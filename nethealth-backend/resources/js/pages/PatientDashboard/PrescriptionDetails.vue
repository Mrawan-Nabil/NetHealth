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
        title="Prescription Details"
        :is-dark="isDark"
        :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
        :notifications="[]"
        :show-last-viewed="false"
        :show-share="false"
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
          <!-- Breadcrumb & Header -->
          <div class="mb-6">
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-4">
              <Link href="/medical-records" class="hover:text-[#14B8A6] transition-colors">Medical Record</Link>
              <span class="mx-2">/</span>
              <Link href="/medical-records" class="hover:text-[#14B8A6] transition-colors">Prescription</Link>
              <span class="mx-2">/</span>
              <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Prescription Details</span>
            </p>
            
            <div class="flex items-start justify-between">
              <div>
                <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
                  Prescription Details
                </h1>
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                  Generated on {{ prescription.generatedDate }}
                </p>
              </div>
              
              <div class="flex items-center gap-3">
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
          </div>

          <!-- Doctor Card -->
          <div class="mb-6">
            <DoctorCard :doctor="prescription.doctor" :is-dark="isDark" />
          </div>

          <!-- Patient Information -->
          <div class="mb-6">
            <PatientInfoCard :patient="prescription.patient" :is-dark="isDark" />
          </div>

          <!-- Diagnosis -->
          <div class="mb-6">
            <DiagnosisCard :diagnosis="prescription.diagnosis" :is-dark="isDark" />
          </div>

          <!-- Medicines Table -->
          <div class="mb-6">
            <MedicinesTable :medicines="prescription.medicines" :is-dark="isDark" />
          </div>

          <!-- Bottom Grid: Notes & Attachments -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <NotesCard :notes="prescription.notes" :is-dark="isDark" />
            <AttachmentsCard 
              :attachments="prescription.attachments" 
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
import { router, Link } from '@inertiajs/vue3'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import DoctorCard from '../components/prescription/DoctorCard.vue'
import PatientInfoCard from '../components/prescription/PatientInfoCard.vue'
import DiagnosisCard from '../components/prescription/DiagnosisCard.vue'
import MedicinesTable from '../components/prescription/MedicinesTable.vue'
import NotesCard from '../components/prescription/NotesCard.vue'
import AttachmentsCard from '../components/prescription/AttachmentsCard.vue'

// Using Inertia router instead
// ID from URL parsing or props

// State
const isDark = ref(false)
const prescription = ref({})
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
    router.get('/logout')
  }
}

const fetchPrescriptionDetails = async () => {
  loading.value = true
  error.value = null
  
  try {
    // Uncomment to use real API
    // import { dashboardAPI } from '../services/api.js'
    // const response = await dashboardAPI.getPrescription(window.location.pathname.split('/').pop())
    // prescription.value = response.data
    
    // Using dummy data
    await new Promise(resolve => setTimeout(resolve, 500))
    prescription.value = getDummyPrescription()
  } catch (err) {
    console.error('Error fetching prescription:', err)
    error.value = 'Failed to load prescription details. Please try again.'
    prescription.value = getDummyPrescription()
  } finally {
    loading.value = false
  }
}

const getDummyPrescription = () => ({
  id: window.location.pathname.split('/').pop() || 1,
  generatedDate: 'October 24, 2025',
  doctor: {
    name: 'Dr. Mohamed Barakat',
    credentials: 'MD, MRCP - Cardiologist & Internal Medicine Specialist',
    license: '12345',
    phone: '+1 234 567 890',
    status: 'ACTIVE',
    clinicAddress: '452 Medical Plaza, Suite 200\nHeart & Vascular Center\nSan Francisco, CA 94107',
    avatar: 'https://i.pravatar.cc/150?img=33'
  },
  patient: {
    name: 'Ahmed Yahia',
    gender: 'Male',
    age: '34',
    id: '#PT-00041782'
  },
  diagnosis: {
    title: 'Hypertension (Essential), Stage 1 — ICD-10: I10',
    description: 'Patient presents with persistently elevated blood pressure readings averaging 148/92 mmHg over a 4-week monitoring period.'
  },
  medicines: [
    {
      name: 'Lisinopril',
      type: 'ACE Inhibitor',
      dosage: '10 mg',
      frequency: 'Once daily',
      duration: '30 Days',
      instructions: 'Take in the morning before food'
    },
    {
      name: 'Atorvastatin',
      type: 'Statin',
      dosage: '20 mg',
      frequency: 'Once daily',
      duration: '90 Days',
      instructions: 'Take at bedtime'
    },
    {
      name: 'Aspirin (Low Dose)',
      type: 'Antiplatelet',
      dosage: '81 mg',
      frequency: 'Once daily',
      duration: 'Indefinite',
      instructions: 'Take with main meal'
    }
  ],
  notes: [
    'Maintain a low-sodium diet (less than 2,300mg per day)',
    'Moderate aerobic exercise for 30 minutes, 5 days per week',
    'Monitor blood pressure daily and keep a log',
    'Avoid excessive alcohol consumption',
    'Schedule follow-up appointment in 4 weeks'
  ],
  attachments: [
    { name: 'ECG_Results_Oct24.pdf', size: '2.4 MB' },
    { name: 'Chest_XRay_Image.jpg', size: '1.8 MB' },
    { name: 'Blood_Test_Results.pdf', size: '856 KB' }
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
  fetchPrescriptionDetails()
})
</script>
