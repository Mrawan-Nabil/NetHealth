<script setup lang="ts">
// Full-screen medical team background; replace with your own asset if needed
const backgroundImage = 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=1920'
</script>

<template>
  <div
    class="relative min-h-screen w-full bg-cover bg-center bg-no-repeat"
    :style="{ backgroundImage: `url(${backgroundImage})` }"
  >
    <!-- Dark overlay -->
    <div class="absolute inset-0 bg-black/50" aria-hidden="true" />

    <!-- Centered card -->
    <div class="relative flex min-h-screen items-center justify-center p-4">
      <div
        class="w-full max-w-md rounded-2xl bg-white p-8 shadow-xl"
      >
        <slot />
      </div>
    </div>
  </div>
</template>
