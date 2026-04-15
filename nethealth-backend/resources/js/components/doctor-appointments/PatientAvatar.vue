<script setup lang="ts">
defineProps<{ initials: string; muted?: boolean }>();
</script>

<template>
    <span
        class="inline-flex h-11 w-11 items-center justify-center rounded-full text-sm font-semibold"
        :class="muted ? 'bg-[#F1F5F9] text-[#64748B] dark:bg-[#334155] dark:text-[#94A3B8]' : 'bg-[#14B8A6] text-white dark:bg-[#14B8A6] dark:text-white'"
    >
        {{ initials }}
    </span>
</template>
