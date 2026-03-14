<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-lg p-5 border shadow-sm">
    <div class="flex items-center justify-between mb-5">
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
        File Information
      </h3>
      <span class="px-2.5 py-1 bg-[#CCFBF1] text-[#14B8A6] rounded text-[10px] font-bold uppercase tracking-wide">
        Final Report
      </span>
    </div>

    <div class="space-y-4">
      <!-- Type & Size -->
      <div class="grid grid-cols-2 gap-4">
        <div>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1.5">
            Type
          </p>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ fileInfo.type }}
          </p>
        </div>
        <div>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1.5">
            Size
          </p>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ fileInfo.size }}
          </p>
        </div>
      </div>

      <!-- Physician -->
      <div>
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1.5">
          Physician
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
          {{ fileInfo.physician }}
        </p>
      </div>

      <!-- Radiology Center -->
      <div>
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1.5">
          Radiology Center
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
          {{ fileInfo.radiologyCenter }}
        </p>
      </div>

      <!-- Scan Date & Format -->
      <div class="grid grid-cols-2 gap-4">
        <div>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1.5">
            Scan Date
          </p>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ fileInfo.scanDate }}
          </p>
        </div>
        <div>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1.5">
            Format
          </p>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
            {{ fileInfo.format }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  fileInfo: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})
</script>
