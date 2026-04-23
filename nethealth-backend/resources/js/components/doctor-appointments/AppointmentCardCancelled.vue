<script setup>
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
import PatientAvatar from './PatientAvatar.vue';

defineProps({ item: { type: Object, required: true } });
defineEmits(['reschedule']);
</script>

<template>
    <article
        class="dash-card rounded-2xl border border-[#F1F5F9] bg-white p-5 shadow-[var(--shadow-card)] dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div class="flex items-start gap-3">
                <PatientAvatar :initials="item.initials" muted />
                <div>
                    <p class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.patientName }}</p>
                    <p class="mt-1 inline-flex items-center gap-3 text-sm text-[#64748B] dark:text-[#94A3B8]">
                        <span class="inline-flex items-center gap-1"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 2v3m8-3v3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" /></svg>{{ item.date }}</span>
                        <span class="inline-flex items-center gap-1"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" /></svg>{{ item.time }}</span>
                    </p>
                    <p class="mt-2 text-sm text-[#64748B] dark:text-[#94A3B8]">{{ item.cancelledNote }}</p>
                    <p class="text-sm text-[#64748B] dark:text-[#94A3B8]">Reason: {{ item.reason }}</p>
                </div>
            </div>
            <div class="flex items-center gap-2">
                <BaseBadge variant="cancelled">Cancelled</BaseBadge>
                <BaseButton variant="success" size="sm" @click="$emit('reschedule')"><svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M21 12a9 9 0 1 1-2.64-6.36M21 4v6h-6" /></svg>Reschedule</BaseButton>
            </div>
        </div>
    </article>
</template>
