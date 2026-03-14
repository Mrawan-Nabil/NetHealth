<template>
  <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="container-hover-subtle rounded-xl p-6 border shadow-sm">
    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-6">Health Overview</h3>
    
    <div class="space-y-3">
      <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="flex items-center justify-between p-4 rounded-lg smooth-transition">
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium">Blood Type</span>
        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{ healthData.bloodType }}</span>
      </div>
      
      <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="flex items-center justify-between p-4 rounded-lg smooth-transition">
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium">Allergies</span>
        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{ healthData.allergies }}</span>
      </div>
      
      <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="flex items-center justify-between p-4 rounded-lg smooth-transition">
        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium">Chronic Conditions</span>
        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{ healthData.conditions }}</span>
      </div>
      
      <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="p-4 rounded-lg smooth-transition">
        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium mb-3">Primary Doctor</p>
        <div class="flex items-center gap-3">
          <img 
            :src="healthData.primaryDoctorAvatar || 'https://i.pravatar.cc/150?img=47'" 
            :alt="healthData.primaryDoctor"
            class="w-10 h-10 rounded-full object-cover ring-2 smooth-transition"
            :class="isDark ? 'ring-[#334155]' : 'ring-gray-100'"
          />
          <div>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{ healthData.primaryDoctor }}</p>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">{{ healthData.primaryDoctorSpecialty || 'Cardiologist' }}</p>
          </div>
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
  healthData: {
    type: Object,
    required: true
  },
  isDark: Boolean
})
</script>
