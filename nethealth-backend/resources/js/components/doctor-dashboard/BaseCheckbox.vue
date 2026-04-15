<script setup lang="ts">
defineProps<{
    modelValue: boolean;
    label?: string;
}>();

defineEmits<{
    (event: 'update:modelValue', value: boolean): void;
}>();
</script>

<template>
    <label class="inline-flex items-center gap-2 text-sm text-[#64748B] dark:text-[#94A3B8]">
        <span class="relative inline-flex h-5 w-5 items-center justify-center">
            <input
                type="checkbox"
                class="peer sr-only"
                :checked="modelValue"
                @change="$emit('update:modelValue', ($event.target as HTMLInputElement).checked)"
            />
            <span class="h-5 w-5 rounded-md border border-[#E5E7EB] bg-white transition-colors duration-200 peer-checked:border-[#14B8A6] peer-checked:bg-[#14B8A6] dark:border-[#334155] dark:bg-[#0F172A]" />
            <svg class="pointer-events-none absolute h-3.5 w-3.5 text-white opacity-0 transition-opacity duration-200 peer-checked:opacity-100" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.2" d="m5 13 4 4L19 7" />
            </svg>
        </span>
        <span v-if="label">{{ label }}</span>
    </label>
</template>
