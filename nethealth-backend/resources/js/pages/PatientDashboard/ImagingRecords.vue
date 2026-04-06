<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import ImagingRecordCard from '@/components/medical/ImagingRecordCard.vue';
import TabsNavigation from '@/components/medical/TabsNavigation.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

// LARAVEL DATA BINDING: Expects Array imagingRecords, Array notifications, Object currentUser
// Replace the currentUser prop with auth
defineProps({
    imagingRecords: {
        type: Array,
        required: true,
        default: () => [],
    },
    notifications: {
        type: Array,
        default: () => [],
    },
    auth: {
        type: Object,
        default: () => ({ user: null }),
    },
});

// Computed properties
const isDark = computed(() => state.isDark);

// Methods
const toggleTheme = (theme) => {
    setTheme(theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.post('/logout');
    }
};

const handleTabChange = (tabId) => {
    if (tabId === 'prescription') {
        router.get('/prescription');
    } else if (tabId === 'test-results') {
        router.get('/test-results');
    } else if (tabId === 'imaging') {
        router.get('/imaging');
    } else if (tabId === 'visit-history') {
        router.get('/visit-history');
    }
};

const handleViewFile = (record) => {
    console.log('Viewing file:', record);
    router.get(`/imaging/${record.id}`);
};

const handleDownload = (record) => {
    console.log('Downloading:', record);
    alert(`Downloading ${record.file.name}`);
};
// Lifecycle
onMounted(() => {
    // Data provided by Inertia Props
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <!-- Sidebar -->
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <!-- Main Content -->
        <div class="ml-64">
            <!-- Top Navbar -->
            <TopNavbar
                title="Medical Record"
                :user="{
                    name: auth?.user?.name || 'Patient',
                    username: '@' + (auth?.user?.email?.split('@')[0] || 'patient'),
                    avatar: auth?.user?.avatar || `https://ui-avatars.com/api/?name=${auth?.user?.name || 'Patient'}&background=0D9488&color=fff`,
                }"
                :notifications="notifications"
                :is-dark="isDark"
                :show-last-viewed="true"
                :show-share="true"
                last-viewed="10 mins ago"
                @logout="handleLogout"
            />
            <!-- Page Content -->
            <main class="p-6">
                <!-- Breadcrumb -->
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
                        <Link href="/medical-records" class="transition-colors hover:text-[#14B8A6]">Medical Record</Link>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">Imaging</span>
                    </p>
                </div>

                <!-- Tabs Navigation -->
                <TabsNavigation :active-tab="'imaging'" :is-dark="isDark" @change="handleTabChange" />

                <!-- Page Header -->
                <div class="mb-6">
                    <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">Imaging Records</h1>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                        View and manage diagnostic imaging reports for the current quarter.
                    </p>
                </div>

                <!-- Imaging Records Grid -->
                <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
                    <ImagingRecordCard
                        v-for="record in imagingRecords"
                        :key="record.id"
                        :record="record"
                        :is-dark="isDark"
                        @view-file="handleViewFile"
                        @download="handleDownload"
                    />
                </div>
            </main>
        </div>
    </div>
</template>
