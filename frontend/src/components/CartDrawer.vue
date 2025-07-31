<script setup lang="ts">
import { useCart } from '@/composables/useCart'
import { XMarkIcon, PlusIcon, MinusIcon } from '@heroicons/vue/24/outline'

const { 
  items, 
  total, 
  isEmpty, 
  removeFromCart, 
  updateQuantity 
} = useCart()

const emit = defineEmits(['close', 'checkout'])

const handleCheckout = () => {
  emit('checkout')
}
</script>

<template>
  <div class="fixed inset-0 z-50 overflow-hidden">
    <div class="absolute inset-0 overflow-hidden">
      <!-- Overlay -->
      <div 
        class="absolute inset-0 bg-black/40 transition-opacity"
        @click="$emit('close')"
      >
      </div>

      <!-- Drawer -->
      <div class="fixed inset-y-0 right-0 flex max-w-full pl-10">
        <div class="w-screen max-w-md">
          <div class="flex h-full flex-col bg-white shadow-xl">
            <div class="flex-1 overflow-y-auto py-6 px-4 sm:px-6">
              <div class="flex items-start justify-between">
                <h2 class="text-lg font-medium text-gray-900">Tu pedido</h2>
                <button
                  type="button"
                  class="-m-2 p-2 text-gray-400 hover:text-gray-500"
                  @click="$emit('close')"
                >
                  <XMarkIcon class="h-6 w-6" />
                </button>
              </div>

              <div v-if="isEmpty" class="mt-12 text-center">
                <p class="text-gray-500">Tu carrito está vacío</p>
              </div>

              <div v-else class="mt-8">
                <div class="flow-root">
                  <ul class="-my-6 divide-y divide-gray-200">
                    <li v-for="item in items" :key="item.id" class="flex py-6">
                      <div class="ml-4 flex flex-1 flex-col">
                        <div>
                          <div class="flex justify-between text-base font-medium text-gray-900">
                            <h3>{{ item.name }}</h3>
                            <p class="ml-4">${{ (item.price * item.quantity).toFixed(2) }}</p>
                          </div>
                        </div>
                        <div class="flex flex-1 items-end justify-between text-sm">
                          <div class="flex items-center space-x-2">
                            <button 
                              @click="updateQuantity(item.id, -1)"
                              class="text-gray-500 hover:text-gray-700"
                              :disabled="item.quantity <= 1"
                            >
                              <MinusIcon class="h-4 w-4" />
                            </button>
                            <span class="w-6 text-center">{{ item.quantity }}</span>
                            <button 
                              @click="updateQuantity(item.id, 1)"
                              class="text-gray-500 hover:text-gray-700"
                            >
                              <PlusIcon class="h-4 w-4" />
                            </button>
                          </div>
                          <button 
                            @click="removeFromCart(item.id)"
                            class="font-medium text-amber-600 hover:text-amber-500"
                          >
                            Eliminar
                          </button>
                        </div>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
            </div>

            <div v-if="!isEmpty" class="border-t border-gray-200 py-6 px-4 sm:px-6">
              <div class="flex justify-between text-base font-medium text-gray-900">
                <p>Total</p>
                <p>${{ total.toFixed(2) }}</p>
              </div>
              <div class="mt-6">
                <button
                  @click="handleCheckout"
                  class="flex w-full justify-center items-center px-6 py-3 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-amber-600 hover:bg-amber-700"
                >
                  Confirmar pedido
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
