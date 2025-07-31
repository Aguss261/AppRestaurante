import { createRouter, createWebHashHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useCartStore } from '../stores/cartStore'

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
  {
    path: '',
    redirect: { name: 'Menu' } // Redirige ruta vacía
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: { name: 'Menu' } // Redirige rutas desconocidas
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

// Lee el mesa_id una sola vez al iniciar
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
