# ⚡ PERBAIKI LOGIN SEKARANG (1 Menit!)

## Masalah:
Login gagal padahal log NextAuth sudah benar.

## Penyebab:
Password hash di Supabase SALAH! (`$2a$` tidak valid)

---

## ✅ SOLUSI LANGSUNG:

### Langkah 1: Buka Supabase SQL Editor

1. https://supabase.com → Login
2. Pilih project `sim-tunjangan-guru`
3. Klik **SQL Editor**

### Langkah 2: Copy & Paste Ini (30 detik)

```sql
-- Update password admin dengan hash yang BENAR
UPDATE "User"
SET password = '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.'
WHERE username = 'admin';

-- Insert jika belum ada
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;

-- Verify
SELECT username, role
FROM "User"
WHERE username = 'admin';
```

### Langkah 3: Run SQL (10 detik)

Klik tombol **Run** di SQL Editor

### Langkah 4: Test Login (20 detik)

1. Buka website di **Incognito/Private Window**
2. Login: `admin` / `admin123`

**Selesai!** ✅

---

## 📊 Verification:

Hasil query harus:
```
username | role
---------|------
admin    | ADMIN
```

---

## 🔍 Kalau Masih Gagal:

### Cek Password di Database:

1. Table Editor → Tabel `User`
2. Klik row `admin`
3. Cek kolom `password`

**Harus**: `$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.`
**Salah**: `$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u`

Jika masih salah → Jalankan SQL update lagi.

---

## 📄 Files Tersedia:

| File | Gunakan Jika... |
|------|----------------|
| `insert-admin-correct.sql` | Hanya update user admin |
| `insert-all-users-correct.sql` | Update admin dan guru |
| `FIX_LOGIN_PASSWORD_HASH.md` | Butuh penjelasan detail |

---

**Cukup copy-paste SQL di atas ke Supabase SQL Editor dan Run!** ✅
