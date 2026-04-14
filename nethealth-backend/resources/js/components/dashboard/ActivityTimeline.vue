<script setup>
defineProps({
    activities: { type: Array, required: true },
    isDark:     Boolean,
});

const activityMeta = (type) => {
    const map = {
        appointment: { bg: 'bg-[#14B8A6]', text: 'Appointment',  ring: 'ring-[#14B8A6]/20' },
        test:        { bg: 'bg-blue-500',   text: 'Test result',  ring: 'ring-blue-500/20'   },
        prescription:{ bg: 'bg-amber-400',  text: 'Prescription', ring: 'ring-amber-400/20'  },
        imaging:     { bg: 'bg-violet-500', text: 'Imaging',      ring: 'ring-violet-500/20' },
    };
    return map[type] || { bg: 'bg-slate-400', text: 'Activity', ring: 'ring-slate-400/20' };
};
</script>

<template>
    <div
        :class="isDark ? 'border-[#1E293B] bg-[#1E293B]' : 'border-[#F1F5F9] bg-white'"
        class="dash-card border p-6"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="mb-5 flex items-center gap-2">
            <span
                :class="isDark ? 'bg-blue-500/10' : 'bg-blue-50'"
                class="flex h-7 w-7 items-center justify-center rounded-lg"
            >
                <svg class="h-4 w-4 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </span>
            <h3 :class="isDark ? 'text-[#F1F5F9]' : 'text-[#0F172A]'" class="text-sm font-semibold">
                Recent Activity
            </h3>
        </div>

        <div v-if="activities.length > 0" class="relative space-y-0">
            <!-- Vertical line -->
            <div
                class="absolute top-2 bottom-2 left-[9px] w-px"
                :class="isDark ? 'bg-[#334155]' : 'bg-[#F1F5F9]'"
            />

            <div
                v-for="(activity, index) in activities"
                :key="index"
                class="relative flex items-start gap-4 pb-4 last:pb-0"
                :class="`animate-fadeInUp stagger-${Math.min(index + 1, 6)}`"
            >
                <!-- Dot -->
                <div class="relative z-10 mt-0.5 shrink-0">
                    <div
                        :class="[activityMeta(activity.type).bg, activityMeta(activity.type).ring]"
                        class="h-[18px] w-[18px] rounded-full ring-4"
                        style="box-shadow: 0 0 0 3px white;"
                    />
                </div>

                <!-- Content -->
                <div class="min-w-0 flex-1 pt-0">
                    <p :class="isDark ? 'text-[#CBD5E1]' : 'text-[#0F172A]'" class="text-xs font-semibold leading-snug">
                        {{ activity.title }}
                    </p>
                    <p :class="isDark ? 'text-[#475569]' : 'text-[#9CA3AF]'" class="mt-0.5 text-[11px]">
                        {{ activity.time }}
                    </p>
                </div>
            </div>
        </div>

        <div v-else class="py-6 text-center">
            <p :class="isDark ? 'text-[#475569]' : 'text-[#94A3B8]'" class="text-xs">No recent activity</p>
        </div>
    </div>
</template>
