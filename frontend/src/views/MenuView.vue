<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useProducts } from '@/composables/useProducts'
import { useCart } from '@/composables/useCart'
import { useOrder } from '@/composables/useOrder'
import { useRouter } from 'vue-router'
import ProductCard from '@/components/ProductCard.vue'
import CartDrawer from '@/components/CartDrawer.vue'
import Toast from '@/components/Toast.vue'

const { products, loading, error } = useProducts()
const { itemCount } = useCart()
const { createOrder, loading: _, error: orderError } = useOrder()
const router = useRouter()

const showCart = ref(false)
const showToast = ref(false)
const toastMessage = ref('')
const toastType = ref<'success' | 'error'>('success')

const filteredProducts = computed(() => products.value)

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
  <div class="min-h-screen bg-gradient-to-br from-slate-50 to-gray-100">
    <!-- Hero Section -->
    <div class="bg-gradient-to-r from-orange-600 via-red-600 to-pink-600 text-white">
      <div class="max-w-7xl mx-auto px-4 py-12 sm:px-6 lg:px-8">
        <div class="text-center">
          <h1 class="text-4xl md:text-6xl font-bold mb-4">
            <span class="bg-gradient-to-r from-yellow-300 to-orange-300 bg-clip-text text-transparent">
              Delicioso
            </span>
            <br>
            Menú Gourmet
          </h1>
          <p class="text-xl md:text-2xl text-orange-100 max-w-3xl mx-auto">
            Descubre sabores únicos preparados con ingredientes frescos y amor
          </p>
        </div>
      </div>
    </div>

    <!-- Navigation Bar -->
    <nav class="bg-white/80 backdrop-blur-md shadow-lg sticky top-0 z-40 border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 py-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
          <div class="flex items-center space-x-4">
            <div class="bg-gradient-to-r from-orange-500 to-red-500 p-2 rounded-lg">
              <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
              </svg>
            </div>
            <h2 class="text-xl font-bold text-gray-800">Nuestro Menú</h2>
          </div>
          
          <button 
            @click="showCart = true"
            class="relative bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white px-6 py-3 rounded-full font-medium transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
          >
            <div class="flex items-center space-x-2">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              <span>Mi Pedido</span>
            </div>
            <span v-if="itemCount > 0"
              class="absolute -top-2 -right-2 bg-yellow-400 text-orange-900 text-xs font-bold rounded-full h-6 w-6 flex items-center justify-center animate-pulse">
              {{ itemCount }}
            </span>
          </button>
        </div>
      </div>
    </nav>

    <main class="max-w-7xl mx-auto px-4 py-8 sm:px-6 lg:px-8">
      <!-- Loading -->
      <div v-if="loading" class="space-y-8">
        <div class="text-center">
          <div class="inline-flex items-center px-6 py-3 bg-white/80 backdrop-blur-sm rounded-full shadow-lg">
            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-orange-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <span class="text-gray-700 font-medium">Cargando deliciosos platos...</span>
          </div>
        </div>
        <div class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
          <div v-for="i in 6" :key="i" class="bg-white/60 backdrop-blur-sm rounded-2xl shadow-xl overflow-hidden animate-pulse">
            <div class="h-48 bg-gradient-to-r from-gray-200 to-gray-300"></div>
            <div class="p-6">
              <div class="h-6 bg-gray-200 rounded-lg w-3/4 mb-3"></div>
              <div class="h-4 bg-gray-200 rounded w-1/2 mb-4"></div>
              <div class="h-12 bg-gray-200 rounded-lg w-full"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Error -->
      <div v-else-if="error" class="text-center py-16">
        <div class="bg-white/80 backdrop-blur-sm rounded-2xl shadow-xl p-8 max-w-md mx-auto">
          <div class="bg-red-100 p-4 rounded-full w-16 h-16 mx-auto mb-4 flex items-center justify-center">
            <svg class="h-8 w-8 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-800 mb-2">¡Oops! Algo salió mal</h3>
          <p class="text-gray-600 mb-6">{{ error }}</p>
          <button @click="$router.go(-1)"
            class="bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white px-6 py-3 rounded-full font-medium transition-all duration-300 transform hover:scale-105 shadow-lg">
            Reintentar
          </button>
        </div>
      </div>

      <!-- Productos -->
      <div v-else-if="filteredProducts.length > 0" class="space-y-8">
        <div class="text-center">
          <h3 class="text-2xl font-bold text-gray-800 mb-2">Nuestras Especialidades</h3>
          <p class="text-gray-600">Cada plato preparado con ingredientes frescos y mucho amor</p>
        </div>
        <div class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
          <ProductCard v-for="product in filteredProducts" :key="product.id" :product="product" />
        </div>
      </div>

      <!-- Nada cargado -->
      <div v-else class="text-center py-16">
        <div class="bg-white/80 backdrop-blur-sm rounded-2xl shadow-xl p-8 max-w-md mx-auto">
          <div class="bg-gray-100 p-4 rounded-full w-16 h-16 mx-auto mb-4 flex items-center justify-center">
            <svg class="h-8 w-8 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-800 mb-2">Menú en preparación</h3>
          <p class="text-gray-600">Estamos preparando deliciosos platos para ti. ¡Vuelve pronto!</p>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-md border-t border-gray-200/50 shadow-2xl">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div class="flex justify-between items-center">
          <div class="flex items-center space-x-4">
            <div class="bg-gradient-to-r from-orange-100 to-red-100 p-3 rounded-full">
              <svg class="h-6 w-6 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
              </svg>
            </div>
            <div>
              <p class="text-sm font-medium text-gray-600">Tu pedido</p>
              <p class="text-xl font-bold bg-gradient-to-r from-orange-600 to-red-600 bg-clip-text text-transparent">
                {{ itemCount }} {{ itemCount === 1 ? 'producto' : 'productos' }}
              </p>
            </div>
          </div>
          
          <button @click="showCart = true" :disabled="itemCount === 0"
            :class="[
              'px-8 py-4 rounded-full font-bold text-white transition-all duration-300 transform shadow-lg',
              itemCount === 0 
                ? 'bg-gray-300 cursor-not-allowed opacity-50' 
                : 'bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 hover:scale-105 hover:shadow-xl active:scale-95'
            ]">
            <div class="flex items-center space-x-2">
              <span>{{ itemCount === 0 ? 'Agregar productos' : 'Ver mi pedido' }}</span>
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
            </div>
          </button>
        </div>
      </div>
    </footer>

    <!-- Cart -->
    <CartDrawer v-if="showCart" @close="showCart = false" @checkout="handleCheckout" />

    <!-- Toast -->
    <Toast v-if="showToast" :show="showToast" :message="toastMessage" :type="toastType"
      @close="showToast = false" />
  </div>
</template>
