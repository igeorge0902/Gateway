-- MySQL dump 10.13  Distrib 5.6.24, for osx10.8 (x86_64)
--
-- Host: 127.0.0.1    Database: login
-- ------------------------------------------------------
-- Server version	5.6.25-log

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
CREATE TABLE `Last_seen` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `deviceId` char(255) COLLATE utf8_bin NOT NULL DEFAULT '0000',
  `Session_` mediumtext COLLATE utf8_bin,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`deviceId`),
  KEY `deviceId` (`deviceId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Last_seen`
--

LOCK TABLES `Last_seen` WRITE;
/*!40000 ALTER TABLE `Last_seen` DISABLE KEYS */;
INSERT INTO `Last_seen` VALUES (1,'88F7A2D8-25C5-4085-A5C1-28F425F61431','1459356745374','2016-03-30 16:52:25'),(2,'D9840B2C-D08C-4232-827C-196A73CDFCFB','1460396917455','2016-04-11 17:48:37'),(3,'0509360114613237056832032','1459356868155','2016-03-30 16:54:28'),(4,'75010114537364902623110537365900144024','1460370633515','2016-04-11 10:30:33');
/*!40000 ALTER TABLE `Last_seen` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tokens 
AFTER INSERT ON Last_seen 
FOR EACH ROW

BEGIN
       DECLARE deviceId_ char(255);
	   select deviceId into deviceId_ from Last_seen where last_insert_id() = last_insert_id() ORDER by ID DESC LIMIT 1;
  
  INSERT INTO Tokens (deviceId) values (deviceId_);

  
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
CREATE TABLE `Tokens` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `deviceId` char(255) COLLATE utf8_bin DEFAULT NULL,
  `token1` char(255) COLLATE utf8_bin DEFAULT NULL,
  `token2` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token1` (`token1`),
  UNIQUE KEY `token2` (`token2`),
  KEY `token2_2` (`token2`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tokens`
--

LOCK TABLES `Tokens` WRITE;
/*!40000 ALTER TABLE `Tokens` DISABLE KEYS */;
INSERT INTO `Tokens` VALUES (1,'88F7A2D8-25C5-4085-A5C1-28F425F61431','cf1244b4-f697-11e5-ad08-198d77b00c29','0.8424547657765958','2016-03-30 16:52:37'),(2,'D9840B2C-D08C-4232-827C-196A73CDFCFB','9e7887ee-000d-11e6-95b7-dafd64fecafc','0.180317500774113','2016-04-11 17:48:37'),(3,'0509360114613237056832032','13ced32e-f698-11e5-ad08-198d77b00c29','0.9291308763708276','2016-03-30 16:54:33'),(4,'75010114537364902623110537365900144024','a511e79c-ffd3-11e5-95b7-dafd64fecafc','0.7369539791130963','2016-04-11 10:53:37');
/*!40000 ALTER TABLE `Tokens` ENABLE KEYS */;
UNLOCK TABLES;
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
CREATE TABLE `device_states` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `deviceId` char(255) COLLATE utf8_bin DEFAULT NULL,
  `state` enum('logged_in','playing','logged_out','deleted') COLLATE utf8_bin DEFAULT NULL,
  `SessionID` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `state` (`state`),
  KEY `deviceId` (`deviceId`),
  KEY `time` (`TIME_`),
  KEY `sessionID` (`SessionID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_states`
--

LOCK TABLES `device_states` WRITE;
/*!40000 ALTER TABLE `device_states` DISABLE KEYS */;
INSERT INTO `device_states` VALUES (1,'88F7A2D8-25C5-4085-A5C1-28F425F61431','logged_out','870be9ef309070f23991d3ba5d34','2016-03-30 16:52:37'),(3,'0509360114613237056832032','logged_out','8729e3b296b2087b6b29d946a16b','2016-03-30 16:54:33'),(5,'D9840B2C-D08C-4232-827C-196A73CDFCFB','logged_in','67082cf673a4213d475b8324dc5d','2016-04-11 17:48:37'),(6,'75010114537364902623110537365900144024','logged_out','4df732b19216475271b5af9f20b7','2016-04-11 12:11:03'),(7,'75010114537364902623110537365900144024','logged_out','4df732b19216475271b5af9f20b7','2016-04-11 12:11:03');
/*!40000 ALTER TABLE `device_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `deviceId` char(255) COLLATE utf8_bin DEFAULT NULL,
  `uuid` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'88F7A2D8-25C5-4085-A5C1-28F425F61431','9f394dd6-6de0-11e5-8441-71caa0c5f788','2016-03-30 16:52:11'),(2,'D9840B2C-D08C-4232-827C-196A73CDFCFB','65f63602-6ddf-11e5-8441-71caa0c5f788','2016-03-30 16:53:36'),(3,'0509360114613237056832032','65f63602-6ddf-11e5-8441-71caa0c5f788','2016-03-30 16:54:28'),(4,'D9840B2C-D08C-4232-827C-196A73CDFCFB','ab36ff88-6de1-11e5-8441-71caa0c5f788','2016-03-30 17:00:48'),(5,'D9840B2C-D08C-4232-827C-196A73CDFCFB','9f394dd6-6de0-11e5-8441-71caa0c5f788','2016-04-04 06:32:56'),(6,'75010114537364902623110537365900144024','6c073e32-ffd0-11e5-95b7-dafd64fecafc','2016-04-11 10:30:33'),(7,'75010114537364902623110537365900144024','a50d723e-ffd3-11e5-95b7-dafd64fecafc','2016-04-11 10:53:37');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sqluser`@`localhost`*/ /*!50003 TRIGGER deviceId_uuid 
AFTER INSERT ON devices 
FOR EACH ROW

BEGIN
       DECLARE deviceId_ char(255);
	   select deviceId into deviceId_ from devices where last_insert_id() = last_insert_id() ORDER by ID DESC LIMIT 1;

  INSERT INTO device_states (deviceId, state) values (deviceId_, 'logged_in');
  
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
CREATE TABLE `logins` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `hash_` char(255) COLLATE utf8_bin DEFAULT NULL,
  `user` varchar(255) COLLATE utf8_bin NOT NULL,
  `uuid` char(255) COLLATE utf8_bin DEFAULT NULL,
  `email` char(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_UNIQUE` (`user`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `user` (`user`),
  KEY `hash_` (`hash_`),
  FULLTEXT KEY `user_2` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logins`
--

LOCK TABLES `logins` WRITE;
/*!40000 ALTER TABLE `logins` DISABLE KEYS */;
INSERT INTO `logins` VALUES (1,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GG','65f63602-6ddf-11e5-8441-71caa0c5f788',NULL),(2,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GA','9f394dd6-6de0-11e5-8441-71caa0c5f788',NULL),(3,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GI','ab36ff88-6de1-11e5-8441-71caa0c5f788',NULL),(4,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','Lilla','37bd295e-6de3-11e5-8441-71caa0c5f788',NULL),(5,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','Milo','81e84d10-6de3-11e5-8441-71caa0c5f788',NULL),(13,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','KI','ce118410-b7bf-11e5-ab38-d9d1883983e4',NULL),(14,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','KK','0cc4b1a4-b7c1-11e5-ab38-d9d1883983e4',NULL),(25,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GGG','437266ba-d03f-11e5-bf8d-12c4a3e48e1b','igeorge1982@gmail.com'),(26,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GGGGG','6c073e32-ffd0-11e5-95b7-dafd64fecafc','g@g.hu'),(27,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GGGG','a50d723e-ffd3-11e5-95b7-dafd64fecafc','gg@gg.hu');
/*!40000 ALTER TABLE `logins` ENABLE KEYS */;
UNLOCK TABLES;
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
-- Table structure for table `voucher_states`
--

DROP TABLE IF EXISTS `voucher_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voucher_states` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` enum('free','processing','registered','expired') DEFAULT NULL,
  `voucher_` char(255) DEFAULT NULL,
  `duration_in_seconds` int(11) unsigned DEFAULT NULL,
  `toBeActivated` tinyint(1) DEFAULT NULL,
  `isActivated` tinyint(1) NOT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `voucher_` (`voucher_`),
  KEY `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucher_states`
--

LOCK TABLES `voucher_states` WRITE;
/*!40000 ALTER TABLE `voucher_states` DISABLE KEYS */;
INSERT INTO `voucher_states` VALUES (8,'registered','12345',NULL,0,1,'2016-03-10 20:25:44'),(9,'registered','12346',NULL,0,1,'2016-03-10 20:41:30'),(10,'registered','12347',NULL,0,1,'2016-03-10 20:41:30'),(11,'registered','12348',NULL,0,1,'2016-03-10 20:40:42'),(12,'registered','12349',NULL,0,1,'2016-03-10 20:40:51'),(13,'registered','12350',NULL,0,1,'2016-03-10 20:41:00'),(14,'registered','12351',NULL,0,1,'2016-03-10 20:41:07'),(15,'registered','12352',NULL,1,0,'2016-04-11 10:20:19'),(16,'registered','12353',NULL,1,0,'2016-04-11 10:30:33'),(17,'registered','12354',NULL,1,0,'2016-04-11 10:53:37');
/*!40000 ALTER TABLE `voucher_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vouchers` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `voucher_` char(255) COLLATE utf8_bin DEFAULT NULL,
  `uuid` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `uuid_2` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` VALUES (1,'12345','65f63602-6ddf-11e5-8441-71caa0c5f788','2015-10-08 17:09:56'),(2,'12346','9f394dd6-6de0-11e5-8441-71caa0c5f788','2015-10-08 17:18:41'),(3,'12347','ab36ff88-6de1-11e5-8441-71caa0c5f788','2015-10-08 17:26:11'),(4,'12348','37bd295e-6de3-11e5-8441-71caa0c5f788','2015-10-08 17:37:16'),(9,'12350','ce118410-b7bf-11e5-ab38-d9d1883983e4','2016-01-10 17:30:12'),(10,'12351','0cc4b1a4-b7c1-11e5-ab38-d9d1883983e4','2016-01-10 17:39:07'),(21,'12349','437266ba-d03f-11e5-bf8d-12c4a3e48e1b','2016-02-10 21:43:03'),(22,'12353','6c073e32-ffd0-11e5-95b7-dafd64fecafc','2016-04-11 10:30:33'),(23,'12354','a50d723e-ffd3-11e5-95b7-dafd64fecafc','2016-04-11 10:53:37');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;

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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `check_voucher`(IN voucher_ char(255))
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
/*!50003 DROP PROCEDURE IF EXISTS `get_hash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_hash`(IN hash_ char(255))
BEGIN
select hash_ 
from login.logins
where login.logins.hash_ = hash_;
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_processing_voucher`(IN voucher_ char(255))
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_token`(IN deviceId_ char (255))
BEGIN
select token1 from Tokens where deviceId = deviceId_ order by TIME_ desc LIMIT 1;
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_token2`(IN deviceId_ char (255))
BEGIN
select token2 from Tokens where deviceId = deviceId_ order by TIME_ desc LIMIT 1;
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_voucher`(IN voucher_ char(255))
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `insert_device`(IN deviceId_ char(255), IN user_ varchar(255))
BEGIN

declare uuid_ char(255);

select uuid into uuid_ from logins
where logins.user = user_ ;


insert into devices (deviceId, uuid) values (deviceId_,uuid_);

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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `insert_device_`(IN deviceId_ char(255), IN user_ varchar(255))
BEGIN

declare uuid_ char(255);
declare devices_ char(255);

select uuid into uuid_ from logins
where logins.user = user_ ;

#join devices with logins table to check device for user
#select deviceId into devices_ from devices where deviceId = deviceId_;

select a.deviceId into devices_ from devices a left join logins b on a.uuid = b.uuid where a.deviceId = deviceId_ and b.user = user_;


if deviceId_ != devices_ or devices_ is null then

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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `insert_sessionCreated`(IN deviceId_ char(255), IN sessionCreated_ long, IN sessionID_ char(255))
BEGIN

declare devices_ char(255);
declare id_ int(11);
declare idS_ int(11);

select id, deviceId into id_, devices_ from Last_seen where deviceId = deviceId_;
select id into idS_ from device_states where deviceId = deviceId_ order by TIME_ desc LIMIT 1;

if deviceId_ != devices_ or devices_ is null then

insert into Last_seen (deviceId, Session_) values (deviceId_,sessionCreated_);
update device_states set SessionID = sessionID_ where device_states.deviceId = deviceId_ and device_states.id = idS_;

else 

update Last_seen 
set Last_seen.Session_ = sessionCreated_ 
where Last_seen.deviceId = deviceId_ and Last_seen.id= id_;

update device_states set SessionID = sessionID_ 
where device_states.deviceId = deviceId_ and device_states.id = idS_;

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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `insert_voucher`(IN voucher char(255), IN user_ varchar(255), IN pass char(255))
BEGIN

declare uuid_ char(255);

select uuid into uuid_ from logins
where logins.user = user_ and logins.hash_ = pass;

update vouchers 
join logins on vouchers.uuid = logins.uuid
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `isActivated`(IN user_ varchar(255))
BEGIN

select a.isActivated AS state 
from voucher_states a 
left join  vouchers b on a.voucher_ = b.voucher_ 
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `logout_device`(IN sessionID_ char(255))
BEGIN
	
    declare deviceId_ char(255);

	update device_states 
	set device_states.state = 'logged_out' 
	where device_states.sessionID = sessionID_;
    
    select deviceId into deviceId_ from device_states
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `register_voucher`(IN voucher_ char(255))
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `reset_voucher`(IN voucher_ char(255))
BEGIN
UPDATE login.voucher_states 
SET login.voucher_states.state ='free' 
WHERE login.voucher_states.voucher_ = voucher_ 
AND login.voucher_states.state = 'registered' or login.voucher_states.state = 'processing';
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `set_voucher`(IN voucher_ char(255))
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-11 19:49:46
