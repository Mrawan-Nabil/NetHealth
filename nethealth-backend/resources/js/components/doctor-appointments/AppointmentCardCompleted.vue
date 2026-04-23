<script setup>
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
import PatientAvatar from './PatientAvatar.vue';

defineProps({ item: { type: Object, required: true } });
defineEmits(['edit', 'prescription']);

</script>

<template>
    <article
        class="dash-card rounded-2xl border border-[#F1F5F9] bg-white p-5 shadow-[var(--shadow-card)] dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div class="flex items-center gap-3">
                <PatientAvatar :initials="item.initials" />
                <p class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.patientName }}</p>
            </div>
            <div class="flex flex-wrap items-center gap-3 text-[#64748B] dark:text-[#94A3B8]">
                <span class="inline-flex items-center gap-1.5 text-sm"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 2v3m8-3v3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" /></svg>{{ item.date }}</span>
                <span class="inline-flex items-center gap-1.5 text-sm"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" /></svg>{{ item.time }}</span>
                <BaseBadge :variant="item.visitType === 'In-Clinic Visit' ? 'visit-clinic' : 'visit-followup'">{{ item.visitType }}</BaseBadge>
            </div>
            <div class="flex flex-wrap items-center gap-2">
                <BaseBadge variant="completed">Completed</BaseBadge>
                <BaseButton v-if="item.canEdit" variant="secondary" size="sm" @click="$emit('edit')"><svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 20h4l10-10-4-4L4 16v4Z" /></svg>Edit</BaseButton>
                <BaseButton :variant="item.canEdit ? 'success' : 'primary'" size="sm" @click="$emit('prescription')">
                    <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M5 4.5h9l5 5V19a1.5 1.5 0 0 1-1.5 1.5h-12A1.5 1.5 0 0 1 4 19V6A1.5 1.5 0 0 1 5.5 4.5Z" /></svg>
                    {{ item.canEdit ? 'View Prescription' : 'Write Prescription' }}
                </BaseButton>
            </div>
        </div>
    </article>
</template>
