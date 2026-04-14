<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import AttachmentsCard from '@/components/prescription/AttachmentsCard.vue';
import DoctorInterpretationCard from '@/components/testresult/DoctorInterpretationCard.vue';
import TestInfoCardHorizontal from '@/components/testresult/TestInfoCardHorizontal.vue';
import TestResultsTable from '@/components/testresult/TestResultsTable.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

const props = defineProps({
    testResult: {
        type: Object,
        default: null,
    }
});

const isDark = computed(() => state.isDark);
const localTestResult = ref(props.testResult || {});
const loading = ref(!props.testResult);
const error = ref(null);

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

const handleBackToTestResults = () => router.get('/test-results');
const handlePrint = () => window.print();
const handleDownloadPDF = () => {
    alert('PDF download functionality will be implemented with backend integration');
};
const handleDownloadAttachment = (file) => {
    alert(`Downloading ${file.name}`);
};

const fetchTestResultDetails = async () => {
    if (props.testResult) return;
    
    loading.value = true;
    error.value = null;

    try {
        await new Promise((resolve) => setTimeout(resolve, 500));
        localTestResult.value = getDummyTestResult();
    } catch (err) {
        error.value = 'Failed to load test result details. Please try again.';
        localTestResult.value = getDummyTestResult();
    } finally {
        loading.value = false;
    }
};

const getDummyTestResult = () => ({
    id: window.location.pathname.split('/').pop() || 1,
    generatedDate: 'Oct 24, 2025',
    testInfo: {
        name: 'Full Blood Count (FBC)',
        lab: 'City General Laboratory',
        date: '2025-10-24',
        status: 'AVAILABLE',
    },
    results: [
        { parameter: 'Hemoglobin', value: '14.2', unit: 'g/dL', range: '13.5 - 17.5', status: 'Normal' },
        { parameter: 'White Blood Cell Count', value: '11.5', unit: 'x10⁹/L', range: '4.5 - 11.0', status: 'High' },
        { parameter: 'Platelets', value: '250', unit: 'x10⁹/L', range: '150 - 450', status: 'Normal' },
        { parameter: 'Iron', value: '12.0', unit: 'µmol/L', range: '14.0 - 32.0', status: 'Low' },
    ],
    interpretation:
        '"Your white blood cell count is slightly elevated, suggesting a minor infection. Please continue the prescribed antibiotics and re-test in two weeks. Ensure you stay hydrated and monitor for any fever symptoms."',
    doctor: {
        name: 'Dr. Mitchell',
        avatar: 'https://i.pravatar.cc/150?img=45',
        signedDate: 'Oct 25, 2025',
    },
    attachments: [
        { name: 'Full_Blood_Count_Report.pdf', size: '2.4 MB' },
        { name: 'Lab_Imaging_Platelets.jpg', size: '1.1 MB' },
    ],
});

onMounted(() => {
    fetchTestResultDetails();
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Test Result Details"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">
                <div v-if="loading" class="space-y-6">
                    <div class="animate-pulse">
                        <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="mb-4 h-8 w-64 rounded"></div>
                        <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-64 rounded-xl"></div>
                    </div>
                </div>

                <div v-else-if="error" :class="isDark ? 'border-red-500/20 bg-red-500/10' : 'border-red-200 bg-red-50'" class="rounded-xl border p-6 text-center">
                    <p :class="isDark ? 'text-red-400' : 'text-red-600'" class="text-sm font-semibold">{{ error }}</p>
                </div>

                <div v-else>
                    <!-- Breadcrumb -->
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-6 text-xs font-medium">
                        Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                        <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <Link href="/test-results" class="transition-colors hover:text-[#14B8A6]">Test Results</Link>
                        <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Details</span>
                    </p>

                    <TabsNavigation :active-tab="'test-results'" :is-dark="isDark" @change="handleTabChange" />

                    <!-- Page header -->
                    <div class="mb-6 mt-6 flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                        <div>
                            <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Test Report Details</h1>
                            <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                                Generated on {{ localTestResult.generatedDate }}
                            </p>
                        </div>

                        <div class="flex flex-wrap items-center gap-2">
                            <button
                                @click="handleBackToTestResults"
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
                                Download PDF
                            </button>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <TestInfoCardHorizontal :test-info="localTestResult.testInfo" :is-dark="isDark" />
                        <TestResultsTable :results="localTestResult.results" :is-dark="isDark" />

                        <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
                            <DoctorInterpretationCard :interpretation="localTestResult.interpretation" :doctor="localTestResult.doctor" :is-dark="isDark" />
                            <AttachmentsCard :attachments="localTestResult.attachments" :is-dark="isDark" @download="handleDownloadAttachment" />
                        </div>
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
