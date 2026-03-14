<template>
  <router-link 
    :to="recordLink"
    :class="isDark ? 'bg-[#1E293B]/50 hover:bg-[#1E293B] border-[#334155]/50' : 'bg-[#F8FAFC] hover:bg-gray-100 border-transparent'" 
    class="container-hover-subtle flex items-center gap-4 p-4 rounded-xl border group"
  >
    <div :class="[iconBgColor, 'smooth-transition group-hover:scale-105']" class="p-3 rounded-lg flex-shrink-0">
      <component :is="iconComponent" class="w-5 h-5" :class="iconColor" />
    </div>
    
    <div class="flex-1 min-w-0">
      <h4 :class="isDark ? 'text-white' : 'text-gray-900'" class="font-medium text-sm mb-1 truncate">{{ record.title }}</h4>
      <p :class="isDark ? 'text-slate-400' : 'text-gray-600'" class="text-xs truncate">{{ record.doctor }} • {{ record.date }}</p>
    </div>

    <span 
      :class="statusClass"
      class="px-3 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap flex-shrink-0 smooth-transition"
    >
      {{ record.status }}
    </span>
  </router-link>
</template>

<style scoped>
.container-hover-subtle {
  transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
}

.container-hover-subtle:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.06);
}
</style>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  record: {
    type: Object,
    required: true
  },
  isDark: Boolean
})

const recordLink = computed(() => {
  const title = props.record.title.toLowerCase()
  if (title.includes('prescription')) {
    return `/prescription/${props.record.id || 1}`
  }
  if (title.includes('test') || title.includes('blood')) {
    return `/test-results/${props.record.id || 1}`
  }
  return '/medical-records'
})

const iconComponent = computed(() => {
  const title = props.record.title.toLowerCase()
  if (title.includes('prescription')) return PrescriptionIcon
  if (title.includes('test') || title.includes('blood')) return TestIcon
  return DocumentIcon
})

const iconBgColor = computed(() => {
  const title = props.record.title.toLowerCase()
  if (title.includes('prescription')) return props.isDark ? 'bg-orange-500/10' : 'bg-orange-50'
  if (title.includes('test') || title.includes('blood')) return props.isDark ? 'bg-blue-500/10' : 'bg-blue-50'
  return props.isDark ? 'bg-emerald-500/10' : 'bg-emerald-50'
})

const iconColor = computed(() => {
  const title = props.record.title.toLowerCase()
  if (title.includes('prescription')) return props.isDark ? 'text-[#F59E0B]' : 'text-[#F59E0B]'
  if (title.includes('test') || title.includes('blood')) return props.isDark ? 'text-[#3B82F6]' : 'text-[#3B82F6]'
  return props.isDark ? 'text-[#22C55E]' : 'text-[#22C55E]'
})

const statusClass = computed(() => {
  const status = props.record.status.toLowerCase()
  const classes = {
    active: props.isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-50 text-[#22C55E]',
    available: props.isDark ? 'bg-blue-500/10 text-[#3B82F6]' : 'bg-blue-50 text-[#3B82F6]',
    completed: props.isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-gray-100 text-[#6B7280]',
    pending: props.isDark ? 'bg-amber-500/10 text-[#F59E0B]' : 'bg-yellow-50 text-[#F59E0B]'
  }
  return classes[status] || (props.isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-gray-100 text-[#6B7280]')
})

// Icon Components
const PrescriptionIcon = {
  template: `
    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
    </svg>
  `
}

const TestIcon = {
  template: `
    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
    </svg>
  `
}

const DocumentIcon = {
  template: `
    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
    </svg>
  `
}
</script>
