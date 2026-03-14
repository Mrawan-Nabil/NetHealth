<script setup>
defineProps({
  label: { type: String, default: '' },
  modelValue: { type: [String, Number], default: '' },
  error: { type: String, default: '' },
  placeholder: { type: String, default: 'Select...' },
})

const emit = defineEmits(['update:modelValue'])

function onChange(event) {
  emit('update:modelValue', event.target.value)
}
</script>

<template>
  <div class="w-full">
    <label v-if="label" class="mb-2 block text-sm font-semibold text-white">
      {{ label }}
    </label>
    <div class="relative">
      <select
        :value="modelValue"
        class="glass-select w-full rounded-2xl border border-white/20 bg-white/5 backdrop-blur-sm px-6 py-4 pr-12 text-white focus:border-white/40 focus:outline-none focus:ring-4 focus:ring-white/20 focus:bg-white/10 hover:border-white/30 hover:bg-white/5 appearance-none cursor-pointer transition-all duration-300"
        :class="{ 'border-red-400/60 focus:border-red-400 focus:ring-red-400/20': error }"
        @change="onChange"
      >
        <option value="" disabled class="bg-gray-800 text-white">{{ placeholder }}</option>
        <slot />
      </select>
      <svg
        class="pointer-events-none absolute right-4 top-1/2 h-5 w-5 -translate-y-1/2 text-white/60 transition-all duration-300"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
      </svg>
    </div>
    <span v-if="error" class="mt-1 block text-sm text-red-400">{{ error }}</span>
  </div>
</template>
