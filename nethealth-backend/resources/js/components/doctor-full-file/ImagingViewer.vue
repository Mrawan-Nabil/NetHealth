<script setup>
import { computed, ref } from 'vue';
import ViewerThumbnailStrip from './ViewerThumbnailStrip.vue';

defineProps({ image: { type: String, required: true }, pages: { type: Number, required: true }, currentPage: { type: Number, required: true }, thumbnails: { type: Array, required: true }, activeThumb: { type: Number, required: true } });
defineEmits(['thumbnail']);

const zoom = ref(1);
const rotation = ref(0);
const isPlaying = ref(false);
const viewerRef = ref(null);

const imageStyle = computed(() => ({
    transform: `scale(${zoom.value}) rotate(${rotation.value}deg)`,
}));

const zoomOut = () => {
    zoom.value = Math.max(0.75, Number((zoom.value - 0.1).toFixed(2)));
};

const zoomIn = () => {
    zoom.value = Math.min(1.4, Number((zoom.value + 0.1).toFixed(2)));
};

const rotate = () => {
    rotation.value = (rotation.value + 90) % 360;
};

const resetView = () => {
    zoom.value = 1;
    rotation.value = 0;
};

const togglePlayback = () => {
    isPlaying.value = !isPlaying.value;
};

const openFullscreen = () => {
    viewerRef.value?.requestFullscreen?.();
};
</script>
<template>
    <section>
        <div ref="viewerRef" class="overflow-hidden rounded-2xl border border-slate-700 bg-slate-950 text-slate-200 shadow-sm">
            <div class="flex items-center justify-between border-b border-slate-800 px-3 py-2 text-xs">
                <div class="flex items-center gap-2">
                    <button type="button" class="rounded-md p-1 transition hover:bg-slate-800 focus-visible:ring-2 focus-visible:ring-teal-400/40 focus-visible:outline-none" @click="zoomOut"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 9H9m6 6H9m10-3a8 8 0 1 1-16 0 8 8 0 0 1 16 0Z" /></svg></button>
                    <button type="button" class="rounded-md p-1 transition hover:bg-slate-800 focus-visible:ring-2 focus-visible:ring-teal-400/40 focus-visible:outline-none" @click="zoomIn"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M9 12h6M12 9v6m7-3a8 8 0 1 1-16 0 8 8 0 0 1 16 0Z" /></svg></button>
                    <button type="button" class="rounded-md p-1 transition hover:bg-slate-800 focus-visible:ring-2 focus-visible:ring-teal-400/40 focus-visible:outline-none" @click="rotate"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 12a8 8 0 1 0 2.3-5.7M4 4v4h4" /></svg></button>
                    <button type="button" class="rounded-md p-1 transition hover:bg-slate-800 focus-visible:ring-2 focus-visible:ring-teal-400/40 focus-visible:outline-none" @click="resetView"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 3v18M3 12h18" /></svg></button>
                    <span class="hidden text-slate-500 sm:inline">{{ Math.round(zoom * 100) }}%</span>
                </div>
                <div class="inline-flex items-center gap-3">
                    <span>Page {{ currentPage }} of {{ pages }}</span>
                    <button type="button" class="rounded-md p-1 transition hover:bg-slate-800 focus-visible:ring-2 focus-visible:ring-teal-400/40 focus-visible:outline-none" @click="openFullscreen"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 3H3v5M16 3h5v5M8 21H3v-5M21 21h-5v-5" /></svg></button>
                </div>
            </div>
            <div class="overflow-hidden p-3"><img :src="image" class="h-[320px] w-full rounded-xl object-cover transition-transform duration-200 sm:h-[430px]" :style="imageStyle" /></div>
            <div class="px-3 pb-3">
                <div class="flex items-center gap-2 text-xs text-slate-400">
                    <button type="button" class="rounded-md p-1 transition hover:bg-slate-800 focus-visible:ring-2 focus-visible:ring-teal-400/40 focus-visible:outline-none" @click="togglePlayback">
                        <svg v-if="!isPlaying" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="m8 5 10 7-10 7V5Z" /></svg>
                        <svg v-else class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 5h3v14H8zM13 5h3v14h-3z" /></svg>
                    </button>
                    <div class="h-1.5 flex-1 rounded-full bg-slate-800"><div class="h-1.5 rounded-full bg-teal-500 transition-all duration-200" :class="isPlaying ? 'w-3/4' : 'w-1/2'" /></div>
                    <span>Series 2/4</span>
                </div>
            </div>
        </div>
        <ViewerThumbnailStrip :thumbnails="thumbnails" :active-index="activeThumb" @select="$emit('thumbnail', $event)" />
    </section>
</template>
