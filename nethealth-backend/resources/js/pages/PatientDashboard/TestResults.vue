<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import TestResultCard from '@/components/medical/TestResultCard.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

defineProps({
    testResults: { type: Array, required: true, default: () => [] },
});

const isDark = computed(() => state.isDark);

const toggleTheme = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const handleTabChange = (tabId) => {
    const routes = {
        prescription:  '/prescription',
        'test-results':'/test-results',
        imaging:       '/imaging',
        'visit-history':'/visit-history',
    };
    if (routes[tabId]) router.get(routes[tabId]);
};

const handleViewReport = (testResult) => {
    router.get(`/test-results/${testResult.id}`);
};
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Test Results"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="true"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">
                <!-- Breadcrumb -->
                <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-6 text-xs font-medium">
                    Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                    <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Test Results</span>
                </p>

                <!-- Tabs -->
                <TabsNavigation :active-tab="'test-results'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page header -->
                <div class="mb-6 mt-6">
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Test Results</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                        View and manage diagnostic test results and reports.
                    </p>
                </div>

                <!-- Grid -->
                <div v-if="testResults.length > 0" class="grid grid-cols-1 gap-5 lg:grid-cols-2">
                    <TestResultCard
                        v-for="result in testResults"
                        :key="result.id"
                        :test-result="result"
                        :is-dark="isDark"
                        @view-report="handleViewReport"
                    />
                </div>

                <!-- Empty state -->
                <div
                    v-else
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="rounded-2xl border p-16 text-center"
                    style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                >
                    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl">
                        <svg :class="isDark ? 'text-[#334155]' : 'text-[#CBD5E1]'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
                        </svg>
                    </div>
                    <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">No Test Results Found</h3>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">Lab results from your appointments will appear here.</p>
                </div>
            </main>
        </div>
    </div>
</template>

<style scoped>
.animate-fadeInUp {
    animation: fadeInUp 0.4s ease-out both;
}
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
}
</style>
