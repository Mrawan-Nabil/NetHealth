<script setup>
// Full-screen medical team background; replace with your own asset if needed
const backgroundImage = 'https://69a108c1d09d9185fbb073de.imgix.net/C%3A/Users/ms182/Downloads/UNIVERSITY/SECOND%20TERM/SOFTWARE%20ENGINEERING/NetHealth/nethealth-frontend/src/assets/dooone.jpg'
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
        <router-view />
      </div>
    </div>
  </div>
</template>
