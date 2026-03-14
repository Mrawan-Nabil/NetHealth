<script setup>
import { RouterLink } from 'vue-router'
import { ref, onMounted } from 'vue'
import netHealthLogo from '../../assets/logo.png'

const quickLinks = [
  { label: 'Home', href: '#home' },
  { label: 'Features', href: '#features-section' },
  { label: 'About Us', href: '#cta-section' },
  { label: 'Contact', href: '#footer-section' },
  { label: 'Login', to: { name: 'Login' } },
  { label: 'Register', to: { name: 'Register' } },
]

const legalLinks = [
  { label: 'Privacy Policy', href: '#' },
  { label: 'Terms of Service', href: '#' },
  { label: 'Cookie Policy', href: '#' },
  { label: 'HIPAA Compliance', href: '#' },
]

const socialLinks = [
  { label: 'Facebook', href: '#', icon: 'facebook' },
  { label: 'Twitter', href: '#', icon: 'twitter' },
  { label: 'LinkedIn', href: '#', icon: 'linkedin' },
  { label: 'Instagram', href: '#', icon: 'instagram' },
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
    { threshold: 0.1 }
  )

  const footer = document.querySelector('#footer-section')
  if (footer) {
    observer.observe(footer)
  }
})

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
</script>


<template>
  <footer id="footer-section" class="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 text-white">
    <!-- Background decoration -->
    <div class="absolute inset-0 opacity-5">
      <div class="absolute inset-0" style="background-image: radial-gradient(circle at 30px 30px, white 2px, transparent 2px); background-size: 60px 60px;"></div>
    </div>
    <div class="absolute top-0 left-0 w-96 h-96 bg-teal-500/5 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-0 w-80 h-80 bg-cyan-500/5 rounded-full blur-3xl"></div>

    <div class="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8 lg:py-20 relative">
      <div class="grid grid-cols-1 gap-12 md:grid-cols-2 lg:grid-cols-4">
        <!-- Column 1: Logo, description, Get Started -->
        <div 
          :class="[
            'lg:col-span-1 transition-all duration-500',
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <RouterLink to="/" class="inline-flex items-center gap-2 logo-group">
            <img 
              :src="netHealthLogo" 
              alt="NetHealth Logo" 
              class="w-36 h-36 transition-all duration-300" 
              style="margin-bottom: -5px; margin-top: -5px;"
            />
          </RouterLink>
          
          <p class="mt-6 max-w-sm text-gray-300 leading-relaxed">
            Your health, managed in one secure place. Connect with doctors, manage records, and take control of your care with our premium platform.
          </p>
          
          <RouterLink 
            :to="{ name: 'Register' }" 
            class="mt-8 inline-flex items-center gap-2 btn-pill btn-primary-gradient shadow-lg hover:shadow-xl transform hover:-translate-y-1 transition-all duration-300"
          >
            Get Started Free
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
            </svg>
          </RouterLink>
        </div>

        <!-- Column 2: Quick Links -->
        <div 
          :class="[
            'transition-all duration-500 delay-100',
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <h3 class="text-lg font-semibold text-white mb-6 relative">
            Quick Links
            <span class="absolute -bottom-2 left-0 w-8 h-0.5 bg-gradient-to-r from-teal-500 to-cyan-500"></span>
          </h3>
          <ul class="space-y-4">
            <li v-for="link in quickLinks" :key="link.label">
              <RouterLink
                v-if="link.to"
                :to="link.to"
                class="text-gray-400 transition-all duration-300 hover:text-teal-400 hover:translate-x-2 flex items-center gap-2 link-group"
              >
                <span class="w-1 h-1 bg-teal-500 rounded-full opacity-0 transition-opacity duration-300"></span>
                {{ link.label }}
              </RouterLink>
              <a
                v-else
                :href="link.href"
                @click.prevent="handleSmoothScroll(link.href)"
                class="text-gray-400 transition-all duration-300 hover:text-teal-400 hover:translate-x-2 flex items-center gap-2 link-group cursor-pointer"
              >
                <span class="w-1 h-1 bg-teal-500 rounded-full opacity-0 transition-opacity duration-300"></span>
                {{ link.label }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Column 3: Legal -->
        <div 
          :class="[
            'transition-all duration-500 delay-150',
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <h3 class="text-lg font-semibold text-white mb-6 relative">
            Legal & Compliance
            <span class="absolute -bottom-2 left-0 w-8 h-0.5 bg-gradient-to-r from-teal-500 to-cyan-500"></span>
          </h3>
          <ul class="space-y-4">
            <li v-for="link in legalLinks" :key="link.label">
              <a
                :href="link.href"
                class="text-gray-400 transition-all duration-300 hover:text-teal-400 hover:translate-x-2 flex items-center gap-2 link-group"
              >
                <span class="w-1 h-1 bg-teal-500 rounded-full opacity-0 transition-opacity duration-300"></span>
                {{ link.label }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Column 4: Follow Us & Newsletter -->
        <div 
          :class="[
            'transition-all duration-500 delay-200',
            isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
          ]"
        >
          <h3 class="text-lg font-semibold text-white mb-6 relative">
            Stay Connected
            <span class="absolute -bottom-2 left-0 w-8 h-0.5 bg-gradient-to-r from-teal-500 to-cyan-500"></span>
          </h3>
          
          <!-- Social Links -->
          <div class="flex gap-3 mb-8">
            <a
              v-for="social in socialLinks"
              :key="social.label"
              :href="social.href"
              :aria-label="social.label"
              class="group relative p-3 rounded-xl bg-gray-800/50 backdrop-blur-sm border border-gray-700/50 text-gray-400 transition-all duration-300 hover:bg-teal-500/10 hover:border-teal-500/30 hover:text-teal-400 hover:-translate-y-1 hover:scale-110"
            >
              <!-- Facebook -->
              <svg v-if="social.icon === 'facebook'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" />
              </svg>
              <!-- Twitter/X -->
              <svg v-else-if="social.icon === 'twitter'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
              </svg>
              <!-- LinkedIn -->
              <svg v-else-if="social.icon === 'linkedin'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
              </svg>
              <!-- Instagram -->
              <svg v-else-if="social.icon === 'instagram'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
              </svg>
            </a>
          </div>

          <!-- Newsletter signup -->
          <div class="space-y-4">
            <p class="text-sm text-gray-300">
              Get health tips and platform updates
            </p>
            <div class="flex gap-2">
              <input
                type="email"
                placeholder="Enter your email"
                class="flex-1 px-4 py-2 bg-gray-800/50 backdrop-blur-sm border border-gray-700/50 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-teal-500/50 focus:ring-1 focus:ring-teal-500/50 transition-all duration-300"
              />
              <button class="px-4 py-2 bg-gradient-to-r from-teal-500 to-cyan-500 text-white rounded-lg hover:from-teal-600 hover:to-cyan-600 transition-all duration-300 hover:scale-105">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Copyright and trust badges -->
      <div 
        :class="[
          'mt-16 pt-8 border-t border-gray-800/50 transition-all duration-500 delay-250',
          isVisible ? 'scroll-reveal revealed' : 'scroll-reveal'
        ]"
      >
        <div class="flex flex-col md:flex-row justify-between items-center gap-6">
          <p class="text-sm text-gray-400">
            © {{ new Date().getFullYear() }} NetHealth. All rights reserved. Built with ❤️ for better healthcare.
          </p>
          
          <!-- Trust badges -->
          <div class="flex items-center gap-6 text-xs text-gray-400">
            <div class="flex items-center gap-2">
              <svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
              HIPAA Compliant
            </div>
            <div class="flex items-center gap-2">
              <svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
              </svg>
              SSL Secured
            </div>
            <div class="flex items-center gap-2">
              <svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
              99.9% Uptime
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
/* Footer animations */
.scroll-reveal {
  opacity: 0;
  transform: translateY(25px);
}

.scroll-reveal.revealed {
  opacity: 1;
  transform: translateY(0);
}

/* Button styles */
.btn-pill {
  border-radius: 50px;
  padding: 12px 24px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  position: relative;
  overflow: hidden;
}

.btn-primary-gradient {
  background: linear-gradient(135deg, #14B8A6 0%, #0D9488 50%, #0F766E 100%);
  border: none;
  box-shadow: 0 4px 14px rgba(20, 184, 166, 0.25);
}

.btn-primary-gradient:hover {
  background: linear-gradient(135deg, #0D9488 0%, #0F766E 50%, #134E4A 100%);
  box-shadow: 0 6px 18px rgba(20, 184, 166, 0.3);
}

/* Social link hover effects (only for social icons) */
.group:hover:not(.logo-group) {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.08), rgba(6, 182, 212, 0.08));
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* Text link hover effects (no background) */
.link-group:hover {
  background: none !important;
}

.link-group:hover span {
  opacity: 1;
}

/* Logo hover and animation effects */
.logo-group img {
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.logo-group:hover img {
  animation: fastHeartPulse 1s ease-in-out infinite;
  filter: drop-shadow(0 6px 16px rgba(20, 184, 166, 0.3)) brightness(1.15);
  transform: scale(1.05) translateY(-2px);
}

.logo-group:hover {
  background: none !important;
}

@keyframes fastHeartPulse {
  0%, 100% {
    transform: scale(1.05) translateY(-2px);
  }
  20% {
    transform: scale(1.08) translateY(-2px);
  }
  35% {
    transform: scale(1.05) translateY(-2px);
  }
  50% {
    transform: scale(1.07) translateY(-2px);
  }
  65% {
    transform: scale(1.05) translateY(-2px);
  }
}

/* Newsletter input focus effects */
input:focus {
  background: rgba(31, 41, 55, 0.8);
}

/* Trust badge animations */
.flex.items-center.gap-2 {
  transition: all 0.25s ease;
}

.flex.items-center.gap-2:hover {
  transform: translateY(-1px);
  color: #14B8A6;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .btn-pill {
    padding: 10px 20px;
    font-size: 13px;
  }
}
</style>