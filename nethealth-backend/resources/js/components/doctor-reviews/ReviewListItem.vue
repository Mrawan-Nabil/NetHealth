<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';
import BaseButton from './BaseButton.vue';
import PatientAvatar from './PatientAvatar.vue';

defineProps<{
    item: { id: number; patientName: string; initials: string; filesCount: number; date: string; time: string; status: 'Pending' | 'Reviewed' };
}>();
defineEmits<{
    (event: 'view-files', id: number): void;
    (event: 'view-details', id: number): void;
    (event: 'edit-review', id: number): void;
}>();
</script>

<template>
    <article
        class="dash-card rounded-2xl border border-[#E5E7EB] bg-white p-5 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">

            <!-- Patient info -->
            <div class="flex min-w-0 flex-1 items-center gap-3">
                <PatientAvatar :initials="item.initials" />
                <div class="min-w-0">
                    <p class="truncate text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.patientName }}</p>
                    <p class="text-sm text-[#64748B] dark:text-[#94A3B8]">{{ item.filesCount }} {{ item.filesCount > 1 ? 'files' : 'file' }}</p>
                </div>
            </div>

            <!-- Date / time — fixed width, always right-aligned -->
            <div class="w-[130px] shrink-0 text-right">
                <p class="flex items-center justify-end gap-1 text-sm text-[#64748B] dark:text-[#94A3B8]">
                    <svg class="h-3.5 w-3.5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" />
                    </svg>
                    {{ item.date }}
                </p>
                <p class="mt-0.5 text-xs text-[#94A3B8] dark:text-[#64748B]">{{ item.time }}</p>
            </div>

            <!-- Actions -->
            <div class="flex shrink-0 flex-wrap items-center gap-2">
                <BaseBadge :variant="item.status === 'Pending' ? 'pending' : 'reviewed'">{{ item.status }}</BaseBadge>
                <BaseButton v-if="item.status === 'Pending'" variant="success" size="sm" @click="$emit('view-files', item.id)">View Files</BaseButton>
                <template v-else>
                    <BaseButton variant="secondary" size="sm" @click="$emit('view-details', item.id)">View Details</BaseButton>
                    <BaseButton variant="ghost" size="sm" @click="$emit('edit-review', item.id)">Edit Review</BaseButton>
                </template>
            </div>

        </div>
    </article>
</template>
