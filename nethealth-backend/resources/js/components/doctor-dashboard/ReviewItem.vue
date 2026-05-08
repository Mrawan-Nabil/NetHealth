<script setup>
defineProps({
    reportType: { type: String, required: true },
    patientName: { type: String, required: true },
    category: { type: String, required: true },
    timeAgo: { type: String, required: true },
});

defineEmits(['review-files']);
</script>

<template>
    <article class="rounded-xl border border-transparent bg-[#F8FAFC] p-3.5 transition-colors duration-200 hover:border-[#E5E7EB] hover:bg-[#F1F5F9] dark:bg-[#0F172A] dark:hover:border-[#334155]/60 dark:hover:bg-[#334155]/40">
        <p class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ reportType }}:<br> {{ patientName }}</p>
        <p class="mt-1 text-xs text-[#64748B] dark:text-[#94A3B8]">{{ category }} - {{ timeAgo }}</p>
        <button
            type="button"
            class="mt-3 text-xs font-semibold text-[#14B8A6] transition-colors duration-200 hover:text-[#0D9488] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-[#2DD4BF]"
            @click="$emit('review-files')"
        >
            Review Files
        </button>
    </article>
</template>
