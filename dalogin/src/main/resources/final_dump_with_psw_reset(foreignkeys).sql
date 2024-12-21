-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: login
-- ------------------------------------------------------
-- Server version	5.7.12-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Last_seen`
--

DROP TABLE IF EXISTS `Last_seen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Last_seen`
(
    `id`         int(20) NOT NULL AUTO_INCREMENT,
    `deviceId`   char(255) COLLATE utf8_bin NOT NULL DEFAULT '0000',
    `Session_`   mediumtext COLLATE utf8_bin,
    `TIME_`      timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `devices_id` int(20) DEFAULT NULL,
    PRIMARY KEY (`id`, `deviceId`),
    KEY          `deviceId` (`deviceId`),
    KEY          `fk_devices_idx` (`devices_id`),
    CONSTRAINT `fk_devices2` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Last_seen`
--

LOCK
TABLES `Last_seen` WRITE;
/*!40000 ALTER TABLE `Last_seen` DISABLE KEYS */;
INSERT INTO `Last_seen`
VALUES (1, '7501012353736560292487537365900144024', '1489971801555', '2017-03-20 01:03:21', 1);
/*!40000 ALTER TABLE `Last_seen` ENABLE KEYS */;
UNLOCK
TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tokens 
AFTER INSERT ON Last_seen 
FOR EACH ROW

BEGIN
       DECLARE deviceId_ char(255);
       declare id_ char(255);
	   select id, deviceId into id_, deviceId_ from Last_seen where last_insert_id() = last_insert_id() ORDER by ID DESC LIMIT 1;
  
  INSERT INTO Tokens (deviceId, devices_id) values (deviceId_, id_);

  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `login`.`Last_seen_AFTER_UPDATE` AFTER UPDATE ON `Last_seen` FOR EACH ROW
BEGIN

       DECLARE deviceId_ char(255);
	   select deviceId into deviceId_ from Last_seen where last_insert_id() = last_insert_id() ORDER by Session_ DESC LIMIT 1;
  
  UPDATE Tokens 
  SET Tokens.deviceId = deviceId_ where Tokens.deviceId = deviceId_;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Tokens`
--

DROP TABLE IF EXISTS `Tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tokens`
(
    `id`         int(20) NOT NULL AUTO_INCREMENT,
    `deviceId`   char(255) COLLATE utf8_bin DEFAULT NULL,
    `token1`     char(255) COLLATE utf8_bin DEFAULT NULL,
    `token2`     char(255) COLLATE utf8_bin DEFAULT NULL,
    `TIME_`      timestamp NOT NULL         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `devices_id` int(20) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `token1` (`token1`),
    UNIQUE KEY `token2` (`token2`),
    KEY          `token2_2` (`token2`),
    KEY          `fk_devices3_idx` (`devices_id`),
    CONSTRAINT `fk_devices3` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tokens`
--

LOCK
TABLES `Tokens` WRITE;
/*!40000 ALTER TABLE `Tokens` DISABLE KEYS */;
INSERT INTO `Tokens`
VALUES (1, '7501012353736560292487537365900144024', '63157170-0d50-11e7-bfa5-08d61afda954', '0.28146259699153026',
        '2017-03-20 09:34:16', 1);
/*!40000 ALTER TABLE `Tokens` ENABLE KEYS */;
UNLOCK
TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `login`.`Tokens_BEFORE_INSERT` BEFORE INSERT ON `Tokens` FOR EACH ROW
BEGIN
    SET NEW.token1 = UUID();
	SET NEW.token2 = RAND();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `login`.`Tokens_BEFORE_UPDATE` BEFORE UPDATE ON `Tokens` FOR EACH ROW
BEGIN
    SET NEW.token1 = UUID();
    SET NEW.token2 = RAND();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `device_states`
--

DROP TABLE IF EXISTS `device_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_states`
(
    `id`         int(10) unsigned NOT NULL AUTO_INCREMENT,
    `deviceId`   char(255) CHARACTER SET utf8 DEFAULT NULL,
    `state`      enum('logged_in','playing','logged_out','deleted') COLLATE utf8_bin DEFAULT NULL,
    `SessionID`  char(255) COLLATE utf8_bin   DEFAULT NULL,
    `TIME_`      timestamp NOT NULL           DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `uuid`       char(255) COLLATE utf8_bin   DEFAULT NULL,
    `devices_id` int(20) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY          `state` (`state`),
    KEY          `deviceId` (`deviceId`),
    KEY          `time` (`TIME_`),
    KEY          `sessionID` (`SessionID`),
    KEY          `fk_devices_idx` (`devices_id`),
    CONSTRAINT `fk_devices` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_states`
--

LOCK
TABLES `device_states` WRITE;
/*!40000 ALTER TABLE `device_states` DISABLE KEYS */;
INSERT INTO `device_states`
VALUES (1, '7501012353736560292487537365900144024', 'logged_out', '9032f02af73197aac9b1c639d30a', '2017-03-16 21:26:04',
        '9f394dd6-6de0-11e5-8441-71caa0c5f788', 1),
       (2, '7501012353736560292487537365900144024', 'logged_in', '-AM6ZD6MPAcoze74xiG9XvXQk57ZKn_sYQ1gzxfM',
        '2017-03-14 13:15:57', '65f63602-6ddf-11e5-8441-71caa0c5f788', 2),
       (3, '7501012353736560292487537365900144024', 'logged_out', '9036a0e11cb5eced4a0d1591894c', '2017-03-16 21:27:49',
        'a08d4212-3d4e-11e6-b703-b68b964fca08', 3),
       (4, '7501012353736560292487537365900144024', 'logged_out', 'Qblue5ORs8pYtIlLlRaKAJyGzzODEQXmYAIrZpA4',
        '2017-03-20 09:34:16', 'ab36ff88-6de1-11e5-8441-71caa0c5f788', 4);
/*!40000 ALTER TABLE `device_states` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices`
(
    `id`       int(20) NOT NULL AUTO_INCREMENT,
    `deviceId` char(255) COLLATE utf8_bin DEFAULT NULL,
    `uuid`     char(255) COLLATE utf8_bin DEFAULT NULL,
    `TIME_`    timestamp NOT NULL         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY        `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK
TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices`
VALUES (1, '7501012353736560292487537365900144024', '9f394dd6-6de0-11e5-8441-71caa0c5f788', '2017-03-14 12:53:12'),
       (2, '7501012353736560292487537365900144024', '65f63602-6ddf-11e5-8441-71caa0c5f788', '2017-03-14 13:15:57'),
       (3, '7501012353736560292487537365900144024', 'a08d4212-3d4e-11e6-b703-b68b964fca08', '2017-03-16 21:26:04'),
       (4, '7501012353736560292487537365900144024', 'ab36ff88-6de1-11e5-8441-71caa0c5f788', '2017-03-20 01:03:21');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK
TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sqluser`@`localhost`*/ /*!50003 TRIGGER deviceId_uuid 
AFTER INSERT ON devices 
FOR EACH ROW

BEGIN
	   DECLARE Id_ char(255);
       DECLARE deviceId_ char(255);
       DECLARE uuid_ char(255);
	   select id, deviceId, uuid into Id_, deviceId_, uuid_ from devices where last_insert_id() = last_insert_id() ORDER by ID DESC LIMIT 1;

  INSERT INTO device_states (deviceId, state, uuid, devices_id) values (deviceId_, 'logged_in', uuid_, Id_);
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `forgotPsw`
--

DROP TABLE IF EXISTS `forgotPsw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forgotPsw`
(
    `id`                 int(11) NOT NULL AUTO_INCREMENT,
    `forgotUserEmail`    char(255) NOT NULL,
    `forgotRequestToken` char(255) DEFAULT NULL,
    `forgotRequestTime`  char(255) DEFAULT NULL,
    `isValid`            tinyint(1) DEFAULT NULL,
    `TIME_`              timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `forgotUserEmail_UNIQUE` (`forgotUserEmail`),
    UNIQUE KEY `forgotRequestToken_UNIQUE` (`forgotRequestToken`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forgotPsw`
--

LOCK
TABLES `forgotPsw` WRITE;
/*!40000 ALTER TABLE `forgotPsw` DISABLE KEYS */;
INSERT INTO `forgotPsw`
VALUES (1, 'ga@ga.com', '0.6539524473752384', '1489964739351', 1, '2017-03-21 11:19:00'),
       (2, 'gi@gi.com', '0.09058727611842311', '1490103024413', 0, '2017-03-21 13:30:42');
/*!40000 ALTER TABLE `forgotPsw` ENABLE KEYS */;
UNLOCK
TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `login`.`forgotPsw_BEFORE_INSERT` 
BEFORE INSERT ON `forgotPsw` FOR EACH ROW

BEGIN
	SET NEW.forgotRequestToken = RAND();
    SET NEW.isValid = 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `login`.`forgotPsw_BEFORE_UPDATE` BEFORE UPDATE ON `forgotPsw` FOR EACH ROW

BEGIN
	SET NEW.forgotRequestToken = RAND();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `logins`
--

DROP TABLE IF EXISTS `logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logins`
(
    `id`    int(20) NOT NULL AUTO_INCREMENT,
    `hash_` char(255) COLLATE utf8_bin NOT NULL,
    `user`  varchar(255) COLLATE utf8_bin DEFAULT NULL,
    `uuid`  char(255) COLLATE utf8_bin    DEFAULT NULL,
    `email` char(255) COLLATE utf8_bin    DEFAULT NULL,
    `TIME_` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `email_UNIQUE` (`email`),
    UNIQUE KEY `uuid` (`uuid`),
    UNIQUE KEY `user_UNIQUE` (`user`),
    KEY     `user` (`user`),
    KEY     `hash_` (`hash_`),
    FULLTEXT KEY `user_2` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logins`
--

LOCK
TABLES `logins` WRITE;
/*!40000 ALTER TABLE `logins` DISABLE KEYS */;
INSERT INTO `logins`
VALUES (1,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'GG', '65f63602-6ddf-11e5-8441-71caa0c5f788', 'igeorge0902@yahoo.com', '2017-03-05 15:23:21'),
       (2,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'GA', '9f394dd6-6de0-11e5-8441-71caa0c5f788', 'ga@ga.com', '2017-03-05 15:23:21'),
       (3,
        'a444e9773a37543a1a380f0076e766cc6bf38953c74c09929dcab75c43ef3082a37568974728d0ccd0d2870cc2110da4e72183bf116a2ccb4262906cb003f6c0',
        'GI', 'ab36ff88-6de1-11e5-8441-71caa0c5f788', 'gi@gi.com', '2017-03-21 13:30:42'),
       (4,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'Lilla', '37bd295e-6de3-11e5-8441-71caa0c5f788', 'lilla@lilla.hu', '2017-03-05 15:23:21'),
       (5,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'Milo', '81e84d10-6de3-11e5-8441-71caa0c5f788', 'milo@milo.hu', '2017-03-05 15:23:21'),
       (13,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'KI', 'ce118410-b7bf-11e5-ab38-d9d1883983e4', 'ki@ki.hu', '2017-03-05 15:23:21'),
       (14,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'KK', '0cc4b1a4-b7c1-11e5-ab38-d9d1883983e4', 'kk@kk.hu', '2017-03-05 15:23:21'),
       (37,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'George', 'eefcfe1a-0284-11e6-b3c9-cce30c92baea', 'igeorge1982@hotmail.com', '2017-03-05 15:23:21'),
       (60,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'AA', 'd4969b4e-04b4-11e6-8ded-b86cf27c977e', 'aa@aa.hu', '2017-03-05 15:23:21'),
       (62,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'CC', '6b8e6034-04c6-11e6-8ded-b86cf27c977e', 'igeorge1982@gmail.com', '2017-03-05 15:23:21'),
       (63,
        '52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976',
        'CD', 'a08d4212-3d4e-11e6-b703-b68b964fca08', 'igeorge1982@yahoo.com', '2017-03-05 15:23:21');
/*!40000 ALTER TABLE `logins` ENABLE KEYS */;
UNLOCK
TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER insert_guid 
BEFORE INSERT ON logins
FOR EACH  ROW 
BEGIN 
    SET NEW.uuid = UUID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER vouchers 
AFTER INSERT ON logins 
FOR EACH ROW
BEGIN
       DECLARE uuid_ char(255);
	   select uuid into uuid_ from logins where last_insert_id() = last_insert_id() ORDER by ID DESC LIMIT 1;

  INSERT INTO vouchers
     (uuid) values (uuid_);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `user_on_devices`
--

DROP TABLE IF EXISTS `user_on_devices`;
/*!50001 DROP VIEW IF EXISTS `user_on_devices`*/;
SET
@saved_cs_client     = @@character_set_client;
SET
character_set_client = utf8;
/*!50001 CREATE VIEW `user_on_devices` AS SELECT 
 1 AS `user`,
 1 AS `email`,
 1 AS `uuid`,
 1 AS `deviceId`,
 1 AS `state`,
 1 AS `TIME_`,
 1 AS `voucher_`*/;
SET
character_set_client = @saved_cs_client;

--
-- Table structure for table `voucher_states`
--

DROP TABLE IF EXISTS `voucher_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voucher_states`
(
    `id`                  int(10) unsigned NOT NULL AUTO_INCREMENT,
    `state`               enum('free','processing','registered','expired') DEFAULT NULL,
    `voucher_`            char(255)          DEFAULT NULL,
    `duration_in_seconds` int(11) unsigned DEFAULT NULL,
    `toBeActivated`       tinyint(1) DEFAULT NULL,
    `isActivated`         tinyint(1) NOT NULL,
    `TIME_`               timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `activation_token`    char(255)          DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `voucher_` (`voucher_`),
    KEY                   `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucher_states`
--

LOCK
TABLES `voucher_states` WRITE;
/*!40000 ALTER TABLE `voucher_states` DISABLE KEYS */;
INSERT INTO `voucher_states`
VALUES (8, 'registered', '12345', NULL, 0, 1, '2016-03-10 20:25:44', NULL),
       (9, 'registered', '12346', NULL, 0, 1, '2016-03-10 20:41:30', NULL),
       (10, 'registered', '12347', NULL, 0, 1, '2016-03-10 20:41:30', NULL),
       (11, 'registered', '12348', NULL, 0, 1, '2016-03-10 20:40:42', NULL),
       (12, 'registered', '12349', NULL, 0, 1, '2016-03-10 20:40:51', NULL),
       (13, 'registered', '12350', NULL, 0, 1, '2016-03-10 20:41:00', NULL),
       (14, 'registered', '12351', NULL, 0, 1, '2016-03-10 20:41:07', NULL),
       (15, 'registered', '12352', NULL, 1, 0, '2016-04-20 22:48:32', '0.32044395554852105'),
       (16, 'free', '12353', NULL, 1, 0, '2017-03-14 08:59:40', '0.058389987850924946'),
       (17, 'registered', '12354', NULL, 1, 0, '2016-04-17 18:01:58', '0.32044395554852106'),
       (18, 'registered', '12355', NULL, 1, 0, '2016-04-14 21:17:11', '0.09055326235532134'),
       (19, 'registered', '12356', NULL, 1, 0, '2016-06-28 16:37:39', '0.554701955574287'),
       (20, 'free', '12357', NULL, 0, 1, '2017-03-21 13:22:48', NULL);
/*!40000 ALTER TABLE `voucher_states` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vouchers`
(
    `id`          int(20) NOT NULL AUTO_INCREMENT,
    `voucherUuid` char(255) CHARACTER SET utf8 DEFAULT NULL,
    `voucher_`    char(255) CHARACTER SET utf8 DEFAULT NULL,
    `uuid`        char(255) COLLATE utf8_bin   DEFAULT NULL,
    `TIME_`       timestamp NOT NULL           DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uuid` (`uuid`),
    UNIQUE KEY `voucherUuid_UNIQUE` (`voucherUuid`),
    UNIQUE KEY `voucher__UNIQUE` (`voucher_`),
    KEY           `uuid_2` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK
TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers`
VALUES (1, 'b2438bc2-019f-11e7-82f7-55d015f58ee5', '12346', '9f394dd6-6de0-11e5-8441-71caa0c5f788',
        '2017-03-05 12:31:46'),
       (2, '48fe32f6-01a0-11e7-82f7-55d015f58ee5', '12347', 'ab36ff88-6de1-11e5-8441-71caa0c5f788',
        '2017-03-05 12:35:58'),
       (3, '571c48d2-01a0-11e7-82f7-55d015f58ee5', '12348', '37bd295e-6de3-11e5-8441-71caa0c5f788',
        '2017-03-05 12:36:22'),
       (4, '65ec7e4a-01a0-11e7-82f7-55d015f58ee5', '12350', 'ce118410-b7bf-11e5-ab38-d9d1883983e4',
        '2017-03-05 12:36:47'),
       (5, '718b3dfe-01a0-11e7-82f7-55d015f58ee5', '12351', '0cc4b1a4-b7c1-11e5-ab38-d9d1883983e4',
        '2017-03-05 12:37:06'),
       (6, '81f0a1a2-01a0-11e7-82f7-55d015f58ee5', '12349', '437266ba-d03f-11e5-bf8d-12c4a3e48e1b',
        '2017-03-05 12:37:34'),
       (7, '92137168-01a0-11e7-82f7-55d015f58ee5', '12355', 'eefcfe1a-0284-11e6-b3c9-cce30c92baea',
        '2017-03-05 12:38:01'),
       (8, 'e508cf76-01a0-11e7-82f7-55d015f58ee5', '12345', '65f63602-6ddf-11e5-8441-71caa0c5f788',
        '2017-03-05 12:40:20'),
       (9, 'f9513ab8-01a0-11e7-82f7-55d015f58ee5', '12354', 'd4969b4e-04b4-11e6-8ded-b86cf27c977e',
        '2017-03-05 12:40:54'),
       (10, '5f56878c-01a1-11e7-82f7-55d015f58ee5', '12352', '6b8e6034-04c6-11e6-8ded-b86cf27c977e',
        '2017-03-05 12:43:45'),
       (11, '6c0a8d02-01a1-11e7-82f7-55d015f58ee5', '12356', 'a08d4212-3d4e-11e6-b703-b68b964fca08',
        '2017-03-14 09:23:24'),
       (12, '1a8ba03a-0cdf-11e7-85af-5c2dcc79f86f', NULL, '1a8b440a-0cdf-11e7-85af-5c2dcc79f86f',
        '2017-03-19 20:03:22'),
       (13, 'b3ccd0f2-0cdf-11e7-85af-5c2dcc79f86f', NULL, 'b3ccc8e6-0cdf-11e7-85af-5c2dcc79f86f',
        '2017-03-19 20:07:39');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK
TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER insert_voucher 
BEFORE INSERT ON vouchers
FOR EACH  ROW 
BEGIN 
    SET NEW.voucherUuid = UUID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'login'
--
/*!50003 DROP PROCEDURE IF EXISTS `check_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `check_voucher`(IN voucher_ char(255))
BEGIN
select voucher_
from login.voucher_states
where login.voucher_states.voucher_ = voucher_
  AND login.voucher_states.state = 'registered';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `copy_token2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `copy_token2`(IN voucher_ char(255))
BEGIN

declare
token2_ char(255);

select login.Tokens.token2
into token2_
from login.devices
         join login.vouchers on login.devices.uuid = login.vouchers.uuid
         join login.Tokens on login.Tokens.deviceId = login.devices.deviceId
         join login.voucher_states on login.voucher_states.voucher_ = vouchers.voucher_
where login.vouchers.voucher_ = voucher_
order by login.Tokens.TIME_ desc limit 1;

update login.voucher_states
set login.voucher_states.activation_token = token2_
where login.voucher_states.voucher_ = voucher_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `delete_user`(IN user_ char(255))
BEGIN

declare
uuid_ char(255);
declare
voucher char(255);

select uuid
into uuid_
from logins
where logins.user = user_;

select login.vouchers.voucher_
into voucher
from login.logins
         join login.vouchers on login.logins.uuid = login.vouchers.uuid
where login.vouchers.uuid = uuid_;


UPDATE login.voucher_states
SET login.voucher_states.state           ='free',
    login.voucher_states.activation_token=null
WHERE login.voucher_states.voucher_ = voucher
    AND login.voucher_states.state = 'registered'
   or login.voucher_states.state = 'processing';

delete
from login.logins
where login.logins.uuid = uuid_;
delete
from login.vouchers
where login.vouchers.uuid = uuid_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `find_email`(IN email char(255))
BEGIN
select email
from login.logins
where login.logins.email = email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `find_email2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `find_email2`(IN email char(255))
BEGIN

declare
email_ char(255);

select email
into email_
from login.logins
where login.logins.email = email;

select forgotRequestToken, forgotRequestTime
from login.forgotPsw
where login.forgotPsw.forgotUserEmail = email_
  and login.forgotPsw.isValid = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `forgot_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `forgot_password`(IN email char(255), IN time char(255))
BEGIN

declare
forgotRequestToken_ char(255);
declare
id_ int(11);

select id, forgotRequestToken
into id_, forgotRequestToken_
from forgotPsw
where forgotUserEmail = email;

if
forgotRequestToken_ is null then

insert into forgotPsw (forgotUserEmail, forgotRequestTime) values (email, time);

else

update forgotPsw
set forgotPsw.forgotUserEmail   = email,
    forgotPsw.forgotRequestTime = time, forgotPsw.isValid = 1
where id = id_;

end if;

select forgotRequestToken
from forgotPsw
where forgotUserEmail = email;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_activation_vocher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `get_activation_vocher`(IN user char(255))
BEGIN

select voucher_states.activation_token, logins.email
from voucher_states
         join vouchers on vouchers.voucher_ = voucher_states.voucher_
         join logins on vouchers.uuid = logins.uuid
where logins.user = user;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_hash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `get_hash`(IN hash_ char(255), IN user_ char(255))
BEGIN
select hash_
from login.logins
where login.logins.hash_ = hash_
  and login.logins.user = user_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_processing_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `get_processing_voucher`(IN voucher_ char(255))
BEGIN
select voucher_
from login.voucher_states
where login.voucher_states.voucher_ = voucher_
  AND login.voucher_states.state = 'processing';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_token` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `get_token`(IN deviceId_ char (255))
BEGIN
select token1
from Tokens
where deviceId = deviceId_
order by TIME_ desc LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_token2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `get_token2`(IN deviceId_ char (255))
BEGIN
select token2
from Tokens
where deviceId = deviceId_
order by TIME_ desc LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `get_voucher`(IN voucher_ char(255))
BEGIN
select voucher_
from login.voucher_states
where login.voucher_states.voucher_ = voucher_
  AND login.voucher_states.state = 'free';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_device` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `insert_device`(IN deviceId_ char(255), IN user_ varchar(255))
BEGIN

declare
uuid_ char(255);

select uuid
into uuid_
from logins
where logins.user = user_;


insert into devices (deviceId, uuid)
values (deviceId_, uuid_);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_device_` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `insert_device_`(IN deviceId_ char(255), IN user_ varchar(255))
BEGIN

declare
uuid_ char(255);
declare
devices_ char(255);
#declare
id_ int(11);
#declare
idS_ int(11);

select uuid
into uuid_
from logins
where logins.user = user_;

#join
devices with logins table to check device for user
#select id into id_ from devices_states where deviceId = deviceId_;
select deviceId
into devices_
from devices
where devices.deviceId = deviceId_
  and devices.uuid = uuid_;

if
deviceId_ != devices_ or devices_ is null then
insert into devices (deviceId, uuid) values (deviceId_,uuid_);

else

update device_states
set device_states.state = 'logged_in'
where device_states.deviceId = deviceId_;

end if;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_sessionCreated` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `insert_sessionCreated`(IN deviceId_ char(255), IN sessionCreated_ long, IN sessionID_ char(255))
BEGIN

declare
devices_ char(255);
declare
id_ int(11);
declare
idS_ int(11);

select id, deviceId
into id_, devices_
from Last_seen
where deviceId = deviceId_;
select id
into idS_
from device_states
where deviceId = deviceId_
order by TIME_ desc LIMIT 1;

if
deviceId_ != devices_ or devices_ is null then

insert into Last_seen (deviceId, Session_, devices_id) values (deviceId_,sessionCreated_, idS_);
update device_states
set SessionID = sessionID_
where device_states.deviceId = deviceId_
  and device_states.id = idS_;

else

update Last_seen
set Last_seen.Session_ = sessionCreated_
where Last_seen.deviceId = deviceId_
  and Last_seen.id = id_;

update device_states
set SessionID = sessionID_
where device_states.deviceId = deviceId_
  and device_states.id = idS_;

end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `insert_voucher`(IN voucher char(255), IN user_ varchar(255), IN pass char(255))
BEGIN

declare
uuid_ char(255);

select uuid
into uuid_
from logins
where logins.user = user_
  and logins.hash_ = pass;

update vouchers
    join logins
on vouchers.uuid = logins.uuid
    set vouchers.voucher_ = voucher
where vouchers.uuid = uuid_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `isActivated` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `isActivated`(IN user_ varchar(255))
BEGIN

select a.isActivated AS state
from voucher_states a
         left join vouchers b on a.voucher_ = b.voucher_
         left join logins c on c.uuid = b.uuid
where c.user = user_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `logout_device` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `logout_device`(IN sessionID_ char(255))
BEGIN
	
    declare
deviceId_ char(255);

update device_states
set device_states.state = 'logged_out'
where device_states.sessionID = sessionID_;

select deviceId
into deviceId_
from device_states
where device_states.sessionID = sessionID_;

update Tokens
set Tokens.token1 = 0 and Tokens.token2 = 0
where Tokens.deviceId = deviceId_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `register_voucher`(IN voucher_ char(255))
BEGIN
UPDATE login.voucher_states
SET login.voucher_states.state ='registered'
WHERE login.voucher_states.voucher_ = voucher_
  AND login.voucher_states.state = 'processing';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reset_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `reset_voucher`(IN voucher_ char(255))
BEGIN
UPDATE login.voucher_states
SET login.voucher_states.state ='free'
WHERE login.voucher_states.voucher_ = voucher_
    AND login.voucher_states.state = 'registered'
   or login.voucher_states.state = 'processing';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `set_voucher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `set_voucher`(IN voucher_ char(255))
BEGIN
UPDATE login.voucher_states
SET login.voucher_states.state ='processing'
WHERE login.voucher_states.voucher_ = voucher_
  AND login.voucher_states.state = 'free';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`sqluser`@`localhost` PROCEDURE `update_password`(IN pass_ char(255), IN email_ char(255))
BEGIN

declare
id_ int(11);

select id
into id_
from login.logins
where login.logins.email = email_;

update login.logins
set login.logins.hash_ = pass_
where login.logins.id = id_;

update login.forgotPsw
set login.forgotPsw.isValid = 0
where login.forgotPsw.forgotUserEmail = email_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `user_on_devices`
--

/*!50001 DROP VIEW IF EXISTS `user_on_devices`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_on_devices` AS select `logins`.`user` AS `user`,`logins`.`email` AS `email`,`logins`.`uuid` AS `uuid`,`devices`.`deviceId` AS `deviceId`,`device_states`.`state` AS `state`,`device_states`.`TIME_` AS `TIME_`,`voucher_states`.`voucher_` AS `voucher_` from (((((`logins` join `vouchers` on((`logins`.`uuid` = `vouchers`.`uuid`))) join `devices` on((`logins`.`uuid` = `devices`.`uuid`))) join `device_states` on((`devices`.`uuid` = `device_states`.`uuid`))) join `tokens` on((`tokens`.`deviceId` = `devices`.`deviceId`))) join `voucher_states` on((`voucher_states`.`voucher_` = `vouchers`.`voucher_`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-21 14:31:06
