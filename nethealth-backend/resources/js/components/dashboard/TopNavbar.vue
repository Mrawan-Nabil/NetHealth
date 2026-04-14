<script setup>
import NotificationDropdown from './NotificationDropdown.vue';
import UserDropdown from './UserDropdown.vue';

defineProps({
    title: { type: String, default: 'Dashboard' },
    lastViewed: { type: String, default: '10 mins ago' },
    showLastViewed: { type: Boolean, default: true },
    showShare: { type: Boolean, default: true },
    notifications: { type: Array, default: () => [] },
    isDark: Boolean,
    // Optional: kept for backward compat; UserDropdown reads auth from page global
    user: { type: Object, default: null },
});

const emit = defineEmits(['mark-read', 'mark-all-read', 'notification-click', 'logout']);

const handleMarkRead      = (id)           => emit('mark-read', id);
const handleMarkAllRead   = ()             => emit('mark-all-read');
const handleNotificationClick = (n)        => emit('notification-click', n);
const handleLogout        = ()             => emit('logout');
</script>

<template>
    <nav
        :class="isDark
            ? 'border-[#1E293B] bg-[#0F172A]/95'
            : 'border-[#F1F5F9] bg-white/95'"
        class="sticky top-0 z-40 flex h-[72px] items-center justify-between border-b px-7 backdrop-blur-sm transition-colors duration-300"
        style="box-shadow: 0 1px 0 0 rgba(0,0,0,0.04);"
    >
        <!-- Left: page title -->
        <div class="flex items-center gap-3">
            <h1
                :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'"
                class="text-base font-semibold tracking-tight"
            >
                {{ $page.props.auth.user.full_name }}
            </h1>
        </div>

        <!-- Right: actions -->
        <div class="flex items-center gap-2">
            <!-- Last viewed pill -->
            <div
                v-if="showLastViewed"
                :class="isDark
                    ? 'bg-[#1E293B] text-[#64748B]'
                    : 'bg-[#F8FAFC] text-[#94A3B8]'"
                class="hidden items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs sm:flex"
            >
                <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>{{ lastViewed }}</span>
            </div>

            <!-- Share button -->
            <button
                v-if="showShare"
                :class="isDark
                    ? 'bg-[#1E293B] text-[#94A3B8] hover:bg-[#334155] hover:text-[#F1F5F9]'
                    : 'bg-[#F8FAFC] text-[#64748B] hover:bg-[#F1F5F9] hover:text-[#0F172A]'"
                class="hidden items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-semibold transition-all duration-200 sm:flex"
            >
                <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"/>
                </svg>
                Share
            </button>

            <!-- Notification dropdown -->
            <NotificationDropdown
                :is-dark="isDark"
                :notifications="notifications"
                @mark-read="handleMarkRead"
                @mark-all-read="handleMarkAllRead"
                @click="handleNotificationClick"
            />

            <!-- User dropdown -->
            <UserDropdown
                :is-dark="isDark"
                :user="$page.props.auth.user"
                @logout="handleLogout"
            />
        </div>
    </nav>
</template>
