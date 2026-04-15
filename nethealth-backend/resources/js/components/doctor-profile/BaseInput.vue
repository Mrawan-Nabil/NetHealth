<script setup lang="ts">
import { computed, useAttrs } from 'vue';

const props = withDefaults(
    defineProps<{
        modelValue?: string | number;
        label?: string;
        type?: string;
        placeholder?: string;
        hint?: string;
        icon?: 'calendar' | 'eye' | 'eye-off' | 'none';
        inputClass?: string;
    }>(),
    {
        modelValue: '',
        label: '',
        type: 'text',
        placeholder: '',
        hint: '',
        icon: 'none',
        inputClass: '',
    },
);

const emit = defineEmits<{
    (event: 'update:modelValue', value: string): void;
    (event: 'icon-click'): void;
}>();

const attrs = useAttrs();

// Only show the icon button for non-date types to avoid clashing with native date picker
const hasIcon = computed(() => props.icon !== 'none' && props.type !== 'date');
</script>

<template>
    <label class="block space-y-1.5">
        <span v-if="label" class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">{{ label }}</span>
        <div
            class="flex h-10 w-full items-center rounded-lg border border-[#E5E7EB] bg-white px-3 text-sm text-[#0F172A] transition-all duration-200 hover:border-[#14B8A6]/50 focus-within:border-[#14B8A6] dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#F1F5F9] dark:hover:border-[#14B8A6]/50 dark:focus-within:border-[#14B8A6]"
        >
            <input
                :value="modelValue"
                :type="type"
                :placeholder="placeholder"
                :class="['h-full w-full bg-transparent outline-none placeholder:text-[#9CA3AF] dark:placeholder:text-[#475569]', inputClass]"
                v-bind="attrs"
                @input="emit('update:modelValue', ($event.target as HTMLInputElement).value)"
            />
            <button
                v-if="hasIcon"
                type="button"
                tabindex="-1"
                class="ml-1.5 shrink-0 text-[#9CA3AF] transition-colors duration-200 hover:text-[#14B8A6] dark:text-[#64748B] dark:hover:text-[#2DD4BF]"
                @click="emit('icon-click')"
            >
                <svg v-if="icon === 'calendar'" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" />
                </svg>
                <svg v-else-if="icon === 'eye'" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.5 12s3.5-6.5 9.5-6.5S21.5 12 21.5 12s-3.5 6.5-9.5 6.5S2.5 12 2.5 12Z" />
                    <circle cx="12" cy="12" r="3" stroke-width="2" />
                </svg>
                <svg v-else class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3l18 18M10.7 6.1A9.6 9.6 0 0 1 12 6c6 0 9.5 6 9.5 6a15.1 15.1 0 0 1-3.2 4.1M6.6 6.6C4.2 8 2.5 12 2.5 12s3.5 6 9.5 6a9.9 9.9 0 0 0 4.1-.8M9.9 9.9A3 3 0 0 0 14.1 14.1" />
                </svg>
            </button>
        </div>
        <span v-if="hint" class="text-[11px] text-[#9CA3AF] dark:text-[#64748B]">{{ hint }}</span>
    </label>
</template>
