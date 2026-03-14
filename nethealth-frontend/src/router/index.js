import { createRouter, createWebHistory } from 'vue-router'
import AuthLayout from '../layouts/AuthLayout.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    
      { path: '/', 
        name: 'Home',
        component: () => import('../views/Home.vue')},
      
      { path: '/dashboard', 
        name: 'Dashboard',
        component: () => import('../views/DashboardInteractive.vue')},
      
      { path: '/profile', 
        name: 'Profile',
        component: () => import('../views/Profile.vue')},
      
      { path: '/medical-records', 
        name: 'MedicalRecords',
        component: () => import('../views/MedicalRecords.vue')},
      
      { path: '/test-results', 
        name: 'TestResults',
        component: () => import('../views/TestResults.vue')},
      
      { path: '/imaging', 
        name: 'ImagingRecords',
        component: () => import('../views/ImagingRecords.vue')},
      
      { path: '/imaging/:id', 
        name: 'ImagingDetail',
        component: () => import('../views/ImagingDetail.vue')},
      
      { path: '/visit-history', 
        name: 'VisitHistory',
        component: () => import('../views/VisitHistory.vue')},
      
      { path: '/prescription/:id', 
        name: 'PrescriptionDetails',
        component: () => import('../views/PrescriptionDetails.vue')},
      
      { path: '/test-results/:id', 
        name: 'TestResultDetails',
        component: () => import('../views/TestResultDetails.vue')},
      
      { path: '/appointments', 
        name: 'Appointments',
        component: () => import('../views/Appointments.vue')},
      
      { path: '/appointments/create', 
        name: 'CreateAppointment',
        component: () => import('../views/CreateAppointment.vue')},
      
      { path: '/doctor/:id', 
        name: 'DoctorProfile',
        component: () => import('../views/DoctorProfile.vue')},
      
      { path: '/notifications', 
        name: 'Notifications',
        component: () => import('../views/Notifications.vue')},

      // Register route - standalone without AuthLayout
      {
        path: '/register',
        name: 'Register',
        component: () => import('../views/Register.vue'),
      },
      
      // Legacy register routes - redirect to new unified register
      {
        path: '/register/patient',
        redirect: '/register'
      },
      {
        path: '/register/doctor',
        redirect: '/register'
      },
      {
        path: '/register/clinic',
        redirect: '/register'
      },
      {
        path: '/register/pharmacy',
        redirect: '/register'
      },

      // Auth routes with AuthLayout
      {
        path: '/auth',
        component: AuthLayout,
        children: [
          { 
            path: '/login',
            name: 'Login',
            component: () => import('../views/Login.vue') 
          }
        ]
      }
  ],
  scrollBehavior(to, from, savedPosition) {
    return { top: 0 }
  }
})

export default router

