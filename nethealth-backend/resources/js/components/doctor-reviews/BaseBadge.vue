<script setup lang="ts">
import { computed } from 'vue';
type Variant = 'pending' | 'reviewed' | 'lab' | 'xray' | 'mri';
const props = defineProps<{ variant: Variant }>();
const classes = computed(() => {
    const map: Record<Variant, string> = {
        pending: 'bg-[#FEF9C3] text-[#A16207] dark:bg-amber-500/15 dark:text-amber-300',
        reviewed: 'bg-[#DCFCE7] text-[#15803D] dark:bg-emerald-500/15 dark:text-emerald-300',
        lab: 'bg-[#CCFBF1] text-[#0F766E] dark:bg-teal-500/15 dark:text-[#2DD4BF]',
        xray: 'bg-[#DBEAFE] text-[#1D4ED8] dark:bg-blue-500/15 dark:text-blue-300',
        mri: 'bg-[#EDE9FE] text-[#6D28D9] dark:bg-violet-500/15 dark:text-violet-300',
    };
    return `inline-flex items-center rounded-full px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide ${map[props.variant]}`;
});
</script>
<template><span :class="classes"><slot /></span></template>
