<script setup lang="ts">
defineProps<{ title: string; subtitle: string }>();
</script>

<template>
    <div class="space-y-1">
        <h3 class="text-3xl font-bold text-teal-900 dark:text-teal-200">{{ title }}</h3>
        <p class="text-lg text-slate-500 dark:text-slate-400">{{ subtitle }}</p>
    </div>
</template>
