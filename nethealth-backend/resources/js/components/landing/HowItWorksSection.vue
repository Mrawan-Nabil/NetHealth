<script setup>
const steps = [
  {
    title: 'Create an Account',
    description: 'Sign up in minutes with your email. Choose whether you’re a patient, doctor, clinic, or pharmacy to get the right experience.',
    icon: 'account',
  },
  {
    title: 'Choose Your Role',
    description: 'Pick the account type that fits you. We’ll guide you through a simple setup so you’re ready to use the platform.',
    icon: 'role',
  },
  {
    title: 'Start Managing Healthcare Digitally',
    description: 'Book appointments, manage records, connect with providers, or run your practice—all from one secure place.',
    icon: 'start',
  },
]
</script>



<template>
  <section id="how-it-works" ref="howItWorksSection" class="py-16 sm:py-20 lg:py-24">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <h2 class="text-center text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
        How It <span class="text-primary">Works?</span>
      </h2>

      <div class="mt-12 grid grid-cols-1 gap-10 sm:grid-cols-3 lg:gap-12">
        <article v-for="(step, index) in steps" :key="index" class="group flex flex-col items-center text-center">
          <div class="mb-6 flex h-24 w-24 shrink-0 items-center justify-center rounded-full bg-primary p-6 text-white transition-all duration-500 ease-out group-hover:scale-110 group-hover:rotate-6 group-hover:shadow-2xl"aria-hidden="true">
            <!-- Create account / user-plus -->
            <svg v-if="step.icon === 'account'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
            </svg>
            <!-- Choose role / badge -->
            <svg v-else-if="step.icon === 'role'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 00-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
            </svg>
            <!-- Start / rocket -->
            <svg v-else-if="step.icon === 'start'" class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
          <h3 class="text-lg font-bold text-gray-900">
            {{ step.title }}
          </h3>
          <p class="mt-2 max-w-sm text-sm text-gray-600">
            {{ step.description }}
          </p>
        </article>
      </div>
    </div>
  </section>
</template>
