<template>
  <div class="space-y-4">
    <!-- Main Viewer -->
    <div class="bg-[#1A1F2E] rounded-lg overflow-hidden relative" style="aspect-ratio: 16/10;">
      <!-- Viewer Controls -->
      <div class="absolute top-4 left-4 right-4 flex items-center justify-between z-10">
        <div class="flex items-center gap-2">
          <button 
            @click="zoomIn"
            class="w-9 h-9 bg-[#2A3142] hover:bg-[#353B4F] rounded-lg flex items-center justify-center transition-colors"
            title="Zoom In"
          >
            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"/>
            </svg>
          </button>
          <button 
            @click="zoomOut"
            class="w-9 h-9 bg-[#2A3142] hover:bg-[#353B4F] rounded-lg flex items-center justify-center transition-colors"
            title="Zoom Out"
          >
            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM13 10H7"/>
            </svg>
          </button>
          <button 
            @click="resetView"
            class="w-9 h-9 bg-[#2A3142] hover:bg-[#353B4F] rounded-lg flex items-center justify-center transition-colors"
            title="Reset View"
          >
            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
            </svg>
          </button>
          <button 
            @click="toggleBrightness"
            class="w-9 h-9 bg-[#2A3142] hover:bg-[#353B4F] rounded-lg flex items-center justify-center transition-colors"
            title="Toggle Brightness"
          >
            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
            </svg>
          </button>
        </div>

        <div class="flex items-center gap-2">
          <span class="text-white text-xs font-medium px-3 py-1.5 bg-[#2A3142] rounded-lg">
            Page {{ currentPage }} of {{ totalPages }}
          </span>
          <button 
            @click="toggleFullscreen"
            class="w-9 h-9 bg-[#2A3142] hover:bg-[#353B4F] rounded-lg flex items-center justify-center transition-colors"
            title="Fullscreen"
          >
            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- Patient Info Overlay -->
      <div class="absolute top-4 left-4 text-[#14B8A6] font-mono text-[10px] leading-relaxed z-10">
        <div>PATIENT: JOHN DOE</div>
        <div>ID: 123-45-67</div>
        <div>DOB: 12-05-1985</div>
      </div>

      <!-- Scan Info Overlay -->
      <div class="absolute bottom-20 right-4 text-[#14B8A6] font-mono text-[10px] leading-relaxed text-right z-10">
        <div>SLICE: {{ currentSlice }}/128</div>
        <div>FOV: 350MM</div>
        <div>WL: {{ windowLevel }} WW: {{ windowWidth }}</div>
      </div>

      <!-- Main Image Container -->
      <div 
        ref="imageContainer"
        class="w-full h-full flex items-center justify-center p-12 cursor-move"
        @mousedown="startPan"
        @mousemove="pan"
        @mouseup="endPan"
        @mouseleave="endPan"
        @wheel="handleWheel"
      >
        <img 
          ref="mainImage"
          :src="currentImage" 
          alt="CT Scan"
          class="max-w-full max-h-full object-contain transition-transform duration-200"
          :style="{
            transform: `scale(${zoom}) translate(${panX}px, ${panY}px)`,
            filter: `brightness(${brightness}%)`
          }"
          draggable="false"
        />
      </div>

      <!-- Playback Controls -->
      <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-4">
        <div class="flex items-center gap-3">
          <button 
            @click="togglePlay"
            class="w-8 h-8 flex items-center justify-center text-white hover:text-[#14B8A6] transition-colors"
          >
            <svg v-if="!isPlaying" class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M8 5v14l11-7z"/>
            </svg>
            <svg v-else class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M6 4h4v16H6V4zm8 0h4v16h-4V4z"/>
            </svg>
          </button>
          <div 
            class="flex-1 h-1 bg-[#2A3142] rounded-full overflow-hidden cursor-pointer"
            @click="seekTo"
            ref="progressBar"
          >
            <div class="h-full bg-[#14B8A6] transition-all" :style="{ width: `${progress}%` }"></div>
          </div>
          <span class="text-white text-xs font-medium">SERIES {{ currentSeries }}/4</span>
        </div>
      </div>
    </div>

    <!-- Thumbnail Strip -->
    <div class="flex items-center gap-6 overflow-x-auto pb-2">
      <div 
        v-for="(image, index) in images" 
        :key="image.id"
        @click="selectImage(index)"
        class="w-56 h-40 cursor-pointer transition-all flex-shrink-0 relative"
        :style="{
          opacity: activeImageIndex === index ? 1 : 0.7
        }"
      >
        <!-- Custom Corner Borders -->
        <div 
          :class="[
            'absolute inset-0 pointer-events-none',
            activeImageIndex === index ? 'opacity-100' : 'opacity-0'
          ]"
          class="transition-opacity duration-300"
        >
          <!-- Top-left corner -->
          <div class="absolute top-0 left-0 w-12 h-12 border-t-2 border-l-2 border-[#14B8A6]"></div>
          <!-- Bottom-right corner -->
          <div class="absolute bottom-0 right-0 w-12 h-12 border-b-2 border-r-2 border-[#14B8A6]"></div>
        </div>
        
        <div class="w-full h-full bg-[#1E293B] flex items-center justify-center">
          <span class="text-[#14B8A6] text-4xl font-bold">Slice {{ index + 1 }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  images: {
    type: Array,
    required: true
  },
  isDark: {
    type: Boolean,
    default: false
  }
})

// Refs
const imageContainer = ref(null)
const mainImage = ref(null)
const progressBar = ref(null)

// State
const activeImageIndex = ref(0)
const zoom = ref(1)
const panX = ref(0)
const panY = ref(0)
const isPanning = ref(false)
const startX = ref(0)
const startY = ref(0)
const brightness = ref(100)
const isPlaying = ref(false)
const currentPage = ref(1)
const totalPages = ref(12)
const currentSlice = ref(14)
const windowLevel = ref(40)
const windowWidth = ref(400)
const currentSeries = ref(2)
const playInterval = ref(null)

// Computed
const currentImage = computed(() => {
  return `https://placehold.co/600x400/1A1F2E/14B8A6?text=CT+Scan+Image`
})

const progress = computed(() => {
  return (activeImageIndex.value / (props.images.length - 1)) * 100
})

// Methods
const zoomIn = () => {
  zoom.value = Math.min(zoom.value + 0.2, 3)
}

const zoomOut = () => {
  zoom.value = Math.max(zoom.value - 0.2, 0.5)
}

const resetView = () => {
  zoom.value = 1
  panX.value = 0
  panY.value = 0
  brightness.value = 100
}

const toggleBrightness = () => {
  brightness.value = brightness.value === 100 ? 150 : brightness.value === 150 ? 75 : 100
}

const startPan = (e) => {
  isPanning.value = true
  startX.value = e.clientX - panX.value
  startY.value = e.clientY - panY.value
}

const pan = (e) => {
  if (!isPanning.value) return
  panX.value = e.clientX - startX.value
  panY.value = e.clientY - startY.value
}

const endPan = () => {
  isPanning.value = false
}

const handleWheel = (e) => {
  e.preventDefault()
  if (e.deltaY < 0) {
    zoomIn()
  } else {
    zoomOut()
  }
}

const selectImage = (index) => {
  activeImageIndex.value = index
  currentSlice.value = 14 + index * 10
}

const togglePlay = () => {
  isPlaying.value = !isPlaying.value
  
  if (isPlaying.value) {
    playInterval.value = setInterval(() => {
      activeImageIndex.value = (activeImageIndex.value + 1) % props.images.length
      currentSlice.value = 14 + activeImageIndex.value * 10
    }, 500)
  } else {
    if (playInterval.value) {
      clearInterval(playInterval.value)
      playInterval.value = null
    }
  }
}

const seekTo = (e) => {
  const rect = progressBar.value.getBoundingClientRect()
  const x = e.clientX - rect.left
  const percentage = x / rect.width
  const newIndex = Math.floor(percentage * props.images.length)
  activeImageIndex.value = Math.max(0, Math.min(newIndex, props.images.length - 1))
  currentSlice.value = 14 + activeImageIndex.value * 10
}

const toggleFullscreen = () => {
  if (!document.fullscreenElement) {
    imageContainer.value?.parentElement?.requestFullscreen()
  } else {
    document.exitFullscreen()
  }
}

// Cleanup
onUnmounted(() => {
  if (playInterval.value) {
    clearInterval(playInterval.value)
  }
})
</script>
