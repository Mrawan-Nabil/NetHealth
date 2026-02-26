<script setup>
import { RouterLink } from 'vue-router'
import netHealthLogo from '../../assets/logo.png'

const quickLinks = [
  { label: 'Home', href: '#home' },
  { label: 'Features', href: '#features' },
  { label: 'About Us', href: '#about' },
  { label: 'Contact', href: '#contact' },
  { label: 'Login', to: { name: 'Login' } },
  { label: 'Register', to: { name: 'RegisterRole' } },
]

const legalLinks = [
  { label: 'Privacy Policy', href: '#' },
  { label: 'Terms of Service', href: '#' },
  { label: 'Cookie Policy', href: '#' },
]

const socialLinks = [
  { label: 'Facebook', href: '#' },
  { label: 'Twitter', href: '#' },
  { label: 'LinkedIn', href: '#' },
  { label: 'Instagram', href: '#' },
]
</script>

<template>
  <footer class="bg-gray-900 text-white">
    <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8 lg:py-16">
      <div class="grid grid-cols-1 gap-8 md:grid-cols-2 lg:grid-cols-4">
        <!-- Column 1: Logo, description, Get Started -->
        <div class="lg:col-span-1">
          <RouterLink to="/" class="inline-flex items-center gap-2">
              <img :src="netHealthLogo" alt="NetHealth Logo" class="w-16 h-16 mb-2" style="width: 165px; height: 160px; margin-bottom: -50px;margin-top: -50px;"/>
            </RouterLink>
          <p class="mt-4 max-w-xs text-sm text-gray-400">
            Your health, managed in one secure place. Connect with doctors, manage records, and take control of your care.
          </p>
          <RouterLink
            :to="{ name: 'RegisterRole' }"
            class="mt-6 inline-block rounded-lg bg-primary px-5 py-2.5 text-sm font-medium text-white transition-opacity hover:opacity-95 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:ring-offset-2 focus:ring-offset-gray-900"
          >
            Get Started
          </RouterLink>
        </div>

        <!-- Column 2: Quick Links -->
        <div>
          <h3 class="text-sm font-semibold uppercase tracking-wider text-gray-300">
            Quick Links
          </h3>
          <ul class="mt-4 space-y-3">
            <li v-for="link in quickLinks" :key="link.label">
              <RouterLink
                v-if="link.to"
                :to="link.to"
                class="text-sm text-gray-400 transition-colors hover:text-primary"
              >
                {{ link.label }}
              </RouterLink>
              <a
                v-else
                :href="link.href"
                class="text-sm text-gray-400 transition-colors hover:text-primary"
              >
                {{ link.label }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Column 3: Legal -->
        <div>
          <h3 class="text-sm font-semibold uppercase tracking-wider text-gray-300">
            Legal
          </h3>
          <ul class="mt-4 space-y-3">
            <li v-for="link in legalLinks" :key="link.label">
              <a
                :href="link.href"
                class="text-sm text-gray-400 transition-colors hover:text-primary"
              >
                {{ link.label }}
              </a>
            </li>
          </ul>
        </div>

        <!-- Column 4: Follow Us -->
        <div>
          <h3 class="text-sm font-semibold uppercase tracking-wider text-gray-300">
            Follow Us
          </h3>
          <div class="mt-4 flex gap-3">
            <a
              v-for="social in socialLinks"
              :key="social.label"
              :href="social.href"
              :aria-label="social.label"
              class="rounded-lg p-2 text-gray-400 transition-colors hover:bg-gray-800 hover:text-primary"
            >
              <!-- Facebook -->
              <svg v-if="social.label === 'Facebook'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" />
              </svg>
              <!-- Twitter/X -->
              <svg v-else-if="social.label === 'Twitter'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
              </svg>
              <!-- LinkedIn -->
              <svg v-else-if="social.label === 'LinkedIn'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
              </svg>
              <!-- Instagram -->
              <svg v-else-if="social.label === 'Instagram'" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
              </svg>
            </a>
          </div>
        </div>
      </div>

      <!-- Copyright -->
      <div class="mt-12 border-t border-gray-800 pt-8">
        <p class="text-center text-sm text-gray-500">
          © {{ new Date().getFullYear() }} NetHealth. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
</template>
