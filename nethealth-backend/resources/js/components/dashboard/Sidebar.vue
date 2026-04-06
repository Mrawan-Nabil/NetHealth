<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import netHealthLogo3 from '../../assets/logo3.png';

defineProps({
    isDark: Boolean,
});

const page = usePage();
const emit = defineEmits(['toggle-theme', 'logout']);

// 🛑 ROUTE CHECK #1: Update these paths to match your web.php routes!
const menuItems = [
    {
        name: 'Home',
        // REPLACE THIS: Make sure this matches your main patient dashboard URL
        path: '/dashboard',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>',
    },
    {
        name: 'Profile',
        // REPLACE THIS: Make sure this matches your profile URL
        path: '/profile',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>',
    },
    {
        name: 'Medical Record',
        // REPLACE THIS: Make sure this matches your medical records index URL
        path: '/prescription',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>',
    },
    {
        name: 'Appointments',
        // REPLACE THIS: Make sure this matches your appointments index URL
        path: '/appointments',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>',
    },
    {
        name: 'Notification',
        // REPLACE THIS: Make sure this matches your notifications URL
        path: '/notifications',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>',
    },
    {
        name: 'Logout',
        path: '', // Leave this empty, logout is handled by the button click!
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>',
    },
];

const isActive = (path) => {
    if (!path || path === '') return false;

    // Inertia exposes the current URL here!
    const currentUrl = page.url;

    // 🛑 ROUTE CHECK #2: Update these 'startsWith' checks if your URLs change
    if (path === '/dashboard') {
        return currentUrl === '/dashboard' || currentUrl === '/';
    }

    if (path === '/medical-records') {
        return currentUrl.startsWith('/medical-records') || currentUrl.startsWith('/prescription') || currentUrl.startsWith('/test-results');
    }

    if (path === '/appointments') {
        return currentUrl.startsWith('/appointments') || currentUrl.startsWith('/doctor');
    }

    return currentUrl.startsWith(path);
};

const setTheme = (theme) => {
    emit('toggle-theme', theme);
};

const handleLogout = () => {
    emit('logout');
};
</script>

<template>
    <aside
        :class="isDark ? 'border-[#334155] bg-[#111827]' : 'border-[#E5E7EB] bg-white'"
        class="fixed top-0 left-0 flex h-screen w-64 flex-col border-r transition-all duration-300"
    >
        <div class="flex items-center gap-3 p-6 pb-4">
            <Link href="/home" class="heart-pulse-hover flex shrink-0 items-center gap-2 transition-transform duration-300">
                <img
                    :src="netHealthLogo3"
                    alt="NetHealth Logo"
                    class="mb-2 h-16 w-16"
                    style="width: 155px; height: 150px; margin-bottom: -50px; margin-top: -50px"
                />
            </Link>
        </div>

        <div class="mb-6 px-6">
            <div class="relative">
                <svg class="absolute top-1/2 left-3 h-4 w-4 -translate-y-1/2 text-[#6B7280]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input
                    type="text"
                    placeholder="Search"
                    :class="
                        isDark
                            ? 'border-[#334155] bg-[#1E293B] text-[#F8FAFC] placeholder-[#94A3B8]'
                            : 'border-[#E5E7EB] bg-[#F8FAFC] text-[#111827] placeholder-[#6B7280]'
                    "
                    class="w-full rounded-lg border py-2.5 pr-4 pl-9 text-sm transition-all duration-200 focus:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6]/20 focus:outline-none"
                />
            </div>
        </div>

        <nav class="flex-1 overflow-y-auto px-6">
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-4 px-3 text-xs font-semibold tracking-wide uppercase">General</p>
            <ul class="space-y-1">
                <li v-for="item in menuItems" :key="item.name">
                    <Link
                        v-if="item.name !== 'Logout'"
                        :href="item.path"
                        :class="[
                            isActive(item.path)
                                ? isDark
                                    ? 'border-[#14B8A6]/20 bg-[#14B8A6]/10 text-[#2DD4BF]'
                                    : 'border-[#14B8A6]/20 bg-[#14B8A6]/10 text-[#14B8A6]'
                                : isDark
                                  ? 'text-[#94A3B8] hover:bg-[#1E293B] hover:text-[#F8FAFC]'
                                  : 'text-[#6B7280] hover:bg-[#F8FAFC] hover:text-[#111827]',
                        ]"
                        class="flex w-full items-center gap-3 rounded-lg border border-transparent px-3 py-2.5 text-left transition-all duration-200"
                    >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="item.iconPath"></svg>
                        <span class="text-sm font-medium">{{ item.name }}</span>
                    </Link>

                    <button
                        v-else
                        @click="handleLogout"
                        :class="isDark ? 'text-[#EF4444] hover:bg-red-500/10' : 'text-[#EF4444] hover:bg-red-50 hover:text-[#DC2626]'"
                        class="flex w-full items-center gap-3 rounded-lg border border-transparent px-3 py-2.5 text-left transition-all duration-200"
                    >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="item.iconPath"></svg>
                        <span class="text-sm font-medium">{{ item.name }}</span>
                    </button>
                </li>
            </ul>
        </nav>

        <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="border-t p-6">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-[#F8FAFC]'" class="flex items-center rounded-lg p-1">
                <button
                    @click="setTheme('light')"
                    :class="!isDark ? 'bg-white text-[#111827] shadow-sm' : 'text-[#94A3B8] hover:bg-[#334155]'"
                    class="flex flex-1 items-center justify-center gap-2 rounded-md py-2 transition-all duration-200"
                >
                    <svg class="h-4 w-4" :class="!isDark ? 'text-[#F59E0B]' : 'text-[#94A3B8]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
                        />
                    </svg>
                    <span class="text-xs font-medium">Light</span>
                </button>
                <button
                    @click="setTheme('dark')"
                    :class="isDark ? 'bg-[#14B8A6] text-white shadow-lg' : 'text-[#6B7280] hover:bg-gray-200'"
                    class="flex flex-1 items-center justify-center gap-2 rounded-md py-2 transition-all duration-200"
                >
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
                        />
                    </svg>
                    <span class="text-xs font-medium">Dark</span>
                </button>
            </div>
        </div>
    </aside>
</template>
