<script setup lang="ts">
const props = withDefaults(
    defineProps<{
        modelValue?: string;
        label?: string;
        placeholder?: string;
        rows?: number;
    }>(),
    {
        modelValue: '',
        label: '',
        placeholder: '',
        rows: 4,
    },
);

const emit = defineEmits<{
    (event: 'update:modelValue', value: string): void;
}>();
</script>

<template>
    <label class="block space-y-1.5">
        <span v-if="label" class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">{{ label }}</span>
        <textarea
            :value="modelValue"
            :rows="rows"
            :placeholder="placeholder"
            class="w-full rounded-lg border border-[#E5E7EB] bg-white px-3 py-2.5 text-sm text-[#0F172A] outline-none transition-all duration-200 hover:border-[#14B8A6]/50 focus:border-[#14B8A6] resize-none dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#F1F5F9] dark:hover:border-[#14B8A6]/50 dark:focus:border-[#14B8A6] dark:placeholder:text-[#64748B]"
            @input="emit('update:modelValue', ($event.target as HTMLTextAreaElement).value)"
        />
    </label>
</template>
