<script setup lang="ts">
import BaseButton from './BaseButton.vue';
defineEmits<{ (event: 'back'): void; (event: 'print'): void; (event: 'download'): void }>();
</script>
<template>
    <div class="flex w-full flex-wrap items-center justify-start gap-2 lg:w-auto lg:justify-end">
        <button class="inline-flex items-center gap-1.5 rounded-lg px-2 py-1.5 text-sm font-medium text-[#64748B] transition-colors duration-200 hover:bg-[#F8FAFC] hover:text-[#0F172A] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-[#94A3B8] dark:hover:bg-[#334155]/60 dark:hover:text-[#F1F5F9]" @click="$emit('back')">
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="m15 18-6-6 6-6" /></svg>
            Back to View File
        </button>
        <BaseButton variant="secondary" size="sm" @click="$emit('print')"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M7 8V4h10v4M6 17H4.5A1.5 1.5 0 0 1 3 15.5v-5A1.5 1.5 0 0 1 4.5 9h15A1.5 1.5 0 0 1 21 10.5v5a1.5 1.5 0 0 1-1.5 1.5H18m-12 0h12v3H6v-3Z" /></svg>Print</BaseButton>
        <BaseButton variant="primary" size="sm" @click="$emit('download')"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 4v10m0 0 4-4m-4 4-4-4M4 16.5v2A1.5 1.5 0 0 0 5.5 20h13a1.5 1.5 0 0 0 1.5-1.5v-2" /></svg>Download PDF</BaseButton>
    </div>
</template>
