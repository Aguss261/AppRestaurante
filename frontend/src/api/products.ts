import { http } from './http'

export interface Producto {
  id: number
  nombre: string
  descripcion: string
  precio: number
  foto: string
  categoria: string
}

export const fetchProducts = async (): Promise<Producto[]> => {
  const { data } = await http.get<Producto[]>('/productos')
  return data
}