<script setup lang="ts">
import { computed, ref } from 'vue'
import { useProducts } from '@/composables/useProducts'
import { useCart } from '@/composables/useCart'
import ProductCard from '@/components/ProductCard.vue'
import CartDrawer from '@/components/CartDrawer.vue'

const { products, loading, error } = useProducts()
const { itemCount } = useCart()

const showCart = ref(false)

// Group products by category
const productsByCategory = computed(() => {
  const grouped: Record<string, any[]> = {
    comida: [],
    bebida: []
  }
  
  for (const product of products.value || []) {
    const category = product.categoria?.toLowerCase()
    if (category === 'comida' || category === 'comidas') {
      grouped.comida.push(product)
    } else if (category === 'bebida' || category === 'bebidas') {
      grouped.bebida.push(product)
    }
  }
  
  return grouped
})

const categories = [
  { key: 'comida', title: 'Comidas', icon: '🍔' },
  { key: 'bebida', title: 'Bebidas', icon: '🥤' }
]
</script>

<template>
  <div class="menu-view">
    <!-- Header -->
    <div class="menu-header">
      <h1 class="menu-title">Nuestro Menú</h1>
      <p class="menu-subtitle">Descubre nuestros deliciosos platos y bebidas</p>
      
      <!-- Cart Button -->
      <button 
        @click="showCart = true" 
        class="cart-button"
        v-if="itemCount > 0"
      >
        🛒 Carrito ({{ itemCount }})
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Cargando productos...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="error-state">
      <div class="error-icon">⚠️</div>
      <h3>Error al cargar productos</h3>
      <p>{{ error }}</p>
    </div>

    <!-- Products by Category -->
    <div v-else class="menu-content">
      <div 
        v-for="category in categories" 
        :key="category.key"
        class="category-section"
        v-show="productsByCategory[category.key].length > 0"
      >
        <div class="category-header">
          <span class="category-icon">{{ category.icon }}</span>
          <h2 class="category-title">{{ category.title }}</h2>
          <div class="category-count">
            {{ productsByCategory[category.key].length }} productos
          </div>
        </div>
        
        <div class="products-grid">
          <ProductCard 
            v-for="product in productsByCategory[category.key]"
            :key="product.id"
            :product="product"
          />
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="!loading && !error && products.length === 0" class="empty-state">
        <div class="empty-icon">🍽️</div>
        <h3>No hay productos disponibles</h3>
        <p>Vuelve más tarde para ver nuestro menú</p>
      </div>
    </div>

    <!-- Cart Drawer -->
    <CartDrawer v-model:show="showCart" />
  </div>
</template>

<style scoped>
.menu-view {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 20px;
}

.menu-header {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
}

.menu-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin: 0 0 8px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.menu-subtitle {
  font-size: 1.1rem;
  color: #7f8c8d;
  margin: 0 0 30px 0;
}

.cart-button {
  position: fixed;
  top: 20px;
  right: 20px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 25px;
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
  transition: all 0.3s ease;
  z-index: 100;
}

.cart-button:hover {
  background: #c0392b;
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(231, 76, 60, 0.4);
}

.loading-state, .error-state, .empty-state {
  text-align: center;
  padding: 60px 20px;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-icon, .empty-icon {
  font-size: 3rem;
  margin-bottom: 16px;
}

.error-state h3, .empty-state h3 {
  color: #2c3e50;
  margin: 0 0 8px 0;
}

.error-state p, .empty-state p {
  color: #7f8c8d;
  margin: 0;
}

.menu-content {
  max-width: 1200px;
  margin: 0 auto;
}

.category-section {
  margin-bottom: 50px;
}

.category-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 24px;
  padding: 0 8px;
}

.category-icon {
  font-size: 2rem;
}

.category-title {
  font-size: 1.8rem;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
  flex: 1;
}

.category-count {
  background: #ecf0f1;
  color: #7f8c8d;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.9rem;
  font-weight: 500;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
  padding: 0 8px;
}

@media (max-width: 768px) {
  .menu-view {
    padding: 16px;
  }
  
  .menu-title {
    font-size: 2rem;
  }
  
  .products-grid {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 16px;
  }
  
  .cart-button {
    position: fixed;
    bottom: 20px;
    right: 20px;
    top: auto;
  }
}
</style>

