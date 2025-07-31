import { ref, onMounted, computed } from 'vue'
import { fetchProducts } from '../api/products'
import type { Producto } from '../api/products'

export const useProducts = () => {
  const products = ref<Producto[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const categories = computed(() => {
    const set = new Set(products.value.map((p) => p.categoria))
    return Array.from(set)
  })
  const load = async () => {
    loading.value = true
    error.value = null
    
    try {
      const result = await fetchProducts()
      products.value = Array.isArray(result) ? result : []
    } catch (e) {
      console.error('Error cargando productos:', e)
      error.value = (e as Error).message || 'Error desconocido'
      products.value = []
    } finally {
      loading.value = false
    }
  }  

  onMounted(load)

  return {
    products,
    loading,
    error,
    categories,
    reload: load,
  }
}
