<script setup>
import { RouterLink } from 'vue-router'
import netHealthLogo from '../../assets/logo.png'
import netHealthLogo2 from '../../assets/logo2.png' 
import netHealthLogo3 from '../../assets/logo3.png' 
const navLinks = [
  { label: 'Home', href: '#home' },
  { label: 'Features', href: '#features' },
  { label: 'About Us', href: '#about' },
  { label: 'Contact', href: '#contact' },
]
</script>

<template>
  <header
    class="sticky top-0 z-50 w-full bg-white shadow-[0_1px_3px_0_rgba(0,0,0,0.08)]"
  >
    <nav class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
      <!-- Logo + brand -->
      <RouterLink to="/" class="flex shrink-0 items-center gap-2">
        <img :src="netHealthLogo3" alt="NetHealth Logo" class="w-16 h-16 mb-2" style="width: 155px; height: 150px; margin-bottom: -50px;margin-top: -50px;"/>
        <!-- <span class="text-xl font-semibold text-gray-900">NetHealth</span> -->
      </RouterLink>

      <!-- Center links -->
      <div class="hidden items-center gap-8 md:flex">
        <a
          v-for="link in navLinks"
          :key="link.label"
          :href="link.href"
          class="text-sm font-medium text-gray-600 transition-colors hover:text-primary"
        >
          {{ link.label }}
        </a>
      </div>

      <!-- Right: Login + Register -->
      <div class="flex shrink-0 items-center gap-3">
        <RouterLink
          :to="{ name: 'Login' }"
          class="rounded-full bg-primary px-6 py-2 text-sm font-medium text-white transition-opacity hover:opacity-95 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:ring-offset-2"
        >
          Login
        </RouterLink>
        <RouterLink
          :to="{ name: 'RegisterRole' }"
          class="rounded-full border border-primary px-6 py-2 text-sm font-medium text-primary transition-colors hover:bg-primary/10 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:ring-offset-2"
        >
          Register
        </RouterLink>
      </div>
    </nav>
  </header>
</template>
