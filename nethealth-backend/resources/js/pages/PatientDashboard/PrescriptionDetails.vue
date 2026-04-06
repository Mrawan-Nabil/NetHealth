<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import AttachmentsCard from '@/components/prescription/AttachmentsCard.vue';
import DiagnosisCard from '@/components/prescription/DiagnosisCard.vue';
import DoctorCard from '@/components/prescription/DoctorCard.vue';
import MedicinesTable from '@/components/prescription/MedicinesTable.vue';
import NotesCard from '@/components/prescription/NotesCard.vue';
import PatientInfoCard from '@/components/prescription/PatientInfoCard.vue';

// 1. Receive the real data from the Laravel Controller
defineProps({
    prescription: {
        type: Object,
        required: true,
    },
    // Assuming you share the authenticated user globally via Inertia middleware
    auth: {
        type: Object,
        default: () => ({ user: null })
    }
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
        router.get('/logout'); // Usually POST for Laravel standard logout
    }
};

const handlePrint = () => {
    window.print();
};

const handleDownloadPDF = () => {
    console.log('Downloading PDF...');
    alert('PDF download functionality will be implemented with backend integration');
};

const handleDownloadAttachment = (file) => {
    console.log('Downloading attachment:', file);
    alert(`Downloading ${file.name}`);
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
                title="Prescription Details"
                :is-dark="isDark"
                :user="{
                    name: auth?.user?.name || prescription.patient.name,
                    username: '@' + (auth?.user?.email?.split('@')[0] || 'patient'),
                    avatar: auth?.user?.avatar || `https://ui-avatars.com/api/?name=${prescription.patient.name}&background=0D9488&color=fff`
                }"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-6">
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-4 text-sm">
                        <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                        <span class="mx-2">/</span>
                        <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Prescription</Link>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Prescription Details</span>
                    </p>

                    <div class="flex items-start justify-between">
                        <div>
                            <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">Prescription Details</h1>
                            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                                Generated on {{ prescription.generatedDate }}
                            </p>
                        </div>

                        <div class="flex items-center gap-3">
                            <button
                                @click="handlePrint"
                                :class="
                                    isDark
                                        ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]'
                                        : 'border-[#E5E7EB] text-[#111827] hover:bg-[#F8FAFC]'
                                "
                                class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-medium transition-all duration-300"
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
                                :class="
                                    isDark ? 'bg-[#14B8A6] shadow-lg shadow-teal-500/20 hover:bg-[#2DD4BF]' : 'bg-[#14B8A6] hover:bg-[#0D9488]'
                                "
                                class="flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium text-white transition-all duration-300"
                            >
                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
                                    />
                                </svg>
                                Download PDF
                            </button>
                        </div>
                    </div>
                </div>

                <div class="mb-6">
                    <DoctorCard :doctor="prescription.doctor" :is-dark="isDark" />
                </div>

                <div class="mb-6">
                    <PatientInfoCard :patient="prescription.patient" :is-dark="isDark" />
                </div>

                <div class="mb-6">
                    <DiagnosisCard :diagnosis="prescription.diagnosis" :is-dark="isDark" />
                </div>

                <div class="mb-6">
                    <MedicinesTable :medicines="prescription.medicines" :is-dark="isDark" />
                </div>

                <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
                    <NotesCard :notes="prescription.notes" :is-dark="isDark" />
                    <AttachmentsCard :attachments="prescription.attachments" :is-dark="isDark" @download="handleDownloadAttachment" />
                </div>
            </main>
        </div>
    </div>
</template>
