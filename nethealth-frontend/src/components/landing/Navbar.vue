<script setup>
import { RouterLink } from 'vue-router'
import { ref, onMounted } from 'vue'
import netHealthLogo3 from '../../assets/logo3.png'

const navLinks = [
  { label: 'Home', href: '#home' },
  { label: 'Features', href: '#features-section' },
  { label: 'About Us', href: '#cta-section' },
  { label: 'Contact', href: '#footer-section' },
]

const isScrolled = ref(false)

// Smooth scroll function
function handleSmoothScroll(href) {
  if (href === '#home') {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } else {
    const targetId = href.replace('#', '')
    const targetElement = document.getElementById(targetId)
    if (targetElement) {
      targetElement.scrollIntoView({ behavior: 'smooth' })
    }
  }
}

onMounted(() => {
  const handleScroll = () => {
    isScrolled.value = window.scrollY > 20
  }
  
  window.addEventListener('scroll', handleScroll)
  
  return () => {
    window.removeEventListener('scroll', handleScroll)
  }
})
</script>

<template>
  <header
    :class="[
      'sticky top-0 z-50 w-full transition-all duration-300',
      isScrolled 
        ? 'bg-white/80 dark:bg-gray-900/80 backdrop-blur-xl shadow-lg border-b border-gray-200/20 dark:border-gray-700/20' 
        : 'bg-transparent'
    ]"
  >
    <nav class="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
      <!-- Logo + brand -->
      <RouterLink 
        to="/" 
        class="flex shrink-0 items-center transition-all duration-300 hover:scale-105 group"
      >
        <img 
          :src="netHealthLogo3" 
          alt="NetHealth Logo" 
          class="max-h-16 w-auto h-auto transition-all duration-300 group-hover:brightness-110"
        />
      </RouterLink>

      <!-- Center navigation -->
      <div class="hidden items-center space-x-8 md:flex">
        <a
          v-for="link in navLinks"
          :key="link.label"
          @click.prevent="handleSmoothScroll(link.href)"
          :class="[
            'relative text-sm font-medium transition-all duration-250 cursor-pointer group',
            isScrolled 
              ? 'text-gray-700 dark:text-gray-300 hover:text-teal-600 dark:hover:text-teal-400' 
              : 'text-gray-600 hover:text-teal-600'
          ]"
        >
          {{ link.label }}
          <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-teal-500 to-cyan-500 transition-all duration-250 group-hover:w-full"></span>
        </a>
      </div>

      <!-- Right: Auth buttons -->
      <div class="flex shrink-0 items-center space-x-3">
        <RouterLink
          :to="{ name: 'Login' }"
          :class="[
            'px-4 py-2 text-sm font-medium transition-all duration-250 rounded-lg',
            isScrolled 
              ? 'text-gray-700 dark:text-gray-300 hover:text-teal-600 dark:hover:text-teal-400 hover:bg-teal-50 dark:hover:bg-teal-900/20' 
              : 'text-gray-700 hover:text-teal-600 hover:bg-white/10'
          ]"
        >
          Login
        </RouterLink>
        <RouterLink 
          :to="{ name: 'Register' }"
          class="btn-pill btn-primary-gradient text-white shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 transition-all duration-250"
        >
          Get Started
        </RouterLink>
      </div>
    </nav>
  </header>
</template>

<style scoped>
/* Navbar animations */
@keyframes fadeDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Enhanced glassmorphism effect */
header {
  animation: fadeDown 0.6s ease-out;
}

/* Logo hover effect */
.group:hover img {
  filter: drop-shadow(0 4px 8px rgba(20, 184, 166, 0.3));
}

/* Logo sizing constraints */
.group img {
  max-width: 240px;
  object-fit: contain;
  height: auto;
}

/* Navigation link hover effects */
.group:hover span {
  background: linear-gradient(90deg, #14B8A6, #06B6D4);
}

/* Button enhancements */
.btn-pill {
  border-radius: 50px;
  padding: 10px 20px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.btn-primary-gradient {
  background: linear-gradient(135deg, #14B8A6 0%, #0D9488 50%, #0F766E 100%);
  border: none;
  box-shadow: 0 4px 16px rgba(20, 184, 166, 0.3);
}

.btn-primary-gradient:hover {
  background: linear-gradient(135deg, #0D9488 0%, #0F766E 50%, #134E4A 100%);
  box-shadow: 0 8px 24px rgba(20, 184, 166, 0.4);
}

/* Mobile responsiveness */
@media (max-width: 768px) {
  .btn-pill {
    padding: 8px 16px;
    font-size: 13px;
  }
}
</style>
