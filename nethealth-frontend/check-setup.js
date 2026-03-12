// Quick setup checker
const fs = require('fs');
const path = require('path');

console.log('🔍 Checking NetHealth Dashboard Setup...\n');

const checks = [
  { name: 'Node.js version', check: () => process.version, expected: 'v16+' },
  { name: 'package.json', check: () => fs.existsSync('package.json'), expected: true },
  { name: 'node_modules', check: () => fs.existsSync('node_modules'), expected: true },
  { name: 'src/main.js', check: () => fs.existsSync('src/main.js'), expected: true },
  { name: 'src/App.vue', check: () => fs.existsSync('src/App.vue'), expected: true },
  { name: 'src/router/index.js', check: () => fs.existsSync('src/router/index.js'), expected: true },
  { name: 'src/views/DashboardTest.vue', check: () => fs.existsSync('src/views/DashboardTest.vue'), expected: true },
  { name: 'src/views/DashboardInteractive.vue', check: () => fs.existsSync('src/views/DashboardInteractive.vue'), expected: true },
  { name: 'src/components/dashboard/Sidebar.vue', check: () => fs.existsSync('src/components/dashboard/Sidebar.vue'), expected: true },
  { name: 'src/components/dashboard/TopNavbar.vue', check: () => fs.existsSync('src/components/dashboard/TopNavbar.vue'), expected: true },
];

let allPassed = true;

checks.forEach(({ name, check, expected }) => {
  try {
    const result = check();
    const passed = typeof expected === 'boolean' ? result === expected : result;
    const status = passed ? '✅' : '❌';
    console.log(`${status} ${name}: ${result}`);
    if (!passed) allPassed = false;
  } catch (error) {
    console.log(`❌ ${name}: ERROR - ${error.message}`);
    allPassed = false;
  }
});

console.log('\n' + '='.repeat(50));

if (allPassed) {
  console.log('✅ All checks passed!');
  console.log('\n📝 Next steps:');
  console.log('1. Run: npm run dev');
  console.log('2. Open: http://localhost:5173/dashboard');
  console.log('3. You should see "Dashboard Test Page"');
  console.log('\nIf you see a white screen:');
  console.log('- Press F12 to open browser console');
  console.log('- Look for red error messages');
  console.log('- Check WHITE_SCREEN_FIX.md for solutions');
} else {
  console.log('❌ Some checks failed!');
  console.log('\n📝 Fixes:');
  console.log('1. If node_modules missing: npm install');
  console.log('2. If files missing: Check if you\'re in the right directory');
  console.log('3. Run this script again after fixing');
}

console.log('='.repeat(50) + '\n');
