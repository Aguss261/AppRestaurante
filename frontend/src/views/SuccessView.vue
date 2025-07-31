<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCart } from '@/composables/useCart'
import { CheckCircleIcon } from '@heroicons/vue/24/outline'

const router = useRouter()
const { clearCart } = useCart()

// Clear cart when success page is loaded
onMounted(() => {
  clearCart()

  setTimeout(() => {
    router.push({ name: 'Menu' })  // ✅ redirige a la vista de menú
  }, 5000)
})
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center px-4">
    <div class="max-w-md w-full text-center bg-white p-8 rounded-lg shadow-md">
      <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-green-100">
        <CheckCircleIcon class="h-10 w-10 text-green-600" />
      </div>
      <h2 class="mt-4 text-2xl font-bold text-gray-900">¡Pedido Confirmado!</h2>
      <p class="mt-2 text-gray-600">
        Tu pedido ha sido recibido y está siendo preparado. 
        Serás redirigido al menú en unos segundos...
      </p>
      <div class="mt-6">
        <button
          @click="router.push({ name: 'Menu' })"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-amber-600 hover:bg-amber-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-amber-500"
        >
          Volver al menú
        </button>
      </div>
    </div>
  </div>
</template>
