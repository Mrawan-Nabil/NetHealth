<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';

defineProps<{
    patientName: string;
    appointmentType: string;
    description: string;
    time: string;
    status: string;
    avatar: string;
}>();

defineEmits<{ (event: 'view-details'): void }>();
</script>

<template>
    <article class="flex flex-col gap-3 rounded-xl border border-transparent bg-[#F8FAFC] p-3.5 transition-colors duration-200 hover:border-[#E5E7EB] hover:bg-[#F1F5F9] sm:flex-row sm:items-center sm:justify-between dark:bg-[#0F172A] dark:hover:border-[#334155]/60 dark:hover:bg-[#334155]/40">
        <div class="flex items-center gap-3">
            <img :src="avatar" :alt="patientName" class="h-10 w-10 rounded-full object-cover" />
            <div>
                <p class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ patientName }}</p>
                <div class="mt-1 flex items-center gap-2">
                    <BaseBadge variant="teal">{{ appointmentType }}</BaseBadge>
                    <span class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ description }}</span>
                </div>
            </div>
        </div>
        <div class="flex items-center gap-3 self-end sm:self-auto">
            <p class="text-right text-sm font-semibold text-[#14B8A6] dark:text-[#2DD4BF]">{{ time }}</p>
            <BaseBadge :variant="status === 'Waiting' ? 'warning' : 'success'">{{ status }}</BaseBadge>
            <button
                type="button"
                class="text-sm font-semibold text-[#14B8A6] transition-colors duration-200 hover:text-[#0D9488] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-[#2DD4BF]"
                @click="$emit('view-details')"
            >
                View Details
            </button>
        </div>
    </article>
</template>
