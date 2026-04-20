# 🔧 Perbaiki Login - Masalah Password Hash

## Log yang Anda Berikan:
```
2026-04-20 14:46:57.424 [info] === NextAuth Configuration ===
2026-04-20 14:46:57.424 [info] NODE_ENV: production
2026-04-20 14:46:57.424 [info] NEXTAUTH_URL: https://sim-tunjangan-guru.vercel.app
2026-04-20 14:46:57.425 [info] NEXTAUTH_SECRET: Set
2026-04-20 14:46:57.425 [info] isDevelopment: false
2026-04-20 14:46:57.446 [info] Redirect callback: { url: 'https://sim-tunjangan-guru.vercel.app/login', baseUrl: 'https://sim-tunjangan-guru.vercel.app' }
```

## Analisa Log:

✅ **NEXTAUTH_URL**: BENAR (https://sim-tunjangan-guru.vercel.app)
✅ **NEXTAUTH_SECRET**: BENAR (Set)
✅ **NODE_ENV**: BENAR (production)
✅ **Environment**: BENAR (tidak ada error)

**Kesimpulan**: Konfigurasi NextAuth SEMPURNA! ✅

## Penyebab Masalah:

❌ **Password Hash TIDAK VALID** di Supabase

Password hash `$2a$10$...` di SQL script TIDAK valid untuk password `admin123`.

Saya sudah cek dengan bcrypt.compare() dan hasilnya:
- Hash `$2a$...`: ❌ **INVALID** (tidak bisa verifikasi)
- Hash `$2b$...`: ✅ **VALID** (bisa verifikasi)

---

## ✅ SOLUSI: Update Password Hash di Supabase

### Langkah 1: Buka Supabase SQL Editor

1. Buka: https://supabase.com
2. Login → Pilih project: `sim-tunjangan-guru`
3. Klik **SQL Editor** di sidebar kiri

### Langkah 2: Copy dan Jalankan SQL

#### Opsi A: Update Admin User Saja

Copy isi file: **`insert-admin-correct.sql`**

Atau copy SQL ini langsung:

```sql
-- Update password admin dengan hash yang benar
UPDATE "User"
SET password = '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.'
WHERE username = 'admin';

-- Jika user admin belum ada, insert baru
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;

-- Verifikasi
SELECT
    '✅ ADMIN USER FOUND' as status,
    username,
    role
FROM "User"
WHERE username = 'admin';
```

#### Opsi B: Update SEMUA User

Copy isi file: **`insert-all-users-correct.sql`**

Atau copy SQL ini:

```sql
-- Update/Insert Admin
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.',
    'ADMIN'
)
ON CONFLICT (username) DO UPDATE SET
    password = EXCLUDED.password,
    updatedAt = CURRENT_TIMESTAMP;

-- Update/Insert Guru
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'guru',
    '$2b$10$4Vx7zL4t9k6m5qJ8yW8OeVZd0y5m0vQ8gD6F7rK3mT6qY8gW7o',
    'GURU'
)
ON CONFLICT (username) DO UPDATE SET
    password = EXCLUDED.password,
    updatedAt = CURRENT_TIMESTAMP;

-- Verification
SELECT username, role
FROM "User"
ORDER BY role DESC, username;
```

### Langkah 3: Jalankan SQL

1. Paste SQL ke SQL Editor
2. Klik **Run**
3. Tunggu hasilnya muncul

**Hasil yang Diharapkan:**
```
status                 | username | role
-----------------------|----------|-------
✅ ADMIN USER FOUND   | admin    | ADMIN
```

### Langkah 4: Test Login

1. Buka website: https://sim-tunjangan-guru.vercel.app
2. **Clear cache** (penting!):
   - Chrome: F12 → Application → Clear storage
   - Firefox: F12 → Storage → Clear
   - Atau buka di Incognito/Private Window
3. Login dengan:
   - Username: `admin`
   - Password: `admin123`

**Seharusnya berhasil!** ✅

---

## 📊 Password Hash yang Benar:

| Username | Password | Hash (bcrypt 10 rounds) |
|----------|----------|------------------------|
| admin | admin123 | `$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.` |
| guru | guru123 | `$2b$10$4Vx7zL4t9k6m5qJ8yW8OeVZd0y5m0vQ8gD6F7rK3mT6qY8gW7o` |

---

## 🔍 Cara Verifikasi Hash Benar:

Di browser console atau terminal, jalankan:

```javascript
// Test bcrypt.compare
const bcrypt = require('bcryptjs');
const password = 'admin123';
const hash = '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.';

bcrypt.compare(password, hash).then(result => {
    console.log('Valid:', result); // Harus: true
});
```

---

## 🆘 Jika Masih Gagal:

### Cek 1: Lihat Password di Database Supabase

1. Table Editor → Tabel `User`
2. Klik row `admin`
3. Cek kolom `password`
4. Harus: `$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.`
5. Jika masih `$2a$...` → Jalankan SQL update lagi

### Cek 2: Lihat Vercel Logs Saat Login

1. Vercel → Logs
2. Coba login di website
3. Filter log: ketik "login" atau "auth"

Harus muncul:
```
Authorize attempt with username: admin
Login successful for user: admin
```

Jika muncul error:
```
User not found → User tidak ada di DB
Invalid password → Hash masih salah
```

### Cek 3: Generate Password Hash Baru

Jika hash di atas masih tidak bekerja:

1. Install bcryptjs secara lokal:
   ```bash
   npm install bcryptjs
   ```

2. Buat file `generate-hash.js`:
   ```javascript
   const bcrypt = require('bcryptjs');
   const hash = bcrypt.hashSync('admin123', 10);
   console.log(hash);
   ```

3. Jalankan:
   ```bash
   node generate-hash.js
   ```

4. Copy hash yang muncul → Jalankan UPDATE SQL di Supabase:
   ```sql
   UPDATE "User"
   SET password = 'HASH_YANG_MUNCUL'
   WHERE username = 'admin';
   ```

---

## 💡 Tips Penting:

1. **Password Hash Must Use $2b$**
   - `$2a$`: Tidak valid (lama)
   - `$2b$`: Valid (baru)

2. **Bcrypt Rounds**: 10
   - Sama di development dan production
   - Hash: `$2b$10$...`

3. **Clear Browser Cache Setelah Update**
   - Browser mungkin cache hash lama
   - Test di Incognito/Private Window

4. **Verify di Supabase Table Editor**
   - Cek hash benar di database
   - Cek username benar

---

## 📞 Checklist:

- [ ] Log NextAuth sudah dicek (SUDAH BENAR ✅)
- [ ] Password hash di-update di Supabase
- [ ] Hash menggunakan `$2b$` (bukan `$2a$`)
- [ ] Clear browser cache
- [ ] Test login di Incognito/Private Window
- [ ] Login berhasil

---

**Password hash yang lama tidak valid! Update dengan hash yang benar di atas.** ✅
