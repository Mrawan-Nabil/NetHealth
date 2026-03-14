<script setup>
import { RouterLink } from 'vue-router'
// Pharmacy registration form – implement as needed
</script>

<template>
  <div class="page-enter space-y-loose">
    <div class="text-center stagger-1">
      <h1 class="text-3xl font-bold text-gray-900 mb-2">Pharmacy Registration</h1>
      <p class="text-gray-600 text-base leading-relaxed">Register your pharmacy with our platform.</p>
    </div>
    
    <div class="card-base container-hover-subtle max-w-md mx-auto text-center py-12 stagger-2">
      <div class="w-16 h-16 bg-[#14B8A6]/10 rounded-full flex items-center justify-center mx-auto mb-4">
        <svg class="w-8 h-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
        </svg>
      </div>
      <h2 class="text-xl font-semibold text-gray-900 mb-2">Coming Soon</h2>
      <p class="text-gray-600 mb-6">Pharmacy registration will be available soon. Please check back later.</p>
      <RouterLink to="/register" class="btn-secondary">
        Back to Registration
      </RouterLink>
    </div>
  </div>
</template>
