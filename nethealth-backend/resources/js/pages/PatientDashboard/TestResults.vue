<script setup>
import { router } from '@inertiajs/vue3';
import { computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import TestResultCard from '@/components/medical/TestResultCard.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

// LARAVEL DATA BINDING: Expects Array testResults
defineProps({
    testResults: {
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

const handleViewReport = (testResult) => {
    console.log('Viewing report:', testResult);
    router.get(`/test-results/${testResult.id}`);
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
                title="Test Results"
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
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                        <span class="text-gray-400">Medical Record</span>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Test Results</span>
                    </p>
                </div>

                <!-- Tabs Navigation -->
                <TabsNavigation :active-tab="'test-results'" :is-dark="isDark" @change="handleTabChange" />
                <!-- Page Header -->
                <div class="mb-6">
                    <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">Test Results</h1>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                        View and manage diagnostic test results reports for the current quarter.
                    </p>
                </div>
                <!-- Test Results Grid -->
                <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
                    <div v-for="(result, index) in testResults" :key="result.id" class="animate-fade-in-up" :class="`stagger-${(index % 4) + 1}`">
                        <TestResultCard :test-result="result" :is-dark="isDark" @view-report="handleViewReport" />
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>
