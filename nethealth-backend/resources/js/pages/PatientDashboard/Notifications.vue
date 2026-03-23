<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import NotificationItem from '@/components/notifications/NotificationItem.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme, markAllNotificationsAsRead, clearAllNotifications } = useDashboard();

// LARAVEL DATA BINDING: Expects Array notifications
const props = defineProps({
    notifications: {
        type: Array,
        required: true,
        default: () => []
    }
});

// Computed properties
const isDark = computed(() => state.isDark);

const todayNotifications = computed(() => {
    return props.notifications.filter((n) => n.date === 'today');
});

const yesterdayNotifications = computed(() => {
    return props.notifications.filter((n) => n.date === 'yesterday');
});

// Methods
const toggleTheme = (theme) => {
    setTheme(theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const markAllAsRead = () => {
    markAllNotificationsAsRead();
};

const clearAll = () => {
    if (confirm('Are you sure you want to clear all notifications?')) {
        clearAllNotifications();
    }
};

// Lifecycle
onMounted(() => {
    // Data provided by Inertia Props
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <!-- Sidebar -->
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <!-- Main Content -->
        <div class="ml-64">
            <!-- Top Navbar -->
            <TopNavbar
                title="Notifications"
                :is-dark="isDark"
                :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <!-- Page Content -->
            <main class="max-w-4xl p-6">
                <!-- Page Header -->
                <div class="mb-6">
                    <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">Notifications</h1>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                        Stay updated with your latest healthcare activities and reminders.
                    </p>
                </div>

                <!-- Action Buttons -->
                <div class="mb-6 flex items-center gap-3">
                    <button
                        @click="markAllAsRead"
                        class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                    >
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                        Mark All as Read
                    </button>
                    <button
                        @click="clearAll"
                        :class="isDark ? 'border-red-500/50 text-red-400 hover:bg-red-500/10' : 'border-red-300 text-red-600 hover:bg-red-50'"
                        class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-semibold transition-colors"
                    >
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                            />
                        </svg>
                        Clear All
                    </button>
                </div>

                <!-- Notifications List -->
                <div class="space-y-6">
                    <!-- Today Section -->
                    <div v-if="todayNotifications.length > 0">
                        <h2 :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-3 text-xs font-semibold tracking-wider uppercase">
                            Today
                        </h2>
                        <div class="space-y-2">
                            <NotificationItem
                                v-for="notification in todayNotifications"
                                :key="notification.id"
                                :notification="notification"
                                :is-dark="isDark"
                            />
                        </div>
                    </div>

                    <!-- Yesterday Section -->
                    <div v-if="yesterdayNotifications.length > 0">
                        <h2 :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-3 text-xs font-semibold tracking-wider uppercase">
                            Yesterday
                        </h2>
                        <div class="space-y-2">
                            <NotificationItem
                                v-for="notification in yesterdayNotifications"
                                :key="notification.id"
                                :notification="notification"
                                :is-dark="isDark"
                            />
                        </div>
                    </div>

                    <!-- Empty State -->
                    <div
                        v-if="notifications.length === 0"
                        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                        class="rounded-lg border p-12 text-center"
                    >
                        <svg
                            class="mx-auto mb-4 h-16 w-16"
                            :class="isDark ? 'text-[#94A3B8]' : 'text-gray-400'"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                            />
                        </svg>
                        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 text-lg font-semibold">No Notifications</h3>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                            You're all caught up! Check back later for updates.
                        </p>
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>
