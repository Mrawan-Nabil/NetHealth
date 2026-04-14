<script setup>
import { computed } from 'vue';

const props = defineProps({
    value:     { type: Number, required: true },
    label:     { type: String, required: true },
    icon:      { type: String, required: true },
    isDark:    Boolean,
    clickable: { type: Boolean, default: true },
});

const emit = defineEmits(['click']);

const handleClick = () => {
    if (props.clickable) emit('click', { label: props.label, value: props.value });
};

const iconMeta = computed(() => {
    const map = {
        calendar:     { bg: 'bg-blue-50',   bgDark: 'bg-blue-500/10',   color: 'text-blue-500',   path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>' },
        prescription: { bg: 'bg-amber-50',  bgDark: 'bg-amber-500/10',  color: 'text-amber-500',  path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>' },
        test:         { bg: 'bg-violet-50', bgDark: 'bg-violet-500/10', color: 'text-violet-500', path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>' },
    };
    return map[props.icon] || { bg: 'bg-slate-50', bgDark: 'bg-slate-500/10', color: 'text-slate-400', path: '' };
});
</script>

<template>
    <div
        @click="handleClick"
        :class="[
            isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white',
            clickable ? 'cursor-pointer' : '',
        ]"
        class="group dash-card border p-5 shadow-[var(--shadow-card)] select-none"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="mb-4 flex items-center justify-between">
            <!-- Icon badge -->
            <div
                :class="isDark ? iconMeta.bgDark : iconMeta.bg"
                class="flex h-10 w-10 items-center justify-center rounded-xl transition-transform duration-200 group-hover:scale-105"
            >
                <svg
                    :class="iconMeta.color"
                    class="h-5 w-5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    v-html="iconMeta.path"
                />
            </div>

            <!-- Trend arrow (decorative, upward) -->
            <div
                :class="isDark ? 'bg-emerald-500/10 text-emerald-400' : 'bg-emerald-50 text-emerald-500'"
                class="flex items-center gap-0.5 rounded-full px-2 py-0.5 text-[10px] font-semibold"
            >
                <svg class="h-2.5 w-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 15l7-7 7 7"/>
                </svg>
                Active
            </div>
        </div>

        <!-- Value -->
        <p
            :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'"
            class="mb-0.5 text-3xl font-bold leading-none tracking-tight"
        >
            {{ value }}
        </p>

        <!-- Label -->
        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-xs font-medium">
            {{ label }}
        </p>
    </div>
</template>
