<script setup lang="ts">
const props = withDefaults(
    defineProps<{
        modelValue?: string;
        label?: string;
        options: Array<{ label: string; value: string }>;
        placeholder?: string;
    }>(),
    {
        modelValue: '',
        label: '',
        placeholder: 'Select option',
    },
);

const emit = defineEmits<{
    (event: 'update:modelValue', value: string): void;
}>();
</script>

<template>
    <label class="block space-y-1.5">
        <span v-if="label" class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">{{ label }}</span>
        <span class="relative block">
            <select
                :value="modelValue"
                class="h-10 w-full appearance-none rounded-lg border border-[#E5E7EB] bg-white px-3 pr-9 text-sm text-[#0F172A] outline-none transition-all duration-200 hover:border-[#14B8A6]/50 focus:border-[#14B8A6] dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#F1F5F9] dark:hover:border-[#14B8A6]/50 dark:focus:border-[#14B8A6]"
                @change="emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
            >
                <option disabled value="">{{ placeholder }}</option>
                <option v-for="option in options" :key="option.value" :value="option.value">
                    {{ option.label }}
                </option>
            </select>
            <svg class="pointer-events-none absolute top-1/2 right-2.5 h-4 w-4 -translate-y-1/2 text-[#9CA3AF] dark:text-[#64748B]" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m6 9 6 6 6-6" />
            </svg>
        </span>
    </label>
</template>
