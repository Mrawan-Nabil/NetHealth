<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import BaseBadge from '@/components/doctor-dashboard/BaseBadge.vue';
import EditScheduleModal from '@/components/doctor-dashboard/EditScheduleModal.vue';
import PatientItem from '@/components/doctor-dashboard/PatientItem.vue';
import ReviewItem from '@/components/doctor-dashboard/ReviewItem.vue';
import ScheduleItem from '@/components/doctor-dashboard/ScheduleItem.vue';
import SectionCard from '@/components/doctor-dashboard/SectionCard.vue';
import StatCard from '@/components/doctor-dashboard/StatCard.vue';
import WeeklyAvailabilityCard from '@/components/doctor-dashboard/WeeklyAvailabilityCard.vue';
import WelcomeBanner from '@/components/doctor-dashboard/WelcomeBanner.vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

// ─── Props (Inertia Data Contract) ───────────────────────────────────────────
const props = defineProps({
    doctor: { type: Object, required: true },
    stats: { type: Object, required: true },
    todaySchedule: { type: Array, default: () => [] },
    upcomingAppointments: { type: Array, default: () => [] },
    pendingReviews: { type: Array, default: () => [] },
    recentPatients: { type: Array, default: () => [] },
    schedule: {
        type: Object,
        required: false,
        default: () => ({
            days: [],
            duration: '30 min',
            breakBetweenSlots: '5 min',
            selectedPreset: null,
            appointmentTypes: { inClinic: true, followUp: true, labReview: true },
            labReviewOptions: { acceptLabTests: true, acceptXrayImages: true },
        }),
    },
});

// ─── State ───────────────────────────────────────────────────────────────────
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const scheduleModalOpen = ref(false);
const localSchedule = ref(props.schedule);

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home', active: true },
    { key: 'profile', label: 'Profile', icon: 'profile' },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

// ─── Computed ─────────────────────────────────────────────────────────────────
const isDark = computed(() => state.isDark);

const statsCards = computed(() => [
    {
        title: 'Upcoming',
        value: String(props.stats?.upcomingAppointments),
        subtitle: 'Appointments',
        icon: 'calendar',
        accent: 'teal',
        urgent: false,
    },
    {
        title: 'Pending',
        value: String(props.stats?.pendingTestReviews).padStart(2),
        subtitle: 'Test Reviews',
        icon: 'file',
        accent: 'rose',
        urgent: props.stats?.pendingTestReviews > 0,
    },
    { title: 'Total', value: props.stats?.totalPatients.toLocaleString(), subtitle: 'Patients', icon: 'users', accent: 'emerald', urgent: false },
    { title: 'Completed', value: String(props.stats?.completedThisWeek), subtitle: 'This Week', icon: 'check', accent: 'amber', urgent: false },
]);

const availabilityDays = computed(() =>
    (localSchedule.value.days ?? []).map((day) => ({
        day: day.name,
        hours: day.enabled ? `${day.from} - ${day.to}` : 'Day Off',
        available: day.enabled,
    })),
);

// ─── Handlers ────────────────────────────────────────────────────────────────
const toggleTheme = (value) => setTheme(value);

const saveSchedule = (value) => {
    localSchedule.value = value;
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
    if (key === 'logout') return router.get('/logout');
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
                :doctor-name="props.doctor?.fullName"
                :handle="props.doctor?.handle"
                :avatar="props.doctor?.avatar ?? ''"
                :is-dark="isDark"
                @toggle-sidebar="sidebarOpen = true"
            />

            <main class="animate-fadeInUp space-y-6 p-4 sm:p-6 lg:p-7">
                <WelcomeBanner :name="props.doctor?.name" />

                <WeeklyAvailabilityCard :days="availabilityDays" @edit-schedule="scheduleModalOpen = true" />

                <section class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
                    <StatCard
                        v-for="item in statsCards"
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
                                    v-for="appointment in props.todaySchedule"
                                    :key="appointment.id"
                                    :patient-name="appointment.patientName"
                                    :appointment-type="appointment.appointmentType"
                                    :description="appointment.description"
                                    :time="appointment.time"
                                    :status="appointment.status"
                                    :avatar="appointment.avatar ?? ''"
                                    @view-details="router.get('/doctor/appointments')"
                                />
                            </div>
                        </SectionCard>

                        <SectionCard title="Upcoming Appointments">
                            <template #header-right>
                                <button
                                    class="text-sm font-semibold text-teal-600 transition-colors duration-200 hover:text-teal-700 focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-teal-300 dark:hover:text-teal-200"
                                    @click="router.get('/doctor/appointments')"
                                >
                                    View Full Calendar
                                </button>
                            </template>

                            <div class="space-y-3">
                                <article
                                    v-for="item in props.upcomingAppointments"
                                    :key="item.id"
                                    class="flex flex-col gap-3 rounded-xl bg-[#F8FAFC] p-4 transition-colors duration-200 hover:bg-[#F1F5F9] sm:flex-row sm:items-center sm:justify-between dark:bg-[#0F172A] dark:hover:bg-[#334155]/40"
                                >
                                    <div class="flex items-center gap-3">
                                        <div
                                            class="flex h-10 w-10 items-center justify-center rounded-full bg-sky-100 text-sm font-semibold text-sky-700 dark:bg-sky-500/20 dark:text-sky-300"
                                        >
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
                                        <button
                                            class="text-sm font-semibold text-teal-600 transition-colors duration-200 hover:text-teal-700 focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-teal-300 dark:hover:text-teal-200"
                                            @click="router.get('/doctor/appointments')"
                                        >
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
                                <BaseBadge variant="urgent">{{ props.pendingReviews.length }} New</BaseBadge>
                            </template>
                            <div class="space-y-3">
                                <ReviewItem
                                    v-for="review in props.pendingReviews"
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
                                    v-for="patient in props.recentPatients"
                                    :key="patient.id"
                                    :name="patient.name"
                                    :last-visit="patient.lastVisit"
                                    :note="patient.note"
                                    :avatar="patient.avatar ?? ''"
                                    @view-patient="router.get('/doctor/reviews/medical-record')"
                                />
                            </div>
                        </SectionCard>
                    </div>
                </section>
            </main>
        </div>

        <EditScheduleModal :open="scheduleModalOpen" :schedule="localSchedule" @close="scheduleModalOpen = false" @save="saveSchedule" />
    </div>
</template>
