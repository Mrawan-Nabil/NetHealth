<template>
  <div 
    @click="handleClick"
    :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'"
    class="container-hover-subtle rounded-xl p-6 cursor-pointer border shadow-sm"
  >
    <div class="flex items-center gap-4 mb-4">
      <div :class="[iconBgColor]" class="p-3 rounded-lg smooth-transition">
        <component :is="iconComponent" class="w-6 h-6" :class="iconColor" />
      </div>
      <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-3xl font-bold">{{ value }}</h3>
    </div>
    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium leading-relaxed">{{ label }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  value: {
    type: [Number, String],
    required: true
  },
  label: {
    type: String,
    required: true
  },
  icon: {
    type: String,
    required: true
  },
  isDark: Boolean,
  clickable: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['click'])

const handleClick = () => {
  if (props.clickable) {
    emit('click', { label: props.label, value: props.value })
  }
}

const iconComponent = computed(() => {
  const icons = {
    calendar: CalendarIcon,
    prescription: PrescriptionIcon,
    test: TestIcon
  }
  return icons[props.icon] || CalendarIcon
})

const iconBgColor = computed(() => {
  if (props.isDark) {
    const colors = {
      calendar: 'bg-[#3B82F6]/10',
      prescription: 'bg-[#F59E0B]/10',
      test: 'bg-[#8B5CF6]/10'
    }
    return colors[props.icon] || 'bg-[#6B7280]/10'
  } else {
    const colors = {
      calendar: 'bg-[#3B82F6]/10',
      prescription: 'bg-[#F59E0B]/10',
      test: 'bg-[#8B5CF6]/10'
    }
    return colors[props.icon] || 'bg-gray-50'
  }
})

const iconColor = computed(() => {
  const colors = {
    calendar: 'text-[#3B82F6]',
    prescription: 'text-[#F59E0B]',
    test: 'text-[#8B5CF6]'
  }
  return colors[props.icon] || 'text-[#6B7280]'
})

// Icon Components
const CalendarIcon = {
  template: `
    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
    </svg>
  `
}

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
</script>
