<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useCart } from '@/composables/useCart'

const props = defineProps<{
  product: {
    id: number
    nombre: string
    descripcion: string
    precio: number
    foto: string
    categoria: string
  }
}>()

const router = useRouter()
const { items } = useCart()

// Get the actual quantity from the cart
const quantity = computed(() => {
  const cartItem = items.value.find(item => item.id === props.product.id)
  return cartItem ? cartItem.quantity : 0
})

const goToProductDetail = () => {
  router.push(`/product/${props.product.id}`)
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src =
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop&crop=center&auto=format&q=80'
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('es-CL', {
    style: 'currency',
    currency: 'CLP',
    minimumFractionDigits: 0
  }).format(price)
}
</script>

<template>
  <div class="product-card" @click="goToProductDetail">
    <div class="product-image-container">
      <img 
        :src="product.foto" 
        :alt="product.nombre"
        class="product-image"
        @error="handleImageError"
      />
      <div class="product-badge">
        <span class="badge-icon">
          <span v-if="product.categoria?.toLowerCase() === 'comida'">🍔</span>
          <span v-else>🥤</span>
        </span>
      </div>
      
      <!-- Quantity indicator if item is in cart -->
      <div v-if="quantity > 0" class="quantity-indicator">
        {{ quantity }}
      </div>
    </div>
    
    <div class="product-content">
      <h3 class="product-title">{{ product.nombre }}</h3>
      <p class="product-description">{{ product.descripcion }}</p>
      <div class="product-footer">
        <span class="product-price">{{ formatPrice(product.precio) }}</span>
        <div class="view-details-btn">
          <span v-if="quantity === 0">Ver detalles</span>
          <span v-else class="in-cart">En carrito ({{ quantity }})</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.product-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  cursor: pointer;
  max-width: 280px;
  margin: 0 auto;
}

.product-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.product-image-container {
  position: relative;
  width: 100%;
  height: 180px;
  overflow: hidden;
}

.product-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.product-card:hover .product-image {
  transform: scale(1.05);
}

.product-badge {
  position: absolute;
  top: 12px;
  left: 12px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 8px;
  padding: 6px 8px;
  backdrop-filter: blur(10px);
}

.badge-icon {
  font-size: 16px;
}

.product-content {
  padding: 16px;
}

.product-title {
  font-size: 18px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0 0 8px 0;
  line-height: 1.3;
}

.product-description {
  font-size: 14px;
  color: #666;
  margin: 0 0 16px 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.product-price {
  font-size: 20px;
  font-weight: 700;
  color: #e74c3c;
}

.quantity-indicator {
  position: absolute;
  top: 12px;
  right: 12px;
  background: #e74c3c;
  color: white;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(231, 76, 60, 0.3);
}

.view-details-btn {
  background: #ff6b35;
  color: white;
  border-radius: 8px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.2s ease;
  min-width: 70px;
  text-align: center;
  cursor: pointer;
}

.product-card:hover .view-details-btn {
  background: #e55a2b;
  transform: translateY(-1px);
}

.view-details-btn .in-cart {
  color: #ffffff;
  font-weight: 700;
}

.product-card:hover .view-details-btn .in-cart {
  color: #219a52;
}
</style>

