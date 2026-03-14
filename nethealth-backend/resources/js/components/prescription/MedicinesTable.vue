<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-4">
      Prescribed Medicines
    </h3>
    
    <div class="overflow-x-auto">
      <table class="w-full">
        <thead>
          <tr :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="border-b">
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-left py-3 px-4 text-xs font-semibold uppercase">Medicine Name</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-left py-3 px-4 text-xs font-semibold uppercase">Dosage</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-left py-3 px-4 text-xs font-semibold uppercase">Frequency</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-left py-3 px-4 text-xs font-semibold uppercase">Duration</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-left py-3 px-4 text-xs font-semibold uppercase">Instructions</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="(medicine, index) in medicines" 
            :key="index"
            :class="isDark ? 'border-[#334155] hover:bg-[#334155]/20' : 'border-[#E5E7EB] hover:bg-[#F8FAFC]'"
            class="border-b last:border-b-0 transition-colors duration-200"
          >
            <td :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="py-4 px-4">
              <div class="font-medium text-sm">{{ medicine.name }}</div>
              <div :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs mt-0.5">{{ medicine.type }}</div>
            </td>
            <td :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="py-4 px-4 text-sm">{{ medicine.dosage }}</td>
            <td :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="py-4 px-4 text-sm">{{ medicine.frequency }}</td>
            <td :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="py-4 px-4 text-sm">{{ medicine.duration }}</td>
            <td :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="py-4 px-4 text-sm">{{ medicine.instructions }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
defineProps({
  medicines: {
    type: Array,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})
</script>
