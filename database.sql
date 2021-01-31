CREATE DATABASE  IF NOT EXISTS `jad` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `jad`;
-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: jad
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `FkBuyerId` int NOT NULL,
  `FkProductId` int NOT NULL,
  `qty` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `buyer_idx` (`FkBuyerId`),
  KEY `product2_idx` (`FkProductId`),
  CONSTRAINT `buyer` FOREIGN KEY (`FkBuyerId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product2` FOREIGN KEY (`FkProductId`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (8,4,22,1);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Laptops','2020-05-27 23:05:15'),(2,'Smartphones','2020-05-27 23:05:15'),(40,'table','2020-08-13 20:39:52');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `FkBuyerId` int NOT NULL,
  `FkProductId` int NOT NULL,
  `qty` int NOT NULL,
  `Status` tinyint NOT NULL DEFAULT '0',
  `billAddr` varchar(510) NOT NULL,
  `shipAddr` varchar(510) NOT NULL,
  `billPostal` int NOT NULL,
  `shipPostal` int NOT NULL,
  `billCountry` char(3) DEFAULT NULL,
  `shipCountry` char(3) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_idx` (`FkProductId`),
  KEY `offor_idx` (`FkBuyerId`),
  CONSTRAINT `offor` FOREIGN KEY (`FkBuyerId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product` FOREIGN KEY (`FkProductId`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (7,8,22,1,2,'blk 267 toh guan road','blk 267 toh guan road',600267,600267,'SGP','SGP','2020-08-06 09:56:39'),(8,8,23,1,-1,'blk 267 toh guan road','blk 267 toh guan road',600267,600267,'SGP','SGP','2020-08-06 09:56:39'),(9,8,23,1,1,'blk 267 toh guan road','blk 265 toh guan road',600267,600265,'SGP','SLE','2020-08-06 18:32:43'),(10,8,23,1,0,'blk 267 toh guan road','blk 267 toh guan road',600267,600267,'SGP','SGP','2020-08-13 20:51:50'),(11,8,21,1,0,'blk 267 toh guan road','blk 267 toh guan road',600267,600267,'SGP','SGP','2020-08-13 20:51:50');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `briefD` varchar(255) DEFAULT NULL,
  `detailD` varchar(8000) DEFAULT NULL,
  `costPr` double NOT NULL,
  `retailPr` double NOT NULL,
  `qty` int NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `FKCategoryId` int NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cat_idx` (`FKCategoryId`),
  CONSTRAINT `cat` FOREIGN KEY (`FKCategoryId`) REFERENCES `category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (9,'zane2','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ',10.55,10.55,8,'https://images.unsplash.com/photo-1548611635-b6e7827d7d4a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80',1,'2020-05-27 23:05:15'),(12,'zan55','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dolor sit amet consectetur adipiscing elit ut. Urna nunc id cursus metus aliquam. Mauris cursus mattis molestie a. Tortor pretium viverra suspendisse potenti nullam ac tortor vitae. Gravida dictum fusce ut placerat orci nulla pellentesque dignissim. Cursus vitae congue mauris rhoncus. Tempor nec feugiat nisl pretium fusce id velit ut. Lectus urna duis convallis convallis tellus. Egestas sed sed risus pretium quam vulputate dignissim',551515,2515129,3,'https://images.unsplash.com/photo-1551817958-d9d86fb29431?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80',1,'2020-05-30 09:53:24'),(18,'asus','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute',200,1200,7,'https://images.unsplash.com/photo-1577375729152-4c8b5fcda381?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=80',1,'2020-07-21 19:45:32'),(19,'iphone','minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in ','minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in ',3,5,5,'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',1,'2020-07-21 19:51:11'),(20,'lenovo','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad ','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',7,4,0,'https://www.asus.com/media/global/gallery/Wt8C4pHn0BmrRjHI_setting_000_1_90_end_500.png',1,'2020-07-21 19:54:20'),(21,'acer','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad ','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',8,8,8,'https://images.unsplash.com/photo-1552257079-e48b715185fa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1189&q=80',1,'2020-07-21 19:55:00'),(22,'macbook','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',12,11,3,'https://images.unsplash.com/photo-1581090123826-27b62664de96?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',1,'2020-07-21 19:55:46'),(23,'dell','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad ','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',5,4,7,'https://images.unsplash.com/photo-1558864559-ed673ba3610b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1189&q=80',1,'2020-07-21 19:56:51'),(24,'oppo','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',122,222,2,'https://images.unsplash.com/photo-1551721434-8b94ddff0e6d?ixlib=rb-https://images.unsplash.com/photo-1551721434-8b94ddff0e6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=701&q=8031592/galaxynote10plus-1024x768.jpg',2,'2020-07-30 23:01:48'),(25,'ZTE','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad ','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',2,7,1,'https://unsplash.com/photos/OYMKjv5zmGU/download?force=true&w=640',1,'2020-07-30 23:07:24'),(26,'sansunng','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',1,3,8,'https://unsplash.com/photos/41yF2vjjk0g/download?force=true&w=640',2,'2020-08-13 20:37:40');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `viewAdmin` tinyint(1) NOT NULL,
  `addProduct` tinyint(1) NOT NULL,
  `editProduct` tinyint(1) NOT NULL,
  `delProduct` tinyint(1) NOT NULL,
  `addUser` tinyint(1) NOT NULL,
  `editUser` tinyint(1) NOT NULL,
  `delUser` tinyint(1) NOT NULL,
  `setOrderStatus` tinyint(1) NOT NULL,
  `setCategory` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'User',0,0,0,0,0,0,0,0,0),(2,'Admin',1,1,1,1,0,0,0,1,1),(3,'Root',1,1,1,1,1,1,1,1,1);
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password` char(60) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `FkRoleId` int NOT NULL,
  `contact` varchar(15) NOT NULL,
  `name` varchar(45) NOT NULL,
  `country` char(3) DEFAULT NULL,
  `address` varchar(510) DEFAULT NULL,
  `postalCode` int DEFAULT NULL,
  `spent` double NOT NULL DEFAULT '0',
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`email`),
  KEY `role_idx` (`FkRoleId`),
  CONSTRAINT `role` FOREIGN KEY (`FkRoleId`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'root@zElectronics.com.sg','$2a$12$aE9qMukfEJUnsV4uA8vgxOnP5a9XqP2./xOVQD81A01YEL64ewzmK','https://source.unsplash.com/featured/?face',3,'96873572','root','SGP','blk2',400267,0,'2020-07-08 23:20:39'),(2,'zzz@zzz.com','$2a$12$spnM2b19Du8IsS9jJtyviedVo9h7I1xKmeO2zDCxAwgG.vXJOrn5O','https://source.unsplash.com/featured/?face',1,'96873572','zzzzz','SGP','blk 267 toh guan road',500267,0,'2020-07-08 23:33:31'),(3,'jun@hua.com','$2a$12$cDULwNtciWfwmB.zy8Op0OU14aPk20QMYFI14gzsm4ca4z/yFWxnG','https://source.unsplash.com/featured/?face',1,'96873572','jun hua','SGP','blk 267 toh guan road',400267,0,'2020-07-09 16:41:32'),(4,'admin@zElectronics.com.sg','$2a$12$oLPJcmV1vvNE6xzPHyIjOecyQjRsZg0JSgMW9eIyoOLBIYMt.2Y0W','https://source.unsplash.com/featured/?face',2,'12345789','admin','SGP','blk 267 toh guan road',650267,0,'2020-07-11 20:51:57'),(8,'zane0703@hotmail.com','$2a$10$0fj5hAZ8Lx.F7lWYWjPU1O83AGoEYbnSfUvkvLncYfTbApPeQE3Jq','https://source.unsplash.com/featured/?face',1,'98765432','zane eng','SGP','blk 267 toh guan road',600267,53,'2020-07-20 19:42:14'),(12,'jun@huc.com','$12$J7B1VHe.cRjABeguVHgghebZWGVL1264cZfNf4vraUxbdEHSYVZZq','https://source.unsplash.com/featured/?face',1,'96873572','zane eng','SGP','blk 267 toh guan road',605267,0,'2020-07-31 11:35:42'),(13,'zzz@hotmail.com','$2a$12$5Kcnr1R6zKqHnxDL74YzPeaDVIVzSsXdyOnD9WTFz1kvEOZz9tTW2','https://source.unsplash.com/featured/?face',1,'12345789','jun hua','SGP','blk 267 toh guan road',604267,0,'2020-07-31 11:35:42'),(14,'jun@haa.com','$12$J7B1VHe.cRjABeguVHgghebZWGVL1264cZfNf4vraUxbdEHSYVZZq','https://source.unsplash.com/featured/?face',1,'96873572','jun hua','SGP','blk 267 toh guan road',607267,0,'2020-07-31 11:37:51'),(15,'jun@ichat.sp.edu.sg','$12$J7B1VHe.cRjABeguVHgghebZWGVL1264cZfNf4vraUxbdEHSYVZZq','https://source.unsplash.com/featured/?face',1,'96873572','jun hua','SLE','nublk 267 toh guan roadll',601267,0,'2020-07-31 11:37:51'),(19,'zoe130994@gmail.com','$2a$12$quspic/ktn.ZfFLef48CCuYCoLqqDcE2G2Ocd2B7HEkGpvIvv8mp2','https://source.unsplash.com/featured/?face',1,'12345678','zane','SGP','blk 267 toh guan road',660267,0,'2020-08-03 00:50:31'),(21,'zaneang.19@ichat.sp.edu.sg','$2a$12$AkZaCIGKBN.be5HU4iEuueELaMrQwfrzMojjHlZ.xcgfuNXrnAE/y','https://source.unsplash.com/featured/?face',1,'96962203','zaneang.19','MYS','blk 267 jurong east',600267,0,'2020-08-06 16:52:57'),(22,'zane@ang.com','$2a$12$RkJfkREwBkLZ3FgV9XUNZeMzC5nEU.Xc.FRKcMbM7vlsY0xKx2rYu','https://source.unsplash.com/featured/?face',1,'96968803','zane ang','BGR','blk267',123456,0,'2020-08-06 16:56:29');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'jad'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-08-16 13:13:57
