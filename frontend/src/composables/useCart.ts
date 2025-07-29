import { ref, computed } from 'vue'
import { useCartStore } from '@/stores/cartStore'
import type { CartItem } from '@/stores/cartStore'

const isCartOpen = ref(false)

export const useCart = () => {
  const store = useCartStore()

  const addToCart = (item: Omit<CartItem, 'quantity'>) => {
    store.addItem(item)
  }

  const removeFromCart = (id: number) => {
    store.removeItem(id)
  }

  const clearCart = () => {
    store.clear()
  }

  const updateQuantity = (id: number, change: number) => {
    const item = store.items.find((i: CartItem) => i.id === id)
    if (item) {
      const newQuantity = Math.max(1, item.quantity + change)
      if (newQuantity !== item.quantity) {
        store.items = store.items.map((i: CartItem) => 
          i.id === id ? { ...i, quantity: newQuantity } : i
        )
      }
    }
  }

  return {
    isCartOpen, // ✅ ahora disponible para usar con v-model
    items: computed(() => store.items),
    total: computed(() => store.total),
    isEmpty: computed(() => store.isEmpty),
    addToCart,
    removeFromCart,
    clearCart,
    updateQuantity,
    itemCount: computed(() => 
      store.items.reduce((count: number, item: CartItem) => count + item.quantity, 0)
    ),
  }
}
