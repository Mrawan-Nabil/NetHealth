<script setup>
import { router, usePage } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    isDark: Boolean,
});

const emit = defineEmits(['logout']);

const page      = usePage();
const user      = computed(() => page.props.auth?.user);
const isOpen    = ref(false);
const dropdownRef = ref(null);

const avatarUrl = computed(() => {
    const u = user.value;
    if (!u) return '';
    if (u.avatar) return u.avatar.startsWith('http') ? u.avatar : `/storage/${u.avatar}`;
    return `https://ui-avatars.com/api/?name=${encodeURIComponent(u.full_name || 'User')}&background=0D9488&color=fff&size=160`;
});

const toggleDropdown  = () => { isOpen.value = !isOpen.value; };
const handleProfile   = () => { isOpen.value = false; router.get('/profile'); };
const handleSettings  = () => { isOpen.value = false; router.get('/settings'); };
const handleLogout    = () => { isOpen.value = false; emit('logout'); };

const handleClickOutside = (event) => {
    if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
        isOpen.value = false;
    }
};
onMounted(()  => document.addEventListener('click', handleClickOutside));
onUnmounted(() => document.removeEventListener('click', handleClickOutside));

const menuItems = [
    {
        label: 'View Profile',
        icon:  '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>',
        action: () => handleProfile(),
    },
    {
        label: 'Settings',
        icon:  '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>',
        action: () => handleSettings(),
    },
];
</script>

<template>
    <div class="relative" ref="dropdownRef">
        <button
            @click="toggleDropdown"
            :class="isDark ? 'hover:bg-[#1E293B]' : 'hover:bg-[#F8FAFC]'"
            class="flex items-center gap-2.5 rounded-xl px-2.5 py-1.5 transition-all duration-200"
        >
            <!-- Avatar -->
            <img
                :src="avatarUrl"
                :alt="user?.full_name || 'User'"
                class="h-8 w-8 rounded-full object-cover ring-2"
                :class="isDark ? 'ring-[#334155]' : 'ring-[#F1F5F9]'"
            />
            <!-- Name + email -->
            <div class="hidden flex-col text-left sm:flex">
                <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-xs font-semibold leading-tight">
                    {{ user?.full_name }}
                </span>
                <span :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-[10px] leading-tight">
                    {{ user?.email }}
                </span>
            </div>
            <!-- Caret -->
            <svg
                :class="[isOpen ? 'rotate-180' : '', isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]']"
                class="h-3.5 w-3.5 transition-transform duration-200"
                fill="none" stroke="currentColor" viewBox="0 0 24 24"
            >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7"/>
            </svg>
        </button>

        <Transition name="dropdown">
            <div
                v-if="isOpen"
                :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                class="absolute right-0 z-50 mt-2 w-56 overflow-hidden rounded-2xl border"
                style="box-shadow: 0 10px 30px -5px rgba(0,0,0,0.12), 0 4px 12px -4px rgba(0,0,0,0.08);"
            >
                <!-- Header -->
                <div
                    :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'"
                    class="flex items-center gap-3 px-4 py-4"
                >
                    <img
                        :src="avatarUrl"
                        :alt="user?.full_name || 'User'"
                        class="h-10 w-10 rounded-xl object-cover ring-2"
                        :class="isDark ? 'ring-[#334155]' : 'ring-[#F1F5F9]'"
                    />
                    <div class="min-w-0">
                        <p :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="truncate text-sm font-semibold">
                            {{ user?.full_name }}
                        </p>
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#94A3B8]'" class="truncate text-xs">
                            {{ user?.email }}
                        </p>
                    </div>
                </div>

                <!-- Menu items -->
                <div class="p-1.5">
                    <button
                        v-for="item in menuItems"
                        :key="item.label"
                        @click="item.action"
                        :class="isDark
                            ? 'text-[#94A3B8] hover:bg-[#334155]/60 hover:text-[#F1F5F9]'
                            : 'text-[#374151] hover:bg-[#F8FAFC] hover:text-[#0F172A]'"
                        class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left transition-all duration-150"
                    >
                        <svg class="h-4 w-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="item.icon" />
                        <span class="text-xs font-semibold">{{ item.label }}</span>
                    </button>
                </div>

                <!-- Logout -->
                <div :class="isDark ? 'border-[#1E293B]' : 'border-[#F1F5F9]'" class="border-t p-1.5">
                    <button
                        @click="handleLogout"
                        :class="isDark ? 'text-red-400 hover:bg-red-500/10' : 'text-red-500 hover:bg-red-50'"
                        class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left transition-all duration-150"
                    >
                        <svg class="h-4 w-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                        </svg>
                        <span class="text-xs font-semibold">Sign Out</span>
                    </button>
                </div>
            </div>
        </Transition>
    </div>
</template>

<style scoped>
.dropdown-enter-active, .dropdown-leave-active {
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.dropdown-enter-from, .dropdown-leave-to {
    opacity: 0;
    transform: translateY(-6px) scale(0.97);
}
</style>
