<script setup lang="ts">
type TabId = 'profile' | 'test-results' | 'imaging' | 'prescriptions' | 'visit-history';
defineProps<{ activeTab: TabId }>();
defineEmits<{ (event: 'change', tab: TabId): void }>();
const tabs: Array<{ id: TabId; label: string; icon: string }> = [
    { id: 'profile', label: 'Profile', icon: 'M16 7a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM4 20a8 8 0 0 1 16 0' },
    { id: 'test-results', label: 'Test Results', icon: 'M9 3v6a3 3 0 0 1-3 3H3m0 0v8a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V3m-15 0h15' },
    { id: 'imaging', label: 'Imaging', icon: 'M4 3h16a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2m5 4a2 2 0 1 0-4 0 2 2 0 0 0 4 0m8 10l-5-5-3 3' },
    { id: 'prescriptions', label: 'Prescription', icon: 'M9 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2h4a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4V5z' },
    { id: 'visit-history', label: 'Visit History', icon: 'M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2z' },
];
</script>
<template>
    <div
        class="flex gap-1 overflow-x-auto rounded-xl border border-[#E5E7EB] bg-white p-1 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04); scrollbar-width: none;"
    >
        <button
            v-for="tab in tabs"
            :key="tab.id"
            class="inline-flex min-w-max flex-1 items-center justify-center gap-1.5 rounded-lg px-3 py-2 text-sm font-semibold transition-all duration-200 whitespace-nowrap focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none"
            :class="
                activeTab === tab.id
                    ? 'bg-[#14B8A6] text-white shadow-sm shadow-teal-500/20 dark:shadow-teal-500/30'
                    : 'text-[#94A3B8] hover:bg-[#F8FAFC] hover:text-[#64748B] dark:text-[#64748B] dark:hover:bg-[#334155]/50 dark:hover:text-[#94A3B8]'
            "
            @click="$emit('change', tab.id)"
        >
            <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="tab.icon" /></svg>{{ tab.label }}
        </button>
    </div>
</template>
