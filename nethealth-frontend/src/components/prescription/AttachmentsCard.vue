<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155] shadow-lg shadow-black/20' : 'bg-white border-[#E5E7EB] shadow-sm'" class="rounded-lg p-6 border transition-all duration-300">
    <div class="flex items-start gap-3 mb-4">
      <div :class="isDark ? 'bg-[#14B8A6]/10' : 'bg-teal-50'" class="w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0">
        <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"/>
        </svg>
      </div>
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">
        Attachments
      </h3>
    </div>
    
    <div class="space-y-3">
      <div 
        v-for="(file, index) in attachments" 
        :key="index"
        :class="isDark ? 'bg-[#334155]/30 hover:bg-[#334155]/50' : 'bg-[#F8FAFC] hover:bg-gray-100'"
        class="flex items-center justify-between p-3 rounded-lg transition-colors duration-200"
      >
        <div class="flex items-center gap-3">
          <div :class="getFileIconBg(file.name)" class="w-10 h-10 rounded-lg flex items-center justify-center">
            <svg v-if="file.name.endsWith('.pdf')" class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 24 24">
              <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8l-6-6z"/>
              <path d="M14 2v6h6"/>
            </svg>
            <svg v-else class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
              <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8l-6-6z"/>
              <path d="M14 2v6h6"/>
            </svg>
          </div>
          <div>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-medium">
              {{ file.name }}
            </p>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">
              {{ file.size }} • {{ getFileType(file.name) }}
            </p>
          </div>
        </div>
        
        <button 
          class="p-2 rounded-lg transition-colors duration-200"
          :class="isDark ? 'hover:bg-[#334155]' : 'hover:bg-gray-200'"
          @click.stop="handleDownload(file)"
        >
          <svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  attachments: {
    type: Array,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['download'])

const getFileType = (filename) => {
  const ext = filename.split('.').pop().toUpperCase()
  if (ext === 'PDF') return 'PDF Document'
  if (ext === 'JPG' || ext === 'JPEG' || ext === 'PNG') return 'Image'
  return ext + ' File'
}

const getFileIconBg = (filename) => {
  if (filename.endsWith('.pdf')) {
    return props.isDark ? 'bg-red-500/10' : 'bg-red-50'
  }
  return props.isDark ? 'bg-blue-500/10' : 'bg-blue-50'
}

const handleDownload = (file) => {
  emit('download', file)
}
</script>
