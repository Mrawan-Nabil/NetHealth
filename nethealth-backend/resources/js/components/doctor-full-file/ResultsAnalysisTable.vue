<script setup>
defineProps({ rows: { type: Array, required: true } });
</script>
<template>
    <section
        class="overflow-hidden rounded-2xl border border-[#F1F5F9] bg-white dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <header class="flex flex-wrap items-center justify-between gap-2 border-b border-[#F1F5F9] px-4 py-3 dark:border-[#334155]">
            <h4 class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">Results Analysis</h4>
            <div class="flex items-center gap-4 text-xs text-[#64748B] dark:text-[#94A3B8]">
                <span class="inline-flex items-center gap-1"><span class="h-2 w-2 rounded-full bg-emerald-500" />Normal</span>
                <span class="inline-flex items-center gap-1"><span class="h-2 w-2 rounded-full bg-amber-500" />Attention</span>
                <span class="inline-flex items-center gap-1"><span class="h-2 w-2 rounded-full bg-rose-500" />Critical</span>
            </div>
        </header>
        <div class="overflow-x-auto">
            <table class="min-w-full text-sm">
                <thead class="bg-[#F8FAFC] text-left text-xs uppercase tracking-wide text-[#64748B] dark:bg-[#0F172A] dark:text-[#94A3B8]">
                    <tr><th class="px-4 py-3">Parameter</th><th class="px-4 py-3">Result</th><th class="px-4 py-3">Unit</th><th class="px-4 py-3">Reference Range</th><th class="px-4 py-3">Status</th></tr>
                </thead>
                <tbody>
                    <tr v-for="row in rows" :key="row.parameter" class="border-t border-[#F1F5F9] dark:border-[#334155]">
                        <td class="px-4 py-3 font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ row.parameter }}</td>
                        <td class="px-4 py-3 font-bold" :class="row.status === 'High' ? 'text-red-500' : row.status === 'Low' ? 'text-amber-500' : 'text-[#0F172A] dark:text-[#F1F5F9]'">{{ row.result }}</td>
                        <td class="px-4 py-3 text-[#64748B] dark:text-[#94A3B8]">{{ row.unit }}</td>
                        <td class="px-4 py-3 text-[#64748B] dark:text-[#94A3B8]">{{ row.range }}</td>
                        <td class="px-4 py-3">
                            <span class="inline-flex items-center gap-1 font-semibold" :class="row.status === 'High' ? 'text-rose-500' : row.status === 'Low' ? 'text-amber-500' : 'text-emerald-500'">
                                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 8v8m0-8 4 4m-4-4-4 4" /></svg>
                                {{ row.status }}
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>
</template>
