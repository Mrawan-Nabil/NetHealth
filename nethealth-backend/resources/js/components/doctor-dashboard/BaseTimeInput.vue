<script setup lang="ts">
defineProps<{
    modelValue: string;
    label?: string;
    disabled?: boolean;
}>();

defineEmits<{
    (event: 'update:modelValue', value: string): void;
}>();
</script>

<template>
    <label class="flex items-center gap-2 text-sm text-[#64748B] dark:text-[#94A3B8]">
        <span v-if="label" class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">{{ label }}</span>
        <input
            :value="modelValue"
            :disabled="disabled"
            type="text"
            inputmode="text"
            class="h-10 min-w-[108px] rounded-lg border border-[#E5E7EB] bg-white px-3 text-sm font-medium text-[#0F172A] outline-none transition-all duration-200 hover:border-[#14B8A6]/50 focus:border-[#14B8A6] disabled:cursor-not-allowed disabled:opacity-60 dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#F1F5F9] dark:hover:border-[#14B8A6]/50 dark:focus:border-[#14B8A6]"
            @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        />
    </label>
</template>
