import { ref } from 'vue'
import { useCartStore } from '@/stores/cartStore'
import { http } from '@/api/http'

interface OrderItem {
  producto_id: number
  cantidad: number
  precio_unitario: number
}

export const useOrder = () => {
  const loading = ref(false)
  const error = ref<string | null>(null)
  const orderId = ref<string | null>(null)
  const cart = useCartStore()

  const createOrder = async () => {
    if (cart.isEmpty) {
      error.value = 'El carrito está vacío'
      return null
    }
    cart.mesaId = 4
    if (!cart.mesaId) {
      error.value = 'No se ha especificado la mesa'
      return null
    }

    loading.value = true
    error.value = null

    try {
      const items: OrderItem[] = cart.items.map(item => ({
        producto_id: item.id,
        cantidad: item.quantity,
        precio_unitario: item.price,
      }))

      const { data } = await http.post<{ id: string }>('/pedidos', {
        mesa_id: cart.mesaId,
        items,
      })

      orderId.value = data.id
      return data.id
    } catch (e) {
      error.value = 'Error al crear el pedido. Por favor, intente nuevamente.'
      console.error('Error creating order:', e)
      return null
    } finally {
      loading.value = false
    }
  }

  const resetOrder = () => {
    orderId.value = null
    error.value = null
  }

  return {
    loading,
    error,
    orderId,
    createOrder,
    resetOrder,
  }
}
