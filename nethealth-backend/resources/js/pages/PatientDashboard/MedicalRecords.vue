<script setup>
import { router } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import PrescriptionCard from '@/components/medical/PrescriptionCard.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import { useDashboard } from '@/composables/useDashboard.js';

const { state, setTheme } = useDashboard();

defineProps({
    prescriptions: { type: Array, required: true, default: () => [] },
    notifications: { type: Array, default: () => [] },
    currentUser:   { type: Object, required: true, default: () => ({}) },
});

const isDark = computed(() => state.isDark);

const toggleTheme  = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};
const handleTabChange = (tabId) => {
    const routes = {
        'test-results': '/test-results',
        'imaging':      '/imaging',
        'visit-history':'/visit-history',
    };
    if (routes[tabId]) router.get(routes[tabId]);
};
const handleDownload   = (p) => alert(`Downloading prescription from ${p.doctor}`);
const handleViewDetails = (p) => router.get(`/prescription/${p.id}`);
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Medical Records"
                :user="currentUser"
                :notifications="notifications"
                :is-dark="isDark"
                :show-last-viewed="true"
                :show-share="false"
                last-viewed="10 mins ago"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">
                <!-- Breadcrumb -->
                <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-6 text-xs font-medium">
                    Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Medical Record</span>
                    <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Prescriptions</span>
                </p>

                <!-- Tabs -->
                <TabsNavigation :active-tab="'prescription'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page header -->
                <div class="mb-6 mt-6">
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Prescriptions</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                        View and manage prescriptions issued from your appointments.
                    </p>
                </div>

                <!-- Grid -->
                <div v-if="prescriptions.length > 0" class="grid grid-cols-1 gap-5 lg:grid-cols-2">
                    <PrescriptionCard
                        v-for="prescription in prescriptions"
                        :key="prescription.id"
                        :prescription="prescription"
                        :is-dark="isDark"
                        @download="handleDownload"
                        @view-details="handleViewDetails"
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                    </div>
                    <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">No Prescriptions Found</h3>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">Prescriptions from your appointments will appear here.</p>
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
