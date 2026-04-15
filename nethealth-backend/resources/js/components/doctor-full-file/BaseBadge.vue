<script setup lang="ts">
import { computed } from 'vue';

type Variant = 'success' | 'info' | 'muted';

const props = withDefaults(defineProps<{ variant?: Variant }>(), { variant: 'muted' });

const classes = computed(() => {
    const map: Record<Variant, string> = {
        success: 'bg-[#DCFCE7] text-[#15803D] dark:bg-emerald-500/15 dark:text-emerald-300',
        info: 'bg-[#CCFBF1] text-[#0F766E] dark:bg-teal-500/15 dark:text-[#2DD4BF]',
        muted: 'bg-[#F1F5F9] text-[#475569] dark:bg-[#94A3B8]/12 dark:text-[#94A3B8]',
    };
    return `inline-flex items-center rounded-full px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide ${map[props.variant]}`;
});
</script>

<template>
    <span :class="classes"><slot /></span>
</template>
