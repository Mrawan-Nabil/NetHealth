<script setup>
defineProps({
    patient: { type: Object, default: () => ({}) },
    isDark:  Boolean,
});
</script>

<template>
    <div
        :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
        class="dash-card border p-6"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <!-- Header -->
        <div class="mb-5 flex items-center gap-2">
            <span
                :class="isDark ? 'bg-[#14B8A6]/10' : 'bg-[#CCFBF1]'"
                class="flex h-7 w-7 items-center justify-center rounded-lg"
            >
                <svg class="h-4 w-4 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75"
                          d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                </svg>
            </span>
            <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-sm font-semibold">
                Health Overview
            </h3>
        </div>

        <!-- Stats rows -->
        <div class="mb-4 space-y-2">
            <!-- Blood Type -->
            <div
                :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                class="flex items-center justify-between rounded-xl px-4 py-3"
            >
                <div class="flex items-center gap-2.5">
                    <div :class="isDark ? 'bg-red-500/10' : 'bg-red-50'" class="flex h-6 w-6 items-center justify-center rounded-md">
                        <svg class="h-3.5 w-3.5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="text-xs font-medium">Blood Type</span>
                </div>
                <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-xs font-bold">
                    {{ patient?.blood_type || 'N/A' }}
                </span>
            </div>

            <!-- Allergies -->
            <div
                :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                class="flex items-center justify-between rounded-xl px-4 py-3"
            >
                <div class="flex items-center gap-2.5">
                    <div :class="isDark ? 'bg-amber-500/10' : 'bg-amber-50'" class="flex h-6 w-6 items-center justify-center rounded-md">
                        <svg class="h-3.5 w-3.5 text-amber-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                        </svg>
                    </div>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="text-xs font-medium">Allergies</span>
                </div>
                <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="max-w-[52%] truncate text-right text-xs font-bold">
                    {{ Array.isArray(patient?.allergies) ? patient.allergies.join(', ') : (patient?.allergies || 'None') }}
                </span>
            </div>

            <!-- Chronic Conditions -->
            <div
                :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                class="flex items-center justify-between rounded-xl px-4 py-3"
            >
                <div class="flex items-center gap-2.5">
                    <div :class="isDark ? 'bg-violet-500/10' : 'bg-violet-50'" class="flex h-6 w-6 items-center justify-center rounded-md">
                        <svg class="h-3.5 w-3.5 text-violet-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                    </div>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="text-xs font-medium">Conditions</span>
                </div>
                <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="max-w-[52%] truncate text-right text-xs font-bold">
                    {{ patient?.chronic_conditions || 'None' }}
                </span>
            </div>
        </div>

        <!-- Divider -->
        <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="mb-4 h-px" />

        <!-- Primary Doctor -->
        <div>
            <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-3 text-[10px] font-semibold uppercase tracking-wider">
                Primary Doctor
            </p>
            <div class="flex items-center gap-3">
                <img
                    :src="patient?.doctor?.user?.avatar || `https://ui-avatars.com/api/?name=${encodeURIComponent(patient?.doctor?.user?.full_name || 'Not Assigned')}&background=0D9488&color=fff&size=80`"
                    :alt="patient?.doctor?.user?.full_name || 'Not Assigned'"
                    class="h-9 w-9 rounded-full object-cover ring-2"
                    :class="isDark ? 'ring-[#334155]' : 'ring-[#F1F5F9]'"
                />
                <div>
                    <p :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-sm font-semibold leading-tight">
                        {{ patient?.doctor?.user?.full_name ? 'Dr. ' + patient.doctor.user.full_name : 'Not Assigned' }}
                    </p>
                    <p :class="isDark ? 'text-[#14B8A6]' : 'text-[#0D9488]'" class="text-xs font-medium">
                        {{ patient?.doctor?.specialty || 'General Practice' }}
                    </p>
                </div>
            </div>
        </div>
    </div>
</template>
