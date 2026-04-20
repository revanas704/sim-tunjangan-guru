-- ==========================================
-- Insert User Admin ke Supabase (Password Hash yang BENAR)
-- Jalankan ini di Supabase SQL Editor
-- ==========================================

-- Update password admin yang sudah ada dengan hash yang benar
UPDATE "User"
SET password = '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.'
WHERE username = 'admin';

-- Jika user admin belum ada, insert baru
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2b$10$o28x/Cl84DaxXkknEZ4tlOsDF/mTi8li/vbO775/yUyo4zpTxoKA.',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;

-- Verifikasi - Cek user admin
SELECT
    '✅ ADMIN USER FOUND' as status,
    username,
    role,
    CASE
        WHEN username = 'admin' THEN '✅ Username BENAR'
        ELSE '❌ Username SALAH'
    END as username_check
FROM "User"
WHERE username = 'admin';

-- Test password verification (opsional - hanya untuk info)
SELECT
    '✅ Password hash updated' as info,
    'Password: admin123' as password_hint,
    'Hash version: $2b$ (bcrypt 10 rounds)' as hash_info;
