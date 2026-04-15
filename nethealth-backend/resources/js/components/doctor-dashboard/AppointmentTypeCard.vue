<script setup lang="ts">
import BaseCheckbox from './BaseCheckbox.vue';

defineProps<{
    title: string;
    description: string;
    icon: string;
    modelValue: boolean;
    accent?: 'teal' | 'slate';
}>();

defineEmits<{
    (event: 'update:modelValue', value: boolean): void;
}>();
</script>

<template>
    <label
        class="block rounded-xl border p-4 transition-all duration-200"
        :class="
            modelValue
                ? 'border-teal-200 bg-[#F0FDFA] shadow-sm dark:border-teal-500/20 dark:bg-teal-500/8'
                : 'border-[#E5E7EB] bg-white hover:border-teal-200 dark:border-[#334155] dark:bg-[#1E293B] dark:hover:border-[#14B8A6]/40'
        "
    >
        <div class="flex items-start justify-between gap-3">
            <div class="flex items-start gap-3">
                <span class="inline-flex h-10 w-10 items-center justify-center rounded-xl bg-white text-[#14B8A6] shadow-sm dark:bg-[#1E293B] dark:text-[#2DD4BF]">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" :d="icon" />
                    </svg>
                </span>
                <div>
                    <p class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ title }}</p>
                    <p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ description }}</p>
                    <slot />
                </div>
            </div>
            <BaseCheckbox :model-value="modelValue" @update:model-value="$emit('update:modelValue', $event)" />
        </div>
    </label>
</template>
