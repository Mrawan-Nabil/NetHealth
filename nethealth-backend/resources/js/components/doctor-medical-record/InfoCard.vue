<script setup>
import BaseBadge from './BaseBadge.vue';
defineProps({ title: { type: String, required: true }, icon: { type: String, required: true }, items: { type: Array, required: true } });
</script>
<template>
    <section
        class="rounded-2xl border border-[#E5E7EB] bg-white p-6 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <h4 class="mb-5 inline-flex items-center gap-2 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">
            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" :d="icon" /></svg></span>{{ title }}
        </h4>
        <div class="space-y-3">
            <div v-for="item in items" :key="item.label">
                <p class="text-xs font-medium text-[#94A3B8] dark:text-[#64748B]">{{ item.label }}</p>
                <p v-if="item.value" class="mt-0.5 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.value }}</p>
                <div v-if="item.badges" class="mt-1.5 flex flex-wrap gap-1.5">
                    <BaseBadge v-for="badge in item.badges" :key="badge.label" :variant="badge.variant ?? 'gray'">{{ badge.label }}</BaseBadge>
                </div>
            </div>
        </div>
    </section>
</template>
