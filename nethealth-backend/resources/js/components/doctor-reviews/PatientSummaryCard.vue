<script setup>
import BaseButton from './BaseButton.vue';
import PatientAvatar from './PatientAvatar.vue';

defineProps({ name: { type: String, required: true }, initials: { type: String, required: true }, age: { type: Number, required: true }, gender: { type: String, required: true }, patientId: { type: String, required: true } });
defineEmits(['view-medical-record']);
</script>
<template>
    <article
        class="rounded-2xl border border-[#E5E7EB] bg-white p-6 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div class="flex items-center gap-3">
                <PatientAvatar :initials="initials" />
                <div>
                    <p class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ name }}</p>
                    <p class="text-sm text-[#64748B] dark:text-[#94A3B8]">Age: {{ age }} years | Gender: {{ gender }} | ID: {{ patientId }}</p>
                </div>
            </div>
            <BaseButton variant="success" size="sm" @click="$emit('view-medical-record')"><svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M5 4.5h9l5 5V19a1.5 1.5 0 0 1-1.5 1.5h-12A1.5 1.5 0 0 1 4 19V6A1.5 1.5 0 0 1 5.5 4.5Z" /></svg>View Medical Record</BaseButton>
        </div>
    </article>
</template>
