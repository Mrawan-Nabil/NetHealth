<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-lg p-5 border shadow-sm">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold mb-5">
      Medical Notes
    </h3>

    <div class="space-y-5">
      <!-- Physician Interpretation -->
      <div>
        <p class="text-[11px] font-bold uppercase tracking-wide mb-3 text-[#14B8A6]">
          Physician Interpretation
        </p>
        <div :class="isDark ? 'bg-[#334155]/30 border-[#14B8A6]/20' : 'bg-teal-50/50 border-[#14B8A6]/30'" class="border-l-4 border-[#14B8A6] rounded-r-lg p-3">
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] leading-relaxed italic mb-3">
            {{ notes.physicianInterpretation.text }}
          </p>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-[11px]">
            — {{ notes.physicianInterpretation.author }}
          </p>
        </div>
      </div>

      <!-- Patient Comments -->
      <div>
        <p class="text-[11px] font-bold uppercase tracking-wide mb-3" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'">
          Patient Comments
        </p>
        <div :class="isDark ? 'bg-[#334155]/30' : 'bg-[#F9FAFB]'" class="rounded-lg p-3">
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] leading-relaxed italic">
            {{ notes.patientComments.text }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  notes: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})
</script>
