# 🚀 Panduan Upload Website ke Vercel (Hosting Gratis)

## 📋 Persiapan Sebelum Upload

### 1. Buat Akun Supabase (Database Gratis)

1. Buka https://supabase.com
2. Klik "Start your project"
3. Sign up atau login dengan GitHub/Google
4. Klik "New Project"
5. Isi form:
   - **Name**: sim-tunjangan-guru
   - **Database Password**: (buat password yang kuat, simpan baik-baik)
   - **Region**: Singapore (Southeast Asia)
   - **Pricing Plan**: Free
6. Klik "Create new project" dan tunggu 2-3 menit

### 2. Setup Database di Supabase

1. Setelah project jadi, masuk ke dashboard Supabase
2. Pergi ke menu **SQL Editor** di sidebar kiri
3. Copy kode SQL dari file `supabase-schema.sql`
4. Paste ke SQL Editor
5. Klik **Run** untuk menjalankan query

### 3. Dapatkan Database Connection String

1. Di dashboard Supabase, pergi ke menu **Settings** > **Database**
2. Scroll ke bagian **Connection String**
3. Pilih **URI** (bukan Session)
4. Copy connection string yang terlihat seperti:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxx.supabase.co:5432/postgres
   ```
5. **PENTING**: Ganti `[YOUR-PASSWORD]` dengan password yang Anda buat saat create project

---

## 📤 Cara Upload ke Vercel

### Opsi 1: Upload dengan GitHub (Disarankan)

#### Langkah 1: Push Code ke GitHub

1. Buat akun GitHub di https://github.com (jika belum punya)
2. Buat repository baru:
   - Klik **+** di pojok kanan atas
   - Pilih **New repository**
   - Repository name: `sim-tunjangan-guru`
   - Pilih **Public**
   - Klik **Create repository**

3. Install Git (jika belum ada):
   - Windows: https://git-scm.com/downloads
   - Mac: `git sudah ada`

4. Push code ke GitHub:

   **Buka terminal/CMD di folder project**, lalu jalankan:

   ```bash
   # Inisialisasi git
   git init

   # Tambah semua file
   git add .

   # Commit dengan pesan
   git commit -m "First commit - SIM Tunjangan Profesi Guru"

   # Tambah remote GitHub (GANTI USERNAME dengan username GitHub Anda)
   git remote add origin https://github.com/USERNAME/sim-tunjangan-guru.git

   # Push ke GitHub
   git branch -M main
   git push -u origin main
   ```

#### Langkah 2: Deploy ke Vercel

1. Buka https://vercel.com
2. Sign up atau login dengan **GitHub** (sangat disarankan)
3. Klik **"Add New..."** > **"Project"**

4. Import dari GitHub:
   - Anda akan melihat repository `sim-tunjangan-guru`
   - Klik **Import**

5. Configure project:
   - **Framework Preset**: Next.js (otomatis terdeteksi)
   - **Root Directory**: `./` (biarkan default)
   - Klik **Configure** di bagian Environment Variables

6. Add Environment Variables:

   Klik **Add New** dan tambahkan:

   | Variable Name | Value |
   |--------------|--------|
   | `DATABASE_URL` | Paste connection string dari Supabase |
   | `NEXTAUTH_URL` | `https://nama-project.vercel.app` (ganti nanti setelah deploy) |
   | `NEXTAUTH_SECRET` | Generate random string, bisa dari https://generate-secret.vercel.app/32 |

7. Klik **Deploy**

8. Tunggu 2-5 menit, website akan aktif!

#### Langkah 3: Update NEXTAUTH_URL

1. Setelah deploy selesai, Vercel akan memberikan URL seperti:
   - `https://sim-tunjangan-guru-xyz.vercel.app`

2. Di dashboard Vercel:
   - Klik **Settings** > **Environment Variables**
   - Cari `NEXTAUTH_URL`
   - Update dengan URL website Anda
   - Klik **Save**

3. Re-deploy:
   - Klik **Deployments** di sidebar
   - Klik titik tiga (...) di deploy terbaru
   - Pilih **Redeploy**

---

### Opsi 2: Upload Tanpa Git (Vercel CLI)

Jika Anda tidak ingin menggunakan GitHub:

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Login ke Vercel:
   ```bash
   vercel login
   ```

3. Deploy:
   ```bash
   vercel
   ```

4. Ikuti instruksi di terminal dan masukkan Environment Variables saat diminta.

---

## ✅ Setelah Deploy

### 1. Test Website

Buka URL yang diberikan Vercel, lalu:
- Test login admin: `admin` / `admin123`
- Test login guru: `198001012005011001` / `198001012005011001`
- Cek semua fitur berfungsi

### 2. Masalah yang Mungkin Terjadi

**Problem 1: Login gagal di production**
- Pastikan `NEXTAUTH_URL` sudah diupdate dengan URL website yang benar
- Pastikan `NEXTAUTH_SECRET` sudah di-set

**Problem 2: Database tidak connect**
- Cek `DATABASE_URL` di Vercel Environment Variables
- Pastikan connection string dari Supabase sudah benar

**Problem 3: Data kosong**
- Run SQL script di Supabase SQL Editor
- Pastikan tabel dan data sudah di-import

---

## 🔧 Maintenance

### Update Website

**Dengan GitHub:**
1. Edit code di komputer
2. Push ke GitHub:
   ```bash
   git add .
   git commit -m "Update feature"
   git push
   ```
3. Vercel akan otomatis redeploy!

**Tanpa GitHub:**
1. Edit code di komputer
2. Jalankan:
   ```bash
   vercel --prod
   ```

### Backup Database

1. Di Supabase dashboard:
   - Settings > Database
   - Scroll ke bawah ke "Backups"
   - Supabase membuat backup otomatis (gratis)

---

## 📞 Bantuan

- **Vercel Docs**: https://vercel.com/docs
- **Supabase Docs**: https://supabase.com/docs
- **Next.js Docs**: https://nextjs.org/docs

---

## 🎉 Selesai!

Website Anda sekarang sudah online dan bisa diakses dari mana saja!

URL Website: `https://nama-project.vercel.app`

**Catatan:**
- Gratis: Vercel (100GB bandwidth/month) + Supabase (500MB database)
- Tanpa batas waktu: Website akan aktif selamanya
- SSL/HTTPS: Otomatis gratis dari Vercel

---

## 📌 Checklist Deployment

- [ ] Akun Supabase dibuat
- [ ] Database setup dengan SQL script
- [ ] Database connection string di-copy
- [ ] Akun GitHub dibuat
- [ ] Code push ke GitHub
- [ ] Project import ke Vercel
- [ ] Environment variables di-set
- [ ] Deploy berhasil
- [ ] Login test berhasil
- [ ] NEXTAUTH_URL di-update
- [ ] Re-deploy
- [ ] Website online! ✅
