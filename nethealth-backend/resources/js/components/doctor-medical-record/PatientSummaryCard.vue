<script setup>
import BaseBadge from './BaseBadge.vue';

defineProps({ patient: { type: Object, required: true } });
</script>

<template>
    <section
        class="rounded-2xl border border-[#E5E7EB] bg-white p-6 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-4 md:flex-row md:items-center">
            <span class="inline-flex h-14 w-14 shrink-0 items-center justify-center rounded-xl bg-[#14B8A6] text-lg font-semibold text-white">{{ patient.initials }}</span>
            <div>
                <h4 class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ patient.name }}</h4>
                <div class="mt-1.5"><BaseBadge variant="teal">Patient ID: {{ patient.id }}</BaseBadge></div>
                <p class="mt-2 text-sm text-[#64748B] dark:text-[#94A3B8]">DOB: {{ patient.dob }} · {{ patient.email }}</p>
            </div>
        </div>
    </section>
</template>
