const bcrypt = require('bcryptjs');

async function verifyPassword() {
  try {
    console.log('=== Verifying Admin Password ===\n');

    const password = 'admin123';
    const hash1 = '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u'; // Old hash
    const hash2 = '$2b$10$0rbq6EZXX1akc7Ujh3rOtO9jXq4z3C0YQ.0wM3YbY3Hm.0'; // New hash from local DB

    console.log('Testing password: admin123\n');

    console.log('\n1. Old Hash ($2a$):');
    const valid1 = await bcrypt.compare(password, hash1);
    console.log('   Hash:', hash1);
    console.log('   Valid:', valid1 ? '✅ YES' : '❌ NO');

    console.log('\n2. New Hash ($2b$):');
    const valid2 = await bcrypt.compare(password, hash2);
    console.log('   Hash:', hash2);
    console.log('   Valid:', valid2 ? '✅ YES' : '❌ NO');

    console.log('\n3. Generate New Hash with bcrypt.hash():');
    const newHash = await bcrypt.hash(password, 10);
    const valid3 = await bcrypt.compare(password, newHash);
    console.log('   Hash:', newHash);
    console.log('   Valid:', valid3 ? '✅ YES' : '❌ NO');

    console.log('\n=== Use this hash for Supabase ===');
    console.log(newHash);

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    process.exit();
  }
}

verifyPassword();
