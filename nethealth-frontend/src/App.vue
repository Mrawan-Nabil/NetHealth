<script setup>
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import { useDashboard } from './composables/useDashboard'

const { initializeTheme } = useDashboard()

onMounted(() => {
  initializeTheme()
})
</script>

<template>
  <router-view />
</template>

<style scoped>
/* Minimal page transitions for better performance */
</style>
