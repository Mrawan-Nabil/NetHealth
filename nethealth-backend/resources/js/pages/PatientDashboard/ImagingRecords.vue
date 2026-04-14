<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import ImagingRecordCard from '@/components/medical/ImagingRecordCard.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

defineProps({
    imagingRecords: { type: Array, required: true, default: () => [] },
});

const isDark = computed(() => state.isDark);

const toggleTheme = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.post('/logout');
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

const handleViewFile = (record) => {
    router.get(`/imaging/${record.id}`);
};

const handleDownload = (record) => {
    alert(`Downloading ${record.file.name}`);
};
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Imaging Records"
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
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Imaging</span>
                </p>

                <!-- Tabs -->
                <TabsNavigation :active-tab="'imaging'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page header -->
                <div class="mb-6 mt-6">
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Imaging Records</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                        View and manage diagnostic imaging reports (X-Ray, MRI, CT Scans).
                    </p>
                </div>

                <!-- Grid -->
                <div v-if="imagingRecords.length > 0" class="grid grid-cols-1 gap-5 lg:grid-cols-2">
                    <ImagingRecordCard
                        v-for="record in imagingRecords"
                        :key="record.id"
                        :record="record"
                        :is-dark="isDark"
                        @view-file="handleViewFile"
                        @download="handleDownload"
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                    </div>
                    <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">No Imaging Records</h3>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">Scans from your appointments will appear here.</p>
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
