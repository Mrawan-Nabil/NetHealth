<script setup>
import { router, Link } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppointmentSuccessModal from '@/components/appointments/AppointmentSuccessModal.vue';
import ConfirmAppointmentModal from '@/components/appointments/ConfirmAppointmentModal.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

const props = defineProps({
    doctor: {
        type: Object,
        required: true,
    },
    days: {
        type: Array,
        default: () => [
            { id: 'monday', name: 'Monday', disabled: false },
            { id: 'tuesday', name: 'Tuesday', disabled: false },
            { id: 'wednesday', name: 'Wednesday', disabled: false },
            { id: 'thursday', name: 'Thursday', disabled: true },
            { id: 'friday', name: 'Friday', disabled: false },
        ],
    },
    timeSlots: {
        type: Array,
        default: () => [
            { id: '9:00', time: '9:00 AM' },
            { id: '9:30', time: '9:30 AM' },
            { id: '10:00', time: '10:00 AM' },
            { id: '11:30', time: '11:30 AM' },
            { id: '2:00', time: '2:00 PM' },
            { id: '3:00', time: '3:00 PM' },
        ],
    },
    appointmentTypes: {
        type: Array,
        default: () => [
            {
                id: 'physical',
                name: 'Clinic Visit',
                description: 'In-person consultation',
                icon: '<svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>',
            },
            {
                id: 'remote',
                name: 'Online Medical Consultation',
                description: 'Online Lab & Imaging Consultation',
                icon: '<svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>',
            },
            {
                id: 'emergency',
                name: 'Emergency Visit',
                description: 'Urgent immediate care',
                icon: '<svg class="w-5 h-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>'
            }
        ],
    },
});

const isDark = computed(() => state.isDark);
const selectedDay = ref('monday');
const selectedSlot = ref(null);
const selectedType = ref(null);
const showConfirmModal = ref(false);
const showSuccessModal = ref(false);
const bookingData = ref(null);

const appointmentSummary = computed(() => {
    if (!selectedDay.value || !selectedSlot.value || !selectedType.value) {
        return 'Please select day, time, and appointment type';
    }

    const day = props.days.find((d) => d.id === selectedDay.value);
    const slot = props.timeSlots.find((s) => s.id === selectedSlot.value);
    const type = props.appointmentTypes.find((t) => t.id === selectedType.value);

    if (!day || !slot || !type) return 'Please select day, time, and appointment type';
    return `${day.name} • ${slot.time} • ${type.name}`;
});

const appointmentData = computed(() => {
    const day = props.days.find((d) => d.id === selectedDay.value);
    const slot = props.timeSlots.find((s) => s.id === selectedSlot.value);
    const type = props.appointmentTypes.find((t) => t.id === selectedType.value);

    return {
        doctor: {
            name: props.doctor.name,
            specialty: props.doctor.specialty,
            avatar: props.doctor.avatar,
        },
        date: day?.name || 'TBD',
        time: slot?.time || '',
        type: type?.name || '',
    };
});

const toggleTheme = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const handleConfirmAppointment = () => {
    if (!selectedDay.value || !selectedSlot.value || !selectedType.value) return;
    showConfirmModal.value = true;
};

const handleModalConfirm = (data) => {
    const slot = props.timeSlots.find((s) => s.id === selectedSlot.value);
    const appointmentDateTime = `2026-10-22 ${slot?.time || '09:00 AM'}`;

    router.post(
        '/appointments',
        {
            doctor_id: props.doctor.id,
            appointment_time: appointmentDateTime,
            appointment_type: selectedType.value,
            notes: data.patientInfo.notes,
        },
        {
            onSuccess: () => {
                bookingData.value = data;
                showConfirmModal.value = false;
                showSuccessModal.value = true;
            },
        },
    );
};

const handleModalClose = () => showConfirmModal.value = false;
const handleViewAppointments = () => { showSuccessModal.value = false; router.get('/appointments'); };
const handleBackToDashboard  = () => { showSuccessModal.value = false; router.get('/dashboard'); };

const cardClass = computed(() => isDark.value ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white');
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Doctor Profile"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">
                <!-- Breadcrumb -->
                <div class="mb-7">
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-xs font-medium">
                        Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <Link href="/appointments/create" class="transition-colors hover:text-[#14B8A6]">Book Appointment</Link>
                        <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">{{ doctor.name }}</span>
                    </p>
                </div>

                <!-- Profile Header -->
                <div :class="cardClass" class="mb-6 rounded-2xl border p-6" style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                    <div class="flex flex-col md:flex-row items-start justify-between gap-6">
                        <div class="flex items-start gap-6 w-full">
                            <div class="relative shrink-0">
                                <img :src="doctor.avatar" alt="Doctor" class="h-28 w-28 rounded-2xl object-cover ring-4" :class="isDark ? 'ring-[#1E293B]' : 'ring-white'" />
                                <div class="absolute -right-2 -bottom-2 flex h-8 w-8 items-center justify-center rounded-full bg-emerald-400 border-4" :class="isDark ? 'border-[#1E293B]' : 'border-white'">
                                    <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7" />
                                    </svg>
                                </div>
                            </div>

                            <div class="flex-1">
                                <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-xl font-bold tracking-tight">
                                    {{ doctor.name }}
                                </h1>
                                <p class="mb-3 text-sm font-semibold text-[#14B8A6]">{{ doctor.specialty }}</p>

                                <div class="mb-4 flex flex-wrap items-center gap-4 text-xs font-medium" :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">
                                    <div class="flex items-center gap-1.5">
                                        <svg class="h-4 w-4 text-[#F59E0B]" fill="currentColor" viewBox="0 0 20 20">
                                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                        </svg>
                                        <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-bold">{{ doctor.rating || '4.9' }}</span>
                                        <span>({{ doctor.reviews || '120' }} reviews)</span>
                                    </div>
                                    <div class="flex items-center gap-1.5 border-l px-4" :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'">
                                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                                        <span>12 Years Exp.</span>
                                    </div>
                                    <div class="flex items-center gap-1.5 border-l pl-4" :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'">
                                        <svg class="h-4 w-4 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                                        <span>{{ doctor.hospital }}</span>
                                    </div>
                                </div>

                                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="max-w-2xl text-xs leading-relaxed">
                                    {{ doctor.name }} is a specialist at {{ doctor.hospital }} with over 12 years of experience specializing in preventive care and advanced patient management.
                                </p>
                            </div>
                        </div>

                        <!-- Actions & Price -->
                        <div class="flex flex-col items-end gap-5 shrink-0 w-full md:w-auto mt-4 md:mt-0">
                            <div class="flex items-center gap-2 w-full md:w-auto">
                                <button :class="isDark ? 'border-[#334155] text-[#F1F5F9] hover:bg-[#334155]' : 'border-[#E5E7EB] text-[#0F172A] hover:bg-[#F8FAFC]'" class="flex flex-1 md:flex-none justify-center items-center gap-2 rounded-xl border px-3 py-2 text-xs font-semibold transition-colors">
                                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"/></svg>
                                    Share
                                </button>
                                <button class="btn-primary flex-1 md:flex-none px-3 py-2 text-xs">
                                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/></svg>
                                    Favorite
                                </button>
                            </div>
                            <div class="text-right hidden md:block">
                                <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'" class="block text-[10px] font-bold uppercase tracking-wider mb-0.5">Consultation Fee</span>
                                <span class="text-xl font-extrabold text-[#14B8A6]">{{ doctor.price || '$100' }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Booking Area -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                    <!-- Left: Scheduling -->
                    <div class="lg:col-span-7 space-y-6">
                        <!-- Days -->
                        <div :class="cardClass" class="rounded-2xl border p-5" style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                            <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-4 text-sm font-semibold">Available Days</h3>
                            <div class="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-hide">
                                <button
                                    v-for="day in days"
                                    :key="day.id"
                                    @click="selectedDay = day.id"
                                    :class="[
                                        'shrink-0 rounded-xl px-5 py-2.5 text-xs font-semibold transition-all duration-200',
                                        selectedDay === day.id
                                            ? 'bg-[#14B8A6] text-white shadow-md shadow-teal-500/20'
                                            : day.disabled
                                              ? (isDark ? 'cursor-not-allowed bg-[#1E293B] text-[#475569] opacity-50' : 'cursor-not-allowed bg-[#F8FAFC] text-[#CBD5E1]')
                                              : (isDark ? 'bg-[#0F172A] text-[#94A3B8] hover:bg-[#334155]/60 hover:text-[#F1F5F9]' : 'border border-[#E5E7EB] bg-white text-[#64748B] hover:bg-[#F8FAFC] hover:text-[#0F172A]'),
                                    ]"
                                    :disabled="day.disabled"
                                >
                                    {{ day.name }}
                                </button>
                            </div>
                        </div>

                        <!-- Times -->
                        <div :class="cardClass" class="rounded-2xl border p-5" style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                            <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-4 text-sm font-semibold">
                                Available Time Slots <span class="text-xs font-medium text-[#9CA3AF] ml-1">({{ days.find((d) => d.id === selectedDay)?.name }})</span>
                            </h3>
                            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
                                <button
                                    v-for="slot in timeSlots"
                                    :key="slot.id"
                                    @click="selectedSlot = slot.id"
                                    :class="[
                                        'rounded-xl border-2 py-2.5 text-xs font-semibold transition-all duration-200',
                                        selectedSlot === slot.id
                                            ? 'border-[#14B8A6] bg-[#14B8A6] text-white shadow-md shadow-teal-500/20'
                                            : isDark
                                              ? 'border-transparent bg-[#0F172A] text-[#94A3B8] hover:bg-[#334155]/60 hover:text-[#F1F5F9]'
                                              : 'border-[#E5E7EB] bg-white text-[#64748B] hover:bg-[#F8FAFC] hover:text-[#0F172A]',
                                    ]"
                                >
                                    {{ slot.time }}
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Appointment Type -->
                    <div class="lg:col-span-5">
                        <div :class="cardClass" class="rounded-2xl border p-5" style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                            <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-4 text-sm font-semibold">Visit Type</h3>
                            <div class="space-y-3">
                                <button
                                    v-for="type in appointmentTypes"
                                    :key="type.id"
                                    @click="selectedType = type.id"
                                    :class="[
                                        'flex w-full items-start gap-3 rounded-xl border-2 p-3.5 text-left transition-all duration-200',
                                        selectedType === type.id
                                            ? isDark ? 'border-[#14B8A6] bg-[#14B8A6]/10' : 'border-[#14B8A6] bg-[#F0FDFA]'
                                            : isDark
                                              ? 'border-transparent bg-[#0F172A] hover:bg-[#334155]/40'
                                              : 'border-[#E5E7EB] bg-white hover:bg-[#F8FAFC]',
                                    ]"
                                >
                                    <div v-html="type.icon" class="mt-0.5 shrink-0"></div>
                                    <div class="flex-1 min-w-0">
                                        <h4 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-0.5 text-xs font-bold leading-tight">
                                            {{ type.name }}
                                        </h4>
                                        <p :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="text-[11px] truncate">
                                            {{ type.description }}
                                        </p>
                                    </div>
                                    <div class="shrink-0 mt-1">
                                        <div :class="[
                                            'flex h-4 w-4 items-center justify-center rounded-full border-2 transition-colors',
                                            selectedType === type.id
                                                ? 'border-[#14B8A6] bg-[#14B8A6]'
                                                : isDark ? 'border-[#475569]' : 'border-[#CBD5E1]',
                                            ]"
                                        >
                                            <svg v-if="selectedType === type.id" class="h-2.5 w-2.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                                            </svg>
                                        </div>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Booking Action Bar -->
                <div :class="cardClass" class="mt-6 flex flex-col md:flex-row items-center justify-between gap-4 rounded-2xl border p-5" style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                    <div class="text-center md:text-left">
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-1 text-[10px] uppercase font-bold tracking-widest">Appointment Summary</p>
                        <p :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-sm font-semibold">
                            {{ appointmentSummary }}
                        </p>
                    </div>
                    <button
                        @click="handleConfirmAppointment"
                        :disabled="!selectedDay || !selectedSlot || !selectedType"
                        :class="[
                            'flex w-full md:w-auto justify-center items-center gap-2 rounded-xl px-8 py-3 text-sm font-bold transition-all duration-200',
                            selectedDay && selectedSlot && selectedType
                                ? 'bg-[#14B8A6] text-white hover:bg-[#0D9488] shadow-lg shadow-teal-500/25 cursor-pointer active:scale-95'
                                : isDark
                                  ? 'cursor-not-allowed bg-[#0F172A] text-[#475569] opacity-50'
                                  : 'cursor-not-allowed bg-[#F8FAFC] text-[#CBD5E1] border border-[#E5E7EB]',
                        ]"
                    >
                        Confirm Booking
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                        </svg>
                    </button>
                </div>
            </main>
        </div>

        <ConfirmAppointmentModal
            :is-open="showConfirmModal"
            :appointment="appointmentData"
            :is-dark="isDark"
            @close="handleModalClose"
            @confirm="handleModalConfirm"
        />

        <AppointmentSuccessModal
            :is-open="showSuccessModal"
            :appointment="appointmentData"
            :uploaded-files="bookingData?.files || []"
            :is-dark="isDark"
            @close="() => (showSuccessModal = false)"
            @view-appointments="handleViewAppointments"
            @back-to-dashboard="handleBackToDashboard"
        />
    </div>
</template>

<style scoped>
.animate-fadeInUp {
    animation: fadeInUp 0.4s ease-out both;
}
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
}
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}
.scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>
