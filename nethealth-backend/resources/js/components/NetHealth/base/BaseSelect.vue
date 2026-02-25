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
    <label v-if="label" class="mb-1.5 block text-sm font-medium text-gray-700">
      {{ label }}
    </label>
    <div class="relative">
      <select
        :value="modelValue"
        class="w-full rounded-xl border border-gray-300 bg-white px-4 py-2.5 pr-10 text-gray-900 transition-shadow focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/30 appearance-none cursor-pointer"
        :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500/30': error }"
        @change="onChange"
      >
        <option value="" disabled>{{ placeholder }}</option>
        <slot />
      </select>
      <svg
        class="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-500"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
      </svg>
    </div>
    <span v-if="error" class="mt-1 block text-sm text-red-500">{{ error }}</span>
  </div>
</template>
