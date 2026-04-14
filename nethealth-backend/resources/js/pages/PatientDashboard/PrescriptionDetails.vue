<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import AttachmentsCard from '@/components/prescription/AttachmentsCard.vue';
import DiagnosisCard from '@/components/prescription/DiagnosisCard.vue';
import DoctorCard from '@/components/prescription/DoctorCard.vue';
import MedicinesTable from '@/components/prescription/MedicinesTable.vue';
import NotesCard from '@/components/prescription/NotesCard.vue';
import PatientInfoCard from '@/components/prescription/PatientInfoCard.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

const props = defineProps({
    prescription: { type: Object, required: true },
});

const isDark = computed(() => state.isDark);

const toggleTheme = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.post('/logout'); // Usually POST for Laravel standard logout
    }
};

const handlePrint = () => window.print();
const handleDownloadPDF = () => {
    alert('PDF download functionality will be implemented with backend integration');
};
const handleDownloadAttachment = (file) => {
    alert(`Downloading ${file.name}`);
};

</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Prescription Details"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">
                <!-- Breadcrumb -->
                <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-6 text-xs font-medium">
                    Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                    <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <Link href="/prescription" class="transition-colors hover:text-[#14B8A6]">Prescriptions</Link>
                    <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Details</span>
                </p>

                <!-- Page header -->
                <div class="mb-6 flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                    <div>
                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Prescription Details</h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                            Generated on {{ prescription.generatedDate }}
                        </p>
                    </div>

                    <div class="flex flex-wrap items-center gap-2">
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
                            Download PDF
                        </button>
                    </div>
                </div>

                <div class="space-y-6">
                    <DoctorCard :doctor="prescription.doctor" :is-dark="isDark" />
                    <PatientInfoCard :patient="prescription.patient" :is-dark="isDark" />
                    <DiagnosisCard :diagnosis="prescription.diagnosis" :is-dark="isDark" />
                    <MedicinesTable :medicines="prescription.medicines" :is-dark="isDark" />

                    <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
                        <NotesCard :notes="prescription.notes" :is-dark="isDark" />
                        <AttachmentsCard :attachments="prescription.attachments" :is-dark="isDark" @download="handleDownloadAttachment" />
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
