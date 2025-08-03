<script setup lang="ts">
import { computed } from 'vue'
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

const { addToCart, items } = useCart()

// Get the actual quantity from the cart
const quantity = computed(() => {
  const cartItem = items.value.find(item => item.id === props.product.id)
  return cartItem ? cartItem.quantity : 0
})

const addToCartHandler = () => {
  addToCart({
    id: props.product.id,
    name: props.product.nombre,
    price: props.product.precio
  })
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
  <div class="product-card">
    <div class="product-image-container">
      <img 
        :src="product.foto" 
        :alt="product.nombre"
        class="product-image"
        @error="handleImageError"
      />
      <div class="product-badge">
        <span class="badge-icon">🍔</span>
      </div>
    </div>
    
    <div class="product-content">
      <h3 class="product-title">{{ product.nombre }}</h3>
      <p class="product-description">{{ product.descripcion }}</p>
      <div class="product-footer">
        <span class="product-price">{{ formatPrice(product.precio) }}</span>
        <button 
          @click="addToCartHandler" 
          class="add-to-cart-btn"
          :class="{ 'added': quantity > 0 }"
        >
          <span v-if="quantity === 0">Agregar</span>
          <span v-else>{{ quantity }}</span>
        </button>
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

.add-to-cart-btn {
  background: #ff6b35;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  min-width: 70px;
}

.add-to-cart-btn:hover {
  background: #e55a2b;
  transform: translateY(-1px);
}

.add-to-cart-btn.added {
  background: #27ae60;
}

.add-to-cart-btn.added:hover {
  background: #219a52;
}
</style>

