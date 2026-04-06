<script setup>
defineProps({
    activeTab: {
        type: String,
        required: true,
    },
    isDark: {
        type: Boolean,
        default: false,
    },
});

// 2. UPDATED: Assign to a variable for cleaner template usage
const emit = defineEmits(['change']);

const tabs = [
    {
        id: 'prescription',
        label: 'Prescription',
        iconPath:
            '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>',
    },
    {
        id: 'test-results',
        label: 'Test Results',
        iconPath:
            '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>',
    },
    {
        id: 'imaging',
        label: 'Imaging',
        iconPath:
            '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>',
    },
    {
        id: 'visit-history',
        label: 'Visit History',
        iconPath:
            '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>',
    },
];
</script>

<template>
    <div :class="isDark ? 'border-[#334155]' : 'border-[#E5E7EB]'" class="mb-6 border-b">
        <div class="flex gap-8">
            <button
                v-for="tab in tabs"
                :key="tab.id"
                @click="emit('change', tab.id)"
                :class="[
                    'flex items-center gap-2 border-b-2 px-2 pb-4 transition-all duration-300',
                    activeTab === tab.id
                        ? isDark
                            ? 'border-[#2DD4BF] text-[#2DD4BF]'
                            : 'border-[#14B8A6] text-[#14B8A6]'
                        : isDark
                          ? 'border-transparent text-[#94A3B8] hover:text-[#F8FAFC]'
                          : 'border-transparent text-[#6B7280] hover:text-[#111827]',
                ]"
            >
                <div v-html="tab.iconPath" class="flex items-center justify-center"></div>
                <span class="text-sm font-medium">{{ tab.label }}</span>
            </button>
        </div>
    </div>
</template>
