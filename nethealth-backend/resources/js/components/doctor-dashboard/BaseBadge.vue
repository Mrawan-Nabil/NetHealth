<script setup>
import { computed } from 'vue';

const props = defineProps({
    variant: { type: String, default: 'gray' },
    size: { type: String, default: 'sm' },
});

const variantClasses = {
    success: 'bg-[#DCFCE7] text-[#15803D] dark:bg-emerald-500/20 dark:text-emerald-300',
    warning: 'bg-[#FEF9C3] text-[#92400E] dark:bg-amber-500/20 dark:text-amber-300',
    danger: 'bg-[#FEE2E2] text-[#B91C1C] dark:bg-red-500/20 dark:text-red-300',
    info: 'bg-[#DBEAFE] text-[#1D4ED8] dark:bg-blue-500/20 dark:text-blue-300',
    teal: 'bg-[#CCFBF1] text-[#0D9488] dark:bg-teal-500/20 dark:text-[#2DD4BF]',
    gray: 'bg-[#F1F5F9] text-[#64748B] dark:bg-[#334155] dark:text-[#94A3B8]',
    urgent: 'bg-[#FEE2E2] text-[#B91C1C] dark:bg-red-500/20 dark:text-red-300',
};

const sizeClasses = {
    sm: 'px-2 py-0.5 text-[10px]',
    md: 'px-2.5 py-1 text-xs',
};

const classes = computed(() => [
    'inline-flex items-center rounded-full font-bold uppercase tracking-wide transition-colors duration-200',
    variantClasses[props.variant],
    sizeClasses[props.size],
]);
</script>

<template>
    <span :class="classes">
        <slot />
    </span>
</template>
