const { db } = require('./src/lib/db.ts');

async function checkUsers() {
  try {
    console.log('=== Checking Users in Local Database ===\n');

    const users = await db.user.findMany();

    console.log('Total users:', users.length);
    console.log('\nUsers list:');
    users.forEach(user => {
      console.log(`┌─ Username: ${user.username}`);
      console.log(`│  Role: ${user.role}`);
      console.log(`│  ID: ${user.id}`);
      console.log(`│  Password Hash: ${user.password.substring(0, 20)}...`);
      console.log('└─────────────────');
    });

    // Cek user admin
    const adminUser = await db.user.findUnique({
      where: { username: 'admin' }
    });

    if (adminUser) {
      console.log('\n✅ Admin user FOUND:');
      console.log('   Username:', adminUser.username);
      console.log('   Role:', adminUser.role);
      console.log('   Password Hash:', adminUser.password.substring(0, 30) + '...');
      console.log('\n📋 This hash should be in Supabase:');
      console.log('   ' + adminUser.password);
    } else {
      console.log('\n❌ Admin user NOT FOUND in database!');
      console.log('   Please create admin user first.');
    }

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    process.exit();
  }
}

checkUsers();
