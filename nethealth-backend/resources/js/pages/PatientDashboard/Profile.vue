<script setup>
import { router, useForm } from '@inertiajs/vue3';
import { ref, computed, onMounted } from 'vue';
import Sidebar from '@/components/dashboard/Sidebar.vue';
import TopNavbar from '@/components/dashboard/TopNavbar.vue';
import { useDashboard } from '@/composables/useDashboard';

const props = defineProps({
    profileData: {
        type: Object, required: true,
        default: () => ({ firstName:'', secondName:'', email:'', phone:'', nationalId:'', dateOfBirth:'', gender:'Male', address:'', avatar:'' }),
    },
    emergencyContact: {
        type: Object, required: true,
        default: () => ({ name:'', relationship:'', phone:'' }),
    },
});

const { state, setTheme } = useDashboard();
const isDark = computed(() => state.isDark);

const form = useForm({
    first_name:   props.profileData?.first_name   || '',
    last_name:    props.profileData?.last_name    || '',
    email:        props.profileData?.email        || '',
    phone:        props.profileData?.phone        || '',
    national_id:  props.profileData?.national_id  || '',
    birth_date:props.profileData?.birth_date|| '',
    gender:       props.profileData?.gender       || 'Male',
    governorate:  props.profileData?.governorate  || '',
    emergency_contact_name:         props.emergencyContact?.name         || '',
    emergency_contact_relationship: props.emergencyContact?.relationship  || '',
    emergency_contact_phone:        props.emergencyContact?.phone         || '',
    current_password:    '',
    password:            '',
    password_confirmation:'',
});

const showPassword = ref({ current: false, new: false, confirm: false });
const fileInput    = ref(null);

const toggleTheme  = (theme) => setTheme(theme);
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
        onError: (errors) => {
            const firstError = Object.values(errors)[0];
            if (firstError) alert(Array.isArray(firstError) ? firstError[0] : firstError);
        },
    });
};

const getAvatarUrl = computed(() => {
    if (props.profileData?.avatar) {
        if (props.profileData.avatar.startsWith('http')) return props.profileData.avatar;
        return `/storage/${props.profileData.avatar}`;
    }
    return `https://ui-avatars.com/api/?name=${encodeURIComponent((form.first_name || 'U') + ' ' + (form.last_name || ''))}&background=0D9488&color=fff&size=200`;
});

const uploadAvatar = (event) => {
    const file = event.target.files[0];
    if (!file) return;
    router.post('/profile/avatar', { avatar: file }, {
        preserveScroll: true,
        forceFormData: true,
        onSuccess: () => { if (fileInput.value) fileInput.value.value = ''; },
        onError: (errors) => alert(errors.avatar || 'Failed to upload image.'),
    });
};

const removeAvatar = () => {
    if (!props.profileData?.avatar) return;
    if (!confirm('Remove your profile photo?')) return;

    router.delete('/profile/avatar', {
        preserveScroll: true,
    });
};

/* ── Section card helper classes ── */
const cardClass = computed(() =>
    isDark.value
        ? 'border-[#1E293B] bg-[#1E293B]'
        : 'border-[#F1F5F9] bg-white'
);

const inputClass = computed(() =>
    isDark.value
        ? 'border-[#334155] bg-[#0F172A] text-[#F1F5F9] placeholder-[#475569] focus:border-[#14B8A6]'
        : 'border-[#E5E7EB] bg-white text-[#0F172A] placeholder-[#9CA3AF] focus:border-[#14B8A6]'
);

const labelClass = computed(() => isDark.value ? 'text-[#94A3B8]' : 'text-[#374151]');
const headingClass = computed(() => isDark.value ? 'text-[#F1F5F9]' : 'text-[#0F172A]');
const subheadingClass = computed(() => isDark.value ? 'text-[#64748B]' : 'text-[#9CA3AF]');
</script>

<template>
    <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
        <Sidebar :is-dark="isDark" @toggle-theme="toggleTheme" @logout="handleLogout" />

        <div class="ml-64">
            <TopNavbar
                title="Profile"
                :is-dark="isDark"
                :notifications="[]"
                :show-last-viewed="false"
                :show-share="false"
                @logout="handleLogout"
            />

            <form @submit.prevent="submitForm" class="p-7 animate-fadeInUp">

                <!-- Page header -->
                <div class="mb-7">
                    <p :class="subheadingClass" class="mb-2 text-xs font-medium">
                        Dashboard <span class="mx-1.5 text-[#D1D5DB]">/</span>
                        <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#64748B]'">Profile Settings</span>
                    </p>
                    <h1 :class="headingClass" class="mb-1 text-2xl font-bold tracking-tight">Profile Settings</h1>
                    <p :class="subheadingClass" class="text-sm">Manage your personal information and account settings.</p>
                </div>

                <div class="max-w-3xl space-y-6">

                    <!-- ── Avatar card ── -->
                    <section
                        :class="cardClass"
                        class="rounded-2xl border p-6"
                        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                    >
                        <div class="mb-1 flex items-center gap-2">
                            <h3 :class="headingClass" class="text-sm font-semibold">Profile Picture</h3>
                        </div>
                        <p :class="subheadingClass" class="mb-5 text-xs">JPG, PNG or WebP. Maximum size 10 MB.</p>

                        <div class="flex flex-wrap items-center gap-5">
                            <!-- Avatar -->
                            <div class="relative">
                                <img
                                    :src="getAvatarUrl"
                                    alt="Profile"
                                    class="h-20 w-20 rounded-2xl object-cover ring-4"
                                    :class="isDark ? 'ring-[#1E293B]' : 'ring-[#F1F5F9]'"
                                />
                                <button
                                    type="button"
                                    @click="$refs.fileInput.click()"
                                    class="absolute -right-1.5 -bottom-1.5 flex h-7 w-7 items-center justify-center rounded-full bg-[#14B8A6] shadow-lg shadow-teal-500/30 transition-transform duration-200 hover:scale-110"
                                >
                                    <svg class="h-3.5 w-3.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    </svg>
                                </button>
                            </div>

                            <!-- Info & buttons -->
                            <div>
                                <p :class="headingClass" class="mb-0.5 font-semibold">{{ form.first_name }} {{ form.last_name }}</p>
                                <p :class="subheadingClass" class="mb-4 text-xs">
                                    Patient ID: {{ profileData?.id || '—' }}
                                </p>
                                <div class="flex flex-wrap gap-2">
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
                                        :class="isDark
                                            ? 'border-[#334155] text-[#94A3B8] hover:bg-[#334155]/60'
                                            : 'border-[#E5E7EB] text-[#374151] hover:bg-[#F9FAFB]'"
                                        class="rounded-xl border px-4 py-2 text-xs font-semibold transition-all duration-200"
                                    >
                                        Change Photo
                                    </button>
                                    <button
                                        type="button"
                                        @click="removeAvatar"
                                        :disabled="!profileData?.avatar"
                                        :class="isDark
                                            ? 'border-red-500/30 text-red-400 hover:bg-red-500/8'
                                            : 'border-red-200 text-red-500 hover:bg-red-50'"
                                        class="rounded-xl border px-4 py-2 text-xs font-semibold transition-all duration-200"
                                    >
                                        Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- ── Personal Information ── -->
                    <section
                        :class="cardClass"
                        class="rounded-2xl border p-6"
                        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                    >
                        <h3 :class="headingClass" class="mb-0.5 text-sm font-semibold">Personal Information</h3>
                        <p :class="subheadingClass" class="mb-6 text-xs">Your basic details and contact info</p>

                        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">First Name</label>
                                <input v-model="form.first_name" type="text" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Last Name</label>
                                <input v-model="form.last_name" type="text" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Email Address</label>
                                <input v-model="form.email" type="email" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Phone Number</label>
                                <div class="flex gap-2">
                                    <select :class="inputClass"
                                        class="rounded-xl border px-2.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none">
                                        <option>🇪🇬 +20</option>
                                    </select>
                                    <input v-model="form.phone" type="tel" :class="inputClass"
                                        class="flex-1 rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                                </div>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">National ID</label>
                                <input v-model="form.national_id" type="text" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Date of Birth</label>
                                <input v-model="form.birth_date" type="date" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Gender</label>
                                <select v-model="form.gender" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none">
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Governorate / Address</label>
                                <input v-model="form.governorate" type="text" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                        </div>
                    </section>

                    <!-- ── Emergency Contact ── -->
                    <section
                        :class="cardClass"
                        class="rounded-2xl border p-6"
                        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                    >
                        <div class="mb-0.5 flex items-center gap-2">
                            <h3 :class="headingClass" class="text-sm font-semibold">Emergency Contact</h3>
                            <span class="badge badge-danger">Important</span>
                        </div>
                        <p :class="subheadingClass" class="mb-6 text-xs">Who should we contact in case of emergency?</p>

                        <div class="mb-5 grid grid-cols-1 gap-4 sm:grid-cols-2">
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Contact Name</label>
                                <input v-model="form.emergency_contact_name" type="text" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                            </div>
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Relationship</label>
                                <select v-model="form.emergency_contact_relationship" :class="inputClass"
                                    class="w-full rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none">
                                    <option>Parent</option>
                                    <option>Spouse</option>
                                    <option>Sibling</option>
                                    <option>Friend</option>
                                    <option>Other</option>
                                </select>
                            </div>
                            <div class="sm:col-span-2">
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Phone Number</label>
                                <div class="flex gap-2">
                                    <select :class="inputClass"
                                        class="rounded-xl border px-2.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none">
                                        <option>🇪🇬 +20</option>
                                    </select>
                                    <input v-model="form.emergency_contact_phone" type="tel" :class="inputClass"
                                        class="flex-1 rounded-xl border px-3.5 py-2.5 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                                </div>
                            </div>
                        </div>

                        <!-- Notice -->
                        <div
                            :class="isDark ? 'border-teal-500/20 bg-teal-500/8 text-teal-400' : 'border-teal-200 bg-[#F0FDFA] text-[#0F766E]'"
                            class="flex items-start gap-2.5 rounded-xl border px-4 py-3 text-xs font-medium"
                        >
                            <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            This information is only shared with healthcare providers in case of emergency.
                        </div>
                    </section>

                    <!-- ── Change Password ── -->
                    <section
                        :class="cardClass"
                        class="rounded-2xl border p-6"
                        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
                    >
                        <h3 :class="headingClass" class="mb-0.5 text-sm font-semibold">Change Password</h3>
                        <p :class="subheadingClass" class="mb-6 text-xs">Keep your account secure with a strong, unique password.</p>

                        <div class="space-y-4">
                            <!-- Current password -->
                            <div>
                                <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Current Password</label>
                                <div class="relative">
                                    <input
                                        v-model="form.current_password"
                                        :type="showPassword.current ? 'text' : 'password'"
                                        placeholder="Enter current password"
                                        :class="inputClass"
                                        class="w-full rounded-xl border py-2.5 pl-3.5 pr-16 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"
                                    />
                                    <button type="button" @click="showPassword.current = !showPassword.current"
                                        class="absolute top-1/2 right-3.5 -translate-y-1/2 text-[10px] font-bold text-[#14B8A6] hover:text-[#0D9488] transition-colors">
                                        {{ showPassword.current ? 'Hide' : 'Show' }}
                                    </button>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                                <div>
                                    <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">New Password</label>
                                    <div class="relative">
                                        <input v-model="form.password" :type="showPassword.new ? 'text' : 'password'"
                                            placeholder="Create new password" :class="inputClass"
                                            class="w-full rounded-xl border py-2.5 pl-3.5 pr-16 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                                        <button type="button" @click="showPassword.new = !showPassword.new"
                                            class="absolute top-1/2 right-3.5 -translate-y-1/2 text-[10px] font-bold text-[#14B8A6] hover:text-[#0D9488] transition-colors">
                                            {{ showPassword.new ? 'Hide' : 'Show' }}
                                        </button>
                                    </div>
                                </div>
                                <div>
                                    <label :class="labelClass" class="mb-1.5 block text-xs font-semibold">Confirm Password</label>
                                    <div class="relative">
                                        <input v-model="form.password_confirmation" :type="showPassword.confirm ? 'text' : 'password'"
                                            placeholder="Confirm new password" :class="inputClass"
                                            class="w-full rounded-xl border py-2.5 pl-3.5 pr-16 text-sm transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/15 focus:outline-none"/>
                                        <button type="button" @click="showPassword.confirm = !showPassword.confirm"
                                            class="absolute top-1/2 right-3.5 -translate-y-1/2 text-[10px] font-bold text-[#14B8A6] hover:text-[#0D9488] transition-colors">
                                            {{ showPassword.confirm ? 'Hide' : 'Show' }}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- ── Save actions ── -->
                    <div class="flex justify-end gap-3 pb-2">
                        <button
                            type="button"
                            :class="isDark
                                ? 'border-[#334155] text-[#94A3B8] hover:bg-[#1E293B]'
                                : 'border-[#E5E7EB] text-[#374151] hover:bg-[#F9FAFB]'"
                            class="rounded-xl border px-6 py-2.5 text-sm font-semibold transition-all duration-200"
                        >
                            Cancel
                        </button>
                        <button
                            type="submit"
                            :disabled="form.processing"
                            class="btn-primary disabled:cursor-not-allowed disabled:opacity-50"
                        >
                            <svg v-if="form.processing" class="h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
                            </svg>
                            {{ form.processing ? 'Saving…' : 'Save Changes' }}
                        </button>
                    </div>
                </div>
            </form>
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
</style>
