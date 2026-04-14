<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import netHealthLogo3 from '../../assets/logo3.png';

defineProps({
    isDark: Boolean,
});

const page = usePage();
const emit = defineEmits(['toggle-theme', 'logout']);

const menuItems = [
    {
        name: 'Home',
        path: '/dashboard',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>',
    },
    {
        name: 'Profile',
        path: '/profile',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>',
    },
    {
        name: 'Medical Record',
        path: '/prescription',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>',
    },
    {
        name: 'Appointments',
        path: '/appointments',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>',
    },
    {
        name: 'Notification',
        path: '/notifications',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>',
    },
    {
        name: 'Logout',
        path: '',
        iconPath:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>',
    },
];

const isActive = (path) => {
    if (!path || path === '') return false;
    const currentUrl = page.url;
    if (path === '/dashboard') {
        return currentUrl === '/dashboard' || currentUrl === '/';
    }
    if (path === '/prescription') {
        return (
            currentUrl.startsWith('/medical-records') ||
            currentUrl.startsWith('/prescription') ||
            currentUrl.startsWith('/test-results') ||
            currentUrl.startsWith('/imaging') ||
            currentUrl.startsWith('/visit-history')
        );
    }
    if (path === '/appointments') {
        return currentUrl.startsWith('/appointments') || currentUrl.startsWith('/doctor');
    }
    return currentUrl.startsWith(path);
};

const setTheme = (theme) => emit('toggle-theme', theme);
const handleLogout = () => emit('logout');
</script>

<template>
    <aside
        :class="isDark ? 'border-[#1E293B] bg-[#0F172A]' : 'border-[#F1F5F9] bg-white'"
        class="fixed top-0 left-0 flex h-screen w-64 flex-col border-r transition-colors duration-300"
        style="box-shadow: 1px 0 0 0 rgba(0,0,0,0.04);"
    >
        <!-- Logo Lockup -->
        <div class="relative flex h-[80px] shrink-0 items-center justify-center px-4">
            <Link href="/home" class="group flex w-full items-center justify-center transition-transform duration-300 hover:scale-105">
                <!-- Enlarged Original Logo -->
                <img 
                    :src="netHealthLogo3" 
                    alt="NetHealth Logo" 
                    class="w-[200px] h-[150px] object-contain drop-shadow-md heart-pulse-hover transition-all duration-200" 
                    style="margin-top: -35px; margin-bottom: -35px;"
                />
            </Link>
        </div>

        <!-- Divider -->
        <div :class="isDark ? 'bg-[#1E293B]' : 'bg-[#F1F5F9]'" class="mx-5 h-px shrink-0" />

        <!-- Search -->
        <div class="px-5 pt-4 pb-2 shrink-0">
            <div class="relative">
                <svg
                    class="absolute top-1/2 left-3 h-3.5 w-3.5 -translate-y-1/2 pointer-events-none"
                    :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'"
                    fill="none" stroke="currentColor" viewBox="0 0 24 24"
                >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input
                    type="text"
                    placeholder="Search…"
                    :class="isDark
                        ? 'border-[#1E293B] bg-[#1E293B] text-[#F1F5F9] placeholder-[#475569] focus:border-[#14B8A6] focus:bg-[#1E293B]'
                        : 'border-[#F1F5F9] bg-[#F8FAFC] text-[#0F172A] placeholder-[#9CA3AF] focus:border-[#14B8A6] focus:bg-white'"
                    class="w-full rounded-lg border py-2 pr-4 pl-9 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"
                />
            </div>
        </div>

        <!-- Nav -->
        <nav class="flex-1 overflow-y-auto px-3 py-2">
            <p
                :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'"
                class="mb-2 px-3 text-[10px] font-semibold tracking-widest uppercase"
            >
                Menu
            </p>
            <ul class="space-y-0.5">
                <li v-for="item in menuItems" :key="item.name">
                    <!-- Regular links -->
                    <Link
                        v-if="item.name !== 'Logout'"
                        :href="item.path"
                        :class="[
                            'group flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200',
                            isActive(item.path)
                                ? isDark
                                    ? 'bg-[#14B8A6]/10 text-[#2DD4BF] nav-item-active'
                                    : 'bg-[#CCFBF1] text-[#0D9488] nav-item-active'
                                : isDark
                                  ? 'text-[#64748B] hover:bg-[#1E293B] hover:text-[#CBD5E1]'
                                  : 'text-[#64748B] hover:bg-[#F8FAFC] hover:text-[#0F172A]',
                        ]"
                    >
                        <!-- Active indicator bar -->
                        <span
                            v-if="isActive(item.path)"
                            class="absolute left-0 h-5 w-0.5 rounded-r-full bg-[#14B8A6]"
                        />
                        <span
                            :class="[
                                'flex h-8 w-8 shrink-0 items-center justify-center rounded-lg transition-colors duration-200',
                                isActive(item.path)
                                    ? isDark ? 'bg-[#14B8A6]/15' : 'bg-[#14B8A6]/12'
                                    : isDark ? 'bg-[#1E293B] group-hover:bg-[#334155]' : 'bg-transparent group-hover:bg-[#F1F5F9]'
                            ]"
                        >
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="item.iconPath" />
                        </span>
                        <span>{{ item.name }}</span>
                    </Link>

                    <!-- Logout -->
                    <button
                        v-else
                        @click="handleLogout"
                        :class="isDark
                            ? 'text-[#64748B] hover:bg-red-500/8 hover:text-red-400'
                            : 'text-[#64748B] hover:bg-red-50 hover:text-red-600'"
                        class="group flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200"
                    >
                        <span
                            :class="isDark ? 'bg-[#1E293B] group-hover:bg-red-500/10' : 'bg-transparent group-hover:bg-red-50'"
                            class="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg transition-colors duration-200"
                        >
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="item.iconPath" />
                        </span>
                        <span>{{ item.name }}</span>
                    </button>
                </li>
            </ul>
        </nav>

        <!-- Theme toggle -->
        <div
            :class="isDark ? 'border-[#1E293B]' : 'border-[#F1F5F9]'"
            class="shrink-0 border-t p-4"
        >
            <div
                :class="isDark ? 'bg-[#1E293B]' : 'bg-[#F8FAFC]'"
                class="flex items-center rounded-xl p-1 gap-1"
            >
                <button
                    @click="setTheme('light')"
                    :class="!isDark
                        ? 'bg-white text-[#0F172A] shadow-sm ring-1 ring-black/5'
                        : 'text-[#475569] hover:text-[#94A3B8]'"
                    class="flex flex-1 items-center justify-center gap-1.5 rounded-lg py-1.5 text-xs font-semibold transition-all duration-200"
                >
                    <svg class="h-3.5 w-3.5" :class="!isDark ? 'text-amber-400' : ''" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                    Light
                </button>
                <button
                    @click="setTheme('dark')"
                    :class="isDark
                        ? 'bg-[#14B8A6] text-white shadow-sm shadow-teal-500/30'
                        : 'text-[#9CA3AF] hover:text-[#6B7280]'"
                    class="flex flex-1 items-center justify-center gap-1.5 rounded-lg py-1.5 text-xs font-semibold transition-all duration-200"
                >
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                    </svg>
                    Dark
                </button>
            </div>
        </div>
    </aside>
</template>
