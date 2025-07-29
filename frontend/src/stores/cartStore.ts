import { defineStore } from 'pinia'

export interface CartItem {
  id: number
  name: string
  price: number
  quantity: number
}

interface State {
  mesaId: number | null
  items: CartItem[]
}

export const useCartStore = defineStore('cart', {
  state: (): State => ({
    mesaId: null,
    items: [],
  }),
  getters: {
    total: (state) =>
      state.items.reduce((acc, item) => acc + item.price * item.quantity, 0),
    isEmpty: (state) => state.items.length === 0,
  },
  actions: {
    setMesaId(id: number) {
      if (!this.mesaId) this.mesaId = id
    },
    addItem(item: Omit<CartItem, 'quantity'>) {
      const existing = this.items.find((i) => i.id === item.id)
      if (existing) existing.quantity += 1
      else this.items.push({ ...item, quantity: 1 })
    },
    removeItem(id: number) {
      this.items = this.items.filter((i) => i.id !== id)
    },
    clear() {
      this.items = []
    },
  },
})
