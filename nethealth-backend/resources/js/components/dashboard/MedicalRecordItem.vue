<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    record: {
        type: Object,
        required: true,
    },
    isDark: Boolean,
});

const recordType = computed(() => {
    const title = props.record.title.toLowerCase();
    if (title.includes('prescription')) return 'prescription';
    if (title.includes('test') || title.includes('blood')) return 'test';
    return 'document';
});

const recordLink = computed(() => {
    if (recordType.value === 'prescription') return `/prescription/${props.record.id || 1}`;
    if (recordType.value === 'test') return `/test-results/${props.record.id || 1}`;
    return '/medical-records';
});

const iconBgColor = computed(() => {
    if (recordType.value === 'prescription') return props.isDark ? 'bg-orange-500/10' : 'bg-orange-50';
    if (recordType.value === 'test') return props.isDark ? 'bg-blue-500/10' : 'bg-blue-50';
    return props.isDark ? 'bg-emerald-500/10' : 'bg-emerald-50';
});

const iconColor = computed(() => {
    if (recordType.value === 'prescription') return 'text-[#F59E0B]';
    if (recordType.value === 'test') return 'text-[#3B82F6]';
    return 'text-[#22C55E]';
});

const statusClass = computed(() => {
    const status = props.record.status.toLowerCase();
    const classes = {
        active: props.isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-50 text-[#22C55E]',
        available: props.isDark ? 'bg-blue-500/10 text-[#3B82F6]' : 'bg-blue-50 text-[#3B82F6]',
        completed: props.isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-gray-100 text-[#6B7280]',
        pending: props.isDark ? 'bg-amber-500/10 text-[#F59E0B]' : 'bg-yellow-50 text-[#F59E0B]',
    };
    return classes[status] || (props.isDark ? 'bg-[#334155] text-[#94A3B8]' : 'bg-gray-100 text-[#6B7280]');
});
</script>

<template>
    <Link
        :href="recordLink"
        :class="isDark ? 'border-[#334155]/50 bg-[#1E293B]/50 hover:bg-[#1E293B]' : 'border-transparent bg-[#F8FAFC] hover:bg-gray-100'"
        class="container-hover-subtle group flex items-center gap-4 rounded-xl border p-4"
    >
        <div :class="[iconBgColor, 'smooth-transition group-hover:scale-105']" class="flex-shrink-0 rounded-lg p-3">
            <svg v-if="recordType === 'prescription'" :class="iconColor" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
            </svg>

            <svg v-else-if="recordType === 'test'" :class="iconColor" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
                />
            </svg>

            <svg v-else :class="iconColor" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
            </svg>
        </div>

        <div class="min-w-0 flex-1">
            <h4 :class="isDark ? 'text-white' : 'text-gray-900'" class="mb-1 truncate text-sm font-medium">{{ record.title }}</h4>
            <p :class="isDark ? 'text-slate-400' : 'text-gray-600'" class="truncate text-xs">{{ record.doctor }} • {{ record.date }}</p>
        </div>

        <span :class="statusClass" class="smooth-transition flex-shrink-0 rounded-full px-3 py-1.5 text-xs font-semibold whitespace-nowrap">
            {{ record.status }}
        </span>
    </Link>
</template>

<style scoped>
.container-hover-subtle {
    transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
}

.container-hover-subtle:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.06);
}
</style>
