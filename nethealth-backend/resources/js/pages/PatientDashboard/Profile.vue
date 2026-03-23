<script setup>
import { router, useForm } from '@inertiajs/vue3';
import { ref, computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import { useDashboard } from '@/composables/useDashboard';

const props = defineProps({
    profileData: {
        type: Object,
        required: true,
        default: () => ({
            firstName: '',
            secondName: '',
            email: '',
            phone: '',
            nationalId: '',
            dateOfBirth: '',
            gender: 'Male',
            address: '',
            avatar: '',
        }),
    },
    emergencyContact: {
        type: Object,
        required: true,
        default: () => ({
            name: '',
            relationship: '',
            phone: '',
        }),
    },
});

const { state, setTheme } = useDashboard();
const isDark = computed(() => state.isDark);

const form = useForm({
    first_name: props.profileData?.first_name || '',
    last_name: props.profileData?.last_name || '',
    email: props.profileData?.email || '',
    phone: props.profileData?.phone || '',
    national_id: props.profileData?.national_id || '',
    date_of_birth: props.profileData?.date_of_birth || '',
    gender: props.profileData?.gender || 'Male',
    governorate: props.profileData?.governorate || '',

    emergency_contact_name: props.emergencyContact?.name || '',
    emergency_contact_relationship: props.emergencyContact?.relationship || '',
    emergency_contact_phone: props.emergencyContact?.phone || '',

    current_password: '',
    password: '',
    password_confirmation: '',
});

const showPassword = ref({
    current: false,
    new: false,
    confirm: false,
});

const toggleTheme = (theme) => {
    setTheme(theme);
};

const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
        localStorage.removeItem('authToken');
        router.get('/logout');
    }
};

const submitForm = () => {
    form.patch('/profile/update', {
        preserveScroll: true,
        onSuccess: () => {
            alert('Profile updated successfully!');
            form.reset('current_password', 'password', 'password_confirmation');
        },
    });
};

// --- NEW AVATAR LOGIC START ---

// 1. Reference to the hidden file input
const fileInput = ref(null);

// 2. Computed property to handle the avatar URL cleanly (adds /storage/ prefix)
const getAvatarUrl = computed(() => {
    if (props.profileData?.avatar) {
        // If it already has an HTTP link (like from Google login), use it directly
        if (props.profileData.avatar.startsWith('http')) {
            return props.profileData.avatar;
        }
        // Otherwise, prepend the storage path
        return `/storage/${props.profileData.avatar}`;
    }
    // Fallback UI Avatar
    return `https://ui-avatars.com/api/?name=${form.first_name || 'User'}&background=0D9488&color=fff`;
});

// 3. Handle the file selection and upload it immediately
const uploadAvatar = (event) => {
    const file = event.target.files[0];
    if (!file) return;

    // Post to the route we created in step 2
    router.post('/profile/avatar', {
        avatar: file
    }, {
        preserveScroll: true,
        forceFormData: true, // Required for file uploads in Inertia
        onSuccess: () => {
            // Optional success notification
            // Reset the file input so the same file can be selected again if needed
            if (fileInput.value) fileInput.value.value = '';
        },
        onError: (errors) => {
            alert(errors.avatar || 'Failed to upload image.');
        }
    });
};
// --- NEW AVATAR LOGIC END ---

onMounted(() => {
    // Profile page mounted
});
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Profile"
                :is-dark="isDark"
                :user="{
                    name: form.first_name ? `${form.first_name} ${form.last_name}` : 'User',
                    username: form.email || '@user',
                    avatar: getAvatarUrl, }"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <form @submit.prevent="submitForm" class="p-6">
                <div class="mb-6">
                    <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-2xl font-bold">Profile</h1>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">Upload your personal information and account settings</p>
                </div>

                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="card-interactive animate-fade-in-up mb-6 rounded-xl border p-6 transition-all duration-300 hover:-translate-y-1 hover:shadow-lg"
                >
                    <div class="flex flex-col items-start gap-4 sm:flex-row">
                        <div class="animate-slide-up flex-1">
                            <h3
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-1 text-base font-semibold transition-colors duration-300"
                            >
                                Profile Picture
                            </h3>
                            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-4 text-sm transition-colors duration-300">
                                JPG/PNG/GIF. Max size 10MB</p>

                            <div class="flex flex-wrap items-center gap-4">
                                <img
                                    :src="getAvatarUrl"
                                    alt="Profile"
                                    class="animate-scale-in h-16 w-16 rounded-full object-cover transition-transform duration-300 hover:scale-110"
                                />
                                <div class="animate-slide-left stagger-1">
                                    <p
                                        :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                        class="mb-1 text-sm font-semibold transition-colors duration-300"
                                    >
                                        {{ form.first_name }} {{ form.last_name }}
                                    </p>
                                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-3 text-xs transition-colors duration-300">
                                        Patient_ID: {{ profileData?.id || 'ID not assigned' }}
                                    </p>
                                    <div class="flex flex-wrap items-center gap-2">

                                        <input
                                            type="file"
                                            ref="fileInput"
                                            class="hidden"
                                            @change="uploadAvatar"
                                            accept="image/jpeg,image/png,image/jpg,image/webp"
                                        />

                                        <button
                                            type="button"
                                            @click="$refs.fileInput.click()"
                                            :class="
                                                isDark
                                                    ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]'
                                                    : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'
                                            "
                                            class="btn-ripple flex items-center gap-1.5 rounded-lg border px-4 py-1.5 text-sm font-medium transition-all duration-300 hover:scale-105"
                                        >
                                            Change Photo
                                        </button>

                                        <button
                                            type="button"
                                            class="btn-ripple flex items-center gap-1.5 rounded-lg border border-[#FCA5A5] px-4 py-1.5 text-sm font-medium text-[#DC2626] transition-all duration-300 hover:scale-105 hover:bg-[#FEE2E2]"
                                        >
                                            Remove Photo
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="card-interactive animate-fade-in-up stagger-1 mb-6 rounded-xl border p-6 transition-all duration-300 hover:-translate-y-1 hover:shadow-lg"
                >
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-lg font-semibold transition-colors duration-300">
                        Personal Information
                    </h3>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-6 text-sm transition-colors duration-300">
                        Your basic details and contact info
                    </p>

                    <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                        <div class="animate-slide-up stagger-1">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                First Name
                            </label>
                            <input
                                v-model="form.first_name"
                                type="text"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>

                        <div class="animate-slide-up stagger-2">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                Second Name
                            </label>
                            <input
                                v-model="form.last_name"
                                type="text"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>

                        <div class="animate-slide-up stagger-3">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                Email Address
                            </label>
                            <input
                                v-model="form.email"
                                type="email"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>

                        <div class="animate-slide-up stagger-4">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                Phone Number
                            </label>
                            <div class="flex gap-2">
                                <select
                                    :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                    class="rounded-lg border px-3 py-2 text-sm transition-all duration-300 focus:ring-[#14B8A6] focus:outline-none"
                                >
                                    <option>🇪🇬 +20</option>
                                </select>
                                <input
                                    v-model="form.phone"
                                    type="tel"
                                    :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                    class="flex-1 rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                                />
                            </div>
                        </div>

                        <div class="animate-slide-up stagger-5">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                National ID
                            </label>
                            <input
                                v-model="form.national_id"
                                type="text"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>

                        <div class="animate-slide-up stagger-1">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                Date of Birth
                            </label>
                            <input
                                v-model="form.date_of_birth"
                                type="date"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>

                        <div class="animate-slide-up stagger-2">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                Gender
                            </label>
                            <select
                                v-model="form.gender"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            >
                                <option>Male</option>
                                <option>Female</option>
                            </select>
                        </div>

                        <div class="animate-slide-up stagger-3 col-span-1 md:col-span-2">
                            <label
                                :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                                class="mb-2 block text-sm font-medium transition-colors duration-300"
                            >
                                Address
                            </label>
                            <input
                                v-model="form.governorate"
                                type="text"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-all duration-300 hover:border-[#14B8A6] focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>
                    </div>
                </div>

                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="mb-6 rounded-xl border p-6 transition-all duration-300"
                >
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-lg font-semibold">Emergency Contact</h3>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-6 text-sm">Who should we contact in an emergency?</p>

                    <div class="mb-4 grid grid-cols-1 gap-4 md:grid-cols-2">
                        <div>
                            <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 block text-sm font-medium"> Contact Name </label>
                            <input
                                v-model="form.emergency_contact_name"
                                type="text"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            />
                        </div>

                        <div>
                            <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 block text-sm font-medium"> Relationship </label>
                            <select
                                v-model="form.emergency_contact_relationship"
                                :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                class="w-full rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                            >
                                <option>Parent</option>
                                <option>Spouse</option>
                                <option>Sibling</option>
                                <option>Friend</option>
                            </select>
                        </div>

                        <div class="col-span-1 md:col-span-2">
                            <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 block text-sm font-medium"> Phone Number </label>
                            <div class="flex gap-2">
                                <select
                                    :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                    class="rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                                >
                                    <option>🇪🇬 +20</option>
                                </select>
                                <input
                                    v-model="form.emergency_contact_phone"
                                    type="tel"
                                    :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                    class="flex-1 rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                                />
                            </div>
                        </div>
                    </div>

                    <div class="rounded-lg bg-[#CCFBF1] px-4 py-2.5 text-xs text-[#0F766E]">
                        This information is only shared with healthcare providers in case of emergency.
                    </div>
                </div>

                <div
                    :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
                    class="mb-6 rounded-xl border p-6 transition-all duration-300"
                >
                    <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-lg font-semibold">Change Password</h3>
                    <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-6 text-sm">Keep your account safe with a strong password</p>

                    <div class="space-y-4">
                        <div>
                            <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 block text-sm font-medium">
                                Current Password
                            </label>
                            <div class="relative">
                                <input
                                    v-model="form.current_password"
                                    :type="showPassword.current ? 'text' : 'password'"
                                    placeholder="Enter current password"
                                    :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                    class="w-full rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                                />
                                <button
                                    type="button"
                                    @click="showPassword.current = !showPassword.current"
                                    class="absolute top-1/2 right-3 -translate-y-1/2"
                                >
                                    <span class="text-xs text-[#14B8A6] hover:underline">{{ showPassword.current ? 'Hide' : 'Show' }}</span>
                                </button>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                            <div>
                                <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 block text-sm font-medium">
                                    New Password
                                </label>
                                <div class="relative">
                                    <input
                                        v-model="form.password"
                                        :type="showPassword.new ? 'text' : 'password'"
                                        placeholder="Create a new password"
                                        :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                        class="w-full rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                                    />
                                    <button
                                        type="button"
                                        @click="showPassword.new = !showPassword.new"
                                        class="absolute top-1/2 right-3 -translate-y-1/2"
                                    >
                                        <span class="text-xs text-[#14B8A6] hover:underline">{{ showPassword.new ? 'Hide' : 'Show' }}</span>
                                    </button>
                                </div>
                            </div>

                            <div>
                                <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-2 block text-sm font-medium">
                                    Confirm New Password
                                </label>
                                <div class="relative">
                                    <input
                                        v-model="form.password_confirmation"
                                        :type="showPassword.confirm ? 'text' : 'password'"
                                        placeholder="Confirm your password"
                                        :class="isDark ? 'border-[#334155] bg-[#0F172A] text-[#F8FAFC]' : 'border-[#D1D5DB] bg-white text-[#111827]'"
                                        class="w-full rounded-lg border px-3 py-2 text-sm transition-colors focus:ring-2 focus:ring-[#14B8A6] focus:outline-none"
                                    />
                                    <button
                                        type="button"
                                        @click="showPassword.confirm = !showPassword.confirm"
                                        class="absolute top-1/2 right-3 -translate-y-1/2"
                                    >
                                        <span class="text-xs text-[#14B8A6] hover:underline">{{ showPassword.confirm ? 'Hide' : 'Show' }}</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex justify-end gap-3">
                    <button
                        type="button"
                        :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'"
                        class="rounded-lg border px-6 py-2.5 text-sm font-semibold transition-colors"
                    >
                        Cancel
                    </button>
                    <button
                        type="submit"
                        :disabled="form.processing"
                        class="rounded-lg bg-[#14B8A6] px-6 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-[#0D9488] disabled:opacity-50"
                    >
                        {{ form.processing ? 'Saving...' : 'Save changes' }}
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>
