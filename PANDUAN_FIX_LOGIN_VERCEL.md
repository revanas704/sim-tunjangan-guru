# 🛠️ FIX LOGIN GAGAL DI VERCEL

## ❌ Masalah: "Username atau password salah"

## ✅ Solusi: Ikuti langkah-langkah berikut

---

## 🔍 PENYEBAB UTAMA

Ada 2 penyebab login gagal:

### 1. ❌ **Prisma Schema Salah (MASALAH UTAMA)**
- File `prisma/schema.prisma` masih menggunakan **SQLite**
- Tapi Supabase menggunakan **PostgreSQL**
- Ini membuat Prisma Client tidak bisa berkomunikasi dengan database

### 2. ❌ **Password Hash Tidak Valid**
- Password hash di database mungkin tidak cocok
- Hash yang digunakan tidak valid untuk bcrypt

---

## ✅ LANGKAH-LANGKAH PERBAIKAN

### 📝 Langkah 1: Update Prisma Schema (SUDAH DIPERBAIKI)

File `prisma/schema.prisma` sudah saya perbarui untuk menggunakan **PostgreSQL**.

**Yang berubah:**
```prisma
# ❌ LAMA
datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

# ✅ BARU
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

---

### 🔑 Langkah 2: Regenerate Prisma Client

Di terminal local Anda:

```bash
bunx prisma generate
```

Ini akan generate Prisma Client yang kompatibel dengan PostgreSQL.

---

### 🌐 Langkah 3: Cek Debug Info di Vercel

Setelah deploy ke Vercel, buka URL berikut untuk cek debug login:

```
https://sim-tunjangan-guru.vercel.app/api/debug/login
```

Anda akan melihat response JSON seperti ini:

**✅ Jika database terhubung dengan benar:**
```json
{
  "success": true,
  "databaseConnected": true,
  "userCount": 2,
  "adminFound": true,
  "admin": {
    "id": "...",
    "username": "admin",
    "role": "ADMIN",
    "passwordHashLength": 60
  },
  "passwordTest": {
    "testPassword": "admin123",
    "isPasswordValid": true
  }
}
```

**❌ Jika ada masalah:**
```json
{
  "success": false,
  "message": "Admin user tidak ditemukan di database!",
  "adminFound": false
}
```

---

### 🔧 Langkah 4: Reset Password Admin

Jika admin user tidak ditemukan atau password salah, gunakan API reset password:

#### Cara 1: Dengan cURL

```bash
curl -X POST https://sim-tunjangan-guru.vercel.app/api/debug/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

#### Cara 2: Dengan Postman/Thunder Client

- Method: `POST`
- URL: `https://sim-tunjangan-guru.vercel.app/api/debug/login`
- Headers:
  - `Content-Type`: `application/json`
- Body (JSON):
  ```json
  {
    "username": "admin",
    "password": "admin123"
  }
  ```

Response:
```json
{
  "success": true,
  "message": "User admin berhasil diperbarui",
  "user": {
    "id": "...",
    "username": "admin",
    "role": "ADMIN"
  },
  "passwordTest": {
    "originalPassword": "admin123",
    "hashLength": 60,
    "isPasswordValid": true
  }
}
```

---

### 🧪 Langkah 5: Test Login

Sekarang coba login di website:

- URL: `https://sim-tunjangan-guru.vercel.app/login`
- Username: `admin`
- Password: `admin123`

**Jika masih gagal**, cek Vercel logs untuk error:
1. Buka Vercel Dashboard
2. Pilih project Anda
3. Klik "Logs" tab
4. Cari log dari `/api/auth/[...nextauth]`

---

## 🔎 TROUBLESHOOTING LANJUTAN

### Jika `/api/debug/login` menampilkan error:

#### Error 1: "Admin user tidak ditemukan"
**Solusi:** Jalankan API reset password (Langkah 4 di atas)

#### Error 2: "isPasswordValid": false
**Solusi:** Jalankan API reset password dengan password baru

#### Error 3: Error database connection
**Cek di Vercel:**
1. Buka project di Vercel Dashboard
2. Klik "Settings" → "Environment Variables"
3. Pastikan `DATABASE_URL` sudah benar:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@[YOUR-PROJECT].supabase.co:5432/postgres
   ```

#### Error 4: Prisma Client error
**Solusi:** Pastikan `bunx prisma generate` sudah dijalankan dan di-deploy ke Vercel

---

## 📋 CHECKLIST SELESAI

Selesaikan checklist ini untuk memastikan login berfungsi:

- [ ] `prisma/schema.prisma` sudah menggunakan `postgresql`
- [ ] `bunx prisma generate` sudah dijalankan
- [ ] Code sudah di-push ke GitHub
- [ ] Vercel sudah redeploy otomatis
- [ ] Buka `/api/debug/login` - response "success": true
- [ ] Jalankan POST `/api/debug/login` untuk reset password admin
- [ ] Login dengan admin/admin123 berhasil

---

## 💡 TIPS PENTING

### Password Hash yang Valid

Password hash yang valid untuk bcrypt memiliki panjang **60 karakter**.

Contoh hash yang valid:
```
$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u
```

Jika password hash di database tidak panjangnya 60 karakter, maka itu tidak valid!

### Database Schema di Supabase

Pastikan tabel `User` di Supabase memiliki struktur:
- `id` (UUID, PRIMARY KEY)
- `username` (VARCHAR(255), UNIQUE)
- `password` (VARCHAR(255))
- `role` (VARCHAR(50))
- `guruId` (UUID, UNIQUE, nullable)
- `createdAt` (TIMESTAMPTZ)
- `updatedAt` (TIMESTAMPTZ)

---

## 🆘 MASALAH PERSISTEN?

Jika setelah semua langkah di atas masih gagal:

### Option 1: Reset Database di Supabase

1. Buka Supabase Dashboard
2. Klik "Project Settings" → "Database"
3. Scroll ke "Reset Database Password"
4. Atau buat project Supabase baru

### Option 2: Cek Vercel Build Logs

1. Buka Vercel Dashboard
2. Pilih project
3. Klik "Deployments"
4. Klik deployment terbaru
5. Cari error di "Build Logs" atau "Function Logs"

### Option 3: Cek Environment Variables di Vercel

Pastikan variabel berikut ada dan benar:
- ✅ `DATABASE_URL` - Connection string ke Supabase PostgreSQL
- ✅ `NEXTAUTH_URL` - URL website Vercel
- ✅ `NEXTAUTH_SECRET` - Random string

---

## 🎉 SELESAI!

Setelah mengikuti semua langkah di atas, login seharusnya berfungsi normal.

**Credential Default:**
- Admin: `admin` / `admin123`
- Guru: `guru` / `guru123`

Selamat mencoba! 🚀
