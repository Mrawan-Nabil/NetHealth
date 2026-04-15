<script setup lang="ts">
type TabId = 'completed' | 'upcoming' | 'cancelled';
withDefaults(
    defineProps<{
        activeTab: TabId;
        counts?: Record<TabId, number>;
    }>(),
    {
        counts: () => ({ completed: 0, upcoming: 0, cancelled: 0 }),
    },
);
defineEmits<{ (event: 'change', tab: TabId): void }>();

const tabs: Array<{ id: TabId; label: string }> = [
    { id: 'completed', label: 'Completed' },
    { id: 'upcoming', label: 'Upcoming' },
    { id: 'cancelled', label: 'Cancelled' },
];
</script>

<template>
    <div
        class="flex items-center gap-1 overflow-x-auto rounded-2xl border border-[#F1F5F9] bg-white p-1.5 dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <button
            v-for="tab in tabs"
            :key="tab.id"
            class="flex min-w-[9rem] flex-1 items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-sm font-semibold transition-all duration-200 focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none sm:min-w-0"
            :class="
                activeTab === tab.id
                    ? 'bg-[#14B8A6] text-white shadow-sm shadow-teal-500/20 dark:shadow-teal-500/30'
                    : 'text-[#94A3B8] hover:bg-[#F8FAFC] hover:text-[#64748B] dark:text-[#64748B] dark:hover:bg-[#334155]/50 dark:hover:text-[#94A3B8]'
            "
            @click="$emit('change', tab.id)"
        >
            {{ tab.label }}
            <span
                class="rounded-full px-2 py-0.5 text-[10px] font-bold tabular-nums"
                :class="activeTab === tab.id ? 'bg-white/20 text-white' : 'bg-[#F1F5F9] text-[#9CA3AF] dark:bg-[#334155] dark:text-[#64748B]'"
            >
                {{ counts[tab.id] }}
            </span>
        </button>
    </div>
</template>
