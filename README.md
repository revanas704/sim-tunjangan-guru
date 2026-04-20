# 🎓 SIM Tunjangan Profesi Guru

Sistem Informasi Manajemen Tunjangan Profesi Guru dengan DAK Non Fisik.

## 🚀 Deploy ke Hosting Gratis

### Cara Paling Mudah:

Baca panduan lengkap di: **[PANDUAN_DEPLOYMENT_VERCEL.md](./PANDUAN_DEPLOYMENT_VERCEL.md)**

### Quick Start:

1. **Setup Database (Supabase - Gratis)**
   - https://supabase.com → New Project
   - Import `supabase-schema.sql` di SQL Editor
   - Copy Database URL

2. **Upload to GitHub**
   ```bash
   git init
   git add .
   git commit -m "First commit"
   git remote add origin https://github.com/USERNAME/sim-tunjangan-guru.git
   git push -u origin main
   ```

3. **Deploy to Vercel (Gratis)**
   - https://vercel.com → New Project
   - Import dari GitHub
   - Set environment variables:
     - `DATABASE_URL` = dari Supabase
     - `NEXTAUTH_URL` = URL website
     - `NEXTAUTH_SECRET` = random secret
   - Deploy!

## 📋 Fitur

### ✅ Admin
- Dashboard dengan statistik
- Manajemen data Guru (CRUD)
- Manajemen Pengajuan (Approve/Reject)
- DAK Non Fisik:
  - Import dari Excel
  - Export ke Excel/PDF
  - Kelola status penyaluran
  - Lihat detail penerima dengan pagination

### ✅ Guru
- Dashboard informasi pribadi
- Form pengajuan tunjangan
- Lihat status pengajuan
- DAK Non Fisik:
  - Lihat penyaluran DAK
  - Lihat detail penerima per guru
  - Download laporan

## 🔐 Akun Default

### Admin
- Username: `admin`
- Password: `admin123`

### Guru
- Username: `198001012005011001`
- Password: `198001012005011001`

## 🛠️ Tech Stack

- **Framework**: Next.js 16 (App Router)
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 4 + shadcn/ui
- **Database**: Prisma ORM
- **Auth**: NextAuth.js v4
- **Hosting**: Vercel (Gratis)
- **Database Hosting**: Supabase (Gratis)

## 📦 Install Lokal

```bash
# Install dependencies
bun install

# Setup database
bun run db:push

# Seed data (opsional)
bun run db:seed

# Run dev server
bun run dev
```

Buka: http://localhost:3000

## 🔧 Environment Variables

```env
DATABASE_URL=postgresql://user:password@host:port/database
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=random-secret-key
```

## 📚 Dokumentasi

- **Panduan Deployment**: [PANDUAN_DEPLOYMENT_VERCEL.md](./PANDUAN_DEPLOYMENT_VERCEL.md)
- **Quick Deploy**: [QUICK_DEPLOY.md](./QUICK_DEPLOY.md)
- **Database Schema**: [supabase-schema.sql](./supabase-schema.sql)

## 📞 Support

Jika ada masalah:
1. Cek dokumen deployment
2. Cek environment variables
3. Restart dev server: Ctrl+C → `bun run dev`

---

**Dibuat dengan ❤️ untuk Guru Indonesia**
