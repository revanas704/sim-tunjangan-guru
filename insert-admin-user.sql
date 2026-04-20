-- ==========================================
-- Insert User Admin ke Database Supabase
-- Jalankan ini jika user admin belum ada di database
-- ==========================================

-- Cek dan Insert Admin User
INSERT INTO "User" (id, username, password, role)
VALUES (
    gen_random_uuid(),
    'admin',
    '$2a$10$rO9k6LdJXqVQVqVWJvTLeTfJ6HjZV4WqKZfK7Y7Y6Hq3M8X5C0u',
    'ADMIN'
)
ON CONFLICT (username) DO NOTHING;

-- Verifikasi
SELECT
    username,
    role,
    CASE
        WHEN username = 'admin' THEN '✅ Admin user berhasil di-insert'
        ELSE '❌ Admin user tidak ditemukan'
    END as status
FROM "User"
WHERE username = 'admin';
