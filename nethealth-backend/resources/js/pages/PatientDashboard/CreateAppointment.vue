<script setup>
import { router } from '@inertiajs/vue3';
import { ref, computed, onMounted } from 'vue';
import DoctorCard from '@/components/appointments/DoctorCard.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';

// LARAVEL DATA BINDING: Expects Array doctors, Array specialties
const props = defineProps({
    doctors: {
        type: Array,
        required: true,
        default: () => [],
    },
    specialties: {
        type: Array,
        required: true,
        default: () => [],
    },
    auth: {
        type: Object,
        default: () => ({ user: null }),
    },
});

// State
const isDark = ref(false);
const searchQuery = ref('');
const selectedSpecialty = ref('all');

// Computed
const filteredDoctors = computed(() => {
    let filtered = props.doctors;

    if (selectedSpecialty.value !== 'all') {
        filtered = filtered.filter((d) => d.specialtyId === selectedSpecialty.value);
    }

    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        filtered = filtered.filter(
            (d) => d.name.toLowerCase().includes(query) || d.specialty.toLowerCase().includes(query) || d.hospital.toLowerCase().includes(query),
        );
    }

    return filtered;
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

const handleBookDoctor = (doctor) => {
    console.log('Book doctor:', doctor);
    router.get(`/doctor/${doctor.id}`);
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
            <main class="p-8">
                <!-- Page Header -->
                <div class="mb-8">
                    <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 text-3xl font-bold">Book a New Appointment</h1>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-base leading-relaxed">
                        Find and schedule with top-rated medical specialists in your area.
                    </p>
                </div>

                <!-- Search Section -->
                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="mb-8 rounded-xl border p-6 shadow-sm transition-all duration-300 hover:shadow-md"
                >
                    <div class="flex items-center gap-4">
                        <div class="relative flex-1">
                            <svg
                                class="absolute top-1/2 left-4 h-5 w-5 -translate-y-1/2 transform"
                                :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                                />
                            </svg>
                            <input
                                v-model="searchQuery"
                                type="text"
                                placeholder="Search doctors by name, hospital, or keywords..."
                                :class="[
                                    'w-full rounded-lg border py-3 pr-4 pl-12 transition-all duration-200 focus:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6]/20 focus:outline-none',
                                    isDark
                                        ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC] placeholder-[#94A3B8]'
                                        : 'border-[#E5E7EB] bg-[#F8FAFC] text-[#111827] placeholder-[#9CA3AF]',
                                ]"
                            />
                        </div>
                        <button
                            class="rounded-lg bg-[#14B8A6] px-6 py-3 font-medium text-white transition-all duration-200 hover:bg-[#0F9B8E] hover:shadow-lg hover:shadow-[#14B8A6]/25 active:scale-[0.98]"
                        >
                            Find Specialist
                        </button>
                    </div>
                </div>

                <!-- Specialties Section -->
                <div class="mb-8">
                    <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-6 text-xl font-semibold">Specialties</h2>
                    <div class="flex items-center gap-3 overflow-x-auto pb-2">
                        <button
                            v-for="specialty in specialties"
                            :key="specialty.id"
                            @click="selectedSpecialty = specialty.id"
                            :class="[
                                'flex items-center gap-2 rounded-lg px-4 py-2.5 font-medium whitespace-nowrap transition-all duration-200 hover:scale-[1.02] active:scale-[0.98]',
                                selectedSpecialty === specialty.id
                                    ? 'bg-[#14B8A6] text-white shadow-lg shadow-[#14B8A6]/25'
                                    : isDark
                                      ? 'border border-[#14B8A6] bg-[#1E293B] text-[#14B8A6] hover:bg-[#14B8A6]/10 hover:shadow-sm'
                                      : 'border border-[#14B8A6] bg-white text-[#14B8A6] hover:bg-[#14B8A6]/5 hover:shadow-sm',
                            ]"
                        >
                            <div v-html="specialty.icon" class="h-4 w-4"></div>
                            {{ specialty.name }}
                        </button>
                    </div>
                </div>

                <!-- Doctors Grid -->
                <div v-if="filteredDoctors.length > 0" class="grid grid-cols-1 gap-6 md:grid-cols-2">
                    <div v-for="doctor in filteredDoctors" :key="doctor.id">
                        <DoctorCard :doctor="doctor" :is-dark="isDark" @book="handleBookDoctor" />
                    </div>
                </div>

                <!-- Empty State -->
                <div v-else class="py-16 text-center">
                    <div
                        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                        class="mx-auto max-w-md rounded-xl border p-8 shadow-sm"
                    >
                        <div
                            :class="isDark ? 'bg-[#0F172A]' : 'bg-gray-50'"
                            class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full"
                        >
                            <svg
                                :class="isDark ? 'text-[#475569]' : 'text-gray-400'"
                                class="h-8 w-8"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                                />
                            </svg>
                        </div>
                        <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 text-lg font-semibold">No doctors found</h3>
                        <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm leading-relaxed">
                            Try adjusting your search or specialty filter
                        </p>
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>
