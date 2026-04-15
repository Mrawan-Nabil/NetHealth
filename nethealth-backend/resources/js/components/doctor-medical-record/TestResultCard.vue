<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
defineProps<{ item: { title: string; lab: string; date: string; status: 'Reviewed' | 'Pending' } }>();
defineEmits<{ (event: 'view-details'): void }>();
</script>
<template>
    <article
        class="dash-card rounded-xl border border-[#E5E7EB] bg-white p-4 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex items-start justify-between">
            <span class="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-violet-50 text-violet-500 dark:bg-violet-500/10 dark:text-violet-400"><svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v6a3 3 0 0 1-3 3H3m0 0v8a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V3m-15 0h15" /></svg></span>
            <BaseBadge :variant="item.status === 'Reviewed' ? 'emerald' : 'amber'">{{ item.status }}</BaseBadge>
        </div>
        <h5 class="mt-3 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.title }}</h5>
        <p class="mt-1 text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.lab }}</p>
        <p class="mt-0.5 text-xs text-[#94A3B8] dark:text-[#64748B]">{{ item.date }}</p>
        <BaseButton variant="primary" size="sm" block class="mt-3" @click="$emit('view-details')">View Details</BaseButton>
    </article>
</template>
