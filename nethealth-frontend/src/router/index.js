import { createRouter, createWebHistory } from 'vue-router'
import AuthLayout from '../layouts/AuthLayout.vue'
import Login from '../views/Login.vue'
import Home from '../views/Home.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    
      { path: '/', 
        name: 'Home',
        component: Home},

      {path: '/auth',
      component: AuthLayout,
      children: [
        { 
          path: '/login',
          name: 'Login',
          component: () => import('../views/Login.vue') },
        {
          path: '/register',
          name: 'RegisterRole',
          component: () => import('../views/RegisterRole.vue'),
        },
        {
          path: '/register/patient',
          name: 'RegisterPatient',
          component: () => import('../views/RegisterPatient.vue'),
        },
        {
          path: '/register/doctor',
          name: 'RegisterDoctor',
          component: () => import('../views/RegisterDoctor.vue'),
        },
        {
          path: '/register/clinic',
          name: 'RegisterClinic',
          component: () => import('../views/RegisterClinic.vue'),
        },
        {
          path: '/register/pharmacy',
          name: 'RegisterPharmacy',
          component: () => import('../views/RegisterPharmacy.vue'),
        },
      ],
      scrollBehavior(to, from, savedPosition) {
        return { top: 0 }
      }
    },
  ],
})

export default router

