<script setup>
// Importing all the landing page pieces Cursor just made
import DoctorsSection from '../components/landing/DoctorsSection.vue'
import FeaturesSection from '../components/landing/FeaturesSection.vue'
import Footer from '../components/landing/Footer.vue'
import HeroSection from '../components/landing/HeroSection.vue'
import HowItWorksSection from '../components/landing/HowItWorksSection.vue'
import Navbar from '../components/landing/Navbar.vue'
import ProvidersSection from '../components/landing/ProvidersSection.vue'
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
