<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import MedicalFileCard from '@/components/doctor-reviews/MedicalFileCard.vue';
import PatientSummaryCard from '@/components/doctor-reviews/PatientSummaryCard.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews', active: true },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);
const doctor = { fullName: 'Ahmed Yahia', handle: '@y7ia007', avatar: 'https://i.pravatar.cc/200?img=12' };
const patient = { name: 'Sarah Johnson', initials: 'SJ', age: 34, gender: 'Female', patientId: 'PT-2024-1234' };
const files = [
    { id: 1, category: 'Lab Test', title: 'Blood Test Results - Complete Blood Count', date: 'Mar 24, 2026', previewImage: 'https://images.pexels.com/photos/5726791/pexels-photo-5726791.jpeg?auto=compress&cs=tinysrgb&w=1200', buttonText: 'View Full File' },
    { id: 2, category: 'X-Ray Imaging', title: 'Chest X-Ray - PA View', date: 'Mar 24, 2026', previewImage: 'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=1200', buttonText: 'View Full File' },
    { id: 3, category: 'MRI Imaging', title: 'Brain MRI - T2 Weighted', date: 'Mar 25, 2026', previewImage: 'https://images.pexels.com/photos/7088525/pexels-photo-7088525.jpeg?auto=compress&cs=tinysrgb&w=1200', buttonText: 'View Full File' },
];
const openFullFile = (category) => {
    const type = category === 'Lab Test' ? 'lab' : 'imaging';
    router.get(`/doctor/reviews/view-full-file?type=${type}`);
};
const openMedicalRecord = () => router.get('/doctor/reviews/medical-record');
const isDark = computed(() => state.isDark);
const toggleTheme = (value) => setTheme(value);
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
    <Head title="Doctor Review Files" />
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
                <div class="mb-1">
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                        Patient Reviews <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">View Files</span>
                    </p>
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">View Files</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">Review the patient summary and attached medical files.</p>
                </div>
                <PatientSummaryCard :name="patient.name" :initials="patient.initials" :age="patient.age" :gender="patient.gender" :patient-id="patient.patientId" @view-medical-record="openMedicalRecord" />
                <section class="space-y-4">
                    <h2 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-sm font-semibold">Medical Files</h2>
                    <div class="grid grid-cols-1 gap-5 lg:grid-cols-2">
                        <MedicalFileCard v-for="file in files" :key="file.id" :item="file" @view-file="openFullFile(file.category)" />
                    </div>
                </section>
            </main>
        </div>
    </div>
</template>
