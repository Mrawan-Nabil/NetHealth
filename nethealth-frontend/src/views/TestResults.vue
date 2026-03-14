<template>
  <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
    <!-- Sidebar -->
    <Sidebar 
      :is-dark="isDark"
      @toggle-theme="toggleTheme"
      @logout="handleLogout"
    />

    <!-- Main Content -->
    <div class="ml-64">
      <!-- Top Navbar -->
      <TopNavbar 
        title="Test Results"
        :is-dark="isDark"
        :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
        :notifications="[]"
        :show-last-viewed="true"
        :show-share="true"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-6">
        <!-- Breadcrumb -->
        <div class="mb-6">
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            <span class="text-gray-400">Medical Record</span>
            <span class="mx-2">/</span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Test Results</span>
          </p>
        </div>

        <!-- Tabs Navigation -->
        <TabsNavigation 
          :active-tab="'test-results'"
          :is-dark="isDark"
          @change="handleTabChange"
        />

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-2 gap-6">
          <div v-for="i in 4" :key="i" class="animate-pulse">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-48 rounded-xl skeleton"></div>
          </div>
        </div>

        <!-- Error State -->
        <div v-else-if="error" :class="isDark ? 'bg-red-500/10 border-red-500/20' : 'bg-red-50 border-red-200'" class="border rounded-lg p-6 text-center animate-fade-in">
          <svg class="w-12 h-12 mx-auto mb-4 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <p :class="isDark ? 'text-red-400' : 'text-red-600'" class="text-sm mb-4">{{ error }}</p>
          <button 
            @click="fetchTestResults"
            class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg text-sm font-medium transition-all duration-300 hover:scale-105 active:scale-95"
          >
            Try Again
          </button>
        </div>

        <!-- Test Results Grid -->
        <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div 
            v-for="(result, index) in testResults" 
            :key="result.id"
            class="animate-fade-in-up"
            :class="`stagger-${(index % 4) + 1}`"
          >
            <TestResultCard
              :test-result="result"
              :is-dark="isDark"
              @view-report="handleViewReport"
            />
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useDashboard } from '../composables/useDashboard'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import TabsNavigation from '../components/medical/TabsNavigation.vue'
import TestResultCard from '../components/medical/TestResultCard.vue'

const router = useRouter()
const { state, fetchTestResults, setTheme } = useDashboard()

// Computed properties
const isDark = computed(() => state.isDark)
const testResults = computed(() => state.testResults)
const loading = computed(() => state.loading.testResults)
const error = computed(() => state.errors.testResults)

// Methods
const toggleTheme = (theme) => {
  setTheme(theme)
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.push('/login')
  }
}

const handleTabChange = (tabId) => {
  if (tabId === 'prescription') {
    router.push('/medical-records')
  } else if (tabId === 'test-results') {
    router.push('/test-results')
  } else if (tabId === 'imaging') {
    router.push('/imaging')
  } else if (tabId === 'visit-history') {
    router.push('/visit-history')
  }
}

const handleViewReport = (testResult) => {
  console.log('Viewing report:', testResult)
  router.push(`/test-results/${testResult.id}`)
}

// Lifecycle
onMounted(() => {
  if (state.testResults.length === 0) {
    fetchTestResults()
  }
})
</script>
