<script setup>
import { router, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import DoctorCard from '@/components/appointments/DoctorCard.vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import { useDashboard } from '@/composables/useDashboard';

const { state, setTheme } = useDashboard();

const props = defineProps({
    doctors:     { type: Array, required: true, default: () => [] },
    specialties: { type: Array, required: true, default: () => [] },
});

const isDark            = computed(() => state.isDark);
const searchQuery       = ref('');
const selectedSpecialty = ref('all');

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

const toggleTheme  = (theme) => setTheme(theme);
const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const handleBookDoctor = (doctor) => {
    router.get(`/doctor/${doctor.id}`);
};
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Book Appointment"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <main class="p-7 animate-fadeInUp">
                <!-- Breadcrumb -->
                <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-6 text-xs font-medium">
                    Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <Link href="/appointments" class="transition-colors hover:text-[#14B8A6]">Appointments</Link>
                    <span class="mx-1.5 text-[#D1D5DB]">/</span>
                    <span :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="font-semibold">Book New</span>
                </p>

                <!-- Page Header -->
                <div class="mb-8">
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Book a New Appointment</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#94A3B8]'" class="text-sm">
                        Find and schedule with top-rated medical specialists in your area.
                    </p>
                </div>

                <!-- Search Section -->
                <div
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="mb-8 rounded-2xl border p-4"
                    style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                >
                    <div class="flex flex-col sm:flex-row items-center gap-3">
                        <div class="relative flex-1 w-full">
                            <svg class="absolute top-1/2 left-4 h-5 w-5 -translate-y-1/2 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                            <input
                                v-model="searchQuery"
                                type="text"
                                placeholder="Search doctors by name, hospital, or keywords..."
                                :class="isDark
                                    ? 'border-[#334155] bg-[#0F172A] text-[#F1F5F9] placeholder-[#475569] focus:border-[#14B8A6]'
                                    : 'border-[#E5E7EB] bg-white text-[#0F172A] placeholder-[#9CA3AF] focus:border-[#14B8A6]'"
                                class="w-full rounded-xl border py-3 pr-4 pl-12 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"
                            />
                        </div>
                        <button class="btn-primary w-full sm:w-auto px-6 py-3 shrink-0 whitespace-nowrap">
                            Find Specialist
                        </button>
                    </div>
                </div>

                <!-- Specialties Section -->
                <div class="mb-8">
                    <h2 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-4 text-sm font-semibold">Specialties</h2>
                    <div class="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-hide">
                        <button
                            v-for="specialty in specialties"
                            :key="specialty.id"
                            @click="selectedSpecialty = specialty.id"
                            :class="[
                                'flex items-center gap-2 rounded-xl px-4 py-2 text-sm font-semibold whitespace-nowrap transition-all duration-200',
                                selectedSpecialty === specialty.id
                                    ? 'bg-[#14B8A6] text-white shadow-md shadow-teal-500/25'
                                    : isDark
                                      ? 'border border-[#334155] bg-[#0F172A] text-[#94A3B8] hover:bg-[#334155]/60 hover:text-[#F1F5F9]'
                                      : 'border border-[#E5E7EB] bg-white text-[#64748B] hover:bg-[#F8FAFC] hover:text-[#0F172A]',
                            ]"
                        >
                            <div v-html="specialty.icon" class="h-4 w-4"></div>
                            {{ specialty.name }}
                        </button>
                    </div>
                </div>

                <!-- Doctors Grid -->
                <div v-if="filteredDoctors.length > 0" class="grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3">
                    <div v-for="doctor in filteredDoctors" :key="doctor.id">
                        <DoctorCard :doctor="doctor" :is-dark="isDark" @book="handleBookDoctor" />
                    </div>
                </div>

                <!-- Empty State -->
                <div
                    v-else
                    :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
                    class="rounded-2xl border p-16 text-center"
                    style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                >
                    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl">
                        <svg :class="isDark ? 'text-[#334155]' : 'text-[#CBD5E1]'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                    <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-2 text-base font-semibold">No doctors found</h3>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="text-sm">Try adjusting your search or specialty filter</p>
                </div>
            </main>
        </div>
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
