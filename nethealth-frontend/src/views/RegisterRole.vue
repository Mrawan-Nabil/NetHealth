<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const roles = [
  {
    id: 'patient',
    title: 'Patient',
    subtitle: 'Book appointments, view records, and manage your health.',
    routeName: 'RegisterPatient',
  },
  {
    id: 'doctor',
    title: 'Doctor',
    subtitle: 'Manage your practice, appointments, and patient care.',
    routeName: 'RegisterDoctor',
  },
  {
    id: 'clinic',
    title: 'Clinic',
    subtitle: 'Register your clinic and manage staff and services.',
    routeName: 'RegisterClinic',
  },
  {
    id: 'pharmacy',
    title: 'Pharmacy',
    subtitle: 'Manage inventory, prescriptions, orders and your staff workflow.',
    routeName: 'RegisterPharmacy',
  },
]

function selectRole(routeName) {
  router.push({ name: routeName })
}
</script>

<template>
  <!-- Glassmorphism Background -->
  <div class="min-h-screen relative overflow-hidden">
    <!-- Vibrant Mesh Gradient Background -->
    <div class="absolute inset-0 bg-gradient-to-br from-purple-600 via-pink-500 to-blue-600"></div>
    <div class="absolute inset-0 bg-gradient-to-tl from-cyan-400 via-purple-500 to-pink-600 opacity-70"></div>
    <div class="absolute inset-0 bg-gradient-to-r from-blue-500 via-purple-600 to-pink-500 opacity-50"></div>
    
    <!-- Animated Background Elements -->
    <div class="absolute top-20 left-20 w-72 h-72 bg-white/10 rounded-full blur-3xl animate-pulse"></div>
    <div class="absolute bottom-20 right-20 w-96 h-96 bg-pink-300/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 1s;"></div>
    <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-80 h-80 bg-blue-300/15 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>

    <div class="relative min-h-screen flex items-center justify-center py-12 px-6 lg:px-8">
      <Transition name="fade-slide" appear>
        <div class="w-full max-w-md">
          <!-- Glassmorphism Container -->
          <div class="glass-container backdrop-blur-[15px] bg-white/10 border border-white/20 rounded-3xl p-8 shadow-2xl shadow-black/20">
            
            <!-- Header -->
            <div class="text-center animate-stagger mb-8">
              <h1 class="text-3xl font-bold text-white mb-2">
                Create an Account
              </h1>
              <p class="text-white/80 text-lg">
                Select your account type to get started
              </p>
            </div>

            <!-- Roles -->
            <ul class="flex flex-col gap-4 animate-stagger" role="list">
              <li v-for="role in roles" :key="role.id">
                <button
                  type="button"
                  class="glass-button flex w-full items-center gap-4 rounded-2xl bg-white/5 backdrop-blur-sm border border-white/20 p-5 text-left
                         transition-all duration-300 hover:bg-white/10 hover:border-white/30 hover:scale-[1.02] hover:shadow-lg hover:shadow-white/10
                         active:scale-95 focus:outline-none focus-visible:ring-2 focus-visible:ring-white/50"
                  @click="selectRole(role.routeName)"
                >
            <!-- Patient -->
            <svg
              v-if="role.id === 'patient'"
              class="h-8 w-8 shrink-0 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>

            <!-- Doctor -->
            <svg
              v-else-if="role.id === 'doctor'"
              class="h-8 w-8 shrink-0 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>

            <!-- Clinic -->
            <svg
              v-else-if="role.id === 'clinic'"
              class="h-8 w-8 shrink-0 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
              />
            </svg>

            <!-- Pharmacy -->
            <svg
              v-else-if="role.id === 'pharmacy'"
              class="h-8 w-8 shrink-0 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="1.5"
                d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"
              />
            </svg>

            <!-- Text -->
            <div class="min-w-0 flex-1">
              <span class="font-bold text-white text-lg">
                {{ role.title }}
              </span>
              <p class="mt-1 text-white/70 text-sm">
                {{ role.subtitle }}
              </p>
            </div>

                </button>
              </li>
            </ul>

          </div>
        </div>
      </Transition>
    </div>
  </div>
</template>

<style scoped>
/* Page entrance animation */
.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(20px);
}
.fade-slide-enter-active {
  transition: all 0.5s ease;
}
.fade-slide-enter-to {
  opacity: 1;
  transform: translateY(0);
}

/* Stagger effect */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(15px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-stagger > * {
  opacity: 0;
  animation: fadeInUp 0.5s ease forwards;
}

.animate-stagger > *:nth-child(1) { animation-delay: 0.1s; }
.animate-stagger > *:nth-child(2) { animation-delay: 0.2s; }
.animate-stagger > *:nth-child(3) { animation-delay: 0.3s; }
.animate-stagger > *:nth-child(4) { animation-delay: 0.4s; }
</style>