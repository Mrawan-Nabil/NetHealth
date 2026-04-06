<script setup>
import { ref, computed, onUnmounted } from 'vue';

const props = defineProps({
    images: {
        type: Array,
        required: true,
        default: () => [],
    },
    isDark: {
        type: Boolean,
        default: false,
    },
});

// Refs
const imageContainer = ref(null);
const mainImage = ref(null);
const progressBar = ref(null);

// State
const activeImageIndex = ref(0);
const zoom = ref(1);
const panX = ref(0);
const panY = ref(0);
const isPanning = ref(false);
const startX = ref(0);
const startY = ref(0);
const brightness = ref(100);
const isPlaying = ref(false);
const playInterval = ref(null);

// UI Overlays (Calculated dynamically or kept generic)
const windowLevel = ref(40);
const windowWidth = ref(400);

// Computed
const currentImage = computed(() => {
    // Dynamically pull the active image URL from the prop
    if (!props.images || props.images.length === 0) return '';
    return props.images[activeImageIndex.value]?.url || '';
});

const progress = computed(() => {
    // Safeguard against division by zero if there is only 1 image
    if (props.images.length <= 1) return 100;
    return (activeImageIndex.value / (props.images.length - 1)) * 100;
});

const currentSliceDisplay = computed(() => {
    // Start at an arbitrary slice number for the medical aesthetic
    return 14 + activeImageIndex.value * 10;
});

// Methods
const zoomIn = () => {
    zoom.value = Math.min(zoom.value + 0.2, 3);
};

const zoomOut = () => {
    zoom.value = Math.max(zoom.value - 0.2, 0.5);
};

const resetView = () => {
    zoom.value = 1;
    panX.value = 0;
    panY.value = 0;
    brightness.value = 100;
};

const toggleBrightness = () => {
    brightness.value = brightness.value === 100 ? 150 : brightness.value === 150 ? 75 : 100;
};

const startPan = (e) => {
    isPanning.value = true;
    startX.value = e.clientX - panX.value;
    startY.value = e.clientY - panY.value;
};

const pan = (e) => {
    if (!isPanning.value) return;
    panX.value = e.clientX - startX.value;
    panY.value = e.clientY - startY.value;
};

const endPan = () => {
    isPanning.value = false;
};

const handleWheel = (e) => {
    e.preventDefault();
    if (e.deltaY < 0) {
        zoomIn();
    } else {
        zoomOut();
    }
};

const selectImage = (index) => {
    activeImageIndex.value = index;
};

const togglePlay = () => {
    // Don't play if there's only 1 image
    if (props.images.length <= 1) return;

    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
        playInterval.value = setInterval(() => {
            activeImageIndex.value = (activeImageIndex.value + 1) % props.images.length;
        }, 500);
    } else {
        if (playInterval.value) {
            clearInterval(playInterval.value);
            playInterval.value = null;
        }
    }
};

const seekTo = (e) => {
    if (props.images.length <= 1) return;

    const rect = progressBar.value.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const percentage = x / rect.width;
    const newIndex = Math.floor(percentage * props.images.length);
    activeImageIndex.value = Math.max(0, Math.min(newIndex, props.images.length - 1));
};

const toggleFullscreen = () => {
    if (!document.fullscreenElement) {
        imageContainer.value?.parentElement?.requestFullscreen();
    } else {
        document.exitFullscreen();
    }
};

// Cleanup
onUnmounted(() => {
    if (playInterval.value) {
        clearInterval(playInterval.value);
    }
});
</script>

<template>
    <div class="space-y-4">
        <div class="relative overflow-hidden rounded-lg bg-[#1A1F2E]" style="aspect-ratio: 16/10">
            <div class="absolute top-4 right-4 left-4 z-10 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <button
                        @click="zoomIn"
                        class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#2A3142] transition-colors hover:bg-[#353B4F]"
                        title="Zoom In"
                    >
                        <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"
                            />
                        </svg>
                    </button>
                    <button
                        @click="zoomOut"
                        class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#2A3142] transition-colors hover:bg-[#353B4F]"
                        title="Zoom Out"
                    >
                        <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM13 10H7"
                            />
                        </svg>
                    </button>
                    <button
                        @click="resetView"
                        class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#2A3142] transition-colors hover:bg-[#353B4F]"
                        title="Reset View"
                    >
                        <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                            />
                        </svg>
                    </button>
                    <button
                        @click="toggleBrightness"
                        class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#2A3142] transition-colors hover:bg-[#353B4F]"
                        title="Toggle Brightness"
                    >
                        <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
                            />
                        </svg>
                    </button>
                </div>

                <div class="flex items-center gap-2">
                    <span class="rounded-lg bg-[#2A3142] px-3 py-1.5 text-xs font-medium text-white">
                        Page {{ activeImageIndex + 1 }} of {{ Math.max(images.length, 1) }}
                    </span>
                    <button
                        @click="toggleFullscreen"
                        class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#2A3142] transition-colors hover:bg-[#353B4F]"
                        title="Fullscreen"
                    >
                        <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"
                            />
                        </svg>
                    </button>
                </div>
            </div>

            <div class="pointer-events-none absolute right-4 bottom-20 z-10 text-right font-mono text-[10px] leading-relaxed text-[#14B8A6]">
                <div>SLICE: {{ currentSliceDisplay }}/128</div>
                <div>FOV: 350MM</div>
                <div>WL: {{ windowLevel }} WW: {{ windowWidth }}</div>
            </div>

            <div
                ref="imageContainer"
                class="flex h-full w-full cursor-move items-center justify-center p-12"
                @mousedown="startPan"
                @mousemove="pan"
                @mouseup="endPan"
                @mouseleave="endPan"
                @wheel="handleWheel"
            >
                <img
                    v-if="currentImage"
                    ref="mainImage"
                    :src="currentImage"
                    alt="Scan Viewer"
                    class="max-h-full max-w-full object-contain transition-transform duration-200"
                    :style="{
                        transform: `scale(${zoom}) translate(${panX}px, ${panY}px)`,
                        filter: `brightness(${brightness}%)`,
                    }"
                    draggable="false"
                />
                <div v-else class="text-sm font-medium text-[#94A3B8]">No image file available.</div>
            </div>

            <div class="absolute right-0 bottom-0 left-0 bg-gradient-to-t from-black/80 to-transparent p-4">
                <div class="flex items-center gap-3">
                    <button
                        @click="togglePlay"
                        :disabled="images.length <= 1"
                        :class="images.length <= 1 ? 'cursor-not-allowed opacity-50' : 'transition-colors hover:text-[#14B8A6]'"
                        class="flex h-8 w-8 items-center justify-center text-white"
                    >
                        <svg v-if="!isPlaying" class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M8 5v14l11-7z" />
                        </svg>
                        <svg v-else class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M6 4h4v16H6V4zm8 0h4v16h-4V4z" />
                        </svg>
                    </button>
                    <div
                        class="h-1 flex-1 overflow-hidden rounded-full bg-[#2A3142]"
                        :class="images.length > 1 ? 'cursor-pointer' : ''"
                        @click="seekTo"
                        ref="progressBar"
                    >
                        <div class="h-full bg-[#14B8A6] transition-all duration-200" :style="{ width: `${progress}%` }"></div>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="images && images.length > 0" class="flex items-center gap-6 overflow-x-auto pb-2">
            <div
                v-for="(image, index) in images"
                :key="image.id || index"
                @click="selectImage(index)"
                class="relative h-40 w-56 flex-shrink-0 cursor-pointer transition-all"
                :style="{ opacity: activeImageIndex === index ? 1 : 0.7 }"
            >
                <div
                    :class="['pointer-events-none absolute inset-0 z-10', activeImageIndex === index ? 'opacity-100' : 'opacity-0']"
                    class="transition-opacity duration-300"
                >
                    <div class="absolute top-0 left-0 h-12 w-12 border-t-2 border-l-2 border-[#14B8A6]"></div>
                    <div class="absolute right-0 bottom-0 h-12 w-12 border-r-2 border-b-2 border-[#14B8A6]"></div>
                </div>

                <div class="relative flex h-full w-full items-center justify-center overflow-hidden rounded-sm bg-[#1E293B]">
                    <img :src="image.url" class="absolute inset-0 h-full w-full object-cover opacity-40 mix-blend-luminosity" />
                    <span class="relative z-10 rounded bg-[#1A1F2E]/80 px-3 py-1 text-xl font-bold text-[#14B8A6]">Slice {{ index + 1 }}</span>
                </div>
            </div>
        </div>
    </div>
</template>
