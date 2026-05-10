<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref, watch } from 'vue';
import FilterPills from '@/components/doctor-medical-record/FilterPills.vue';
import ImagingCard from '@/components/doctor-medical-record/ImagingCard.vue';
import InfoCard from '@/components/doctor-medical-record/InfoCard.vue';
import MedicalRecordTabs from '@/components/doctor-medical-record/MedicalRecordTabs.vue';
import NotesCard from '@/components/doctor-medical-record/NotesCard.vue';
import PatientSummaryCard from '@/components/doctor-medical-record/PatientSummaryCard.vue';
import PrescriptionCard from '@/components/doctor-medical-record/PrescriptionCard.vue';
import TestResultCard from '@/components/doctor-medical-record/TestResultCard.vue';
import VisitHistoryCard from '@/components/doctor-medical-record/VisitHistoryCard.vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

// ─── Props (Inertia Data Contract) ───────────────────────────────────────────
const props = defineProps({
    doctor: { type: Object, required: true },
    patient: { type: Object, required: true },
    testResults: { type: Array, default: () => [] },
    imaging: { type: Array, default: () => [] },
    prescriptions: { type: Array, default: () => [] },
    visits: { type: Array, default: () => [] },
});

// ─── State ───────────────────────────────────────────────────────────────────
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const activeMainTab = ref('profile');
const activeFilter = ref('all');

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));

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

const tabLabel = computed(() => {
    const map = {
        profile: 'Profile',
        'test-results': 'Test Result',
        imaging: 'Imaging',
        prescriptions: 'Prescriptions',
        'visit-history': 'Visit History',
    };
    return map[activeMainTab.value];
});

// Bug Fix #7: pill counts derived from actual prop arrays
const pills = computed(() => {
    if (activeMainTab.value === 'test-results') {
        const reviewed = props.testResults.filter((i) => i.status === 'Reviewed').length;
        const pending = props.testResults.filter((i) => i.status === 'Pending').length;
        return [
            { key: 'all', label: `All Tests (${props.testResults.length})` },
            { key: 'reviewed', label: `Reviewed (${reviewed})` },
            { key: 'pending', label: `Pending (${pending})` },
        ];
    }
    if (activeMainTab.value === 'imaging') {
        const xray = props.imaging.filter((i) => i.modality === 'X-ray').length;
        const ct = props.imaging.filter((i) => i.modality === 'CT Scan').length;
        const us = props.imaging.filter((i) => i.modality === 'Ultrasound').length;
        return [
            { key: 'all', label: `All Imaging (${props.imaging.length})` },
            { key: 'xray', label: `X-ray (${xray})` },
            { key: 'ct', label: `CT Scan (${ct})` },
            { key: 'ultrasound', label: `Ultrasound (${us})` },
        ];
    }
    if (activeMainTab.value === 'prescriptions') {
        const active = props.prescriptions.filter((i) => i.status === 'Active').length;
        const expired = props.prescriptions.filter((i) => i.status === 'Expired').length;
        return [
            { key: 'all', label: `All Prescriptions (${props.prescriptions.length})` },
            { key: 'active', label: `Active (${active})` },
            { key: 'expired', label: `Expired (${expired})` },
        ];
    }
    if (activeMainTab.value === 'visit-history') {
        const completed = props.visits.filter((i) => i.status === 'Completed').length;
        const cancelled = props.visits.filter((i) => i.status === 'Cancelled').length;
        return [
            { key: 'all', label: `All Visits (${props.visits.length})` },
            { key: 'completed', label: `Completed (${completed})` },
            { key: 'cancelled', label: `Cancelled (${cancelled})` },
        ];
    }
    return [];
});

const filteredTestResults = computed(() =>
    activeFilter.value === 'all' ? props.testResults : props.testResults.filter((i) => i.status.toLowerCase() === activeFilter.value),
);
const filteredImaging = computed(() => {
    if (activeFilter.value === 'all') return props.imaging;
    const map = { xray: 'X-ray', ct: 'CT Scan', ultrasound: 'Ultrasound' };
    return props.imaging.filter((i) => i.modality === map[activeFilter.value]);
});
const filteredPrescriptions = computed(() =>
    activeFilter.value === 'all' ? props.prescriptions : props.prescriptions.filter((i) => i.status.toLowerCase() === activeFilter.value),
);
const filteredVisits = computed(() =>
    activeFilter.value === 'all' ? props.visits : props.visits.filter((i) => i.status.toLowerCase() === activeFilter.value),
);

// ─── Handlers ────────────────────────────────────────────────────────────────
const toggleTheme = (value) => setTheme(value);
const openFullFile = (category, fileId) => {
    // 1. Force the word to lowercase safely
    const safeCategory = String(category).toLowerCase();

    // 2. Check if it includes the word 'imaging' (handles "Imaging", "imaging", or "x-ray imaging")
    const fileType = safeCategory.includes('imaging') ? 'imaging' : 'lab';
    router.get('/doctor/reviews/view-full-file', {
        type: fileType,
        file: fileId,
    });
};
const openPrescription = (id) => router.get(`/doctor/reviews/view-full-file?prescription=${id}`);

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

watch(activeMainTab, () => {
    activeFilter.value = 'all';
});
</script>

<template>
    <Head title="Doctor Medical Record" />
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <AppSidebar
            :nav-items="navItems"
            :is-open="sidebarOpen"
            :is-dark="isDark"
            @close="sidebarOpen = false"
            @navigate="handleNav"
            @toggle-theme="toggleTheme"
        />
        <div class="lg:ml-64">
            <TopHeader
                title="Reviews"
                :doctor-name="props.doctor.fullName"
                :handle="props.doctor.handle"
                :avatar="props.doctor.avatar ?? ''"
                :is-dark="isDark"
                @toggle-sidebar="sidebarOpen = true"
            />
            <main class="animate-fadeInUp space-y-6 p-4 sm:p-6 lg:p-7">
                <div>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                        Medical Record <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">{{ tabLabel }}</span>
                    </p>
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">{{ tabLabel }}</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                        View patient information, files, prescriptions, and visit history.
                    </p>
                </div>
                <MedicalRecordTabs :active-tab="activeMainTab" @change="activeMainTab = $event" />

                <FilterPills v-if="pills.length" :pills="pills" :active-filter="activeFilter" @change="activeFilter = $event" />

                <section v-if="activeMainTab === 'profile'" class="space-y-4">
                    <PatientSummaryCard
                        :patient="{
                            name: props.patient.name,
                            initials: props.patient.initials,
                            id: props.patient.id,
                            dob: props.patient.dob,
                            email: props.patient.email,
                        }"
                    />
                    <div class="grid gap-4 xl:grid-cols-2">
                        <InfoCard
                            title="Personal Information"
                            icon="M16 7a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM4 20a8 8 0 0 1 16 0"
                            :items="[
                                { label: 'Full Name', value: props.patient.name },
                                { label: 'Gender', value: props.patient.gender },
                                { label: 'Age', value: props.patient.age },
                                { label: 'Phone Number', value: props.patient.phone },
                            ]"
                        />
                        <InfoCard
                            title="Medical Information"
                            icon="M3 12h4l2-6 4 12 2-6h4"
                            :items="[
                                { label: 'Blood Type', badges: [{ label: props.patient.bloodType, variant: 'rose' }] },
                                {
                                    label: 'Chronic Diseases',
                                    badges: [
                                        { label: 'Type 2 Diabetes', variant: 'amber' },
                                        { label: 'Hypertension', variant: 'amber' },
                                    ],
                                },
                                {
                                    label: 'Allergies',
                                    badges: [
                                        { label: 'Penicillin', variant: 'rose' },
                                        { label: 'Pollen', variant: 'rose' },
                                    ],
                                },
                            ]"
                        />
                    </div>
                    <NotesCard
                        title="Additional Notes"
                        icon="M7 8h10M7 12h10M7 16h6M5.5 4.5h13A1.5 1.5 0 0 1 20 6v12a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 4 18V6a1.5 1.5 0 0 1 1.5-1.5Z"
                        :notes="props.patient.notes"
                    />
                </section>

                <section v-if="activeMainTab === 'test-results'" class="grid grid-cols-1 gap-5 lg:grid-cols-2 xl:grid-cols-3">
                    <TestResultCard v-for="item in filteredTestResults" :key="item.title" :item="item" @view-details="openFullFile('lab', item.id)" />
                </section>

                <section v-if="activeMainTab === 'imaging'" class="grid grid-cols-1 gap-5 lg:grid-cols-2 xl:grid-cols-3">
                    <ImagingCard v-for="item in filteredImaging" :key="item.title" :item="item" @view-details="openFullFile('imaging', item.id)" />
                </section>

                <section v-if="activeMainTab === 'prescriptions'" class="space-y-4">
                    <PrescriptionCard v-for="item in filteredPrescriptions" :key="item.condition" :item="item" @view-details="openPrescription" />
                </section>

                <section v-if="activeMainTab === 'visit-history'" class="space-y-4">
                    <VisitHistoryCard
                        v-for="item in filteredVisits"
                        :key="`${item.date}-${item.title}`"
                        :item="item"
                        @view-details="openFullFile(item.category, item.id)"
                        @view-prescription="openPrescription"
                    />
                </section>
            </main>
        </div>
    </div>
</template>
