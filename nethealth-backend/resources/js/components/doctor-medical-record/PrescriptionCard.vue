<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
defineProps<{ item: { doctor: string; visitType: string; date: string; condition: string; medicines: string[]; status: 'Active' | 'Expired' } }>();
defineEmits<{ (event: 'view-details'): void }>();
</script>
<template>
    <article
        class="rounded-xl border border-[#E5E7EB] bg-white p-4 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <div class="shrink-0 min-w-0 w-full lg:w-[190px]">
                <p class="inline-flex items-center gap-2 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]"><span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2h4a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4V5z" /></svg></span>{{ item.doctor }}</p>
                <BaseBadge variant="purple" class="mt-2">{{ item.visitType }}</BaseBadge>
            </div>
            <div class="flex-1">
                <p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.date }}</p>
                <h5 class="mt-0.5 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.condition }}</h5>
                <div class="mt-2 rounded-lg bg-[#F8FAFC] p-2.5 dark:bg-[#0F172A]">
                    <p class="text-[10px] font-semibold uppercase text-[#9CA3AF] dark:text-[#64748B]">Medicines</p>
                    <p v-for="medicine in item.medicines" :key="medicine" class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ medicine }}</p>
                </div>
            </div>
            <div class="flex min-w-[140px] flex-col items-start gap-2 xl:items-end">
                <BaseBadge :variant="item.status === 'Active' ? 'emerald' : 'gray'">{{ item.status }}</BaseBadge>
                <BaseButton variant="primary" size="sm" @click="$emit('view-details')">View Details</BaseButton>
            </div>
        </div>
    </article>
</template>
