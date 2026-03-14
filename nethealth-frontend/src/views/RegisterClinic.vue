<script setup>
import { RouterLink } from 'vue-router'
// Clinic registration form – implement as needed
</script>

<template>
  <div class="page-enter space-y-loose">
    <div class="text-center stagger-1">
      <h1 class="text-3xl font-bold text-gray-900 mb-2">Clinic Registration</h1>
      <p class="text-gray-600 text-base leading-relaxed">Register your clinic with our platform.</p>
    </div>
    
    <div class="card-base container-hover-subtle max-w-md mx-auto text-center py-12 stagger-2">
      <div class="w-16 h-16 bg-[#14B8A6]/10 rounded-full flex items-center justify-center mx-auto mb-4">
        <svg class="w-8 h-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
        </svg>
      </div>
      <h2 class="text-xl font-semibold text-gray-900 mb-2">Coming Soon</h2>
      <p class="text-gray-600 mb-6">Clinic registration will be available soon. Please check back later.</p>
      <RouterLink to="/register" class="btn-secondary">
        Back to Registration
      </RouterLink>
    </div>
  </div>
</template>
