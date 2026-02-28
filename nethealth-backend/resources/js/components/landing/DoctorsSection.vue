<script setup>
const doctors = [
  { name: 'Dr. Sarah Hassan', specialty: 'Cardiology',image:'https://images.unsplash.com/photo-1614608682850-e0d6ed316d47?w=400&h=400&fit=crop' },
  { name: 'Dr. Omar Khalil', specialty: 'General Practice',image:'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&h=400&fit=crop' },
  { name: 'Dr. Layla Mahmoud', specialty: 'Pediatrics',image:'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop' },
  { name: 'Dr. Ahmed Fathy', specialty: 'Orthopedics', image:'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop'},
]
</script>

<template>
  <section id="about" ref="aboutSection" class="py-16 sm:py-20 lg:py-24">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <h2  class="text-center text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
        Meet Our <span class="text-primary">Certified Doctors</span>
      </h2>

      <div class="mt-12 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
        <article v-for="(doctor, index) in doctors" :key="index" class="group overflow-hidden rounded-xl bg-white shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-all duration-500 ease-out hover:-translate-y-3 hover:shadow-2xl">
          <!-- Top half: portrait placeholder on soft green -->
          <div class="relative flex aspect-4/5 items-center justify-center bg-primary/10 overflow-hidden">
  <img :src="doctor.image" class="w-full h-full object-cover transition-transform duration-700 ease-out group-hover:scale-110" :alt="doctor.name" />

  <!-- Overlay -->
  <div class="absolute inset-0 bg-black/0
              transition duration-500
              group-hover:bg-black/10">
  </div>
</div>
          <!-- Bottom half: name, specialty, rating -->
          <div class="p-5">
            <h3 class="font-bold text-gray-900">
              {{ doctor.name }}
            </h3>
            <p class="mt-1 text-sm text-gray-600">
              {{ doctor.specialty }}
            </p>
            <div class="mt-3 flex items-center gap-0.5 text-yellow-400 transition duration-300 group-hover:scale-110">
              <svg v-for="i in 5" :key="i" class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
               <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
            </div>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>
