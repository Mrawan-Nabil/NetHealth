<script setup>
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
defineProps({ item: { type: Object, required: true } });
defineEmits(['view-file']);
</script>
<template>
    <article
        class="dash-card rounded-2xl border border-[#E5E7EB] bg-white p-5 shadow-[var(--shadow-card)] dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="space-y-2 border-b border-[#E5E7EB] pb-4 dark:border-[#334155]">
            <div class="flex items-center gap-2">
                <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-[#F8FAFC] text-[#14B8A6] dark:bg-[#0F172A] dark:text-[#2DD4BF]"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M5 4.5h9l5 5V19a1.5 1.5 0 0 1-1.5 1.5h-12A1.5 1.5 0 0 1 4 19V6A1.5 1.5 0 0 1 5.5 4.5Z" /></svg></span>
                <BaseBadge :variant="item.category === 'Lab Test' ? 'lab' : item.category === 'X-Ray Imaging' ? 'xray' : 'mri'">{{ item.category }}</BaseBadge>
            </div>
            <p class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.title }}</p>
            <p class="inline-flex items-center gap-1 text-sm text-[#64748B] dark:text-[#94A3B8]"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 2v3m8-3v3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" /></svg>{{ item.date }}</p>
        </div>
        <div class="mt-4"><img :src="item.previewImage" :alt="item.title" class="h-40 w-full rounded-xl object-cover" /></div>
        <BaseButton variant="success" size="sm" class="mt-3 w-full" @click="$emit('view-file')">{{ item.buttonText }}</BaseButton>
    </article>
</template>
