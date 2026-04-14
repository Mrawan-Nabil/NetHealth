<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import NotificationItem from '@/components/notifications/NotificationItem.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme, markAllNotificationsAsRead, clearAllNotifications } = useDashboard();

const props = defineProps({
    notifications: { type: Array, default: () => [] }
});

const isDark = computed(() => state.isDark);

const todayNotifications     = computed(() => props.notifications.filter(n => n.date === 'today'));
const yesterdayNotifications = computed(() => props.notifications.filter(n => n.date === 'yesterday'));
const unreadCount            = computed(() => props.notifications.filter(n => !n.read).length);

const toggleTheme = (theme) => setTheme(theme);

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const markAllAsRead = () => markAllNotificationsAsRead();

const clearAll = () => {
    if (confirm('Are you sure you want to clear all notifications?')) clearAllNotifications();
};
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Notifications"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">

                <!-- Page header -->
                <div class="mb-7 flex items-start justify-between gap-4">
                    <div>
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                            Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Notifications</span>
                        </p>
                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">
                            Notifications
                        </h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                            Stay updated with your latest healthcare activities and reminders.
                        </p>
                    </div>

                    <!-- Unread badge -->
                    <div v-if="unreadCount > 0" class="shrink-0">
                        <span class="badge badge-teal text-sm px-3 py-1.5">
                            {{ unreadCount }} unread
                        </span>
                    </div>
                </div>

                <!-- Action bar -->
                <div
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="mb-6 flex items-center justify-between gap-3 rounded-2xl border p-4"
                    style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                >
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="text-xs">
                        {{ notifications.length === 0 ? 'No notifications' : `${notifications.length} total notification${notifications.length !== 1 ? 's' : ''}` }}
                    </p>
                    <div class="flex items-center gap-2">
                        <button
                            v-if="unreadCount > 0"
                            @click="markAllAsRead"
                            class="btn-primary text-xs px-3 py-1.5"
                        >
                            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/>
                            </svg>
                            Mark All Read
                        </button>
                        <button
                            v-if="notifications.length > 0"
                            @click="clearAll"
                            :class="isDark
                                ? 'border-red-500/30 text-red-400 hover:bg-red-500/8'
                                : 'border-red-200 text-red-500 hover:bg-red-50'"
                            class="flex items-center gap-1.5 rounded-xl border px-3 py-1.5 text-xs font-semibold transition-all duration-200"
                        >
                            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                            </svg>
                            Clear All
                        </button>
                    </div>
                </div>

                <!-- Notifications content -->
                <div class="max-w-2xl space-y-7">

                    <!-- Today -->
                    <div v-if="todayNotifications.length > 0">
                        <div class="mb-3 flex items-center gap-3">
                            <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-[10px] font-bold uppercase tracking-widest whitespace-nowrap">
                                Today
                            </p>
                            <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="h-px flex-1" />
                        </div>
                        <div class="space-y-2">
                            <NotificationItem
                                v-for="n in todayNotifications"
                                :key="n.id"
                                :notification="n"
                                :is-dark="isDark"
                            />
                        </div>
                    </div>

                    <!-- Yesterday -->
                    <div v-if="yesterdayNotifications.length > 0">
                        <div class="mb-3 flex items-center gap-3">
                            <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-[10px] font-bold uppercase tracking-widest whitespace-nowrap">
                                Yesterday
                            </p>
                            <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="h-px flex-1" />
                        </div>
                        <div class="space-y-2">
                            <NotificationItem
                                v-for="n in yesterdayNotifications"
                                :key="n.id"
                                :notification="n"
                                :is-dark="isDark"
                            />
                        </div>
                    </div>

                    <!-- Empty state -->
                    <div
                        v-if="notifications.length === 0"
                        :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                        class="rounded-2xl border p-16 text-center"
                        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                    >
                        <div
                            :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                            class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl"
                        >
                            <svg :class="isDark ? 'text-[#334155]' : 'text-[#CBD5E1]'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                            </svg>
                        </div>
                        <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">You're all caught up!</h3>
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">No new notifications at this time.</p>
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>

<style scoped>
.animate-fadeInUp {
    animation: fadeInUp 0.4s ease-out both;
}
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
}
</style>
