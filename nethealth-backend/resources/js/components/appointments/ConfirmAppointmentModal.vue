<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
    isOpen: {
        type: Boolean,
        required: true
    },
    appointment: {
        type: Object,
        required: true
    },
    isDark: {
        type: Boolean,
        default: false
    }
})

const emit = defineEmits(['close', 'confirm'])

// State
const fileInput = ref(null)
const uploadedFiles = ref([])
const patientInfo = ref({
    fullName: '',
    phone: '',
    email: '',
    notes: ''
})

// Computed
const isFormValid = computed(() => {
    return patientInfo.value.fullName &&
        patientInfo.value.phone &&
        patientInfo.value.email
})

// Methods
const triggerFileUpload = () => {
    fileInput.value?.click()
}

const handleFileSelect = (event) => {
    const files = Array.from(event.target.files)
    uploadedFiles.value.push(...files)
}

const handleFileDrop = (event) => {
    const files = Array.from(event.dataTransfer.files)
    uploadedFiles.value.push(...files)
}

const removeFile = (index) => {
    uploadedFiles.value.splice(index, 1)
}

const handleConfirm = () => {
    if (!isFormValid.value) return

    emit('confirm', {
        patientInfo: patientInfo.value,
        files: uploadedFiles.value
    })

    // Reset form
    patientInfo.value = {
        fullName: '',
        phone: '',
        email: '',
        notes: ''
    }
    uploadedFiles.value = []
}
</script>

<template>
  <!-- Modal Overlay -->
  <div
    v-if="isOpen"
    class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
    @click.self="$emit('close')"
  >
    <!-- Modal Content -->
    <div
      :class="isDark ? 'bg-[#1E293B]' : 'bg-white'"
      class="rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl"
    >
      <!-- Header -->
      <div class="p-6 border-b" :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'">
        <div class="flex items-start justify-between">
          <div>
            <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-bold mb-1">
              Confirm Appointment
            </h2>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
              Review your booking details before proceeding.
            </p>
          </div>
          <button
            @click="$emit('close')"
            :class="isDark ? 'text-[#94A3B8] hover:text-[#F8FAFC]' : 'text-[#9CA3AF] hover:text-[#111827]'"
            class="transition-colors"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- Body -->
      <div class="p-6 space-y-6">
        <!-- Doctor & Schedule Info -->
        <div class="flex items-start gap-4">
          <!-- Doctor Avatar -->
          <img
            :src="appointment.doctor.avatar"
            alt="Doctor"
            class="w-16 h-16 rounded-xl object-cover"
          />

          <!-- Doctor Details -->
          <div class="flex-1">
            <div class="flex items-start justify-between">
              <div>
                <p class="text-[#14B8A6] text-xs font-semibold uppercase mb-1">DOCTOR</p>
                <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold mb-1">
                  {{ appointment.doctor.name }}
                </h3>
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                  {{ appointment.doctor.specialty }}
                </p>
              </div>

              <div class="text-right">
                <p class="text-[#14B8A6] text-xs font-semibold uppercase mb-1">SCHEDULE</p>
                <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
                  {{ appointment.date }}
                </p>
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                  {{ appointment.time }} • {{ appointment.type }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Patient Information -->
        <div>
          <div class="flex items-center gap-2 mb-4">
            <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
              Patient Information
            </h3>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <!-- Full Name -->
            <div>
              <label :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="block text-sm font-medium mb-2">
                Full Name
              </label>
              <input
                v-model="patientInfo.fullName"
                type="text"
                placeholder="e.g. John Doe"
                :class="[
                  'w-full px-4 py-2.5 rounded-lg border transition-colors',
                  isDark
                    ? 'bg-[#334155] border-[#475569] text-[#F8FAFC] placeholder-[#94A3B8]'
                    : 'bg-white border-[#E5E7EB] text-[#111827] placeholder-[#9CA3AF]'
                ]"
              />
            </div>

            <!-- Phone Number -->
            <div>
              <label :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="block text-sm font-medium mb-2">
                Phone Number
              </label>
              <input
                v-model="patientInfo.phone"
                type="tel"
                placeholder="(555) 000-0000"
                :class="[
                  'w-full px-4 py-2.5 rounded-lg border transition-colors',
                  isDark
                    ? 'bg-[#334155] border-[#475569] text-[#F8FAFC] placeholder-[#94A3B8]'
                    : 'bg-white border-[#E5E7EB] text-[#111827] placeholder-[#9CA3AF]'
                ]"
              />
            </div>

            <!-- Email Address -->
            <div class="col-span-2">
              <label :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="block text-sm font-medium mb-2">
                Email Address
              </label>
              <input
                v-model="patientInfo.email"
                type="email"
                placeholder="john.doe@example.com"
                :class="[
                  'w-full px-4 py-2.5 rounded-lg border transition-colors',
                  isDark
                    ? 'bg-[#334155] border-[#475569] text-[#F8FAFC] placeholder-[#94A3B8]'
                    : 'bg-white border-[#E5E7EB] text-[#111827] placeholder-[#9CA3AF]'
                ]"
              />
            </div>

            <!-- Optional Notes -->
            <div class="col-span-2">
              <label :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="block text-sm font-medium mb-2">
                Optional Notes
              </label>
              <textarea
                v-model="patientInfo.notes"
                rows="3"
                placeholder="Any specific concerns or history you'd like to mention..."
                :class="[
                  'w-full px-4 py-2.5 rounded-lg border transition-colors resize-none',
                  isDark
                    ? 'bg-[#334155] border-[#475569] text-[#F8FAFC] placeholder-[#94A3B8]'
                    : 'bg-white border-[#E5E7EB] text-[#111827] placeholder-[#9CA3AF]'
                ]"
              ></textarea>
            </div>
          </div>
        </div>

        <!-- Medical Records Upload -->
        <div>
          <div class="flex items-center gap-2 mb-4">
            <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
            </svg>
            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
              Medical Records
            </h3>
          </div>

          <!-- Upload Area -->
          <div
            :class="[
              'border-2 border-dashed rounded-lg p-8 text-center transition-colors cursor-pointer',
              isDark
                ? 'border-[#475569] hover:border-[#14B8A6] bg-[#334155]/30'
                : 'border-[#E5E7EB] hover:border-[#14B8A6] bg-[#F9FAFB]'
            ]"
            @click="triggerFileUpload"
            @dragover.prevent
            @drop.prevent="handleFileDrop"
          >
            <svg class="w-12 h-12 mx-auto mb-3 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
            </svg>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium mb-1">
              Click to upload or drag and drop
            </p>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs">
              Upload medical test results, X-rays, or reports
            </p>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs mt-1">
              PDF, JPG, or PNG (max. 10MB)
            </p>
            <input
              ref="fileInput"
              type="file"
              class="hidden"
              accept=".pdf,.jpg,.jpeg,.png"
              multiple
              @change="handleFileSelect"
            />
          </div>

          <!-- Uploaded Files -->
          <div v-if="uploadedFiles.length > 0" class="mt-3 space-y-2">
            <div
              v-for="(file, index) in uploadedFiles"
              :key="index"
              :class="[
                'flex items-center justify-between p-3 rounded-lg',
                isDark ? 'bg-[#334155]' : 'bg-[#F9FAFB]'
              ]"
            >
              <div class="flex items-center gap-3">
                <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
                  {{ file.name }}
                </span>
              </div>
              <button
                @click="removeFile(index)"
                :class="isDark ? 'text-[#94A3B8] hover:text-red-400' : 'text-[#9CA3AF] hover:text-red-600'"
                class="transition-colors"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="p-6 border-t" :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'">
        <div class="flex items-center justify-end gap-3">
          <button
            @click="$emit('close')"
            :class="[
              'px-6 py-2.5 rounded-lg text-sm font-semibold transition-colors',
              isDark
                ? 'bg-[#334155] text-[#F8FAFC] hover:bg-[#475569]'
                : 'bg-[#F3F4F6] text-[#111827] hover:bg-[#E5E7EB]'
            ]"
          >
            Cancel
          </button>
          <button
            @click="handleConfirm"
            :disabled="!isFormValid"
            :class="[
              'px-6 py-2.5 rounded-lg text-sm font-semibold transition-colors flex items-center gap-2',
              isFormValid
                ? 'bg-[#14B8A6] hover:bg-[#0F9B8E] text-white'
                : isDark
                  ? 'bg-[#334155] text-[#64748B] cursor-not-allowed'
                  : 'bg-[#F3F4F6] text-[#9CA3AF] cursor-not-allowed'
            ]"
          >
            Confirm Booking
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>


