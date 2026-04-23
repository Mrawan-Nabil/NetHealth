<script setup>
import { computed } from 'vue';

const props = defineProps({
    variant: { type: String, default: 'neutral' },
});

const classes = computed(() => {
    const map = {
        neutral: 'border-[#E5E7EB] bg-white text-[#64748B] dark:border-[#334155] dark:bg-[#1A1F35] dark:text-[#94A3B8]',
        teal: 'border-teal-200 bg-[#F0FDFA] text-[#0D9488] dark:border-teal-500/30 dark:bg-teal-500/10 dark:text-teal-300',
        soft: 'border-[#F1F5F9] bg-[#F8FAFC] text-[#64748B] dark:border-[#334155] dark:bg-[#1A1F35] dark:text-[#94A3B8]',
    };

    return `inline-flex items-center rounded-full border px-2.5 py-1 text-[11px] font-semibold transition-colors duration-200 ${map[props.variant]}`;
});
</script>

<template>
    <span :class="classes"><slot /></span>
</template>
