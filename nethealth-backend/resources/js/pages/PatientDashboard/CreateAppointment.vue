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
        title="Book a New Appointment"
        :is-dark="isDark"
        :user="{ name: 'Ahmed Yahia', username: '@y7ia007', avatar: 'https://i.pravatar.cc/150?img=12' }"
        :notifications="[]"
        :show-last-viewed="true"
        :show-share="true"
        @logout="handleLogout"
      />

      <!-- Page Content -->
      <main class="p-8">
        <!-- Page Header -->
        <div class="mb-8">
          <h1 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-3xl font-bold mb-2">
            Book a New Appointment
          </h1>
          <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-base leading-relaxed">
            Find and schedule with top-rated medical specialists in your area.
          </p>
        </div>

        <!-- Search Section -->
        <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="rounded-xl border p-6 mb-8 shadow-sm hover:shadow-md transition-all duration-300">
          <div class="flex items-center gap-4">
            <div class="flex-1 relative">
              <svg class="w-5 h-5 absolute left-4 top-1/2 transform -translate-y-1/2" :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
              </svg>
              <input 
                v-model="searchQuery"
                type="text"
                placeholder="Search doctors by name, hospital, or keywords..."
                :class="[
                  'w-full pl-12 pr-4 py-3 rounded-lg border transition-all duration-200 focus:ring-2 focus:ring-[#14B8A6]/20 focus:border-[#14B8A6] focus:outline-none',
                  isDark 
                    ? 'bg-[#0F172A] border-[#334155] text-[#F8FAFC] placeholder-[#94A3B8]'
                    : 'bg-[#F8FAFC] border-[#E5E7EB] text-[#111827] placeholder-[#9CA3AF]'
                ]"
              />
            </div>
            <button class="px-6 py-3 bg-[#14B8A6] hover:bg-[#0F9B8E] text-white rounded-lg font-medium transition-all duration-200 hover:shadow-lg hover:shadow-[#14B8A6]/25 active:scale-[0.98]">
              Find Specialist
            </button>
          </div>
        </div>

        <!-- Specialties Section -->
        <div class="mb-8">
          <h2 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-xl font-semibold mb-6">
            Specialties
          </h2>
          <div class="flex items-center gap-3 overflow-x-auto pb-2">
            <button
              v-for="specialty in specialties"
              :key="specialty.id"
              @click="selectedSpecialty = specialty.id"
              :class="[
                'px-4 py-2.5 rounded-lg font-medium transition-all duration-200 flex items-center gap-2 whitespace-nowrap hover:scale-[1.02] active:scale-[0.98]',
                selectedSpecialty === specialty.id
                  ? 'bg-[#14B8A6] text-white shadow-lg shadow-[#14B8A6]/25'
                  : isDark
                    ? 'bg-[#1E293B] border border-[#14B8A6] text-[#14B8A6] hover:bg-[#14B8A6]/10 hover:shadow-sm'
                    : 'bg-white border border-[#14B8A6] text-[#14B8A6] hover:bg-[#14B8A6]/5 hover:shadow-sm'
              ]"
            >
              <div v-html="specialty.icon" class="w-4 h-4"></div>
              {{ specialty.name }}
            </button>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="i in 6" :key="i" class="animate-pulse">
            <div :class="isDark ? 'bg-[#1E293B]' : 'bg-gray-200'" class="h-80 rounded-xl"></div>
          </div>
        </div>

        <!-- Doctors Grid -->
        <div v-else-if="filteredDoctors.length > 0" class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="doctor in filteredDoctors" :key="doctor.id">
            <DoctorCard
              :doctor="doctor"
              :is-dark="isDark"
              @book="handleBookDoctor"
            />
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="text-center py-16">
          <div :class="isDark ? 'bg-[#1E293B] border-[#334155]' : 'bg-white border-[#E5E7EB]'" class="max-w-md mx-auto rounded-xl border p-8 shadow-sm">
            <div :class="isDark ? 'bg-[#0F172A]' : 'bg-gray-50'" class="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg :class="isDark ? 'text-[#475569]' : 'text-gray-400'" class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
              </svg>
            </div>
            <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-lg font-semibold mb-2">No doctors found</h3>
            <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm leading-relaxed">Try adjusting your search or specialty filter</p>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/dashboard/Sidebar.vue'
import TopNavbar from '../components/dashboard/TopNavbar.vue'
import DoctorCard from '../components/appointments/DoctorCard.vue'

const router = useRouter()

// State
const isDark = ref(false)
const searchQuery = ref('')
const selectedSpecialty = ref('all')
const loading = ref(false)

const specialties = [
  {
    id: 'all',
    name: 'All Specialties',
    icon: '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3zM3.31 9.397L5 10.12v4.102a8.969 8.969 0 00-1.05-.174 1 1 0 01-.89-.89 11.115 11.115 0 01.25-3.762zM9.3 16.573A9.026 9.026 0 007 14.935v-3.957l1.818.78a3 3 0 002.364 0l5.508-2.361a11.026 11.026 0 01.25 3.762 1 1 0 01-.89.89 8.968 8.968 0 00-5.35 2.524 1 1 0 01-1.4 0zM6 18a1 1 0 001-1v-2.065a8.935 8.935 0 00-2-.712V17a1 1 0 001 1z"/></svg>'
  },
  {
    id: 'cardiology',
    name: 'Cardiology',
    icon: '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/></svg>'
  },
  {
    id: 'gastritis',
    name: 'Gastritis',
    icon: '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6z"/></svg>'
  },
  {
    id: 'neurology',
    name: 'Neurology',
    icon: '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z"/><path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd"/></svg>'
  },
  {
    id: 'pulmonology',
    name: 'Pulmonology',
    icon: '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3 3a1 1 0 000 2v8a2 2 0 002 2h2.586l-1.293 1.293a1 1 0 101.414 1.414L10 15.414l2.293 2.293a1 1 0 001.414-1.414L12.414 15H15a2 2 0 002-2V5a1 1 0 100-2H3zm11 4a1 1 0 10-2 0v4a1 1 0 102 0V7zm-3 1a1 1 0 10-2 0v3a1 1 0 102 0V8zM8 9a1 1 0 00-2 0v2a1 1 0 102 0V9z" clip-rule="evenodd"/></svg>'
  },
  {
    id: 'dentistry',
    name: 'Dentistry',
    icon: '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM7 9a1 1 0 100-2 1 1 0 000 2zm7-1a1 1 0 11-2 0 1 1 0 012 0zm-.464 5.535a1 1 0 10-1.415-1.414 3 3 0 01-4.242 0 1 1 0 00-1.415 1.414 5 5 0 007.072 0z" clip-rule="evenodd"/></svg>'
  }
]

const doctors = ref([])

// Computed
const filteredDoctors = computed(() => {
  let filtered = doctors.value

  if (selectedSpecialty.value !== 'all') {
    filtered = filtered.filter(d => d.specialtyId === selectedSpecialty.value)
  }

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(d => 
      d.name.toLowerCase().includes(query) ||
      d.specialty.toLowerCase().includes(query) ||
      d.hospital.toLowerCase().includes(query)
    )
  }

  return filtered
})

// Methods
const toggleTheme = (theme) => {
  isDark.value = theme === 'dark'
  localStorage.setItem('theme', theme)
}

const handleLogout = () => {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('authToken')
    router.push('/login')
  }
}

const handleBookDoctor = (doctor) => {
  console.log('Book doctor:', doctor)
  router.push(`/doctor/${doctor.id}`)
}

const fetchDoctors = async () => {
  loading.value = true
  
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 1000))
  
  // Dummy data
  doctors.value = [
    {
      id: 1,
      name: 'Dr/ Ayman Fathy',
      specialty: 'Cardiology Specialist',
      specialtyId: 'cardiology',
      avatar: 'https://i.pravatar.cc/150?img=33',
      hospital: 'City Heart Institute',
      rating: 4.9,
      reviews: 120,
      price: '$115 EXP'
    },
    {
      id: 2,
      name: 'Dr/ Sarah Johnson',
      specialty: 'Neurology Specialist',
      specialtyId: 'neurology',
      avatar: 'https://i.pravatar.cc/150?img=47',
      hospital: 'Brain & Spine Center',
      rating: 4.8,
      reviews: 95,
      price: '$125 EXP'
    },
    {
      id: 3,
      name: 'Dr/ Michael Chen',
      specialty: 'Gastroenterology',
      specialtyId: 'gastritis',
      avatar: 'https://i.pravatar.cc/150?img=52',
      hospital: 'Digestive Health Clinic',
      rating: 4.7,
      reviews: 88,
      price: '$110 EXP'
    },
    {
      id: 4,
      name: 'Dr/ Emily Davis',
      specialty: 'Pulmonology',
      specialtyId: 'pulmonology',
      avatar: 'https://i.pravatar.cc/150?img=44',
      hospital: 'Respiratory Care Center',
      rating: 4.9,
      reviews: 102,
      price: '$120 EXP'
    },
    {
      id: 5,
      name: 'Dr/ Robert Wilson',
      specialty: 'Dentistry',
      specialtyId: 'dentistry',
      avatar: 'https://i.pravatar.cc/150?img=68',
      hospital: 'Smile Dental Clinic',
      rating: 4.6,
      reviews: 156,
      price: '$95 EXP'
    },
    {
      id: 6,
      name: 'Dr/ Lisa Anderson',
      specialty: 'Cardiology Specialist',
      specialtyId: 'cardiology',
      avatar: 'https://i.pravatar.cc/150?img=32',
      hospital: 'Heart Care Institute',
      rating: 4.8,
      reviews: 134,
      price: '$130 EXP'
    }
  ]
  
  loading.value = false
}

// Lifecycle
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  }
  fetchDoctors()
})
</script>
