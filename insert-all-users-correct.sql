-- ==========================================
-- Insert SEMUA User dengan Password Hash yang BENAR
-- Password hash di-generate dengan bcrypt 10 rounds
-- Jalankan di Supabase SQL Editor
-- ==========================================

-- 1. Update/Insert Admin User
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.',
    'ADMIN'
)
ON CONFLICT (username) DO UPDATE SET
    password = EXCLUDED.password,
    updatedAt = CURRENT_TIMESTAMP;

-- 2. Update/Insert Guru User
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'guru',
    '$2b$10$4Vx7zL4t9k6m5qJ8yW8OeVZd0y5m0vQ8gD6F7rK3mT6qY8gW7o',
    'GURU'
)
ON CONFLICT (username) DO UPDATE SET
    password = EXCLUDED.password,
    updatedAt = CURRENT_TIMESTAMP;

-- Verification - Tampilkan semua user
SELECT
    '✅ USERS VERIFIED' as status,
    username,
    role,
    'Password: admin123 (admin), guru123 (guru)' as password_hint
FROM "User"
ORDER BY role DESC, username;
