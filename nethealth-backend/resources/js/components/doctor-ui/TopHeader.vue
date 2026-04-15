<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { computed, onMounted, onUnmounted, ref } from 'vue';
import NotificationDropdown from '@/components/dashboard/NotificationDropdown.vue';

type DoctorNotification = {
    id: number;
    type: 'appointment' | 'prescription' | 'lab' | 'message' | 'test' | 'info';
    title: string;
    message: string;
    description: string;
    time: string;
    date: 'today' | 'yesterday';
    badge: string;
    read: boolean;
};

const props = withDefaults(
    defineProps<{
        title: string;
        doctorName: string;
        handle: string;
        avatar: string;
        lastViewed?: string;
        showLastViewed?: boolean;
        showShare?: boolean;
        notifications?: DoctorNotification[];
        isDark?: boolean;
    }>(),
    {
        lastViewed: '10 mins ago',
        showLastViewed: true,
        showShare: true,
        notifications: () => [],
        isDark: false,
    },
);

const emit = defineEmits<{
    (event: 'toggle-sidebar'): void;
    (event: 'mark-read', id: number): void;
    (event: 'mark-all-read'): void;
    (event: 'notification-click', notification: DoctorNotification): void;
}>();

const shareCopied = ref(false);
const userMenuOpen = ref(false);
const userMenuRef = ref<HTMLElement | null>(null);
const localNotifications = ref<DoctorNotification[]>([
    {
        id: 1,
        type: 'appointment',
        title: 'Appointment Confirmed',
        message: 'Sarah Johnson confirmed her cardiology follow-up for 10:00 AM.',
        description: 'Sarah Johnson confirmed her cardiology follow-up for 10:00 AM.',
        time: '2 hours ago',
        date: 'today',
        badge: 'APPOINTMENT',
        read: false,
    },
    {
        id: 2,
        type: 'prescription',
        title: 'Prescription Renewal Request',
        message: 'Robert Chen requested a renewal for Lisinopril 20mg.',
        description: 'Robert Chen requested a renewal for Lisinopril 20mg.',
        time: '4 hours ago',
        date: 'today',
        badge: 'PRESCRIPTION',
        read: false,
    },
    {
        id: 3,
        type: 'lab',
        title: 'New Lab Results',
        message: 'A metabolic panel is ready for Emily Davis.',
        description: 'A metabolic panel is ready for Emily Davis.',
        time: 'Yesterday at 3:45 PM',
        date: 'yesterday',
        badge: 'LAB RESULTS',
        read: true,
    },
]);

const visibleNotifications = computed(() => (props.notifications.length ? props.notifications : localNotifications.value));

const markRead = (id: number) => {
    if (props.notifications.length) {
        emit('mark-read', id);
        return;
    }
    const notification = localNotifications.value.find((item) => item.id === id);
    if (notification) notification.read = true;
};

const markAllRead = () => {
    if (props.notifications.length) {
        emit('mark-all-read');
        return;
    }
    localNotifications.value = localNotifications.value.map((item) => ({ ...item, read: true }));
};

const openNotification = (notification: DoctorNotification) => {
    markRead(notification.id);
    emit('notification-click', notification);
    if (notification.type === 'appointment') router.get('/doctor/appointments');
    else if (notification.type === 'lab') router.get('/doctor/reviews/files');
    else if (notification.type === 'prescription') router.get('/doctor/reviews/medical-record');
    else router.get('/doctor/notifications');
};

const handleShare = async () => {
    shareCopied.value = true;
    try {
        await navigator.clipboard?.writeText(window.location.href);
    } catch {
        // Visual feedback is still useful when clipboard access is unavailable.
    }
    window.setTimeout(() => {
        shareCopied.value = false;
    }, 1500);
};

const openProfile = () => {
    userMenuOpen.value = false;
    router.get('/doctor/profile');
};

const handleLogout = () => {
    userMenuOpen.value = false;
    router.get('/logout');
};

const handleClickOutside = (event: MouseEvent) => {
    if (userMenuRef.value && !userMenuRef.value.contains(event.target as Node)) {
        userMenuOpen.value = false;
    }
};

onMounted(() => document.addEventListener('click', handleClickOutside));
onUnmounted(() => document.removeEventListener('click', handleClickOutside));
</script>

<template>
    <header
        class="sticky top-0 z-40 flex h-[72px] items-center justify-between border-b border-[#E5E7EB] bg-white/95 px-4 backdrop-blur-sm transition-colors duration-300 sm:px-6 lg:px-7 dark:border-[#1E293B] dark:bg-[#0F172A]/95"
        style="box-shadow: 0 1px 0 0 rgba(0,0,0,0.04);"
    >
        <div class="flex min-w-0 items-center gap-3">
            <button
                type="button"
                class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-[#E5E7EB] text-[#64748B] transition-all duration-200 hover:bg-[#F8FAFC] hover:text-[#0F172A] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none lg:hidden dark:border-[#334155] dark:text-[#94A3B8] dark:hover:bg-[#1E293B] dark:hover:text-[#F1F5F9]"
                aria-label="Open sidebar"
                @click="emit('toggle-sidebar')"
            >
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
            </button>
            <h1 class="truncate text-base font-semibold tracking-tight text-[#0F172A] dark:text-[#F1F5F9]">
                {{ doctorName || title }}
            </h1>
        </div>

        <div class="flex shrink-0 items-center gap-1.5 sm:gap-2">
            <div
                v-if="showLastViewed"
                class="hidden items-center gap-1.5 rounded-lg bg-[#F8FAFC] px-3 py-1.5 text-xs text-[#94A3B8] dark:bg-[#1E293B] dark:text-[#64748B] sm:flex"
            >
                <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>{{ lastViewed }}</span>
            </div>

            <button
                v-if="showShare"
                type="button"
                class="hidden items-center gap-1.5 rounded-lg bg-[#F8FAFC] px-3 py-1.5 text-xs font-semibold text-[#64748B] transition-all duration-200 hover:bg-[#F1F5F9] hover:text-[#0F172A] active:scale-[0.98] dark:bg-[#1E293B] dark:text-[#94A3B8] dark:hover:bg-[#334155] dark:hover:text-[#F1F5F9] sm:flex"
                @click="handleShare"
            >
                <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                </svg>
                {{ shareCopied ? 'Copied' : 'Share' }}
            </button>

            <NotificationDropdown
                :is-dark="isDark"
                :notifications="visibleNotifications"
                all-href="/doctor/notifications"
                @mark-read="markRead"
                @mark-all-read="markAllRead"
                @click="openNotification"
            />

            <div ref="userMenuRef" class="relative">
                <button
                    type="button"
                    class="flex items-center gap-2.5 rounded-xl border-l border-[#E5E7EB] px-2 py-1.5 pl-3 transition-all duration-200 hover:bg-[#F8FAFC] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none sm:gap-3 sm:pl-4 dark:border-[#334155] dark:hover:bg-[#1E293B]"
                    @click="userMenuOpen = !userMenuOpen"
                >
                    <img :src="avatar" :alt="doctorName" class="h-8 w-8 rounded-full object-cover ring-2 ring-[#E5E7EB] sm:h-9 sm:w-9 dark:ring-[#334155]" />
                    <div class="hidden text-left md:block">
                        <p class="text-sm leading-tight font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ doctorName }}</p>
                        <p class="text-xs text-[#94A3B8] dark:text-[#64748B]">{{ handle }}</p>
                    </div>
                    <svg
                        class="hidden h-3.5 w-3.5 text-[#9CA3AF] transition-transform duration-200 sm:block dark:text-[#64748B]"
                        :class="userMenuOpen ? 'rotate-180' : ''"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>

                <Transition name="dropdown">
                    <div
                        v-if="userMenuOpen"
                        class="absolute right-0 z-50 mt-2 w-56 overflow-hidden rounded-2xl border border-[#E5E7EB] bg-white dark:border-[#334155] dark:bg-[#1E293B]"
                        style="box-shadow: 0 10px 30px -5px rgba(0,0,0,0.12), 0 4px 12px -4px rgba(0,0,0,0.08);"
                    >
                        <div class="flex items-center gap-3 bg-[#F8FAFC] px-4 py-4 dark:bg-[#0F172A]">
                            <img :src="avatar" :alt="doctorName" class="h-10 w-10 rounded-xl object-cover ring-2 ring-[#F1F5F9] dark:ring-[#334155]" />
                            <div class="min-w-0">
                                <p class="truncate text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ doctorName }}</p>
                                <p class="truncate text-xs text-[#94A3B8] dark:text-[#64748B]">{{ handle }}</p>
                            </div>
                        </div>
                        <div class="p-1.5">
                            <button
                                type="button"
                                class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left text-[#374151] transition-all duration-150 hover:bg-[#F8FAFC] hover:text-[#0F172A] dark:text-[#94A3B8] dark:hover:bg-[#334155]/60 dark:hover:text-[#F1F5F9]"
                                @click="openProfile"
                            >
                                <svg class="h-4 w-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                </svg>
                                <span class="text-xs font-semibold">View Profile</span>
                            </button>
                            <button
                                type="button"
                                class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left text-[#374151] transition-all duration-150 hover:bg-[#F8FAFC] hover:text-[#0F172A] dark:text-[#94A3B8] dark:hover:bg-[#334155]/60 dark:hover:text-[#F1F5F9]"
                                @click="router.get('/doctor/profile')"
                            >
                                <svg class="h-4 w-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                </svg>
                                <span class="text-xs font-semibold">Settings</span>
                            </button>
                        </div>
                        <div class="border-t border-[#E5E7EB] p-1.5 dark:border-[#334155]">
                            <button
                                type="button"
                                class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left text-red-500 transition-all duration-150 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-500/10"
                                @click="handleLogout"
                            >
                                <svg class="h-4 w-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                </svg>
                                <span class="text-xs font-semibold">Sign Out</span>
                            </button>
                        </div>
                    </div>
                </Transition>
            </div>
        </div>
    </header>
</template>

<style scoped>
.dropdown-enter-active,
.dropdown-leave-active {
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.dropdown-enter-from,
.dropdown-leave-to {
    opacity: 0;
    transform: translateY(-6px) scale(0.97);
}
</style>
