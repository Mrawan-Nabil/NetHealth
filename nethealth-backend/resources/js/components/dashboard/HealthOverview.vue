<script setup>
defineProps({
    patient: {
        type: Object,
        required: true,
        // Added a default empty object just to be extra safe
        default: () => ({})
    },
    isDark: Boolean,
});
</script>

<template>
    <div
        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
        class="container-hover-subtle rounded-xl border p-6 shadow-sm"
    >
        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-6 text-lg font-semibold">Health Overview</h3>

        <div class="space-y-3">
            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="smooth-transition flex items-center justify-between rounded-lg p-4">
                <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium">Blood Type</span>
                <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
                    {{ patient?.blood_type || 'N/A' }}
                </span>
            </div>

            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="smooth-transition flex items-center justify-between rounded-lg p-4">
                <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium">Allergies</span>
               <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold text-right max-w-[60%] truncate">
    {{ Array.isArray(patient?.allergies) ? patient.allergies.join(', ') : (patient?.allergies || 'None') }}
</span>
            </div>

            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="smooth-transition flex items-center justify-between rounded-lg p-4">
                <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm font-medium">Chronic Conditions</span>
                <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold text-right max-w-[60%] truncate">
                    {{ patient?.chronic_conditions || 'None' }}
                </span>
            </div>

            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="smooth-transition rounded-lg p-4">
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-3 text-sm font-medium">Primary Doctor</p>
                <div class="flex items-center gap-3">
                    <img
    :src="patient?.doctor?.user?.avatar || `https://ui-avatars.com/api/?name=${encodeURIComponent(patient?.doctor?.user?.full_name || 'Not Assigned')}&background=0D9488&color=fff`"
    :alt="patient?.doctor?.user?.full_name || 'Not Assigned'"
    class="smooth-transition h-10 w-10 rounded-full object-cover ring-2"
    :class="isDark ? 'ring-[#334155]' : 'ring-gray-100'"
/>
                    <div>
                        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
                            {{ patient?.doctor?.user?.full_name ? 'Dr. ' + patient.doctor.user.full_name : 'Not Assigned' }}
                        </p>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">
                            {{ patient?.doctor?.specialty || 'General Practice' }}
                        </p>
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
