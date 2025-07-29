import { createRouter, createWebHashHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useCartStore } from '../stores/cartStore'

// Lazy-loaded views
const MenuView = () => import('../views/MenuView.vue')
const SuccessView = () => import('../views/SuccessView.vue')

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Menu',
    component: MenuView,
  },
  {
    path: '/success',
    name: 'Success',
    component: SuccessView,
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

// Read mesa_id once and store in Pinia
router.beforeEach((to, _from, next) => {
  const store = useCartStore()
  if (!store.mesaId) {
    const mesaIdParam = (to.query.mesa_id || to.query.mesaId) as string | undefined
    if (mesaIdParam) {
      store.setMesaId(Number(mesaIdParam))
    }
  }
  next()
})

export default router
