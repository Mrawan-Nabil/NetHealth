<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import DicomViewer from '@/components/imaging/DicomViewer.vue';
import FileInformationCard from '@/components/imaging/FileInformationCard.vue';
import MedicalNotesCard from '@/components/imaging/MedicalNotesCard.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

const props = defineProps({
    imagingData: { type: Object, required: true },
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

const handleBackToImaging = () => router.get('/imaging');
const handlePrint = () => window.print();
const handleDownloadPDF = () => {
    if (props.imagingData.images?.[0]?.url) {
        window.open(props.imagingData.images[0].url, '_blank');
    }
};

</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Medical Record"
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
                    <Link href="/imaging" class="transition-colors hover:text-[#14B8A6]">Imaging</Link>
                    <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">{{ imagingData.fileInfo.type }}</span>
                </p>

                <TabsNavigation :active-tab="'imaging'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page header -->
                <div class="mb-6 mt-6 flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                    <div>
                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">
                            {{ imagingData.title }}
                        </h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                            Uploaded on {{ imagingData.fileInfo.scanDate }} &nbsp;·&nbsp; ID: IMG-{{ imagingData.id }}
                        </p>
                    </div>

                    <div class="flex flex-wrap items-center gap-2">
                        <button
                            @click="handleBackToImaging"
                            :class="isDark ? 'border-[#334155] text-[#F1F5F9] hover:bg-[#1E293B]' : 'border-[#E5E7EB] text-[#0F172A] hover:bg-[#F8FAFC]'"
                            class="flex items-center gap-2 rounded-xl border px-3 py-2 text-xs font-semibold transition-colors duration-200"
                        >
                            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                            </svg>
                            Back
                        </button>
                        <button
                            @click="handlePrint"
                            :class="isDark ? 'border-[#334155] text-[#F1F5F9] hover:bg-[#1E293B]' : 'border-[#E5E7EB] text-[#0F172A] hover:bg-[#F8FAFC]'"
                            class="flex items-center gap-2 rounded-xl border px-3 py-2 text-xs font-semibold transition-colors duration-200"
                        >
                            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                            </svg>
                            Print
                        </button>
                        <button
                            @click="handleDownloadPDF"
                            class="btn-primary flex items-center gap-2 px-3 py-2 text-xs"
                        >
                            <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                            </svg>
                            Download
                        </button>
                    </div>
                </div>

                <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
                    <div class="space-y-6 lg:col-span-4">
                        <FileInformationCard :file-info="imagingData.fileInfo" :is-dark="isDark" />
                        <MedicalNotesCard :notes="imagingData.notes" :is-dark="isDark" />
                    </div>

                    <div class="lg:col-span-8">
                        <DicomViewer :images="imagingData.images" :is-dark="isDark" />
                    </div>
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
