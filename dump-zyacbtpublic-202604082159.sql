-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: zyacbtpublic
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+07:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `manusgicbt`
--
CREATE DATABASE IF NOT EXISTS `manusgicbt` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `manusgicbt`;

--
-- Table structure for table `cbt_jawaban`
--

DROP TABLE IF EXISTS `cbt_jawaban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_jawaban` (
  `jawaban_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `jawaban_soal_id` bigint unsigned NOT NULL,
  `jawaban_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `jawaban_benar` tinyint(1) NOT NULL DEFAULT '0',
  `jawaban_aktif` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`jawaban_id`),
  KEY `p_answer_question_id` (`jawaban_soal_id`),
  CONSTRAINT `cbt_jawaban_ibfk_1` FOREIGN KEY (`jawaban_soal_id`) REFERENCES `cbt_soal` (`soal_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=626 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_jawaban`
--

LOCK TABLES `cbt_jawaban` WRITE;
/*!40000 ALTER TABLE `cbt_jawaban` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_jawaban` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_konfigurasi`
--

DROP TABLE IF EXISTS `cbt_konfigurasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_konfigurasi` (
  `konfigurasi_id` int NOT NULL AUTO_INCREMENT,
  `konfigurasi_kode` varchar(50) NOT NULL,
  `konfigurasi_isi` varchar(500) NOT NULL,
  `konfigurasi_keterangan` varchar(100) NOT NULL,
  PRIMARY KEY (`konfigurasi_id`),
  UNIQUE KEY `konfigurasi_kode` (`konfigurasi_kode`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_konfigurasi`
--

LOCK TABLES `cbt_konfigurasi` WRITE;
/*!40000 ALTER TABLE `cbt_konfigurasi` DISABLE KEYS */;
INSERT INTO `cbt_konfigurasi` VALUES (1,'link_login_operator','ya','Menampilkan Link Login Operator'),(2,'cbt_nama','Computer Based-Test','Nama Penyelenggara ZYACBT'),(3,'cbt_keterangan','Ujian Online','Keterangan Penyelenggara ZYACBT'),(4,'cbt_mobile_lock_xambro','tidak','Melakukan Lock pada browser mobile agar menggunakan Xambro Saja'),(5,'cbt_informasi','<p>Untuk kenyamanan dan kelancaran ujian, mohon tetap berada di halaman ini hingga selesai. Menutup tab atau membuka aplikasi lain akan memicu sistem keamanan yang dapat membatalkan ujian Anda secara otomatis. Selamat mengerjakan dan semoga sukses!</p>\r\n','Informasi yang diberika di Dashboard peserta tes\''),(6,'proteksi_multilogin','ya','Proteksi MultiLogin Peserta Tes');
/*!40000 ALTER TABLE `cbt_konfigurasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_modul`
--

DROP TABLE IF EXISTS `cbt_modul`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_modul` (
  `modul_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `modul_nama` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `modul_aktif` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`modul_id`),
  UNIQUE KEY `ak_module_name` (`modul_nama`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_modul`
--

LOCK TABLES `cbt_modul` WRITE;
/*!40000 ALTER TABLE `cbt_modul` DISABLE KEYS */;
INSERT INTO `cbt_modul` VALUES (9,'Default',1);
/*!40000 ALTER TABLE `cbt_modul` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_sessions`
--

DROP TABLE IF EXISTS `cbt_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_sessions` (
  `id` varchar(128) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_sessions`
--

LOCK TABLES `cbt_sessions` WRITE;
/*!40000 ALTER TABLE `cbt_sessions` DISABLE KEYS */;
INSERT INTO `cbt_sessions` VALUES ('10nvm3eseaeeknhssrdnf7lqk79or2go','127.0.0.1',1775657924,_binary '__ci_last_regenerate|i:1775657900;cbt_tes_tanda|s:22:\"@ZYACBT@master@ZYACBT@\";cbt_tes_user_id|s:6:\"master\";cbt_tes_nama|s:6:\"Master\";cbt_tes_group|s:6:\"TESTER\";cbt_tes_group_id|s:1:\"6\";cbt_tes_token|s:6:\"F67D26\";','2026-04-08 14:18:20'),('20tfjl2fej996ch33v083vs2j808bq4j','127.0.0.1',1775658274,_binary '__ci_last_regenerate|i:1775658274;cbt_user_id|s:5:\"admin\";cbt_nama|s:12:\"Achmad Lutfi\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:13:58'),('20u8dinht0pthjiv66frocdh89f4brvs','127.0.0.1',1775657317,_binary '__ci_last_regenerate|i:1775657317;cbt_user_id|s:5:\"admin\";cbt_nama|s:12:\"Achmad Lutfi\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:02:27'),('2g4n4h6av72ntegm0aiq8sc2japs284s','127.0.0.1',1775659271,_binary '__ci_last_regenerate|i:1775658994;cbt_user_id|s:5:\"admin\";cbt_nama|s:13:\"Administrator\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:36:34'),('4ruqc0k0b68tjnvvii78808gg8bnqc1n','127.0.0.1',1775658994,_binary '__ci_last_regenerate|i:1775658994;cbt_user_id|s:5:\"admin\";cbt_nama|s:12:\"Achmad Lutfi\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:29:36'),('begae4g4i6i39er8c6a89m2848qkvoij','127.0.0.1',1775658576,_binary '__ci_last_regenerate|i:1775658576;cbt_user_id|s:5:\"admin\";cbt_nama|s:12:\"Achmad Lutfi\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:24:34'),('dgsqdbst8etckd3n4uvh50fskp5nbidr','127.0.0.1',1775660234,_binary '__ci_last_regenerate|i:1775660158;cbt_user_id|s:5:\"admin\";cbt_nama|s:13:\"Administrator\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:55:58'),('j9d5vpj8eagvgt9q3emo697lfafs4m2p','127.0.0.1',1775660158,_binary '__ci_last_regenerate|i:1775660158;','2026-04-08 14:42:37'),('jnok4cs9grrmf93ck1qss0b7p49m9s9s','127.0.0.1',1775657638,_binary '__ci_last_regenerate|i:1775657638;cbt_user_id|s:5:\"admin\";cbt_nama|s:12:\"Achmad Lutfi\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2026-04-08 14:08:37'),('o9kbc4m5fbd7it517l96t6r2hcie5j7t','::1',1714970576,_binary '__ci_last_regenerate|i:1714970458;cbt_tes_tanda|s:21:\"@ZYACBT@lutfi@ZYACBT@\";cbt_tes_user_id|s:5:\"lutfi\";cbt_tes_nama|s:22:\"Muhammad Lutfial Hakim\";cbt_tes_group|s:5:\"XI MM\";cbt_tes_group_id|s:1:\"5\";','2024-05-06 04:40:58'),('rof3gp9ehhoe5tie140dh8vue34dfpf9','127.0.0.1',1714970643,_binary '__ci_last_regenerate|i:1714970419;cbt_user_id|s:5:\"admin\";cbt_nama|s:12:\"Achmad Lutfi\";cbt_level|s:5:\"admin\";cbt_opsi1|s:0:\"\";cbt_opsi2|s:0:\"\";','2024-05-06 04:40:19');
/*!40000 ALTER TABLE `cbt_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_soal`
--

DROP TABLE IF EXISTS `cbt_soal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_soal` (
  `soal_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `soal_topik_id` bigint unsigned NOT NULL,
  `soal_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `soal_tipe` smallint unsigned NOT NULL DEFAULT '1' COMMENT '1=Pilihan ganda, 2=essay, 3=jawaban singkat',
  `soal_kunci` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci COMMENT 'Kunci untuk soal jawaban singkat',
  `soal_difficulty` smallint NOT NULL DEFAULT '1',
  `soal_aktif` tinyint(1) NOT NULL DEFAULT '0',
  `soal_audio` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `soal_audio_play` int NOT NULL DEFAULT '0',
  `soal_timer` smallint DEFAULT NULL,
  `soal_inline_answers` tinyint(1) NOT NULL DEFAULT '0',
  `soal_auto_next` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`soal_id`),
  KEY `p_question_subject_id` (`soal_topik_id`),
  CONSTRAINT `cbt_soal_ibfk_1` FOREIGN KEY (`soal_topik_id`) REFERENCES `cbt_topik` (`topik_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_soal`
--

LOCK TABLES `cbt_soal` WRITE;
/*!40000 ALTER TABLE `cbt_soal` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_soal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tes`
--

DROP TABLE IF EXISTS `cbt_tes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tes` (
  `tes_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tes_nama` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tes_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tes_begin_time` datetime DEFAULT NULL,
  `tes_end_time` datetime DEFAULT NULL,
  `tes_duration_time` smallint unsigned NOT NULL DEFAULT '0',
  `tes_ip_range` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '*.*.*.*',
  `tes_results_to_users` tinyint(1) NOT NULL DEFAULT '0',
  `tes_detail_to_users` tinyint(1) NOT NULL DEFAULT '0',
  `tes_score_right` decimal(10,2) DEFAULT '1.00',
  `tes_score_wrong` decimal(10,2) DEFAULT '0.00',
  `tes_score_unanswered` decimal(10,2) DEFAULT '0.00',
  `tes_max_score` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tes_token` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`tes_id`),
  UNIQUE KEY `ak_test_name` (`tes_nama`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tes`
--

LOCK TABLES `cbt_tes` WRITE;
/*!40000 ALTER TABLE `cbt_tes` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_tes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tes_soal`
--

DROP TABLE IF EXISTS `cbt_tes_soal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tes_soal` (
  `tessoal_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tessoal_tesuser_id` bigint unsigned NOT NULL,
  `tessoal_user_ip` varchar(39) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tessoal_soal_id` bigint unsigned NOT NULL,
  `tessoal_jawaban_text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `tessoal_nilai` decimal(10,2) DEFAULT NULL,
  `tessoal_creation_time` datetime DEFAULT NULL,
  `tessoal_display_time` datetime DEFAULT NULL,
  `tessoal_change_time` datetime DEFAULT NULL,
  `tessoal_reaction_time` bigint unsigned NOT NULL DEFAULT '0',
  `tessoal_ragu` int NOT NULL DEFAULT '0' COMMENT '1=ragu, 0=tidak ragu',
  `tessoal_order` smallint NOT NULL DEFAULT '1',
  `tessoal_num_answers` smallint unsigned NOT NULL DEFAULT '0',
  `tessoal_comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `tessoal_audio_play` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`tessoal_id`),
  UNIQUE KEY `ak_testuser_question` (`tessoal_tesuser_id`,`tessoal_soal_id`),
  KEY `p_testlog_question_id` (`tessoal_soal_id`),
  KEY `p_testlog_testuser_id` (`tessoal_tesuser_id`),
  CONSTRAINT `cbt_tes_soal_ibfk_1` FOREIGN KEY (`tessoal_tesuser_id`) REFERENCES `cbt_tes_user` (`tesuser_id`) ON DELETE CASCADE,
  CONSTRAINT `cbt_tes_soal_ibfk_2` FOREIGN KEY (`tessoal_soal_id`) REFERENCES `cbt_soal` (`soal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tes_soal`
--

LOCK TABLES `cbt_tes_soal` WRITE;
/*!40000 ALTER TABLE `cbt_tes_soal` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_tes_soal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tes_soal_jawaban`
--

DROP TABLE IF EXISTS `cbt_tes_soal_jawaban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tes_soal_jawaban` (
  `soaljawaban_tessoal_id` bigint unsigned NOT NULL,
  `soaljawaban_jawaban_id` bigint unsigned NOT NULL,
  `soaljawaban_selected` smallint NOT NULL DEFAULT '-1',
  `soaljawaban_order` smallint NOT NULL DEFAULT '1',
  `soaljawaban_position` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`soaljawaban_tessoal_id`,`soaljawaban_jawaban_id`),
  KEY `p_logansw_answer_id` (`soaljawaban_jawaban_id`),
  KEY `p_logansw_testlog_id` (`soaljawaban_tessoal_id`),
  CONSTRAINT `cbt_tes_soal_jawaban_ibfk_1` FOREIGN KEY (`soaljawaban_tessoal_id`) REFERENCES `cbt_tes_soal` (`tessoal_id`) ON DELETE CASCADE,
  CONSTRAINT `cbt_tes_soal_jawaban_ibfk_2` FOREIGN KEY (`soaljawaban_jawaban_id`) REFERENCES `cbt_jawaban` (`jawaban_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tes_soal_jawaban`
--

LOCK TABLES `cbt_tes_soal_jawaban` WRITE;
/*!40000 ALTER TABLE `cbt_tes_soal_jawaban` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_tes_soal_jawaban` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tes_token`
--

DROP TABLE IF EXISTS `cbt_tes_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tes_token` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `token_isi` varchar(20) NOT NULL,
  `token_user_id` int NOT NULL,
  `token_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `token_aktif` int NOT NULL DEFAULT '1' COMMENT 'Umur Token dalam menit, 1 = 1 hari penuh',
  `token_tes_id` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`token_id`),
  KEY `token_user_id` (`token_user_id`),
  CONSTRAINT `cbt_tes_token_ibfk_1` FOREIGN KEY (`token_user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tes_token`
--

LOCK TABLES `cbt_tes_token` WRITE;
/*!40000 ALTER TABLE `cbt_tes_token` DISABLE KEYS */;
INSERT INTO `cbt_tes_token` VALUES (13,'F67D26',1,'2026-04-08 07:18:39',1,6);
/*!40000 ALTER TABLE `cbt_tes_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tes_topik_set`
--

DROP TABLE IF EXISTS `cbt_tes_topik_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tes_topik_set` (
  `tset_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tset_tes_id` bigint unsigned NOT NULL,
  `tset_topik_id` bigint unsigned NOT NULL,
  `tset_tipe` smallint NOT NULL DEFAULT '1',
  `tset_difficulty` smallint NOT NULL DEFAULT '1',
  `tset_jumlah` smallint NOT NULL DEFAULT '1',
  `tset_jawaban` smallint NOT NULL DEFAULT '0',
  `tset_acak_jawaban` int NOT NULL DEFAULT '1',
  `tset_acak_soal` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`tset_id`),
  KEY `p_tsubset_test_id` (`tset_tes_id`),
  KEY `tsubset_subject_id` (`tset_topik_id`),
  CONSTRAINT `cbt_tes_topik_set_ibfk_1` FOREIGN KEY (`tset_tes_id`) REFERENCES `cbt_tes` (`tes_id`) ON DELETE CASCADE,
  CONSTRAINT `cbt_tes_topik_set_ibfk_2` FOREIGN KEY (`tset_topik_id`) REFERENCES `cbt_topik` (`topik_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tes_topik_set`
--

LOCK TABLES `cbt_tes_topik_set` WRITE;
/*!40000 ALTER TABLE `cbt_tes_topik_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_tes_topik_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tes_user`
--

DROP TABLE IF EXISTS `cbt_tes_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tes_user` (
  `tesuser_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tesuser_tes_id` bigint unsigned NOT NULL,
  `tesuser_user_id` bigint unsigned NOT NULL,
  `tesuser_status` smallint unsigned NOT NULL DEFAULT '0',
  `tesuser_creation_time` datetime NOT NULL,
  `tesuser_comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `tesuser_token` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`tesuser_id`),
  UNIQUE KEY `ak_testuser` (`tesuser_tes_id`,`tesuser_user_id`,`tesuser_status`),
  KEY `p_testuser_user_id` (`tesuser_user_id`),
  KEY `p_testuser_test_id` (`tesuser_tes_id`),
  CONSTRAINT `cbt_tes_user_ibfk_1` FOREIGN KEY (`tesuser_tes_id`) REFERENCES `cbt_tes` (`tes_id`) ON DELETE CASCADE,
  CONSTRAINT `cbt_tes_user_ibfk_2` FOREIGN KEY (`tesuser_user_id`) REFERENCES `cbt_user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tes_user`
--

LOCK TABLES `cbt_tes_user` WRITE;
/*!40000 ALTER TABLE `cbt_tes_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_tes_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_tesgrup`
--

DROP TABLE IF EXISTS `cbt_tesgrup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_tesgrup` (
  `tstgrp_tes_id` bigint unsigned NOT NULL,
  `tstgrp_grup_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tstgrp_tes_id`,`tstgrp_grup_id`),
  KEY `p_tstgrp_test_id` (`tstgrp_tes_id`),
  KEY `p_tstgrp_group_id` (`tstgrp_grup_id`),
  CONSTRAINT `cbt_tesgrup_ibfk_1` FOREIGN KEY (`tstgrp_tes_id`) REFERENCES `cbt_tes` (`tes_id`) ON DELETE CASCADE,
  CONSTRAINT `cbt_tesgrup_ibfk_2` FOREIGN KEY (`tstgrp_grup_id`) REFERENCES `cbt_user_grup` (`grup_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_tesgrup`
--

LOCK TABLES `cbt_tesgrup` WRITE;
/*!40000 ALTER TABLE `cbt_tesgrup` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_tesgrup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_topik`
--

DROP TABLE IF EXISTS `cbt_topik`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_topik` (
  `topik_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `topik_modul_id` bigint unsigned NOT NULL DEFAULT '1',
  `topik_nama` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `topik_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `topik_aktif` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`topik_id`),
  UNIQUE KEY `ak_subject_name` (`topik_modul_id`,`topik_nama`),
  CONSTRAINT `cbt_topik_ibfk_1` FOREIGN KEY (`topik_modul_id`) REFERENCES `cbt_modul` (`modul_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_topik`
--

LOCK TABLES `cbt_topik` WRITE;
/*!40000 ALTER TABLE `cbt_topik` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_topik` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_user`
--

DROP TABLE IF EXISTS `cbt_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_user` (
  `user_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_login` int NOT NULL DEFAULT '0' COMMENT ' 	0=Tidak Login, 1=Login ',
  `user_login_date` date DEFAULT NULL,
  `user_grup_id` bigint unsigned NOT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_ip` varchar(39) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_firstname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_birthdate` date DEFAULT NULL,
  `user_birthplace` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_level` smallint unsigned NOT NULL DEFAULT '1',
  `user_detail` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `ak_user_name` (`user_name`),
  KEY `user_groups_id` (`user_grup_id`),
  KEY `user_detail` (`user_detail`),
  CONSTRAINT `cbt_user_ibfk_1` FOREIGN KEY (`user_grup_id`) REFERENCES `cbt_user_grup` (`grup_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_user`
--

LOCK TABLES `cbt_user` WRITE;
/*!40000 ALTER TABLE `cbt_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbt_user_grup`
--

DROP TABLE IF EXISTS `cbt_user_grup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cbt_user_grup` (
  `grup_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `grup_nama` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`grup_id`),
  UNIQUE KEY `group_name` (`grup_nama`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbt_user_grup`
--

LOCK TABLES `cbt_user_grup` WRITE;
/*!40000 ALTER TABLE `cbt_user_grup` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbt_user_grup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peserta_ujian_status`
--

DROP TABLE IF EXISTS `peserta_ujian_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peserta_ujian_status` (
  `id_status` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `id_mapel` int DEFAULT NULL,
  `jumlah_pelanggaran` int DEFAULT '0',
  `status_ujian` enum('aktif','selesai','diblokir') DEFAULT 'aktif',
  `terakhir_aktif` datetime DEFAULT NULL,
  `log_detail` text,
  PRIMARY KEY (`id_status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peserta_ujian_status`
--

LOCK TABLES `peserta_ujian_status` WRITE;
/*!40000 ALTER TABLE `peserta_ujian_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `peserta_ujian_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama` varchar(150) NOT NULL,
  `opsi1` varchar(75) NOT NULL,
  `opsi2` varchar(75) NOT NULL,
  `keterangan` varchar(150) NOT NULL,
  `level` varchar(50) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `level` (`level`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`level`) REFERENCES `user_level` (`level`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','d033e22ae348aeb5660fc2140aec35850c4da997','Administrator','','','','admin','2015-07-29 18:12:03');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_akses`
--

DROP TABLE IF EXISTS `user_akses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_akses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level` varchar(75) NOT NULL,
  `kode_menu` varchar(50) NOT NULL,
  `add` int NOT NULL DEFAULT '1' COMMENT '0=false, 1=true',
  `edit` int NOT NULL DEFAULT '1' COMMENT '0=false, 1=true',
  PRIMARY KEY (`id`),
  KEY `akses_kode_menu` (`kode_menu`),
  KEY `akses_level` (`level`),
  CONSTRAINT `user_akses_ibfk_2` FOREIGN KEY (`kode_menu`) REFERENCES `user_menu` (`kode_menu`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_akses_ibfk_3` FOREIGN KEY (`level`) REFERENCES `user_level` (`level`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=529 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_akses`
--

LOCK TABLES `user_akses` WRITE;
/*!40000 ALTER TABLE `user_akses` DISABLE KEYS */;
INSERT INTO `user_akses` VALUES (254,'operator-soal','modul-daftar',1,1),(255,'operator-soal','modul-filemanager',1,1),(256,'operator-soal','modul-import',1,1),(257,'operator-soal','modul-soal',1,1),(258,'operator-soal','modul-topik',1,1),(259,'operator-tes','tes-hasil-operator',1,1),(260,'operator-tes','tes-token',1,1),(505,'admin','laporan-analisis-butir-soal',1,1),(506,'admin','peserta-kartu',1,1),(507,'admin','peserta-group',1,1),(508,'admin','peserta-daftar',1,1),(509,'admin','modul-daftar',1,1),(510,'admin','tes-daftar',1,1),(511,'admin','tool-backup',1,1),(512,'admin','tes-evaluasi',1,1),(513,'admin','tool-exportimport-soal',1,1),(514,'admin','modul-filemanager',1,1),(515,'admin','tes-hasil',1,1),(516,'admin','peserta-import',1,1),(517,'admin','modul-import',1,1),(518,'admin','modul-import-word',1,1),(519,'admin','user_level',1,1),(520,'admin','user_menu',1,1),(521,'admin','user_atur',1,1),(522,'admin','user-zyacbt',1,1),(523,'admin','laporan-rekap',1,1),(524,'admin','peserta-reset',1,1),(525,'admin','modul-soal',1,1),(526,'admin','tes-tambah',1,1),(527,'admin','tes-token',1,1),(528,'admin','modul-topik',1,1);
/*!40000 ALTER TABLE `user_akses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_level`
--

DROP TABLE IF EXISTS `user_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level` varchar(50) NOT NULL,
  `keterangan` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `level` (`level`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_level`
--

LOCK TABLES `user_level` WRITE;
/*!40000 ALTER TABLE `user_level` DISABLE KEYS */;
INSERT INTO `user_level` VALUES (1,'admin','Administrator'),(7,'operator-soal','Operator Soal'),(8,'operator-tes','Operator Tes');
/*!40000 ALTER TABLE `user_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_log`
--

DROP TABLE IF EXISTS `user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `log` varchar(250) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_log`
--

LOCK TABLES `user_log` WRITE;
/*!40000 ALTER TABLE `user_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_menu`
--

DROP TABLE IF EXISTS `user_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipe` int NOT NULL DEFAULT '1' COMMENT '0=parent, 1=child',
  `parent` varchar(50) DEFAULT NULL,
  `kode_menu` varchar(50) NOT NULL,
  `nama_menu` varchar(100) NOT NULL,
  `url` varchar(150) NOT NULL DEFAULT '#',
  `icon` varchar(75) NOT NULL DEFAULT 'fa fa-circle-o',
  `urutan` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kode_menu` (`kode_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_menu`
--

LOCK TABLES `user_menu` WRITE;
/*!40000 ALTER TABLE `user_menu` DISABLE KEYS */;
INSERT INTO `user_menu` VALUES (1,0,'','user','Pengaturan','#','fa fa-user',20),(3,1,'user','user_atur','Pengaturan User','manager/useratur','fa fa-circle-o',5),(4,1,'user','user_level','Pengaturan Level','manager/userlevel','fa fa-circle-o',6),(5,1,'user','user_menu','Pengaturan Menu','manager/usermenu','fa fa-circle-o',7),(6,0,'','modul','Data Modul','#','fa fa-book',2),(7,1,'modul','modul-daftar','Daftar Soal','manager/modul_daftar','fa fa-circle-o',5),(8,1,'modul','modul-topik','Topik','manager/modul_topik','fa fa-circle-o',2),(10,0,'','peserta','Data Peserta','#','fa fa-users',3),(11,1,'peserta','peserta-daftar','Daftar Peserta','manager/peserta_daftar','fa fa-circle-o',2),(12,1,'peserta','peserta-group','Daftar Group','manager/peserta_group','fa fa-circle-o',1),(13,1,'peserta','peserta-import','Import Data Peserta','manager/peserta_import','fa fa-circle-o',3),(14,0,'','tes','Data Tes','#','fa fa-tasks',4),(15,1,'tes','tes-tambah','Tambah Tes','manager/tes_tambah','fa fa-circle-o',1),(16,1,'tes','tes-daftar','Daftar Tes','manager/tes_daftar','fa fa-circle-o',2),(17,1,'tes','tes-hasil','Hasil Tes','manager/tes_hasil','fa fa-circle-o',6),(18,1,'modul','modul-soal','Soal','manager/modul_soal','fa fa-circle-o',3),(19,1,'tes','tes-token','Token','manager/tes_token','fa fa-circle-o',8),(22,1,'modul','modul-filemanager','File Manager','manager/modul_filemanager','fa fa-circle-o',6),(24,1,'modul','modul-import','Import Soal Spreadsheet','manager/modul_import','fa fa-circle-o',4),(25,1,'tes','tes-evaluasi','Evaluasi Tes','manager/tes_evaluasi','fa fa-circle-o',5),(28,1,'tes','tes-hasil-operator','Hasil Tes Operator','manager/tes_hasil_operator','fa fa-circle-o',10),(30,0,'','tool','Tool','#','fa fa-wrench',6),(31,1,'tool','tool-backup','Database','manager/tool_backup','fa fa-database',1),(32,1,'tes-laporan','laporan-rekap','Rekap Hasil Tes','manager/laporan_rekap_hasil','fa fa-circle-o',7),(33,1,'tool','tool-exportimport-soal','Export / Import Soal','manager/tool_exportimport_soal','fa fa-circle-o',2),(34,1,'user','user-zyacbt','Pengaturan Aplikasi','manager/pengaturan_zyacbt','fa fa-circle-o',1),(37,1,'peserta','peserta-kartu','Cetak Kartu','manager/peserta_kartu','fa fa-circle-o',5),(38,0,'','tes-laporan','Laporan','#','fa fa-print',5),(41,1,'tes-laporan','laporan-analisis-butir-soal','Analisis Butir Soal','manager/laporan_analisis_butir_soal','fa fa-circle-o',1),(42,1,'tes-laporan','laporan-analisis-soal','Analisis Soal','manager/laporan_analisis_soal','fa fa-circle-o',2),(43,1,'modul','modul-import-word','Import Soal Word','manager/modul_import_word','fa fa-circle-o',4),(44,1,'peserta','peserta-reset','Reset Login','manager/peserta_reset','fa fa-circle-o',7);
/*!40000 ALTER TABLE `user_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'zyacbtpublic'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08 21:59:23
