<script setup>
import netHealthLogo3 from '../../assets/logo3.png';
import ThemeToggle from './ThemeToggle.vue';

defineProps({
    navItems: { type: Array, required: true },
    isOpen: { type: Boolean, required: true },
    isDark: { type: Boolean, required: true },
});

defineEmits(['navigate', 'close', 'toggle-theme']);

const iconMap = {
    home: 'M3 12 12 4l9 8M5 10v10h14V10',
    profile: 'M16 7a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM4 20a8 8 0 0 1 16 0',
    appointments: 'M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2Z',
    reviews: 'm9 11 3 3L22 4 M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11',
    notification: 'M15 17h5l-1.4-1.4a2 2 0 0 1-.6-1.4V11a6 6 0 0 0-12 0v3.2c0 .5-.2 1-.6 1.4L4 17h5m6 0a3 3 0 1 1-6 0',
    logout: 'M16 17l5-5-5-5M21 12H9 M13 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h8',
};
</script>

<template>
    <div>
        <transition name="fade">
            <button
                v-if="isOpen"
                type="button"
                class="fixed inset-0 z-30 bg-slate-900/45 lg:hidden"
                @click="$emit('close')"
            />
        </transition>

        <aside
            class="fixed top-0 left-0 z-40 flex h-screen w-72 flex-col border-r border-slate-200 bg-white px-5 py-5 transition-transform duration-300 lg:translate-x-0 dark:border-slate-700 dark:bg-slate-900"
            :class="isOpen ? 'translate-x-0' : '-translate-x-full'"
        >
            <div class="flex items-center justify-between">
                <img :src="netHealthLogo3" alt="NetHealth logo" class="h-11 w-auto" />
                <button
                    type="button"
                    class="rounded-lg p-1.5 text-slate-500 hover:bg-slate-100 lg:hidden dark:text-slate-300 dark:hover:bg-slate-700"
                    @click="$emit('close')"
                >
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M18 6 6 18M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="mt-5">
                <label class="relative block">
                    <svg class="pointer-events-none absolute top-2.5 left-3 h-4 w-4 text-teal-500/80" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="m21 21-4.3-4.3m1.3-4.7a6 6 0 1 1-12 0 6 6 0 0 1 12 0Z" />
                    </svg>
                    <input
                        type="text"
                        placeholder="Search"
                        class="w-full rounded-full border border-teal-200 bg-white py-2 pr-4 pl-9 text-sm text-slate-700 outline-none transition-colors duration-200 focus:border-teal-400 dark:border-slate-600 dark:bg-slate-800 dark:text-slate-200 dark:placeholder:text-slate-400"
                    />
                </label>
            </div>

            <nav class="mt-6 space-y-1.5">
                <p class="px-3 text-[11px] font-semibold uppercase tracking-wider text-slate-400">General</p>
                <button
                    v-for="item in navItems"
                    :key="item.key"
                    type="button"
                    class="group flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200"
                    :class="
                        item.active
                            ? 'bg-teal-50 text-teal-700 dark:bg-teal-500/15 dark:text-teal-300'
                            : 'text-slate-600 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800'
                    "
                    @click="$emit('navigate', item.key)"
                >
                    <svg class="h-[18px] w-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" :d="iconMap[item.icon]" />
                    </svg>
                    {{ item.label }}
                </button>
            </nav>

            <div class="mt-auto border-t border-slate-200 pt-4 dark:border-slate-700">
                <ThemeToggle :is-dark="isDark" @toggle="$emit('toggle-theme')" />
            </div>
        </aside>
    </div>
</template>
