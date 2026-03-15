<script setup>
import { computed, onMounted } from 'vue';
import { router, usePage } from '@inertiajs/vue3';
import { useDashboard } from '@/composables/useDashboard';
import Sidebar from '../components/dashboard/Sidebar.vue';
import TopNavbar from '../components/dashboard/TopNavbar.vue';
import TabsNavigation from '../components/medical/TabsNavigation.vue';
import VisitHistoryCard from '../components/medical/VisitHistoryCard.vue';

const router = usePage();
const { state, fetchVisitHistory, setTheme } = useDashboard();

// Computed properties
const isDark = computed(() => state.isDark);
const visits = computed(() => state.visitHistory);
const loading = computed(() => state.loading.visitHistory);
const error = computed(() => state.errors.visitHistory);

// Methods
const toggleTheme = (theme) => {
    setTheme(theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.push('/login');
    }
};

const handleTabChange = (tabId) => {
    if (tabId === 'prescription') {
        router.push('/medical-records');
    } else if (tabId === 'test-results') {
        router.push('/test-results');
    } else if (tabId === 'imaging') {
        router.push('/imaging');
    } else if (tabId === 'visit-history') {
        router.push('/visit-history');
    }
};

// Lifecycle
onMounted(() => {
    if (state.visitHistory.length === 0) {
        fetchVisitHistory();
    }
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
                :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
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
                        <router-link to="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</router-link>
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

                <!-- Loading State -->
                <div v-if="loading" class="space-y-4">
                    <div v-for="i in 5" :key="i" class="animate-pulse">
                        <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-20 rounded-xl"></div>
                    </div>
                </div>

                <!-- Error State -->
                <div
                    v-else-if="error"
                    :class="isDark ? 'border-red-500/20 bg-red-500/10' : 'border-red-200 bg-red-50'"
                    class="rounded-lg border p-6 text-center"
                >
                    <p :class="isDark ? 'text-red-400' : 'text-red-600'" class="text-sm">{{ error }}</p>
                    <button
                        @click="fetchVisitHistory"
                        class="mt-4 rounded-lg bg-red-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-red-700"
                    >
                        Try Again
                    </button>
                </div>

                <!-- Visit History List -->
                <div v-else class="space-y-4">
                    <VisitHistoryCard v-for="visit in visits" :key="visit.id" :visit="visit" :is-dark="isDark" />
                </div>
            </main>
        </div>
    </div>
</template>
