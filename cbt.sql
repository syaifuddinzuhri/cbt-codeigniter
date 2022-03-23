SET
    SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

SET
    AUTOCOMMIT = 0;

START TRANSACTION;

SET
    time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `zyacbt` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;

USE `zyacbt`;

CREATE TABLE `cbt_jawaban` (
    `jawaban_id` bigint(20) UNSIGNED NOT NULL,
    `jawaban_soal_id` bigint(20) UNSIGNED NOT NULL,
    `jawaban_detail` text COLLATE utf8_unicode_ci NOT NULL,
    `jawaban_benar` tinyint(1) NOT NULL DEFAULT 0,
    `jawaban_aktif` tinyint(1) NOT NULL DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_konfigurasi` (
    `konfigurasi_id` int(11) NOT NULL,
    `konfigurasi_kode` varchar(50) NOT NULL,
    `konfigurasi_isi` varchar(500) NOT NULL,
    `konfigurasi_keterangan` varchar(100) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `cbt_modul` (
    `modul_id` bigint(20) UNSIGNED NOT NULL,
    `modul_nama` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `modul_aktif` tinyint(1) NOT NULL DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_sessions` (
    `id` varchar(128) NOT NULL,
    `ip_address` varchar(45) NOT NULL,
    `timestamp` int(10) UNSIGNED NOT NULL DEFAULT 0,
    `data` blob NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `cbt_soal` (
    `soal_id` bigint(20) UNSIGNED NOT NULL,
    `soal_topik_id` bigint(20) UNSIGNED NOT NULL,
    `soal_detail` text COLLATE utf8_unicode_ci NOT NULL,
    `soal_tipe` smallint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Pilihan ganda, 2=essay, 3=jawaban singkat',
    `soal_kunci` text COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Kunci untuk soal jawaban singkat',
    `soal_difficulty` smallint(6) NOT NULL DEFAULT 1,
    `soal_aktif` tinyint(1) NOT NULL DEFAULT 0,
    `soal_audio` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
    `soal_audio_play` int(11) NOT NULL DEFAULT 0,
    `soal_timer` smallint(10) DEFAULT NULL,
    `soal_inline_answers` tinyint(1) NOT NULL DEFAULT 0,
    `soal_auto_next` tinyint(1) NOT NULL DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_tes` (
    `tes_id` bigint(20) UNSIGNED NOT NULL,
    `tes_nama` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `tes_detail` text COLLATE utf8_unicode_ci NOT NULL,
    `tes_begin_time` datetime DEFAULT NULL,
    `tes_end_time` datetime DEFAULT NULL,
    `tes_duration_time` smallint(10) UNSIGNED NOT NULL DEFAULT 0,
    `tes_ip_range` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '*.*.*.*',
    `tes_results_to_users` tinyint(1) NOT NULL DEFAULT 0,
    `tes_detail_to_users` tinyint(1) NOT NULL DEFAULT 0,
    `tes_score_right` decimal(10, 2) DEFAULT 1.00,
    `tes_score_wrong` decimal(10, 2) DEFAULT 0.00,
    `tes_score_unanswered` decimal(10, 2) DEFAULT 0.00,
    `tes_max_score` decimal(10, 2) NOT NULL DEFAULT 0.00,
    `tes_token` tinyint(1) DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_tesgrup` (
    `tstgrp_tes_id` bigint(20) UNSIGNED NOT NULL,
    `tstgrp_grup_id` bigint(20) UNSIGNED NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_tes_soal` (
    `tessoal_id` bigint(20) UNSIGNED NOT NULL,
    `tessoal_tesuser_id` bigint(20) UNSIGNED NOT NULL,
    `tessoal_user_ip` varchar(39) COLLATE utf8_unicode_ci DEFAULT NULL,
    `tessoal_soal_id` bigint(20) UNSIGNED NOT NULL,
    `tessoal_jawaban_text` text COLLATE utf8_unicode_ci DEFAULT NULL,
    `tessoal_nilai` decimal(10, 2) DEFAULT NULL,
    `tessoal_creation_time` datetime DEFAULT NULL,
    `tessoal_display_time` datetime DEFAULT NULL,
    `tessoal_change_time` datetime DEFAULT NULL,
    `tessoal_reaction_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
    `tessoal_ragu` int(1) NOT NULL DEFAULT 0 COMMENT '1=ragu, 0=tidak ragu',
    `tessoal_order` smallint(6) NOT NULL DEFAULT 1,
    `tessoal_num_answers` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
    `tessoal_comment` text COLLATE utf8_unicode_ci DEFAULT NULL,
    `tessoal_audio_play` int(11) NOT NULL DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_tes_soal_jawaban` (
    `soaljawaban_tessoal_id` bigint(20) UNSIGNED NOT NULL,
    `soaljawaban_jawaban_id` bigint(20) UNSIGNED NOT NULL,
    `soaljawaban_selected` smallint(6) NOT NULL DEFAULT -1,
    `soaljawaban_order` smallint(6) NOT NULL DEFAULT 1,
    `soaljawaban_position` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_tes_token` (
    `token_id` int(11) NOT NULL,
    `token_isi` varchar(20) NOT NULL,
    `token_user_id` int(11) NOT NULL,
    `token_ts` timestamp NOT NULL DEFAULT current_timestamp(),
    `token_aktif` int(11) NOT NULL DEFAULT 1 COMMENT 'Umur Token dalam menit, 1 = 1 hari penuh',
    `token_tes_id` bigint(20) NOT NULL DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `cbt_tes_topik_set` (
    `tset_id` bigint(20) UNSIGNED NOT NULL,
    `tset_tes_id` bigint(20) UNSIGNED NOT NULL,
    `tset_topik_id` bigint(20) UNSIGNED NOT NULL,
    `tset_tipe` smallint(6) NOT NULL DEFAULT 1,
    `tset_difficulty` smallint(6) NOT NULL DEFAULT 1,
    `tset_jumlah` smallint(6) NOT NULL DEFAULT 1,
    `tset_jawaban` smallint(6) NOT NULL DEFAULT 0,
    `tset_acak_jawaban` int(11) NOT NULL DEFAULT 1,
    `tset_acak_soal` int(11) NOT NULL DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_tes_user` (
    `tesuser_id` bigint(20) UNSIGNED NOT NULL,
    `tesuser_tes_id` bigint(20) UNSIGNED NOT NULL,
    `tesuser_user_id` bigint(20) UNSIGNED NOT NULL,
    `tesuser_status` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
    `tesuser_creation_time` datetime NOT NULL,
    `tesuser_comment` text COLLATE utf8_unicode_ci DEFAULT NULL,
    `tesuser_token` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_topik` (
    `topik_id` bigint(20) UNSIGNED NOT NULL,
    `topik_modul_id` bigint(20) UNSIGNED NOT NULL DEFAULT 1,
    `topik_nama` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `topik_detail` text COLLATE utf8_unicode_ci DEFAULT NULL,
    `topik_aktif` tinyint(1) NOT NULL DEFAULT 0
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_user` (
    `user_id` bigint(20) UNSIGNED NOT NULL,
    `user_grup_id` bigint(20) UNSIGNED NOT NULL,
    `user_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `user_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `user_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `user_regdate` timestamp NOT NULL DEFAULT current_timestamp(),
    `user_ip` varchar(39) COLLATE utf8_unicode_ci DEFAULT NULL,
    `user_firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `user_birthdate` date DEFAULT NULL,
    `user_birthplace` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `user_level` smallint(3) UNSIGNED NOT NULL DEFAULT 1,
    `user_detail` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `cbt_user_grup` (
    `grup_id` bigint(20) UNSIGNED NOT NULL,
    `grup_nama` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

CREATE TABLE `user` (
    `id` int(11) NOT NULL,
    `username` varchar(100) NOT NULL,
    `password` varchar(255) NOT NULL,
    `nama` varchar(150) NOT NULL,
    `opsi1` varchar(75) NOT NULL,
    `opsi2` varchar(75) NOT NULL,
    `keterangan` varchar(150) NOT NULL,
    `level` varchar(50) NOT NULL,
    `ts` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_akses` (
    `id` int(11) NOT NULL,
    `level` varchar(75) NOT NULL,
    `kode_menu` varchar(50) NOT NULL,
    `add` int(2) NOT NULL DEFAULT 1 COMMENT '0=false, 1=true',
    `edit` int(2) NOT NULL DEFAULT 1 COMMENT '0=false, 1=true'
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_level` (
    `id` int(11) NOT NULL,
    `level` varchar(50) NOT NULL,
    `keterangan` varchar(100) DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_log` (
    `id` int(11) NOT NULL,
    `username` varchar(100) NOT NULL,
    `log` varchar(250) NOT NULL,
    `ts` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `user_menu` (
    `id` int(11) NOT NULL,
    `tipe` int(11) NOT NULL DEFAULT 1 COMMENT '0=parent, 1=child',
    `parent` varchar(50) DEFAULT NULL,
    `kode_menu` varchar(50) NOT NULL,
    `nama_menu` varchar(100) NOT NULL,
    `url` varchar(150) NOT NULL DEFAULT '#',
    `icon` varchar(75) NOT NULL DEFAULT 'fa fa-circle-o',
    `urutan` int(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

--
-- Indexes for table `cbt_jawaban`
--
ALTER TABLE
    `cbt_jawaban`
ADD
    PRIMARY KEY (`jawaban_id`),
ADD
    KEY `p_answer_question_id` (`jawaban_soal_id`);

--
-- Indexes for table `cbt_konfigurasi`
--
ALTER TABLE
    `cbt_konfigurasi`
ADD
    PRIMARY KEY (`konfigurasi_id`),
ADD
    UNIQUE KEY `konfigurasi_kode` (`konfigurasi_kode`);

--
-- Indexes for table `cbt_modul`
--
ALTER TABLE
    `cbt_modul`
ADD
    PRIMARY KEY (`modul_id`),
ADD
    UNIQUE KEY `ak_module_name` (`modul_nama`);

--
-- Indexes for table `cbt_sessions`
--
ALTER TABLE
    `cbt_sessions`
ADD
    PRIMARY KEY (`id`),
ADD
    KEY `ci_sessions_timestamp` (`timestamp`);

--
-- Indexes for table `cbt_soal`
--
ALTER TABLE
    `cbt_soal`
ADD
    PRIMARY KEY (`soal_id`),
ADD
    KEY `p_question_subject_id` (`soal_topik_id`);

--
-- Indexes for table `cbt_tes`
--
ALTER TABLE
    `cbt_tes`
ADD
    PRIMARY KEY (`tes_id`),
ADD
    UNIQUE KEY `ak_test_name` (`tes_nama`);

--
-- Indexes for table `cbt_tesgrup`
--
ALTER TABLE
    `cbt_tesgrup`
ADD
    PRIMARY KEY (`tstgrp_tes_id`, `tstgrp_grup_id`),
ADD
    KEY `p_tstgrp_test_id` (`tstgrp_tes_id`),
ADD
    KEY `p_tstgrp_group_id` (`tstgrp_grup_id`);

--
-- Indexes for table `cbt_tes_soal`
--
ALTER TABLE
    `cbt_tes_soal`
ADD
    PRIMARY KEY (`tessoal_id`),
ADD
    UNIQUE KEY `ak_testuser_question` (`tessoal_tesuser_id`, `tessoal_soal_id`),
ADD
    KEY `p_testlog_question_id` (`tessoal_soal_id`),
ADD
    KEY `p_testlog_testuser_id` (`tessoal_tesuser_id`);

--
-- Indexes for table `cbt_tes_soal_jawaban`
--
ALTER TABLE
    `cbt_tes_soal_jawaban`
ADD
    PRIMARY KEY (
        `soaljawaban_tessoal_id`,
        `soaljawaban_jawaban_id`
    ),
ADD
    KEY `p_logansw_answer_id` (`soaljawaban_jawaban_id`),
ADD
    KEY `p_logansw_testlog_id` (`soaljawaban_tessoal_id`);

--
-- Indexes for table `cbt_tes_token`
--
ALTER TABLE
    `cbt_tes_token`
ADD
    PRIMARY KEY (`token_id`),
ADD
    KEY `token_user_id` (`token_user_id`);

--
-- Indexes for table `cbt_tes_topik_set`
--
ALTER TABLE
    `cbt_tes_topik_set`
ADD
    PRIMARY KEY (`tset_id`),
ADD
    KEY `p_tsubset_test_id` (`tset_tes_id`),
ADD
    KEY `tsubset_subject_id` (`tset_topik_id`);

--
-- Indexes for table `cbt_tes_user`
--
ALTER TABLE
    `cbt_tes_user`
ADD
    PRIMARY KEY (`tesuser_id`),
ADD
    UNIQUE KEY `ak_testuser` (
        `tesuser_tes_id`,
        `tesuser_user_id`,
        `tesuser_status`
    ),
ADD
    KEY `p_testuser_user_id` (`tesuser_user_id`),
ADD
    KEY `p_testuser_test_id` (`tesuser_tes_id`);

--
-- Indexes for table `cbt_topik`
--
ALTER TABLE
    `cbt_topik`
ADD
    PRIMARY KEY (`topik_id`),
ADD
    UNIQUE KEY `ak_subject_name` (`topik_modul_id`, `topik_nama`);

--
-- Indexes for table `cbt_user`
--
ALTER TABLE
    `cbt_user`
ADD
    PRIMARY KEY (`user_id`),
ADD
    UNIQUE KEY `ak_user_name` (`user_name`),
ADD
    KEY `user_groups_id` (`user_grup_id`),
ADD
    KEY `user_detail` (`user_detail`);

--
-- Indexes for table `cbt_user_grup`
--
ALTER TABLE
    `cbt_user_grup`
ADD
    PRIMARY KEY (`grup_id`),
ADD
    UNIQUE KEY `group_name` (`grup_nama`);

--
-- Indexes for table `user`
--
ALTER TABLE
    `user`
ADD
    PRIMARY KEY (`id`),
ADD
    UNIQUE KEY `username` (`username`),
ADD
    KEY `level` (`level`);

--
-- Indexes for table `user_akses`
--
ALTER TABLE
    `user_akses`
ADD
    PRIMARY KEY (`id`),
ADD
    KEY `akses_kode_menu` (`kode_menu`),
ADD
    KEY `akses_level` (`level`);

--
-- Indexes for table `user_level`
--
ALTER TABLE
    `user_level`
ADD
    PRIMARY KEY (`id`),
ADD
    UNIQUE KEY `level` (`level`);

--
-- Indexes for table `user_log`
--
ALTER TABLE
    `user_log`
ADD
    PRIMARY KEY (`id`);

--
-- Indexes for table `user_menu`
--
ALTER TABLE
    `user_menu`
ADD
    PRIMARY KEY (`id`),
ADD
    UNIQUE KEY `kode_menu` (`kode_menu`);

--
-- AUTO_INCREMENT for dumped tables
--
--
-- AUTO_INCREMENT for table `cbt_jawaban`
--
ALTER TABLE
    `cbt_jawaban`
MODIFY
    `jawaban_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 626;

--
-- AUTO_INCREMENT for table `cbt_konfigurasi`
--
ALTER TABLE
    `cbt_konfigurasi`
MODIFY
    `konfigurasi_id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT for table `cbt_modul`
--
ALTER TABLE
    `cbt_modul`
MODIFY
    `modul_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 10;

--
-- AUTO_INCREMENT for table `cbt_soal`
--
ALTER TABLE
    `cbt_soal`
MODIFY
    `soal_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 215;

--
-- AUTO_INCREMENT for table `cbt_tes`
--
ALTER TABLE
    `cbt_tes`
MODIFY
    `tes_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT for table `cbt_tes_soal`
--
ALTER TABLE
    `cbt_tes_soal`
MODIFY
    `tessoal_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 41;

--
-- AUTO_INCREMENT for table `cbt_tes_token`
--
ALTER TABLE
    `cbt_tes_token`
MODIFY
    `token_id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 13;

--
-- AUTO_INCREMENT for table `cbt_tes_topik_set`
--
ALTER TABLE
    `cbt_tes_topik_set`
MODIFY
    `tset_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT for table `cbt_tes_user`
--
ALTER TABLE
    `cbt_tes_user`
MODIFY
    `tesuser_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 5;

--
-- AUTO_INCREMENT for table `cbt_topik`
--
ALTER TABLE
    `cbt_topik`
MODIFY
    `topik_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 9;

--
-- AUTO_INCREMENT for table `cbt_user`
--
ALTER TABLE
    `cbt_user`
MODIFY
    `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 3;

--
-- AUTO_INCREMENT for table `cbt_user_grup`
--
ALTER TABLE
    `cbt_user_grup`
MODIFY
    `grup_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE
    `user`
MODIFY
    `id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT for table `user_akses`
--
ALTER TABLE
    `user_akses`
MODIFY
    `id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 505;

--
-- AUTO_INCREMENT for table `user_level`
--
ALTER TABLE
    `user_level`
MODIFY
    `id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 9;

--
-- AUTO_INCREMENT for table `user_log`
--
ALTER TABLE
    `user_log`
MODIFY
    `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_menu`
--
ALTER TABLE
    `user_menu`
MODIFY
    `id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 44;

--
-- Constraints for dumped tables
--
--
-- Constraints for table `cbt_jawaban`
--
ALTER TABLE
    `cbt_jawaban`
ADD
    CONSTRAINT `cbt_jawaban_ibfk_1` FOREIGN KEY (`jawaban_soal_id`) REFERENCES `cbt_soal` (`soal_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_soal`
--
ALTER TABLE
    `cbt_soal`
ADD
    CONSTRAINT `cbt_soal_ibfk_1` FOREIGN KEY (`soal_topik_id`) REFERENCES `cbt_topik` (`topik_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_tesgrup`
--
ALTER TABLE
    `cbt_tesgrup`
ADD
    CONSTRAINT `cbt_tesgrup_ibfk_1` FOREIGN KEY (`tstgrp_tes_id`) REFERENCES `cbt_tes` (`tes_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD
    CONSTRAINT `cbt_tesgrup_ibfk_2` FOREIGN KEY (`tstgrp_grup_id`) REFERENCES `cbt_user_grup` (`grup_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_tes_soal`
--
ALTER TABLE
    `cbt_tes_soal`
ADD
    CONSTRAINT `cbt_tes_soal_ibfk_1` FOREIGN KEY (`tessoal_tesuser_id`) REFERENCES `cbt_tes_user` (`tesuser_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD
    CONSTRAINT `cbt_tes_soal_ibfk_2` FOREIGN KEY (`tessoal_soal_id`) REFERENCES `cbt_soal` (`soal_id`) ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_tes_soal_jawaban`
--
ALTER TABLE
    `cbt_tes_soal_jawaban`
ADD
    CONSTRAINT `cbt_tes_soal_jawaban_ibfk_1` FOREIGN KEY (`soaljawaban_tessoal_id`) REFERENCES `cbt_tes_soal` (`tessoal_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD
    CONSTRAINT `cbt_tes_soal_jawaban_ibfk_2` FOREIGN KEY (`soaljawaban_jawaban_id`) REFERENCES `cbt_jawaban` (`jawaban_id`) ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_tes_token`
--
ALTER TABLE
    `cbt_tes_token`
ADD
    CONSTRAINT `cbt_tes_token_ibfk_1` FOREIGN KEY (`token_user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cbt_tes_topik_set`
--
ALTER TABLE
    `cbt_tes_topik_set`
ADD
    CONSTRAINT `cbt_tes_topik_set_ibfk_1` FOREIGN KEY (`tset_tes_id`) REFERENCES `cbt_tes` (`tes_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD
    CONSTRAINT `cbt_tes_topik_set_ibfk_2` FOREIGN KEY (`tset_topik_id`) REFERENCES `cbt_topik` (`topik_id`) ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_tes_user`
--
ALTER TABLE
    `cbt_tes_user`
ADD
    CONSTRAINT `cbt_tes_user_ibfk_1` FOREIGN KEY (`tesuser_tes_id`) REFERENCES `cbt_tes` (`tes_id`) ON DELETE CASCADE,
ADD
    CONSTRAINT `cbt_tes_user_ibfk_2` FOREIGN KEY (`tesuser_user_id`) REFERENCES `cbt_user` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_topik`
--
ALTER TABLE
    `cbt_topik`
ADD
    CONSTRAINT `cbt_topik_ibfk_1` FOREIGN KEY (`topik_modul_id`) REFERENCES `cbt_modul` (`modul_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cbt_user`
--
ALTER TABLE
    `cbt_user`
ADD
    CONSTRAINT `cbt_user_ibfk_1` FOREIGN KEY (`user_grup_id`) REFERENCES `cbt_user_grup` (`grup_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `user`
--
ALTER TABLE
    `user`
ADD
    CONSTRAINT `user_ibfk_1` FOREIGN KEY (`level`) REFERENCES `user_level` (`level`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_akses`
--
ALTER TABLE
    `user_akses`
ADD
    CONSTRAINT `user_akses_ibfk_2` FOREIGN KEY (`kode_menu`) REFERENCES `user_menu` (`kode_menu`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD
    CONSTRAINT `user_akses_ibfk_3` FOREIGN KEY (`level`) REFERENCES `user_level` (`level`) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;