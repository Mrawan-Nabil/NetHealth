<script setup>
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
import PatientAvatar from './PatientAvatar.vue';

defineProps({ item: { type: Object, required: true } });
defineEmits(['view-patient', 'review-files', 'cancel', 'reschedule']);
</script>

<template>
    <article
        class="dash-card overflow-hidden rounded-2xl border border-[#F1F5F9] bg-white dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <!-- Patient info body -->
        <div class="flex items-start gap-3 p-5">
            <PatientAvatar :initials="item.initials" />
            <div>
                <p class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.patientName }}</p>
                <p class="mt-0.5 inline-flex items-center gap-3 text-sm text-[#64748B] dark:text-[#94A3B8]">
                    <span class="inline-flex items-center gap-1">
                        <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 2v3m8-3v3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" />
                        </svg>
                        {{ item.date }}
                    </span>
                    <span class="inline-flex items-center gap-1">
                        <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" />
                        </svg>
                        {{ item.time }}
                    </span>
                </p>
            </div>
        </div>

        <!-- Teal action strip (bottom) — mirrors Completed's action strip structure -->
        <div class="flex flex-wrap items-center justify-between gap-2 border-t border-[#E2FAF7] bg-[#F0FDFA] px-5 py-3 dark:border-[#0F172A] dark:bg-[#14B8A6]/8">
            <div class="flex flex-wrap items-center gap-2">
                <BaseBadge :variant="item.status === 'Pending' ? 'pending' : 'confirmed'">{{ item.status }}</BaseBadge>
                <BaseBadge :variant="item.visitType === 'In-Clinic Visit' ? 'visit-clinic' : 'visit-followup'">{{ item.visitType }}</BaseBadge>
            </div>
            <div class="flex items-center gap-2">
                <BaseButton variant="secondary" size="sm" @click="$emit('reschedule', item)">
                    <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M21 12a9 9 0 1 1-2.64-6.36M21 4v6h-6" />
                    </svg>
                    Reschedule
                </BaseButton>
                <BaseButton variant="secondary" size="sm" @click="$emit('view-patient')">View Patient</BaseButton>
                <BaseButton variant="success" size="sm" @click="$emit('review-files')">
                    {{ item.action === 'start' ? 'Start Visit' : 'Review Files' }}
                </BaseButton>
                <BaseButton variant="icon" size="sm" @click="$emit('cancel')">
                    <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M18 6 6 18M6 6l12 12" />
                    </svg>
                </BaseButton>
            </div>
        </div>
    </article>
</template>
