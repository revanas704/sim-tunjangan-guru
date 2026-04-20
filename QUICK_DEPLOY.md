# ⚡ Panduan Cepat Upload ke Vercel

## 📋 Langkah 1: Setup Supabase (Database)

1. Buka: https://supabase.com → Sign up/login → New Project
2. Project name: `sim-tunjangan-guru`
3. Set password dan region: Singapore → Create Project
4. Tunggu 2-3 menit

### Import Database

1. Di Supabase → SQL Editor (sidebar kiri)
2. Copy seluruh isi file: `supabase-schema.sql`
3. Paste ke SQL Editor
4. Klik **Run**

### Get Database URL

1. Settings → Database → Connection String → URI
2. Copy: `postgresql://postgres:[PASSWORD]@db.xxx.supabase.co:5432/postgres`
3. **PENTING**: Ganti `[PASSWORD]` dengan password project Anda

---

## 📤 Langkah 2: Upload ke GitHub

### Buat Repository GitHub

1. Buka: https://github.com/new
2. Repository name: `sim-tunjangan-guru`
3. Pilih **Public** → Create repository

### Push Code ke GitHub

Buka terminal di folder project dan jalankan:

```bash
git init
git add .
git commit -m "First commit"
git branch -M main
git remote add origin https://github.com/USERNAME-GITHUB-ANDA/sim-tunjangan-guru.git
git push -u origin main
```

**Ganti USERNAME-GITHUB-ANDA dengan username GitHub Anda!**

---

## 🚀 Langkah 3: Deploy ke Vercel

1. Buka: https://vercel.com → Sign up dengan **GitHub**
2. Klik **Add New** → **Project**
3. Pilih repository: `sim-tunjangan-guru`
4. Klik **Import**

### Setup Environment Variables

Klik **Configure** → Add environment variables:

| Key | Value |
|-----|-------|
| `DATABASE_URL` | Paste database URL dari Supabase |
| `NEXTAUTH_URL` | `https://sim-tunjangan-guru.vercel.app` (update nanti) |
| `NEXTAUTH_SECRET` | Generate di: https://generate-secret.vercel.app/32 |

Klik **Deploy** → Tunggu 3-5 menit

---

## ✅ Langkah 4: Update NEXTAUTH_URL

1. Setelah deploy selesai, copy URL dari Vercel (contoh: `https://sim-tunjangan-guru-abc123.vercel.app`)
2. Di Vercel → Settings → Environment Variables
3. Update `NEXTAUTH_URL` dengan URL tersebut
4. Save → Deployments → Redeploy

---

## 🎉 Selesai!

Website online di: `https://sim-tunjangan-guru.vercel.app`

### Test Login:
- **Admin**: `admin` / `admin123`
- **Guru**: `198001012005011001` / `198001012005011001`

---

## 📞 Error? Check:

1. **Login gagal** → Cek `NEXTAUTH_URL` di Vercel settings
2. **Database error** → Cek `DATABASE_URL` connection string
3. **Data kosong** → Run SQL script di Supabase SQL Editor

---

## 💰 Biaya:
- Vercel: **GRATIS** (100GB bandwidth/month)
- Supabase: **GRATIS** (500MB database)
- Total: **Rp 0** 💰
