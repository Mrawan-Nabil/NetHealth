<script setup lang="ts">
defineProps<{ isDark: boolean }>();
defineEmits<{ (event: 'toggle'): void }>();
</script>

<template>
    <button
        type="button"
        class="flex w-full items-center justify-between rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm font-medium text-slate-600 transition-all duration-200 hover:border-teal-200 hover:bg-teal-50 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-300"
        @click="$emit('toggle')"
    >
        <span>{{ isDark ? 'Dark' : 'Light' }}</span>
        <span class="relative h-5 w-10 rounded-full bg-slate-200 dark:bg-slate-600">
            <span class="absolute top-0.5 left-0.5 h-4 w-4 rounded-full bg-white transition-transform duration-200" :class="isDark ? 'translate-x-5' : ''" />
        </span>
    </button>
</template>
