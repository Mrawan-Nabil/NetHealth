<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import ReviewListItem from '@/components/doctor-reviews/ReviewListItem.vue';
import ReviewStatsCard from '@/components/doctor-reviews/ReviewStatsCard.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

type NavIcon = 'home' | 'profile' | 'appointments' | 'reviews' | 'notification' | 'logout';
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));
const navItems = ref<Array<{ key: string; label: string; icon: NavIcon; active?: boolean }>>([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews', active: true },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);
const doctor = { fullName: 'Ahmed Yahia', handle: '@y7ia007', avatar: 'https://i.pravatar.cc/200?img=12' };
const reviews = ref([
    { id: 1, patientName: 'Sarah Johnson', initials: 'SJ', filesCount: 2, date: 'Mar 24, 2026', time: '09:30 AM', status: 'Pending' },
    { id: 2, patientName: 'Michael Chen', initials: 'MC', filesCount: 2, date: 'Mar 23, 2026', time: '02:15 PM', status: 'Reviewed' },
    { id: 3, patientName: 'Emily Rodriguez', initials: 'ER', filesCount: 1, date: 'Mar 23, 2026', time: '11:45 AM', status: 'Pending' },
    { id: 4, patientName: 'Emily Rodriguez', initials: 'ER', filesCount: 1, date: 'Mar 23, 2026', time: '11:45 AM', status: 'Pending' },
    { id: 5, patientName: 'Michael Chen', initials: 'MC', filesCount: 2, date: 'Mar 23, 2026', time: '02:15 PM', status: 'Reviewed' },
    { id: 6, patientName: 'Emily Rodriguez', initials: 'ER', filesCount: 1, date: 'Mar 23, 2026', time: '11:45 AM', status: 'Pending' },
    { id: 7, patientName: 'Emily Rodriguez', initials: 'ER', filesCount: 1, date: 'Mar 23, 2026', time: '11:45 AM', status: 'Pending' },
    { id: 8, patientName: 'Michael Chen', initials: 'MC', filesCount: 2, date: 'Mar 23, 2026', time: '02:15 PM', status: 'Reviewed' },
]).value;
const isDark = computed(() => state.isDark);
const pendingCount = computed(() => reviews.filter((item) => item.status === 'Pending').length);
const reviewedCount = computed(() => reviews.filter((item) => item.status === 'Reviewed').length);

const toggleTheme = (value: 'light' | 'dark') => setTheme(value);
const handleNav = (key: string) => {
    navItems.value = navItems.value.map((item) => ({ ...item, active: item.key === key }));
    sidebarOpen.value = false;
    if (key === 'home') return router.get('/doctor/dashboard');
    if (key === 'profile') return router.get('/doctor/profile');
    if (key === 'appointments') return router.get('/doctor/appointments');
    if (key === 'reviews') return router.get('/doctor/reviews');
    if (key === 'notification') return router.get('/doctor/notifications');
    if (key === 'logout') return router.get('/logout');
};
const handleViewFiles = () => router.get('/doctor/reviews/files');
const handleReviewDetails = () => router.get('/doctor/reviews/view-full-file?type=lab');

</script>
<template>
    <Head title="Doctor Reviews Dashboard" />
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
                <section>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-2 text-xs font-medium">
                        Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Reviews</span>
                    </p>
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Patient Reviews</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">Manage patient file reviews and clinical follow-ups.</p>
                </section>
                <section class="grid gap-3 md:grid-cols-3">
                    <ReviewStatsCard label="Total Reviews" :value="reviews.length" tone="total" />
                    <ReviewStatsCard label="Pending" :value="pendingCount" tone="pending" />
                    <ReviewStatsCard label="Reviewed" :value="reviewedCount" tone="reviewed" />
                </section>
                <section class="space-y-3">
                    <ReviewListItem
                        v-for="item in reviews"
                        :key="item.id"
                        :item="item"
                        @view-files="handleViewFiles"
                        @view-details="handleReviewDetails"
                        @edit-review="handleViewFiles"
                    />
                </section>
            </main>
        </div>
    </div>
</template>
