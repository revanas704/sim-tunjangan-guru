import { NextResponse } from 'next/server'
import { db } from '@/lib/db'
import bcrypt from 'bcryptjs'

export async function GET() {
  try {
    console.log('=== Debug Login API ===')
    console.log('DATABASE_URL set:', !!process.env.DATABASE_URL)

    // Cek koneksi database
    const userCount = await db.user.count()
    console.log('Total users in database:', userCount)

    // Cari admin user
    const adminUser = await db.user.findUnique({
      where: { username: 'admin' },
    })

    console.log('Admin user found:', !!adminUser)

    if (!adminUser) {
      return NextResponse.json({
        success: false,
        message: 'Admin user tidak ditemukan di database!',
        databaseConnected: true,
        userCount,
        adminFound: false,
      })
    }

    // Test password comparison
    const testPassword = 'admin123'
    const isPasswordValid = await bcrypt.compare(testPassword, adminUser.password)

    // Test generating new hash
    const newHash = await bcrypt.hash(testPassword, 10)
    const isNewHashValid = await bcrypt.compare(testPassword, newHash)

    return NextResponse.json({
      success: true,
      message: 'Debug info berhasil diambil',
      databaseConnected: true,
      userCount,
      adminFound: true,
      admin: {
        id: adminUser.id,
        username: adminUser.username,
        role: adminUser.role,
        passwordHash: adminUser.password.substring(0, 20) + '...',
        passwordHashLength: adminUser.password.length,
      },
      passwordTest: {
        testPassword,
        isPasswordValid,
        newHash: newHash.substring(0, 20) + '...',
        isNewHashValid,
      },
    })
  } catch (error: any) {
    console.error('Debug API Error:', error)
    return NextResponse.json({
      success: false,
      message: 'Error: ' + error.message,
      error: error.toString(),
    }, { status: 500 })
  }
}

export async function POST(request: Request) {
  try {
    const { username, password } = await request.json()

    if (!username || !password) {
      return NextResponse.json({
        success: false,
        message: 'Username dan password diperlukan',
      }, { status: 400 })
    }

    // Generate hash untuk password baru
    const hash = await bcrypt.hash(password, 10)

    // Update atau buat user baru
    const user = await db.user.upsert({
      where: { username },
      create: {
        username,
        password: hash,
        role: username === 'admin' ? 'ADMIN' : 'GURU',
      },
      update: {
        password: hash,
      },
    })

    // Test password comparison
    const isPasswordValid = await bcrypt.compare(password, hash)

    return NextResponse.json({
      success: true,
      message: `User ${username} berhasil ${user.password === hash ? 'dibuat' : 'diperbarui'}`,
      user: {
        id: user.id,
        username: user.username,
        role: user.role,
      },
      passwordTest: {
        originalPassword: password,
        hashLength: hash.length,
        isPasswordValid,
      },
    })
  } catch (error: any) {
    console.error('Reset Password API Error:', error)
    return NextResponse.json({
      success: false,
      message: 'Error: ' + error.message,
      error: error.toString(),
    }, { status: 500 })
  }
}
