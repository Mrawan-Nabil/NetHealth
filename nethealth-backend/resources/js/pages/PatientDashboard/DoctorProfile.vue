<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted } from 'vue';
import AppointmentSuccessModal from '@/components/appointments/AppointmentSuccessModal.vue';
import ConfirmAppointmentModal from '@/components/appointments/ConfirmAppointmentModal.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';

// 1. Accept Real Data from Laravel Controller
const props = defineProps({
    auth: {
        type: Object,
        default: () => ({ user: null }),
    },
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

// State
const isDark = ref(false);
const selectedDay = ref('monday');
const selectedSlot = ref(null);
const selectedType = ref(null);
const showConfirmModal = ref(false);
const showSuccessModal = ref(false);
const bookingData = ref(null);

// Computed
const appointmentSummary = computed(() => {
    if (!selectedDay.value || !selectedSlot.value || !selectedType.value) {
        return 'Please select day, time, and appointment type';
    }

    const day = props.days.find((d) => d.id === selectedDay.value);
    const slot = props.timeSlots.find((s) => s.id === selectedSlot.value);
    const type = props.appointmentTypes.find((t) => t.id === selectedType.value);

    if (!day || !slot || !type) {
        return 'Please select day, time, and appointment type';
    }

    // You can make the date dynamic later!
    return `${day.name} • ${slot.time} • ${type.name}`;
});

// Computed for modal data to feed exact info
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

// Methods
const toggleTheme = (theme) => {
    isDark.value = theme === 'dark';
    localStorage.setItem('theme', theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const handleConfirmAppointment = () => {
    if (!selectedDay.value || !selectedSlot.value || !selectedType.value) {
        return;
    }
    showConfirmModal.value = true;
};

const handleModalConfirm = (data) => {
    // Combine the selected day and time into a parseable string (Example format)
    const slot = props.timeSlots.find((s) => s.id === selectedSlot.value);

    // In a real app, you'd use a real date picker. For now, we fake the date string:
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

const handleModalClose = () => {
    showConfirmModal.value = false;
};

const handleViewAppointments = () => {
    showSuccessModal.value = false;
    router.get('/appointments');
};

const handleBackToDashboard = () => {
    showSuccessModal.value = false;
    router.get('/dashboard');
};

// Lifecycle
onMounted(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        isDark.value = savedTheme === 'dark';
    }
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Doctor Profile"
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

            <main class="p-6">
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm">
                        <Link href="/appointments/create" class="transition-colors hover:text-[#14B8A6]">Doctors</Link>
                        <span class="mx-2">/</span>
                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="font-medium">{{ doctor.name }}</span>
                    </p>
                </div>

                <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="mb-6 rounded-xl border p-6">
                    <div class="mb-6 flex items-start justify-between">
                        <div class="flex items-start gap-6">
                            <div class="relative">
                                <img :src="doctor.avatar" alt="Doctor" class="h-32 w-32 rounded-xl object-cover" />
                                <div class="absolute -right-2 -bottom-2 flex h-10 w-10 items-center justify-center rounded-full bg-[#14B8A6]">
                                    <svg class="h-5 w-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                    </svg>
                                </div>
                            </div>

                            <div>
                                <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 text-2xl font-bold">
                                    {{ doctor.name }}
                                </h1>
                                <p class="mb-3 text-base font-medium text-[#14B8A6]">{{ doctor.specialty }} • {{ doctor.hospital }}</p>

                                <div class="mb-4 flex items-center gap-6">
                                    <div class="flex items-center gap-1">
                                        <svg class="h-5 w-5 text-[#F59E0B]" fill="currentColor" viewBox="0 0 20 20">
                                            <path
                                                d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                                            />
                                        </svg>
                                        <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">{{
                                            doctor.rating || '4.9'
                                        }}</span>
                                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-sm"
                                            >({{ doctor.reviews || '120' }} reviews)</span
                                        >
                                    </div>

                                    <div class="flex items-center gap-2">
                                        <svg
                                            class="h-5 w-5"
                                            :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                                            />
                                        </svg>
                                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">12 Years Experience</span>
                                    </div>
                                </div>

                                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="max-w-2xl text-sm leading-relaxed">
                                    {{ doctor.name }} is a specialist at {{ doctor.hospital }} with over 12 years of experience specializing in
                                    preventive care and advanced patient management.
                                </p>

                                <div class="mt-4 flex items-center gap-2">
                                    <svg class="h-5 w-5 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                                        />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                    </svg>
                                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                                        {{ doctor.hospital }}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="flex items-center gap-3">
                            <button
                                :class="
                                    isDark
                                        ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#334155]'
                                        : 'border-[#E5E7EB] text-[#111827] hover:bg-[#F9FAFB]'
                                "
                                class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-semibold transition-colors"
                            >
                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"
                                    />
                                </svg>
                                Share
                            </button>
                            <button
                                class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#0F9B8E]"
                            >
                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
                                    />
                                </svg>
                                Favorite
                            </button>
                        </div>
                    </div>

                    <div class="flex items-center justify-end">
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mr-2 text-sm">Consultation Fee:</span>
                        <span class="text-xl font-bold text-[#14B8A6]">{{ doctor.price || '$100' }}</span>
                    </div>
                </div>

                <div class="mb-6 grid grid-cols-4 gap-4">
                    <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="rounded-xl border p-4 text-center">
                        <svg class="mx-auto mb-2 h-8 w-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                            />
                        </svg>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-1 text-xs uppercase">NEXT AVAILABLE</p>
                        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">Tomorrow</p>
                    </div>

                    <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="rounded-xl border p-4 text-center">
                        <svg class="mx-auto mb-2 h-8 w-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
                            />
                        </svg>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-1 text-xs uppercase">CONSULTATION</p>
                        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">{{ doctor.price || '$100.00' }}</p>
                    </div>

                    <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="rounded-xl border p-4 text-center">
                        <svg class="mx-auto mb-2 h-8 w-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                            />
                        </svg>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-1 text-xs uppercase">EXPERIENCE</p>
                        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">12+ Years</p>
                    </div>

                    <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="rounded-xl border p-4 text-center">
                        <svg class="mx-auto mb-2 h-8 w-8 text-[#14B8A6]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2M7 20H5a2 2 0 01-2-2v-6a2 2 0 012-2h2.5"
                            />
                        </svg>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-1 text-xs uppercase">RATING</p>
                        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
                            {{ doctor.rating || '4.9' }} / 5.0
                        </p>
                    </div>
                </div>

                <div class="grid grid-cols-12 gap-6">
                    <div class="col-span-7">
                        <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="mb-6 rounded-xl border p-6">
                            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-4 text-lg font-semibold">Available Days</h3>
                            <div class="flex items-center gap-3">
                                <button
                                    v-for="day in days"
                                    :key="day.id"
                                    @click="selectedDay = day.id"
                                    :class="[
                                        'rounded-lg px-6 py-2.5 text-sm font-semibold transition-colors',
                                        selectedDay === day.id
                                            ? 'bg-[#14B8A6] text-white'
                                            : day.disabled
                                              ? isDark
                                                  ? 'cursor-not-allowed bg-[#334155] text-[#64748B]'
                                                  : 'cursor-not-allowed bg-[#F3F4F6] text-[#9CA3AF]'
                                              : isDark
                                                ? 'bg-[#334155] text-[#F8FAFC] hover:bg-[#475569]'
                                                : 'border border-[#E5E7EB] bg-white text-[#111827] hover:bg-[#F9FAFB]',
                                    ]"
                                    :disabled="day.disabled"
                                >
                                    {{ day.name }}
                                </button>
                            </div>
                        </div>

                        <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="rounded-xl border p-6">
                            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-4 text-lg font-semibold">
                                Available Time Slots - {{ days.find((d) => d.id === selectedDay)?.name }}
                            </h3>
                            <div class="grid grid-cols-3 gap-3">
                                <button
                                    v-for="slot in timeSlots"
                                    :key="slot.id"
                                    @click="selectedSlot = slot.id"
                                    :class="[
                                        'rounded-lg px-4 py-3 text-sm font-semibold transition-colors',
                                        selectedSlot === slot.id
                                            ? 'border-2 border-[#14B8A6] bg-[#14B8A6] text-white'
                                            : isDark
                                              ? 'border-2 border-transparent bg-[#334155] text-[#F8FAFC] hover:bg-[#475569]'
                                              : 'border-2 border-[#E5E7EB] bg-white text-[#111827] hover:bg-[#F9FAFB]',
                                    ]"
                                >
                                    {{ slot.time }}
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-span-5">
                        <div :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'" class="rounded-xl border p-6">
                            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-4 text-lg font-semibold">Appointment Type</h3>
                            <div class="space-y-3">
                                <button
                                    v-for="type in appointmentTypes"
                                    :key="type.id"
                                    @click="selectedType = type.id"
                                    :class="[
                                        'flex w-full items-start gap-3 rounded-xl p-4 text-left transition-all',
                                        selectedType === type.id
                                            ? 'border-2 border-[#14B8A6] bg-[#14B8A6]/10'
                                            : isDark
                                              ? 'border-2 border-transparent bg-[#334155] hover:border-[#475569]'
                                              : 'border-2 border-[#E5E7EB] bg-white hover:border-[#D1D5DB]',
                                    ]"
                                >
                                    <div v-html="type.icon" class="mt-0.5 flex-shrink-0"></div>
                                    <div class="flex-1">
                                        <h4 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-sm font-semibold">
                                            {{ type.name }}
                                        </h4>
                                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs">
                                            {{ type.description }}
                                        </p>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <div
                                            :class="[
                                                'flex h-5 w-5 items-center justify-center rounded-full border-2',
                                                selectedType === type.id
                                                    ? 'border-[#14B8A6] bg-[#14B8A6]'
                                                    : isDark
                                                      ? 'border-[#475569]'
                                                      : 'border-[#D1D5DB]',
                                            ]"
                                        >
                                            <svg
                                                v-if="selectedType === type.id"
                                                class="h-3 w-3 text-white"
                                                fill="none"
                                                stroke="currentColor"
                                                viewBox="0 0 24 24"
                                            >
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                                            </svg>
                                        </div>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="mt-6 flex items-center justify-between rounded-xl border p-6"
                >
                    <div>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="mb-1 text-xs uppercase">Appointment Summary</p>
                        <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold">
                            {{ appointmentSummary }}
                        </p>
                    </div>
                    <button
                        @click="handleConfirmAppointment"
                        :disabled="!selectedDay || !selectedSlot || !selectedType"
                        :class="[
                            'flex items-center gap-2 rounded-lg px-6 py-3 text-sm font-semibold transition-colors',
                            selectedDay && selectedSlot && selectedType
                                ? 'bg-[#14B8A6] text-white hover:bg-[#0F9B8E]'
                                : isDark
                                  ? 'cursor-not-allowed bg-[#334155] text-[#64748B]'
                                  : 'cursor-not-allowed bg-[#F3F4F6] text-[#9CA3AF]',
                        ]"
                    >
                        Confirm Appointment
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
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
