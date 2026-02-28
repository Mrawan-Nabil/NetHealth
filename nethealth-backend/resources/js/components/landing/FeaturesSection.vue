<script setup>
const features = [
  {
    title: 'Easy Appointment Booking',
    subtitle: 'Schedule visits with doctors in a few clicks. View availability, pick a slot, and get reminders—no phone tag.',
    icon: 'calendar',
  },
  {
    title: 'Secure Medical Records',
    subtitle: 'Your health data is encrypted and stored safely. Access your history anytime and share only what you choose.',
    icon: 'shield',
  },
  {
    title: 'Connect with Doctors',
    subtitle: 'Find verified providers, read profiles and reviews, and start your care journey from one place.',
    icon: 'users',
  },
  {
    title: '24/7 Access',
    subtitle: 'Manage prescriptions, view results, and message your care team whenever it works for you.',
    icon: 'clock',
  },
]
</script>


<template>
  <section id="features" ref="featuresSection" class="py-16 sm:py-20 lg:py-24">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <h2 class="text-center text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
        Why Choose <span class="text-primary">Our Platform?</span>
      </h2>

      <div class="mt-12 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
        <article
          v-for="(feature, index) in features" :key="index" class="rounded-xl bg-white p-6 shadow-[0_2px_8px_rgba(0,0,0,0.06)] sm:p-8transform transition duration-300 hover:-translate-y-2 hover:shadow-lg hover:bg-primary/5">
          <div
            class="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10 text-primary"
            aria-hidden="true"
          >
            <!-- Calendar -->
            <svg v-if="feature.icon === 'calendar'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            <!-- Shield -->
            <svg v-else-if="feature.icon === 'shield'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
            <!-- Users -->
            <svg v-else-if="feature.icon === 'users'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
            <!-- Clock -->
            <svg v-else-if="feature.icon === 'clock'" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h3 class="text-lg font-bold text-gray-900">
            {{ feature.title }}
          </h3>
          <p class="mt-2 text-sm text-gray-600">
            {{ feature.subtitle }}
          </p>
        </article>
      </div>
    </div>
  </section>
</template>
