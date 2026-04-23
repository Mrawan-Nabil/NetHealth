<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import NotificationItem from '@/components/notifications/NotificationItem.vue';
import { useDashboard } from '@/composables/useDashboard';

// ─── Props (Inertia Data Contract) ───────────────────────────────────────────
const props = defineProps({
    doctor: { type: Object, required: true },
    notifications: { type: Array, default: () => [] },
});

// ─── State ───────────────────────────────────────────────────────────────────
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);

// Local copy to avoid direct prop mutation (Bug Fix #9)
const localNotifications = ref(props.notifications.map((n) => ({ ...n })));

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification', active: true },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

// ─── Computed ─────────────────────────────────────────────────────────────────
const isDark = computed(() => state.isDark);
const todayNotifications = computed(() => localNotifications.value.filter((n) => n.date === 'today'));
const yesterdayNotifications = computed(() => localNotifications.value.filter((n) => n.date === 'yesterday'));
const unreadCount = computed(() => localNotifications.value.filter((n) => !n.read).length);

// ─── Handlers ────────────────────────────────────────────────────────────────
const toggleTheme = (value) => setTheme(value);

const markAllAsRead = () => {
    localNotifications.value = localNotifications.value.map((n) => ({ ...n, read: true }));
};

const markAsRead = (id) => {
    const notification = localNotifications.value.find((n) => n.id === id);
    if (notification) notification.read = true;
};

const clearAll = () => {
    localNotifications.value = [];
};

const handleNotificationClick = (notification) => {
    markAsRead(notification.id);
    if (notification.type === 'appointment') router.get('/doctor/appointments');
    else if (notification.type === 'lab') router.get('/doctor/reviews/files');
    else if (notification.type === 'prescription') router.get('/doctor/reviews/medical-record');
};

const handleNav = (key) => {
    navItems.value = navItems.value.map((item) => ({ ...item, active: item.key === key }));
    sidebarOpen.value = false;
    if (key === 'home') return router.get('/doctor/dashboard');
    if (key === 'profile') return router.get('/doctor/profile');
    if (key === 'appointments') return router.get('/doctor/appointments');
    if (key === 'reviews') return router.get('/doctor/reviews');
    if (key === 'notification') return router.get('/doctor/notifications');
    if (key === 'logout') return router.get('/logout');
};
</script>

<template>
    <Head title="Doctor Notifications" />

    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <AppSidebar :nav-items="navItems" :is-open="sidebarOpen" :is-dark="isDark" @close="sidebarOpen = false" @navigate="handleNav" @toggle-theme="toggleTheme" />

        <div class="lg:ml-64">
            <TopHeader
                title="Notifications"
                :doctor-name="props.doctor.fullName"
                :handle="props.doctor.handle"
                :avatar="props.doctor.avatar ?? ''"
                :notifications="localNotifications"
                :is-dark="isDark"
                :show-last-viewed="false"
                :show-share="false"
                @mark-read="markAsRead"
                @mark-all-read="markAllAsRead"
                @toggle-sidebar="sidebarOpen = true"
            />

            <main class="p-4 sm:p-6 lg:p-7 animate-fadeInUp">
                <div class="mb-7 flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                    <div>
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                            Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Notifications</span>
                        </p>
                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Notifications</h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">Stay updated with patient activity, requests, and review reminders.</p>
                    </div>

                    <span v-if="unreadCount > 0" class="badge badge-teal w-fit px-3 py-1.5 text-sm">{{ unreadCount }} unread</span>
                </div>

                <div
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="mb-6 flex flex-col gap-3 rounded-2xl border p-4 sm:flex-row sm:items-center sm:justify-between"
                    style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                >
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="text-xs">
                        {{ localNotifications.length === 0 ? 'No notifications' : `${localNotifications.length} total notification${localNotifications.length !== 1 ? 's' : ''}` }}
                    </p>
                    <div class="flex flex-wrap items-center gap-2">
                        <button v-if="unreadCount > 0" class="btn-primary px-3 py-1.5 text-xs" @click="markAllAsRead">
                            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7" />
                            </svg>
                            Mark All Read
                        </button>
                        <button
                            v-if="localNotifications.length > 0"
                            :class="isDark ? 'border-red-500/30 text-red-400 hover:bg-red-500/8' : 'border-red-200 text-red-500 hover:bg-red-50'"
                            class="inline-flex items-center gap-1.5 rounded-xl border px-3 py-1.5 text-xs font-semibold transition-all duration-200 focus-visible:ring-2 focus-visible:ring-red-400/30 focus-visible:outline-none"
                            @click="clearAll"
                        >
                            Clear All
                        </button>
                    </div>
                </div>

                <div class="max-w-2xl space-y-7">
                    <section v-if="todayNotifications.length > 0">
                        <div class="mb-3 flex items-center gap-3">
                            <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-[10px] font-bold tracking-widest uppercase whitespace-nowrap">Today</p>
                            <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="h-px flex-1" />
                        </div>
                        <div class="space-y-2">
                            <button v-for="notification in todayNotifications" :key="notification.id" type="button" class="block w-full text-left" @click="handleNotificationClick(notification)">
                                <NotificationItem :notification="notification" :is-dark="isDark" />
                            </button>
                        </div>
                    </section>

                    <section v-if="yesterdayNotifications.length > 0">
                        <div class="mb-3 flex items-center gap-3">
                            <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-[10px] font-bold tracking-widest uppercase whitespace-nowrap">Yesterday</p>
                            <div :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'" class="h-px flex-1" />
                        </div>
                        <div class="space-y-2">
                            <button v-for="notification in yesterdayNotifications" :key="notification.id" type="button" class="block w-full text-left" @click="handleNotificationClick(notification)">
                                <NotificationItem :notification="notification" :is-dark="isDark" />
                            </button>
                        </div>
                    </section>

                    <section
                        v-if="localNotifications.length === 0"
                        :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                        class="rounded-2xl border p-10 text-center sm:p-16"
                        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                    >
                        <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl">
                            <svg :class="isDark ? 'text-[#334155]' : 'text-[#CBD5E1]'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                            </svg>
                        </div>
                        <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">You're all caught up!</h3>
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">No new notifications at this time.</p>
                    </section>
                </div>
            </main>
        </div>
    </div>
</template>
