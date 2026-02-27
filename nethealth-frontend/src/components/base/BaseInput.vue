<script setup>
defineProps({
  label: { type: String, default: '' },
  type: { type: String, default: 'text' },
  modelValue: { type: [String, Number], default: '' },
  placeholder: { type: String, default: '' },
  error: { type: String, default: '' },
})

const emit = defineEmits(['update:modelValue'])

function onInput(event) {
  emit('update:modelValue', event.target.value)
}
</script>

<template>
  <div class="w-full">
    <!-- Label -->
    <label v-if="label" class="mb-1.5 block text-sm font-medium text-gray-700">
      {{ label }}
    </label>

    <div class="relative">
      <!-- Input field -->
      <input
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        class="w-full rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-gray-900 placeholder-gray-500 transition-shadow focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/30"
        :class="[
          { 'border-red-500 focus:border-red-500 focus:ring-red-500/30': error },
          $slots.icon ? 'pr-16' : ''
        ]"
        @input="onInput"
      />

      <!-- Slot for custom icon or Show/Hide button -->
      <div
        v-if="$slots.icon"
        class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-auto"
      >
        <slot name="icon" />
      </div>
    </div>

    <!-- Error message -->
    <span v-if="error" class="mt-1 block text-sm text-red-500">{{ error }}</span>
  </div>
</template>