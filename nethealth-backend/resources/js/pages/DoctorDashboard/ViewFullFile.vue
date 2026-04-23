<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import DoctorNotesCard from '@/components/doctor-full-file/DoctorNotesCard.vue';
import FileInfoCard from '@/components/doctor-full-file/FileInfoCard.vue';
import ImagingViewer from '@/components/doctor-full-file/ImagingViewer.vue';
import LabReportSummaryCard from '@/components/doctor-full-file/LabReportSummaryCard.vue';
import PageActionBar from '@/components/doctor-full-file/PageActionBar.vue';
import ResultsAnalysisTable from '@/components/doctor-full-file/ResultsAnalysisTable.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

// ─── Props (Inertia Data Contract) ───────────────────────────────────────────
// Bug Fix #3: fileType is passed from the backend (not read from window.location)
const props = defineProps({
    doctor: { type: Object, required: true },
    fileType: { type: String, default: 'imaging' },
    imaging: { type: Object, default: null },
    lab: { type: Object, default: null },
});

// ─── State ───────────────────────────────────────────────────────────────────
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const activeThumb = ref(0);
const notes = ref('');
const notesSaved = ref(false);

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews', active: true },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

// ─── Computed ─────────────────────────────────────────────────────────────────
const isDark = computed(() => state.isDark);
const isImaging = computed(() => props.fileType === 'imaging');
const currentImage = computed(() => props.imaging?.thumbnails?.[activeThumb.value] ?? props.imaging?.thumbnails?.[0] ?? '');
const pageTitle = computed(() => isImaging.value ? (props.imaging?.title ?? 'Imaging File') : (props.lab?.title ?? 'Lab Report'));
const pageSubtitle = computed(() => isImaging.value ? (props.imaging?.subtitle ?? '') : (props.lab?.subtitle ?? ''));

// ─── Handlers ────────────────────────────────────────────────────────────────
const toggleTheme = (value) => setTheme(value);

const submitNotes = () => {
    notesSaved.value = true;
    window.setTimeout(() => { notesSaved.value = false; }, 1800);
};

const printFile = () => window.print();

const downloadFile = () => {
    const title = isImaging.value ? (props.imaging?.title ?? 'imaging') : (props.lab?.summary?.testName ?? 'lab-report');
    const payload = isImaging.value
        ? `${props.imaging?.title}\n${props.imaging?.subtitle}\n\nDoctor notes:\n${notes.value || 'No notes added.'}`
        : `${props.lab?.summary?.testName}\n${props.lab?.summary?.laboratory}\n${props.lab?.summary?.reportDate}\n\nDoctor notes:\n${notes.value || 'No notes added.'}`;
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
</script>

<template>
    <Head title="Doctor View Full File" />
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <AppSidebar :nav-items="navItems" :is-open="sidebarOpen" :is-dark="isDark" @close="sidebarOpen = false" @navigate="handleNav" @toggle-theme="toggleTheme" />
        <div class="lg:ml-64">
            <TopHeader
                title="Reviews"
                :doctor-name="props.doctor.fullName"
                :handle="props.doctor.handle"
                :avatar="props.doctor.avatar ?? ''"
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
                        <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">{{ pageTitle }}</h1>
                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">{{ pageSubtitle }}</p>
                    </div>
                    <PageActionBar @back="router.get('/doctor/reviews/files')" @print="printFile" @download="downloadFile" />
                </div>

                <!-- Imaging view -->
                <section v-if="isImaging && props.imaging" class="grid grid-cols-1 gap-6 lg:grid-cols-3">
                    <div class="space-y-6">
                        <FileInfoCard :metadata="props.imaging.metadata" />
                        <DoctorNotesCard v-model="notes" :saved="notesSaved" @submit="submitNotes" />
                    </div>
                    <div class="lg:col-span-2">
                        <ImagingViewer
                            :image="currentImage"
                            :pages="props.imaging.pages"
                            :current-page="props.imaging.currentPage"
                            :thumbnails="props.imaging.thumbnails"
                            :active-thumb="activeThumb"
                            @thumbnail="activeThumb = $event"
                        />
                    </div>
                </section>

                <!-- Lab view -->
                <section v-else-if="!isImaging && props.lab" class="space-y-4">
                    <LabReportSummaryCard :summary="props.lab.summary" />
                    <ResultsAnalysisTable :rows="props.lab.rows" />
                    <DoctorNotesCard v-model="notes" :saved="notesSaved" @submit="submitNotes" />
                </section>
            </main>
        </div>
    </div>
</template>
