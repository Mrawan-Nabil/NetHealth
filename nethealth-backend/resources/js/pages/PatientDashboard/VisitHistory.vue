<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import VisitHistoryCard from '@/components/medical/VisitHistoryCard.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

const props = defineProps({
    visits: { type: Array, required: true, default: () => [] },
    auth:   { type: Object, default: () => ({ user: null }) },
});

const isDark       = computed(() => state.isDark);
const toggleTheme  = (theme) => setTheme(theme);
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
    };
    if (routes[tabId]) router.get(routes[tabId]);
};
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Visit History"
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
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Visit History</span>
                </p>

                <!-- Tabs -->
                <TabsNavigation :active-tab="'visit-history'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page header -->
                <div class="mb-6 mt-6">
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Visit History</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">Overview of your medical visits and consultations.</p>
                </div>

                <!-- Cards -->
                <div v-if="visits.length > 0" class="space-y-4">
                    <VisitHistoryCard
                        v-for="visit in visits"
                        :key="visit.id"
                        :visit="visit"
                        :is-dark="isDark"
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                    </div>
                    <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">No Visits on Record</h3>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">Your visit history will appear here after your first appointment.</p>
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
