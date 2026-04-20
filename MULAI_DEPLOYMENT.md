# 🎯 Mulai Deployment Disini!

Website Anda sudah siap untuk di-upload ke hosting gratis (Vercel).

## 📚 Dokumentasi Tersedia:

### 1️⃣ Panduan Cepat (Pilih ini kalau mau langsung deploy)
📄 **[QUICK_DEPLOY.md](./QUICK_DEPLOY.md)**
- Panduan singkat 4 langkah
- Cocok untuk yang sudah familiar

### 2️⃣ Panduan Lengkap (Pilih ini kalau butuh detail lengkap)
📄 **[PANDUAN_DEPLOYMENT_VERCEL.md](./PANDUAN_DEPLOYMENT_VERCEL.md)**
- Penjelasan detail setiap langkah
- Termasuk troubleshooting
- Tips maintenance

### 3️⃣ Database Schema
📄 **[supabase-schema.sql](./supabase-schema.sql)**
- SQL script lengkap untuk database
- Termasuk sample data
- Siap di-import ke Supabase

### 4️⃣ Checklist
📄 **[DEPLOY_CHECKLIST.md](./DEPLOY_CHECKLIST.md)**
- Checklist step-by-step
- Tracking progress
- Testing checklist

---

## ⚡ Cara Paling Cepat (5 Menit):

### Step 1: Setup Database (3 menit)

**Jika error SQL: Baca [SOLUSI_SQL_SUPABASE.md](./SOLUSI_SQL_SUPABASE.md)**

1. Buka https://supabase.com → Sign up → New Project
2. Name: `sim-tunjangan-guru`
3. Buka SQL Editor → Copy isi file `supabase-schema.sql` → Paste → Run
4. Settings → Database → Connection String → Copy `postgresql://postgres:[PASS]@db.xxx.supabase.co:5432/postgres`

### Step 2: Upload ke GitHub (2 menit)

Buka terminal di folder project:

```bash
git init
git add .
git commit -m "SIM Tunjangan Guru - First commit"
git branch -M main
git remote add origin https://github.com/USERNAME-ANDA/sim-tunjangan-guru.git
git push -u origin main
```

**Ganti USERNAME-ANDA dengan username GitHub Anda!**

### Step 3: Deploy ke Vercel (3 menit)

1. Buka https://vercel.com → Sign up dengan GitHub
2. Add New → Project → Import `sim-tunjangan-guru`
3. Add Environment Variables:
   - `DATABASE_URL`: paste dari Supabase
   - `NEXTAUTH_URL`: `https://sim-tunjangan-guru.vercel.app`
   - `NEXTAUTH_SECRET`: buka https://generate-secret.vercel.app/32 dan copy
4. Click **Deploy**

### Step 4: Update NEXTAUTH_URL (1 menit)

1. Setelah deploy, copy URL Vercel (contoh: `https://sim-tunjangan-guru-xyz.vercel.app`)
2. Vercel → Settings → Environment Variables
3. Update `NEXTAUTH_URL` dengan URL tersebut
4. Deployments → Redeploy

**Selesai! 🎉 Website online!**

---

## 🔑 Akun Login:

**Admin:**
- Username: `admin`
- Password: `admin123`

**Guru:**
- Username: `198001012005011001`
- Password: `198001012005011001`

---

## 🆘 Butuh Bantuan?

**Error saat deploy?**
- Baca [DEPLOY_CHECKLIST.md](./DEPLOY_CHECKLIST.md) bagian Troubleshooting

**Butuh panduan detail?**
- Baca [PANDUAN_DEPLOYMENT_VERCEL.md](./PANDUAN_DEPLOYMENT_VERCEL.md)

**Database tidak connect?**
- Cek connection string Supabase
- Pastikan password benar
- Cek Supabase project sudah aktif

---

## 💰 Biaya Hosting:

- **Vercel**: Gratis (100GB bandwidth/month)
- **Supabase**: Gratis (500MB database)
- **Total**: Rp 0,00 💰

Website akan aktif selamanya tanpa biaya!

---

## ✨ Ready?

Semua file sudah siap:
- ✅ Code sudah di-build tanpa error
- ✅ Database schema siap
- ✅ Dokumentasi lengkap
- ✅ Environment variables example

**Mulai deployment sekarang!** 🚀

---

*Dibuat untuk memudahkan upload SIM Tunjangan Profesi Guru ke hosting gratis*
