CREATE DATABASE  IF NOT EXISTS `login` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `login`;
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
CREATE TABLE `Last_seen` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `deviceId` char(255) COLLATE utf8_bin NOT NULL DEFAULT '0000',
  `Session_` mediumtext COLLATE utf8_bin,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `devices_id` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`,`deviceId`),
  KEY `deviceId` (`deviceId`),
  KEY `fk_devices_idx` (`devices_id`),
  CONSTRAINT `fk_devices2` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Last_seen`
--

LOCK TABLES `Last_seen` WRITE;
/*!40000 ALTER TABLE `Last_seen` DISABLE KEYS */;
INSERT INTO `Last_seen` VALUES (1,'64CAA753-A134-44C4-A425-92B46A6D18A8','1588542251924','2020-05-03 21:44:11',1);
/*!40000 ALTER TABLE `Last_seen` ENABLE KEYS */;
UNLOCK TABLES;
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
CREATE TABLE `Tokens` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `deviceId` char(255) COLLATE utf8_bin DEFAULT NULL,
  `token1` char(255) COLLATE utf8_bin DEFAULT NULL,
  `token2` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `devices_id` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token1` (`token1`),
  UNIQUE KEY `token2` (`token2`),
  KEY `token2_2` (`token2`),
  KEY `fk_devices3_idx` (`devices_id`),
  CONSTRAINT `fk_devices3` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tokens`
--

LOCK TABLES `Tokens` WRITE;
/*!40000 ALTER TABLE `Tokens` DISABLE KEYS */;
INSERT INTO `Tokens` VALUES (1,'64CAA753-A134-44C4-A425-92B46A6D18A8','39e2f5d8-8d87-11ea-a441-cf47f7011c8d','0.4399847150221325','2020-05-03 21:44:11',1);
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
  `deviceId` char(255) CHARACTER SET utf8 DEFAULT NULL,
  `state` enum('logged_in','playing','logged_out','deleted') COLLATE utf8_bin DEFAULT NULL,
  `SessionID` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `uuid` char(255) COLLATE utf8_bin DEFAULT NULL,
  `devices_id` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `state` (`state`),
  KEY `deviceId` (`deviceId`),
  KEY `time` (`TIME_`),
  KEY `sessionID` (`SessionID`),
  KEY `fk_devices_idx` (`devices_id`),
  CONSTRAINT `fk_devices` FOREIGN KEY (`devices_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_states`
--

LOCK TABLES `device_states` WRITE;
/*!40000 ALTER TABLE `device_states` DISABLE KEYS */;
INSERT INTO `device_states` VALUES (1,'64CAA753-A134-44C4-A425-92B46A6D18A8','logged_out','qs77DJ16A2PwXbxQjXtmUVfDiSf1C0skkxVXaPRi','2020-05-03 21:43:48','65f63602-6ddf-11e5-8441-71caa0c5f788',1),(2,'64CAA753-A134-44C4-A425-92B46A6D18A8','logged_in','Mg47Ho9vUJ6mk5xy9ZHF-BDTWH_LgLCGwL_6e54k','2020-05-03 21:44:11','97c6fd76-ed90-11e9-871a-874ce8a992e2',2);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'64CAA753-A134-44C4-A425-92B46A6D18A8','65f63602-6ddf-11e5-8441-71caa0c5f788','2020-05-03 21:43:27'),(2,'64CAA753-A134-44C4-A425-92B46A6D18A8','97c6fd76-ed90-11e9-871a-874ce8a992e2','2020-05-03 21:44:11');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;
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
CREATE TABLE `forgotPsw` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forgotUserEmail` char(255) NOT NULL,
  `forgotRequestToken` char(255) DEFAULT NULL,
  `forgotRequestTime` char(255) DEFAULT NULL,
  `isValid` tinyint(1) DEFAULT NULL,
  `TIME_` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `forgotUserEmail_UNIQUE` (`forgotUserEmail`),
  UNIQUE KEY `forgotRequestToken_UNIQUE` (`forgotRequestToken`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forgotPsw`
--

LOCK TABLES `forgotPsw` WRITE;
/*!40000 ALTER TABLE `forgotPsw` DISABLE KEYS */;
INSERT INTO `forgotPsw` VALUES (1,'ga@ga.com','0.20107192378590993','1491772273707',0,'2017-04-09 21:11:23'),(2,'gi@gi.com','0.8017910614626399','1490129614313',0,'2017-03-21 20:55:32'),(3,'igeorge1982@gmail.com','0.23730198502289315','1588170794417',0,'2020-04-29 14:33:29');
/*!40000 ALTER TABLE `forgotPsw` ENABLE KEYS */;
UNLOCK TABLES;
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
CREATE TABLE `logins` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `hash_` char(255) COLLATE utf8_bin NOT NULL,
  `user` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `uuid` char(255) COLLATE utf8_bin DEFAULT NULL,
  `email` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `user_UNIQUE` (`user`),
  KEY `user` (`user`),
  KEY `hash_` (`hash_`),
  FULLTEXT KEY `user_2` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logins`
--

LOCK TABLES `logins` WRITE;
/*!40000 ALTER TABLE `logins` DISABLE KEYS */;
INSERT INTO `logins` VALUES (2,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','GI','97c6fd76-ed90-11e9-871a-874ce8a992e2','ildiko.gaspar.911@gmail.com','2019-10-13 08:09:41'),(5,'52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976','Milo','f73b72c4-1071-11ea-9359-551258859352','igeorge1982@yahoo.com','2019-11-26 17:27:05'),(9,'c3f143d18059221215df660694195553ce02d4ebb4a48e89a5a5a0104898f61a9c6b24793cf5e80ad37616696d1b504295aa9a0c0a10ed3fd0380928d18b7cc1','GG','65f63602-6ddf-11e5-8441-71caa0c5f788','igeorge1982@gmail.com','2020-04-29 14:33:29');
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
-- Temporary view structure for view `user_on_devices`
--

DROP TABLE IF EXISTS `user_on_devices`;
/*!50001 DROP VIEW IF EXISTS `user_on_devices`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `user_on_devices` AS SELECT 
 1 AS `user`,
 1 AS `uuid`,
 1 AS `email`,
 1 AS `voucher`,
 1 AS `deviceId`,
 1 AS `state`,
 1 AS `sessionID`,
 1 AS `Time`*/;
SET character_set_client = @saved_cs_client;

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
  `activation_token` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `voucher_` (`voucher_`),
  KEY `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucher_states`
--

LOCK TABLES `voucher_states` WRITE;
/*!40000 ALTER TABLE `voucher_states` DISABLE KEYS */;
INSERT INTO `voucher_states` VALUES (8,'free','12345',NULL,0,1,'2019-12-14 17:41:05',NULL),(9,'registered','12346',NULL,0,1,'2019-10-13 08:08:08','0.21622941476873067'),(10,'registered','12347',NULL,0,1,'2019-12-14 17:19:36','0.31117856345249206'),(11,'registered','12348',NULL,0,1,'2019-12-14 17:34:51','0.1513986430609586'),(12,'free','12349',NULL,0,1,'2019-03-05 00:04:28',NULL),(13,'free','12350',NULL,0,1,'2019-03-05 00:04:28',NULL),(14,'free','12351',NULL,0,1,'2019-03-05 00:04:28',NULL),(15,'registered','12352',NULL,1,0,'2019-11-26 17:27:05','0.3084171948101532'),(16,'free','12353',NULL,1,0,'2019-03-05 00:04:28',''),(17,'free','12354',NULL,1,0,'2019-03-05 00:04:28',''),(18,'free','12355',NULL,1,0,'2019-03-05 00:04:28',''),(19,'free','12356',NULL,1,0,'2019-03-05 00:04:28',''),(20,'free','12357',NULL,0,1,'2017-03-21 13:22:48',NULL);
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
  `voucherUuid` char(255) CHARACTER SET utf8 DEFAULT NULL,
  `voucher_` char(255) CHARACTER SET utf8 DEFAULT NULL,
  `uuid` char(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `voucherUuid_UNIQUE` (`voucherUuid`),
  UNIQUE KEY `voucher__UNIQUE` (`voucher_`),
  KEY `uuid_2` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` VALUES (9,'97c76dc4-ed90-11e9-871a-874ce8a992e2','12346','97c6fd76-ed90-11e9-871a-874ce8a992e2','2019-10-13 08:08:08'),(12,'f73b7e0e-1071-11ea-9359-551258859352','12352','f73b72c4-1071-11ea-9359-551258859352','2019-11-26 17:27:05'),(13,'e75efdd0-1e95-11ea-878f-b5c6be69cfd4','12347','e75ee37c-1e95-11ea-878f-b5c6be69cfd4','2019-12-14 17:19:36'),(14,'65f63602-6ddf-11e5-8441-71caa0c5f788','12348','65f63602-6ddf-11e5-8441-71caa0c5f788','2019-12-17 08:42:06');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `copy_token2`(IN voucher_ char(255))
BEGIN

declare token2_ char(255);

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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `delete_user`(IN user_ char(255))
BEGIN

declare uuid_ char(255);
declare voucher char(255);

select uuid into uuid_ from logins where logins.user = user_;

select login.vouchers.voucher_ into voucher
from login.logins
join login.vouchers on login.logins.uuid = login.vouchers.uuid
where login.vouchers.uuid = uuid_;


UPDATE login.voucher_states 
SET login.voucher_states.state ='free',
login.voucher_states.activation_token=null 
WHERE login.voucher_states.voucher_ = voucher 
AND login.voucher_states.state = 'registered' or login.voucher_states.state = 'processing';

delete from login.logins where login.logins.uuid = uuid_;
delete from login.vouchers where login.vouchers.uuid = uuid_;

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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `find_email`(IN email char(255))
BEGIN
select email from login.logins where login.logins.email = email;
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `find_email2`(IN email char(255))
BEGIN

declare email_ char(255);

select email into email_ from login.logins where login.logins.email = email;

select forgotRequestToken, forgotRequestTime from login.forgotPsw 
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `forgot_password`(IN email char(255), IN time char(255))
BEGIN

declare forgotRequestToken_ char(255);
declare id_ int(11);

select id, forgotRequestToken into id_, forgotRequestToken_ from forgotPsw where forgotUserEmail = email;

if forgotRequestToken_ is null then

insert into forgotPsw (forgotUserEmail, forgotRequestTime) values (email, time);

else

update forgotPsw 
set forgotPsw.forgotUserEmail = email, forgotPsw.forgotRequestTime = time, forgotPsw.isValid = 1
where id = id_;

end if;

select forgotRequestToken from forgotPsw where forgotUserEmail = email;


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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_activation_vocher`(IN user char(255))
BEGIN

select voucher_states.activation_token, logins.email from voucher_states 
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_hash`(IN hash_ char(255), IN user_ char(255))
BEGIN
select hash_ 
from login.logins
where login.logins.hash_ = hash_ and
login.logins.user = user_;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_token2`(IN deviceId_ char (255))
BEGIN
select Tokens.token2, Last_seen.Session_ from Tokens join Last_seen on Tokens.deviceId = Last_seen.deviceId where Tokens.deviceId = deviceId_ order by Tokens.TIME_ desc LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_uuid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `get_uuid`(IN user_ char (255))
BEGIN
select uuid from logins where user = user_;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `insert_device_`(IN deviceId_ char(255), IN user_ varchar(255))
BEGIN

declare uuid_ char(255);
declare devices_ char(255);
#declare id_ int(11);
#declare idS_ int(11);

select uuid into uuid_ from logins
where logins.user = user_ ;

#join devices with logins table to check device for user
#select id into id_ from devices_states where deviceId = deviceId_;
select deviceId into devices_ from devices where devices.deviceId = deviceId_ and devices.uuid = uuid_;

if deviceId_ != devices_ or devices_ is null then
insert into devices (deviceId, uuid) values (deviceId_,uuid_);

else

update device_states 
set device_states.state = 'logged_in' 
where device_states.deviceId = deviceId_
and device_states.uuid = uuid_;

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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `insert_sessionCreated`(IN deviceId_ char(255), IN sessionCreated_ long, IN sessionID_ char(255))
BEGIN

declare devices_ char(255);
declare id_ int(11);
declare idS_ int(11);

select id, deviceId into id_, devices_ from Last_seen where deviceId = deviceId_;
select id into idS_ from device_states where deviceId = deviceId_ order by TIME_ desc LIMIT 1;

if deviceId_ != devices_ or devices_ is null then

insert into Last_seen (deviceId, Session_, devices_id) values (deviceId_,sessionCreated_, idS_);
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `logout_device`(IN sessionID_ char(255))
BEGIN
	
    declare deviceId_ char(255);

	update device_states 
	set device_states.state = 'logged_out' 
	where device_states.sessionID = sessionID_;
    
    select deviceId into deviceId_ from device_states
	where device_states.sessionID = sessionID_;
    
    ##comment out if it causes issues in TomCat cluster env
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `reset_voucher`(IN voucher_ char(255), IN user_ varchar(255))
BEGIN
UPDATE login.voucher_states 
SET login.voucher_states.state ='free'
WHERE login.voucher_states.voucher_ = voucher_ 
AND login.voucher_states.state = 'registered' or login.voucher_states.state = 'processing';

DELETE FROM login.logins WHERE login.logins.user = user_;
DELETE FROM login.vouchers WHERE login.vouchers.voucher_ = voucher_;
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
CREATE DEFINER=`sqluser`@`localhost` PROCEDURE `update_password`(IN pass_ char(255), IN email_ char(255))
BEGIN

declare id_ int(11);

select id into id_ from login.logins where login.logins.email = email_;

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
/*!50001 VIEW `user_on_devices` AS select `logins`.`user` AS `user`,`logins`.`uuid` AS `uuid`,`logins`.`email` AS `email`,`vouchers`.`voucher_` AS `voucher`,`device_states`.`deviceId` AS `deviceId`,`device_states`.`state` AS `state`,`device_states`.`SessionID` AS `sessionID`,`device_states`.`TIME_` AS `Time` from ((`logins` join `vouchers` on((`logins`.`uuid` = `vouchers`.`uuid`))) join `device_states` on((`logins`.`uuid` = `device_states`.`uuid`))) */;
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

-- Dump completed on 2020-05-04  0:34:59
