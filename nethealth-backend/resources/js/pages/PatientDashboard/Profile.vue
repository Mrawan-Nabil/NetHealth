<template>
  <div :class="isDark ? 'bg-[#0F172A]' : 'bg-[#F8FAFC]'" class="min-h-screen transition-colors duration-300">
    <!-- Sidebar -->
    <Sidebar 
      :is-dark="isDark"
      @toggle-theme="toggleTheme"
      @logout="handleLogout"
    />

    <!-- Main Content -->
    <div class="ml-64">
      <!-- Top Navbar -->
      <TopNavbar 
        title="Profile"
        :is-dark="isDark"
        :user="{ name: profileData.name, username: '@y7ia007', avatar: profileData.avatar }"
        :notifications="[]"
        :show-last-viewed="false"
        :show-share="false"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-6">
        <!-- Page Header -->
        <div class="mb-6">
          <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-2xl font-bold mb-1">
            Profile
          </h1>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
            Upload your personal information and account settings
          </p>
        </div>

        <!-- Profile Picture Card -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-xl border p-6 mb-6 transition-all duration-300 hover:shadow-lg hover:-translate-y-1 card-interactive animate-fade-in-up">
          <div class="flex items-start gap-4">
            <!-- Icon -->
            <div class="w-12 h-12 rounded-lg bg-[#CCFBF1] flex items-center justify-center flex-shrink-0 hover:scale-110 transition-transform duration-300 animate-slide-right">
              <svg class="w-6 h-6 text-[#14B8A6] animate-pulse-slow" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
              </svg>
            </div>

            <!-- Content -->
            <div class="flex-1 animate-slide-up">
              <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-base font-semibold mb-1 transition-colors duration-300">
                Profile Picture
              </h3>
              <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-4 transition-colors duration-300">
                JPG/PNG or GIF. Max size 5 MB
              </p>

              <!-- Avatar and Actions -->
              <div class="flex items-center gap-4">
                <img 
                  :src="profileData.avatar" 
                  alt="Profile"
                  class="w-16 h-16 rounded-full object-cover hover:scale-110 transition-transform duration-300 animate-scale-in"
                />
                <div class="animate-slide-left stagger-1">
                  <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold mb-1 transition-colors duration-300">
                    {{ profileData.name }}
                  </p>
                  <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-xs mb-3 transition-colors duration-300">
                    {{ profileData.id }}
                  </p>
                  <div class="flex items-center gap-2">
                    <button :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'" class="px-4 py-1.5 border rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-1.5 hover:scale-105 btn-ripple">
                      <svg class="w-4 h-4 transition-transform duration-300 group-hover:-translate-y-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                      </svg>
                      Change Photo
                    </button>
                    <button class="px-4 py-1.5 border border-[#FCA5A5] text-[#DC2626] hover:bg-[#FEE2E2] rounded-lg text-sm font-medium transition-all duration-300 flex items-center gap-1.5 hover:scale-105 btn-ripple">
                      <svg class="w-4 h-4 transition-transform duration-300 group-hover:rotate-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                      </svg>
                      Remove Photo
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Personal Information Card -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-xl border p-6 mb-6 transition-all duration-300 hover:shadow-lg hover:-translate-y-1 card-interactive animate-fade-in-up stagger-1">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-1 transition-colors duration-300">
            Personal Information
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-6 transition-colors duration-300">
            Your basic details and contact info
          </p>

          <div class="grid grid-cols-2 gap-4">
            <!-- First Name -->
            <div class="animate-slide-up stagger-1">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                First Name
              </label>
              <input 
                v-model="profileData.firstName"
                type="text"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              />
            </div>

            <!-- Second Name -->
            <div class="animate-slide-up stagger-2">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                Second Name
              </label>
              <input 
                v-model="profileData.secondName"
                type="text"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              />
            </div>

            <!-- Email Address -->
            <div class="animate-slide-up stagger-3">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                Email Address
              </label>
              <input 
                v-model="profileData.email"
                type="email"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              />
            </div>

            <!-- Phone Number -->
            <div class="animate-slide-up stagger-4">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                Phone Number
              </label>
              <div class="flex gap-2">
                <select :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'" class="px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]">
                  <option>🇪🇬 +20</option>
                </select>
                <input 
                  v-model="profileData.phone"
                  type="tel"
                  :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                  class="flex-1 px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
                />
              </div>
            </div>

            <!-- National ID -->
            <div class="animate-slide-up stagger-5">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                National ID
              </label>
              <input 
                v-model="profileData.nationalId"
                type="text"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              />
            </div>

            <!-- Date of Birth -->
            <div class="animate-slide-up stagger-1">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                Date of Birth
              </label>
              <input 
                v-model="profileData.dateOfBirth"
                type="date"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              />
            </div>

            <!-- Gender -->
            <div class="animate-slide-up stagger-2">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                Gender
              </label>
              <select 
                v-model="profileData.gender"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              >
                <option>Male</option>
                <option>Female</option>
              </select>
            </div>

            <!-- Address (Full Width) -->
            <div class="col-span-2 animate-slide-up stagger-3">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2 transition-colors duration-300">
                Address
              </label>
              <input 
                v-model="profileData.address"
                type="text"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-all duration-300 hover:border-[#14B8A6]"
              />
            </div>
          </div>
        </div>

        <!-- Emergency Contact Card -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-xl border p-6 mb-6 transition-all duration-300">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-1">
            Emergency Contact
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-6">
            Who should we contact in an emergency?
          </p>

          <div class="grid grid-cols-2 gap-4 mb-4">
            <!-- Contact Name -->
            <div>
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2">
                Contact Name
              </label>
              <input 
                v-model="emergencyContact.name"
                type="text"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors"
              />
            </div>

            <!-- Relationship -->
            <div>
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2">
                Relationship
              </label>
              <select 
                v-model="emergencyContact.relationship"
                :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                class="w-full px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors"
              >
                <option>Parent</option>
                <option>Spouse</option>
                <option>Sibling</option>
                <option>Friend</option>
              </select>
            </div>

            <!-- Phone Number (Full Width) -->
            <div class="col-span-2">
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2">
                Phone Number
              </label>
              <div class="flex gap-2">
                <select :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'" class="px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors">
                  <option>🇪🇬 +20</option>
                </select>
                <input 
                  v-model="emergencyContact.phone"
                  type="tel"
                  :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                  class="flex-1 px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors"
                />
              </div>
            </div>
          </div>

          <!-- Info Message -->
          <div class="bg-[#CCFBF1] text-[#0F766E] px-4 py-2.5 rounded-lg text-xs">
            This information is only shared with healthcare providers in case of emergency.
          </div>
        </div>

        <!-- Change Password Card -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-xl border p-6 mb-6 transition-all duration-300">
          <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-1">
            Change Password
          </h3>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm mb-6">
            Keep your account safe with a strong password
          </p>

          <div class="space-y-4">
            <!-- Current Password -->
            <div>
              <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2">
                Current Password
              </label>
              <div class="relative">
                <div class="absolute left-3 top-1/2 -translate-y-1/2">
                  <svg class="w-4 h-4 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                  </svg>
                </div>
                <input 
                  v-model="passwordData.current"
                  :type="showPassword.current ? 'text' : 'password'"
                  placeholder="Create a current password"
                  :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                  class="w-full pl-10 pr-10 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors"
                />
                <button 
                  @click="showPassword.current = !showPassword.current"
                  class="absolute right-3 top-1/2 -translate-y-1/2"
                >
                  <svg class="w-4 h-4 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                  </svg>
                </button>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <!-- New Password -->
              <div>
                <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2">
                  New Password
                </label>
                <div class="relative">
                  <div class="absolute left-3 top-1/2 -translate-y-1/2">
                    <svg class="w-4 h-4 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                  </div>
                  <input 
                    v-model="passwordData.new"
                    :type="showPassword.new ? 'text' : 'password'"
                    placeholder="Create a new password"
                    :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                    class="w-full pl-10 pr-10 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors"
                  />
                  <button 
                    @click="showPassword.new = !showPassword.new"
                    class="absolute right-3 top-1/2 -translate-y-1/2"
                  >
                    <svg class="w-4 h-4 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Confirm New Password -->
              <div>
                <label :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="block text-sm font-medium mb-2">
                  Confirm New Password
                </label>
                <div class="relative">
                  <div class="absolute left-3 top-1/2 -translate-y-1/2">
                    <svg class="w-4 h-4 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                  </div>
                  <input 
                    v-model="passwordData.confirm"
                    :type="showPassword.confirm ? 'text' : 'password'"
                    placeholder="Confirm your password"
                    :class="isDark ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC]' : 'bg-white border-[#D1D5DB] text-[#111827]'"
                    class="w-full pl-10 pr-10 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#14B8A6] transition-colors"
                  />
                  <button 
                    @click="showPassword.confirm = !showPassword.confirm"
                    class="absolute right-3 top-1/2 -translate-y-1/2"
                  >
                    <svg class="w-4 h-4 text-[#9CA3AF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex justify-end gap-3">
          <button :class="isDark ? 'border-[#334155] text-[#F8FAFC] hover:bg-[#1E293B]' : 'border-[#D1D5DB] text-[#111827] hover:bg-[#F9FAFB]'" class="px-6 py-2.5 border rounded-lg text-sm font-semibold transition-colors">
            Cancel
          </button>
          <button @click="handleSaveChanges" class="px-6 py-2.5 bg-[#14B8A6] hover:bg-[#0D9488] text-white rounded-lg text-sm font-semibold transition-colors">
            Save change
          </button>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useDashboard } from '../composables/useDashboard'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'

const router = useRouter()
const { state, setTheme } = useDashboard()

const isDark = computed(() => state.isDark)

const profileData = ref({
  avatar: 'https://i.pravatar.cc/150?img=12',
  name: 'Ahmed Yahia',
  id: 'Patient ID: EGY-2020-00870',
  firstName: 'Ahmed',
  secondName: 'Yahia',
  email: 'ahmedyahia@gmail.com',
  phone: '01038484832',
  nationalId: 'XXXX-XXXX-0798',
  dateOfBirth: '1999-03-07',
  gender: 'Male',
  address: '1234 Maple Avenue, Apt 2B, New York, NY 10001'
})

const emergencyContact = ref({
  name: 'Yahia Mohamed',
  relationship: 'Parent',
  phone: '01038384832'
})

const passwordData = ref({
  current: '',
  new: '',
  confirm: ''
})

const showPassword = ref({
  current: false,
  new: false,
  confirm: false
})

const toggleTheme = (theme) => {
  setTheme(theme)
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.push('/login')
  }
}

const handleSaveChanges = () => {
  alert('Profile updated successfully!')
}

onMounted(() => {
  // Profile page mounted
})
</script>
