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
    <label v-if="label" class="mb-2 block text-sm font-semibold text-white">
      {{ label }}
    </label>

    <div class="relative">
      <!-- Input field -->
      <input
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        class="glass-input w-full rounded-2xl border border-white/20 bg-white/5 backdrop-blur-sm px-6 py-4 text-white placeholder-white/60 transition-all duration-300 focus:border-white/40 focus:outline-none focus:ring-4 focus:ring-white/20 focus:bg-white/10 hover:border-white/30 hover:bg-white/5"
        :class="[
          { 'border-red-400/60 focus:border-red-400 focus:ring-red-400/20': error },
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
    <span v-if="error" class="mt-1 block text-sm text-red-400">{{ error }}</span>
  </div>
</template>