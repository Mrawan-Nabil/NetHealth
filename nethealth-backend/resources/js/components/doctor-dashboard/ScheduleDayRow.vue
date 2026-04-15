<script setup lang="ts">
import BaseTimeInput from './BaseTimeInput.vue';
import BaseToggle from './BaseToggle.vue';

defineProps<{
    day: {
        name: string;
        enabled: boolean;
        from: string;
        to: string;
    };
}>();

defineEmits<{
    (event: 'toggle'): void;
    (event: 'update:from', value: string): void;
    (event: 'update:to', value: string): void;
}>();
</script>

<template>
    <div
        class="rounded-xl border p-4 transition-all duration-200"
        :class="
            day.enabled
                ? 'border-teal-200 bg-white shadow-sm dark:border-teal-500/20 dark:bg-[#1E293B]'
                : 'border-[#E5E7EB] bg-[#F8FAFC] dark:border-[#334155] dark:bg-[#0F172A]'
        "
    >
        <div class="flex items-center justify-between gap-3">
            <p class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ day.name }}</p>
            <div class="flex items-center gap-2.5">
                <span
                    class="text-xs font-semibold"
                    :class="day.enabled ? 'text-[#14B8A6] dark:text-[#2DD4BF]' : 'text-[#94A3B8] dark:text-[#64748B]'"
                >
                    {{ day.enabled ? 'On' : 'Off' }}
                </span>
                <BaseToggle :model-value="day.enabled" @update:model-value="$emit('toggle')" />
            </div>
        </div>

        <transition name="slide">
            <div v-if="day.enabled" class="mt-4 flex flex-wrap items-center gap-3">
                <BaseTimeInput label="From" :model-value="day.from" @update:model-value="$emit('update:from', $event)" />
                <span class="text-sm text-[#94A3B8] dark:text-[#64748B]">to</span>
                <BaseTimeInput :model-value="day.to" @update:model-value="$emit('update:to', $event)" />
            </div>
        </transition>
    </div>
</template>
