<script setup>
import { RouterLink } from 'vue-router'
import { ref, onMounted } from 'vue'
import doctorImage from '../../assets/male-surgeon-using-digital-tablet-operation-room.jpg'

const highlights = [
  { label: 'HIPAA Secure', icon: 'shield' },
  { label: 'AI-Powered', icon: 'cpu' },
  { label: '24/7 Access', icon: 'clock' },
]

const isVisible = ref(false)

onMounted(() => {
  isVisible.value = true
  
  // Parallax effect
  const handleScroll = () => {
    const scrolled = window.pageYOffset
    const parallaxElements = document.querySelectorAll('.parallax-element')
    
    parallaxElements.forEach((element, index) => {
      const speed = 0.5 + (index * 0.1)
      element.style.transform = `translateY(${scrolled * speed}px)`
    })
  }
  
  window.addEventListener('scroll', handleScroll)
  
  return () => {
    window.removeEventListener('scroll', handleScroll)
  }
})
</script>

<template>
  <section class="overflow-hidden py-20 sm:py-24 lg:py-32 relative">
    <!-- Background with gradient and decorative elements -->
    <div class="absolute inset-0 bg-gradient-to-br from-white via-gray-50 to-teal-50/30 dark:from-gray-900 dark:via-gray-800 dark:to-teal-900/20"></div>
    
    <!-- Floating background elements -->
    <div class="absolute top-20 left-10 w-72 h-72 bg-teal-200/20 dark:bg-teal-400/10 rounded-full blur-3xl parallax-element"></div>
    <div class="absolute bottom-20 right-10 w-96 h-96 bg-cyan-200/20 dark:bg-cyan-400/10 rounded-full blur-3xl parallax-element"></div>
    <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-gradient-to-r from-teal-100/10 to-cyan-100/10 dark:from-teal-900/10 dark:to-cyan-900/10 rounded-full blur-3xl parallax-element"></div>

    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative">
      <div class="grid grid-cols-1 items-center gap-16 lg:grid-cols-2">
        <!-- Left column -->
        <div 
          :class="[
            'text-center lg:text-left transition-all duration-1000',
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <!-- Badge -->
          <div class="inline-flex items-center gap-2 rounded-full bg-teal-50 dark:bg-teal-900/20 px-4 py-2 text-sm font-medium text-teal-700 dark:text-teal-300 mb-6 glass-card">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
            Trusted by 50K+ patients
          </div>

          <!-- Main heading -->
          <h1 class="text-5xl font-bold tracking-tight text-gray-900 dark:text-gray-50 sm:text-6xl lg:text-7xl mb-6 leading-tight">
            <span class="gradient-text">Smart Healthcare,</span>
            <span class="block text-gray-900 dark:text-gray-50">Simplified.</span>
          </h1>
          
          <!-- Subheading -->
          <p class="text-xl text-gray-700 dark:text-gray-200 leading-relaxed mb-8 max-w-2xl mx-auto lg:mx-0">
            Connect with doctors, manage your records, and take control of your care—all in one secure platform built for patients and providers.
          </p>
          
          <!-- CTA Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start mb-10">
            <RouterLink
              :to="{ name: 'Register' }"
              class="btn-pill btn-primary-gradient btn-shimmer shadow-xl hover:shadow-2xl"
            >
              <span class="flex items-center gap-2">
                Get Started Free
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </span>
            </RouterLink>
            <a
              href="#features"
              class="btn-pill btn-secondary-glass"
            >
              <span class="flex items-center gap-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h1m4 0h1m-6 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Watch Demo
              </span>
            </a>
          </div>
          
          <!-- Feature highlights -->
          <div class="flex flex-wrap justify-center lg:justify-start gap-6">
            <div
              v-for="(item, index) in highlights"
              :key="item.label"
              :class="[
                'flex items-center gap-3 text-sm font-medium text-gray-700 dark:text-gray-300 transition-all duration-300',
                `stagger-${index + 1}`,
                isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
              ]"
            >
              <!-- Shield icon -->
              <div class="flex-shrink-0 w-8 h-8 bg-gradient-to-br from-teal-500 to-cyan-500 rounded-lg flex items-center justify-center">
                <svg v-if="item.icon === 'shield'" class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
                <!-- CPU icon -->
                <svg v-else-if="item.icon === 'cpu'" class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
                </svg>
                <!-- Clock icon -->
                <svg v-else-if="item.icon === 'clock'" class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              {{ item.label }}
            </div>
          </div>
        </div>

        <!-- Right column: Enhanced image with glassmorphism -->
        <div 
          :class="[
            'relative flex items-center justify-center transition-all duration-600 delay-200',
            isVisible ? 'scroll-reveal revealed float-animation' : 'scroll-reveal'
          ]"
        >
          <div class="relative w-full max-w-lg">
            <!-- Glassmorphism container -->
            <div class="glass-card rounded-3xl p-6 shadow-2xl">
              <img
                :src="doctorImage"
                alt="Doctor holding tablet"
                class="w-full h-auto rounded-2xl"
              />
            </div>
            
            <!-- Floating UI elements -->
            <div class="absolute -top-4 -left-4 glass-card rounded-2xl p-4 shadow-lg float-animation">
              <div class="flex items-center gap-3">
                <div class="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
                <span class="text-sm font-medium text-gray-700 dark:text-gray-800">Online</span>
              </div>
            </div>
            
            <div class="absolute -bottom-4 -right-4 glass-card rounded-2xl p-4 shadow-lg float-animation" style="animation-delay: -1.5s;">
              <div class="flex items-center gap-2">
                <svg class="w-5 h-5 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span class="text-sm font-medium text-gray-700 dark:text-gray-800">Verified</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Hero section animations */
@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-15px);
  }
}

/* Scroll reveal animations */
.scroll-reveal {
  opacity: 0;
  transform: translateY(40px);
}

.scroll-reveal.revealed {
  opacity: 1;
  transform: translateY(0);
}

/* Floating animation for hero elements */
.float-animation {
  animation: float 6s ease-in-out infinite;
}

/* Parallax elements */
.parallax-element {
  will-change: transform;
}

/* Enhanced hover effects */
.glass-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* Staggered animations */
.stagger-1 { transition-delay: 0.1s; }
.stagger-2 { transition-delay: 0.2s; }
.stagger-3 { transition-delay: 0.3s; }

/* Badge animation */
.glass-card {
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .parallax-element {
    transform: none !important;
  }
}
</style>