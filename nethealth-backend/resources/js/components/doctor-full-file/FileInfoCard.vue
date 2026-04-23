<script setup>
import BaseBadge from './BaseBadge.vue';
defineProps({ metadata: { type: Object, required: true } });
</script>
<template>
    <section
        class="rounded-2xl border border-[#F1F5F9] bg-white p-6 dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <header class="mb-5 flex items-center justify-between">
            <h4 class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">File Information</h4>
            <BaseBadge variant="success">Final Report</BaseBadge>
        </header>
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div v-for="(value, label) in metadata" :key="label">
                <p class="text-[11px] font-semibold uppercase tracking-wide text-[#9CA3AF] dark:text-[#64748B]">{{ label }}</p>
                <p class="text-sm font-medium text-[#0F172A] dark:text-[#F1F5F9]">{{ value }}</p>
            </div>
        </div>
    </section>
</template>
