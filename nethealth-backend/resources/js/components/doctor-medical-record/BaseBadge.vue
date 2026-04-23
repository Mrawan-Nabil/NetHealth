<script setup>
import { computed } from 'vue';

const props = defineProps({ variant: { type: String, default: 'gray' } });

const classes = computed(() => {
    const map = {
        teal: 'bg-[#CCFBF1] text-[#0D9488] dark:bg-teal-500/20 dark:text-[#2DD4BF]',
        purple: 'bg-[#EDE9FE] text-[#6D28D9] dark:bg-violet-500/20 dark:text-violet-300',
        amber: 'bg-[#FEF9C3] text-[#92400E] dark:bg-amber-500/20 dark:text-amber-300',
        rose: 'bg-[#FEE2E2] text-[#B91C1C] dark:bg-red-500/20 dark:text-red-300',
        emerald: 'bg-[#DCFCE7] text-[#15803D] dark:bg-emerald-500/20 dark:text-emerald-300',
        gray: 'bg-[#F1F5F9] text-[#64748B] dark:bg-[#334155] dark:text-[#94A3B8]',
    };
    return `inline-flex items-center rounded-full px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide ${map[props.variant]}`;
});
</script>
<template><span :class="classes"><slot /></span></template>
