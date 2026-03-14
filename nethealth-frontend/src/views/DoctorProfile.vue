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
        title="Doctor Profile"
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
            <router-link to="/appointments/create" class="hover:text-[#14B8A6] transition-colors">Doctors</router-link>
            <span class="mx-2">/</span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Dr. Ayman Fathy</span>
          </p>
        </div>

        <!-- Doctor Profile Card -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-6 mb-6">
          <div class="flex items-start justify-between mb-6">
            <div class="flex items-start gap-6">
              <!-- Doctor Image -->
              <div class="relative">
                <img 
                  src="https://i.pravatar.cc/200?img=33" 
                  alt="Doctor"
                  class="w-32 h-32 rounded-xl object-cover"
                />
                <div class="absolute -bottom-2 -right-2 w-10 h-10 bg-[#14B8A6] rounded-full flex items-center justify-center">
                  <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                  </svg>
                </div>
              </div>

              <!-- Doctor Info -->
              <div>
                <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-2">
                  Dr/ Ayman Fathy
                </h1>
                <p class="text-[#14B8A6] text-base font-medium mb-3">
                  Cardiologist • City Heart Institute
                </p>
                
                <div class="flex items-center gap-6 mb-4">
                  <div class="flex items-center gap-1">
                    <svg class="w-5 h-5 text-[#F59E0B]" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                    </svg>
                    <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">4.9</span>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">(120 reviews)</span>
                  </div>
                  
                  <div class="flex items-center gap-2">
                    <svg class="w-5 h-5" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">12 Years Experience</span>
                  </div>
                </div>

                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm leading-relaxed max-w-2xl">
                  Dr. Ayman Fathy is a board-certified cardiologist at City Heart Institute with over 12 years of experience specializing in preventive cardiology, cardiovascular diagnostics, and advanced heart failure management.
                </p>

                <div class="flex items-center gap-2 mt-4">
                  <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                  </svg>
                  <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                    City Heart Institute, Medical Center Plaza
                  </span>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex items-center gap-3">
              <button :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#334155]' : 'border-[#E5E7EB] text-[#111827] hover:bg-[#F9FAFB]'" class="px-4 py-2 border rounded-lg text-sm font-semibold transition-colors flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"/>
                </svg>
                Share
              </button>
              <button class="px-4 py-2 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg text-sm font-semibold transition-colors flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                </svg>
                Favorite
              </button>
            </div>
          </div>

          <!-- Consultation Fee -->
          <div class="flex items-center justify-end">
            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mr-2">Consultation Fee:</span>
            <span class="text-[#14B8A6] text-xl font-bold">$100</span>
          </div>
        </div>

        <!-- Info Cards -->
        <div class="grid grid-cols-4 gap-4 mb-6">
          <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-4 text-center">
            <svg class="w-8 h-8 mx-auto mb-2 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
            </svg>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs uppercase mb-1">NEXT AVAILABLE</p>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">Tomorrow</p>
          </div>

          <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-4 text-center">
            <svg class="w-8 h-8 mx-auto mb-2 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs uppercase mb-1">CONSULTATION</p>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">$100.00</p>
          </div>

          <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-4 text-center">
            <svg class="w-8 h-8 mx-auto mb-2 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
            </svg>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs uppercase mb-1">EXPERIENCE</p>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">12+ Years</p>
          </div>

          <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-4 text-center">
            <svg class="w-8 h-8 mx-auto mb-2 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2M7 20H5a2 2 0 01-2-2v-6a2 2 0 012-2h2.5"/>
            </svg>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs uppercase mb-1">RATING</p>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">4.9 / 5.0</p>
          </div>
        </div>

        <!-- Booking Section -->
        <div class="grid grid-cols-12 gap-6">
          <!-- Left: Schedule -->
          <div class="col-span-7">
            <!-- Available Days -->
            <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-6 mb-6">
              <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
                Available Days
              </h3>
              <div class="flex items-center gap-3">
                <button
                  v-for="day in days"
                  :key="day.id"
                  @click="selectedDay = day.id"
                  :class="[
                    'px-6 py-2.5 rounded-lg text-sm font-semibold transition-colors',
                    selectedDay === day.id
                      ? 'bg-[#14B8A6] text-white'
                      : day.disabled
                        ? isDark
                          ? 'bg-[#334155] text-[#64748B] cursor-not-allowed'
                          : 'bg-[#F3F4F6] text-[#9CA3AF] cursor-not-allowed'
                        : isDark
                          ? 'bg-[#334155] text-[#F8FAFC] hover:bg-[#475569]'
                          : 'bg-white border border-[#E5E7EB] text-[#111827] hover:bg-[#F9FAFB]'
                  ]"
                  :disabled="day.disabled"
                >
                  {{ day.name }}
                </button>
              </div>
            </div>

            <!-- Time Slots -->
            <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-6">
              <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
                Available Time Slots - {{ days.find(d => d.id === selectedDay)?.name }}
              </h3>
              <div class="grid grid-cols-3 gap-3">
                <button
                  v-for="slot in timeSlots"
                  :key="slot.id"
                  @click="selectedSlot = slot.id"
                  :class="[
                    'px-4 py-3 rounded-lg text-sm font-semibold transition-colors',
                    selectedSlot === slot.id
                      ? 'bg-[#14B8A6] text-white border-2 border-[#14B8A6]'
                      : isDark
                        ? 'bg-[#334155] text-[#F8FAFC] hover:bg-[#475569] border-2 border-transparent'
                        : 'bg-white border-2 border-[#E5E7EB] text-[#111827] hover:bg-[#F9FAFB]'
                  ]"
                >
                  {{ slot.time }}
                </button>
              </div>
            </div>
          </div>

          <!-- Right: Appointment Type -->
          <div class="col-span-5">
            <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-6">
              <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
                Appointment Type
              </h3>
              <div class="space-y-3">
                <button
                  v-for="type in appointmentTypes"
                  :key="type.id"
                  @click="selectedType = type.id"
                  :class="[
                    'w-full p-4 rounded-xl text-left transition-all flex items-start gap-3',
                    selectedType === type.id
                      ? 'bg-[#14B8A6]/10 border-2 border-[#14B8A6]'
                      : isDark
                        ? 'bg-[#334155] border-2 border-transparent hover:border-[#475569]'
                        : 'bg-white border-2 border-[#E5E7EB] hover:border-[#D1D5DB]'
                  ]"
                >
                  <div v-html="type.icon" class="flex-shrink-0 mt-0.5"></div>
                  <div class="flex-1">
                    <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">
                      {{ type.name }}
                    </h4>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">
                      {{ type.description }}
                    </p>
                  </div>
                  <div class="flex-shrink-0">
                    <div :class="[
                      'w-5 h-5 rounded-full border-2 flex items-center justify-center',
                      selectedType === type.id
                        ? 'border-[#14B8A6] bg-[#14B8A6]'
                        : isDark
                          ? 'border-[#475569]'
                          : 'border-[#D1D5DB]'
                    ]">
                      <svg v-if="selectedType === type.id" class="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/>
                      </svg>
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Appointment Summary & Confirm -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="border rounded-xl p-6 mt-6 flex items-center justify-between">
          <div>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs uppercase mb-1">Appointment Summary</p>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
              {{ appointmentSummary }}
            </p>
          </div>
          <button 
            @click="handleConfirmAppointment"
            :disabled="!selectedDay || !selectedSlot || !selectedType"
            :class="[
              'px-6 py-3 rounded-lg text-sm font-semibold transition-colors flex items-center gap-2',
              selectedDay && selectedSlot && selectedType
                ? 'bg-[#14B8A6] hover:bg-[#0F9B8E] text-white'
                : isDark
                  ? 'bg-[#334155] text-[#64748B] cursor-not-allowed'
                  : 'bg-[#F3F4F6] text-[#9CA3AF] cursor-not-allowed'
            ]"
          >
            Confirm Appointment
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
            </svg>
          </button>
        </div>
      </main>
    </div>

    <!-- Confirm Appointment Modal -->
    <ConfirmAppointmentModal
      :is-open="showConfirmModal"
      :appointment="appointmentData"
      :is-dark="isDark"
      @close="handleModalClose"
      @confirm="handleModalConfirm"
    />

    <!-- Success Modal -->
    <AppointmentSuccessModal
      :is-open="showSuccessModal"
      :appointment="appointmentData"
      :uploaded-files="bookingData?.files || []"
      :is-dark="isDark"
      @close="() => showSuccessModal = false"
      @view-appointments="handleViewAppointments"
      @back-to-dashboard="handleBackToDashboard"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import ConfirmAppointmentModal from '../components/appointments/ConfirmAppointmentModal.vue'
import AppointmentSuccessModal from '../components/appointments/AppointmentSuccessModal.vue'

const router = useRouter()
const route = useRoute()

// State
const isDark = ref(false)
const selectedDay = ref('monday')
const selectedSlot = ref(null)
const selectedType = ref(null)
const showConfirmModal = ref(false)
const showSuccessModal = ref(false)
const bookingData = ref(null)

const days = [
  { id: 'monday', name: 'Monday', disabled: false },
  { id: 'tuesday', name: 'Tuesday', disabled: false },
  { id: 'wednesday', name: 'Wednesday', disabled: false },
  { id: 'thursday', name: 'Thursday', disabled: true },
  { id: 'friday', name: 'Friday', disabled: false }
]

const timeSlots = [
  { id: '9:00', time: '9:00 AM' },
  { id: '9:30', time: '9:30 AM' },
  { id: '10:00', time: '10:00 AM' },
  { id: '11:30', time: '11:30 AM' },
  { id: '2:00', time: '2:00 PM' },
  { id: '3:00', time: '3:00 PM' }
]

const appointmentTypes = [
  {
    id: 'clinic',
    name: 'Clinic Visit',
    description: 'In-person consultation',
    icon: '<svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>'
  },
  {
    id: 'online',
    name: 'Online Medical Consultation',
    description: 'Online Lab & Imaging Consultation',
    icon: '<svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>'
  },
  {
    id: 'followup',
    name: 'Follow-up Visit',
    description: 'Routine check-up',
    icon: '<svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>'
  }
]

// Computed
const appointmentSummary = computed(() => {
  if (!selectedDay || !selectedSlot || !selectedType) {
    return 'Please select day, time, and appointment type'
  }
  
  const day = days.find(d => d.id === selectedDay)
  const slot = timeSlots.find(s => s.id === selectedSlot)
  const type = appointmentTypes.find(t => t.id === selectedType)
  
  if (!day || !slot || !type) {
    return 'Please select day, time, and appointment type'
  }
  
  return `Mon, 22 Oct • ${slot.time} • ${type.name}`
})

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

const handleConfirmAppointment = () => {
  if (!selectedDay.value || !selectedSlot.value || !selectedType.value) {
    return
  }
  
  showConfirmModal.value = true
}

const handleModalConfirm = (data) => {
  console.log('Booking confirmed:', data)
  bookingData.value = data
  showConfirmModal.value = false
  showSuccessModal.value = true
}

const handleModalClose = () => {
  showConfirmModal.value = false
}

const handleViewAppointments = () => {
  showSuccessModal.value = false
  router.push('/appointments')
}

const handleBackToDashboard = () => {
  showSuccessModal.value = false
  router.push('/dashboard')
}

// Computed for modal data
const appointmentData = computed(() => {
  const day = days.find(d => d.id === selectedDay.value)
  const slot = timeSlots.find(s => s.id === selectedSlot.value)
  const type = appointmentTypes.find(t => t.id === selectedType.value)
  
  return {
    doctor: {
      name: 'Dr. Ayman Fathy',
      specialty: 'Cardiologist',
      avatar: 'https://i.pravatar.cc/200?img=33'
    },
    date: 'Monday, Oct 22',
    time: slot?.time || '',
    type: type?.name || ''
  }
})

// Lifecycle
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  }
})
</script>
