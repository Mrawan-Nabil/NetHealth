<script setup>
import BaseButton from './BaseButton.vue';
import BaseBadge from './BaseBadge.vue';
import SectionCard from './SectionCard.vue';

defineProps({
    days: { type: Array, required: true },
});

defineEmits(['edit-schedule']);
</script>

<template>
    <SectionCard title="Weekly Availability" subtitle="Status: Currently active for patient bookings">
        <template #header-right>
            <BaseButton variant="primary" @click="$emit('edit-schedule')">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 20h9 M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4z" />
                </svg>
                Edit Schedule
            </BaseButton>
        </template>

        <div class="grid grid-cols-2 gap-3 md:grid-cols-4 xl:grid-cols-7">
            <div
                v-for="item in days"
                :key="item.day"
                class="rounded-xl border px-3 py-3.5 text-center transition-colors duration-200"
                :class="
                    item.available
                        ? 'border-teal-200 bg-[#F0FDFA] text-[#0F766E] dark:border-teal-500/20 dark:bg-teal-500/8 dark:text-teal-400'
                        : 'border-[#E5E7EB] bg-[#F8FAFC] text-[#94A3B8] dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#64748B]'
                "
            >
                <p class="text-sm font-semibold">{{ item.day }}</p>
                <p class="mt-1 text-[11px] leading-tight">{{ item.hours }}</p>
            </div>
        </div>

        <div class="mt-4 flex items-center gap-3 text-xs">
            <BaseBadge variant="teal">Available</BaseBadge>
            <BaseBadge variant="gray">Day Off</BaseBadge>
        </div>
    </SectionCard>
</template>
