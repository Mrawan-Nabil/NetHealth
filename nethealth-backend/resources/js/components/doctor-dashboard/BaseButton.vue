<script setup lang="ts">
import { computed } from 'vue';

type Variant = 'primary' | 'secondary' | 'ghost';
type Size = 'sm' | 'md';

const props = withDefaults(
    defineProps<{
        variant?: Variant;
        size?: Size;
        type?: 'button' | 'submit' | 'reset';
        block?: boolean;
        disabled?: boolean;
    }>(),
    {
        variant: 'secondary',
        size: 'md',
        type: 'button',
        block: false,
        disabled: false,
    },
);

const classes = computed(() => {
    const variants: Record<Variant, string> = {
        primary: 'bg-[#14B8A6] text-white hover:bg-[#0D9488] hover:shadow-[0_4px_14px_rgba(20,184,166,0.35)] active:scale-95',
        secondary: 'border border-[#E5E7EB] bg-white text-[#374151] hover:bg-[#F9FAFB] dark:border-[#334155] dark:bg-[#0F172A] dark:text-[#94A3B8] dark:hover:bg-[#1E293B] dark:hover:text-[#F1F5F9]',
        ghost: 'border border-transparent bg-transparent text-[#64748B] hover:bg-[#F8FAFC] hover:text-[#0F172A] dark:text-[#94A3B8] dark:hover:bg-[#334155]/60 dark:hover:text-[#F1F5F9]',
    };

    const sizes: Record<Size, string> = {
        sm: 'h-8 px-3 text-xs',
        md: 'h-9 px-4 text-sm',
    };

    return `inline-flex items-center justify-center gap-1.5 rounded-lg font-semibold transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:ring-offset-2 focus-visible:ring-offset-white disabled:pointer-events-none disabled:opacity-50 dark:focus-visible:ring-offset-[#0F172A] ${variants[props.variant]} ${sizes[props.size]} ${props.block ? 'w-full' : ''}`;
});
</script>

<template>
    <button :type="type" :disabled="disabled" :class="classes">
        <slot />
    </button>
</template>
