<script setup>
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';

defineProps({ item: { type: Object, required: true } });
defineEmits(['view-details', 'view-prescription']);
</script>

<template>
    <article
        class="rounded-xl border border-[#E5E7EB] bg-white p-4 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <div class="min-w-[120px]"><BaseBadge variant="purple">{{ item.visitType }}</BaseBadge></div>
            <div class="flex-1">
                <p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.date }} - {{ item.time }}</p>
                <h5 class="mt-0.5 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.title }}</h5>
                <p class="mt-1 text-xs leading-relaxed text-[#64748B] dark:text-[#94A3B8]">{{ item.summary }}</p>
                <p v-if="item.prescriptionNote" class="mt-1 text-xs font-medium text-[#14B8A6] dark:text-[#2DD4BF]">{{ item.prescriptionNote }}</p>
            </div>
            <div class="flex min-w-[150px] flex-col items-start gap-2 lg:items-end">
                <BaseBadge :variant="item.status === 'Completed' ? 'emerald' : 'rose'">{{ item.status }}</BaseBadge>
                <BaseButton variant="secondary" size="sm" @click="$emit('view-details')">View Details</BaseButton>
                <BaseButton v-if="item.hasPrescription" variant="primary" size="sm" @click="$emit('view-prescription')">Prescription</BaseButton>
            </div>
        </div>
    </article>
</template>
