<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref, watch } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import FilterPills from '@/components/doctor-medical-record/FilterPills.vue';
import ImagingCard from '@/components/doctor-medical-record/ImagingCard.vue';
import InfoCard from '@/components/doctor-medical-record/InfoCard.vue';
import MedicalRecordTabs from '@/components/doctor-medical-record/MedicalRecordTabs.vue';
import NotesCard from '@/components/doctor-medical-record/NotesCard.vue';
import PatientSummaryCard from '@/components/doctor-medical-record/PatientSummaryCard.vue';
import PrescriptionCard from '@/components/doctor-medical-record/PrescriptionCard.vue';
import TestResultCard from '@/components/doctor-medical-record/TestResultCard.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import VisitHistoryCard from '@/components/doctor-medical-record/VisitHistoryCard.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const activeMainTab = ref('profile');
const activeFilter = ref('all');

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));

const doctor = { fullName: 'Ahmed Yahia', handle: '@y7ia007', avatar: 'https://i.pravatar.cc/200?img=12' };
const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews', active: true },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

const patient = {
    name: 'Sarah Johnson',
    initials: 'SJ',
    id: 'PT-2024-1234',
    dob: 'June 15, 1992',
    email: 'sarah.johnson@email.com',
    gender: 'Female',
    age: '34 years',
    phone: '+1 (555) 123-4567',
    bloodType: 'A+',
    notes: 'Patient requires regular monitoring for blood glucose levels. Currently on metformin 500mg twice daily. Blood pressure has been stable with medication. Patient is compliant with treatment plan and follows dietary recommendations. Scheduled for quarterly follow-ups.',
};

const testResults = [
    { title: 'Complete Blood Count (CBC)', lab: 'Central Medical Laboratory', date: 'Mar 24, 2026', status: 'Reviewed' },
    { title: 'Lipid Panel', lab: 'Central Medical Laboratory', date: 'Mar 24, 2026', status: 'Reviewed' },
    { title: 'Thyroid Function Panel', lab: 'Central Medical Laboratory', date: 'Mar 26, 2026', status: 'Pending' },
];

const imaging = [
    { title: 'Chest X-ray', region: 'Chest', doctor: 'Dr. Sarah Martinez', date: 'Mar 23, 2026', modality: 'X-ray' },
    { title: 'Cardiac Ultrasound', region: 'Heart', doctor: 'Dr. Sarah Martinez', date: 'Mar 24, 2026', modality: 'Ultrasound' },
    { title: 'Abdominal CT Scan', region: 'Abdomen', doctor: 'Dr. Sarah Martinez', date: 'Mar 24, 2026', modality: 'CT Scan' },
];

const prescriptions = [
    { doctor: 'Dr. Sarah Martinez', visitType: 'Follow-up Visit', date: 'Mar 10, 2026', condition: 'Chronic Lower Back Pain', medicines: ['Ibuprofen (600mg)', 'Cyclobenzaprine (10mg)', 'Gabapentin (300mg)'], status: 'Expired' },
    { doctor: 'Dr. Sarah Martinez', visitType: 'First Visit', date: 'Mar 25, 2026', condition: 'Hypertension', medicines: ['Lisinopril (10mg)', 'Amlodipine (5mg)', 'Aspirin (81mg)'], status: 'Active' },
    { doctor: 'Dr. Sarah Martinez', visitType: 'Follow-up Visit', date: 'Mar 18, 2026', condition: 'Gastroesophageal Reflux Disease', medicines: ['Omeprazole (20mg)', 'Famotidine (20mg)', 'Calcium Carbonate (500mg)'], status: 'Active' },
];

const visits = [
    { visitType: 'Follow-up Visit', date: 'Mar 25, 2026', time: '2:15 PM', title: 'Hypertension follow-up', summary: 'Blood pressure readings show improvement. Continue current medication.', prescriptionNote: 'Prescription renewed', status: 'Completed', hasPrescription: true },
    { visitType: 'First Visit', date: 'Mar 24, 2026', time: '11:00 AM', title: 'Diabetes management', summary: 'Initial consultation for Type 2 Diabetes. Lab results reviewed. Started on Metformin.', prescriptionNote: 'New prescription issued', status: 'Completed', hasPrescription: true },
    { visitType: 'Follow-up Visit', date: 'Mar 22, 2026', time: '3:45 PM', title: 'Follow-up for URI', summary: 'Upper respiratory infection symptoms resolved. Completed antibiotic course.', status: 'Completed' },
    { visitType: 'Follow-up Visit', date: 'Mar 8, 2026', time: '3:00 PM', title: 'Routine follow-up', summary: 'Patient cancelled due to scheduling conflict. Rescheduled for later date.', status: 'Cancelled' },
];

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

const pills = computed(() => {
    if (activeMainTab.value === 'test-results') return [{ key: 'all', label: 'All Tests (3)' }, { key: 'reviewed', label: 'Reviewed (2)' }, { key: 'pending', label: 'Pending (1)' }];
    if (activeMainTab.value === 'imaging') return [{ key: 'all', label: 'All Imaging (3)' }, { key: 'xray', label: 'X-ray (1)' }, { key: 'ct', label: 'CT Scan (1)' }, { key: 'ultrasound', label: 'Ultrasound (1)' }];
    if (activeMainTab.value === 'prescriptions') return [{ key: 'all', label: 'All Prescriptions (3)' }, { key: 'active', label: 'Active (2)' }, { key: 'expired', label: 'Expired (1)' }];
    if (activeMainTab.value === 'visit-history') return [{ key: 'all', label: 'All Visits (4)' }, { key: 'completed', label: 'Completed (3)' }, { key: 'cancelled', label: 'Cancelled (1)' }];
    return [];
});

const filteredTestResults = computed(() => activeFilter.value === 'all' ? testResults : testResults.filter((item) => item.status.toLowerCase() === activeFilter.value));
const filteredImaging = computed(() => {
    if (activeFilter.value === 'all') return imaging;
    const map = { xray: 'X-ray', ct: 'CT Scan', ultrasound: 'Ultrasound' };
    return imaging.filter((item) => item.modality === map[activeFilter.value]);
});
const filteredPrescriptions = computed(() => activeFilter.value === 'all' ? prescriptions : prescriptions.filter((item) => item.status.toLowerCase() === activeFilter.value));
const filteredVisits = computed(() => activeFilter.value === 'all' ? visits : visits.filter((item) => item.status.toLowerCase() === activeFilter.value));

const toggleTheme = (value) => setTheme(value);
const openFullFile = (type = 'lab') => router.get(`/doctor/reviews/view-full-file?type=${type}`);
const openPrescription = () => router.get('/doctor/reviews/view-full-file?type=lab');
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
    <Head title="Doctor Medical Record Dashboard" />
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
                <div>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                        Medical Record <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">{{ tabLabel }}</span>
                    </p>
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">{{ tabLabel }}</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">View patient information, files, prescriptions, and visit history.</p>
                </div>
                <MedicalRecordTabs :active-tab="activeMainTab" @change="activeMainTab = $event" />

                <FilterPills v-if="pills.length" :pills="pills" :active-filter="activeFilter" @change="activeFilter = $event" />

                <section v-if="activeMainTab === 'profile'" class="space-y-4">
                    <PatientSummaryCard :patient="{ name: patient.name, initials: patient.initials, id: patient.id, dob: patient.dob, email: patient.email }" />
                    <div class="grid gap-4 xl:grid-cols-2">
                        <InfoCard title="Personal Information" icon="M16 7a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM4 20a8 8 0 0 1 16 0" :items="[{ label: 'Full Name', value: patient.name }, { label: 'Gender', value: patient.gender }, { label: 'Age', value: patient.age }, { label: 'Phone Number', value: patient.phone }]" />
                        <InfoCard title="Medical Information" icon="M3 12h4l2-6 4 12 2-6h4" :items="[{ label: 'Blood Type', badges: [{ label: patient.bloodType, variant: 'rose' }] }, { label: 'Chronic Diseases', badges: [{ label: 'Type 2 Diabetes', variant: 'amber' }, { label: 'Hypertension', variant: 'amber' }] }, { label: 'Allergies', badges: [{ label: 'Penicillin', variant: 'rose' }, { label: 'Pollen', variant: 'rose' }] }]" />
                    </div>
                    <NotesCard title="Additional Notes" icon="M7 8h10M7 12h10M7 16h6M5.5 4.5h13A1.5 1.5 0 0 1 20 6v12a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 4 18V6a1.5 1.5 0 0 1 1.5-1.5Z" :content="patient.notes" />
                </section>

                <section v-if="activeMainTab === 'test-results'" class="grid grid-cols-1 gap-5 lg:grid-cols-2 xl:grid-cols-3">
                    <TestResultCard v-for="item in filteredTestResults" :key="item.title" :item="item" @view-details="openFullFile('lab')" />
                </section>

                <section v-if="activeMainTab === 'imaging'" class="grid grid-cols-1 gap-5 lg:grid-cols-2 xl:grid-cols-3">
                    <ImagingCard v-for="item in filteredImaging" :key="item.title" :item="item" @view-details="openFullFile('imaging')" />
                </section>

                <section v-if="activeMainTab === 'prescriptions'" class="space-y-4">
                    <PrescriptionCard v-for="item in filteredPrescriptions" :key="item.condition" :item="item" @view-details="openPrescription" />
                </section>

                <section v-if="activeMainTab === 'visit-history'" class="space-y-4">
                    <VisitHistoryCard v-for="item in filteredVisits" :key="`${item.date}-${item.title}`" :item="item" @view-details="openFullFile('lab')" @view-prescription="openPrescription" />
                </section>
            </main>
        </div>
    </div>
</template>
