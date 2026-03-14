<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="container-hover-subtle rounded-xl p-6 border shadow-sm">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-6">Recent Activity</h3>
    
    <div class="space-y-5">
      <div 
        v-for="(activity, index) in activities" 
        :key="index"
        class="flex items-start gap-4"
        :class="`stagger-${index + 1}`"
      >
        <div class="relative">
          <div :class="getActivityColor(activity.type)" class="w-3 h-3 rounded-full mt-1 shadow-sm smooth-transition"></div>
          <div 
            v-if="index < activities.length - 1" 
            :class="isDark ? 'bg-[#334155]' : 'bg-gray-200'"
            class="absolute left-1/2 top-5 w-px h-8 -translate-x-1/2"
          ></div>
        </div>
        
        <div class="flex-1 pb-2">
          <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1">{{ activity.title }}</p>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">{{ activity.time }}</p>
        </div>
      </div>
    </div>
  </div>
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
defineProps({
  activities: {
    type: Array,
    required: true
  },
  isDark: Boolean
})

const getActivityColor = (type) => {
  const colors = {
    appointment: 'bg-[#10B981]',
    test: 'bg-[#3B82F6]',
    prescription: 'bg-[#F59E0B]',
    default: 'bg-[#6B7280]'
  }
  return colors[type] || colors.default
}
</script>
