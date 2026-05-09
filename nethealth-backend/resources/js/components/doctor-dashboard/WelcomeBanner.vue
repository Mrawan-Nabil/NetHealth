<script setup>
defineProps({
    name: { type: String, required: true },
});
</script>

<template>
    <section
        class="flex items-center justify-between rounded-2xl border border-[#F1F5F9] bg-white px-6 py-5 dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div>
            <h2 class="mb-0.5 text-xl font-bold text-[#0F172A] dark:text-[#F1F5F9]">Welcome back, {{ name }} 👋</h2>
            <p class="text-sm text-[#94A3B8] dark:text-[#64748B]">Here's your clinical overview for today.</p>
        </div>
        <div class="hidden items-center gap-2 rounded-xl border border-[#E5E7EB] bg-[#F8FAFC] px-4 py-2 text-xs font-medium text-[#64748B] dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#64748B] sm:flex">
            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            {{ new Date().toLocaleDateString('en-GB', { weekday:'long', day:'numeric', month:'long' }) }}
        </div>
    </section>
</template>
