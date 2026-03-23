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
        title="Medical Record"
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
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
            <Link href="/medical-records" class="hover:text-[#14B8A6] transition-colors">Medical Record</Link>
            <span class="mx-2">/</span>
            <Link href="/imaging" class="hover:text-[#14B8A6] transition-colors">Imaging</Link>
            <span class="mx-2">/</span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Chest CT</span>
          </p>
        </div>

        <!-- Tabs Navigation -->
        <TabsNavigation 
          :active-tab="'imaging'"
          :is-dark="isDark"
          @change="handleTabChange"
        />

        <!-- Page Header -->
        <div class="flex items-start justify-between mb-6">
          <div>
            <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
              Chest CT Scan
            </h1>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
              Uploaded on Oct 14, 2024 • ID: IMG-90244-X
            </p>
          </div>
          
          <div class="flex items-center gap-3">
            <button 
              @click="handleBackToImaging"
              :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'"
              class="px-4 py-2 border rounded-lg text-sm font-semibold transition-colors flex items-center gap-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
              </svg>
              Back to Imaging List
            </button>
            <button 
              @click="handlePrint"
              :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'"
              class="px-4 py-2 border rounded-lg text-sm font-semibold transition-colors flex items-center gap-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
              </svg>
              Print
            </button>
            <button 
              @click="handleDownloadPDF"
              class="px-4 py-2 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center gap-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
              </svg>
              Download PDF
            </button>
          </div>
        </div>

        <!-- Main Content Grid -->
        <div v-if="!loading" class="grid grid-cols-12 gap-6">
          <!-- Left Column - Info Cards -->
          <div class="col-span-4 space-y-6">
            <!-- File Information Card -->
            <FileInformationCard :file-info="imagingData.fileInfo" :is-dark="isDark" />
            
            <!-- Medical Notes Card -->
            <MedicalNotesCard :notes="imagingData.notes" :is-dark="isDark" />
          </div>

          <!-- Right Column - DICOM Viewer -->
          <div class="col-span-8">
            <DicomViewer :images="imagingData.images" :is-dark="isDark" />
          </div>
        </div>

        <!-- Loading State -->
        <div v-else class="grid grid-cols-12 gap-6">
          <div class="col-span-4 space-y-6">
            <div class="animate-pulse">
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-64 rounded-lg"></div>
            </div>
            <div class="animate-pulse">
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-96 rounded-lg"></div>
            </div>
          </div>
          <div class="col-span-8">
            <div class="animate-pulse">
              <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-[600px] rounded-lg"></div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { router, Link } from '@inertiajs/vue3'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import TabsNavigation from '../components/medical/TabsNavigation.vue'
import FileInformationCard from '../components/imaging/FileInformationCard.vue'
import MedicalNotesCard from '../components/imaging/MedicalNotesCard.vue'
import DicomViewer from '../components/imaging/DicomViewer.vue'

// Using Inertia router instead
// ID from URL parsing or props

// State
const isDark = ref(false)
const loading = ref(true)
const imagingData = ref({
  fileInfo: {
    type: '',
    size: '',
    physician: '',
    radiologyCenter: '',
    scanDate: '',
    format: ''
  },
  notes: {
    physicianInterpretation: {
      text: '',
      author: ''
    },
    patientComments: {
      text: ''
    }
  },
  images: []
})

// Methods
const toggleTheme = (theme) => {
  isDark.value = theme === 'dark'
  localStorage.setItem('theme', theme)
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.get('/logout')
  }
}

const handleTabChange = (tabId) => {
  if (tabId === 'prescription') {
    router.get('/medical-records')
  } else if (tabId === 'test-results') {
    router.get('/test-results')
  } else if (tabId === 'imaging') {
    router.get('/imaging')
  }
}

const handleBackToImaging = () => {
  router.get('/imaging')
}

const handlePrint = () => {
  window.print()
}

const handleDownloadPDF = () => {
  alert('Downloading PDF...')
}

// Lifecycle
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  }
  
  // Load imaging data
  imagingData.value = {
    fileInfo: {
      type: 'CT Scan',
      size: '12.4 MB',
      physician: 'Dr. Sarah Mitchell',
      radiologyCenter: 'City General Hospital',
      scanDate: 'Oct 12, 2024',
      format: 'DICOM/PDF'
    },
    notes: {
      physicianInterpretation: {
        text: '"Clear visualization of pulmonary structures. No signs of infection or abnormal masses detected. Recommended follow-up in 6 months for routine observation."',
        author: 'Dr. Sarah Mitchell, Lead Radiologist'
      },
      patientComments: {
        text: '"Feeling much better after the medication adjustment. No more chest pain during deep breathing."'
      }
    },
    images: [
      { id: 1, url: '/chest-ct-1.jpg', active: true },
      { id: 2, url: '/chest-ct-2.jpg', active: false },
      { id: 3, url: '/chest-ct-3.jpg', active: false }
    ]
  }
  
  loading.value = false
})
</script>
