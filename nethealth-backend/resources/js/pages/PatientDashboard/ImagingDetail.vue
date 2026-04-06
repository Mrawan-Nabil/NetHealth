<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import DicomViewer from '@/components/imaging/DicomViewer.vue';
import FileInformationCard from '@/components/imaging/FileInformationCard.vue';
import MedicalNotesCard from '@/components/imaging/MedicalNotesCard.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';

// 1. Accept real data from Inertia Controller
const props = defineProps({
    imagingData: {
        type: Object,
        required: true,
    },
    auth: {
        type: Object,
        default: () => ({ user: null }),
    },
});

// State
const isDark = ref(false);

// Methods
const toggleTheme = (theme) => {
    isDark.value = theme === 'dark';
    localStorage.setItem('theme', theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.post('/logout'); // Usually POST for Laravel
    }
};

const handleTabChange = (tabId) => {
    if (tabId === 'prescription') {
        router.get('/prescription');
    } else if (tabId === 'test-results') {
        router.get('/test-results');
    } else if (tabId === 'imaging') {
        router.get('/imaging');
    }
};

const handleBackToImaging = () => {
    router.get('/imaging');
};

const handlePrint = () => {
    window.print();
};

const handleDownloadPDF = () => {
    // You can hook this up to the actual file URL later
    window.open(props.imagingData.images[0]?.url, '_blank');
};

// Lifecycle
onMounted(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        isDark.value = savedTheme === 'dark';
    }
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Medical Record"
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

            <main class="p-6">
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
                        <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                        <span class="mx-2">/</span>
                        <Link href="/imaging" class="transition-colors hover:text-[#14B8A6]">Imaging</Link>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">{{ imagingData.fileInfo.type }}</span>
                    </p>
                </div>

                <TabsNavigation :active-tab="'imaging'" :is-dark="isDark" @change="handleTabChange" />

                <div class="mb-6 flex items-start justify-between">
                    <div>
                        <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">{{ imagingData.title }}</h1>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                            Uploaded on {{ imagingData.fileInfo.scanDate }} • ID: IMG-{{ imagingData.id }}
                        </p>
                    </div>

                    <div class="flex items-center gap-3">
                        <button
                            @click="handleBackToImaging"
                            :class="
                                isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'
                            "
                            class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-semibold transition-colors"
                        >
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                            </svg>
                            Back to Imaging List
                        </button>
                        <button
                            @click="handlePrint"
                            :class="
                                isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'
                            "
                            class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-semibold transition-colors"
                        >
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"
                                />
                            </svg>
                            Print
                        </button>
                        <button
                            @click="handleDownloadPDF"
                            class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                        >
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
                                />
                            </svg>
                            Download File
                        </button>
                    </div>
                </div>

                <div class="grid grid-cols-12 gap-6">
                    <div class="col-span-4 space-y-6">
                        <FileInformationCard :file-info="imagingData.fileInfo" :is-dark="isDark" />
                        <MedicalNotesCard :notes="imagingData.notes" :is-dark="isDark" />
                    </div>

                    <div class="col-span-8">
                        <DicomViewer :images="imagingData.images" :is-dark="isDark" />
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>
