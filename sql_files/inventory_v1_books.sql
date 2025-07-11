-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: inventory_v1
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL,
  `teacher_id` int DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `publisher` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `year` date DEFAULT NULL,
  `writers` text COLLATE utf8mb4_general_ci,
  `description` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,2,'Telecommunications Engineering and Fundamentals','RBD Publications','2008-07-01','Dr. S. C. Jain, Vinesh Jain, Jyoti Tilokchandani,Rakesh Rathi','\"Telecommunications Engineering and Fundamentals\", Dr. S. C. Jain, Vinesh Jain, Jyoti Tilokchandani,Rakesh Rathi, Published By: RBD Publications, 2008'),(2,5,'Telecommunications Engineering and Fundamentals','RBD Publications','2008-07-01','Dr. S. C. Jain, Vinesh Jain, Jyoti Tilokchandani,Rakesh Rathi','\"Telecommunications Engineering and Fundamentals\", Dr. S. C. Jain, Vinesh Jain, Jyoti Tilokchandani,Rakesh Rathi, Published By: RBD Publications, 2008'),(3,5,'Concept of Information Technology, Class X','RBSC','2008-07-01','Atul Chaudhary, Vinesh Jain, Dinesh Khunteta, Anil Dubey','\"Concept of Information Technology, Class X\", Atul Chaudhary, Vinesh Jain, Dinesh Khunteta, Anil Dubey, Published By: RBSC, 2008'),(4,5,'Computer System Programming','RBD Publications','2008-07-01','Dr. S. C. Jain, Rakesh Rathi, Akhil Pandey,Vinesh Jain','\"Computer System Programming\", Dr. S. C. Jain, Rakesh Rathi, Akhil Pandey,Vinesh Jain, Published By: RBD Publications, 2008'),(5,4,'Computer System and Programming','RBD Publications','2008-09-01','Jain, Rathi, Pandey, Jain','\"Computer System and Programming\", Jain, Rathi, Pandey, Jain, Published By: RBD Publications, 2008'),(6,4,'Telecommunication Fundamentals','RBD Publications','2008-09-01','Jain, Jain, Tilokchandani, Rathi','\"Telecommunication Fundamentals\", Jain, Jain, Tilokchandani, Rathi, Published By: RBD Publications, 2008'),(7,4,'Data Structures &Algorithms','RBD Publications','2008-09-01','Jain , Goyal, Rathi , Gupta','\"Data Structures &Algorithms\", Jain , Goyal, Rathi , Gupta, Published By: RBD Publications, 2008'),(8,27,'Engineering Thermodynamics','CBC, Jaipur','2007-01-01','A.D.Sharma, Alok Khatri, S. Singh','\"Engineering Thermodynamics\", A.D.Sharma, Alok Khatri, S. Singh, Published By: CBC, Jaipur, 2007'),(9,27,'Implementation of Contract Farming & Value Stream Mapping: A Case Study','Lambert Academic','2018-01-01','Sharma, D., Khatri, A. and Mathur Y. B.','\"Implementation of Contract Farming & Value Stream Mapping: A Case Study\", Sharma, D., Khatri, A. and Mathur Y. B., Published By: Lambert Academic, 2018'),(10,28,'Earth Air Tunnel Heat Exchangers: Performance, Analysis and Design','LAP Lambert Academic','2009-08-01','Rohit Misra','\"Earth Air Tunnel Heat Exchangers: Performance, Analysis and Design\", Rohit Misra, Published By: LAP Lambert Academic, 2009'),(11,28,'Solar Air Heater: CFD Analysis of Aero-foil Shaped Roughness',' LAP Lambert Academic','2014-01-01','Jitendra Yadav, Rohit Misra','\"Solar Air Heater: CFD Analysis of Aero-foil Shaped Roughness\", Jitendra Yadav, Rohit Misra, Published By:  LAP Lambert Academic, 2014');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-10 18:14:52
