<script setup>
import { Head, router, useForm } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import AppSidebar from '@/components/doctor-ui/AppSidebar.vue';
import EditScheduleModal from '@/components/doctor-dashboard/EditScheduleModal.vue';
import BaseButton from '@/components/doctor-profile/BaseButton.vue';
import BaseInput from '@/components/doctor-profile/BaseInput.vue';
import BaseSelect from '@/components/doctor-profile/BaseSelect.vue';
import FormSectionCard from '@/components/doctor-profile/FormSectionCard.vue';
import DayPill from '@/components/doctor-profile/DayPill.vue';
import InfoMiniCard from '@/components/doctor-profile/InfoMiniCard.vue';
import ProfilePictureCard from '@/components/doctor-profile/ProfilePictureCard.vue';
import TopHeader from '@/components/doctor-ui/TopHeader.vue';
import { useDashboard } from '@/composables/useDashboard';

// ─── Props (Inertia Data Contract) ───────────────────────────────────────────
const props = defineProps({
    doctor: { type: Object, required: true },
    schedule: { type: Object, required: false, default: () => ({
        days: [],
        duration: '30 min',
        breakBetweenSlots: '5 min',
        selectedPreset: null,
        appointmentTypes: { inClinic: true, followUp: true, labReview: true },
        labReviewOptions: { acceptLabTests: true, acceptXrayImages: true },
    }) },
});

// ─── State ───────────────────────────────────────────────────────────────────
const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const scheduleModalOpen = ref(false);
const localAvatar = ref(props.doctor.avatar ?? '');

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile', active: true },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

// ─── Inertia useForm (Rule 3) ─────────────────────────────────────────────────
const form = useForm({
    firstName: props.doctor.firstName,
    secondName: props.doctor.secondName,
    email: props.doctor.email,
    countryCode: '+20',
    phone: props.doctor.phone,
    nationalId: props.doctor.nationalId,
    dob: props.doctor.dob,
    gender: props.doctor.gender,
    address: props.doctor.address,
    specialty: props.doctor.specialty,
    experience: props.doctor.experience,
    consultationFee: props.doctor.consultationFee,
    about: props.doctor.about,
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
});

const localSchedule = ref(props.schedule);

// ─── Derived display values ───────────────────────────────────────────────────
const activeDays = computed(() =>
    (localSchedule.value.days ?? []).map((day) => ({
        label: day.name.charAt(0),
        active: day.enabled,
    })),
);

const genderOptions = [
    { label: 'Male', value: 'male' },
    { label: 'Female', value: 'female' },
    { label: 'Prefer not to say', value: 'na' },
];
const countryOptions = [
    { label: '+20', value: '+20' },
    { label: '+1', value: '+1' },
    { label: '+44', value: '+44' },
];

// ─── Computed ─────────────────────────────────────────────────────────────────
const isDark = computed(() => state.isDark);
const toggleTheme = (value) => setTheme(value);

// ─── Handlers ────────────────────────────────────────────────────────────────
const handlePhotoChange = (file) => {
    localAvatar.value = URL.createObjectURL(file);
};

const removePhoto = () => {
    localAvatar.value = `https://ui-avatars.com/api/?name=${encodeURIComponent(props.doctor.fullName)}&background=0D9488&color=fff&size=160`;
};

// Rule 3: use form.reset() to revert
const handleCancel = () => {
    form.reset();
};

// Rule 3: use form.patch() to submit to the Laravel backend
const handleSave = () => {
    form.patch('/doctor/profile');
};

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
    <Head title="Doctor Profile" />

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
                title="Profile"
                :doctor-name="props.doctor.fullName"
                :handle="props.doctor.handle"
                :avatar="localAvatar"
                :is-dark="isDark"
                @toggle-sidebar="sidebarOpen = true"
            />

            <main class="p-4 sm:p-6 lg:p-7 animate-fadeInUp">
                <div class="mb-6">
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mb-1.5 text-xs font-medium">
                        Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Profile Settings</span>
                    </p>
                    <h1 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="mb-1 text-2xl font-bold tracking-tight">Profile Settings</h1>
                    <p :class="isDark ? 'text-[#64748B]' : 'text-[#9CA3AF]'" class="text-sm">Manage your professional information and account settings.</p>
                </div>

                <div class="max-w-3xl space-y-5">
                    <ProfilePictureCard
                        :avatar="localAvatar"
                        :name="props.doctor.name"
                        :doctor-id="String(props.doctor.id)"
                        @change-photo="handlePhotoChange"
                        @remove-photo="removePhoto"
                    />

                    <FormSectionCard title="Personal Information" subtitle="Your basic details and contact information">
                        <div class="grid gap-4 sm:grid-cols-2">
                            <BaseInput v-model="form.firstName" label="First Name" />
                            <BaseInput v-model="form.secondName" label="Second Name" />
                            <BaseInput v-model="form.email" label="Email Address" type="email" />
                            <label class="block space-y-1.5">
                                <span class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">Phone Number</span>
                                <div class="grid grid-cols-[96px_1fr] gap-2">
                                    <BaseSelect v-model="form.countryCode" :options="countryOptions" placeholder="+20" />
                                    <BaseInput v-model="form.phone" />
                                </div>
                            </label>
                            <BaseInput v-model="form.nationalId" label="National ID" />
                            <BaseInput v-model="form.dob" label="Date of Birth" type="date" />
                            <BaseSelect v-model="form.gender" label="Gender" :options="genderOptions" />
                            <div class="sm:col-span-2">
                                <BaseInput v-model="form.address" label="Address" />
                            </div>
                        </div>
                    </FormSectionCard>

                    <FormSectionCard title="Professional Information" subtitle="Your professional details and clinic info">
                        <div class="grid gap-4 sm:grid-cols-2">
                            <BaseInput v-model="form.specialty" label="Medical Specialty" />
                            <div class="grid grid-cols-2 gap-3">
                                <BaseInput v-model="form.experience" label="Experience (Years)" />
                                <BaseInput v-model="form.consultationFee" label="Consultation Fee" />
                            </div>
                            <!-- Clinic comes from backend relationship — read-only display -->
                            <BaseInput :model-value="props.doctor.clinic?.name ?? 'No clinic assigned'" label="Clinic Name" :disabled="true" />
                            <div class="sm:col-span-2">
                                <BaseInput :model-value="props.doctor.clinic?.address ?? ''" label="Clinic Address" :disabled="true" />
                            </div>
                        </div>
                    </FormSectionCard>

                    <section class="grid gap-4 xl:grid-cols-12">
                        <FormSectionCard title="About & Experience" class="xl:col-span-7">
                            <p class="text-sm leading-6 text-[#64748B] dark:text-[#94A3B8]">
                                {{ form.about }}
                            </p>
                            <div class="mt-4 grid gap-3 sm:grid-cols-2">
                                <InfoMiniCard title="Education" subtitle="2009 M University School of Medicine" icon="education" />
                                <InfoMiniCard title="Board Certification" subtitle="American Board of Surgeons Certified Specialist" icon="certification" />
                            </div>
                        </FormSectionCard>

                        <FormSectionCard title="Working Schedule" class="xl:col-span-5">
                            <template #default>
                                <div class="space-y-4">
                                    <div class="flex items-center justify-between">
                                        <p class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">Available Days</p>
                                        <button
                                            type="button"
                                            class="text-xs font-semibold text-[#14B8A6] transition-colors duration-200 hover:text-[#0D9488] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-[#2DD4BF]"
                                            @click="scheduleModalOpen = true"
                                        >
                                            Edit Schedule
                                        </button>
                                    </div>
                                    <div class="flex flex-wrap gap-2">
                                        <DayPill v-for="(day, index) in activeDays" :key="`${day.label}-${index}`" :label="day.label" :active="day.active" />
                                    </div>
                                    <div class="grid grid-cols-2 gap-2">
                                        <BaseInput :model-value="localSchedule.days?.find(d => d.enabled)?.from ?? '09:00 AM'" label="From" />
                                        <BaseInput :model-value="localSchedule.days?.find(d => d.enabled)?.to ?? '05:00 PM'" label="To" />
                                    </div>
                                    <div class="rounded-xl border border-teal-200 bg-[#F0FDFA] px-3 py-2 dark:border-teal-500/20 dark:bg-teal-500/8">
                                        <InfoMiniCard title="Standard Availability" subtitle="This is a weekly visible support schedule for your patients." icon="availability" />
                                    </div>
                                </div>
                            </template>
                        </FormSectionCard>
                    </section>

                    <FormSectionCard title="Change Password" subtitle="Keep your account safe with a strong password">
                        <div class="grid gap-4 md:grid-cols-3">
                            <BaseInput v-model="form.currentPassword" label="Current Password" type="password" placeholder="Enter current password" />
                            <BaseInput v-model="form.newPassword" label="New Password" type="password" placeholder="Create a new password" />
                            <BaseInput v-model="form.confirmPassword" label="Confirm New Password" type="password" placeholder="Confirm new password" />
                        </div>
                    </FormSectionCard>

                    <!-- Inertia form status feedback -->
                    <div class="flex flex-col gap-3 border-t border-[#E5E7EB] pt-4 sm:flex-row sm:items-center sm:justify-between dark:border-[#334155]">
                        <p class="min-h-5 text-xs font-medium text-[#14B8A6] dark:text-[#2DD4BF]">
                            <span v-if="form.wasSuccessful">Profile saved successfully.</span>
                            <span v-else-if="form.hasErrors" class="text-red-500">Please fix the errors above.</span>
                        </p>
                        <div class="flex justify-end gap-2">
                            <BaseButton variant="secondary" :disabled="form.processing" @click="handleCancel">Cancel</BaseButton>
                            <BaseButton variant="primary" :disabled="form.processing" @click="handleSave">
                                {{ form.processing ? 'Saving...' : 'Save Changes' }}
                            </BaseButton>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <EditScheduleModal :open="scheduleModalOpen" :schedule="localSchedule" @close="scheduleModalOpen = false" @save="saveSchedule" />
    </div>
</template>
