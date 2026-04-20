# 🗄️ Cara Menjalankan SQL di Supabase

## Masalah yang Anda Alami:
```
Error: Failed to run sql query: ERROR: 42P01: relation "Guru" does not exist
```

**Penyebab**: SQL script lama mencoba menghapus tabel yang belum ada, sehingga Supabase berhenti menjalankan script.

## ✅ Solusi:

### 1. Buka SQL Editor di Supabase

1. Login ke: https://supabase.com
2. Pilih project: `sim-tunjangan-guru`
3. Di sidebar kiri, klik **SQL Editor**
4. Klik **"New query"**

### 2. Copy dan Paste SQL Script

1. Buka file: `supabase-schema.sql` di folder project
2. Copy SELURUH isi file
3. Paste ke SQL Editor di Supabase

### 3. Jalankan Query

Klik tombol **Run** (atau `Ctrl/Cmd + Enter`)

### 4. Verifikasi Hasil

Setelah berhasil, Anda akan melihat tabel di bawah:

| table_name | row_count |
|-----------|-----------|
| Guru | 2 |
| User | 2 |
| Pengajuan | 0 |
| DAKPenyaluran | 1 |
| DAKDetailPenerima | 2 |

**Jika semua muncul, berarti sukses! ✅**

---

## 🔧 Jika Masih Error:

### Error: "relation already exists"
**Solusi**: Sudah ada data, aman untuk diabaikan atau hapus tabel manual di Table Editor.

### Error: "column does not exist"
**Solusi**: Hapus semua tabel lama:
1. Buka **Table Editor** di Supabase
2. Hapus semua tabel satu per satu
3. Jalankan SQL script lagi

### Error: Permission denied
**Solusi**:
1. Pastikan Anda login sebagai owner project
2. Check di dashboard Supabase

---

## 📊 Setelah SQL Berhasil:

### 1. Cek Data User

Buka **Table Editor** → pilih tabel `User` → Anda akan melihat:

| username | role |
|----------|-------|
| admin | ADMIN |
| guru | GURU |

### 2. Cek Data Guru

Buka **Table Editor** → pilih tabel `Guru` → Anda akan melihat:

| nip | nama |
|-----|------|
| 198001012005011001 | Ahmad Supriyadi |
| 198502152010011002 | Siti Aminah |

### 3. Cek Data DAK

Buka **Table Editor** → pilih tabel `DAKPenyaluran` dan `DAKDetailPenerima`

---

## 🚀 Lanjut ke Deployment

Setelah database siap, lanjutkan upload ke Vercel:

Baca: [MULAI_DEPLOYMENT.md](./MULAI_DEPLOYMENT.md)

---

## ✨ Tips:

1. **SQL Script sudah diperbaiki** - Menggunakan `CREATE TABLE IF NOT EXISTS` jadi aman dijalankan berulang kali
2. **ON CONFLICT DO NOTHING** - Tidak akan error jika data sudah ada
3. **Verification Query** - Menampilkan jumlah data di setiap tabel

---

## 📞 Butuh Bantuan?

- **Supabase Docs**: https://supabase.com/docs/guides/database
- **SQL Basics**: https://supabase.com/docs/guides/database/postgres/overview

---

**SQL Script sudah diperbaiki! Coba jalankan lagi di SQL Editor Supabase.** ✅
