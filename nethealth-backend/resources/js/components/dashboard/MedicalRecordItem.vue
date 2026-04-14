<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    record: { type: Object, required: true },
    isDark: Boolean,
});

const recordType = computed(() => {
    const t = props.record.title?.toLowerCase() || '';
    if (t.includes('prescription')) return 'prescription';
    if (t.includes('test') || t.includes('blood') || t.includes('lab')) return 'test';
    if (t.includes('imaging') || t.includes('scan') || t.includes('mri') || t.includes('ray')) return 'imaging';
    return 'document';
});

const recordLink = computed(() => {
    if (recordType.value === 'prescription') return `/prescription/${props.record.id || 1}`;
    if (recordType.value === 'test') return `/test-results/${props.record.id || 1}`;
    if (recordType.value === 'imaging') return `/imaging/${props.record.id || 1}`;
    return '/medical-records';
});

const iconMeta = computed(() => {
    const map = {
        prescription: {
            bg: props.isDark ? 'bg-amber-500/10' : 'bg-amber-50',
            color: 'text-amber-500',
            path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>',
        },
        test: {
            bg: props.isDark ? 'bg-blue-500/10' : 'bg-blue-50',
            color: 'text-blue-500',
            path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>',
        },
        imaging: {
            bg: props.isDark ? 'bg-violet-500/10' : 'bg-violet-50',
            color: 'text-violet-500',
            path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>',
        },
        document: {
            bg: props.isDark ? 'bg-teal-500/10' : 'bg-teal-50',
            color: 'text-teal-500',
            path: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>',
        },
    };
    return map[recordType.value];
});

const statusMeta = computed(() => {
    const s = (props.record.status || '').toLowerCase();
    const map = {
        active:    { cls: 'badge badge-teal',    label: 'Active' },
        available: { cls: 'badge badge-info',     label: 'Available' },
        completed: { cls: 'badge badge-gray',     label: 'Completed' },
        pending:   { cls: 'badge badge-warning',  label: 'Pending' },
        expired:   { cls: 'badge badge-danger',   label: 'Expired' },
    };
    return map[s] || { cls: 'badge badge-gray', label: props.record.status };
});
</script>

<template>
    <Link
        :href="recordLink"
        :class="isDark
            ? 'border-[#334155]/40 bg-[#0F172A]/60 hover:bg-[#1E293B]/80'
            : 'border-transparent bg-[#F8FAFC] hover:bg-[#F1F5F9] hover:border-[#E5E7EB]'"
        class="group flex items-center gap-3.5 rounded-xl border p-3.5 transition-all duration-200"
    >
        <!-- Icon -->
        <div
            :class="iconMeta.bg"
            class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl transition-transform duration-200 group-hover:scale-105"
        >
            <svg :class="iconMeta.color" class="h-4.5 w-4.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="iconMeta.path" />
        </div>

        <!-- Text -->
        <div class="min-w-0 flex-1">
            <h4 :class="isDark ? 'text-[#E2E8F0]' : 'text-[#0F172A]'" class="mb-0.5 truncate text-sm font-semibold">
                {{ record.title }}
            </h4>
            <p :class="isDark ? 'text-[#475569]' : 'text-[#94A3B8]'" class="truncate text-xs">
                {{ record.doctor }} &nbsp;·&nbsp; {{ record.date }}
            </p>
        </div>

        <!-- Status badge -->
        <span :class="statusMeta.cls" class="shrink-0">
            {{ statusMeta.label }}
        </span>
    </Link>
</template>
