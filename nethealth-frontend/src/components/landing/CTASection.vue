<script setup>
import { RouterLink } from 'vue-router'
import { ref, onMounted } from 'vue'

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

  const section = document.querySelector('#cta-section')
  if (section) {
    observer.observe(section)
  }
})
</script>

<template>
  <section id="cta-section" class="py-16 sm:py-20 lg:py-24 relative overflow-hidden">
    <!-- Background with gradient and patterns -->
    <div class="absolute inset-0 bg-gradient-to-br from-teal-600 via-cyan-600 to-blue-700"></div>
    <div class="absolute inset-0 opacity-20">
      <div class="absolute inset-0" style="background-image: radial-gradient(circle at 30px 30px, white 2px, transparent 2px); background-size: 60px 60px;"></div>
    </div>
    
    <!-- Floating elements -->
    <div class="absolute top-10 left-10 w-20 h-20 bg-white/10 rounded-full blur-xl float-animation"></div>
    <div class="absolute top-20 right-20 w-32 h-32 bg-cyan-300/20 rounded-full blur-2xl float-animation" style="animation-delay: -2s;"></div>
    <div class="absolute bottom-10 left-1/3 w-24 h-24 bg-teal-300/20 rounded-full blur-xl float-animation" style="animation-delay: -4s;"></div>

    <div class="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8 relative">
      <div 
        :class="[
          'text-center transition-all duration-600',
          isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
        ]"
      >
        <!-- Main heading -->
        <h2 class="text-4xl font-bold tracking-tight text-white sm:text-5xl lg:text-6xl mb-6 leading-tight">
          Ready to Transform Your
          <span class="block bg-gradient-to-r from-cyan-200 to-teal-200 bg-clip-text text-transparent">
            Healthcare Experience?
          </span>
        </h2>

        <!-- Subheading -->
        <p class="text-xl text-cyan-50 mb-8 max-w-2xl mx-auto leading-relaxed">
          Join thousands of patients and providers who trust our platform for secure, efficient, and modern healthcare management.
        </p>

        <!-- CTA Buttons -->
        <div class="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
          <RouterLink
            :to="{ name: 'Register' }"
            class="btn-pill btn-shimmer bg-white text-teal-600 hover:bg-gray-50 hover:text-teal-700 shadow-xl hover:shadow-2xl transform hover:-translate-y-1 transition-all duration-300"
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
            class="btn-pill btn-secondary-glass text-white border-white/30 hover:bg-white/10 hover:border-white/50"
          >
            <span class="flex items-center gap-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h1m4 0h1m-6 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Schedule Demo
            </span>
          </a>
        </div>

        <!-- Trust indicators -->
        <div 
          :class="[
            'grid grid-cols-1 sm:grid-cols-3 gap-6 max-w-3xl mx-auto transition-all duration-600 delay-150',
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <div class="flex items-center justify-center gap-3 text-cyan-100">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span class="font-medium">HIPAA Compliant</span>
          </div>
          
          <div class="flex items-center justify-center gap-3 text-cyan-100">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
            <span class="font-medium">Bank-Level Security</span>
          </div>
          
          <div class="flex items-center justify-center gap-3 text-cyan-100">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
            <span class="font-medium">99.9% Uptime</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* CTA section specific animations */
.float-animation {
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  33% {
    transform: translateY(-10px) rotate(1deg);
  }
  66% {
    transform: translateY(5px) rotate(-1deg);
  }
}

/* Enhanced button hover effects */
.btn-pill:hover {
  transform: translateY(-2px) scale(1.02);
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* Shimmer effect for CTA button */
.btn-shimmer::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transition: left 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.btn-shimmer:hover::before {
  left: 100%;
}

/* Scroll reveal animations */
.scroll-reveal {
  opacity: 0;
  transform: translateY(25px);
}

.scroll-reveal.revealed {
  opacity: 1;
  transform: translateY(0);
}
</style>