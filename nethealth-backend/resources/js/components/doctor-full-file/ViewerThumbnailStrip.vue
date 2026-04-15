<script setup lang="ts">
import BaseBadge from './BaseBadge.vue';
defineProps<{ thumbnails: string[]; activeIndex: number }>();
defineEmits<{ (event: 'select', index: number): void }>();
</script>
<template>
    <div class="mt-3 flex gap-3 overflow-x-auto pb-1">
        <button v-for="(thumb, index) in thumbnails" :key="thumb" class="relative h-20 w-28 shrink-0 overflow-hidden rounded-xl border-2 bg-slate-900/90 transition-all duration-200" :class="index === activeIndex ? 'border-teal-400' : 'border-transparent hover:border-slate-300 dark:hover:border-slate-600'" @click="$emit('select', index)">
            <img :src="thumb" class="h-full w-full object-cover opacity-85" />
            <BaseBadge v-if="index === activeIndex" variant="info" class="absolute top-1 left-1">Current</BaseBadge>
        </button>
    </div>
</template>
