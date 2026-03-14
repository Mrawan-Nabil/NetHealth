<script setup>
import { ref, onMounted } from 'vue'

const stats = [
  {
    number: '50K+',
    label: 'Active Patients',
    description: 'Trust our platform daily',
    icon: 'users'
  },
  {
    number: '1.2K+',
    label: 'Healthcare Providers',
    description: 'Verified professionals',
    icon: 'shield'
  },
  {
    number: '99.9%',
    label: 'Uptime',
    description: 'Reliable service',
    icon: 'clock'
  },
  {
    number: '24/7',
    label: 'Support',
    description: 'Always here to help',
    icon: 'support'
  }
]

const isVisible = ref(false)

onMounted(() => {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          isVisible.value = true
        }
      })
    },
    { threshold: 0.3 }
  )

  const section = document.querySelector('#stats-section')
  if (section) {
    observer.observe(section)
  }
})
</script>

<template>
  <section id="stats-section" class="py-16 sm:py-20 lg:py-24 relative overflow-hidden">
    <!-- Background decoration -->
    <div class="absolute inset-0 bg-gradient-to-br from-teal-50/50 to-cyan-50/50 dark:from-teal-950/20 dark:to-cyan-950/20"></div>
    <div class="absolute top-0 left-1/4 w-72 h-72 bg-teal-200/20 dark:bg-teal-400/10 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-1/4 w-96 h-96 bg-cyan-200/20 dark:bg-cyan-400/10 rounded-full blur-3xl"></div>

    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative">
      <div class="text-center mb-16">
        <h2 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-gray-50 sm:text-4xl mb-4">
          Trusted by <span class="gradient-text">Healthcare Leaders</span>
        </h2>
        <p class="text-lg text-gray-700 dark:text-black-200 max-w-2xl mx-auto leading-relaxed">
          Join thousands of patients and providers who rely on our platform for secure, efficient healthcare management.
        </p>
      </div>

      <div class="grid grid-cols-2 gap-6 lg:grid-cols-4 lg:gap-8">
        <div
          v-for="(stat, index) in stats"
          :key="stat.label"
          :class="[
            'premium-card glass-card rounded-2xl p-6 text-center transition-all duration-500',
            `stagger-${index + 1}`,
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <!-- Icon -->
          <div class="mb-4 flex justify-center">
            <div class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-teal-500 to-cyan-500 text-white shadow-lg">
              <!-- Users icon -->
              <svg v-if="stat.icon === 'users'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
              <!-- Shield icon -->
              <svg v-else-if="stat.icon === 'shield'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
              <!-- Clock icon -->
              <svg v-else-if="stat.icon === 'clock'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <!-- Support icon -->
              <svg v-else-if="stat.icon === 'support'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364M12 2.25a9.75 9.75 0 109.75 9.75c0-5.385-4.365-9.75-9.75-9.75z" />
              </svg>
            </div>
          </div>

          <!-- Number -->
          <div class="mb-2">
            <span class="text-3xl font-bold text-gray-900 dark:text-gray-800 lg:text-4xl">
              {{ stat.number }}
            </span>
          </div>

          <!-- Label -->
          <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-800 mb-1">
            {{ stat.label }}
          </h3>

          <!-- Description -->
          <p class="text-sm text-gray-600 dark:text-gray-800 leading-relaxed">
            {{ stat.description }}
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Additional animations for stats */
.premium-card {
  transform: translateY(15px);
  opacity: 0;
}

.premium-card.revealed {
  transform: translateY(0);
  opacity: 1;
}

/* Hover effect for stats cards */
.premium-card:hover {
  transform: translateY(-3px) scale(1.01);
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* Gradient background animation */
@keyframes gradientShift {
  0%, 100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

.premium-card:hover .bg-gradient-to-br {
  animation: gradientShift 3s ease infinite;
  background-size: 200% 200%;
}
</style>