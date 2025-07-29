import { ref, onMounted, computed } from 'vue'
import { fetchProducts } from '../api/products'
import type { Product } from '../api/products'

export const useProducts = () => {
  const products = ref<Product[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const categories = computed(() => {
    const set = new Set(products.value.map((p) => p.category))
    return Array.from(set)
  })

  const load = async () => {
    loading.value = true
    try {
      products.value = await fetchProducts()
    } catch (e) {
      error.value = (e as Error).message
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
