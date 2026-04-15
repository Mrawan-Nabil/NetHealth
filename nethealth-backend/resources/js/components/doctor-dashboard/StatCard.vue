<script setup lang="ts">
defineProps<{
    title: string;
    value: string;
    subtitle: string;
    icon: 'calendar' | 'file' | 'users' | 'check';
    accent?: 'teal' | 'rose' | 'emerald' | 'amber';
    urgent?: boolean;
}>();

const accentMap = {
    teal:    { bg: 'bg-blue-50    dark:bg-blue-500/15',    color: 'text-blue-500    dark:text-blue-400' },
    rose:    { bg: 'bg-violet-50  dark:bg-violet-500/15',  color: 'text-violet-500  dark:text-violet-400' },
    emerald: { bg: 'bg-emerald-50 dark:bg-emerald-500/15', color: 'text-emerald-500 dark:text-emerald-400' },
    amber:   { bg: 'bg-amber-50   dark:bg-amber-500/15',   color: 'text-amber-500   dark:text-amber-400' },
};

// All paths kept safely within the 0 0 24 24 viewBox
const iconPaths: Record<string, string[]> = {
    calendar: [
        'M8 7V4m8 3V4m-9 5h10M5 21h14a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2Z',
    ],
    file: [
        'M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9L14 3Z',
        'M14 3v6h6',
        'M16 13H8M16 17H8M10 9H8',
    ],
    users: [
        'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
        'M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8Z',
        'M22 21v-2a4 4 0 0 0-3-3.87',
        'M16 3.13a4 4 0 0 1 0 7.75',
    ],
    check: [
        'M20 7 9 18l-5-5',
    ],
};
</script>

<template>
    <article
        class="group dash-card rounded-2xl border border-[#E5E7EB] bg-white p-5 select-none dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="mb-4 flex items-center justify-between">
            <!-- Icon badge — overflow-hidden prevents scale clipping -->
            <div
                :class="accentMap[accent ?? 'teal'].bg"
                class="flex h-10 w-10 shrink-0 items-center justify-center overflow-hidden rounded-xl"
            >
                <svg
                    :class="accentMap[accent ?? 'teal'].color"
                    class="h-5 w-5"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="1.75"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                >
                    <path v-for="(d, i) in iconPaths[icon]" :key="i" :d="d" />
                </svg>
            </div>

            <!-- Status badge -->
            <div
                v-if="urgent"
                class="flex items-center gap-0.5 rounded-full bg-red-50 px-2 py-0.5 text-[10px] font-semibold text-red-500 dark:bg-red-500/15 dark:text-red-400"
            >
                Urgent
            </div>
            <div
                v-else
                class="flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-0.5 text-[10px] font-semibold text-emerald-600 dark:bg-emerald-500/15 dark:text-emerald-400"
            >
                <svg class="h-2.5 w-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 15l7-7 7 7" />
                </svg>
                Active
            </div>
        </div>

        <p class="mb-0.5 text-3xl font-bold leading-none tracking-tight text-[#0F172A] dark:text-[#F1F5F9]">{{ value }}</p>
        <p class="mt-1 text-xs font-medium text-[#64748B] dark:text-[#94A3B8]">{{ title }} {{ subtitle }}</p>
    </article>
</template>
