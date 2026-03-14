<template>
  <div 
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" 
    class="rounded-lg p-5 border shadow-sm transition-all duration-300 hover:shadow-xl hover:-translate-y-1 animate-fade-in-up card-interactive group"
  >
    <!-- Header with Icon, Title and Status -->
    <div class="flex items-start justify-between mb-5">
      <div class="flex items-start gap-3">
        <div :class="[getIconBgColor(), 'transition-all duration-300 group-hover:scale-110 group-hover:rotate-3']" class="w-11 h-11 rounded-lg flex items-center justify-center flex-shrink-0">
          <svg v-if="record.type === 'MRI'" class="w-5 h-5 text-[#14B8A6] transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"/>
          </svg>
          <svg v-else class="w-5 h-5 text-[#9CA3AF] transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
          </svg>
        </div>
        
        <div class="transition-all duration-300">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold mb-0.5 leading-tight transition-colors duration-300">
            {{ record.title }}
          </h3>
          <p class="text-[11px] font-medium uppercase tracking-wide transition-colors duration-300" :class="record.type === 'MRI' ? 'text-[#14B8A6]' : 'text-[#9CA3AF]'">
            Imaging Type: {{ record.type }}
          </p>
        </div>
      </div>
      
      <span 
        :class="getStatusBadgeClass()"
        class="px-2.5 py-1 rounded text-[10px] font-bold uppercase tracking-wide transition-all duration-300 group-hover:scale-110"
      >
        {{ record.status }}
      </span>
    </div>

    <!-- Info Grid -->
    <div class="grid grid-cols-2 gap-x-6 gap-y-3.5 mb-5">
      <div class="transition-all duration-300 group-hover:translate-x-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1 transition-colors duration-300">
          Hospital
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] font-medium leading-tight transition-colors duration-300">
          {{ record.hospital }}
        </p>
      </div>
      
      <div class="transition-all duration-300 group-hover:translate-x-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1 transition-colors duration-300">
          Physician
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] font-medium leading-tight transition-colors duration-300">
          {{ record.physician }}
        </p>
      </div>
      
      <div class="transition-all duration-300 group-hover:translate-x-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1 transition-colors duration-300">
          Scan Date
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] font-medium leading-tight transition-colors duration-300">
          {{ record.scanDate }}
        </p>
      </div>
      
      <div class="transition-all duration-300 group-hover:translate-x-1">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[10px] font-semibold uppercase tracking-wide mb-1 transition-colors duration-300">
          Upload Date
        </p>
        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] font-medium leading-tight transition-colors duration-300">
          {{ record.uploadDate || 'Processing...' }}
        </p>
      </div>
    </div>

    <!-- File Info -->
    <div v-if="record.file" :class="isDark ? 'bg-[#334155]/30' : 'bg-[#F9FAFB]'" class="rounded-md p-2.5 mb-4 flex items-center justify-between transition-all duration-300 group-hover:bg-opacity-80">
      <div class="flex items-center gap-2.5">
        <svg class="w-4 h-4 transition-transform duration-300 group-hover:scale-110" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
        </svg>
        <div>
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-[13px] font-medium leading-tight transition-colors duration-300">
            {{ record.file.name }}
          </p>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-[11px] leading-tight transition-colors duration-300">
            {{ record.file.format }} • {{ record.file.size }}
          </p>
        </div>
      </div>
      
      <button class="p-0.5 hover:bg-black/5 rounded transition-all duration-300 hover:scale-110">
        <svg class="w-4 h-4" :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" fill="currentColor" viewBox="0 0 24 24">
          <circle cx="12" cy="5" r="1.5"/>
          <circle cx="12" cy="12" r="1.5"/>
          <circle cx="12" cy="19" r="1.5"/>
        </svg>
      </button>
    </div>

    <!-- Processing Message -->
    <div v-if="record.status === 'PENDING'" :class="isDark ? 'bg-blue-500/10 text-blue-400' : 'bg-[#EFF6FF] text-[#3B82F6]'" class="rounded-md p-2.5 mb-4 text-center text-[12px] font-medium animate-pulse">
      <div class="flex items-center justify-center gap-2">
        <svg class="w-4 h-4 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
        </svg>
        File verification in progress
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="flex items-center gap-2.5">
      <button 
        v-if="record.status === 'VERIFIED'"
        @click="$emit('view-file', record)"
        class="flex-1 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white px-3.5 py-2 rounded-lg text-[13px] font-semibold transition-all duration-300 flex items-center justify-center gap-1.5 hover:scale-105 active:scale-95 hover:shadow-lg hover:shadow-teal-500/30"
      >
        <svg class="w-3.5 h-3.5 transition-transform duration-300 group-hover:scale-110" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
        </svg>
        View File
      </button>
      
      <button 
        v-else
        disabled
        :class="isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-[#E5E7EB] text-[#9CA3AF]'"
        class="flex-1 px-3.5 py-2 rounded-lg text-[13px] font-semibold cursor-not-allowed flex items-center justify-center gap-1.5"
      >
        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
        </svg>
        View File
      </button>
      
      <button 
        v-if="record.status === 'VERIFIED'"
        @click="$emit('download', record)"
        :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#14B8A6] hover:bg-[#F9FAFB]'"
        class="flex-1 border px-3.5 py-2 rounded-lg text-[13px] font-semibold transition-all duration-300 flex items-center justify-center gap-1.5 hover:scale-105 active:scale-95"
      >
        <svg class="w-3.5 h-3.5 transition-transform duration-300 group-hover:translate-y-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
        </svg>
        Download
      </button>
      
      <button 
        v-else
        disabled
        :class="isDark ? 'border-[#334155] text-[#94A3B8]' : 'border-[#E5E7EB] text-[#9CA3AF]'"
        class="flex-1 border px-3.5 py-2 rounded-lg text-[13px] font-semibold cursor-not-allowed flex items-center justify-center gap-1.5"
      >
        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
        </svg>
        Download
      </button>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  record: {
    type: Object,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

defineEmits(['view-file', 'download'])

const getIconBgColor = () => {
  if (props.record.type === 'MRI') {
    return props.isDark ? 'bg-[#14B8A6]/10' : 'bg-[#CCFBF1]'
  }
  return props.isDark ? 'bg-[#334155]/30' : 'bg-[#F3F4F6]'
}

const getStatusBadgeClass = () => {
  if (props.record.status === 'VERIFIED') {
    return props.isDark ? 'bg-[#14B8A6]/10 text-[#14B8A6]' : 'bg-[#CCFBF1] text-[#14B8A6]'
  }
  return props.isDark ? 'bg-blue-500/10 text-blue-400' : 'bg-[#DBEAFE] text-[#3B82F6]'
}
</script>
