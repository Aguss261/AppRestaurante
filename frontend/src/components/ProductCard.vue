<script setup lang="ts">
import { ref } from 'vue'
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

const { addToCart, updateQuantity } = useCart()
const quantity = ref(0)

const addToCartHandler = () => {
  if (quantity.value === 0) {
    addToCart({
      id: props.product.id,
      name: props.product.nombre,
      price: props.product.precio,
    })
  } else {
    updateQuantity(props.product.id, 1)
  }
  quantity.value++
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop&crop=center&auto=format&q=80'
}
</script>

<template>
  <div class="group bg-white/90 backdrop-blur-sm rounded-xl shadow-lg hover:shadow-xl transition-all duration-400 overflow-hidden transform hover:-translate-y-1 hover:scale-[1.01] border border-neutral-200 max-w-xs mx-auto my-4 flex flex-col justify-between min-h-[340px]">
    <!-- Image Container -->
    <div class="relative overflow-hidden flex items-center justify-center" style="height:180px;">
      <img 
        :src="product.foto || '/api/placeholder/400/300'" 
        :alt="product.nombre" 
        class="max-h-36 w-auto object-contain mx-auto transition-transform duration-700 group-hover:scale-105 rounded-xl shadow-md bg-white"
        style="max-width: 90%; max-height: 140px; min-height: 80px;"
        @error="handleImageError"
      />
      <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
      
      <!-- Category Badge -->
      <div class="absolute top-4 left-4">
        <span class="bg-white/90 backdrop-blur-sm text-gray-800 px-3 py-1 rounded-full text-xs font-semibold shadow-lg">
          {{ product.categoria || 'Especialidad' }}
        </span>
      </div>
      
      <!-- Price Badge -->
      <div class="absolute top-4 right-4">
        <div class="bg-gradient-to-r from-orange-500 to-red-500 text-white px-4 py-2 rounded-full shadow-lg">
          <span class="text-lg font-bold">${{ product.precio.toFixed(2) }}</span>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="px-4 py-3 flex-1 flex flex-col justify-between">
      <div class="mb-2">
        <h3 class="text-base font-semibold text-gray-800 mb-1 line-clamp-2 group-hover:text-orange-600 transition-colors duration-300">
          {{ product.nombre }}
        </h3>
        <p class="text-gray-600 text-xs line-clamp-3 leading-snug">
          {{ product.descripcion || 'Delicioso plato preparado con ingredientes frescos y de la más alta calidad.' }}
        </p>
      </div>
      <!-- Action Button -->
      <button 
        @click="addToCartHandler" 
        class="w-full bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white font-bold py-2 px-3 rounded-lg transition-all duration-300 transform hover:scale-105 active:scale-95 shadow-md hover:shadow-lg group-hover:shadow-orange-500/25 text-sm mt-2"
      >
        <div class="flex items-center justify-center space-x-2">
          <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          <span>
            {{ quantity === 0 ? 'Agregar al pedido' : `Agregar otro (${quantity})` }}
          </span>
        </div>
      </button>
    </div>

    <!-- Quantity Indicator -->
    <div v-if="quantity > 0" class="absolute -top-2 -right-2 z-10">
      <div class="bg-yellow-400 text-orange-900 rounded-full w-8 h-8 flex items-center justify-center font-bold text-sm shadow-lg animate-bounce">
        {{ quantity }}
      </div>
    </div>
  </div>
</template>
