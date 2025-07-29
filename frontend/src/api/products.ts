import { http } from './http'

export interface Product {
  id: number
  name: string
  description: string
  price: number
  image: string
  category: string
}

export const fetchProducts = async () => {
  const { data } = await http.get<Product[]>('/productos')
  return data
}
