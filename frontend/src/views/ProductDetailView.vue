<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useProducts } from '@/composables/useProducts'
import { useCart } from '@/composables/useCart'

const route = useRoute()
const router = useRouter()
const { products } = useProducts()
const { addToCart, items, updateQuantity } = useCart()

const productId = computed(() => parseInt(route.params.id as string))

const product = computed(() => {
  return products.value.find(p => p.id === productId.value)
})

const quantity = computed(() => {
  const cartItem = items.value.find(item => item.id === productId.value)
  return cartItem ? cartItem.quantity : 0
})

const selectedImage = ref(0)
const productImages = computed(() => {
  if (!product.value?.foto) return []
  // For now, we'll use the same image multiple times as placeholder
  // In a real app, you'd have multiple product images
  return [
    product.value.foto,
    product.value.foto,
    product.value.foto
  ]
})

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('es-CL', {
    style: 'currency',
    currency: 'CLP',
    minimumFractionDigits: 0
  }).format(price)
}

const addToCartHandler = () => {
  if (!product.value) return
  
  addToCart({
    id: product.value.id,
    name: product.value.nombre,
    price: product.value.precio
  })
}

const increaseQuantity = () => {
  if (!product.value) return
  updateQuantity(product.value.id, 1)
}

const decreaseQuantity = () => {
  if (!product.value) return
  updateQuantity(product.value.id, -1)
}

const goBack = () => {
  router.push('/')
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src =
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&h=400&fit=crop&crop=center&auto=format&q=80'
}

// Redirect if product not found
onMounted(() => {
  if (products.value.length > 0 && !product.value) {
    router.push('/')
  }
})
</script>

<template>
  <div class="product-detail-view">
    <!-- Loading state while products are loading -->
    <div v-if="!product && products.length === 0" class="loading-container">
      <div class="loading-spinner"></div>
      <p>Cargando producto...</p>
    </div>

    <!-- Product not found -->
    <div v-else-if="!product" class="not-found-container">
      <div class="not-found-icon">😕</div>
      <h2>Producto no encontrado</h2>
      <p>El producto que buscas no existe o ha sido eliminado.</p>
      <button @click="goBack" class="back-button">
        ← Volver al menú
      </button>
    </div>

    <!-- Product details -->
    <div v-else class="product-container">
      <!-- Header with back button -->
      <div class="header">
        <button @click="goBack" class="back-btn">
          <span class="back-icon">←</span>
          Volver
        </button>
      </div>

      <!-- Product content -->
      <div class="product-content">
        <!-- Image gallery -->
        <div class="image-section">
          <div class="main-image">
            <img 
              :src="productImages[selectedImage]" 
              :alt="product.nombre"
              @error="handleImageError"
              class="product-image"
            />
            <div class="category-badge">
              <span v-if="product.categoria?.toLowerCase() === 'comida'">🍔</span>
              <span v-else>🥤</span>
              {{ product.categoria }}
            </div>
          </div>
          
          <!-- Image thumbnails (if multiple images) -->
          <div v-if="productImages.length > 1" class="image-thumbnails">
            <button
              v-for="(image, index) in productImages"
              :key="index"
              @click="selectedImage = index"
              :class="['thumbnail', { active: selectedImage === index }]"
            >
              <img :src="image" :alt="`${product.nombre} ${index + 1}`" @error="handleImageError" />
            </button>
          </div>
        </div>

        <!-- Product info -->
        <div class="info-section">
          <div class="product-header">
            <h1 class="product-title">{{ product.nombre }}</h1>
            <div class="product-price">{{ formatPrice(product.precio) }}</div>
          </div>

          <div class="product-description">
            <h3>Descripción</h3>
            <p>{{ product.descripcion }}</p>
          </div>

          <!-- Additional product details -->
          <div class="product-details">
            <div class="detail-item">
              <span class="detail-label">Categoría:</span>
              <span class="detail-value">{{ product.categoria }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">Precio unitario:</span>
              <span class="detail-value">{{ formatPrice(product.precio) }}</span>
            </div>
          </div>

          <!-- Quantity controls and add to cart -->
          <div class="cart-section">
            <div v-if="quantity === 0" class="add-to-cart-container">
              <button @click="addToCartHandler" class="add-to-cart-btn">
                <span class="cart-icon">🛒</span>
                Agregar al carrito
              </button>
            </div>
            
            <div v-else class="quantity-section">
              <div class="quantity-controls">
                <button 
                  @click="decreaseQuantity"
                  class="quantity-btn decrease"
                  :disabled="quantity <= 1"
                >
                  −
                </button>
                <span class="quantity-display">{{ quantity }}</span>
                <button 
                  @click="increaseQuantity"
                  class="quantity-btn increase"
                >
                  +
                </button>
              </div>
              
              <div class="total-price">
                Total: {{ formatPrice(product.precio * quantity) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.product-detail-view {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
}

.loading-container, .not-found-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 20px;
  text-align: center;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.not-found-icon {
  font-size: 4rem;
  margin-bottom: 20px;
}

.not-found-container h2 {
  color: #2c3e50;
  margin: 0 0 12px 0;
}

.not-found-container p {
  color: #7f8c8d;
  margin: 0 0 24px 0;
}

.back-button {
  background: #3498db;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 12px 24px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-button:hover {
  background: #2980b9;
  transform: translateY(-1px);
}

.product-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.header {
  margin-bottom: 30px;
}

.back-btn {
  background: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 12px;
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.back-btn:hover {
  background: white;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.back-icon {
  font-size: 18px;
}

.product-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
  background: white;
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.image-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.main-image {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  background: #f8f9fa;
}

.product-image {
  width: 100%;
  height: 400px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.product-image:hover {
  transform: scale(1.02);
}

.category-badge {
  position: absolute;
  top: 16px;
  left: 16px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  display: flex;
  align-items: center;
  gap: 6px;
}

.image-thumbnails {
  display: flex;
  gap: 12px;
}

.thumbnail {
  border: none;
  border-radius: 8px;
  overflow: hidden;
  width: 80px;
  height: 80px;
  cursor: pointer;
  transition: all 0.2s ease;
  opacity: 0.7;
}

.thumbnail.active {
  opacity: 1;
  box-shadow: 0 0 0 3px #ff6b35;
}

.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info-section {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.product-header {
  border-bottom: 1px solid #e5e7eb;
  padding-bottom: 20px;
}

.product-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #1f2937;
  margin: 0 0 12px 0;
  line-height: 1.2;
}

.product-price {
  font-size: 2rem;
  font-weight: 700;
  color: #e74c3c;
}

.product-description h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #374151;
  margin: 0 0 12px 0;
}

.product-description p {
  font-size: 1.1rem;
  line-height: 1.6;
  color: #6b7280;
  margin: 0;
}

.product-details {
  background: #f9fafb;
  border-radius: 12px;
  padding: 20px;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #e5e7eb;
}

.detail-item:last-child {
  border-bottom: none;
}

.detail-label {
  font-weight: 600;
  color: #374151;
}

.detail-value {
  color: #6b7280;
  font-weight: 500;
}

.cart-section {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border-radius: 16px;
  padding: 24px;
  border: 2px solid #e5e7eb;
}

.add-to-cart-container {
  text-align: center;
}

.add-to-cart-btn {
  background: linear-gradient(135deg, #ff6b35 0%, #e55a2b 100%);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 16px 32px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
  width: 100%;
}

.add-to-cart-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(255, 107, 53, 0.4);
}

.cart-icon {
  font-size: 1.2rem;
}

.quantity-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
  align-items: center;
}

.quantity-controls {
  display: flex;
  align-items: center;
  background: white;
  border-radius: 12px;
  padding: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.quantity-btn {
  background: #f3f4f6;
  border: none;
  border-radius: 8px;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 18px;
  font-weight: 600;
  transition: all 0.2s ease;
}

.quantity-btn:hover:not(:disabled) {
  background: #e5e7eb;
  transform: scale(1.05);
}

.quantity-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.quantity-btn.decrease {
  color: #ef4444;
}

.quantity-btn.increase {
  color: #10b981;
}

.quantity-display {
  min-width: 60px;
  text-align: center;
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  padding: 0 16px;
}

.total-price {
  font-size: 1.3rem;
  font-weight: 700;
  color: #e74c3c;
  text-align: center;
  padding: 12px 24px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

@media (max-width: 768px) {
  .product-container {
    padding: 16px;
  }
  
  .product-content {
    grid-template-columns: 1fr;
    gap: 24px;
    padding: 24px;
  }
  
  .product-title {
    font-size: 2rem;
  }
  
  .product-price {
    font-size: 1.5rem;
  }
  
  .product-image {
    height: 300px;
  }
  
  .back-btn {
    padding: 10px 16px;
    font-size: 14px;
  }
}
</style>
