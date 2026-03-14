<script setup>
import { ref, onMounted } from 'vue'

const features = [
  {
    title: 'Smart Appointment Booking',
    subtitle: 'AI-powered scheduling that finds the perfect time slots. Get instant confirmations and smart reminders.',
    icon: 'calendar',
    gradient: 'from-blue-500 to-cyan-800'
  },
  {
    title: 'Secure Medical Records',
    subtitle: 'Bank-level encryption keeps your health data safe. Access your complete history anytime, anywhere.',
    icon: 'shield',
    gradient: 'from-green-500 to-teal-500'
  },
  {
    title: 'Connect with Experts',
    subtitle: 'Find verified specialists, read reviews, and connect with the right healthcare providers instantly.',
    icon: 'users',
    gradient: 'from-purple-500 to-pink-500'
  },
  {
    title: '24/7 Health Access',
    subtitle: 'Manage prescriptions, view results, and message your care team whenever you need support.',
    icon: 'clock',
    gradient: 'from-orange-500 to-red-500'
  },
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
    { threshold: 0.2 }
  )

  const section = document.querySelector('#features-section')
  if (section) {
    observer.observe(section)
  }
})
</script>


<template>
  <section id="features-section" class="py-16 sm:py-20 lg:py-24 relative overflow-hidden">
    <!-- Background decoration -->
    <div class="absolute inset-0 bg-gradient-to-b from-gray-50/50 to-white dark:from-gray-900/50 dark:to-gray-800"></div>
    <div class="absolute top-0 right-0 w-96 h-96 bg-gradient-to-bl from-teal-100/30 to-cyan-100/30 dark:from-teal-900/20 dark:to-cyan-900/20 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 left-0 w-80 h-80 bg-gradient-to-tr from-blue-100/30 to-purple-100/30 dark:from-blue-900/20 dark:to-purple-900/20 rounded-full blur-3xl"></div>

    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative">
      <!-- Section header -->
      <div 
        :class="[
          'text-center mb-16 transition-all duration-1000',
          isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
        ]"
      >
        <div class="inline-flex items-center gap-2 rounded-full bg-teal-50 dark:bg-teal-900/30 px-4 py-2 text-sm font-medium text-teal-700 dark:text-teal-300 mb-4">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
          </svg>
          Features
        </div>
        
        <h2 class="text-4xl font-bold tracking-tight text-gray-900 dark:text-gray-50 sm:text-5xl mb-6">
          Why Choose <span class="gradient-text">Our Platform?</span>
        </h2>
        
        <p class="text-xl text-gray-700 dark:text-gray-200 max-w-3xl mx-auto leading-relaxed">
          Experience healthcare technology that puts you first. Our platform combines cutting-edge features with intuitive design.
        </p>
      </div>

      <!-- Features grid -->
      <div class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-4">
        <article
          v-for="(feature, index) in features"
          :key="index" 
          :class="[
            'premium-card glass-card rounded-3xl p-8 text-center transition-all duration-500 group',
            `stagger-${index + 1}`,
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <!-- Icon with gradient background -->
          <div class="mb-6 flex justify-center">
            <div 
              :class="[
                'inline-flex h-16 w-16 items-center justify-center rounded-2xl text-white shadow-lg transition-all duration-250 group-hover:scale-105 group-hover:rotate-2',
                `bg-gradient-to-br ${feature.gradient}`
              ]"
            >
              <!-- Calendar -->
              <svg v-if="feature.icon === 'calendar'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <!-- Shield -->
              <svg v-else-if="feature.icon === 'shield'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
              <!-- Users -->
              <svg v-else-if="feature.icon === 'users'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
              <!-- Clock -->
              <svg v-else-if="feature.icon === 'clock'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
          </div>
          
          <!-- Content -->
          <h3 class="text-xl font-bold text-gray-900 dark:text-gray-800 mb-4 group-hover:text-teal-600 dark:group-hover:text-teal-400 transition-colors duration-250">
            {{ feature.title }}
          </h3>
          
          <p class="text-gray-700 dark:text-gray-800 leading-relaxed mb-6">
            {{ feature.subtitle }}
          </p>

          <!-- Hover indicator -->
          <div class="opacity-0 group-hover:opacity-100 transition-opacity duration-250">
            <div class="inline-flex items-center gap-2 text-sm font-medium text-teal-600 dark:text-teal-400">
              Learn more
              <svg class="w-4 h-4 transform group-hover:translate-x-1 transition-transform duration-250" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
            </div>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>
<style scoped>
/* Features section animations */
.scroll-reveal {
  opacity: 0;
  transform: translateY(25px);
}

.scroll-reveal.revealed {
  opacity: 1;
  transform: translateY(0);
}

/* Staggered animations */
.stagger-1 { transition-delay: 0.05s; }
.stagger-2 { transition-delay: 0.1s; }
.stagger-3 { transition-delay: 0.15s; }
.stagger-4 { transition-delay: 0.2s; }

/* Enhanced card hover effects */
.premium-card {
  position: relative;
  overflow: hidden;
}

.premium-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.08), transparent);
  transition: left 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.premium-card:hover::before {
  left: 100%;
}

/* Icon animation */
.premium-card:hover .bg-gradient-to-br {
  animation: iconPulse 1.5s ease-in-out infinite;
}

@keyframes iconPulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.02);
  }
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .premium-card {
    padding: 1.5rem;
  }
}
</style>