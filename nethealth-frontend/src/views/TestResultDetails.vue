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
        title="Test Result Details"
        :is-dark="isDark"
        :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
        :notifications="[]"
        :show-last-viewed="true"
        :show-share="true"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-6">
        <!-- Loading State -->
        <div v-if="loading" class="space-y-6">
          <div class="animate-pulse">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-8 w-64 rounded mb-4"></div>
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-64 rounded-lg"></div>
          </div>
        </div>

        <!-- Error State -->
        <div v-else-if="error" :class="isDark ? 'bg-red-500/10 border-red-500/20' : 'bg-red-50 border-red-200'" class="border rounded-lg p-6 text-center">
          <p :class="isDark ? 'text-red-400' : 'text-red-600'" class="text-sm">{{ error }}</p>
        </div>

        <!-- Content -->
        <div v-else>
          <!-- Breadcrumb -->
          <div class="mb-6">
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
              <router-link to="/medical-records" class="hover:text-[#14B8A6] transition-colors">Medical Record</router-link>
              <span class="mx-2">/</span>
              <router-link to="/test-results" class="hover:text-[#14B8A6] transition-colors">Test Result</router-link>
              <span class="mx-2">/</span>
              <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Test Result Details</span>
            </p>
          </div>

          <!-- Tabs Navigation -->
          <TabsNavigation 
            :active-tab="'test-results'"
            :is-dark="isDark"
            @change="handleTabChange"
          />

          <!-- Page Header -->
          <div class="flex items-start justify-between mb-6">
            <div>
              <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
                Test Report Details
              </h1>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                Detailed breakdown of your laboratory findings from October 2025.
              </p>
            </div>
            
            <div class="flex items-center gap-3">
              <button 
                @click="handleBackToTestResults"
                :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#E5E7EB] text-[#111827] hover:bg-[#F8FAFC]'"
                class="px-4 py-2 border rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-2"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                </svg>
                Back to Test Result
              </button>
              <button 
                @click="handlePrint"
                :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#E5E7EB] text-[#111827] hover:bg-[#F8FAFC]'"
                class="px-4 py-2 border rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-2"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
                </svg>
                Print
              </button>
              <button 
                @click="handleDownloadPDF"
                :class="isDark ? 'bg-[#14B8A6] hover:bg-[#2DD4BF] shadow-lg shadow-teal-500/20' : 'bg-[#14B8A6] hover:bg-[#0D9488]'"
                class="px-4 py-2 text-white rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-2"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                </svg>
                Download PDF
              </button>
            </div>
          </div>

          <!-- Test Info Card - Horizontal Layout -->
          <div class="mb-6">
            <TestInfoCardHorizontal :test-info="testResult.testInfo" :is-dark="isDark" />
          </div>

          <!-- Results Analysis Table -->
          <div class="mb-6">
            <TestResultsTable :results="testResult.results" :is-dark="isDark" />
          </div>

          <!-- Bottom Grid: Doctor Notes & Attachments -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <DoctorInterpretationCard 
              :interpretation="testResult.interpretation" 
              :doctor="testResult.doctor"
              :is-dark="isDark"
            />
            <AttachmentsCard 
              :attachments="testResult.attachments" 
              :is-dark="isDark"
              @download="handleDownloadAttachment"
            />
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import TabsNavigation from '../components/medical/TabsNavigation.vue'
import TestInfoCardHorizontal from '../components/testresult/TestInfoCardHorizontal.vue'
import TestResultsTable from '../components/testresult/TestResultsTable.vue'
import DoctorInterpretationCard from '../components/testresult/DoctorInterpretationCard.vue'
import AttachmentsCard from '../components/prescription/AttachmentsCard.vue'

const router = useRouter()
const route = useRoute()

// State
const isDark = ref(false)
const testResult = ref({})
const loading = ref(true)
const error = ref(null)

// Methods
const toggleTheme = (theme) => {
  isDark.value = theme === 'dark'
  localStorage.setItem('theme', theme)
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
  }
}

const handleBackToTestResults = () => {
  router.push('/test-results')
}

const fetchTestResultDetails = async () => {
  loading.value = true
  error.value = null
  
  try {
    // Uncomment to use real API
    // import { dashboardAPI } from '../services/api.js'
    // const response = await dashboardAPI.getTestResult(route.params.id)
    // testResult.value = response.data
    
    // Using dummy data
    await new Promise(resolve => setTimeout(resolve, 500))
    testResult.value = getDummyTestResult()
  } catch (err) {
    console.error('Error fetching test result:', err)
    error.value = 'Failed to load test result details. Please try again.'
    testResult.value = getDummyTestResult()
  } finally {
    loading.value = false
  }
}

const getDummyTestResult = () => ({
  id: route.params.id || 1,
  generatedDate: 'Oct 24, 2025',
  testInfo: {
    name: 'Full Blood Count (FBC)',
    lab: 'City General Laboratory',
    date: '2025-10-24',
    status: 'AVAILABLE'
  },
  results: [
    {
      parameter: 'Hemoglobin',
      value: '14.2',
      unit: 'g/dL',
      range: '13.5 - 17.5',
      status: 'Normal'
    },
    {
      parameter: 'White Blood Cell Count',
      value: '11.5',
      unit: 'x10⁹/L',
      range: '4.5 - 11.0',
      status: 'High'
    },
    {
      parameter: 'Platelets',
      value: '250',
      unit: 'x10⁹/L',
      range: '150 - 450',
      status: 'Normal'
    },
    {
      parameter: 'Iron',
      value: '12.0',
      unit: 'µmol/L',
      range: '14.0 - 32.0',
      status: 'Low'
    }
  ],
  interpretation: '"Your white blood cell count is slightly elevated, suggesting a minor infection. Please continue the prescribed antibiotics and re-test in two weeks. Ensure you stay hydrated and monitor for any fever symptoms."',
  doctor: {
    name: 'Dr. Mitchell',
    avatar: 'https://i.pravatar.cc/150?img=45',
    signedDate: 'Oct 25, 2025'
  },
  attachments: [
    { name: 'Full_Blood_Count_Report.pdf', size: '2.4 MB' },
    { name: 'Lab_Imaging_Platelets.jpg', size: '1.1 MB' }
  ]
})

const handlePrint = () => {
  window.print()
}

const handleDownloadPDF = () => {
  console.log('Downloading PDF...')
  alert('PDF download functionality will be implemented with backend integration')
}

const handleDownloadAttachment = (file) => {
  console.log('Downloading attachment:', file)
  alert(`Downloading ${file.name}`)
}

// Lifecycle
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  }
  fetchTestResultDetails()
})
</script>
