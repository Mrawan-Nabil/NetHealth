<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <div class="flex items-center justify-between mb-6">
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">
        Results Analysis
      </h3>
      
      <!-- Legend -->
      <div class="flex items-center gap-4">
        <div class="flex items-center gap-1.5">
          <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
          <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">Normal</span>
        </div>
        <div class="flex items-center gap-1.5">
          <span class="w-2 h-2 rounded-full bg-orange-500"></span>
          <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">Attention</span>
        </div>
        <div class="flex items-center gap-1.5">
          <span class="w-2 h-2 rounded-full bg-red-500"></span>
          <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">Critical</span>
        </div>
      </div>
    </div>
    
    <div class="overflow-x-auto">
      <table class="w-full">
        <thead>
          <tr :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="border-b">
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-left py-3 px-4 text-xs font-semibold uppercase">Parameter</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-center py-3 px-4 text-xs font-semibold uppercase">Result</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-center py-3 px-4 text-xs font-semibold uppercase">Unit</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-center py-3 px-4 text-xs font-semibold uppercase">Reference Range</th>
            <th :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-center py-3 px-4 text-xs font-semibold uppercase">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="(result, index) in results" 
            :key="index"
            :class="isDark ? 'border-[#334155] hover:bg-[#334155]/20' : 'border-[#E5E7EB] hover:bg-[#F8FAFC]'"
            class="border-b last:border-b-0 transition-colors duration-200"
          >
            <td :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="py-4 px-4 font-medium text-sm">
              {{ result.parameter }}
            </td>
            <td :class="[isDark ? 'text-[#F8FAFC]' : 'text-[#111827]', getResultColor(result.status)]" class="py-4 px-4 text-center text-sm font-bold">
              {{ result.value }}
            </td>
            <td :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="py-4 px-4 text-center text-sm">
              {{ result.unit }}
            </td>
            <td :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="py-4 px-4 text-center text-sm">
              {{ result.range }}
            </td>
            <td class="py-4 px-4 text-center">
              <span :class="getStatusClasses(result.status)" class="inline-flex items-center gap-1.5 text-sm font-medium">
                <span v-html="getStatusIcon(result.status)"></span>
                {{ result.status }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  results: {
    type: Array,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const getResultColor = (status) => {
  const statusLower = status.toLowerCase()
  if (statusLower === 'high') return 'text-orange-600'
  if (statusLower === 'low') return 'text-red-600'
  return ''
}

const getStatusClasses = (status) => {
  const statusLower = status.toLowerCase()
  if (statusLower === 'normal') return 'text-emerald-600'
  if (statusLower === 'high') return 'text-orange-600'
  if (statusLower === 'low') return 'text-red-600'
  return props.isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'
}

const getStatusIcon = (status) => {
  const statusLower = status.toLowerCase()
  if (statusLower === 'normal') {
    return '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>'
  }
  if (statusLower === 'high') {
    return '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/></svg>'
  }
  if (statusLower === 'low') {
    return '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"/></svg>'
  }
  return ''
}
</script>
