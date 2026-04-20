-- ==========================================
-- SIM Tunjangan Profesi Guru - Supabase Schema
-- VERSION: 2.0 - FIXED (Safe deployment)
-- ==========================================

-- CATATAN PENTING:
-- 1. Script ini menggunakan pendekatan CREATE TABLE IF NOT EXISTS
-- 2. Foreign keys ditambahkan setelah tabel utama dibuat
-- 3. Aman untuk dijalankan berulang kali
-- 4. Menggunakan ON CONFLICT DO NOTHING untuk insert data

-- ==========================================
-- STEP 1: Buat tabel TANPA foreign key dulu
-- ==========================================

-- 1.1 Tabel Guru (Buat dulu karena jadi referensi User dan Pengajuan)
CREATE TABLE IF NOT EXISTS "Guru" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    nip TEXT UNIQUE NOT NULL,
    nama TEXT NOT NULL,
    nik TEXT,
    tempatLahir TEXT,
    tanggalLahir DATE,
    jenisKelamin TEXT,
    agama TEXT,
    alamat TEXT,
    noHp TEXT,
    email TEXT,
    pendidikanTerakhir TEXT,
    statusPegawai TEXT,
    statusGuru TEXT,
    tmtGuru DATE,
    sertifikasi TEXT,
    nomorSertifikasi TEXT,
    tanggalSertifikasi DATE,
    nuptk TEXT,
    mapel TEXT,
    unitKerja TEXT,
    jenisPtk TEXT,
    bank TEXT,
    nomorRekening TEXT,
    npwp TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.2 Tabel DAK Penyaluran
CREATE TABLE IF NOT EXISTS "DAKPenyaluran" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    jenis TEXT NOT NULL,
    kanwil TEXT,
    kppn TEXT,
    pemda TEXT,
    periode TEXT NOT NULL,
    gelombang TEXT NOT NULL,
    salurBruto NUMERIC(20, 2) DEFAULT 0,
    potPph NUMERIC(20, 2) DEFAULT 0,
    potJknPns NUMERIC(20, 2) DEFAULT 0,
    potJknPppk NUMERIC(20, 2) DEFAULT 0,
    nilaiRekomendasi NUMERIC(20, 2) DEFAULT 0,
    jumlahPenerima INTEGER DEFAULT 0,
    kirimKeDitPa BOOLEAN DEFAULT FALSE,
    kirimKeKppn BOOLEAN DEFAULT FALSE,
    durasiKerja TEXT,
    bankOperator TEXT,
    spp TEXT,
    sp2d TEXT,
    status TEXT DEFAULT 'UPLOAD_SELESAI' CHECK (status IN ('UPLOAD_SELESAI', 'DIKIRIM_KE_DJPK', 'DIKIRIM_KE_DITPA', 'SP2D')),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.3 Tabel DAK Detail Penerima
CREATE TABLE IF NOT EXISTS "DAKDetailPenerima" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    dakPenyaluranId TEXT NOT NULL,
    nip TEXT NOT NULL,
    nama TEXT NOT NULL,
    namaPemilikRekening TEXT,
    noRekening TEXT NOT NULL,
    bank TEXT,
    satdik TEXT,
    salurBruto NUMERIC(20, 2) DEFAULT 0,
    pph NUMERIC(20, 2) DEFAULT 0,
    potIjn NUMERIC(20, 2) DEFAULT 0,
    salurNetto NUMERIC(20, 2) DEFAULT 0,
    status TEXT DEFAULT 'BELUM_CAIR' CHECK (status IN ('BELUM_CAIR', 'CAIR')),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.4 Tabel Pengajuan
CREATE TABLE IF NOT EXISTS "Pengajuan" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    guruId TEXT NOT NULL,
    nip TEXT NOT NULL,
    nama TEXT NOT NULL,
    tahun TEXT NOT NULL,
    semester TEXT NOT NULL,
    status TEXT DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
    komentar TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.5 Tabel User
CREATE TABLE IF NOT EXISTS "User" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('ADMIN', 'GURU')),
    guruId TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- STEP 2: Tambahkan Foreign Keys secara manual
-- ==========================================

-- 2.1 FK untuk DAKDetailPenerima
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'dak_detail_penerima_dak_penyaluran_id_fkey'
    ) THEN
        ALTER TABLE "DAKDetailPenerima"
        ADD CONSTRAINT dak_detail_penerima_dak_penyaluran_id_fkey
        FOREIGN KEY (dakPenyaluranId) REFERENCES "DAKPenyaluran"(id) ON DELETE CASCADE;
    END IF;
END $$;

-- 2.2 FK untuk Pengajuan
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'pengajuan_guru_id_fkey'
    ) THEN
        ALTER TABLE "Pengajuan"
        ADD CONSTRAINT pengajuan_guru_id_fkey
        FOREIGN KEY (guruId) REFERENCES "Guru"(id) ON DELETE CASCADE;
    END IF;
END $$;

-- 2.3 FK untuk User
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'user_guru_id_fkey'
    ) THEN
        ALTER TABLE "User"
        ADD CONSTRAINT user_guru_id_fkey
        FOREIGN KEY (guruId) REFERENCES "Guru"(id) ON DELETE SET NULL;
    END IF;
END $$;

-- ==========================================
-- STEP 3: Buat Index
-- ==========================================

CREATE INDEX IF NOT EXISTS "idx_user_username" ON "User"(username);
CREATE INDEX IF NOT EXISTS "idx_user_role" ON "User"(role);
CREATE INDEX IF NOT EXISTS "idx_guru_nip" ON "Guru"(nip);
CREATE INDEX IF NOT EXISTS "idx_pengajuan_guruId" ON "Pengajuan"(guruId);
CREATE INDEX IF NOT EXISTS "idx_pengajuan_status" ON "Pengajuan"(status);
CREATE INDEX IF NOT EXISTS "idx_pengajuan_tahun_semester" ON "Pengajuan"(tahun, semester);
CREATE INDEX IF NOT EXISTS "idx_dak_penyaluran_periode" ON "DAKPenyaluran"(periode);
CREATE INDEX IF NOT EXISTS "idx_dak_penyaluran_status" ON "DAKPenyaluran"(status);
CREATE INDEX IF NOT EXISTS "idx_dak_detail_penyaluranId" ON "DAKDetailPenerima"(dakPenyaluranId);
CREATE INDEX IF NOT EXISTS "idx_dak_detail_nip" ON "DAKDetailPenerima"(nip);
CREATE INDEX IF NOT EXISTS "idx_dak_detail_nama" ON "DAKDetailPenerima"(nama);

-- ==========================================
-- STEP 4: Insert Default Data
-- ==========================================

-- 4.1 Insert Admin User
INSERT INTO "User" (username, password, role)
VALUES (
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;

-- 4.2 Insert Guru User
INSERT INTO "User" (username, password, role)
VALUES (
    'guru',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'GURU'
)
ON CONFLICT (username) DO NOTHING;

-- 4.3 Insert Sample Guru
INSERT INTO "Guru" (nip, nama, nik, tempatLahir, tanggalLahir, jenisKelamin, alamat, noHp, email, statusPegawai, bank, nomorRekening, unitKerja) VALUES
('198001012005011001', 'Ahmad Supriyadi', '3201120101800001', 'Jakarta', '1980-01-01', 'Laki-laki', 'Jl. Pendidikan No. 1', '081234567890', 'ahmad@email.com', 'PNS', 'BRI', '1234567890', 'SDN 1 Jakarta'),
('198502152010011002', 'Siti Aminah', '3204150202850002', 'Bandung', '1985-02-15', 'Perempuan', 'Jl. Guru No. 2', '081234567891', 'siti@email.com', 'PPPK', 'BNI', '0987654321', 'SDN 2 Bandung')
ON CONFLICT (nip) DO NOTHING;

-- 4.4 Insert Sample DAK Penyaluran
INSERT INTO "DAKPenyaluran" (jenis, kanwil, kppn, pemda, periode, gelombang, salurBruto, potPph, potJknPns, potJknPppk, nilaiRekomendasi, jumlahPenerima, status) VALUES
('TPP Triwulan I', 'Kanwil DJPB Jawa Barat', 'KPPN Bandung', 'Pemda Kota Bandung', '2025', '1', 5000000000, 50000000, 10000000, 20000000, 4920000000, 2, 'UPLOAD_SELESAI')
ON CONFLICT DO NOTHING;

-- 4.5 Insert Sample DAK Detail Penerima (Hanya jika DAKPenyaluran berhasil di-insert)
INSERT INTO "DAKDetailPenerima" (dakPenyaluranId, nip, nama, namaPemilikRekening, noRekening, bank, satdik, salurBruto, pph, potIjn, salurNetto, status)
SELECT
    (SELECT id FROM "DAKPenyaluran" WHERE jenis = 'TPP Triwulan I' AND periode = '2025' LIMIT 1),
    '198001012005011001', 'Ahmad Supriyadi', 'Ahmad Supriyadi', '1234567890', 'BRI', 'SDN 1 Jakarta', 2500000000, 25000000, 5000000, 2425000000, 'BELUM_CAIR'
WHERE EXISTS (SELECT 1 FROM "DAKPenyaluran" WHERE jenis = 'TPP Triwulan I' AND periode = '2025')
ON CONFLICT DO NOTHING;

INSERT INTO "DAKDetailPenerima" (dakPenyaluranId, nip, nama, namaPemilikRekening, noRekening, bank, satdik, salurBruto, pph, potIjn, salurNetto, status)
SELECT
    (SELECT id FROM "DAKPenyaluran" WHERE jenis = 'TPP Triwulan I' AND periode = '2025' LIMIT 1),
    '198502152010011002', 'Siti Aminah', 'Siti Aminah', '0987654321', 'BNI', 'SDN 2 Bandung', 2500000000, 25000000, 5000000, 2425000000, 'BELUM_CAIR'
WHERE EXISTS (SELECT 1 FROM "DAKPenyaluran" WHERE jenis = 'TPP Triwulan I' AND periode = '2025')
ON CONFLICT DO NOTHING;

-- ==========================================
-- STEP 5: Buat Trigger untuk update updatedAt
-- ==========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5.1 Trigger untuk User
DROP TRIGGER IF EXISTS update_user_updated_at ON "User";
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON "User"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5.2 Trigger untuk Guru
DROP TRIGGER IF EXISTS update_guru_updated_at ON "Guru";
CREATE TRIGGER update_guru_updated_at BEFORE UPDATE ON "Guru"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5.3 Trigger untuk Pengajuan
DROP TRIGGER IF EXISTS update_pengajuan_updated_at ON "Pengajuan";
CREATE TRIGGER update_pengajuan_updated_at BEFORE UPDATE ON "Pengajuan"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5.4 Trigger untuk DAKPenyaluran
DROP TRIGGER IF EXISTS update_dak_penyaluran_updated_at ON "DAKPenyaluran";
CREATE TRIGGER update_dak_penyaluran_updated_at BEFORE UPDATE ON "DAKPenyaluran"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5.5 Trigger untuk DAKDetailPenerima
DROP TRIGGER IF EXISTS update_dak_detail_updated_at ON "DAKDetailPenerima";
CREATE TRIGGER update_dak_detail_updated_at BEFORE UPDATE ON "DAKDetailPenerima"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- STEP 6: Verification
-- ==========================================

SELECT
    '✅ GURU' as table_name, COUNT(*) as row_count FROM "Guru"
UNION ALL
SELECT
    '✅ USER', COUNT(*) FROM "User"
UNION ALL
SELECT
    '✅ PENGAJUAN', COUNT(*) FROM "Pengajuan"
UNION ALL
SELECT
    '✅ DAK_PENYALURAN', COUNT(*) FROM "DAKPenyaluran"
UNION ALL
SELECT
    '✅ DAK_DETAIL_PENERIMA', COUNT(*) FROM "DAKDetailPenerima"
ORDER BY table_name;

-- ==========================================
-- DONE! Database setup selesai!
-- ==========================================
