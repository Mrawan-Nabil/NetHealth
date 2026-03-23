<script setup>
defineProps({
    doctor: {
        type: Object,
        required: true,
    },
    isDark: {
        type: Boolean,
        default: false,
    },
});

defineEmits(['book']);
</script>

<template>
    <div
        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
        class="group rounded-xl border p-6 transition-all duration-200 hover:-translate-y-1 hover:shadow-lg hover:shadow-black/5"
    >
        <!-- Doctor Info -->
        <div class="mb-5 flex items-start gap-4">
            <div class="relative">
                <img
                    :src="doctor.avatar"
                    alt="Doctor"
                    class="h-16 w-16 rounded-full object-cover ring-2 ring-gray-100 transition-all duration-200"
                    :class="isDark ? 'ring-gray-700' : 'ring-gray-100'"
                />
                <div class="absolute -right-1 -bottom-1 flex h-5 w-5 items-center justify-center rounded-full bg-green-500 ring-2 ring-white">
                    <div class="h-2 w-2 rounded-full bg-white"></div>
                </div>
            </div>
            <div class="flex-1">
                <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-lg font-semibold">
                    {{ doctor.name }}
                </h3>
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-3 text-sm">
                    {{ doctor.specialty }}
                </p>
                <div class="flex items-center gap-1">
                    <svg class="h-4 w-4 text-[#F59E0B]" fill="currentColor" viewBox="0 0 20 20">
                        <path
                            d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                        />
                    </svg>
                    <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
                        {{ doctor.rating }}
                    </span>
                    <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#9CA3AF]'" class="text-xs"> ({{ doctor.reviews }} reviews) </span>
                </div>
            </div>
        </div>

        <!-- Hospital -->
        <div class="mb-4 flex items-center gap-2">
            <svg class="h-4 w-4" :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                />
            </svg>
            <span :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm">
                {{ doctor.hospital }}
            </span>
        </div>

        <!-- Availability & Price -->
        <div class="mb-5 flex items-center justify-between">
            <span class="flex items-center gap-1.5 text-xs font-medium text-[#10B981]">
                <span class="h-2 w-2 rounded-full bg-[#10B981]"></span>
                AVAILABLE TODAY
            </span>
            <span :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm font-semibold">
                {{ doctor.price }}
            </span>
        </div>

        <!-- Book Button -->
        <button
            @click="$emit('book', doctor)"
            class="w-full rounded-lg bg-[#14B8A6] px-4 py-3 font-medium text-white transition-all duration-200 hover:bg-[#0F9B8E] hover:shadow-lg hover:shadow-[#14B8A6]/25 active:scale-[0.98]"
        >
            Book Appointment
        </button>
    </div>
</template>
