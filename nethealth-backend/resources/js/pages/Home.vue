<script setup>
// Importing all the landing page pieces Cursor just made
import Navbar from '../components/landing/Navbar.vue'
import HeroSection from '../components/landing/HeroSection.vue'
import FeaturesSection from '../components/landing/FeaturesSection.vue'
import HowItWorksSection from '../components/landing/HowItWorksSection.vue'
import DoctorsSection from '../components/landing/DoctorsSection.vue'
import ProvidersSection from '../components/landing/ProvidersSection.vue'
import Footer from '../components/landing/Footer.vue'
</script>

<template>
  <div class="min-h-screen flex flex-col font-sans">
    <Navbar />

    <main class="grow">
      <HeroSection />
      <FeaturesSection />
      <HowItWorksSection />
      <DoctorsSection />
      <ProvidersSection />
    </main>

    <Footer />
  </div>
</template>