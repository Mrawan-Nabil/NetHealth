<script setup>
import { Head, router } from '@inertiajs/vue3';
import { computed, onMounted, reactive, ref } from 'vue';
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

const { state, setTheme } = useDashboard();
const sidebarOpen = ref(false);
const scheduleModalOpen = ref(false);
const saveMessage = ref('');

onMounted(() => setTheme(state.isDark ? 'dark' : 'light'));
const showCurrentPassword = ref(false);
const showNewPassword = ref(false);
const showConfirmPassword = ref(false);

const doctor = reactive({
    name: 'Dr Ahmed Yahia',
    fullName: 'Ahmed Yahia',
    handle: '@y7ia007',
    id: 'AF MED 240-0679',
    avatar: 'https://i.pravatar.cc/200?img=12',
});

const navItems = ref([
    { key: 'home', label: 'Home', icon: 'home' },
    { key: 'profile', label: 'Profile', icon: 'profile', active: true },
    { key: 'appointments', label: 'Appointments', icon: 'appointments' },
    { key: 'reviews', label: 'Reviews', icon: 'reviews' },
    { key: 'notification', label: 'Notification', icon: 'notification' },
    { key: 'logout', label: 'Logout', icon: 'logout' },
]);

const form = reactive({
    firstName: 'Ahmed',
    secondName: 'Yahia',
    email: 'ahmed.yahia@gmail.com',
    countryCode: '+20',
    phone: '01098548452',
    nationalId: '30001-0006-0789',
    dob: '1999-05-13',
    gender: 'male',
    address: '1234 Maple Avenue, Apt 35, New York, NY 10001',
    specialty: 'Senior Cardiology',
    experience: '4',
    consultationFee: '$150.00',
    clinicName: 'Serenity Heart Center',
    clinicAddress: '1234 Maple Avenue, Apt 38, New York, NY 10001',
    about: 'Dr. Ahmed Yahia is a globally recognized Chief of Surgery with over 12 years of specialized experience in minimally invasive procedures. Her patient-first philosophy and commitment to utilizing cutting-edge surgical robotics have consistently led to superior recovery outcomes.',
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
});

const initialForm = { ...form };

const schedule = ref({
    days: [
        { name: 'Monday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Tuesday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Wednesday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Thursday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Friday', enabled: true, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Saturday', enabled: false, from: '09:00 AM', to: '03:00 PM' },
        { name: 'Sunday', enabled: false, from: '09:00 AM', to: '03:00 PM' },
    ],
    duration: '30 min',
    breakBetweenSlots: '10 min',
    selectedPreset: null,
    appointmentTypes: {
        inClinic: true,
        followUp: true,
        labReview: true,
    },
    labReviewOptions: {
        acceptLabTests: true,
        acceptXrayImages: true,
    },
});

const activeDays = [
    { label: 'M', active: true },
    { label: 'T', active: true },
    { label: 'W', active: true },
    { label: 'T', active: true },
    { label: 'F', active: true },
    { label: 'S', active: false },
    { label: 'S', active: false },
];

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

const isDark = computed(() => state.isDark);
const toggleTheme = (value) => setTheme(value);

const setSaveMessage = (message) => {
    saveMessage.value = message;
    window.setTimeout(() => {
        if (saveMessage.value === message) saveMessage.value = '';
    }, 1800);
};

const handlePhotoChange = (file) => {
    doctor.avatar = URL.createObjectURL(file);
    setSaveMessage('Profile photo preview updated.');
};

const removePhoto = () => {
    doctor.avatar = `https://ui-avatars.com/api/?name=${encodeURIComponent(doctor.fullName)}&background=0D9488&color=fff&size=160`;
    setSaveMessage('Profile photo removed.');
};

const handleCancel = () => {
    Object.assign(form, initialForm);
    setSaveMessage('Changes reverted.');
};

const handleSave = () => {
    Object.assign(initialForm, form);
    setSaveMessage('Profile changes saved.');
};

const saveSchedule = (value) => {
    schedule.value = value;
    scheduleModalOpen.value = false;
    setSaveMessage('Schedule updated.');
};

const handleNav = (key) => {
    navItems.value = navItems.value.map((item) => ({ ...item, active: item.key === key }));
    sidebarOpen.value = false;

    if (key === 'home') {
        router.get('/doctor/dashboard');
        return;
    }
    if (key === 'profile') {
        router.get('/doctor/profile');
        return;
    }
    if (key === 'appointments') {
        router.get('/doctor/appointments');
        return;
    }
    if (key === 'reviews') {
        router.get('/doctor/reviews');
        return;
    }
    if (key === 'notification') {
        router.get('/doctor/notifications');
        return;
    }
    if (key === 'logout') {
        router.get('/logout');
    }
};

</script>

<template>
    <Head title="Doctor Profile Dashboard" />

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
                :doctor-name="doctor.fullName"
                :handle="doctor.handle"
                :avatar="doctor.avatar"
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
                <ProfilePictureCard :avatar="doctor.avatar" :name="doctor.name" :doctor-id="doctor.id" @change-photo="handlePhotoChange" @remove-photo="removePhoto" />

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
                        <BaseInput v-model="form.clinicName" label="Clinic Name" />
                        <div class="sm:col-span-2">
                            <BaseInput v-model="form.clinicAddress" label="Clinic Address" />
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
                                    <BaseInput model-value="09:00 AM" label="From" />
                                    <BaseInput model-value="03:00 PM" label="To" />
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
                        <BaseInput
                            v-model="form.currentPassword"
                            label="Current Password"
                            :type="showCurrentPassword ? 'text' : 'password'"
                            :icon="showCurrentPassword ? 'eye-off' : 'eye'"
                            placeholder="Create a current password"
                            @icon-click="showCurrentPassword = !showCurrentPassword"
                        />
                        <BaseInput
                            v-model="form.newPassword"
                            label="New Password"
                            :type="showNewPassword ? 'text' : 'password'"
                            :icon="showNewPassword ? 'eye-off' : 'eye'"
                            placeholder="Create a new password"
                            @icon-click="showNewPassword = !showNewPassword"
                        />
                        <BaseInput
                            v-model="form.confirmPassword"
                            label="Confirm New Password"
                            :type="showConfirmPassword ? 'text' : 'password'"
                            :icon="showConfirmPassword ? 'eye-off' : 'eye'"
                            placeholder="Confirm new password"
                            @icon-click="showConfirmPassword = !showConfirmPassword"
                        />
                    </div>
                </FormSectionCard>

                <div class="flex flex-col gap-3 border-t border-[#E5E7EB] pt-4 sm:flex-row sm:items-center sm:justify-between dark:border-[#334155]">
                    <p class="min-h-5 text-xs font-medium text-[#14B8A6] dark:text-[#2DD4BF]">{{ saveMessage }}</p>
                    <div class="flex justify-end gap-2">
                        <BaseButton variant="secondary" @click="handleCancel">Cancel</BaseButton>
                        <BaseButton variant="primary" @click="handleSave">Save Changes</BaseButton>
                    </div>
                </div>
                </div>
            </main>
        </div>

        <EditScheduleModal :open="scheduleModalOpen" :schedule="schedule" @close="scheduleModalOpen = false" @save="saveSchedule" />
    </div>
</template>
