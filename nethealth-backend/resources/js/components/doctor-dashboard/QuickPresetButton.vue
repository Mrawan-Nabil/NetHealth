<script setup lang="ts">
defineProps<{
    label: string;
    timeRange: string;
    selected?: boolean;
}>();
</script>

<template>
    <button
        type="button"
        class="inline-flex items-center gap-2 rounded-xl border px-3 py-2 text-left transition-all duration-200"
        :class="
            selected
                ? 'border-teal-200 bg-[#F0FDFA] text-[#0F766E] shadow-sm dark:border-teal-500/20 dark:bg-teal-500/8 dark:text-teal-400'
                : 'border-[#E5E7EB] bg-white text-[#64748B] hover:border-teal-200 hover:bg-[#F8FAFC] dark:border-[#334155] dark:bg-[#1E293B] dark:text-[#94A3B8] dark:hover:border-[#14B8A6]/40 dark:hover:bg-[#334155]/60'
        "
    >
        <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-white text-[#14B8A6] shadow-sm dark:bg-[#1E293B] dark:text-[#2DD4BF]">
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" />
            </svg>
        </span>
        <span>
            <span class="block text-sm font-semibold">{{ label }}</span>
            <span class="block text-xs opacity-80">{{ timeRange }}</span>
        </span>
    </button>
</template>
