<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';
defineProps<{ summary: { testName: string; laboratory: string; regId: string; doctor: string; specialty: string; reportDate: string; reportId: string } }>();
</script>
<template>
    <section
        class="rounded-2xl border border-[#F1F5F9] bg-white p-6 dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="grid gap-4 md:grid-cols-5 md:items-center">
            <div class="flex items-center gap-3">
                <span class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]"><svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 21h8m-4-4v4M5 3h14M8 3v6a4 4 0 1 0 8 0V3" /></svg></span>
                <div><p class="text-[11px] font-semibold uppercase text-[#9CA3AF] dark:text-[#64748B]">Test Name</p><p class="font-bold text-[#0F172A] dark:text-[#F1F5F9]">{{ summary.testName }}</p></div>
            </div>
            <div><p class="text-[11px] font-semibold uppercase text-[#9CA3AF] dark:text-[#64748B]">Laboratory</p><p class="font-medium text-[#0F172A] dark:text-[#F1F5F9]">{{ summary.laboratory }}</p><p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ summary.regId }}</p></div>
            <div><p class="text-[11px] font-semibold uppercase text-[#9CA3AF] dark:text-[#64748B]">Doctor</p><p class="font-medium text-[#0F172A] dark:text-[#F1F5F9]">{{ summary.doctor }}</p><p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ summary.specialty }}</p></div>
            <div><p class="text-[11px] font-semibold uppercase text-[#9CA3AF] dark:text-[#64748B]">Report Info</p><p class="font-medium text-[#0F172A] dark:text-[#F1F5F9]">{{ summary.reportDate }}</p><p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ summary.reportId }}</p></div>
            <div class="md:text-right"><BaseBadge variant="success">Available</BaseBadge></div>
        </div>
    </section>
</template>
