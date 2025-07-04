-- phpMyAdmin SQL Dump
-- version 4.4.12
-- http://www.phpmyadmin.net
--
-- Host: localhost:3309
-- Generation Time: Jul 02, 2025 at 10:45 AM
-- Server version: 5.5.44
-- PHP Version: 5.6.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `facultydb`
--

-- --------------------------------------------------------

--
-- Table structure for table `adm_role`
--

CREATE TABLE IF NOT EXISTS `adm_role` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `role_name` varchar(120) NOT NULL,
  `role_type` text NOT NULL,
  `start_year` date NOT NULL,
  `end_year` date DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `adm_role`
--

INSERT INTO `adm_role` (`id`, `teacher_id`, `role_name`, `role_type`, `start_year`, `end_year`) VALUES
(1, 2, 'Department First Year ', 'Coordinator', '2017-07-01', '2018-07-01'),
(2, 2, 'Institute TEQIP-II Committee', 'Member', '2016-11-01', '2017-05-01'),
(3, 2, 'Women Cell', 'Member', '2015-11-01', NULL),
(4, 3, 'Head of Computer Engineering & Information Technology department', 'Head of Department', '2002-09-01', '2006-12-01'),
(5, 3, 'Convener for committee to look into women’s problem at work place at Engineering College, Ajmer', 'Convener for committee', '2005-06-01', '2007-06-01'),
(6, 3, 'Chief Coordinator- RTU Student Grievance Cell', 'Chief Coordinator', '2013-05-01', '2014-11-01'),
(7, 5, 'Examination', 'Coordinator', '2010-07-01', NULL),
(8, 5, 'Training and Placement', 'Coordinator', '2012-07-01', NULL),
(9, 4, 'Reader & Head Arya College', 'Reader & Head', '2006-07-01', '2006-02-01'),
(10, 4, 'Chief Coordinator of internet and networking committee', 'Chief Coordinator', '2006-06-01', NULL),
(11, 4, 'M Tech C.E. Coordinator', 'Coordinator', '2007-07-01', '2014-08-01'),
(12, 6, 'ECA - Website Development and Maintenance', 'Nodal Officer', '2020-07-01', NULL),
(13, 6, 'Election Duty', 'Member', '2013-07-01', NULL),
(14, 6, 'Internet And Networking Commitee', 'Member ', '2017-07-01', NULL),
(15, 10, 'Estate Adviser (Civil)', 'Estate Adviser', '2009-06-01', '2016-01-01'),
(16, 10, 'Nodal Officer (Civil)', 'Nodal Officer', '2013-01-01', '2017-07-01'),
(17, 10, 'Construction and Maintenances of College buildings', 'I/C Estate', '2017-10-01', NULL),
(18, 22, 'Hindustan Cables Ltd.', 'Assistant Manager (R&D)', '1998-12-01', '2021-09-01'),
(19, 22, 'AICTE Coordinator/ Convener', 'Coordinator', '2006-03-01', '2021-11-01'),
(20, 21, 'Academic affairs in GEC, Jhalwar', 'Faculty Incharge ', '2007-06-01', '2008-06-01'),
(21, 21, 'Examination Co-ordinator of GEC, Ajmer', 'Examination Co-ordinator', '2009-01-01', '2014-02-01'),
(22, 21, '1st Year Co-ordinator of the Department.', 'Co-ordinator', '2011-07-01', NULL),
(23, 27, 'Government Engineering College Ajmer', 'Examination Coordinator', '2016-07-01', NULL),
(24, 31, 'Chief Proctor - Looking after all the student related activities, admissions, maintaining discipline etc', 'Chief Proctor', '2009-06-01', '2011-01-01'),
(25, 31, 'Stores officer - Procurement of variety of items ranging from furniture, lab equipments, stationary, printing items etc', 'Stores officer', '2015-10-01', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `award`
--

CREATE TABLE IF NOT EXISTS `award` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `award_name` text NOT NULL,
  `award_year` date NOT NULL,
  `details` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `award`
--

INSERT INTO `award` (`id`, `teacher_id`, `award_name`, `award_year`, `details`) VALUES
(1, 2, 'AICTE Visvesvaraya Best Teacher', '2021-07-01', '');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `publisher` text NOT NULL,
  `year` date NOT NULL,
  `writers` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `teacher_id`, `name`, `publisher`, `year`, `writers`) VALUES
(1, 2, 'Telecommunications Engineering and Fundamentals', 'RBD Publications', '2008-07-01', 'Dr. S. C. Jain, Vinesh Jain, Jyoti Tilokchandani,Rakesh Rathi'),
(2, 5, 'Telecommunications Engineering and Fundamentals', 'RBD Publications', '2008-07-01', 'Dr. S. C. Jain, Vinesh Jain, Jyoti Tilokchandani,Rakesh Rathi'),
(3, 5, 'Concept of Information Technology, Class X', 'RBSC', '2008-07-01', 'Atul Chaudhary, Vinesh Jain, Dinesh Khunteta, Anil Dubey'),
(4, 5, 'Computer System Programming', 'RBD Publications', '2008-07-01', 'Dr. S. C. Jain, Rakesh Rathi, Akhil Pandey,Vinesh Jain'),
(5, 4, 'Computer System and Programming', 'RBD Publications', '2008-09-01', 'Jain, Rathi, Pandey, Jain'),
(6, 4, 'Telecommunication Fundamentals', 'RBD Publications', '2008-09-01', 'Jain, Jain, Tilokchandani, Rathi'),
(7, 4, 'Data Structures &Algorithms', 'RBD Publications', '2008-09-01', 'Jain , Goyal, Rathi , Gupta'),
(8, 27, 'Engineering Thermodynamics', 'CBC, Jaipur', '2007-01-01', 'A.D.Sharma, Alok Khatri, S. Singh'),
(9, 27, 'Implementation of Contract Farming & Value Stream Mapping: A Case Study', 'Lambert Academic', '2018-01-01', 'Sharma, D., Khatri, A. and Mathur Y. B.'),
(10, 28, 'Earth Air Tunnel Heat Exchangers: Performance, Analysis and Design', 'LAP Lambert Academic', '2009-08-01', 'Rohit Misra'),
(11, 28, 'Solar Air Heater: CFD Analysis of Aero-foil Shaped Roughness', ' LAP Lambert Academic', '2014-01-01', 'Jitendra Yadav, Rohit Misra');

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE IF NOT EXISTS `certificates` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `certificate_name` text NOT NULL,
  `certificate_year` date NOT NULL,
  `details` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `certificates`
--

INSERT INTO `certificates` (`id`, `teacher_id`, `certificate_name`, `certificate_year`, `details`) VALUES
(1, 2, 'Development of Ajmer Police Traffic App', '2017-03-01', 'Recognization by Dr. Nitin Deep Blaggan, SP Ajmer'),
(2, 2, 'Representation of College for student projects', '2017-07-01', 'At Festival of Education - 2017 organized by Govt. of Rajasthan at Jaipur'),
(3, 3, 'Organized First National Conference On Emerging Trends And Applications In Computer Engineering', '2007-07-01', ''),
(4, 5, 'Member, Board of Studies, Rajasthan Technical University, Kota', '2016-07-01', ''),
(5, 5, 'Cisco Certified Network Administrator', '2017-07-01', 'Cisco Certified Network Administrator'),
(6, 4, 'CCAI (CISCO certified academy instructor)', '2002-07-01', ''),
(7, 6, 'Internet Of Things Workshop', '2018-07-01', 'Cepta Infotech Pvt Ltd Sponsored One Day Workshop'),
(8, 6, 'Certified Virtual Classroom Teacher', '2020-07-01', ''),
(9, 6, 'Matlab & Simulink Workshop', '2013-07-01', 'High Standard Of Excellence In National Workshop'),
(10, 22, 'Honoured by Merit Appreciation Certificate by Lion’s Club, Ajmer on Teacher’s Day.', '2007-03-01', ''),
(11, 22, 'Best Project Award winner for project work in B. Tech Examination', '1991-04-01', ''),
(12, 28, 'Member of Editorial Board of SCIREA Journal of Energy', '2012-03-01', '');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE IF NOT EXISTS `department` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`id`, `name`) VALUES
(1, 'EC Ajmer'),
(2, 'Computer Science and Engineering'),
(3, 'Civil Engineering'),
(4, 'Mechanical Engineering'),
(5, 'Electrical Engineering'),
(6, 'Electronics and Communication Engineering'),
(7, 'Electronic Instrumentation And Control Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `education`
--

CREATE TABLE IF NOT EXISTS `education` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `start_year` int(11) NOT NULL,
  `end_year` int(11) DEFAULT NULL,
  `edu_name` text NOT NULL,
  `edu_place` text NOT NULL,
  `specialization` text NOT NULL,
  `research_advisor` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `education`
--

INSERT INTO `education` (`id`, `teacher_id`, `start_year`, `end_year`, `edu_name`, `edu_place`, `specialization`, `research_advisor`) VALUES
(1, 2, 2000, 2004, ' B.Tech.(Computer Engineering)', 'Mody University, Lakshmangarh', '', ''),
(2, 2, 2011, 2013, 'M.Tech.(Computer Engineering)', 'Indian Institute of Technology Bombay', 'Implementation of Side Channel Attacks on AES in Modern Processors', 'Prof. Bernard L. Menezes'),
(3, 2, 2015, 2020, 'PhD (Computer Engineering)', 'Malviya National Institute of Technology, Jaipur', 'Android Malware Analysis', 'Prof. Manoj Singh Gaur & Dr. Meenakshi Tripathi'),
(4, 3, 1991, 1995, 'BE (Computer Sc & Engg)', 'MBM Engineering College Jodhpur', '', ''),
(5, 3, 2006, 2009, 'ME (Computer Science& Engg)', 'NITTTR, punjab University Chandigarh', 'Computer Science & Engg', 'Dr Maitreyee Dutta'),
(6, 3, 2014, 2017, 'PhD(Computer Science & Engg)', 'Bhagwant University Ajmer', 'Software Engineering (human Computer Interface, Brain Computer Interface)', 'Dr Neeraj Bhargava'),
(7, 5, 2000, 2004, 'B.E(Computer Engineering)', 'Govt. Engineering College, Ajmer', '', ''),
(8, 5, 2010, 2012, 'M.Tech', 'Malaviya National Institute of Technology, Jaipur', 'Computer Engineering', 'Prof. M.S Gaur'),
(9, 5, 2015, NULL, 'PhD', 'Malaviya National Institute of Technology, Jaipur', 'Computer Engineering', 'Dr. Arka Prokash Mazumdar and Prof. Mahesh Chandra Govil'),
(10, 6, 1998, 2001, 'Diploma(Computer Science And Engineering)', 'Vidhya Bhavan Polytechnic College Udaipur', '', ''),
(11, 6, 2001, 2004, 'Bachlore Of Engineering(Computer Engineering)', 'Jaipur Engineering College And Research Center, Jaipur', '', ''),
(12, 6, 2011, 2021, 'M.tech.', 'Govt. Engineering College, Ajmer', 'Computer Science', 'Dr. Neetu Sharma'),
(13, 10, 2000, 2004, ' B.E.(Civil Engineering)', 'M.B.M. Engineering College, J N V U, Jodhpur', '', ''),
(14, 10, 2006, 2008, 'M.E.', 'M.B.M. Engineering College, J N V U, Jodhpur', 'Civil Engineering', 'Prof. Ravi Saxena'),
(15, 10, 2019, NULL, ' PhD', 'National Institute of Technology, Kurukshetra', 'Civil Engineering', 'Prof. Arun Goel (NITKkr) and Prof. Mahender Choudhary (MNIT, Jaipur)'),
(16, 9, 2001, 2004, 'B.E(Civil Engineering)', 'Rajasthan University', '', ''),
(17, 9, 2005, 2007, 'M.E.', 'M.B.M. Engineering college, Jodhpur', 'Geotechnical Engineering', 'Dr. D. G. Purohit & Dr. N. K. Ametha'),
(18, 9, 2010, NULL, 'PhD', 'Rajasthan Technical University', 'Civil Engineering', 'Dr. A. K. Dwivedi'),
(19, 13, 1996, 2000, 'B.E(Electrical Engineering)', 'CTAE, Udaipur', '', ''),
(20, 13, 2001, 2003, 'M.Tech', 'MNIT, Jaipur', 'Power System', ''),
(21, 13, 2011, 2015, 'PhD', 'RTU, Kota', 'Power System', ''),
(22, 14, 1988, 1993, 'B. E.(Hons.)', 'MNIT Jaipur', 'Electrical Engg.', ''),
(23, 14, 2002, 2004, ' M.Tech (Hons.)', 'MNIT Jaipur', 'Electronics and Comm. Engg.', 'Dr. V. Sahula'),
(24, 14, 2010, 2016, 'PhD', 'Maulana National Institute of Technology', 'Elecctronics and Comm. Engg.', 'Dr. M.K. Gupta (MANIT, Bhopal) and Dr. V. Singh (IIT-Bombay)'),
(25, 16, 1997, 2001, ' B. E (Electronics and Communication Engineering)', 'Amravati Unniversity', '', ''),
(26, 16, 2008, 2010, 'M.Tech.', 'Malaviya National Institute of Technology, Jaipur', 'Digital Communication', 'Prof. M. M. Sharma'),
(27, 16, 2018, NULL, 'PhD', 'Rajasthan Technical University,Kota', 'Printed UWB Antennas', 'Prof. M. M. Sharma and Dr. J. K. Deegwal'),
(28, 19, 1998, 2002, 'B.E. (Electronics Instrumentation and Control Engineering)', 'Govt. Engineering College Kota', '', ''),
(29, 19, 2006, 2011, 'M.Tech', 'IET Alwar', 'Electrical Engineering', 'Dr.(Prof.) G. K. Joshi'),
(30, 22, 1988, 1991, ' B.Tech', 'Allahabad University', 'Electronics And Telecommunication Engineering', 'Prof. H.k.dixit'),
(31, 22, 2002, 2005, 'M.Tech', 'Malaviya National Institute of Technology, Jaipur', 'Electronics And Communication Engineering', 'Prof. Sandeep Sancheti'),
(32, 22, 2010, 2016, 'PhD', 'Utter Pradesh Technical University Lucknow', 'Optical Computing', 'Prof. H.k.dixit'),
(33, 21, 2000, 2004, ' B.E', 'Gangamai College of Engineering , Dhule, (M.S.)', 'Electronics and Telecommunication', 'Prof. Bagul'),
(34, 21, 2014, 2015, 'M.Tech', 'Bhagwant University, Ajmer', 'Digital Communication', 'Sh. Sanjay Gurjar'),
(35, 21, 2015, NULL, 'PhD', 'Bhagwant University, Ajmer', 'Antenna Design', 'Dr. Uma Shanker Modani'),
(36, 27, 1994, 1998, 'B.Tech.', 'National Institute of Technology, Jamshedpur', '', ''),
(37, 27, 2000, 2003, 'M.Tech', 'Malaviya National Institute of Technology, Jaipur', 'Ergonomic Design of Spectacles', 'Dr. A. Bhardwaj'),
(38, 27, 2011, 2018, 'PhD', 'National Institute of Technology, Kurukshetra', 'Managing Agility in Indian Manufacturing Industries', 'Dr. Dixit Garg, Dr. G.S.Dangayach'),
(39, 28, 1992, 1997, 'B.E(Mechanical Engineering)', 'G.M. College Of Engineering, Dhule, Maharashtra', '', ''),
(40, 28, 1997, 2003, 'Master Of Engineering', 'M.B.M. Engineering College, Jodhpur, Rajasthan', 'Thermal Engineering', 'Dr. Rajendra Karwa'),
(41, 28, 2008, 2013, 'PhD', 'Malaviya National Institute of Technology, Jaipur', 'Energy', 'Dr. G. D. Agarwal And Dr. Jyotirmay Mathur'),
(42, 30, 1982, 1987, 'B.E(Mechanical Engineering)', 'M.B.M.Engineering College ,Jodhpur ( Raj.)', '', ''),
(43, 30, 1990, 1992, ' M.Tech.( Production Engg.)', 'TRTC Delhi ( Presently Delhi Institute of Tool Engineering)', 'Tool Engineering', ''),
(44, 31, 2012, 2015, 'PhD', 'Indian Institute of Technology Delhi', 'Solar Thermal Power', 'Prof. Subhash C. Mullick and Prof. Tara C. Kandpal');

-- --------------------------------------------------------

--
-- Table structure for table `employment`
--

CREATE TABLE IF NOT EXISTS `employment` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `start_year` date NOT NULL,
  `end_year` date DEFAULT NULL,
  `emp_place` text NOT NULL,
  `emp_des` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employment`
--

INSERT INTO `employment` (`id`, `teacher_id`, `start_year`, `end_year`, `emp_place`, `emp_des`) VALUES
(1, 2, '2005-09-01', '2006-03-01', 'DRDO (Defence Lab, Jodhpur)', 'Research Fellow'),
(2, 2, '2006-03-01', NULL, 'Govt. Engineering College, Ajmer', 'Asst. Professor'),
(3, 3, '1997-01-01', '1997-12-01', 'Army Institute Of Technology ,pune', 'Lecturer'),
(4, 3, '1998-02-01', '1999-02-01', 'SVITS, INDORE', 'Lecturer'),
(5, 3, '1999-06-01', '2013-06-01', 'Govt Engineering College Ajmer', 'Assistant Professor'),
(6, 3, '2013-07-01', NULL, 'Govt Engineering College Ajmer', 'Associate Professor'),
(7, 5, '2005-07-01', '2006-07-01', 'Govt. Engineering College, Ajmer', 'Guest Lecturer'),
(8, 5, '2006-07-01', NULL, 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(9, 4, '2000-01-01', '2000-06-01', 'Sigma computers', 'System Engineer'),
(10, 4, '2000-07-01', '2002-06-01', 'Maharishi Arvind Institute of Engineering & Technology', 'Assistant Professor'),
(11, 4, '2002-07-01', '2006-02-01', 'Arya College of Engineering & Information Technology', 'Reader & Head of Department'),
(12, 4, '2006-03-01', NULL, 'Government Engineering College Ajmer', 'Assistant Professor'),
(13, 6, '2006-07-01', '2006-09-01', 'CMS Computer Ltd ', 'Associate Trainee Engineer'),
(14, 6, '2006-10-01', NULL, 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(15, 10, '2001-08-01', '2002-07-01', 'NGO, Society to Uplift Rural Economy, Barmer', 'Principal Investigator'),
(16, 10, '2003-08-01', '2004-07-01', 'Reliance Engineering Associated Pvt. Ltd. Jaipur', 'Site Engineer'),
(17, 10, '2004-08-01', '2006-05-01', 'M.B.M. Engineering College, J N V U, Jodhpur', 'Guest faculty'),
(18, 10, '2006-11-01', NULL, 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(19, 16, '2006-03-01', '2008-02-01', 'Government Engineering College Ajmer', 'Lecturer'),
(20, 16, '2008-03-01', NULL, 'Government Engineering College Ajmer', 'Associate Professor'),
(21, 17, '2001-04-01', '2006-03-01', 'Mody College of Engineering and Technology, Lakshmangarh, Sikar, Rajasthan', 'Assistant Professor'),
(22, 17, '2006-03-01', '2008-03-01', 'Government Engineering College, Ajmer, Rajasthan', 'Assistant Professor'),
(23, 17, '2008-03-01', NULL, 'Government Engineering College, Ajmer, Rajasthan', 'Associate Professor'),
(24, 19, '2003-01-01', '2006-01-01', 'Instrumentation Limited Kota', 'Engineer'),
(25, 19, '2007-02-01', NULL, 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(26, 22, '1993-03-01', '1994-04-01', 'ITI Mankapur', 'Apprenticeship Trainee'),
(27, 22, '1994-06-01', '1998-12-01', 'Hindustan Cables Limited', 'Project Engineer (R&D)'),
(28, 22, '1998-12-01', '2001-09-01', 'Hindustan Cables Limited', 'Assistant Manager (R&D)'),
(29, 22, '2005-07-01', '2006-03-01', 'Ajmer Institute of Technology, Ajmer', 'Reader, Officer Incharge Academics'),
(30, 22, '2006-03-01', '2007-08-01', 'Govt. Engineering College Ajmer', 'Assistant Professor (ECE)'),
(31, 22, '2007-08-01', NULL, 'Govt. Engineering College Ajmer', 'Associate Professor'),
(32, 21, '2000-06-01', '2005-06-01', 'Govt. Engineering College Ajmer', 'Guest Lecturer'),
(33, 21, '2006-06-01', NULL, 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(34, 27, '2006-07-01', NULL, 'Govt. Engineering College, Ajmer', 'Associate Professor'),
(35, 28, '1999-06-01', '2004-06-01', 'Govt. Engineering College, Ajmer', 'Lecturer'),
(36, 28, '2004-06-01', '2007-02-01', 'Govt. Engineering College, Ajmer', 'Lecturer(Senior Scale)'),
(37, 28, '2007-02-01', NULL, 'Govt. Engineering College, Ajmer', 'Associate Professor'),
(38, 30, '1998-07-01', '1990-07-01', 'J.K. Tyre, Kankroli, Raj.', 'Trainee Engineer'),
(39, 30, '1992-07-01', '2002-07-01', 'Bajaj Auto Limited , Aurangabad, Maharashtra', 'Section Manager'),
(40, 30, '2002-07-01', '2005-07-01', 'Maharashtra Institute of Technology,Aurangabad.', 'Lecturer'),
(41, 30, '2006-07-01', '2008-07-01', 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(42, 30, '2008-07-01', NULL, 'Govt. Engineering College, Ajmer', 'Associate Professor'),
(43, 31, '1999-06-01', '2013-06-01', 'Govt. Engineering College, Ajmer', 'Assistant Professor'),
(44, 31, '2013-06-01', NULL, 'Govt. Engineering College, Ajmer', 'Associate Professor');

-- --------------------------------------------------------

--
-- Table structure for table `journal_publications`
--

CREATE TABLE IF NOT EXISTS `journal_publications` (
  `id` int(11) NOT NULL,
  `other_teacher` text NOT NULL,
  `publication_topic` text NOT NULL,
  `publication_details` text NOT NULL,
  `year` date NOT NULL,
  `status` varchar(30) NOT NULL,
  `pubtype` varchar(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `journal_publications`
--

INSERT INTO `journal_publications` (`id`, `other_teacher`, `publication_topic`, `publication_details`, `year`, `status`, `pubtype`) VALUES
(1, 'Tripathi, Meenakshi, Jyoti Gajrani, and Vinesh Kumar Jain', 'Mobile Security: Attacks and Prevention- Security in Mobile Communication', 'Routing Protocols and Architectural Solutions for Optimal Wireless Networks and Security. IGI Global, 2017. 43-59.', '2017-07-01', 'International', 'Journal'),
(2, 'Sheetal Bairwa, Jyoti Gajrani, Vinesh Jain', 'Augmentation of the Classification Performance of Least Square support vector machine using Simple Particle Swarm Optimization for Phising Dataset', 'In "IJETMAS Special Issue" Nov 2015, ISSN 2349-4476', '2015-11-01', 'International', 'Journal'),
(3, 'Santosh Kumar Singh, Vinesh Jain, Rakesh Rathi, Jyoti Gajrani', 'Enhancement of Salt and Pepper Noise Image using Sharpness Indexed Filtering', 'In "International Journal of Engineering and Technical Research (IJETR), ISSN: 2321-0869, Volume-3, Issue-5", May 2015', '2015-05-01', 'International', 'Journal'),
(4, 'Hari Prabhat Gupta, Rakesh Rathi, Jyoti Tilokchandani, Prakriti Trivedi', 'Semi Structured Data', 'In Annual National Convent Organised By: CSI-2006, in 2006.', '2006-07-01', 'National', 'Journal'),
(5, 'Jyoti Gajrani, Vijay Laxmi, Meenakshi Tripathi, M.S. Gaur, Daya Ram Sharma, Akka Zemmari, Mohamed Mosbah, and Mauro Conti', 'Unraveling Reflection Induced Sensitive Leaks in Android Apps', 'In Springer LNCS 12th International Conference on Risks and Security of Internet and Systems, (CRISIS 2017) at 19st - 21st September 2017, Dinard, France\r\n', '2017-09-01', 'International', 'Conference'),
(6, 'Bhawna Mewara, Sheetal Bairwa, Jyoti Gajrani, Vinesh Jain', 'Enhanced Browser Defense for Reflected Cross-Site Scripting', 'in "IEEE 3rd International Conference on Reliability, Infocom Technologies and Optimization (ICRITO 2014) " at Amity University, Noida (8-10 Oct 2014)', '2014-10-01', 'International', 'Conference'),
(7, 'Yash Pal Singh, Rakesh Rathi, Jyoti Gajrani, Vinesh Jain', 'Analysis of Searching Techniques And Design of Improved Search Algorithm for Unconstructured Peer-to-Peer Networks', 'In “IJCNS, Volume 2,No.4, ISSN 2076-2739”', '2010-04-01', 'International', 'Journal'),
(8, 'Yash Pal, Rakesh Rathi, Jyoti Gajrani, and Vinesh Jain', 'Two levels TTL for unstructured P2P network using adaptive probabilistic search.', 'International Journal of Scientific & Engineering Research 3, no. 1 (2012): 1-4.', '2012-07-01', 'International', 'Journal'),
(9, '', 'AI Based Character Recognition International Journal of AI and Knowledge Discovery', 'Volume 1,Issue 2, April-2011 e-ISSN: 2231 0312, print ISSN:2231 2021', '2011-04-01', 'International', 'Journal'),
(10, '', 'Analysis of Searching Techniques in P2P unstructured Networks', 'In Recent development in Engineering Mathematics and Information Technology at Poornima College, Jaipur', '2009-12-01', 'National', 'Conference'),
(11, '', 'Empirical Study to Analyse Security on the Basis of Boundary Edges', '', '2012-07-01', 'National', 'Journal'),
(12, '', 'An Improved Fitness Based Differential Evolution Algorithm', '', '2016-07-01', 'National', 'Conference'),
(13, 'Singh G., Goel A. & Choudhary M.', 'An inventory of methods and models for domestic water demand forecasting – a review', 'Indian Water Resources Society, 35(3), 34–45.', '2015-07-01', 'National', 'Journal'),
(14, 'Dr. Ganpat Singh and Shivam Chauhan', 'Case Study of Air Pollution in Rajasthan', 'An Int. Journal of Creative Research Thoughts. Vol. 9(8) b747-753', '2021-07-01', 'National', 'Journal'),
(15, 'Singh G., Goel A. & Choudhary M.', 'Domestic water demand predicting by factors analysis of planned colony in Ajmer, Rajasthan', 'National Conference on Engineering Trends in Civil and Mechanical Engg. (NCTCME-2017), Aryabhat College of Engg. & Research Center and CED, Govt. Engg. College, Ajmer.', '2017-07-01', 'National', 'Conference'),
(16, 'H. S. Mewara, J. K. Deegwal, and M. M. Sharma', 'A slot resonators based quintuple band-notched Y-shaped planar monopole ultra-wideband antenna', 'Int. J. Electron. Commun. (AEU), vol. 83, pp. 470-478, 2018. DOI:10.1016/j.aeue.2017.10.03.', '2017-03-01', 'International', 'Journal'),
(17, 'H. S. Mewara, D. Jhanwar, M. M. Sharma, and J. K. Deegwal', 'A printed monopole ellipzoidal UWB antenna with four band rejection characteristics', 'Int. J. Electron. Commun. (AEU), vol. 83, pp. 222-232, 2018. DOI: 10.1016/j.aeue.2017.08.043.', '2017-08-01', 'International', 'Journal'),
(18, 'H. S. Mewara, D. Jhanwar, M. M. Sharma, and J. K. Deegwal', 'A novel hammer-shaped UWB antenna with triple notched-band for rejecting RLS, WLAN and XSCS bands', 'Advanced Electromagnetics, vol. 6, no. 4, pp. 36-41, 2017. DOI: https://doi.org/10.7716/aem.v6i4.527', '2017-03-01', 'International', 'Journal'),
(19, 'H. S. Mewara, R. Kumawat, M. M. Sharma, and I. B. Sharma', 'Bandwidth enhancement of compact rectangular monopole UWB antenna using M-shaped strip with triple band notch characteristic', 'IEEE International Conference on Computer, Communications and Electronics (Comptelix), pp.265-270, 2017. DOI:10.1109/COMPTELIX.2017.8003976', '2017-08-01', 'International', 'Conference'),
(20, 'Ashok Kumar, Venuka Sankhla, J.K. Deegwal, and Arjun Kumar', 'An offset CPW fed triple band circularly polarized printed antenna for multiband wireless applications', 'Int. J. Electron. Commun., vol. 86, pp. 133-141, Feb 2018, doi: 10.1016/j.aeue.2018.02.002.', '2008-02-01', 'International', 'Journal'),
(21, 'Ajay Dadhich, J.K. Deegwal, and M.M. Sharma', 'Multiband slotted microstrip patch antenna for TD-LTE, ITU and X-band applications', '2018 5th International Conference on Signal Processing and Integrated Networks (SPIN), Noida, India, pp. 745-748, 2018, doi: 10.1109/SPIN.2018.8474185', '2018-08-01', 'International', 'Conference'),
(22, 'Deepak Gupta, Ajay Dadhich', 'An approach to Increase the Accuracy of aboutness of web document for search engine using OGP', 'International journal of Scientific and Engineering Research under the title. Year 2013 volume 4 Edition (ISSN 2229-5518).', '2013-03-01', 'International', 'Journal'),
(23, 'Tarun Dadheech, Chandraveer Singh, Ajay Dadhich', 'Design an Extended Circular Planar Microstrip Patch Antenna for UWB Application', 'International Journal of Computer Applications, pp. 0975 – 8887, Volume 138 – No.5, March 2016.', '2016-03-01', 'International', 'Journal'),
(24, 'Mewara, H.S.; Sharma, M.M.; Sharma, M.; Dadhich, A.', 'A Novel Ultra-Wide Band Antenna Design using Notches, Stepped Microstrip Feed and Beveled Partial Ground with Beveled Parasitic Strip', 'Applied Electromagnetics Conference (AEMC), 2013 IEEE,Year: 2013,Pages: 1 - 2, DOI: 10.1109/AEMC.2013.7045091', '2013-03-01', 'International', 'Conference'),
(25, '', 'Parity checking and generating circuit with semiconductor optical amplifier in all-optical domain, Optik-Int.J.Light, SCI Indexed', '', '2008-03-01', 'International', 'Journal'),
(26, '', 'Photonic crystal fibre as low loss flattened fibre and ultra low confinement loss', 'In  International journal of Emerging Technologies and advanced Engineering', '2009-03-01', 'International', 'Journal'),
(27, '', 'All-Optical XOR gate using SOA based Mach-Zehender Interferometer', 'International Conference on Communication and Electronic System Design organized by MNIT, Jaipur and proceedings published by SPIE', '2013-06-01', 'International', 'Conference'),
(28, '', 'Comparison of Two In line MZI Concentration sensors using FDTD Method', 'IEEE International conference ICSPT-2014 organized by EI&CE department of GEC Ajmer', '2014-08-01', 'International', 'Conference'),
(29, '', 'Design of Microstrip UWB Antenna with dual band notch Characteristics', 'Published in "Advanced Research in Electrical and Electronics Engineering" held at New Delhi, JNU', '2015-03-01', 'National', 'Journal'),
(30, '', 'Design of Triple Band Notch Micro strip UWB Antenna with H-shaped parasitic element in ground plane', 'International Journal of Science Technology and Engineering ISSN online-2349- 784x', '2016-03-01', 'International', 'Journal'),
(31, '', 'Challenge in the migration to 4G Mobile Communication', 'Published in National Conference on" Emerging Trends and Applications in Computer Engineering" held at ECAjmer', '2007-03-01', 'National', 'Conference'),
(32, '', 'A CPW fed slotted enhanced band elliptical antenna with triple band Characteristics', 'Published in "International Conference on Signal Propagation and Computer Technology"(IEEE) held at ECAjmer. Print ISBN 978-1-4799-3139-2', '2014-07-01', 'International', 'Conference'),
(33, 'Khatri, A., Garg, D. and Dangayach, G.S.', 'Agile manufacturing: a framework for achieving Agility', 'Industrial Engineering Journal, Mumbai, India, Vol. 7, No. 12, pp.06–09', '2014-09-01', 'National', 'Journal'),
(34, 'Sharma, M. and Khatri, A.', 'Total quality Maintenance & trouble shooting: A case study', 'International Journal of emerging technology & advanced engineering, Vol. 5, issue 3', '2015-09-01', 'International', 'Journal'),
(35, 'Khatri, A., Garg, D. and Dangayach, G.S. ', 'Modelling of Prime Agile Enablers: People, Virtual Integration and Information Technology', '2nd International Conference on Materials Manufacturing and Design Engineering, MIT Aurangabad.', '2017-12-01', 'International', 'Conference'),
(36, 'All India Seminar of Mechanical Engineering Division Board, Institution of Engineers (India), Jaipur ‘Theme: Automobile Industry Perspectives’,', 'Legible Manufacturing in Automobile Industry: A Focus', 'Khatri, A., Garg, D. and Dangayach, G.S.', '2015-08-01', 'National', 'Conference'),
(37, 'Karwa R., Karwa N., Misra R., Agarwal P.C.', 'Effect of Flow Maldistribution on Thermal Performance of a Solar Air Heater Array With Sub-collectors in Parallel', 'Int. J. of Energy, Vol. 32, pp. 1260-1270, ISSN: 0360-5442', '2007-07-01', 'International', 'Journal'),
(38, 'Bansal V., Misra R., Mathur J., Agrawal G.', 'Performance Analysis of Earth-Pipe-Air Heat Exchanger for Winter Heating', 'Int. J. of Energy and Buildings, Vol. 41, pp. 1151-1154, ISSN: 0378-7788', '2009-07-01', 'International', 'Journal'),
(39, 'Misra R., Aseri T. K.', 'Thermal Performance Enhancement of Box-Type Solar Cooker: A New Approach', 'Int. J. of Sustainable Energy (Taylor & Francis), Vol. 1, pp. 1-12, ISSN 1478-6451', '2011-08-01', 'National', 'Journal'),
(40, 'Misra R., Karwa R., Agrawal P.C.', 'Enhanced Performance Artificially Roughened Flat Plate Solar Air Heaters', 'Seminar on Solar Technologies’ organised by The Institution of Electronics & Telecommunication Engineers, Rajasthan Local Centre, Jaipur and sponsored by REDA and RE&IL', '1999-08-01', 'National', 'Conference'),
(41, 'Bansal V., Misra R., Agrawal G. D., Mathur J', 'Performance Analysis of Earth Air Tunnel Heat Exchanger for Summer Cooling', ' International Conference on “Advances in Energy Research (ICAER)” held at I.I.T. Bombay, Dec.9-11, Page No. 49-53', '2009-07-01', 'National', 'Conference'),
(42, 'Sharma, C., Sharma, A. K., Mullick, S. C., Kandpal, T. C', 'Assessment of solar thermal power generation potential in India', 'Renewable and Sustainable Energy Reviews, 42, 902-912', '2015-07-01', 'National', 'Journal'),
(43, 'Sharma, C., Sharma, A. K., Mullick, S. C., Kandpal, T. C.', 'Solar Thermal Power Generation in India: Effect of Potential Incentives on Unit Cost of Electricity', 'International Journal of Sustainable Energy, 36(8), 722-737', '2017-07-01', 'International', 'Journal'),
(44, 'Sharma, A.K., Sharma, C., Mullick, S.C., Kandpal, T.C', 'Effect of incentives on the financial attractiveness of solar industrial process heating in India', 'Renewable Energy and Environmental Sustainability, 33, 1-5', '2017-07-01', 'National', 'Journal'),
(45, 'Sharma, C., Sharma, A. K., Mullick, S. C., Kandpal, T. C', 'Identifying Optimal Combinations of Design DNI, Solar Multiple and Storage Hours for Parabolic Trough Power Plants for Niche Locations in India', 'International Conference on Alternative Energy in Developing Countries and Emerging Economies. Energy Procedia, 79, 61-66', '2015-05-01', 'International', 'Conference');

-- --------------------------------------------------------

--
-- Table structure for table `journal_tags`
--

CREATE TABLE IF NOT EXISTS `journal_tags` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `journal_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `journal_tags`
--

INSERT INTO `journal_tags` (`id`, `teacher_id`, `journal_id`) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 2, 3),
(4, 2, 4),
(5, 2, 5),
(6, 2, 6),
(7, 3, 4),
(8, 5, 1),
(9, 5, 7),
(10, 5, 8),
(11, 5, 6),
(12, 4, 7),
(13, 4, 3),
(14, 4, 4),
(15, 4, 9),
(16, 4, 10),
(17, 6, 11),
(18, 6, 12),
(19, 10, 13),
(20, 10, 14),
(21, 10, 15),
(22, 16, 16),
(23, 16, 17),
(24, 16, 18),
(25, 16, 19),
(26, 17, 16),
(27, 17, 18),
(28, 17, 20),
(29, 17, 21),
(30, 19, 22),
(31, 19, 23),
(32, 19, 21),
(33, 19, 24),
(34, 22, 25),
(35, 22, 26),
(36, 22, 27),
(37, 22, 28),
(38, 21, 29),
(39, 21, 30),
(40, 21, 31),
(41, 21, 32),
(42, 27, 33),
(43, 27, 34),
(44, 27, 35),
(45, 27, 36),
(46, 28, 37),
(47, 28, 38),
(48, 28, 39),
(49, 28, 40),
(50, 28, 41),
(51, 31, 42),
(52, 31, 43),
(53, 31, 44),
(54, 31, 45),
(55, 2, 46);

-- --------------------------------------------------------

--
-- Table structure for table `memberships`
--

CREATE TABLE IF NOT EXISTS `memberships` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `memberships_name` text NOT NULL,
  `details` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `memberships`
--

INSERT INTO `memberships` (`id`, `teacher_id`, `memberships_name`, `details`) VALUES
(1, 2, 'ISTE Life Time member', ''),
(2, 2, 'Member of International Association of Computer Science and Information Technology (IACSIT)', ''),
(3, 5, 'ISTE Life Time member', ''),
(4, 4, 'Indian Society of Technical Education.', 'Life Member'),
(5, 4, 'CISCO Certified Academy Instructor.', 'Member'),
(6, 4, 'The Society of Digital Information and Wireless Communications (SDIWC) ', 'Member, ID 2781'),
(7, 6, 'ISTE Life Time member', 'Since 2013'),
(8, 6, 'IEEE Senior Member', 'Since 2017'),
(9, 6, 'ACM Professional Member', 'Since 2011'),
(10, 10, 'Indian Water Resources Society (Roorkee)', 'Life Membership\r\n'),
(11, 10, 'Alumnus Membership ', 'MBM Engineering College, Jodhpur\r\n'),
(12, 17, 'IEEE', ''),
(13, 17, 'IETE India', ''),
(14, 17, 'ACES', ''),
(15, 19, 'IEEE Professional Member', ''),
(16, 19, 'IEEE APS Member', ''),
(17, 22, 'Life Member ISTE', ''),
(18, 22, 'Fellow OSI', ''),
(19, 22, 'Member IEEE', ''),
(20, 21, 'Life Membership of " Indian Society for Technical Education (ISTE)"', 'Number LM 131216.'),
(21, 28, 'Life Member of Solar Energy Society of India (SESI)', 'Membership No. LM/1563/2011\r\n'),
(22, 28, 'Life Member of Indian Society for Technical Education (ISTE)', 'Membership No. LM 66296'),
(23, 30, 'Life member of Indian Society for Technical Education (ISTE)', '');

-- --------------------------------------------------------

--
-- Table structure for table `research_interest`
--

CREATE TABLE IF NOT EXISTS `research_interest` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `interest` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `research_interest`
--

INSERT INTO `research_interest` (`id`, `teacher_id`, `interest`) VALUES
(1, 2, 'Post Graduate and Graduate'),
(2, 2, 'Linux-Shell Programming'),
(3, 2, 'Databases'),
(4, 2, 'Computer Architecture'),
(5, 2, 'System Software'),
(6, 2, 'C/C++ Programming'),
(7, 2, 'Operating Systems'),
(8, 2, 'Information Security'),
(9, 3, 'Software Engineering'),
(10, 3, 'Human Computer Interface'),
(11, 3, 'Database Management Systems'),
(12, 3, 'Brain Computer Interface'),
(13, 3, 'Networking'),
(14, 3, 'Software Testing'),
(15, 5, 'Internet of Things'),
(16, 5, 'Automata Theory'),
(17, 5, 'Wireless Sensor Network'),
(18, 5, 'Malware Analysis'),
(19, 5, 'Deep Learning'),
(20, 4, 'Computer Networks'),
(21, 4, 'Cloud Computing'),
(22, 6, 'Computer Network'),
(23, 6, 'Human Computer Interaction'),
(24, 6, 'Scientific Visualization'),
(25, 6, 'Data Science And Analytics'),
(26, 6, 'Cyber Security'),
(27, 10, 'Water Resources & Structures'),
(28, 10, 'Construction'),
(29, 10, 'Irrigation'),
(30, 16, 'Printed Antennas'),
(31, 16, 'UWB Antenna'),
(32, 16, 'MANET'),
(33, 16, 'Wireless Sensor Networks(WSN)'),
(34, 17, 'Antennas'),
(35, 17, 'Printed Antennas'),
(36, 17, 'UWB Antennas'),
(37, 17, 'Circularly Polarized Antennas'),
(38, 19, 'Control Systems'),
(39, 19, 'Antenna'),
(40, 22, 'Optical Fiber Communication'),
(41, 22, 'Optical Computing'),
(42, 22, 'Optical Sensors'),
(43, 22, 'Photonics and Nano materials'),
(44, 21, 'Antenna Designing'),
(45, 27, 'Agile manufacturing'),
(46, 27, 'Ergonomics'),
(47, 27, 'Manufacturing systems'),
(48, 27, 'Non-conventional Machining'),
(49, 27, 'Industrial Engineering'),
(50, 27, 'Lean manufacturing'),
(51, 27, 'Supply Chain Management'),
(52, 27, 'Logistic Management'),
(53, 28, 'HVAC Stsytems'),
(54, 28, 'Renewable Energy'),
(55, 28, 'Energy Conservation'),
(56, 28, 'Heat Transfer'),
(57, 30, 'Metrology'),
(58, 30, 'Production Engineering'),
(59, 31, 'Techno-economics of Renewable Energy Systems'),
(60, 31, 'Concentrating Solar Power Technologies'),
(61, 31, 'Optical and thermal performance of Solar Energy Technologies'),
(62, 31, 'Testing of Solar Thermal Devices');

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `workshop_id` int(11) NOT NULL,
  `role` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `teacher_id`, `workshop_id`, `role`) VALUES
(1, 2, 1, 'Expert Lecture'),
(2, 2, 2, 'Expert Lecture'),
(3, 2, 3, 'Expert Lecture'),
(4, 2, 4, 'Cordinator'),
(5, 2, 5, 'Cordinator'),
(6, 2, 6, 'Member'),
(7, 2, 7, 'Attend'),
(9, 5, 8, 'Expert Lecture'),
(10, 5, 9, 'Attend'),
(11, 5, 10, 'Cordinator'),
(12, 5, 11, 'Attend'),
(13, 4, 12, 'Expert Lecture'),
(14, 4, 13, 'Expert Lecture'),
(15, 4, 14, 'Member'),
(16, 4, 15, 'Cordinator'),
(17, 4, 16, 'Cordinator'),
(18, 6, 17, 'Expert Lecture'),
(19, 6, 18, 'Cordinator'),
(20, 6, 19, 'Cordinator'),
(21, 6, 20, 'Attend'),
(22, 6, 21, 'Attend'),
(23, 10, 22, 'Expert Lecture'),
(24, 10, 23, 'Expert Lecture'),
(25, 10, 24, 'Cordinator'),
(26, 10, 25, 'Member'),
(27, 10, 26, 'Attend'),
(28, 19, 27, 'Member'),
(29, 19, 28, 'Cordinator'),
(30, 19, 29, 'Attend'),
(31, 19, 30, 'Attend'),
(32, 22, 31, 'Expert Lecture'),
(33, 22, 32, 'Expert Lecture'),
(34, 22, 33, 'Expert Lecture'),
(35, 22, 34, 'Member'),
(36, 22, 35, 'Cordinator'),
(37, 22, 36, 'Member'),
(38, 22, 37, 'Attend'),
(39, 22, 38, 'Attend'),
(40, 21, 35, 'Cordinator'),
(42, 21, 39, 'Cordinator'),
(43, 21, 40, 'Attend'),
(44, 21, 41, 'Attend'),
(46, 27, 42, 'Cordinator'),
(47, 27, 43, 'Member'),
(48, 27, 44, 'Cordinator'),
(49, 27, 45, 'Attend'),
(50, 27, 46, 'Attend'),
(51, 28, 47, 'Attend'),
(52, 28, 48, 'Attend'),
(53, 28, 42, 'Attend'),
(54, 28, 28, 'Attend'),
(55, 30, 49, 'Attend'),
(56, 30, 50, 'Attend'),
(57, 30, 42, 'Attend'),
(58, 31, 47, 'Attend'),
(59, 31, 48, 'Attend'),
(60, 31, 38, 'Attend');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_profile`
--

CREATE TABLE IF NOT EXISTS `teacher_profile` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `phone_no` varchar(20) NOT NULL,
  `designation` varchar(60) NOT NULL,
  `address` text NOT NULL,
  `department_id` int(11) DEFAULT NULL,
  `img_type` varchar(10) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `teacher_profile`
--

INSERT INTO `teacher_profile` (`id`, `teacher_id`, `name`, `phone_no`, `designation`, `address`, `department_id`, `img_type`) VALUES
(1, 2, 'Dr. Jyoti Gajrani ', '9460031242', 'Assistant Professor', '1554/2, Pancholi Chouraha Ram Nagar, Ajmer', 2, 'png'),
(2, 3, 'Dr. Prakriti Trivedi', '', 'Associate Professor', 'Panchsheel A Block,Ajmer', 2, 'png'),
(3, 4, 'Dr. Rakesh Rathi', '941429515', 'Assistant Professor', 'Anasagar Link Road, Ajmer', 2, 'png'),
(4, 5, 'Dr. Vinesh Kumar Jain', '9462738575', 'Assistant Professor', '5, Officer Enclave, Gali No 8, Balupura Road, Adarsh Nagar Ajmer', 2, 'png'),
(5, 6, 'Prakash Meena', '919460089526', 'Assistant Professor', 'Parshwanath Township Ahmedabad', 2, 'png'),
(6, 7, 'Dr. Jyoti Gajrani', '', '', '', 2, ''),
(7, 8, 'Dr. Rekha Mehra', '', '', '', 0, ''),
(8, 9, 'Mahesh Manwani', '', 'Assistant Professor', 'NEAR KRISHAN KUNJ GARDEN, EKTA VIHAR COLONY, CHOUHANO KA BERA, DHOLABHATA, AJMER - 305001', 3, 'png'),
(9, 10, 'Dr. Ganpat Singh', '7014404116', 'Assistant Professor', 'Bhayal House, Plot No-260, Sector-2, J P Nagar, Ajmer Ajmer\r\n', 3, 'png'),
(10, 11, 'Vishal Srivastava', '', '', '', 3, ''),
(11, 12, 'Mahesh Manwani', '', '', '', 3, ''),
(12, 13, 'Dr. K. G. Sharma', '', 'Head Of Department', '97, H.B.Nagar, Naka Madar, Ajmer', 5, 'png'),
(13, 14, 'Dr. Indira Rawat', '9460124016', 'Associate Professor', '6/239, Vidyadhar Nagar, Jaipur\r\n', 5, 'png'),
(14, 15, 'Dr. K. G. Sharma', '', '', '', 5, ''),
(15, 16, 'Dr. Hari Shankar Mewara', '9414340074', 'Associate Professor', 'House no-13, H. B. Nagar, Naka Madar, Ajmer\r\n', 7, 'png'),
(16, 17, 'Dr. Jitendra Kumar Deegwal', '', 'Associate Professor', 'D-17, Chandra Vardai Nagar, Ajmer-305002\r\n', 7, 'png'),
(17, 18, 'Dr. C. P. Jain', '', '', '', 7, ''),
(18, 19, 'Ajay Dadhich', '', 'Assistant Professor', 'Plot no.- 28, H.B.Nagar,Naka Madar ,Ajmer -305024\r\n', 7, 'png'),
(19, 20, 'Dr. Hari Shankar Mewara', '', '', '', 7, ''),
(20, 21, 'Dr. Anurag Garg', '7231909222', 'Assistant Professor', '308, New Kesari Colony, Balupura Road, Adarsh Nagar, Ajmer', 6, 'png'),
(21, 22, 'Dr. Rekha Mehra', '9214310888', 'Associate Professor', 'House No 3 Adarsh Nagar Ajmer', 6, 'png'),
(22, 23, 'Dr. U.s. Modani', '', '', '', 6, ''),
(23, 24, 'Mukesh Gupta', '', '', '', 6, ''),
(24, 25, 'Dr. Deepak Jhanwar', '', '', '', 6, ''),
(25, 26, 'Dr. Anurag Garg', '', '', '', 6, ''),
(26, 27, 'Dr. Alok Khatri', '9414604006', 'Associate Professor', 'Chandervardai Nagar', 4, 'png'),
(27, 28, 'Dr. Rohit Misra', '9414782651', 'Associate Professor', '22, Brij Vihar Colony, Naya Ghar, Gulab Bari, Ajmer\r\n', 4, 'png'),
(28, 29, 'Dr. Ankur Pareek', '', '', '', 4, ''),
(29, 30, 'Y.k.gupta', '9460389636', 'Associate Professor', 'C-38 B, M.D.Colony, Naka Madar, Ajmer', 4, 'png'),
(30, 31, 'Dr. Chandan Sharma', '9414261670', 'Associate Professor', '46, Hanuman Nagar, Bihari Ganj, Ajmer', 4, 'png'),
(31, 32, 'Dr. Alok Khatri', '', '', '', 4, ''),
(32, 33, 'Shikha Gupta', '', 'Assistant Professor', 'Panchsheel Colony, RHB, Ajmer', 2, '');

-- --------------------------------------------------------

--
-- Table structure for table `thesis`
--

CREATE TABLE IF NOT EXISTS `thesis` (
  `id` int(11) NOT NULL,
  `thesis_name` text NOT NULL,
  `guided` text NOT NULL,
  `status` varchar(20) NOT NULL,
  `degree` varchar(20) NOT NULL,
  `start_year` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `thesis`
--

INSERT INTO `thesis` (`id`, `thesis_name`, `guided`, `status`, `degree`, `start_year`) VALUES
(1, 'Extension of PMIPV6 Model for NEMO-Smart in VANET', 'Swatantra Porwal', 'Completed', 'Mtech', '2014-07-01'),
(2, 'A Robust Client Side Defense for Reflected Cross-Site Scripting', 'Bhawana Mewara', 'Completed', 'Mtech', '2013-07-01'),
(3, 'Detection and Robust Solustion against Phising Attacks', 'Sheetal Bairwa', 'Completed', 'Mtech', '2013-07-01'),
(4, 'Smartphone Malware Analysis through Text Mining ', 'Mohit Sharma (Student of MANIT, Bhopal)', 'Completed', 'Mtech', '2014-07-01'),
(5, 'Android Malware Analysis', 'Taresh Mishra', 'Ongoing', 'Mtech', '2014-07-01'),
(6, 'Intrusion Detection System', 'Surendra Kumar', 'Ongoing', 'Mtech', '2014-07-01'),
(7, 'Internet of Things', 'Bhawana Sharma', 'Ongoing', 'Mtech', '2015-07-01'),
(8, 'Enhance Matching in Multi Dimensional Reconstruction using Stereo Image Sequences', 'S N Tazi', 'Completed', 'Mtech', '2017-07-01'),
(9, 'Time series data prediction using fuzzy data dredging', 'Anshuman Singh', 'Completed', 'Mtech', '2015-07-01'),
(10, 'Frequent Pattern Analysis For Weblog File To Improve Efficiency Of Web Usage Mining', 'Hemwati Kumawat', 'Completed', 'Mtech', '2012-07-01'),
(11, 'Best Fit Multi Value Bin Packaging Approach for VM Allocation in Energy Efficient Cloud Computing', 'Rakesh Singh', 'Completed', 'Mtech', '2008-07-01'),
(12, 'Role of QR (Quick Response) Code in Digital Watermarking', 'Rakesh Singh', 'Completed', 'Mtech', '2009-07-01'),
(13, 'Efficient Data Center Selection Policy for Service Proximity Service Broker in Cloud Analyst Round-Robin Data Center Selection in Single Region', 'Rakesh Singh', 'Completed', 'Mtech', '2010-07-01'),
(14, 'Empirical study to measure the impact of HCI Technologies on Environment and design future frame work model of HCI technology', 'Rakesh Singh', 'Completed', 'Mtech', '2011-07-01'),
(15, ' DESIGN Of Band Notch Antennas with Small and Compact Structure for UWB Application to Sort Frequency Interfernce Problem', 'Deepak Kumar', 'Completed', 'Mtech', '2016-04-01'),
(16, 'UWB Antenna with Dual Band Notch for Enhancing the performance of wireless communication', 'Pooja Meena', 'Completed', 'Mtech', '2017-04-01'),
(17, 'A Hybrid Apprach for ECHO Cancellation Telephone System with Estimation of Noise', 'Praveen Jaiman', 'Completed', 'Mtech', '2018-05-01'),
(18, 'Parametric Investigations of Thermal Influence Zone of Earth Air Tunnel Heat Exchanger: A Transient CFD Analysis', 'Bihari Lal', 'Completed', 'Mtech', '2014-06-01'),
(19, 'CFD Based Performance Analysis of Earth Air Tunnel Heat Exchanger with Regeneration of Soil', 'Kapil Paliwal', 'Completed', 'Mtech', '2015-06-01'),
(20, 'Experimental Investigations of Effect of Water Impregnation on Thermal Performance of Earth Air Tunnel Heat Exchanger', 'Dharmendra Kumar Saini', 'Completed', 'Mtech', '2016-06-01');

-- --------------------------------------------------------

--
-- Table structure for table `thesis_tags`
--

CREATE TABLE IF NOT EXISTS `thesis_tags` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `thesis_id` int(11) NOT NULL,
  `role` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `thesis_tags`
--

INSERT INTO `thesis_tags` (`id`, `teacher_id`, `thesis_id`, `role`) VALUES
(1, 2, 1, 'Supervisor'),
(2, 2, 2, 'Supervisor'),
(3, 2, 3, 'Supervisor'),
(4, 2, 4, 'Co-Supervisor'),
(5, 2, 5, 'Supervisor'),
(6, 2, 6, 'Supervisor'),
(7, 2, 7, 'Supervisor'),
(8, 5, 8, 'Supervisor'),
(9, 5, 9, 'Supervisor'),
(10, 5, 10, 'Supervisor'),
(11, 4, 11, 'Supervisor'),
(12, 4, 12, 'Supervisor'),
(13, 4, 13, 'Supervisor'),
(14, 4, 14, 'Supervisor'),
(15, 21, 15, 'Supervisor'),
(16, 21, 16, 'Supervisor'),
(17, 21, 17, 'Supervisor'),
(18, 28, 18, 'Supervisor'),
(19, 28, 19, 'Supervisor'),
(20, 28, 20, 'Supervisor');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `email` varchar(60) NOT NULL,
  `password` varchar(20) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `otp` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `user_type`, `otp`) VALUES
(1, 'admin@ecajmer.ac.in', '123456', 'admin', '1803'),
(2, 'jyotigajrani@ecajmer.ac.in', 'gajrani83', 'teacher', '8640'),
(3, 'prakrititrivedi@ecajmer.ac.in', '123456', 'teacher', '5720'),
(4, 'rakeshrathi@ecajmer.ac.in', '123456', 'teacher', ''),
(5, 'vineshjain@ecajmer.ac.in', '123456', 'teacher', ''),
(6, 'prakashmeena@ecajmer.ac.in', '123456', 'teacher', ''),
(7, 'cse.hod@ecajmer.ac.in', '123456', 'hod', '9817'),
(8, 'principal@ecajmer.ac.in', '123456', 'principal', '7650'),
(9, 'maheshmanwani@ecajmer.ac.in', '123456', 'teacher', ''),
(10, 'ganpatsingh78@ecajmer.ac.in', '123456', 'teacher', ''),
(11, 'vishalsrivastava@ecajmer.ac.in', '123456', 'teacher', ''),
(12, 'ce.hod@ecajmer.ac.in', '123456', 'hod', ''),
(13, 'kgsharma@ecajmer.ac.in', '123456', 'teacher', ''),
(14, 'rawatindira@ecajmer.ac.in', '123456', 'teacher', ''),
(15, 'ee.hod@ecajmer.ac.in', '123456', 'hod', '6922'),
(16, 'hsmewara@ecajmer.ac.in', '123456', 'teacher', ''),
(17, 'jitendradeegwal@ecajmer.ac.in', '123456', 'teacher', ''),
(18, 'cpjain@ecajmer.ac.in', '123456', 'teacher', ''),
(19, 'ajaydadhich13@ecajmer.ac.in', '123456', 'teacher', ''),
(20, 'eic.hod@ecajmer.ac.in', '123456', 'hod', ''),
(21, 'anurageca@ecajmer.ac.in', '123456', 'teacher', ''),
(22, 'mehrarekha@ecajmer.ac.in', '123456', 'teacher', ''),
(23, 'drusmodani@ecajmer.ac.in', '123456', 'teacher', ''),
(24, 'mukeshgupta@ecajmer.ac.in', '123456', 'teacher', ''),
(25, 'dj@ecajmer.ac.in', '123456', 'teacher', ''),
(26, 'ece.hod@ecajmer.ac.in', '123456', 'hod', ''),
(27, 'alokkhatri@ecajmer.ac.in', '123456', 'teacher', ''),
(28, 'rohiteca@ecajmer.ac.in', '123456', 'teacher', ''),
(29, 'ankurpareek@ecajmer.ac.in', '123456', 'teacher', ''),
(30, 'ykgupta@ecajmer.ac.in', '123456', 'teacher', ''),
(31, 'sharmac1975@ecajmer.ac.in', '123456', 'teacher', ''),
(32, 'me.hod@ecajmer.ac.in', '123456', 'hod', ''),
(33, 'shikhagupta@ecajmer.ac.in', '123456', 'teacher', ''),
(34, 'sisodia.dilip@ecajmer.ac.in', '123456', 'teacher', '2780'),
(35, 'ishwarbhati157@gmail.com', '123456', 'teacher', '4662');

-- --------------------------------------------------------

--
-- Table structure for table `workshop`
--

CREATE TABLE IF NOT EXISTS `workshop` (
  `id` int(11) NOT NULL,
  `workshop_name` text NOT NULL,
  `venue` text NOT NULL,
  `start_year` date NOT NULL,
  `details` text NOT NULL,
  `end_year` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `workshop`
--

INSERT INTO `workshop` (`id`, `workshop_name`, `venue`, `start_year`, `details`, `end_year`) VALUES
(1, 'Reflection Aware ICC Analysis Framework for Android Apps', 'MNIT Jaipur', '2017-12-12', 'During GIAN course on “Principles and Practice of Software Protection”', '2017-12-18'),
(2, 'Android App Development', 'IIT Jammu', '2017-09-19', '', '2017-09-20'),
(3, 'CyberSecurity and SmartPhone Security', 'Shri Govindsingh Gurjar Govt. College, Nasirabaad', '2016-08-13', '', '2016-08-13'),
(4, 'Promoting Excellence in Research', 'Govt.Engineering College, Ajmer', '2014-02-04', '', '2014-02-09'),
(5, 'Awareness about Cyber Crime', 'Govt.Engineering College, Ajmer', '2017-03-16', 'Dept. of Science and Technology, Govt. of India sponsored workshop', '2017-03-18'),
(6, 'Signal Propagation and Computer Technology (ICSPCT 2014)', 'Govt.Engineering College, Ajmer', '2014-07-12', 'International Conference', '2014-07-13'),
(7, 'Information Security and Challenges(ISC-2015)', 'MNIT Jaipur ', '2015-11-16', 'One week FDP on ISC-2015 in Department of Computer Science Engineering', '2015-11-20'),
(8, ' Fundamental of Computer Network', 'Shri Govindsingh Gurjar Govt. College, Nasirabaad', '2016-08-13', 'Lecture on “ Fundamental of Computer Network at Shri Govindsingh Gurjar Govt. College, Nasirabaad\r\n', '2016-08-13'),
(9, 'Security in Computer Networks and Distributed System', 'Govt.Engineering College, Ajmer', '2014-01-09', 'National Conference, Sponsored by AICTE & TEQIP-II at Govt. Engineering College, Ajmer', '2014-01-10'),
(10, 'Network Security', 'Govt.Engineering College, Ajmer', '2016-09-12', '', '2016-09-12'),
(11, 'AI & Deep Learning', 'Govt.Engineering College, Ajmer', '2016-04-04', '', '2017-04-04'),
(12, 'Open Source Technology & Tools', 'Government Engineering College Ajmer', '2016-09-26', '', '2016-09-30'),
(13, 'Information Security', 'Govt.Engineering College, Ajmer', '2019-11-04', '', '2019-11-08'),
(14, 'Emerging Trends and Applications in Computer Engineering', 'Govt.Engineering College, Ajmer', '2007-04-13', '', '2007-04-13'),
(15, 'Python workshop', 'IIT Bombay', '2013-08-26', 'Spoken Tutorial project developed', '2013-08-26'),
(16, 'Deep Learning Applications', 'Govt.Engineering College, Ajmer', '2019-05-27', 'One Week Faculty Development Program', '2019-05-31'),
(17, 'TEQIP III  Future Skill Technology Lecture on Data Science and Analytics', 'Govt.Engineering College, Ajmer', '2020-07-01', '', '2020-07-01'),
(18, 'Recent Trends And Technology In Information Communication & Computing ', 'Govt.Engineering College, Ajmer', '2016-08-14', '', '2016-08-28'),
(19, 'IEEE Workshop On Internet Of Things', 'Govt.Engineering College, Ajmer', '2018-10-01', '', '2018-10-03'),
(20, 'Loophole-ethical Hacking', 'Govt.Engineering College, Ajmer', '2012-04-02', 'IEEE Workshop', '2012-04-03'),
(21, 'Radiation Hazards', 'Govt.Engineering College, Ajmer', '2013-07-22', 'International Workshop', '2013-07-22'),
(22, 'Latest Technology in Civil Engineering', 'AVVNL, Ajmer', '2017-09-17', 'In Quality Control Workshop', '2017-09-17'),
(23, 'Environmental Impact Assessment', 'JEET, Jodhpur (Raj.)', '2015-04-07', 'In Int. Seminar', '2015-04-07'),
(24, 'Human Values in Education', 'Govt.Engineering College, Ajmer', '2016-03-08', 'National Seminar', '2016-03-08'),
(25, 'Emerging Trends on Smart and Sustainable Infrastructure', 'Govt.Engineering College, Ajmer', '2019-08-19', 'One week Organized by Department of Civil Engg. & VJIT, Mumbai', '2019-08-26'),
(26, 'Environmental Protection & Sustainable Development', 'NITTTR, Chandigarh', '2009-10-07', '', '2009-10-14'),
(27, 'National Conference (Recent Advancement in Mathematics with application in Engineering – NCRAME 2012)', 'Govt.Engineering College, Ajmer', '2012-03-12', '', '2012-03-13'),
(28, 'National Seminar on ‘Technical Terminology in Engineering and science’ ', 'Govt.Engineering College, Ajmer', '2012-06-06', '', '2012-06-07'),
(29, 'Indian Antenna', 'Chandigarh ', '2014-05-26', 'Attended one week WORKSHOP on Indian Antenna week organized by IEEE', '2014-05-30'),
(30, 'Advanced Antenna Technology Organized', 'Thiagarajar College of Engineering, Madurai', '2010-06-06', 'Organized in association with IEEE AP-S Madras Chapter and IEEE AP/MTT Kolkata Chapter ', '2010-06-10'),
(31, 'Wireless and Optical Communication', 'Poornima college of Engineering Jaipur', '2014-01-18', 'Invited speaker in the AICTE sponsored National Seminar', '2014-01-19'),
(32, 'Signal Processing in Optical domain', 'RCEW Jaipur', '2016-01-22', ' National conference', '2016-01-22'),
(33, 'Next Generation Optical Network', 'Govt. Women Engineering College Ajmer', '2019-07-28', 'Delivered expert lecture in the National Workshop \r\n', '2019-07-29'),
(34, 'Optical and Wireless Technology 2017', ' MNIT Jaipur', '2017-03-18', 'Organizing Committee member of the International conference', '2107-03-29'),
(35, 'Hands on with MATLAB', 'Engineering College Ajmer', '2016-09-03', 'Organizing Committee member of two days workshop', '2016-09-04'),
(36, 'Robotics made eas', 'Govt.Engineering College, Ajmer', '2016-03-05', 'As IEEE Branch counselor organized', '2016-03-06'),
(37, 'PC Applications', 'ITI Mankapur', '1993-10-11', 'organized by CSI Chapter Mankapur', '1993-10-27'),
(38, 'MATLAB Programming and Applications', 'NITTTR Chandigarh', '2008-05-12', ' short term programme organized by NITTTR Chandigarh', '2008-05-16'),
(39, 'Nature Inspired Algorithms for Engineering Applications Under TEQIP III.', 'Govt.Engineering College, Ajmer', '2018-07-23', 'FDP', '2018-07-27'),
(40, 'Engineering Applications of Matlab', 'Govt.Engineering College, Ajmer', '2015-08-04', ' under TEQIP III', '2015-08-08'),
(41, 'Recent Advancement in Automotive Techonolgy through ICT', 'NITTTR Chandigarh', '2015-08-10', 'Under NITTR,Chandigarh', '2015-08-14'),
(42, 'Recent Advances in Mathematics with Applications in Engineering', 'Govt.Engineering College, Ajmer', '2012-03-12', 'National seminar', '2012-03-13'),
(43, 'Entrepreneurship and personality development', 'Govt.Engineering College, Ajmer', '2014-02-01', 'One week short term course', '2014-02-07'),
(44, '6th Indian Antenna', 'Govt.Engineering College, Ajmer', '2015-05-30', '', '2015-06-03'),
(45, 'Introduction to sustainable manufacturing', 'Malaviya National Institute of Technology, Jaipur', '2016-12-19', '', '2016-12-23'),
(46, 'Recent Trends and Technology in Information, Communication and Computing', 'Govt.Engineering College, Ajmer', '2016-02-23', '', '2016-03-03'),
(47, 'Advanced Tribology', 'I.I.T. Bombay', '2021-06-18', 'Q.I.P. short term course', '2001-06-22'),
(48, 'Use of CNG in I.C. Engines', 'I.I.T. Roorkee', '2022-06-30', 'Q.I.P. short term course', '2002-07-05'),
(49, 'Promoting Excellence in Research', 'Govt.Engineering College, Ajmer', '2014-02-04', 'National Workshop', '2014-02-08'),
(50, 'Radiation Hazards', 'Govt.Engineering College, Ajmer', '2013-01-28', 'International Workshop', '2013-01-29');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adm_role`
--
ALTER TABLE `adm_role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `award`
--
ALTER TABLE `award`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `education`
--
ALTER TABLE `education`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employment`
--
ALTER TABLE `employment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `journal_publications`
--
ALTER TABLE `journal_publications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `journal_tags`
--
ALTER TABLE `journal_tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `memberships`
--
ALTER TABLE `memberships`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `research_interest`
--
ALTER TABLE `research_interest`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teacher_profile`
--
ALTER TABLE `teacher_profile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teacher_id` (`teacher_id`);

--
-- Indexes for table `thesis`
--
ALTER TABLE `thesis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `thesis_tags`
--
ALTER TABLE `thesis_tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `workshop`
--
ALTER TABLE `workshop`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adm_role`
--
ALTER TABLE `adm_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `award`
--
ALTER TABLE `award`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `education`
--
ALTER TABLE `education`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT for table `employment`
--
ALTER TABLE `employment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT for table `journal_publications`
--
ALTER TABLE `journal_publications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=46;
--
-- AUTO_INCREMENT for table `journal_tags`
--
ALTER TABLE `journal_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=56;
--
-- AUTO_INCREMENT for table `memberships`
--
ALTER TABLE `memberships`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `research_interest`
--
ALTER TABLE `research_interest`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=63;
--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=61;
--
-- AUTO_INCREMENT for table `teacher_profile`
--
ALTER TABLE `teacher_profile`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=33;
--
-- AUTO_INCREMENT for table `thesis`
--
ALTER TABLE `thesis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `thesis_tags`
--
ALTER TABLE `thesis_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=36;
--
-- AUTO_INCREMENT for table `workshop`
--
ALTER TABLE `workshop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=51;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
