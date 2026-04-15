<script setup lang="ts">
defineProps<{ isDark: boolean }>();
defineEmits<{ (event: 'toggle'): void }>();
</script>

<template>
    <button
        type="button"
        class="flex w-full items-center justify-between rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm font-medium text-slate-600 transition-all duration-200 hover:border-teal-200 hover:bg-teal-50 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-300 dark:hover:border-teal-500/30 dark:hover:bg-teal-500/10"
        @click="$emit('toggle')"
    >
        <span class="flex items-center gap-2">
            <svg v-if="!isDark" class="h-4 w-4 text-amber-500" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 3v2.2m0 13.6V21m9-9h-2.2M5.2 12H3m15.364 6.364-1.556-1.556M7.192 7.192 5.636 5.636m12.728 0-1.556 1.556M7.192 16.808l-1.556 1.556M15.5 12a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" />
            </svg>
            <svg v-else class="h-4 w-4 text-indigo-300" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z" />
            </svg>
            {{ isDark ? 'Dark' : 'Light' }}
        </span>
        <span class="relative h-5 w-10 rounded-full bg-slate-200 dark:bg-slate-600">
            <span class="absolute top-0.5 left-0.5 h-4 w-4 rounded-full bg-white transition-transform duration-200" :class="isDark ? 'translate-x-5' : ''" />
        </span>
    </button>
</template>
