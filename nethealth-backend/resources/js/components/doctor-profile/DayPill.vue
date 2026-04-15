<script setup lang="ts">
defineProps<{
    label: string;
    active?: boolean;
}>();
</script>

<template>
    <span
        class="inline-flex h-8 w-8 items-center justify-center rounded-md border text-xs font-semibold transition-all duration-200"
        :class="
            active
                ? 'border-teal-200 bg-[#F0FDFA] text-[#0D9488] dark:border-teal-500/30 dark:bg-teal-500/10 dark:text-teal-300'
                : 'border-[#E5E7EB] bg-white text-[#9CA3AF] dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#64748B]'
        "
    >
        {{ label }}
    </span>
</template>
