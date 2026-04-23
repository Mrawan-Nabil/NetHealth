<script setup>
    defineProps({
    title: {
    type: String,
    required: true
},
    subtitle: {
    type: String,
    required: true
},
    icon: {
    type: String,
    required: true,
    // This replaces the TS union type to ensure only valid icons are passed
    validator: (value) => ['education', 'certification', 'availability'].includes(value)
},
});
</script>

<template>
    <article class="rounded-lg bg-[#F8FAFC] p-3 transition-all duration-200 hover:bg-[#F1F5F9] dark:bg-[#0F172A] dark:hover:bg-[#334155]/40">
        <div class="flex items-start gap-2.5">
            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-white text-[#14B8A6] shadow-sm dark:bg-[#1E293B] dark:text-[#2DD4BF]">
                <svg v-if="icon === 'education'" class="h-4.5 w-4.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m3 8.5 9-4.5 9 4.5-9 4.5-9-4.5Zm2 3.5v4l7 3.5 7-3.5v-4" />
                </svg>
                <svg v-else-if="icon === 'certification'" class="h-4.5 w-4.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3.5 4.5 7v5c0 4.3 2.9 7.9 7.5 8.8 4.6-.9 7.5-4.5 7.5-8.8V7L12 3.5Zm-2 8.5 1.5 1.5L14.5 10" />
                </svg>
                <svg v-else class="h-4.5 w-4.5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6l4 2m5-2a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                </svg>
            </span>
            <div>
                <p class="text-xs font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ title }}</p>
                <p class="text-[11px] text-[#64748B] dark:text-[#94A3B8]">{{ subtitle }}</p>
            </div>
        </div>
    </article>
</template>
