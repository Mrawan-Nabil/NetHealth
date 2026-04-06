<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
    prescription: {
        type: Object,
        required: true,
    },
    isDark: {
        type: Boolean,
        default: false,
    },
});

// 1. Assigned to a variable for consistency
const emit = defineEmits(['download', 'view-details']);

const showAllMedicines = ref(false);

const displayedMedicines = computed(() => {
    // 2. Defensive fallback: if medicines is undefined, use an empty array
    const medicines = props.prescription.medicines || [];

    if (showAllMedicines.value || medicines.length <= 2) {
        return medicines;
    }
    return medicines.slice(0, 2);
});

const statusClass = computed(() => {
    // 3. Defensive check: safely lowercase the status, or fallback to empty string
    const status = props.prescription.status?.toLowerCase() || '';

    if (status === 'issued') {
        return props.isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-100 text-emerald-600';
    } else if (status === 'pending') {
        return props.isDark ? 'bg-orange-500/10 text-[#F59E0B]' : 'bg-orange-100 text-orange-600';
    } else if (status === 'dispensed') {
        return props.isDark ? 'bg-blue-500/10 text-[#3B82F6]' : 'bg-blue-100 text-blue-600';
    }
    return props.isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-gray-100 text-gray-500';
});
</script>

<template>
    <div
        :class="isDark ? 'border-[#334155] bg-[#1E293B]' : 'border-[#E5E7EB] bg-white'"
        class="animate-fade-in-up card-interactive group space-y-4 rounded-lg border p-6 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl"
    >
        <div class="flex items-start justify-between">
            <div class="flex-1">
                <h3 :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="mb-1 text-base font-semibold transition-colors duration-300">
                    {{ prescription.doctor }}
                </h3>
                <p :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="text-sm transition-colors duration-300">
                    {{ prescription.specialty }}
                </p>
                <div
                    :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'"
                    class="mt-2 flex items-center gap-1 text-xs transition-colors duration-300"
                >
                    <svg
                        class="h-4 w-4 transition-transform duration-300 group-hover:rotate-12"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                        />
                    </svg>
                    <span>{{ prescription.date }} - Expires {{ prescription.expires }}</span>
                </div>
            </div>
            <span :class="statusClass" class="rounded-full px-3 py-1 text-xs font-medium uppercase transition-all duration-300 group-hover:scale-110">
                {{ prescription.status }}
            </span>
        </div>

        <div class="transition-all duration-300">
            <h4 :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-2 text-xs font-semibold uppercase transition-colors duration-300">
                Diagnosis
            </h4>
            <p :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'" class="text-sm leading-relaxed transition-colors duration-300">
                {{ prescription.diagnosis }}
            </p>
        </div>

        <div class="transition-all duration-300">
            <h4 :class="isDark ? 'text-[#94A3B8]' : 'text-[#6B7280]'" class="mb-2 text-xs font-semibold uppercase transition-colors duration-300">
                Medicines
            </h4>
            <transition-group name="list" tag="ul" class="space-y-1">
                <li
                    v-for="(medicine, index) in displayedMedicines"
                    :key="index"
                    :class="isDark ? 'text-[#F8FAFC]' : 'text-[#111827]'"
                    class="flex items-start gap-2 text-sm transition-all duration-300"
                >
                    <span class="mt-1 text-[#14B8A6] transition-transform duration-300 group-hover:scale-125">•</span>
                    <span>{{ medicine }}</span>
                </li>
            </transition-group>

            <button
                v-if="(prescription.medicines?.length || 0) > 2"
                @click="showAllMedicines = !showAllMedicines"
                class="mt-2 text-xs font-medium text-[#14B8A6] transition-all duration-300 hover:translate-x-1 hover:text-[#0D9488]"
            >
                {{ showAllMedicines ? 'Show less' : `+${prescription.medicines.length - 2} more medicines` }}
            </button>
        </div>

        <div class="flex items-center justify-end gap-3 pt-2">
            <button
                @click="emit('download', prescription)"
                :class="isDark ? 'border-[#334155] text-[#94A3B8] hover:bg-[#334155]' : 'border-[#D1D5DB] text-[#6B7280] hover:bg-gray-50'"
                class="flex items-center gap-2 rounded-lg border px-4 py-2 text-sm font-medium transition-all duration-300 hover:scale-105 hover:shadow-md active:scale-95"
            >
                <svg
                    class="h-4 w-4 transition-transform duration-300 group-hover:translate-y-0.5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                >
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
                    />
                </svg>
                Download
            </button>

            <button
                @click="emit('view-details', prescription)"
                class="flex items-center gap-2 rounded-lg bg-[#14B8A6] px-4 py-2 text-sm font-medium text-white transition-all duration-300 hover:scale-105 hover:bg-[#0F9B8E] hover:shadow-lg hover:shadow-teal-500/30 active:scale-95"
            >
                View Details
                <svg
                    class="h-4 w-4 transition-transform duration-300 group-hover:translate-x-1"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
            </button>
        </div>
    </div>
</template>

<style scoped>
/* List transition animations */
.list-enter-active,
.list-leave-active {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.list-enter-from {
    opacity: 0;
    transform: translateX(-10px);
}

.list-leave-to {
    opacity: 0;
    transform: translateX(10px);
}

.list-move {
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>
