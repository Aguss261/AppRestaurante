<script setup lang="ts">
import { ref, computed } from 'vue'
import { useProducts } from '@/composables/useProducts'
import { useCart } from '@/composables/useCart'
import { useOrder } from '@/composables/useOrder'
import { useRouter } from 'vue-router'
import ProductCard from '@/components/ProductCard.vue'
import CartDrawer from '@/components/CartDrawer.vue'
import Toast from '@/components/Toast.vue'
import CategoryTabs from '@/components/CategoryTabs.vue'

const { products, loading, error, categories } = useProducts()
const { itemCount } = useCart()
const { createOrder, loading: isOrderLoading, error: orderError } = useOrder()
const router = useRouter()

const showCart = ref(false)
const showToast = ref(false)
const toastMessage = ref('')
const toastType = ref<'success' | 'error'>('success')

const selectedCategory = ref('')

const filteredProducts = computed(() => {
  if (!selectedCategory.value) return products.value
  return products.value.filter(p => p.category === selectedCategory.value)
})

const handleCheckout = async () => {
  const orderId = await createOrder()
  if (orderId) {
    showToast.value = true
    toastMessage.value = '¡Pedido realizado con éxito!'
    toastType.value = 'success'
    setTimeout(() => {
      router.push({ name: 'Success' })
    }, 2000)
  } else {
    showToast.value = true
    toastMessage.value = orderError.value || 'Error al realizar el pedido'
    toastType.value = 'error'
  }
}
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow">
      <div class="max-w-7xl mx-auto px-4 py-6 sm:px-6 lg:px-8 flex justify-between items-center">
        <h1 class="text-2xl font-bold text-gray-900">Menú</h1>
        <button 
          @click="showCart = true"
          class="relative p-2 text-gray-400 hover:text-gray-500"
        >
          <span class="sr-only">Ver carrito</span>
          <svg 
            class="h-6 w-6" 
            fill="none" 
            viewBox="0 0 24 24" 
            stroke="currentColor"
          >
            <path 
              stroke-linecap="round" 
              stroke-linejoin="round" 
              stroke-width="2" 
              d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" 
            />
          </svg>
          <span 
            v-if="itemCount > 0"
            class="absolute -top-1 -right-1 bg-amber-500 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center"
          >
            {{ itemCount }}
          </span>
        </button>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-6 sm:px-6 lg:px-8">
      <!-- Category Tabs -->
      <div class="mb-6" v-if="categories.length > 0">
        <CategoryTabs 
          v-model="selectedCategory" 
          :categories="categories" 
        />
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <div v-for="i in 6" :key="i" class="bg-white rounded-lg shadow-md overflow-hidden animate-pulse">
          <div class="h-40 bg-gray-200"></div>
          <div class="p-4">
            <div class="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
            <div class="h-3 bg-gray-200 rounded w-1/4 mb-4"></div>
            <div class="h-10 bg-gray-200 rounded w-full"></div>
          </div>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-12">
        <p class="text-red-500">Error al cargar el menú: {{ error }}</p>
        <button 
          @click="$router.go()"
          class="mt-4 px-4 py-2 bg-amber-500 text-white rounded-md hover:bg-amber-600"
        >
          Reintentar
        </button>
      </div>

      <!-- Products Grid -->
      <div v-else class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <ProductCard 
          v-for="product in filteredProducts" 
          :key="product.id" 
          :product="product" 
        />
      </div>
    </main>

    <!-- Fixed Footer -->
    <footer class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 py-3">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
          <div>
            <p class="text-sm text-gray-500">Total en carrito</p>
            <p class="text-lg font-bold text-gray-900">${{ itemCount }} productos</p>
          </div>
          <button
            @click="showCart = true"
            :disabled="itemCount === 0"
            :class="[
              'px-6 py-3 rounded-md font-medium text-white',
              itemCount === 0 
                ? 'bg-gray-300 cursor-not-allowed' 
                : 'bg-amber-500 hover:bg-amber-600'
            ]"
          >
            Ver pedido
          </button>
        </div>
      </div>
    </footer>

    <!-- Cart Drawer -->
    <CartDrawer 
      v-if="showCart" 
      @close="showCart = false"
      @checkout="handleCheckout"
    />

    <!-- Toast Notification -->
    <Toast 
      v-if="showToast"
      :show="showToast"
      :message="toastMessage"
      :type="toastType"
      @close="showToast = false"
    />
  </div>
</template>
