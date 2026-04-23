<script setup>
defineProps({ initials: { type: String, required: true }, muted: { type: Boolean, default: false } });
</script>
<template>
    <span class="inline-flex h-11 w-11 items-center justify-center rounded-full text-sm font-semibold" :class="muted ? 'bg-[#F1F5F9] text-[#64748B] dark:bg-[#334155] dark:text-[#94A3B8]' : 'bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]'">
        {{ initials }}
    </span>
</template>
