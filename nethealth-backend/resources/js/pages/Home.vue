<template>
  <div :class="['landing-layout min-h-screen flex flex-col font-sans page-enter', { 'dark': isDark }]">
    <Navbar />

    <main class="grow">
      <HeroSection />
      <StatsSection />
      <FeaturesSection />
      <CTASection />
    </main>

    <Footer />
  </div>
</template>

<script setup>
// Importing all the landing page pieces
import CTASection from '../components/landing/CTASection.vue'
import FeaturesSection from '../components/landing/FeaturesSection.vue'
import Footer from '../components/landing/Footer.vue'
import HeroSection from '../components/landing/HeroSection.vue'
import Navbar from '../components/landing/Navbar.vue'
import StatsSection from '../components/landing/StatsSection.vue'
import { useDarkMode } from '../composables/useScrollAnimations.js'

// Setup scroll animations and dark mode
const { isDark } = useDarkMode()
</script>

<style scoped>
/* Modern premium landing page styles */
.landing-layout {
  background: linear-gradient(135deg, #ffffff 0%, #f8fafc 50%, #f1f5f9 100%);
  scroll-behavior: smooth;
  position: relative;
}

/* Dark mode background */
.landing-layout.dark {
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #334155 100%);
}

/* Glassmorphism effects */
.landing-layout :deep(.glass-card) {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.landing-layout.dark :deep(.glass-card) {
  background: rgba(15, 23, 42, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

/* Premium card hover effects */
.landing-layout :deep(.premium-card) {
  transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  transform-origin: center;
}

.landing-layout :deep(.premium-card:hover) {
  transform: translateY(-6px) scale(1.01);
  box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.12);
}

.landing-layout.dark :deep(.premium-card:hover) {
  box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.3);
}

/* Pill-shaped buttons */
.landing-layout :deep(.btn-pill) {
  border-radius: 50px;
  padding: 14px 32px;
  font-weight: 600;
  font-size: 16px;
  transition: all 0.25s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  position: relative;
  overflow: hidden;
}

.landing-layout :deep(.btn-pill:hover) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px -6px rgba(20, 184, 166, 0.35);
}

.landing-layout :deep(.btn-pill:active) {
  transform: translateY(0) scale(0.98);
  transition-duration: 0.15s;
}

/* Primary gradient button */
.landing-layout :deep(.btn-primary-gradient) {
  background: linear-gradient(135deg, #14B8A6 0%, #0D9488 50%, #0F766E 100%);
  color: white;
  border: none;
  box-shadow: 0 4px 14px rgba(20, 184, 166, 0.25);
}

.landing-layout :deep(.btn-primary-gradient:hover) {
  background: linear-gradient(135deg, #0D9488 0%, #0F766E 50%, #134E4A 100%);
  box-shadow: 0 6px 18px rgba(20, 184, 166, 0.3);
}

/* Secondary glass button */
.landing-layout :deep(.btn-secondary-glass) {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
  border: 2px solid rgba(20, 184, 166, 0.25);
  color: #0D9488;
}

.landing-layout :deep(.btn-secondary-glass:hover) {
  background: rgba(20, 184, 166, 0.08);
  border-color: rgba(20, 184, 166, 0.4);
  color: #0F766E;
}

.landing-layout.dark :deep(.btn-secondary-glass) {
  background: rgba(15, 23, 42, 0.25);
  color: #5EEAD4;
  border-color: rgba(94, 234, 212, 0.25);
}

.landing-layout.dark :deep(.btn-secondary-glass:hover) {
  background: rgba(94, 234, 212, 0.08);
  border-color: rgba(94, 234, 212, 0.4);
  color: #7DD3FC;
}

/* Shimmer effect for buttons */
.landing-layout :deep(.btn-shimmer::before) {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
  transition: left 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.landing-layout :deep(.btn-shimmer:hover::before) {
  left: 100%;
}

/* Scroll-triggered animations */
.landing-layout :deep(.scroll-reveal) {
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.landing-layout :deep(.scroll-reveal.revealed) {
  opacity: 1;
  transform: translateY(0);
}

/* Staggered animation delays */
.landing-layout :deep(.stagger-1) { transition-delay: 0.1s; }
.landing-layout :deep(.stagger-2) { transition-delay: 0.2s; }
.landing-layout :deep(.stagger-3) { transition-delay: 0.3s; }
.landing-layout :deep(.stagger-4) { transition-delay: 0.4s; }

/* Floating animation for hero elements */
.landing-layout :deep(.float-animation) {
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}

/* Gradient text effect */
.landing-layout :deep(.gradient-text) {
  background: linear-gradient(135deg, #0D9488 0%, #0F766E 50%, #134E4A 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 700;
}

.landing-layout.dark :deep(.gradient-text) {
  background: linear-gradient(135deg, #5EEAD4 0%, #2DD4BF 50%, #14B8A6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Page entrance animation */
.page-enter {
  animation: pageSlideUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes pageSlideUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Parallax container */
.landing-layout :deep(.parallax-container) {
  transform-style: preserve-3d;
  perspective: 1000px;
}

.landing-layout :deep(.parallax-element) {
  transform: translateZ(0);
  transition: transform 0.1s ease-out;
}

/* Section spacing */
.landing-layout :deep(section) {
  padding: 5rem 0;
  position: relative;
}

@media (min-width: 768px) {
  .landing-layout :deep(section) {
    padding: 6rem 0;
  }
}

@media (min-width: 1024px) {
  .landing-layout :deep(section) {
    padding: 8rem 0;
  }
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .landing-layout :deep(.btn-pill) {
    padding: 12px 24px;
    font-size: 14px;
  }

  .landing-layout :deep(section) {
    padding: 3rem 0;
  }
}
</style>
