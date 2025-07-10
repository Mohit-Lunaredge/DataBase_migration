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
-- Table structure for table `masterthesis`
--

DROP TABLE IF EXISTS `masterthesis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `masterthesis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `thesis_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `guided` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `degree` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_year` date DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `masterthesis`
--

LOCK TABLES `masterthesis` WRITE;
/*!40000 ALTER TABLE `masterthesis` DISABLE KEYS */;
INSERT INTO `masterthesis` VALUES (1,'Extension of PMIPV6 Model for NEMO-Smart in VANET','Swatantra Porwal','Completed','Mtech','2014-07-01','Swatantra Porwal, \"Extension of PMIPV6 Model for NEMO-Smart in VANET\", Since July 2014 : Completed'),(2,'A Robust Client Side Defense for Reflected Cross-Site Scripting','Bhawana Mewara','Completed','Mtech','2013-07-01','Bhawana Mewara, \"A Robust Client Side Defense for Reflected Cross-Site Scripting\", Since July 2013 : Completed'),(3,'Detection and Robust Solustion against Phising Attacks','Sheetal Bairwa','Completed','Mtech','2013-07-01','Sheetal Bairwa, \"Detection and Robust Solustion against Phising Attacks\", Since July 2013 : Completed'),(4,'Smartphone Malware Analysis through Text Mining ','Mohit Sharma (Student of MANIT, Bhopal)','Completed','Mtech','2014-07-01','Mohit Sharma (Student of MANIT, Bhopal), \"Smartphone Malware Analysis through Text Mining \", Since July 2014 : Completed'),(5,'Android Malware Analysis','Taresh Mishra','Ongoing','Mtech','2014-07-01','Taresh Mishra, \"Android Malware Analysis\", Since July 2014 : Ongoing'),(6,'Intrusion Detection System','Surendra Kumar','Ongoing','Mtech','2014-07-01','Surendra Kumar, \"Intrusion Detection System\", Since July 2014 : Ongoing'),(7,'Internet of Things','Bhawana Sharma','Ongoing','Mtech','2015-07-01','Bhawana Sharma, \"Internet of Things\", Since July 2015 : Ongoing'),(8,'Enhance Matching in Multi Dimensional Reconstruction using Stereo Image Sequences','S N Tazi','Completed','Mtech','2017-07-01','S N Tazi, \"Enhance Matching in Multi Dimensional Reconstruction using Stereo Image Sequences\", Since July 2017 : Completed'),(9,'Time series data prediction using fuzzy data dredging','Anshuman Singh','Completed','Mtech','2015-07-01','Anshuman Singh, \"Time series data prediction using fuzzy data dredging\", Since July 2015 : Completed'),(10,'Frequent Pattern Analysis For Weblog File To Improve Efficiency Of Web Usage Mining','Hemwati Kumawat','Completed','Mtech','2012-07-01','Hemwati Kumawat, \"Frequent Pattern Analysis For Weblog File To Improve Efficiency Of Web Usage Mining\", Since July 2012 : Completed'),(11,'Best Fit Multi Value Bin Packaging Approach for VM Allocation in Energy Efficient Cloud Computing','Rakesh Singh','Completed','Mtech','2008-07-01','Rakesh Singh, \"Best Fit Multi Value Bin Packaging Approach for VM Allocation in Energy Efficient Cloud Computing\", Since July 2008 : Completed'),(12,'Role of QR (Quick Response) Code in Digital Watermarking','Rakesh Singh','Completed','Mtech','2009-07-01','Rakesh Singh, \"Role of QR (Quick Response) Code in Digital Watermarking\", Since July 2009 : Completed'),(13,'Efficient Data Center Selection Policy for Service Proximity Service Broker in Cloud Analyst Round-Robin Data Center Selection in Single Region','Rakesh Singh','Completed','Mtech','2010-07-01','Rakesh Singh, \"Efficient Data Center Selection Policy for Service Proximity Service Broker in Cloud Analyst Round-Robin Data Center Selection in Single Region\", Since July 2010 : Completed'),(14,'Empirical study to measure the impact of HCI Technologies on Environment and design future frame work model of HCI technology','Rakesh Singh','Completed','Mtech','2011-07-01','Rakesh Singh, \"Empirical study to measure the impact of HCI Technologies on Environment and design future frame work model of HCI technology\", Since July 2011 : Completed'),(15,' DESIGN Of Band Notch Antennas with Small and Compact Structure for UWB Application to Sort Frequency Interfernce Problem','Deepak Kumar','Completed','Mtech','2016-04-01','Deepak Kumar, \" DESIGN Of Band Notch Antennas with Small and Compact Structure for UWB Application to Sort Frequency Interfernce Problem\", Since April 2016 : Completed'),(16,'UWB Antenna with Dual Band Notch for Enhancing the performance of wireless communication','Pooja Meena','Completed','Mtech','2017-04-01','Pooja Meena, \"UWB Antenna with Dual Band Notch for Enhancing the performance of wireless communication\", Since April 2017 : Completed'),(17,'A Hybrid Apprach for ECHO Cancellation Telephone System with Estimation of Noise','Praveen Jaiman','Completed','Mtech','2018-05-01','Praveen Jaiman, \"A Hybrid Apprach for ECHO Cancellation Telephone System with Estimation of Noise\", Since May 2018 : Completed'),(18,'Parametric Investigations of Thermal Influence Zone of Earth Air Tunnel Heat Exchanger: A Transient CFD Analysis','Bihari Lal','Completed','Mtech','2014-06-01','Bihari Lal, \"Parametric Investigations of Thermal Influence Zone of Earth Air Tunnel Heat Exchanger: A Transient CFD Analysis\", Since June 2014 : Completed'),(19,'CFD Based Performance Analysis of Earth Air Tunnel Heat Exchanger with Regeneration of Soil','Kapil Paliwal','Completed','Mtech','2015-06-01','Kapil Paliwal, \"CFD Based Performance Analysis of Earth Air Tunnel Heat Exchanger with Regeneration of Soil\", Since June 2015 : Completed'),(20,'Experimental Investigations of Effect of Water Impregnation on Thermal Performance of Earth Air Tunnel Heat Exchanger','Dharmendra Kumar Saini','Completed','Mtech','2016-06-01','Dharmendra Kumar Saini, \"Experimental Investigations of Effect of Water Impregnation on Thermal Performance of Earth Air Tunnel Heat Exchanger\", Since June 2016 : Completed');
/*!40000 ALTER TABLE `masterthesis` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-10 17:16:47
