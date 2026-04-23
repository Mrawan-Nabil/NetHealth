<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import BaseBadge from '@/components/doctor-dashboard/BaseBadge.vue';
import EditScheduleModal from '@/components/doctor-dashboard/EditScheduleModal.vue';
import PatientItem from '@/components/doctor-dashboard/PatientItem.vue';
import ReviewItem from '@/components/doctor-dashboard/ReviewItem.vue';
import ScheduleItem from '@/components/doctor-dashboard/ScheduleItem.vue';
import SectionCard from '@/components/doctor-dashboard/SectionCard.vue';
import StatCard from '@/components/doctor-dashboard/StatCard.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import WeeklyAvailabilityCard from '@/components/doctor-dashboard/WeeklyAvailabilityCard.vue';
import WelcomeBanner from '@/components/doctor-dashboard/WelcomeBanner.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const scheduleModalOpen = ref(false);

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));

const doctorProfile = ref({
    name: 'Dr. Ahmed',
    fullName: 'Ahmed Yahia',
    handle: '@yilo007',
    avatar: 'https://i.pravatar.cc/100?img=12',
});

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home', active: true },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

const schedule = ref({
    days: [
        { name: 'Monday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Tuesday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Wednesday', enabled: false, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Thursday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Friday', enabled: false, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Saturday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Sunday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
    ],
    duration: '30 min',
    breakBetweenSlots: '10 min',
    selectedPreset: 'morning',
    appointmentTypes: {
        inClinic: true,
        followUp: false,
        labReview: true,
    },
    labReviewOptions: {
        acceptLabTests: true,
        acceptXrayImages: false,
    },
});

const stats = ref([
    { title: 'Upcoming', value: '12', subtitle: 'Appointments', icon: 'calendar', accent: 'teal', urgent: false },
    { title: 'Pending', value: '08', subtitle: 'Test Reviews', icon: 'file', accent: 'rose', urgent: true },
    { title: 'Total', value: '1,420', subtitle: 'Patients', icon: 'users', accent: 'emerald', urgent: false },
    { title: 'Completed', value: '42', subtitle: 'This Week', icon: 'check', accent: 'amber', urgent: false },
]);

const todaySchedule = ref([
    {
        id: 1,
        patientName: 'Sarah Johnson',
        appointmentType: 'Clinic',
        description: 'Regular Checkup',
        time: '09:00 AM',
        status: 'Waiting',
        avatar: 'https://i.pravatar.cc/80?img=32',
    },
    {
        id: 2,
        patientName: 'Sarah Johnson',
        appointmentType: 'Clinic',
        description: 'Post-Op Follow Up',
        time: '09:00 AM',
        status: 'Confirmed',
        avatar: 'https://i.pravatar.cc/80?img=35',
    },
]);

const upcomingAppointments = ref([
    { id: 1, initials: 'GH', name: 'Greg House', type: 'CLINIC', date: 'Oct 25, 2024', time: '08:45 AM', status: 'Upcoming' },
    { id: 2, initials: 'GH', name: 'Greg House', type: 'CLINIC', date: 'Oct 25, 2024', time: '08:45 AM', status: 'Upcoming' },
    { id: 3, initials: 'GH', name: 'Greg House', type: 'CLINIC', date: 'Oct 25, 2024', time: '08:45 AM', status: 'Upcoming' },
]);

const pendingReviews = ref([
    { id: 1, reportType: 'Lab Report', patientName: 'James W.', category: 'Blood Panel', timeAgo: '2 hours ago' },
    { id: 2, reportType: 'X-Ray', patientName: 'Linda P.', category: 'Chest Imaging', timeAgo: '5 hours ago' },
    { id: 3, reportType: 'X-Ray', patientName: 'Linda P.', category: 'Chest Imaging', timeAgo: '5 hours ago' },
]);

const recentPatients = ref([
    { id: 1, name: 'Robert Miller', lastVisit: 'Oct 20', note: 'Hypertension', avatar: 'https://i.pravatar.cc/80?img=62' },
    { id: 2, name: 'Amina Yusuf', lastVisit: 'Oct 18', note: 'Prenatal Care', avatar: 'https://i.pravatar.cc/80?img=47' },
    { id: 3, name: 'Baby Oliver', lastVisit: 'Oct 15', note: 'Vaccination', avatar: 'https://i.pravatar.cc/80?img=15' },
]);

const isDark = computed(() => state.isDark);
const availabilityDays = computed(() =>
    schedule.value.days.map((day) => ({
        day: day.name,
        hours: day.enabled ? `${day.from} - ${day.to}` : 'Day Off',
        available: day.enabled,
    })),
);

const toggleTheme = (value) => setTheme(value);

const saveSchedule = (value) => {
    schedule.value = value;
    scheduleModalOpen.value = false;
};

const handleNav = (key) => {
    navItems.value = navItems.value.map((item) => ({ ...item, active: item.key === key }));
    sidebarOpen.value = false;

    if (key === 'home') return router.get('/doctor/dashboard');
    if (key === 'profile') return router.get('/doctor/profile');
    if (key === 'appointments') return router.get('/doctor/appointments');
    if (key === 'reviews') return router.get('/doctor/reviews');
    if (key === 'notification') return router.get('/doctor/notifications');
    if (key === 'logout') {
        router.get('/logout');
    }
};

</script>

<template>
    <Head title="Doctor Dashboard" />

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
                title="Home"
                :doctor-name="doctorProfile.fullName"
                :handle="doctorProfile.handle"
                :avatar="doctorProfile.avatar"
                :is-dark="isDark"
                @toggle-sidebar="sidebarOpen = true"
            />

            <main class="space-y-6 p-4 sm:p-6 lg:p-7 animate-fadeInUp">
                <WelcomeBanner :name="doctorProfile.name" />

                <WeeklyAvailabilityCard :days="availabilityDays" @edit-schedule="scheduleModalOpen = true" />

                <section class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
                    <StatCard
                        v-for="item in stats"
                        :key="item.title"
                        :title="item.title"
                        :value="item.value"
                        :subtitle="item.subtitle"
                        :icon="item.icon"
                        :accent="item.accent"
                        :urgent="item.urgent"
                    />
                </section>

                <section class="grid grid-cols-1 gap-6 lg:grid-cols-3">
                    <div class="space-y-6 lg:col-span-2">
                        <SectionCard title="Today's Schedule">
                            <div class="space-y-3">
                                <ScheduleItem
                                    v-for="appointment in todaySchedule"
                                    :key="appointment.id"
                                    :patient-name="appointment.patientName"
                                    :appointment-type="appointment.appointmentType"
                                    :description="appointment.description"
                                    :time="appointment.time"
                                    :status="appointment.status"
                                    :avatar="appointment.avatar"
                                    @view-details="router.get('/doctor/appointments')"
                                />
                            </div>
                        </SectionCard>

                        <SectionCard title="Upcoming Appointments">
                            <template #header-right>
                                <button class="text-sm font-semibold text-teal-600 transition-colors duration-200 hover:text-teal-700 focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-teal-300 dark:hover:text-teal-200" @click="router.get('/doctor/appointments')">
                                    View Full Calendar
                                </button>
                            </template>

                            <div class="space-y-3">
                                <article
                                    v-for="item in upcomingAppointments"
                                    :key="item.id"
                                    class="flex flex-col gap-3 rounded-xl bg-[#F8FAFC] p-4 transition-colors duration-200 hover:bg-[#F1F5F9] sm:flex-row sm:items-center sm:justify-between dark:bg-[#0F172A] dark:hover:bg-[#334155]/40"
                                >
                                    <div class="flex items-center gap-3">
                                        <div class="flex h-10 w-10 items-center justify-center rounded-full bg-sky-100 text-sm font-semibold text-sky-700 dark:bg-sky-500/20 dark:text-sky-300">
                                            {{ item.initials }}
                                        </div>
                                        <div>
                                            <p class="font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ item.name }}</p>
                                            <p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.type }}</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3 self-end sm:self-auto">
                                        <div class="text-right">
                                            <p class="text-sm font-medium text-[#0F172A] dark:text-[#F1F5F9]">{{ item.date }}</p>
                                            <p class="text-xs text-[#64748B] dark:text-[#94A3B8]">{{ item.time }}</p>
                                        </div>
                                        <BaseBadge variant="teal">{{ item.status }}</BaseBadge>
                                        <button class="text-sm font-semibold text-teal-600 transition-colors duration-200 hover:text-teal-700 focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-teal-300 dark:hover:text-teal-200" @click="router.get('/doctor/appointments')">
                                            View Details
                                        </button>
                                    </div>
                                </article>
                            </div>
                        </SectionCard>
                    </div>

                    <div class="space-y-6">
                        <SectionCard title="Pending Reviews">
                            <template #header-right>
                                <BaseBadge variant="urgent">3 New</BaseBadge>
                            </template>
                            <div class="space-y-3">
                                <ReviewItem
                                    v-for="review in pendingReviews"
                                    :key="review.id"
                                    :report-type="review.reportType"
                                    :patient-name="review.patientName"
                                    :category="review.category"
                                    :time-ago="review.timeAgo"
                                    @review-files="router.get('/doctor/reviews/files')"
                                />
                            </div>
                        </SectionCard>

                        <SectionCard title="Recent Patients">
                            <div class="space-y-3">
                                <PatientItem
                                    v-for="patient in recentPatients"
                                    :key="patient.id"
                                    :name="patient.name"
                                    :last-visit="patient.lastVisit"
                                    :note="patient.note"
                                    :avatar="patient.avatar"
                                    @view-patient="router.get('/doctor/reviews/medical-record')"
                                />
                            </div>
                        </SectionCard>
                    </div>
                </section>
            </main>
        </div>

        <EditScheduleModal :open="scheduleModalOpen" :schedule="schedule" @close="scheduleModalOpen = false" @save="saveSchedule" />
    </div>
</template>
