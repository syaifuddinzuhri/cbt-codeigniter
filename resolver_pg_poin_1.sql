-- Resolver poin PG menjadi 1 dan sesuaikan target max score.
-- Jalankan di database CBT setelah backup database.
-- Fokus:
-- 1. Ubah poin dasar tes PG yang masih > 1 menjadi 1.
-- 2. Ubah nilai hasil peserta untuk soal PG:
--    - Tes dengan Essay: PG benar menjadi 1.
--    - Tes tanpa Essay: PG benar menjadi 100 / jumlah PG.
-- 3. Sesuaikan tes_max_score:
--    - Semua tes ditargetkan 100.
--    - Tes tanpa Essay menormalisasi nilai PG peserta ke skala 100.

START TRANSACTION;

-- Preview data tes yang poin PG-nya masih lebih dari 1.
SELECT
    tes_id,
    tes_nama,
    tes_score_right AS poin_pg_lama,
    tes_max_score AS max_score_lama
FROM cbt_tes
WHERE tes_score_right > 1
ORDER BY tes_id;

-- Preview nilai peserta untuk soal PG yang akan diubah menjadi 1.
SELECT
    t.tes_id,
    t.tes_nama,
    COUNT(*) AS jumlah_nilai_pg_diatas_1
FROM cbt_tes_soal ts
JOIN cbt_soal s ON s.soal_id = ts.tessoal_soal_id
JOIN cbt_tes_user tu ON tu.tesuser_id = ts.tessoal_tesuser_id
JOIN cbt_tes t ON t.tes_id = tu.tesuser_tes_id
WHERE s.soal_tipe = 1
  AND ts.tessoal_nilai > 1
GROUP BY t.tes_id, t.tes_nama
ORDER BY t.tes_id;

-- Hitung komposisi soal aktual dari peserta yang sudah pernah generate soal.
DROP TEMPORARY TABLE IF EXISTS tmp_tes_komposisi_aktual_per_peserta;
CREATE TEMPORARY TABLE tmp_tes_komposisi_aktual_per_peserta AS
SELECT
    tu.tesuser_tes_id AS tes_id,
    tu.tesuser_id,
    SUM(CASE WHEN s.soal_tipe = 2 THEN 1 ELSE 0 END) AS essay_count,
    SUM(CASE WHEN s.soal_tipe != 2 THEN 1 ELSE 0 END) AS objektif_count
FROM cbt_tes_user tu
JOIN cbt_tes_soal ts ON ts.tessoal_tesuser_id = tu.tesuser_id
JOIN cbt_soal s ON s.soal_id = ts.tessoal_soal_id
GROUP BY tu.tesuser_tes_id, tu.tesuser_id;

DROP TEMPORARY TABLE IF EXISTS tmp_tes_komposisi_aktual;
CREATE TEMPORARY TABLE tmp_tes_komposisi_aktual AS
SELECT
    tes_id,
    MAX(essay_count) AS essay_count,
    MAX(objektif_count) AS objektif_count
FROM tmp_tes_komposisi_aktual_per_peserta
GROUP BY tes_id;

-- Fallback untuk tes yang belum punya peserta: pakai paket soal.
DROP TEMPORARY TABLE IF EXISTS tmp_tes_komposisi_paket;
CREATE TEMPORARY TABLE tmp_tes_komposisi_paket AS
SELECT
    tset_tes_id AS tes_id,
    SUM(CASE WHEN tset_tipe = 2 THEN tset_jumlah ELSE 0 END) AS essay_count,
    SUM(CASE WHEN tset_tipe != 2 THEN tset_jumlah ELSE 0 END) AS objektif_count
FROM cbt_tes_topik_set
GROUP BY tset_tes_id;

DROP TEMPORARY TABLE IF EXISTS tmp_tes_tanpa_essay;
CREATE TEMPORARY TABLE tmp_tes_tanpa_essay AS
SELECT
    t.tes_id,
    COALESCE(a.objektif_count, p.objektif_count, 0) AS objektif_count
FROM cbt_tes t
LEFT JOIN tmp_tes_komposisi_aktual a ON a.tes_id = t.tes_id
LEFT JOIN tmp_tes_komposisi_paket p ON p.tes_id = t.tes_id
WHERE COALESCE(a.essay_count, p.essay_count, 0) = 0
  AND COALESCE(a.objektif_count, p.objektif_count, 0) > 0;

DROP TEMPORARY TABLE IF EXISTS tmp_tes_dengan_essay;
CREATE TEMPORARY TABLE tmp_tes_dengan_essay AS
SELECT
    t.tes_id
FROM cbt_tes t
LEFT JOIN tmp_tes_komposisi_aktual a ON a.tes_id = t.tes_id
LEFT JOIN tmp_tes_komposisi_paket p ON p.tes_id = t.tes_id
WHERE COALESCE(a.essay_count, p.essay_count, 0) > 0;

-- Tes dengan Essay: PG benar/lama menjadi 1, Essay mengisi sisa nilai menuju 100.
UPDATE cbt_tes_soal ts
JOIN cbt_soal s ON s.soal_id = ts.tessoal_soal_id
JOIN cbt_tes_user tu ON tu.tesuser_id = ts.tessoal_tesuser_id
JOIN tmp_tes_dengan_essay te ON te.tes_id = tu.tesuser_tes_id
SET ts.tessoal_nilai = 1
WHERE s.soal_tipe = 1
  AND ts.tessoal_nilai > 1;

-- Tes tanpa Essay: nilai akhir tetap skala 100.
-- Contoh 45 PG: tiap PG benar bernilai 100/45 = 2.2222.
UPDATE cbt_tes_soal ts
JOIN cbt_soal s ON s.soal_id = ts.tessoal_soal_id
JOIN cbt_tes_user tu ON tu.tesuser_id = ts.tessoal_tesuser_id
JOIN tmp_tes_tanpa_essay te ON te.tes_id = tu.tesuser_tes_id
SET ts.tessoal_nilai = ROUND(100 / te.objektif_count, 4)
WHERE s.soal_tipe = 1
  AND ts.tessoal_nilai > 0;

-- Update poin dasar tes agar pengerjaan berikutnya memberi poin PG = 1.
UPDATE cbt_tes
SET tes_score_right = 1
WHERE tes_score_right > 1;

-- Update target max score.
-- Semua tes memakai target nilai akhir 100.
UPDATE cbt_tes
SET tes_max_score = 100;

-- Validasi setelah update.
SELECT
    tes_id,
    tes_nama,
    tes_score_right AS poin_pg_baru,
    tes_max_score AS max_score_baru
FROM cbt_tes
ORDER BY tes_id;

SELECT
    t.tes_id,
    t.tes_nama,
    tu.tesuser_id,
    SUM(ts.tessoal_nilai) AS nilai_akhir_baru,
    t.tes_max_score AS nilai_maksimal
FROM cbt_tes_user tu
JOIN cbt_tes t ON t.tes_id = tu.tesuser_tes_id
JOIN cbt_tes_soal ts ON ts.tessoal_tesuser_id = tu.tesuser_id
JOIN tmp_tes_tanpa_essay te ON te.tes_id = t.tes_id
GROUP BY t.tes_id, t.tes_nama, tu.tesuser_id, t.tes_max_score
ORDER BY t.tes_id, tu.tesuser_id;

SELECT
    COUNT(*) AS sisa_nilai_pg_diatas_1_di_tes_dengan_essay
FROM cbt_tes_soal ts
JOIN cbt_soal s ON s.soal_id = ts.tessoal_soal_id
JOIN cbt_tes_user tu ON tu.tesuser_id = ts.tessoal_tesuser_id
JOIN tmp_tes_dengan_essay te ON te.tes_id = tu.tesuser_tes_id
WHERE s.soal_tipe = 1
  AND ts.tessoal_nilai > 1;

-- Jika hasil validasi sudah benar:
COMMIT;

-- Jika ingin membatalkan saat masih mengecek, ganti COMMIT di atas menjadi ROLLBACK.
