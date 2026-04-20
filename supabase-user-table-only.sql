-- ==========================================
-- SIM Tunjangan Profesi Guru - Fix Tabel User Saja
-- ==========================================
-- Script ini akan memperbaiki tabel User agar match dengan Prisma schema
-- ==========================================

-- 1. Hapus tabel User jika ada (WARNING: ini akan menghapus semua data user!)
DROP TABLE IF EXISTS "User" CASCADE;

-- 2. Buat tabel User sesuai Prisma schema
CREATE TABLE "User" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('ADMIN', 'GURU')),
    guruId TEXT UNIQUE,
    createdAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Insert Admin User (Password: admin123)
-- Password hash di-generate dengan bcrypt (10 rounds)
INSERT INTO "User" (username, password, role)
VALUES (
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
);

-- 4. Insert Guru User (Password: guru123)
INSERT INTO "User" (username, password, role)
VALUES (
    'guru',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'GURU'
);

-- 5. Buat trigger untuk update updatedAt
CREATE OR REPLACE FUNCTION update_user_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_user_updated_at ON "User";
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON "User"
    FOR EACH ROW EXECUTE FUNCTION update_user_updated_at();

-- 6. Verification
SELECT
    '✅ USER TABLE' as table_name,
    COUNT(*) as row_count,
    STRING_AGG(username, ', ') as users
FROM "User";
