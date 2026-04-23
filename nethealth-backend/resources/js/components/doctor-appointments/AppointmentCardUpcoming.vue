<script setup>
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
import PatientAvatar from './PatientAvatar.vue';

defineProps({ item: { type: Object, required: true } });
defineEmits(['view-patient', 'review-files', 'cancel']);

</script>

<template>
    <article
        class="dash-card rounded-2xl border border-[#F1F5F9] bg-white p-5 shadow-[var(--shadow-card)] dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div class="flex items-center gap-3">
                <PatientAvatar :initials="item.initials" />
                <div>
                    <p class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.patientName }}</p>
                    <p class="text-sm text-[#64748B] dark:text-[#94A3B8]">{{ item.visitType }}</p>
                    <p class="mt-1 inline-flex items-center gap-3 text-sm text-[#64748B] dark:text-[#94A3B8]">
                        <span class="inline-flex items-center gap-1"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 2v3m8-3v3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" /></svg>{{ item.date }}</span>
                        <span class="inline-flex items-center gap-1"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" /></svg>{{ item.time }}</span>
                    </p>
                </div>
            </div>
            <div class="flex flex-wrap items-center gap-2">
                <BaseBadge :variant="item.status === 'Pending' ? 'pending' : 'confirmed'">{{ item.status }}</BaseBadge>
                <BaseButton variant="secondary" size="sm" @click="$emit('view-patient')">View Patient</BaseButton>
                <BaseButton :variant="item.action === 'start' ? 'secondary' : 'success'" :disabled="item.action === 'start'" size="sm" @click="$emit('review-files')">
                    {{ item.action === 'start' ? 'Start Visit' : 'Review Files' }}
                </BaseButton>
                <BaseButton variant="icon" size="sm" @click="$emit('cancel')"><svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M18 6 6 18M6 6l12 12" /></svg></BaseButton>
            </div>
        </div>
    </article>
</template>
