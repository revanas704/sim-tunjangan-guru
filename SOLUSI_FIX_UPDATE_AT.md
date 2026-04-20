# 🛠️ FIX ERROR "record 'new' has no field 'updatedAt'"

## 📋 Masalah

Error yang muncul:
```
Error: Failed to run sql query: ERROR: 42703: record "new" has no field "updatedAt"
CONTEXT: PL/pgSQL assignment "NEW."updatedAt" = CURRENT_TIMESTAMP"
PL/pgSQL function update_updated_at_column() line 3 at assignment
```

## 🔍 Penyebab

Error ini terjadi karena:
1. Ada trigger atau fungsi lama dari skrip sebelumnya yang masih tersimpan di database
2. Fungsi lama mungkin memiliki definisi yang salah atau corrupted
3. Saat skrip baru dijalankan, terjadi konflik dengan definisi lama

## ✅ SOLUSI

Gunakan **SQL Schema Baru v3.0** yang membersihkan SEMUA trigger dan fungsi lama terlebih dahulu.

### Langkah-langkah:

#### 1️⃣ Buka Supabase Dashboard
- Login ke https://supabase.com/dashboard
- Pilih project Anda

#### 2️⃣ Buka SQL Editor
- Klik menu "SQL Editor" di sidebar kiri
- Klik "New query" untuk buat query baru

#### 3️⃣ Copy dan Jalankan Skrip Baru
Buka file **`supabase-schema-v3.sql`** di project Anda, lalu:
1. Copy SEMUA isi file tersebut
2. Paste ke SQL Editor Supabase
3. Klik tombol **"Run"** atau tekan **Ctrl + Enter**

#### 4️⃣ Verifikasi Hasil
Setelah skrip dijalankan, Anda akan melihat tabel hasil seperti ini:

| table_name | row_count |
|------------|-----------|
| ✅ DAK_DETAIL_PENERIMA | 2 |
| ✅ DAK_PENYALURAN | 1 |
| ✅ GURU | 2 |
| ✅ PENGAJUAN | 0 |
| ✅ USER | 2 |

Jika melihat tabel di atas, artinya:
- ✅ Semua tabel berhasil dibuat
- ✅ Semua trigger berhasil dibuat
- ✅ Data sample berhasil di-insert

#### 5️⃣ Cek Akun User di Table Editor
1. Klik menu "Table Editor" di sidebar kiri
2. Buka tabel **"User"**
3. Pastikan ada 2 user:

| username | role | password (hash) |
|----------|------|-----------------|
| admin | ADMIN | $2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u |
| guru | GURU | $2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u |

**Password:**
- Admin: **admin123**
- Guru: **guru123**

#### 6️⃣ Test Login di Website
Setelah database berhasil di-setup, test login di website:

**Untuk Admin:**
- Username: `admin`
- Password: `admin123`

**Untuk Guru:**
- Username: `guru`
- Password: `guru123`

---

## 🔄 Apa yang Berbeda di Skrip v3.0?

Skrip baru (`supabase-schema-v3.sql`) melakukan hal ini:

### ❌ Skrip Lama (v2.0):
```sql
-- Hanya DROP trigger, tapi fungsi lama mungkin masih ada
DROP TRIGGER IF EXISTS update_user_updated_at ON "User";
-- ... create fungsi baru
```

### ✅ Skrip Baru (v3.0):
```sql
-- STEP 0: Clean up old triggers and functions
-- 0.1 Hapus SEMUA trigger dulu
DROP TRIGGER IF EXISTS update_user_updated_at ON "User";
DROP TRIGGER IF EXISTS update_guru_updated_at ON "Guru";
-- ... semua trigger

-- 0.2 Hapus fungsi lama SECARA LENGKAP
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Baru kemudian buat ulang semuanya
```

**Keuntungannya:**
- ✅ Tidak ada konflik dengan definisi lama
- ✅ Clean slate - semua dibuat dari awal
- ✅ Trigger dan fungsi selalu baru dan benar
- ✅ User data di-update jika sudah ada (ON CONFLICT DO UPDATE)

---

## 🆘 Jika Masih Error

### Jika masih error setelah menjalankan v3.0:

#### Opsi 1: Reset Database (Hapus dan Buat Baru)
1. Di Supabase Dashboard, klik **Project Settings** (gear icon)
2. Pilih **General**
3. Scroll ke bawah ke bagian **Reset project password**
4. Atau buat project baru saja (lebih cepat dan bersih)

#### Opsi 2: Hapus Tabel Manual di SQL Editor
Jalankan skrip ini dulu untuk menghapus SEMUA tabel:

```sql
DROP TABLE IF EXISTS "DAKDetailPenerima" CASCADE;
DROP TABLE IF EXISTS "DAKPenyaluran" CASCADE;
DROP TABLE IF EXISTS "Pengajuan" CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;
DROP TABLE IF EXISTS "Guru" CASCADE;
```

Kemudian jalankan **`supabase-schema-v3.sql`** lagi.

#### Opsi 3: Hapus Trigger dan Fungsi Saja
Jalankan ini dulu:

```sql
-- Hapus semua trigger
DROP TRIGGER IF EXISTS update_user_updated_at ON "User";
DROP TRIGGER IF EXISTS update_guru_updated_at ON "Guru";
DROP TRIGGER IF EXISTS update_pengajuan_updated_at ON "Pengajuan";
DROP TRIGGER IF EXISTS update_dak_penyaluran_updated_at ON "DAKPenyaluran";
DROP TRIGGER IF EXISTS update_dak_detail_updated_at ON "DAKDetailPenerima";

-- Hapus fungsi
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
```

Kemudian jalankan **`supabase-schema-v3.sql`**.

---

## 📊 Checklist Selesai

Selesaikan checklist ini untuk memastikan semua berjalan lancar:

- [ ] Sudah menjalankan `supabase-schema-v3.sql` tanpa error
- [ ] Melihat tabel hasil dengan row_count yang benar
- [ ] Melihat 2 user di Table Editor (admin dan guru)
- [ ] User admin memiliki password hash yang benar
- [ ] Bisa login sebagai admin di website
- [ ] Bisa login sebagai guru di website

---

## 🎉 Selesai!

Setelah semua langkah di atas selesai, database Anda sudah siap dan website seharusnya berjalan normal.

**Username & Password Default:**
- **Admin:** admin / admin123
- **Guru:** guru / guru123

Selamat mencoba! 🚀
