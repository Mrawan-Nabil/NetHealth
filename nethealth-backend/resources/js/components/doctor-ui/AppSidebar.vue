<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import netHealthLogo3 from '../../assets/logo3.png';

type NavItem = {
    key: string;
    label: string;
    icon: 'home' | 'profile' | 'appointments' | 'reviews' | 'notification' | 'logout';
    active?: boolean;
};

defineProps<{ navItems: NavItem[]; isOpen: boolean; isDark: boolean }>();
defineEmits<{
    (event: 'navigate', key: string): void;
    (event: 'close'): void;
    (event: 'toggle-theme', theme: 'light' | 'dark'): void;
}>();

const iconMap: Record<NavItem['icon'], string> = {
    home: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>',
    profile: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>',
    appointments: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>',
    reviews: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>',
    notification: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>',
    logout: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>',
};
</script>

<template>
    <transition name="fade">
        <button
            v-if="isOpen"
            type="button"
            class="fixed inset-0 z-30 bg-slate-950/45 backdrop-blur-[1px] lg:hidden"
            aria-label="Close sidebar"
            @click="$emit('close')"
        />
    </transition>

    <aside
        :class="[
            isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white',
            isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0',
        ]"
        class="fixed top-0 left-0 z-40 flex h-screen w-64 flex-col border-r transition-all duration-300 lg:translate-x-0"
        style="box-shadow: 1px 0 0 0 rgba(0,0,0,0.04);"
    >
        <div class="relative flex h-[80px] shrink-0 items-center justify-center px-4">
            <Link href="/home" class="group flex w-full items-center justify-center transition-transform duration-300 hover:scale-105">
                <img
                    :src="netHealthLogo3"
                    alt="NetHealth Logo"
                    class="heart-pulse-hover h-[150px] w-[200px] object-contain drop-shadow-md transition-all duration-200"
                    style="margin-top: -35px; margin-bottom: -35px;"
                />
            </Link>
        </div>

        <div :class="isDark ? 'bg-[#334155]' : 'bg-[#E5E7EB]'" class="mx-5 h-px shrink-0" />

        <div class="shrink-0 px-5 pt-4 pb-2">
            <div class="relative">
                <svg
                    class="pointer-events-none absolute top-1/2 left-3 h-3.5 w-3.5 -translate-y-1/2"
                    :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input
                    type="text"
                    placeholder="Search..."
                    :class="isDark
                        ? 'border-[#334155] bg-[#0F172A] text-[#F1F5F9] placeholder-[#64748B] focus:border-[#14B8A6] focus:bg-[#0F172A]'
                        : 'border-[#F1F5F9] bg-[#F8FAFC] text-[#0F172A] placeholder-[#9CA3AF] focus:border-[#14B8A6] focus:bg-white'"
                    class="w-full rounded-lg border py-2 pr-4 pl-9 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/20 focus:outline-none"
                />
            </div>
        </div>

        <nav class="flex-1 overflow-y-auto px-3 py-2">
            <p
                :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'"
                class="mb-2 px-3 text-[10px] font-semibold tracking-widest uppercase"
            >
                Menu
            </p>
            <ul class="space-y-0.5">
                <li v-for="item in navItems" :key="item.key">
                    <button
                        type="button"
                        :class="[
                            'group relative flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200',
                            item.key === 'logout'
                                ? isDark
                                    ? 'text-[#64748B] hover:bg-red-500/8 hover:text-red-400'
                                    : 'text-[#64748B] hover:bg-red-50 hover:text-red-600'
                                : item.active
                                  ? isDark
                                      ? 'bg-[#14B8A6]/10 text-[#2DD4BF] nav-item-active'
                                      : 'bg-[#CCFBF1] text-[#0D9488] nav-item-active'
                                  : isDark
                                    ? 'text-[#64748B] hover:bg-[#1E293B] hover:text-[#CBD5E1]'
                                    : 'text-[#64748B] hover:bg-[#F8FAFC] hover:text-[#0F172A]',
                        ]"
                        @click="$emit('navigate', item.key)"
                    >
                        <span v-if="item.active && item.key !== 'logout'" class="absolute left-0 h-5 w-0.5 rounded-r-full bg-[#14B8A6]" />
                        <span
                            :class="[
                                'flex h-8 w-8 shrink-0 items-center justify-center rounded-lg transition-colors duration-200',
                                item.key === 'logout'
                                    ? isDark
                                        ? 'bg-[#0F172A] group-hover:bg-red-500/10'
                                        : 'bg-transparent group-hover:bg-red-50'
                                    : item.active
                                      ? isDark ? 'bg-[#14B8A6]/20' : 'bg-[#14B8A6]/12'
                                      : isDark ? 'bg-[#0F172A] group-hover:bg-[#334155]' : 'bg-transparent group-hover:bg-[#F1F5F9]',
                            ]"
                        >
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="iconMap[item.icon]" />
                        </span>
                        <span>{{ item.label }}</span>
                    </button>
                </li>
            </ul>
        </nav>

        <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="shrink-0 border-t p-4">
            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="flex items-center gap-1 rounded-lg p-1">
                <button
                    type="button"
                    @click="$emit('toggle-theme', 'light')"
                    :class="!isDark
                        ? 'bg-white text-[#0F172A] shadow-sm ring-1 ring-black/5'
                        : 'text-[#64748B] hover:text-[#94A3B8]'"
                    class="flex flex-1 items-center justify-center gap-1.5 rounded-md py-1.5 text-xs font-semibold transition-all duration-200"
                >
                    <svg class="h-3.5 w-3.5" :class="!isDark ? 'text-amber-400' : ''" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                    Light
                </button>
                <button
                    type="button"
                    @click="$emit('toggle-theme', 'dark')"
                    :class="isDark
                        ? 'bg-[#14B8A6] text-white shadow-sm shadow-teal-500/30'
                        : 'text-[#9CA3AF] hover:text-[#6B7280]'"
                    class="flex flex-1 items-center justify-center gap-1.5 rounded-md py-1.5 text-xs font-semibold transition-all duration-200"
                >
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                    </svg>
                    Dark
                </button>
            </div>
        </div>
    </aside>
</template>
