<script setup>
import { computed } from 'vue';

const props = defineProps({
    variant: { type: String, required: true },
});

const classes = computed(() => {
    const map = {
        completed: 'bg-[#DCFCE7] text-[#15803D] dark:bg-emerald-500/15 dark:text-emerald-300',
        pending: 'bg-[#FEF9C3] text-[#A16207] dark:bg-amber-500/15 dark:text-amber-300',
        confirmed: 'bg-[#CCFBF1] text-[#0F766E] dark:bg-teal-500/15 dark:text-[#2DD4BF]',
        'visit-clinic': 'bg-[#CCFBF1] text-[#0F766E] dark:bg-teal-500/15 dark:text-[#2DD4BF]',
        'visit-followup': 'bg-[#FEF9C3] text-[#A16207] dark:bg-amber-500/15 dark:text-amber-300',
        cancelled: 'bg-[#FEE2E2] text-[#B91C1C] dark:bg-red-500/15 dark:text-red-300',
    };
    return `inline-flex items-center rounded-full px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide ${map[props.variant]}`;
});
</script>

<template>
    <span :class="classes"><slot /></span>
</template>
