# ✅ Checklist Deployment

Sebelum upload, pastikan semua sudah siap:

## 📦 Persiapan Code

- [x] Project sudah berhasil di-build
- [x] Tidak ada error di build
- [ ] Semua file di-commit ke git
- [ ] Code sudah push ke GitHub

## 🗄️ Database (Supabase)

- [ ] Akun Supabase dibuat
- [ ] Project "sim-tunjangan-guru" dibuat
- [ ] SQL script `supabase-schema.sql` dijalankan
- [ ] Tabel berhasil dibuat
- [ ] Sample data berhasil di-insert
- [ ] Database URL di-copy
- [ ] Password database disimpan dengan aman

## 🔐 Authentication

- [ ] NEXTAUTH_SECRET digenerate
- [ ] NEXTAUTH_SECRET dicatat/simpan
- [ ] NEXTAUTH_URL siap (akan diupdate setelah deploy)

## 📤 GitHub

- [ ] Akun GitHub dibuat
- [ ] Repository "sim-tunjangan-guru" dibuat
- [ ] Git diinisialisasi: `git init`
- [ ] Files di-add: `git add .`
- [ ] Commit dibuat: `git commit -m "First commit"`
- [ ] Remote ditambahkan: `git remote add origin URL`
- [ ] Code di-push: `git push -u origin main`

## 🚀 Vercel

- [ ] Akun Vercel dibuat (login dengan GitHub)
- [ ] Project di-import dari GitHub
- [ ] Framework terdeteksi: Next.js
- [ ] Environment variables di-set:
  - [ ] DATABASE_URL ✓
  - [ ] NEXTAUTH_URL ✓
  - [ ] NEXTAUTH_SECRET ✓
- [ ] Deploy pertama berhasil
- [ ] Website URL dicatat
- [ ] NEXTAUTH_URL di-update dengan website URL
- [ ] Re-deploy dilakukan

## ✅ Testing Setelah Deploy

- [ ] Website bisa diakses
- [ ] Homepage muncul dengan benar
- [ ] Login admin berhasil
- [ ] Login guru berhasil
- [ ] Data Guru bisa dilihat
- [ ] Data DAK bisa dilihat
- [ ] Pagination berfungsi
- [ ] Search/filter berfungsi
- [ ] Export Excel berfungsi
- [ ] Export PDF berfungsi

## 🎉 Selesai!

Jika semua checklist sudah tercentang, website Anda sudah online! 🎊

---

## 📞 Troubleshooting

### Build Error di Vercel
- Cek `package.json` scripts
- Cek dependencies sudah terinstall

### Login Gagal
- Pastikan `NEXTAUTH_URL` sesuai dengan website URL
- Pastikan `NEXTAUTH_SECRET` sudah di-set

### Database Error
- Cek `DATABASE_URL` connection string
- Pastikan password database sudah benar
- Cek Supabase project sudah aktif

### Data Kosong
- Run SQL script di Supabase SQL Editor
- Cek tabel sudah terbuat
- Cek sample data sudah di-insert
