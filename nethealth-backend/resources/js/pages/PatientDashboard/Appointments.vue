<script setup>
import { router } from '@inertiajs/vue3'
import { computed, onMounted } from 'vue'
import CancelledAppointmentCard from '@/components/appointments/CancelledAppointmentCard.vue'
import CompletedAppointmentCard from '@/components/appointments/CompletedAppointmentCard.vue'
import ScheduledAppointmentCard from '@/components/appointments/ScheduledAppointmentCard.vue'
import Sidebar from '@/components/dashboard/Sidebar.vue'
import TopNavbar from '@/components/dashboard/TopNavbar.vue'
import { useDashboard } from '@/composables/useDashboard.js'

const { state, setTheme, cancelAppointment } = useDashboard()

// LARAVEL DATA BINDING: Expects Array appointments
const props = defineProps({
    appointments: {
        type: Array,
        required: true,
        default: () => []
    },
    auth: {
        type: Object,
        default: () => ({ user: null }),
    },
})

// Computed properties
const isDark = computed(() => state.isDark)
const activeTab = computed({
    get: () => state.activeAppointmentTab || 'completed',
    set: (value) => { state.activeAppointmentTab = value }
})


const filteredAppointments = computed(() => {
    const statusMap = {
        'completed': 'Completed',
        'scheduled': 'Scheduled',
        'cancelled': 'Cancelled'
    }
    return props.appointments.filter(apt => apt.status === statusMap[activeTab.value])
})

// Methods
const toggleTheme = (theme) => {
    setTheme(theme)
}

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken')
        router.get('/logout')
    }
}

const handleNewAppointment = () => {
    router.get('/appointments/create')
}

const handleViewPrescription = (appointment) => {
    console.log('View prescription:', appointment)
    router.get(`/prescription/${appointment.id}`)
}

const handleViewReport = (appointment) => {
    console.log('View report:', appointment)
    alert('Viewing report for ' + appointment.doctorName)
}

const handleUploadTestResults = (appointment) => {
    console.log('Upload test results:', appointment)
    alert('Upload test results for ' + appointment.doctorName)
}

const handleUploadImaging = (appointment) => {
    console.log('Upload imaging:', appointment)
    alert('Upload imaging for ' + appointment.doctorName)
}

const handleReschedule = (appointment) => {
    console.log('Reschedule:', appointment)
    alert('Reschedule appointment with ' + appointment.doctorName)
}

const handleCancelAppointment = (appointment) => {
    if (confirm('Are you sure you want to cancel this appointment?')) {
        cancelAppointment(appointment.id, 'Patient requested cancellation')
        alert('Appointment cancelled')
    }
}

// Lifecycle
onMounted(() => {
    // Data is provided by Inertia props
})
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <!-- Sidebar -->
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <!-- Main Content -->
        <div class="ml-64">
            <!-- Top Navbar -->
            <TopNavbar
                :title="'Your Page Title Here'"
                :is-dark="isDark"
                :user="{
        name: auth?.user?.name || 'Patient',
        username: '@' + (auth?.user?.email?.split('@')[0] || 'patient'),
        avatar: auth?.user?.avatar || `https://ui-avatars.com/api/?name=${auth?.user?.name || 'Patient'}&background=0D9488&color=fff`,
    }"
                :notifications="[]"
                :show-last-viewed="true"
                :show-share="true"
                @logout="handleLogout"
            />

            <!-- Page Content -->
            <main class="p-6">
                <!-- Breadcrumb -->
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
                        <span class="text-gray-400">Appointments</span>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">{{
                            activeTab === 'completed' ? 'Completed' : activeTab === 'scheduled' ? 'Scheduled' : 'Cancelled'
                        }}</span>
                    </p>
                </div>

                <!-- Tabs -->
                <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="mb-6 border-b">
                    <div class="flex gap-8">
                        <button
                            @click="activeTab = 'completed'"
                            :class="[
                                'border-b-2 px-2 pb-4 text-sm font-medium transition-all duration-300',
                                activeTab === 'completed'
                                    ? 'border-[#14B8A6] text-[#14B8A6]'
                                    : isDark
                                      ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                                      : 'border-transparent text-[#6B7280] hover:text-[#111827]',
                            ]"
                        >
                            Completed
                        </button>
                        <button
                            @click="activeTab = 'scheduled'"
                            :class="[
                                'border-b-2 px-2 pb-4 text-sm font-medium transition-all duration-300',
                                activeTab === 'scheduled'
                                    ? 'border-[#14B8A6] text-[#14B8A6]'
                                    : isDark
                                      ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                                      : 'border-transparent text-[#6B7280] hover:text-[#111827]',
                            ]"
                        >
                            Scheduled
                        </button>
                        <button
                            @click="activeTab = 'cancelled'"
                            :class="[
                                'border-b-2 px-2 pb-4 text-sm font-medium transition-all duration-300',
                                activeTab === 'cancelled'
                                    ? 'border-[#14B8A6] text-[#14B8A6]'
                                    : isDark
                                      ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                                      : 'border-transparent text-[#6B7280] hover:text-[#111827]',
                            ]"
                        >
                            Cancelled
                        </button>
                    </div>
                </div>

                <!-- Page Header -->
                <div class="mb-6 flex items-start justify-between">
                    <div>
                        <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">
                            {{
                                activeTab === 'completed'
                                    ? 'Completed Appointments'
                                    : activeTab === 'scheduled'
                                      ? 'Scheduled Appointments'
                                      : 'Cancelled Appointments'
                            }}
                        </h1>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                            {{
                                activeTab === 'completed'
                                    ? 'Review details from your past visits and download medical documentation.'
                                    : activeTab === 'scheduled'
                                      ? 'View and manage your upcoming appointments.'
                                      : 'Review cancelled appointments.'
                            }}
                        </p>
                    </div>

                    <button
                        @click="handleNewAppointment"
                        class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                    >
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                        </svg>
                        New Appointment
                    </button>
                </div>

                <!-- Appointments Grid -->
                <div>
                    <!-- Completed & Scheduled: 2-column grid -->
                    <div v-if="activeTab !== 'cancelled'" class="grid grid-cols-1 gap-6 lg:grid-cols-2">
                        <!-- Completed Appointments -->
                        <CompletedAppointmentCard
                            :v-if="activeTab === 'completed'"
                            v-for="appointment in filteredAppointments"
                            :key="appointment.id"
                            :appointment="appointment"
                            :is-dark="isDark"
                            @view-prescription="handleViewPrescription"
                            @view-report="handleViewReport"
                        />

                        <!-- Scheduled Appointments -->
                        <ScheduledAppointmentCard
                            :v-if="activeTab === 'scheduled'"
                            v-for="appointment in filteredAppointments"
                            :key="appointment.id"
                            :appointment="appointment"
                            :is-dark="isDark"
                            @upload-test-results="handleUploadTestResults"
                            @upload-imaging="handleUploadImaging"
                            @reschedule="handleReschedule"
                            @cancel="handleCancelAppointment"
                        />
                    </div>

                    <!-- Cancelled: Single column -->
                    <div v-else class="space-y-4">
                        <CancelledAppointmentCard
                            v-for="appointment in filteredAppointments"
                            :key="appointment.id"
                            :appointment="appointment"
                            :is-dark="isDark"
                            @reschedule="handleReschedule"
                        />
                    </div>
                </div>

                <!-- Empty State -->
                <div
                    v-if="filteredAppointments.length === 0"
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="rounded-lg border p-12 text-center"
                >
                    <svg
                        class="mx-auto mb-4 h-16 w-16"
                        :class="isDark ? 'text-[#94A3B8]' : 'text-gray-400'"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                        />
                    </svg>
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 text-lg font-semibold">No Appointments Found</h3>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">You don't have any {{ activeTab }} appointments yet.</p>
                </div>
            </main>
        </div>
    </div>
</template>
