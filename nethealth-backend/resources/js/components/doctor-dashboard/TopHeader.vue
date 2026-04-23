<script setup>
defineProps({
    doctorName: { type: String, required: true },
    handle: { type: String, required: true },
    avatar: { type: String, required: true },
});

defineEmits(['toggle-sidebar']);
</script>

<template>
    <header class="sticky top-0 z-30 flex h-[72px] items-center justify-between border-b border-slate-200 bg-white/95 px-4 backdrop-blur-sm md:px-8 dark:border-slate-700 dark:bg-slate-900/95">
        <div class="flex items-center gap-3">
            <button
                type="button"
                class="inline-flex rounded-xl border border-slate-200 p-2 text-slate-600 transition-colors duration-200 hover:bg-slate-50 lg:hidden dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800"
                @click="$emit('toggle-sidebar')"
            >
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
            </button>
            <div>
                <h2 class="text-xl font-bold text-slate-900 dark:text-slate-100">Home</h2>
            </div>
        </div>

        <div class="hidden items-center gap-5 md:flex">
            <div class="flex items-center gap-2 text-sm text-slate-500 dark:text-slate-400">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 7v5l3 3M3.5 12a8.5 8.5 0 1 0 17 0 8.5 8.5 0 0 0-17 0Z" />
                </svg>
                Last Viewed 10 mins ago
            </div>

            <button class="rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white transition-colors duration-200 hover:bg-slate-700 dark:bg-slate-100 dark:text-slate-900 dark:hover:bg-slate-200">Share</button>

            <button class="relative rounded-full border border-slate-200 p-2 text-slate-500 transition-colors duration-200 hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800">
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 17h5l-1.4-1.4a2 2 0 0 1-.6-1.4V11a6 6 0 0 0-12 0v3.2c0 .5-.2 1-.6 1.4L4 17h5m6 0a3 3 0 1 1-6 0" />
                </svg>
                <span class="absolute -top-1 -right-1 inline-flex h-5 min-w-5 items-center justify-center rounded-full bg-red-500 px-1 text-[10px] font-semibold text-white">8</span>
            </button>

            <button class="flex items-center gap-3 rounded-full border border-teal-100 bg-teal-50 px-2.5 py-1.5 transition-colors duration-200 hover:bg-teal-100 dark:border-teal-500/30 dark:bg-teal-500/10 dark:hover:bg-teal-500/20">
                <img :src="avatar" :alt="doctorName" class="h-9 w-9 rounded-full object-cover" />
                <div class="text-left">
                    <p class="text-sm font-semibold text-slate-800 dark:text-slate-100">{{ doctorName }}</p>
                    <p class="text-xs text-slate-500 dark:text-slate-400">{{ handle }}</p>
                </div>
                <svg class="h-4 w-4 text-slate-500 dark:text-slate-300" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="m6 9 6 6 6-6" />
                </svg>
            </button>
        </div>
    </header>
</template>
