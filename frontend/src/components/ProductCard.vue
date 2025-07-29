<script setup lang="ts">
import { ref } from 'vue'
import { useCart } from '@/composables/useCart'

const props = defineProps<{
  product: {
    id: number
    name: string
    description: string
    price: number
    image: string
    category: string
  }
}>()

const { addToCart, updateQuantity, items } = useCart()
const quantity = ref(0)

const addToCartHandler = () => {
  if (quantity.value === 0) {
    addToCart({
      id: props.product.id,
      name: props.product.name,
      price: props.product.price,
    })
  } else {
    updateQuantity(props.product.id, 1)
  }
  quantity.value++
}
</script>

<template>
  <div class="bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:scale-105">
    <img 
      :src="product.image || 'https://via.placeholder.com/300x200?text=No+Image'" 
      :alt="product.name"
      class="w-full h-40 object-cover"
    >
    <div class="p-4">
      <div class="flex justify-between items-start">
        <h3 class="text-lg font-semibold text-gray-800">{{ product.name }}</h3>
        <span class="text-lg font-bold text-amber-600">${{ product.price.toFixed(2) }}</span>
      </div>
      <p class="mt-2 text-gray-600 text-sm">{{ product.description }}</p>
      <div class="mt-4 flex items-center justify-between">
        <button
          @click="addToCartHandler"
          class="bg-amber-500 hover:bg-amber-600 text-white px-4 py-2 rounded-lg font-medium transition-colors"
        >
          {{ quantity > 0 ? `Agregar otro (${quantity})` : 'Agregar' }}
        </button>
      </div>
    </div>
  </div>
</template>
