# ⚡ Perbaiki Login Admin CEPAT (2 Menit)

## Masalah:
Login gagal: "Username atau password salah"
Padahal: `admin` / `admin123`

---

## 🎯 SOLUSI PALING CEPAT:

### Langkah 1: Copy URL Website (30 detik)

1. Buka: https://vercel.com/dashboard
2. Klik project: `sim-tunjangan-guru`
3. Copy URL di bagian atas (contoh):
   ```
   https://sim-tunjangan-guru.vercel.app
   ```

### Langkah 2: Update NEXTAUTH_URL (30 detik)

1. Klik **Settings** → **Environment Variables**
2. Cari: `NEXTAUTH_URL`
3. Update dengan URL yang dicopy:
   ```
   https://sim-tunjangan-guru.vercel.app
   ```
4. **PENTING**: Harus pakai `https://` (bukan http)
5. Klik **Save**

### Langkah 3: Redeploy (1 menit)

1. Klik **Deployments** di sidebar
2. Di deploy terbaru → Klik titik tiga (...)
3. Pilih **Redeploy**
4. Tunggu 2-3 menit sampai selesai

### Langkah 4: Clear Cache & Login (30 detik)

1. **Buka website di incognito/private window**
2. Login dengan:
   - Username: `admin`
   - Password: `admin123`

---

## ✅ Selesai!

Jika masih gagal, baca panduan lengkap:

**[FIX_LOGIN_VERCEL.md](./FIX_LOGIN_VERCEL.md)**

---

## 🔍 Jika Masih Gagal:

### Cek 1: User Admin Ada di Database?

Buka Supabase → Table Editor → Tabel `User`

**Harus ada:**
- username: `admin`
- role: `ADMIN`

**Jika tidak ada:**

Buka SQL Editor → Jalankan:

```sql
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;
```

### Cek 2: Lihat Error di Vercel Logs

1. Vercel → **Logs**
2. Cari error yang muncul saat login

---

## 💬 Contoh NEXTAUTH_URL yang Benar:

| Salah | Benar |
|-------|--------|
| `http://localhost:3000` | `https://sim-tunjangan-guru.vercel.app` |
| `http://sim-tunjangan-guru.vercel.app` | `https://sim-tunjangan-guru.vercel.app` |
| `https://localhost:3000` | `https://sim-tunjangan-guru.vercel.app` |

---

**Ikuti 4 langkah di atas, 95% berhasil login!** ✅
