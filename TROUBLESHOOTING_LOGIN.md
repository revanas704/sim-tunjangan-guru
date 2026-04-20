# 🔍 Troubleshooting Login di Vercel - Lengkap

## Masalah:
```
Username atau password salah
```
Padahal credentials benar:
- Username: `admin`
- Password: `admin123`

---

## 📊 Alur Perbaikan (Ikuti Urutan Ini!):

```
START
  ↓
┌─────────────────────────────┐
│ 1. Update NEXTAUTH_URL   │ ← Mulai dari sini (95% berhasil)
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ 2. Cek User di Database │ ← Kalau masih gagal
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ 3. Generate New Secret    │ ← Kalau masih gagal
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ 4. Check Vercel Logs     │ ← Untuk cari error
└─────────────────────────────┘
  ↓
SUCCESS ✅
```

---

## 🎯 LANGKAH 1: Update NEXTAUTH_URL (WAJIB!)

### Screenshot Visual:

```
┌─────────────────────────────────────────────────┐
│  https://sim-tunjangan-guru.vercel.app    │ ← Copy ini!
│  [Copy URL]                               │
└─────────────────────────────────────────────────┘

↓

┌─────────────────────────────────────────────────┐
│  Vercel → Settings → Environment Variables  │
│                                             │
│  Variable Name: NEXTAUTH_URL                │
│  Value: https://sim-tunjangan-guru.vercel.app  ← Paste!
│                                             │
│  [Save]                                    │
└─────────────────────────────────────────────────┘

↓

┌─────────────────────────────────────────────────┐
│  Deployments → [Redeploy]                  │
│  Tunggu 2-3 menit...                     │
└─────────────────────────────────────────────────┘

↓

┌─────────────────────────────────────────────────┐
│  Buka website di Incognito/Private Window     │
│  Login: admin / admin123                   │
└─────────────────────────────────────────────────┘
```

### Contoh NEXTAUTH_URL yang SALAH ❌:

```
❌ http://localhost:3000
❌ http://sim-tunjangan-guru.vercel.app
❌ https://localhost:3000
❌ (kosong)
```

### Contoh NEXTAUTH_URL yang BENAR ✅:

```
✅ https://sim-tunjangan-guru.vercel.app
✅ https://sim-tunjangan-guru-abc123.vercel.app
✅ https://nama-domain-custom.com (jika pakai custom domain)
```

---

## 👤 LANGKAH 2: Cek User Admin di Database

### Buka Supabase → Table Editor → Tabel `User`

#### Skenario A: User Admin ADA ✅

```
┌────────────────────────────────┐
│ id       username  role     │
│ -------- --------- --------   │
│ xxxxx    admin    ADMIN    │ ← Ada!
│ xxxxx    guru     GURU     │
└────────────────────────────────┘
```
**Action**: Langsung ke LANGKAH 1 (Update NEXTAUTH_URL)

#### Skenario B: User Admin TIDAK ADA ❌

```
┌────────────────────────────────┐
│ id       username  role     │
│ -------- --------- --------   │
│ xxxxx    guru     GURU     │ ← Admin tidak ada!
└────────────────────────────────┘
```
**Action**: Insert user admin

### Insert User Admin via SQL Editor

Buka SQL Editor → Jalankan:

```sql
-- Insert Admin User
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;
```

Atau pakai file yang sudah disiapkan:
- File: `insert-admin-user.sql`
- Copy → Paste → Run

### Atau Insert via Table Editor

1. Buka Table Editor → Tabel `User`
2. Klik **Insert row** (+ icon)
3. Isi:
   ```
   id: (biarkan kosong)
   username: admin
   password: $2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u
   role: ADMIN
   guruId: (biarkan null)
   ```
4. Klik **Save**

---

## 🔐 LANGKAH 3: Generate New NEXTAUTH_SECRET

### Generate Secret Baru

1. Buka: https://generate-secret.vercel.app/32
2. Copy secret yang muncul

### Update di Vercel

1. Vercel → Settings → Environment Variables
2. Cari `NEXTAUTH_SECRET`
3. Paste secret baru
4. Klik **Save**

### Redeploy

Deployments → Redeploy

---

## 📋 LANGKAH 4: Check Vercel Logs

### Buka Logs

1. Vercel → **Logs** (tab di sidebar)
2. Pilih deployment terbaru
3. Filter log: ketik "login" atau "auth"

### Cari Error Pattern:

#### Pattern 1: JWT Error

```
JWEDecryptionFailed: decryption operation failed
```
**Penyebab**: NEXTAUTH_SECRET berbeda
**Solusi**: Generate baru NEXTAUTH_SECRET (LANGKAH 3)

#### Pattern 2: NextAuth URL Error

```
[error][NEXTAUTH_URL]
```
**Penyebab**: NEXTAUTH_URL salah atau tidak di-set
**Solusi**: Update NEXTAUTH_URL (LANGKAH 1)

#### Pattern 3: Database Error

```
Error: connection refused
Error: authentication failed
```
**Penyebab**: DATABASE_URL salah
**Solusi**:
1. Cek DATABASE_URL di Vercel → Environment Variables
2. Copy dari Supabase: Settings → Database → Connection String → URI
3. Update: Ganti `[PASSWORD]` dengan password database

#### Pattern 4: User Not Found

```
User not found
Authorize attempt with username: admin
User not found
```
**Penyebab**: User tidak ada di database
**Solusi**: Insert user admin (LANGKAH 2)

#### Pattern 5: Invalid Password

```
Login attempt with username: admin
Invalid password
```
**Penyebab**: Password hash salah
**Solusi**: Update password dengan hash yang benar

---

## 🧪 LANGKAH 5: Test dengan Berbagai Cara

### 1. Test di Incognito/Private Window

**Chrome**: `Ctrl + Shift + N`
**Firefox**: `Ctrl + Shift + P`
**Safari**: `Cmd + Shift + N`

### 2. Clear Browser Cache

**Chrome**:
1. F12 → Application → Clear storage → Clear site data

**Firefox**:
1. F12 → Storage → Clear

**Safari**:
1. Preferences → Privacy → Manage Website Data → Remove

### 3. Test di Different Browser

Test di browser lain:
- Chrome → Firefox → Edge → Safari

### 4. Test di Mobile

Buka website di mobile browser dan coba login

---

## 📞 Checklist Sebelum Contact Support:

✅ Langkah 1: NEXTAUTH_URL sudah diupdate
✅ Langkah 2: User admin ada di database
✅ Langkah 3: NEXTAUTH_SECRET sudah di-generate baru
✅ Langkah 4: Logs sudah dicek
✅ Langkah 5: Clear cache dan test di incognito
✅ DATABASE_URL sudah dicek dan benar
✅ Redeploy sudah dilakukan
✅ Test di browser berbeda

Jika semua checklist sudah tercentang dan masih gagal, berikan info:
- Screenshot error dari Vercel Logs
- URL website
- NextAuth configuration dari Vercel Environment Variables

---

## 💾 File Bantuan:

| File | Deskripsi |
|------|-----------|
| `FIX_LOGIN_VERCEL.md` | Panduan lengkap perbaikan login |
| `QUICK_FIX_LOGIN.md` | Panduan cepat 4 langkah |
| `insert-admin-user.sql` | SQL insert user admin |
| `supabase-schema.sql` | Full database schema |

---

## 🆘 Last Resort: Reset Everything

### 1. Reset Database

1. Hapus semua tabel di Supabase Table Editor
2. Jalankan `supabase-schema.sql` di SQL Editor

### 2. Reset Vercel Environment Variables

1. Vercel → Settings → Environment Variables
2. Hapus semua variables
3. Tambah ulang:
   - DATABASE_URL: (dari Supabase)
   - NEXTAUTH_URL: (URL website)
   - NEXTAUTH_SECRET: (generate baru)

### 3. Redeploy

Deployments → Redeploy

### 4. Test Login

Username: `admin` / Password: `admin123`

---

**Ikuti urutan langkah di atas untuk memperbaiki masalah login!** ✅
