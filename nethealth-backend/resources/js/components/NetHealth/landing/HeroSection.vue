<script setup>
import { RouterLink } from 'vue-router'
import doctorImage from '../../assets/male-surgeon-using-digital-tablet-operation-room.jpg'
const highlights = [
  { label: 'Secure' },
  { label: 'Innovative' },
  { label: 'Accessible' },
]
</script>

<template>
  <section id="home" class="overflow-hidden">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="grid grid-cols-1 items-center gap-12 md:grid-cols-2 md:gap-16">
        <!-- Left column -->
        <div class="py-12 md:py-20">
          <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl lg:text-6xl">
            <span class="text-primary">Smart Healthcare,</span>
            <span class="block text-gray-900">Simplified.</span>
          </h1>
          <p class="mt-6 max-w-lg text-lg text-gray-600">
            Connect with doctors, manage your records, and take control of your care—all in one secure platform built for patients and providers.
          </p>
          <div class="mt-10 flex flex-wrap gap-4">
            <RouterLink
              :to="{ name: 'RegisterRole' }"
              class="rounded-full bg-primary px-8 py-3 text-base font-medium text-white transition-opacity hover:opacity-95 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:ring-offset-2"
            >
              Get Started
            </RouterLink>
            <a
              href="#features"
              class="rounded-full border border-primary px-8 py-3 text-base font-medium text-primary transition-colors hover:bg-primary/10 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:ring-offset-2"
            >
              Learn More
            </a>
          </div>
          <ul class="mt-10 flex flex-wrap gap-x-8 gap-y-3">
            <li
              v-for="item in highlights"
              :key="item.label"
              class="flex items-center gap-2 text-sm font-medium text-gray-700"
            >
              <svg class="h-5 w-5 shrink-0 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              {{ item.label }}
            </li>
          </ul>
        </div>

        <!-- Right column: image placeholder + gradient -->
        <div class="relative flex items-center justify-center py-20">
          <div
            class="absolute inset-0 -z-10 rounded-3xl bg-linear-to-br from-primary/20 via-primary/10 to-transparent blur-2xl"
            aria-hidden="true"
          />
          <div
            class="relative flex aspect-4/5 w-full max-w-md items-center justify-center overflow-hidden rounded-2xl bg-gray-100 ring-1 ring-gray-200/50"
          >
            <!-- Placeholder for doctor + tablet image -->
            <div class="relative flex justify-center lg:justify-end h-full w-full">
              <img :src="doctorImage" alt="Doctor holding tablet" class="w-full h-full object-cover rounded-2xl" />
            <div class="absolute inset-0 -z-10 bg-primary/20 blur-3xl rounded-full"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
