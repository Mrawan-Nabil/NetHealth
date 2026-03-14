<script setup>
// Full-screen medical team background; replace with your own asset if needed
const backgroundImage = 'https://69a108c1d09d9185fbb073de.imgix.net/C%3A/Users/ms182/Downloads/UNIVERSITY/SECOND%20TERM/SOFTWARE%20ENGINEERING/NetHealth/nethealth-frontend/src/assets/dooone.jpg'
</script>

<template>
  <div
    class="auth-layout relative min-h-screen w-full bg-cover bg-center bg-no-repeat"
    :style="{ backgroundImage: `url(${backgroundImage})` }"
  >
    <!-- Dark overlay -->
    <div class="absolute inset-0 bg-black/50" aria-hidden="true" />

    <!-- Centered card -->
    <div class="relative flex min-h-screen items-center justify-center p-4">
      <div class="w-full max-w-md rounded-2xl bg-white p-8 shadow-xl">
        <router-view />
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/auth-animations.css';

/* Auth layout specific styles */
.auth-layout {
  animation: authFadeIn 0.5s ease-out;
}

@keyframes authFadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Enhanced auth card styling */
.auth-card {
  backdrop-filter: blur(10px);
  background: rgba(255, 255, 255, 0.95);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Apply auth animations to child elements */
.auth-layout :deep(input) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.auth-layout :deep(input:focus) {
  transform: translateY(-1px);
  box-shadow: 0 10px 15px -3px rgba(20, 184, 166, 0.1);
}

.auth-layout :deep(button) {
  transition: all 0.2s ease;
}

.auth-layout :deep(button:hover) {
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.auth-layout :deep(button:active) {
  transform: translateY(0);
}

/* Enhanced link styling */
.auth-layout :deep(a) {
  transition: all 0.2s ease;
  position: relative;
}

.auth-layout :deep(a:hover) {
  transform: translateY(-1px);
}

/* Logo animation */
.auth-layout :deep(img) {
  transition: transform 0.3s ease;
}

.auth-layout :deep(img:hover) {
  transform: scale(1.05);
}
</style>
