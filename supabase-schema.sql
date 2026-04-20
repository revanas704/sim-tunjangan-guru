-- ==========================================
-- SIM Tunjangan Profesi Guru - Supabase Schema
-- ==========================================

-- Hapus tabel jika ada (untuk fresh install)
DROP TABLE IF EXISTS "DAKDetailPenerima";
DROP TABLE IF EXISTS "DAKPenyaluran";
DROP TABLE IF EXISTS "Pengajuan";
DROP TABLE IF EXISTS "Guru";
DROP TABLE IF EXISTS "User";

-- ==========================================
-- Tabel User (Authentication)
-- ==========================================
CREATE TABLE "User" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('ADMIN', 'GURU')),
    guruId TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guruId) REFERENCES "Guru"(id) ON DELETE SET NULL
);

-- ==========================================
-- Tabel Guru
-- ==========================================
CREATE TABLE "Guru" (
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

-- ==========================================
-- Tabel Pengajuan
-- ==========================================
CREATE TABLE "Pengajuan" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    guruId TEXT NOT NULL,
    nip TEXT NOT NULL,
    nama TEXT NOT NULL,
    tahun TEXT NOT NULL,
    semester TEXT NOT NULL,
    status TEXT DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
    komentar TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guruId) REFERENCES "Guru"(id) ON DELETE CASCADE
);

-- ==========================================
-- Tabel DAK Penyaluran
-- ==========================================
CREATE TABLE "DAKPenyaluran" (
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

-- ==========================================
-- Tabel DAK Detail Penerima
-- ==========================================
CREATE TABLE "DAKDetailPenerima" (
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
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dakPenyaluranId) REFERENCES "DAKPenyaluran"(id) ON DELETE CASCADE
);

-- ==========================================
-- Index untuk optimasi query
-- ==========================================
CREATE INDEX "idx_user_username" ON "User"(username);
CREATE INDEX "idx_user_role" ON "User"(role);
CREATE INDEX "idx_guru_nip" ON "Guru"(nip);
CREATE INDEX "idx_pengajuan_guruId" ON "Pengajuan"(guruId);
CREATE INDEX "idx_pengajuan_status" ON "Pengajuan"(status);
CREATE INDEX "idx_pengajuan_tahun_semester" ON "Pengajuan"(tahun, semester);
CREATE INDEX "idx_dak_penyaluran_periode" ON "DAKPenyaluran"(periode);
CREATE INDEX "idx_dak_penyaluran_status" ON "DAKPenyaluran"(status);
CREATE INDEX "idx_dak_detail_penyaluranId" ON "DAKDetailPenerima"(dakPenyaluranId);
CREATE INDEX "idx_dak_detail_nip" ON "DAKDetailPenerima"(nip);
CREATE INDEX "idx_dak_detail_nama" ON "DAKDetailPenerima"(nama);

-- ==========================================
-- Insert Default Users
-- ==========================================

-- Insert Admin (Password: admin123)
INSERT INTO "User" (username, password, role)
VALUES (
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
);

-- Insert Guru (Password: guru123)
INSERT INTO "User" (username, password, role)
VALUES (
    'guru',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'GURU'
);

-- ==========================================
-- Insert Sample Data (Opsional - untuk testing)
-- ==========================================

-- Sample Guru
INSERT INTO "Guru" (nip, nama, nik, tempatLahir, tanggalLahir, jenisKelamin, alamat, noHp, email, statusPegawai, bank, nomorRekening, unitKerja) VALUES
('198001012005011001', 'Ahmad Supriyadi', '3201120101800001', 'Jakarta', '1980-01-01', 'Laki-laki', 'Jl. Pendidikan No. 1', '081234567890', 'ahmad@email.com', 'PNS', 'BRI', '1234567890', 'SDN 1 Jakarta'),
('198502152010011002', 'Siti Aminah', '3204150202850002', 'Bandung', '1985-02-15', 'Perempuan', 'Jl. Guru No. 2', '081234567891', 'siti@email.com', 'PPPK', 'BNI', '0987654321', 'SDN 2 Bandung');

-- Sample DAK Penyaluran
INSERT INTO "DAKPenyaluran" (jenis, kanwil, kppn, pemda, periode, gelombang, salurBruto, potPph, potJknPns, potJknPppk, nilaiRekomendasi, jumlahPenerima, status) VALUES
('TPP Triwulan I', 'Kanwil DJPB Jawa Barat', 'KPPN Bandung', 'Pemda Kota Bandung', '2025', '1', 5000000000, 50000000, 10000000, 20000000, 4920000000, 2, 'UPLOAD_SELESAI');

-- Sample DAK Detail Penerima
INSERT INTO "DAKDetailPenerima" (dakPenyaluranId, nip, nama, namaPemilikRekening, noRekening, bank, satdik, salurBruto, pph, potIjn, salurNetto, status) VALUES
((SELECT id FROM "DAKPenyaluran" LIMIT 1), '198001012005011001', 'Ahmad Supriyadi', 'Ahmad Supriyadi', '1234567890', 'BRI', 'SDN 1 Jakarta', 2500000000, 25000000, 5000000, 2425000000, 'BELUM_CAIR'),
((SELECT id FROM "DAKPenyaluran" LIMIT 1), '198502152010011002', 'Siti Aminah', 'Siti Aminah', '0987654321', 'BNI', 'SDN 2 Bandung', 2500000000, 25000000, 5000000, 2425000000, 'BELUM_CAIR');

-- ==========================================
-- Trigger untuk auto update updatedAt
-- ==========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger ke semua tabel
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON "User"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_guru_updated_at BEFORE UPDATE ON "Guru"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pengajuan_updated_at BEFORE UPDATE ON "Pengajuan"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dak_penyaluran_updated_at BEFORE UPDATE ON "DAKPenyaluran"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dak_detail_updated_at BEFORE UPDATE ON "DAKDetailPenerima"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- Done!
-- ==========================================
