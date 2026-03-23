<script setup>
import NotificationDropdown from './NotificationDropdown.vue';
import UserDropdown from './UserDropdown.vue';

defineProps({
    title: {
        type: String,
        default: 'Dashboard',
    },
    lastViewed: {
        type: String,
        default: '10 mins ago',
    },
    showLastViewed: {
        type: Boolean,
        default: true,
    },
    showShare: {
        type: Boolean,
        default: true,
    },
    notifications: {
        type: Array,
        default: () => [],
    },
    isDark: Boolean,
});

const emit = defineEmits(['mark-read', 'mark-all-read', 'notification-click', 'logout']);

const handleMarkRead = (id) => {
    emit('mark-read', id);
};

const handleMarkAllRead = () => {
    emit('mark-all-read');
};

const handleNotificationClick = (notification) => {
    emit('notification-click', notification);
};

const handleLogout = () => {
    emit('logout');
};
</script>

<template>
    <nav
        :class="isDark ? 'border-[#334155] bg-[#111827]' : 'border-[#E5E7EB] bg-white'"
        class="flex items-center justify-between border-b px-8 py-4 shadow-sm transition-all duration-300"
    >
        <div class="flex items-center gap-6">
            <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-semibold">
                {{ $page.props.auth.user.full_name }}
            </h1>
        </div>

        <div class="flex items-center gap-4">
            <div v-if="showLastViewed" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="flex items-center gap-2 text-xs">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>Last viewed {{ lastViewed }}</span>
            </div>

            <button
                v-if="showShare"
                :class="isDark ? 'bg-[#14B8A6] shadow-lg shadow-teal-500/20 hover:bg-[#2DD4BF]' : 'bg-[#111827] hover:bg-black'"
                class="rounded-lg px-4 py-2 text-sm font-medium text-white transition-all duration-300"
            >
                Share
            </button>

            <NotificationDropdown
                :is-dark="isDark"
                :notifications="notifications"
                @mark-read="handleMarkRead"
                @mark-all-read="handleMarkAllRead"
                @click="handleNotificationClick"
            />

            <UserDropdown :is-dark="isDark" :user="$page.props.auth.user" @logout="handleLogout" />
        </div>
    </nav>
</template>
