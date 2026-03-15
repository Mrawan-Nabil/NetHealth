<script setup>
import { Link, router } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import ActivityTimeline from '@/components/dashboard/ActivityTimeline.vue';
import AppointmentCard from '@/components/dashboard/AppointmentCard.vue';
import HealthOverview from '@/components/dashboard/HealthOverview.vue';
import MedicalRecordItem from '@/components/dashboard/MedicalRecordItem.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import StatsCard from '@/components/dashboard/StatsCard.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
//import { dashboardAPI } from '../services/api.js'

defineProps({
    healthOverview: Object,
    upcomingAppointments: Number,
    latestPrescriptionCount: Number,
    pendingTests: Number,
    nextAppointment: Object,
    recentRecords: Array, // You'll need to pass this from your controller!
    activities: Array, // You'll need to pass this from your controller!
});
const isDark = ref(false);

const toggleTheme = (theme) => {
    isDark.value = theme === 'dark';
    localStorage.setItem('theme', theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.push('/login');
    }
};

onMounted(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        isDark.value = savedTheme === 'dark';
    }
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
                title="Dashboard"
                :is-dark="isDark"
                :user="$page.props.auth.user"
                :notifications="[]"
                :show-last-viewed="true"
                :show-share="false"
                @logout="handleLogout"
            />

            <!-- Dashboard Content -->
            <main class="dashboard-grid page-enter p-8">
                <!-- Welcome Section -->
                <section class="dashboard-card welcome-card stagger-1">
                    <div
                        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                        class="container-hover-subtle rounded-xl border p-6 shadow-sm"
                    >
                        <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 text-2xl font-bold">
                            Welcome back, {{ $page.props.auth.user.full_name }} 👋
                        </h2>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-base leading-relaxed">
                            Here's your health overview for today
                        </p>
                    </div>
                </section>

                <!-- Book Appointment Banner -->
                <section class="dashboard-card appointment-banner">
                    <div class="relative overflow-hidden rounded-xl bg-gradient-to-br from-[#14B8A6] to-[#0D9488] p-8 text-white shadow-lg">
                        <div class="relative z-10 flex items-center justify-between">
                            <div class="flex-1">
                                <h3 class="mb-3 text-2xl font-bold">Book a New Appointment</h3>
                                <p class="mb-6 max-w-lg leading-relaxed text-teal-50">
                                    Schedule a consultation with your preferred doctor in just a few steps. Get instant confirmation and digital
                                    prescriptions.
                                </p>
                                <div class="flex items-center gap-6 text-sm">
                                    <div class="flex items-center gap-2">
                                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                                            />
                                        </svg>
                                        <span>Available 24/7</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                                            />
                                        </svg>
                                        <span>Verified Doctors</span>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <Link
                                    href="/appointments"
                                    class="dashboard-button inline-flex items-center gap-2 rounded-xl bg-white px-6 py-3 font-semibold text-[#14B8A6] shadow-lg"
                                >
                                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                                        />
                                    </svg>
                                    Book Now
                                </Link>
                                <p class="mt-2 text-center text-xs text-teal-100">Takes less than 2 minutes</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Stats and Help Section -->
                <section class="stats-grid stagger-3 grid grid-cols-4 gap-6">
                    <!-- Stats Cards -->
                    <div class="dashboard-card">
                        <StatsCard :value="upcomingAppointments" label="Upcoming Appointments" icon="calendar" :is-dark="isDark" />
                    </div>
                    <div class="dashboard-card">
                        <StatsCard :value="latestPrescriptionCount" label="Latest Prescription" icon="prescription" :is-dark="isDark" />
                    </div>
                    <div class="dashboard-card">
                        <StatsCard :value="pendingTests" label="Pending Test Results" icon="test" :is-dark="isDark" />
                    </div>

                    <!-- Need Help Card -->
                    <div class="dashboard-card">
                        <div
                            class="container-hover-subtle flex h-full flex-col rounded-xl bg-gradient-to-br from-[#3B82F6] to-[#2563EB] p-6 text-white shadow-lg"
                        >
                            <div class="mb-3 flex items-center gap-2">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                                    />
                                </svg>
                                <h3 class="font-semibold">Need Help?</h3>
                            </div>
                            <p class="mb-4 flex-1 text-sm leading-relaxed text-blue-50">
                                Ask our AI Medical Assistant for quick answers about your health.
                            </p>
                            <button class="btn-primary w-full rounded-xl bg-white px-4 py-2.5 text-sm font-semibold text-[#3B82F6]">Ask Now</button>
                        </div>
                    </div>
                </section>

                <!-- Main Content Grid -->
                <section class="main-content-grid grid grid-cols-12 gap-8">
                    <!-- Left Column (8/12) -->
                    <div class="col-span-8 space-y-8">
                        <!-- Next Appointment -->
                        <div class="dashboard-card">
                            <AppointmentCard :appointment="nextAppointment" :is-dark="isDark" />
                        </div>

                        <!-- Recent Medical Records -->
                        <div class="dashboard-card">
                            <div
                                :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                                class="container-hover-subtle rounded-xl border p-6 shadow-sm"
                            >
                                <div class="mb-6 flex items-center justify-between">
                                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold">
                                        Recent Medical Records
                                    </h3>
                                    <Link href="/medical-records" class="smooth-transition text-sm font-semibold text-[#14B8A6] hover:text-[#0F9B8E]">
                                        View Full Records
                                    </Link>
                                </div>
                                <div class="space-y-3">
                                    <MedicalRecordItem v-for="(record, index) in recentRecords" :key="index" :record="record" :is-dark="isDark" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column (4/12) -->
                    <div class="col-span-4 space-y-8">
                        <!-- Health Overview -->
                        <div class="dashboard-card">
                            <HealthOverview :patient="healthOverview" :is-dark="isDark" />
                        </div>

                        <!-- Recent Activity -->
                        <div class="dashboard-card">
                            <ActivityTimeline :activities="activities" :is-dark="isDark" />
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </div>
</template>
