# 🔧 Solusi Error SQL di Supabase

## Masalah Anda:
```
Error: Failed to run sql query: ERROR: 42P01: relation "Guru" does not exist
```

**Solusi Tersedia!**

---

## ✅ SOLUSI 1: Gunakan SQL Script yang Sudah Diperbaiki

Script `supabase-schema.sql` sudah diperbaiki dengan pendekatan baru:

### Apa yang Diperbaiki:

1. **Buat tabel TANPA foreign key dulu**
   - Semua tabel dibuat tanpa constraint foreign key
   - Menghindari error "relation does not exist"

2. **Tambahkan foreign key secara manual**
   - Menggunakan DO block dengan IF NOT EXISTS
   - Cek apakah foreign key sudah ada sebelum ditambahkan

3. **Urutan pembuatan tabel yang aman**
   - Guru (pertama - referensi untuk tabel lain)
   - DAKPenyaluran
   - DAKDetailPenerima
   - Pengajuan
   - User (terakhir - punya FK ke Guru)

### Cara Pakai:

1. Buka file `supabase-schema.sql` yang baru
2. Copy SELURUH isi
3. Paste ke SQL Editor Supabase
4. Klik **Run**

---

## 🧹 SOLUSI 2: Reset Database Jika Masih Error

### Langkah 1: Hapus Semua Tabel Manual

1. Di Supabase dashboard, buka **Table Editor**
2. Hapus semua tabel satu per satu (klik tombol delete di setiap tabel):
   - User
   - Pengajuan
   - DAKDetailPenerima
   - DAKPenyaluran
   - Guru

**PENTING**: Hapus dalam urutan yang sama!

### Langkah 2: Jalankan SQL Script Ulang

1. Buka **SQL Editor**
2. Copy file `supabase-schema.sql` yang baru
3. Paste → Run

---

## 🗑️ SOLUSI 3: Delete Project dan Buat Baru (Paling Mudah)

Jika solusi 1 dan 2 masih gagal:

### Langkah 1: Hapus Project Lama

1. Di Supabase dashboard → Settings (gear icon)
2. Scroll ke bawah → **Delete Project**
3. Ketik nama project untuk konfirmasi → Delete
4. Tunggu beberapa detik

### Langkah 2: Buat Project Baru

1. Klik **New Project**
2. Isi:
   - Name: `sim-tunjangan-guru`
   - Database Password: (buat yang baru, simpan!)
   - Region: Singapore
3. Click **Create new project**
4. Tunggu 2-3 menit

### Langkah 3: Import Database

1. Setelah project jadi → buka **SQL Editor**
2. Copy file `supabase-schema.sql` yang baru
3. Paste → Run

4. Verifikasi tabel terbuat dengan benar (akan muncul di bawah query):
   ```
   ✅ GURU              | 2
   ✅ USER               | 2
   ✅ PENGAJUAN          | 0
   ✅ DAK_PENYALURAN    | 1
   ✅ DAK_DETAIL_PENERIMA | 2
   ```

---

## ✅ Setelah SQL Berhasil:

### 1. Cek Tabel di Table Editor

Buka **Table Editor** → Anda akan melihat 5 tabel:
- Guru
- User
- Pengajuan
- DAKPenyaluran
- DAKDetailPenerima

### 2. Cek Data User

Klik tabel `User` → Anda akan melihat 2 data:
- Username: `admin`, Role: `ADMIN`
- Username: `guru`, Role: `GURU`

### 3. Cek Data Guru

Klik tabel `Guru` → Anda akan melihat 2 data:
- NIP: `198001012005011001`, Nama: `Ahmad Supriyadi`
- NIP: `198502152010011002`, Nama: `Siti Aminah`

---

## 🚀 Lanjut ke Deployment Vercel

Setelah database siap, lanjutkan ke Vercel:

Baca: [MULAI_DEPLOYMENT.md](./MULAI_DEPLOYMENT.md)

---

## 📊 Expected Result Setelah Berhasil:

### Verification Output:
```
✅ GURU                | 2
✅ USER                 | 2
✅ PENGAJUAN             | 0
✅ DAK_PENYALURAN       | 1
✅ DAK_DETAIL_PENERIMA   | 2
```

### Cek di Table Editor:
- ✅ 5 tabel berhasil dibuat
- ✅ 2 User ter-insert
- ✅ 2 Guru ter-insert
- ✅ 1 DAK Penyaluran ter-insert
- ✅ 2 DAK Detail Penerima ter-insert
- ✅ Foreign keys berhasil ditambahkan
- ✅ Index berhasil dibuat
- ✅ Trigger berhasil dibuat

---

## 🆘 Jika Masih Error:

### Error: "relation already exists"
**Solusi**: Tabel sudah ada → aman untuk diabaikan atau hapus manual di Table Editor.

### Error: "column does not exist"
**Solusi**:
1. Hapus semua tabel di Table Editor
2. Jalankan SQL script lagi

### Error: "permission denied"
**Solusi**:
1. Logout dari Supabase
2. Login kembali
3. Pastikan sebagai owner project

---

## 💡 Tips:

1. **Gunakan SOLUSI 3** (Delete & Create Project) - Paling mudah dan cepat
2. **Simpan password database** - Anda akan butuh untuk Vercel
3. **Copy database connection string** - Butuh untuk environment variable

---

**SQL script sudah diperbaiki total! Coba salah satu solusi di atas.** ✅
