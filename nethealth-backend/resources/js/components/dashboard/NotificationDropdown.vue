<script setup>
import { Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    notifications: {
        type: Array,
        default: () => [],
    },
    isDark: Boolean,
});

const emit = defineEmits(['mark-read', 'mark-all-read', 'click']);

const isOpen = ref(false);
const dropdownRef = ref(null);

const unreadCount = computed(() => {
    return props.notifications.filter((n) => !n.read).length;
});

const toggleDropdown = () => {
    isOpen.value = !isOpen.value;
};

const markAllAsRead = () => {
    emit('mark-all-read');
};

const handleNotificationClick = (notification) => {
    if (!notification.read) {
        emit('mark-read', notification.id);
    }
    emit('click', notification);
};

const getIconColor = (type) => {
    const colors = {
        appointment: 'bg-[#3B82F6]',
        test: 'bg-[#8B5CF6]',
        prescription: 'bg-[#F59E0B]',
        reminder: 'bg-[#EAB308]',
        success: 'bg-[#10B981]',
        info: 'bg-[#14B8A6]',
    };
    return colors[type] || 'bg-[#6B7280]';
};

const getIconPath = (type) => {
    const icons = {
        appointment:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>',
        test: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>',
        prescription:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>',
        reminder:
            '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>',
        success: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>',
        info: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>',
    };
    return icons[type] || icons.info;
};

const handleClickOutside = (event) => {
    if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
        isOpen.value = false;
    }
};

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
    <div class="relative" ref="dropdownRef">
        <button
            @click="toggleDropdown"
            :class="isDark ? 'hover:bg-[#1E293B]' : 'hover:bg-[#F8FAFC]'"
            class="relative rounded-lg p-2.5 transition-all duration-200 hover:shadow-sm"
        >
            <svg :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                />
            </svg>
            <span
                v-if="unreadCount > 0"
                class="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-[#EF4444] text-xs font-semibold text-white shadow-lg"
            >
                {{ unreadCount > 9 ? '9+' : unreadCount }}
            </span>
        </button>

        <Transition name="dropdown">
            <div
                v-if="isOpen"
                :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                class="absolute right-0 z-50 mt-2 w-96 overflow-hidden rounded-xl border shadow-lg"
            >
                <!-- Header -->
                <div
                    :class="isDark ? 'border-[#334155] bg-[#111827]' : 'border-[#E5E7EB] bg-[#F8FAFC]'"
                    class="flex items-center justify-between border-b px-6 py-4"
                >
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">Notifications</h3>
                    <button
                        v-if="unreadCount > 0"
                        @click="markAllAsRead"
                        class="text-xs font-medium text-[#14B8A6] transition-colors duration-200 hover:text-[#0F9B8E]"
                    >
                        Mark all as read
                    </button>
                </div>

                <!-- Notifications List -->
                <div class="max-h-80 overflow-y-auto">
                    <div v-if="notifications.length === 0" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="px-6 py-12 text-center">
                        <div
                            :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                            class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full"
                        >
                            <svg
                                :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'"
                                class="h-8 w-8"
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
                        </div>
                        <p class="text-sm font-medium">No notifications</p>
                        <p class="mt-1 text-xs">You're all caught up!</p>
                    </div>

                    <div
                        v-for="notification in notifications"
                        :key="notification.id"
                        @click="handleNotificationClick(notification)"
                        :class="[
                            notification.read
                                ? isDark
                                    ? 'bg-[#1E293B]'
                                    : 'bg-white'
                                : isDark
                                  ? 'border-l-[#14B8A6] bg-[#14B8A6]/5'
                                  : 'border-l-[#14B8A6] bg-[#14B8A6]/5',
                            isDark ? 'hover:bg-[#334155]/50' : 'hover:bg-[#F8FAFC]',
                            !notification.read ? 'border-l-4' : '',
                        ]"
                        class="cursor-pointer px-6 py-4 transition-all duration-200 hover:shadow-sm"
                    >
                        <div class="flex gap-4">
                            <div
                                :class="getIconColor(notification.type)"
                                class="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-lg shadow-sm"
                            >
                                <svg
                                    class="h-5 w-5 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                    v-html="getIconPath(notification.type)"
                                ></svg>
                            </div>
                            <div class="min-w-0 flex-1">
                                <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-sm font-semibold">
                                    {{ notification.title }}
                                </p>
                                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-2 text-xs leading-relaxed">
                                    {{ notification.message }}
                                </p>
                                <p :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="text-xs">{{ notification.time }}</p>
                            </div>
                            <div v-if="!notification.read" class="mt-2 h-2 w-2 flex-shrink-0 rounded-full bg-[#14B8A6]"></div>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div :class="isDark ? 'border-[#334155] bg-[#111827]' : 'border-[#E5E7EB] bg-[#F8FAFC]'" class="border-t px-6 py-4 text-center">
                    <Link
                        href="/notifications"
                        @click="isOpen = false"
                        class="text-sm font-medium text-[#14B8A6] transition-colors duration-200 hover:text-[#0F9B8E]"
                    >
                        View all notifications
                    </Link>
                </div>
            </div>
        </Transition>
    </div>
</template>

<style scoped>
.dropdown-enter-active,
.dropdown-leave-active {
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.dropdown-enter-from,
.dropdown-leave-to {
    opacity: 0;
    transform: translateY(-8px) scale(0.95);
}
</style>
