<template>
  <div class="min-h-screen bg-gray-50 p-8">
    <div class="max-w-4xl mx-auto">
      <h1 class="text-4xl font-bold text-gray-800 mb-4">Dashboard Test Page</h1>
      <p class="text-lg text-gray-600 mb-8">If you can see this, the routing is working! ✅</p>
      
      <div class="bg-white rounded-xl p-6 shadow-sm border border-gray-200">
        <h2 class="text-2xl font-semibold text-gray-800 mb-4">Next Steps:</h2>
        <ol class="list-decimal list-inside space-y-2 text-gray-700">
          <li>This test page confirms routing works</li>
          <li>The full interactive dashboard is at the same route</li>
          <li>Check browser console (F12) for any errors</li>
          <li>Make sure all dependencies are installed: <code class="bg-gray-100 px-2 py-1 rounded">npm install</code></li>
        </ol>
      </div>

      <div class="mt-8 bg-blue-50 border border-blue-200 rounded-xl p-6">
        <h3 class="text-lg font-semibold text-blue-800 mb-2">Quick Links:</h3>
        <div class="space-y-2">
          <router-link to="/" class="block text-blue-600 hover:text-blue-700">← Back to Home</router-link>
          <router-link to="/profile" class="block text-blue-600 hover:text-blue-700">Go to Profile</router-link>
          <router-link to="/appointments" class="block text-blue-600 hover:text-blue-700">Go to Appointments</router-link>
        </div>
      </div>

      <div class="mt-8 bg-green-50 border border-green-200 rounded-xl p-6">
        <h3 class="text-lg font-semibold text-green-800 mb-2">✅ What's Working:</h3>
        <ul class="list-disc list-inside space-y-1 text-green-700">
          <li>Vue Router</li>
          <li>Tailwind CSS</li>
          <li>Component rendering</li>
          <li>Navigation</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
// Simple test component - no complex logic
console.log('Dashboard Test component loaded successfully!')
</script>
