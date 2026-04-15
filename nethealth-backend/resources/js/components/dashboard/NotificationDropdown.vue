<script setup>
import { Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    notifications: { type: Array, default: () => [] },
    isDark: Boolean,
    allHref: { type: String, default: '/notifications' },
});

const emit = defineEmits(['mark-read', 'mark-all-read', 'click']);

const isOpen      = ref(false);
const dropdownRef = ref(null);

const unreadCount = computed(() => props.notifications.filter(n => !n.read).length);

const toggleDropdown          = ()  => { isOpen.value = !isOpen.value; };
const markAllAsRead           = ()  => emit('mark-all-read');
const handleNotificationClick = (n) => {
    if (!n.read) emit('mark-read', n.id);
    emit('click', n);
};

const typeMeta = (type) => {
    const map = {
        appointment: { bg: 'bg-blue-500',   icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>' },
        test:        { bg: 'bg-violet-500', icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>' },
        prescription:{ bg: 'bg-amber-400',  icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>' },
        reminder:    { bg: 'bg-amber-500',  icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>' },
        success:     { bg: 'bg-emerald-500',icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>' },
        info:        { bg: 'bg-[#14B8A6]',  icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>' },
    };
    return map[type] || map.info;
};

const handleClickOutside = (e) => {
    if (dropdownRef.value && !dropdownRef.value.contains(e.target)) isOpen.value = false;
};
onMounted(()  => document.addEventListener('click', handleClickOutside));
onUnmounted(() => document.removeEventListener('click', handleClickOutside));
</script>

<template>
    <div class="relative" ref="dropdownRef">
        <!-- Bell button -->
        <button
            @click="toggleDropdown"
            :class="isDark ? 'hover:bg-[#1E293B]' : 'hover:bg-[#F8FAFC]'"
            class="relative rounded-xl p-2 transition-all duration-200"
        >
            <svg :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75"
                      d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
            </svg>
            <!-- Badge -->
            <span
                v-if="unreadCount > 0"
                class="absolute -top-0.5 -right-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-red-500 text-[9px] font-bold text-white shadow-sm"
            >
                {{ unreadCount > 9 ? '9+' : unreadCount }}
            </span>
        </button>

        <Transition name="dropdown">
            <div
                v-if="isOpen"
                :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                class="absolute right-0 z-50 mt-2 w-[360px] overflow-hidden rounded-2xl border"
                style="box-shadow: 0 10px 30px -5px rgba(0,0,0,0.12), 0 4px 12px -4px rgba(0,0,0,0.08);"
            >
                <!-- Header -->
                <div
                    :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                    class="flex items-center justify-between px-5 py-4"
                >
                    <div class="flex items-center gap-2">
                        <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-sm font-semibold">Notifications</h3>
                        <span v-if="unreadCount > 0" class="badge badge-teal">{{ unreadCount }} new</span>
                    </div>
                    <button
                        v-if="unreadCount > 0"
                        @click="markAllAsRead"
                        class="text-[11px] font-semibold text-[#14B8A6] transition-colors duration-200 hover:text-[#0D9488]"
                    >
                        Mark all read
                    </button>
                </div>

                <!-- List -->
                <div class="max-h-80 overflow-y-auto">
                    <!-- Empty -->
                    <div
                        v-if="notifications.length === 0"
                        :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'"
                        class="flex flex-col items-center justify-center px-5 py-12"
                    >
                        <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="mb-3 flex h-14 w-14 items-center justify-center rounded-2xl">
                            <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                            </svg>
                        </div>
                        <p class="text-xs font-semibold">All caught up!</p>
                        <p class="text-[11px]">No new notifications</p>
                    </div>

                    <!-- Items -->
                    <div
                        v-for="notification in notifications"
                        :key="notification.id"
                        @click="handleNotificationClick(notification)"
                        :class="[
                            'cursor-pointer px-5 py-3.5 transition-all duration-200',
                            !notification.read
                                ? isDark ? 'bg-[#14B8A6]/5 border-l-2 border-l-[#14B8A6]' : 'bg-teal-50/60 border-l-2 border-l-[#14B8A6]'
                                : isDark ? 'hover:bg-[#334155]/30' : 'hover:bg-[#F8FAFC]'
                        ]"
                    >
                        <div class="flex gap-3">
                            <!-- Icon -->
                            <div
                                :class="typeMeta(notification.type).bg"
                                class="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-xl"
                            >
                                <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                     v-html="typeMeta(notification.type).icon" />
                            </div>

                            <!-- Text -->
                            <div class="min-w-0 flex-1">
                                <p :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-0.5 text-xs font-semibold leading-snug">
                                    {{ notification.title }}
                                </p>
                                <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="mb-1 text-[11px] leading-relaxed">
                                    {{ notification.message }}
                                </p>
                                <p :class="isDark ? 'text-[#475569]' : 'text-[#CBD5E1]'" class="text-[10px]">
                                    {{ notification.time }}
                                </p>
                            </div>

                            <!-- Unread dot -->
                            <div v-if="!notification.read" class="mt-2 h-1.5 w-1.5 shrink-0 rounded-full bg-[#14B8A6]" />
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div
                    :class="isDark ? 'border-[#1E293B] bg-[#0F172A]' : 'border-[#F1F5F9] bg-[#F8FAFC]'"
                    class="border-t px-5 py-3 text-center"
                >
                    <Link
                        :href="allHref"
                        @click="isOpen = false"
                        class="text-xs font-semibold text-[#14B8A6] transition-colors duration-200 hover:text-[#0D9488]"
                    >
                        View all notifications →
                    </Link>
                </div>
            </div>
        </Transition>
    </div>
</template>

<style scoped>
.dropdown-enter-active, .dropdown-leave-active {
    transition: all 0.22s cubic-bezier(0.4, 0, 0.2, 1);
}
.dropdown-enter-from, .dropdown-leave-to {
    opacity: 0;
    transform: translateY(-6px) scale(0.97);
}
</style>
