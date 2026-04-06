<script setup>
import { router, usePage, Link } from '@inertiajs/vue3';
import { computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import VisitHistoryCard from '@/components/medical/VisitHistoryCard.vue';
import { useDashboard } from '@/composables/useDashboard';

const page = usePage();
const { state, setTheme } = useDashboard();

// LARAVEL DATA BINDING: Expects Array visits
const props = defineProps({
    visits: {
        type: Array,
        required: true,
        default: () => [],
    },
    auth: {
        type: Object,
        default: () => ({ user: null }),
    },
});

// Computed properties
const isDark = computed(() => state.isDark);

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

const handleTabChange = (tabId) => {
    if (tabId === 'prescription') {
        router.get('/prescription');
    } else if (tabId === 'test-results') {
        router.get('/test-results');
    } else if (tabId === 'imaging') {
        router.get('/imaging');
    } else if (tabId === 'visit-history') {
        router.get('/visit-history');
    }
};

// Lifecycle
onMounted(() => {
    // Data is provided by Inertia props
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
                title="Visit History"
                :is-dark="isDark"
                :user="{
                    name: auth?.user?.name || 'Patient',
                    username: '@' + (auth?.user?.email?.split('@')[0] || 'patient'),
                    avatar: auth?.user?.avatar || `https://ui-avatars.com/api/?name=${auth?.user?.name || 'Patient'}&background=0D9488&color=fff`,
                }"
                :notifications="[]"
                :show-last-viewed="true"
                :show-share="true"
                @logout="handleLogout"
            />

            <!-- Page Content -->
            <main class="p-6">
                <!-- Breadcrumb -->
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
                        <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Visit History</span>
                    </p>
                </div>

                <!-- Tabs Navigation -->
                <TabsNavigation :active-tab="'visit-history'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page Header -->
                <div class="mb-6">
                    <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">Visit History</h1>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">Overview of your medical visits and consultations.</p>
                </div>

                <!-- Visit History List -->
                <div class="space-y-4">
                    <VisitHistoryCard v-for="visit in visits" :key="visit.id" :visit="visit" :is-dark="isDark" />
                </div>
            </main>
        </div>
    </div>
</template>
