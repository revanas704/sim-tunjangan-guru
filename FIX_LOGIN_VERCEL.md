# 🔧 Perbaiki Masalah Login di Vercel

## Masalah:
Login gagal dengan pesan "Username atau password salah" padahal:
- Username: `admin`
- Password: `admin123`

---

## 🔍 Penyebab Utama:

### 1. NEXTAUTH_URL Tidak Sesuai (PALING UMUM)
NEXTAUTH_URL di Vercel Environment Variables tidak sama dengan URL website.

### 2. User Tidak Ada di Database Supabase
User admin tidak ter-insert di database Supabase saat SQL dijalankan.

### 3. NEXTAUTH_SECRET Tidak Konsisten
Secret yang berbeda antara development dan production.

---

## ✅ SOLUSI 1: Update NEXTAUTH_URL (Wajib!)

### Langkah 1: Dapatkan URL Website

1. Login ke dashboard Vercel: https://vercel.com/dashboard
2. Pilih project `sim-tunjangan-guru`
3. Copy URL website di bagian atas (contoh):
   ```
   https://sim-tunjangan-guru-abc123.vercel.app
   ```
   atau
   ```
   https://sim-tunjangan-guru.vercel.app
   ```

### Langkah 2: Update Environment Variable di Vercel

1. Di dashboard Vercel, klik **Settings**
2. Klik **Environment Variables**
3. Cari variable `NEXTAUTH_URL`
4. Update dengan URL website Anda:
   ```
   https://sim-tunjangan-guru.vercel.app
   ```
5. **PENTING**: Pastikan URL diawali dengan `https://` (bukan http)
6. Klik **Save**

### Langkah 3: Redeploy Website

1. Klik tab **Deployments** di sidebar
2. Cari deploy terbaru (yang ada tanda check hijau)
3. Klik titik tiga (...) di kanan deploy
4. Pilih **Redeploy**
5. Tunggu 2-3 menit

### Langkah 4: Clear Browser Cache

1. Buka website di incognito/private window
2. Coba login lagi:
   - Username: `admin`
   - Password: `admin123`

---

## ✅ SOLUSI 2: Cek dan Insert User Admin ke Database

### Langkah 1: Cek User di Supabase

1. Buka dashboard Supabase: https://supabase.com
2. Pilih project `sim-tunjangan-guru`
3. Klik **Table Editor** di sidebar
4. Pilih tabel `User`
5. Periksa apakah ada user dengan username `admin`

### Jika User Admin TIDAK ADA:

#### Opsi 1: Jalankan SQL Insert User

Buka **SQL Editor** → Jalankan query ini:

```sql
-- Insert Admin User (Password: admin123)
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;
```

#### Opsi 2: Insert via Table Editor

1. Buka Table Editor → tabel `User`
2. Klik **Insert row** (ikon +)
3. Isi data:
   - **id**: (biarkan kosong, auto-generate)
   - **username**: `admin`
   - **password**: `$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u`
   - **role**: `ADMIN`
   - **guruId**: (biarkan kosong/null)
   - **createdAt**: (biarkan auto)
   - **updatedAt**: (biarkan auto)
4. Klik **Save**

### Langkah 2: Verifikasi User

Di Table Editor, klik refresh → Cek lagi tabel `User` → Harus ada:
- username: `admin`
- role: `ADMIN`

---

## ✅ SOLUSI 3: Generate Baru NEXTAUTH_SECRET

### Langkah 1: Generate Secret Baru

Buka: https://generate-secret.vercel.app/32

Copy secret yang muncul (contoh):
```
random-secret-key-abc123xyz-789
```

### Langkah 2: Update di Vercel

1. Vercel → Settings → Environment Variables
2. Cari `NEXTAUTH_SECRET`
3. Update dengan secret baru
4. Klik **Save**

### Langkah 3: Redeploy

Deployments → Redeploy deploy terbaru

### Langkah 4: Hapus Cookie Browser

1. Clear cookies untuk website:
   - Chrome: F12 → Application → Cookies → Hapus
   - Firefox: F12 → Storage → Cookies → Hapus
2. Reload website
3. Login lagi

---

## ✅ SOLUSI 4: Verifikasi Database Connection

### Langkah 1: Cek DATABASE_URL

1. Vercel → Settings → Environment Variables
2. Cek `DATABASE_URL`
3. Pastikan formatnya benar:
   ```
   postgresql://postgres:[PASSWORD]@db.xxx.supabase.co:5432/postgres
   ```
4. Pastikan `[PASSWORD]` sudah diganti dengan password database

### Langkah 2: Test Connection di Vercel

1. Vercel → Logs
2. Pilih deployment terbaru
3. Cari error database:
   - Jika ada error: "connection refused" → Database URL salah
   - Jika ada error: "authentication failed" → Password database salah

---

## 📊 Checklist Perbaikan:

- [ ] NEXTAUTH_URL diupdate dengan URL website yang benar
- [ ] URL menggunakan `https://` (bukan `http://`)
- [ ] Website di-redeploy setelah update environment variable
- [ ] User admin ada di database Supabase
- [ ] Password admin: `admin123`
- [ ] NEXTAUTH_SECRET di-generate baru
- [ ] Database connection string benar
- [ ] Browser cache cleared
- [ ] Login diincognito/private window

---

## 🆘 Jika Masih Gagal:

### Cek 1: Lihat Vercel Logs

1. Vercel → Logs
2. Cari error saat login:
   - JWT errors → NEXTAUTH_SECRET problem
   - Database errors → DATABASE_URL problem
   - Auth errors → NEXTAUTH_URL problem

### Cek 2: Lihat Browser Console

1. Buka website
2. F12 → Console tab
3. Coba login
4. Lihat error yang muncul

### Cek 3: Verify Database

Buka Supabase → SQL Editor → Jalankan:

```sql
SELECT username, role FROM "User";
```

Harus muncul:
```
username | role
---------|------
admin    | ADMIN
guru     | GURU
```

### Cek 4: Reset Database (Last Resort)

Jika semua solusi gagal:
1. Hapus semua data di tabel `User` di Supabase
2. Insert user admin lagi (lihat Solusi 2)
3. Redeploy di Vercel
4. Coba login lagi

---

## 💡 Tips Penting:

### 1. NEXTAUTH_URL HARUS Sama Persis

**Salah**:
```
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_URL=http://sim-tunjangan-guru.vercel.app
```

**Benar**:
```
NEXTAUTH_URL=https://sim-tunjangan-guru.vercel.app
```

### 2. HTTPS Bukan HTTP

Vercel otomatis pakai HTTPS, jadi NEXTAUTH_URL harus menggunakan `https://`

### 3. Clear Browser Cache Setelah Re-deploy

Setiap kali environment variable diubah dan re-deploy, browser cache harus di-clear.

### 4. Gunakan Incognito/Private Window untuk Testing

Untuk menghindari cache browser yang mungkin bermasalah.

---

## 🚀 Cara Cepat Perbaiki:

Ikuti langkah ini secara berurutan:

1. **Copy URL website dari Vercel** → `https://sim-tunjangan-guru.vercel.app`

2. **Update NEXTAUTH_URL di Vercel** → Paste URL

3. **Redeploy di Vercel**

4. **Clear browser cache**

5. **Buka website di incognito**

6. **Login dengan**: `admin` / `admin123`

---

**Solusi paling umum: UPDATE NEXTAUTH_URL dengan URL website yang benar!** ✅
