<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, reactive, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import DoctorNotesCard from '@/components/doctor-full-file/DoctorNotesCard.vue';
import FileInfoCard from '@/components/doctor-full-file/FileInfoCard.vue';
import ImagingViewer from '@/components/doctor-full-file/ImagingViewer.vue';
import LabReportSummaryCard from '@/components/doctor-full-file/LabReportSummaryCard.vue';
import PageActionBar from '@/components/doctor-full-file/PageActionBar.vue';
import ResultsAnalysisTable from '@/components/doctor-full-file/ResultsAnalysisTable.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const activeThumb = ref(0);
const notes = ref('');
const notesSaved = ref(false);
const fileType = ref('imaging');

const doctor = { fullName: 'Ahmed Yahia', handle: '@y7ia007', avatar: 'https://i.pravatar.cc/200?img=12' };
const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews', active: true },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

const imagingFile = reactive({
    title: 'Chest CT Scan',
    subtitle: 'Uploaded on Oct 14, 2024 · ID: IMG-90244-X',
    metadata: {
        Type: 'CT Scan',
        Size: '12.4 MB',
        Doctor: 'Dr. Sarah Mitchell',
        'Radiology Center': 'City General Hospital',
        'Scan Date': 'Oct 12, 2024',
        'File Type': 'DICOM/PDF',
    },
    pages: 12,
    currentPage: 1,
    thumbnails: [
        'https://images.pexels.com/photos/5726708/pexels-photo-5726708.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/7089010/pexels-photo-7089010.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/7089012/pexels-photo-7089012.jpeg?auto=compress&cs=tinysrgb&w=600',
    ],
});

const labFile = reactive({
    title: 'Test Report Details',
    subtitle: 'Detailed breakdown of your laboratory findings from October 2025.',
    summary: {
        testName: 'Full Blood Count (FBC)',
        laboratory: 'City General Laboratory',
        regId: 'Reg ID: #L-8821',
        doctor: 'Dr. Sarah Mitchell',
        specialty: 'Hematology Specialist',
        reportDate: 'Oct 24, 2025',
        reportId: 'ID: #TR-99021',
    },
    rows: [
        { parameter: 'Hemoglobin', result: '14.2', unit: 'g/dL', range: '13.5 - 17.5', status: 'Normal' },
        { parameter: 'White Blood Cell Count', result: '11.5', unit: 'x10^9/L', range: '4.5 - 11.0', status: 'High' },
        { parameter: 'Platelets', result: '250', unit: 'x10^9/L', range: '150 - 450', status: 'Normal' },
        { parameter: 'Iron', result: '12.0', unit: 'umol/L', range: '14.0 - 32.0', status: 'Low' },
    ],
});

const isDark = computed(() => state.isDark);
const currentImage = computed(() => imagingFile.thumbnails[activeThumb.value] ?? imagingFile.thumbnails[0]);

const toggleTheme = (value) => setTheme(value);

const submitNotes = () => {
    notesSaved.value = true;
    window.setTimeout(() => {
        notesSaved.value = false;
    }, 1800);
};

const printFile = () => {
    window.print();
};

const downloadFile = () => {
    const title = fileType.value === 'imaging' ? imagingFile.title : labFile.summary.testName;
    const payload = fileType.value === 'imaging'
        ? `${imagingFile.title}\n${imagingFile.subtitle}\n\nDoctor notes:\n${notes.value || 'No notes added.'}`
        : `${labFile.summary.testName}\n${labFile.summary.laboratory}\n${labFile.summary.reportDate}\n\nDoctor notes:\n${notes.value || 'No notes added.'}`;
    const blob = new Blob([payload], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `${title.replace(/\s+/g, '-').toLowerCase()}-summary.txt`;
    link.click();
    URL.revokeObjectURL(url);
};

const handleNav = (key) => {
    navItems.value = navItems.value.map((item) => ({ ...item, active: item.key === key }));
    sidebarOpen.value = false;
    if (key === 'home') return router.get('/doctor/dashboard');
    if (key === 'profile') return router.get('/doctor/profile');
    if (key === 'appointments') return router.get('/doctor/appointments');
    if (key === 'reviews') return router.get('/doctor/reviews');
    if (key === 'notification') return router.get('/doctor/notifications');
    if (key === 'logout') return router.get('/logout');
};

onMounted(() => {
    const typeParam = new URLSearchParams(window.location.search).get('type');
    fileType.value = typeParam === 'lab' ? 'lab' : 'imaging';
});
</script>

<template>
    <Head title="Doctor View Full File" />
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <AppSidebar :nav-items="navItems" :is-open="sidebarOpen" :is-dark="isDark" @close="sidebarOpen = false" @navigate="handleNav" @toggle-theme="toggleTheme" />
        <div class="lg:ml-64">
            <TopHeader
                title="Reviews"
                :doctor-name="doctor.fullName"
                :handle="doctor.handle"
                :avatar="doctor.avatar"
                :is-dark="isDark"
                @toggle-sidebar="sidebarOpen = true"
            />
            <main class="space-y-6 p-4 sm:p-6 lg:p-7 animate-fadeInUp">
                <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                    <div>
                        <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                            Patient Reviews <span class="mx-1.5 text-[#D1D5DB]">/</span>
                            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">View Files</span>
                        </p>
                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">{{ fileType === 'imaging' ? imagingFile.title : labFile.title }}</h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">{{ fileType === 'imaging' ? imagingFile.subtitle : labFile.subtitle }}</p>
                    </div>
                    <PageActionBar @back="router.get('/doctor/reviews/files')" @print="printFile" @download="downloadFile" />
                </div>

                <section v-if="fileType === 'imaging'" class="grid grid-cols-1 gap-6 lg:grid-cols-3">
                    <div class="space-y-6">
                        <FileInfoCard :metadata="imagingFile.metadata" />
                        <DoctorNotesCard v-model="notes" :saved="notesSaved" @submit="submitNotes" />
                    </div>
                    <div class="lg:col-span-2">
                        <ImagingViewer :image="currentImage" :pages="imagingFile.pages" :current-page="imagingFile.currentPage" :thumbnails="imagingFile.thumbnails" :active-thumb="activeThumb" @thumbnail="activeThumb = $event" />
                    </div>
                </section>

                <section v-else class="space-y-4">
                    <LabReportSummaryCard :summary="labFile.summary" />
                    <ResultsAnalysisTable :rows="labFile.rows" />
                    <DoctorNotesCard v-model="notes" :saved="notesSaved" @submit="submitNotes" />
                </section>
            </main>
        </div>
    </div>
</template>
