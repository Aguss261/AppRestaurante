<script setup lang="ts">
import { RouterView } from 'vue-router'
import { useCart } from '@/composables/useCart'
import CartDrawer from '@/components/CartDrawer.vue'
import Toast from '@/components/Toast.vue'

// Ahora sí existe isCartOpen
const { isCartOpen } = useCart()
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Main content -->
    <main class="pb-20">
      <RouterView />
    </main>
    </div>
</template>

<style>
/* Add any global styles here */
</style>
