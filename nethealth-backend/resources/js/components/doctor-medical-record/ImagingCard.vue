<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
defineProps<{ item: { title: string; region: string; doctor: string; date: string; modality: 'X-ray' | 'Ultrasound' | 'CT Scan' } }>();
defineEmits<{ (event: 'view-details'): void }>();
</script>
<template>
    <article
        class="dash-card rounded-xl border border-[#E5E7EB] bg-white p-4 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex items-start justify-between">
            <span class="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]"><svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 3h16a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2m5 4a2 2 0 1 0-4 0 2 2 0 0 0 4 0m8 10l-5-5-3 3" /></svg></span>
            <BaseBadge :variant="item.modality === 'CT Scan' ? 'purple' : item.modality === 'Ultrasound' ? 'amber' : 'teal'">{{ item.modality }}</BaseBadge>
        </div>
        <h5 class="mt-3 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.title }}</h5>
        <p class="mt-1 text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.region }}</p>
        <p class="mt-0.5 text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.doctor }}</p>
        <p class="mt-0.5 text-xs text-[#94A3B8] dark:text-[#64748B]">{{ item.date }}</p>
        <BaseButton variant="primary" size="sm" block class="mt-3" @click="$emit('view-details')">View Details</BaseButton>
    </article>
</template>
