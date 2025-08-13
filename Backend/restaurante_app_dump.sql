-- MySQL dump 10.13  Distrib 9.2.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: restaurant_app
-- ------------------------------------------------------
-- Server version	9.2.0

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

--
-- Table structure for table `mesas`
--

DROP TABLE IF EXISTS `mesas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mesas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero_mesa` bigint unsigned DEFAULT NULL,
  `estado` longtext,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_mesas_numero_mesa` (`numero_mesa`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesas`
--

LOCK TABLES `mesas` WRITE;
/*!40000 ALTER TABLE `mesas` DISABLE KEYS */;
INSERT INTO `mesas` VALUES (1,4,'Libre','2025-08-03 18:45:57.705','2025-08-03 18:45:57.705');
/*!40000 ALTER TABLE `mesas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_items`
--

DROP TABLE IF EXISTS `pedido_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pedido_id` bigint unsigned DEFAULT NULL,
  `producto_id` bigint unsigned DEFAULT NULL,
  `cantidad` bigint unsigned DEFAULT NULL,
  `precio_unit` double DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pedidos_items` (`pedido_id`),
  CONSTRAINT `fk_pedidos_items` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_items`
--

LOCK TABLES `pedido_items` WRITE;
/*!40000 ALTER TABLE `pedido_items` DISABLE KEYS */;
INSERT INTO `pedido_items` VALUES (1,1,2,3,0,'2025-08-03 18:46:24.357','2025-08-03 18:46:24.357'),(2,2,1,1,0,'2025-08-03 18:50:10.856','2025-08-03 18:50:10.856'),(3,2,2,1,0,'2025-08-03 18:50:10.856','2025-08-03 18:50:10.856'),(4,3,2,7,0,'2025-08-03 18:50:36.767','2025-08-03 18:50:36.767');
/*!40000 ALTER TABLE `pedido_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero_mesa` bigint unsigned DEFAULT NULL,
  `estado` longtext,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,0,'NUEVO','2025-08-03 18:46:24.356','2025-08-03 18:46:24.356'),(2,0,'NUEVO','2025-08-03 18:50:10.855','2025-08-03 18:50:10.855'),(3,4,'NUEVO','2025-08-03 18:50:36.765','2025-08-03 18:50:36.765');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` longtext,
  `categoria` longtext,
  `precio` double DEFAULT NULL,
  `foto` longtext,
  `descripcion` longtext,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (3,'Melanzane alla parmigiana','ANTIPASTI',18000,NULL,'Berenjenas gratinadas con parmesano y pomodoro',NULL,NULL),(4,'Rabas y zucchini frito','ANTIPASTI',17000,NULL,'Rabas e zucchine fritte',NULL,NULL),(5,'Mozzarella alla milanese','ANTIPASTI',14000,NULL,'Acompañadas con pomodoro y pesto',NULL,NULL),(6,'Antipasto La Parolaccia','ANTIPASTI',33000,NULL,'Jamón crudo, bocconcini, gruyere, tomates secos, spianata, morrón, alcaucil, oliva ascolana y mortadela con pistacho',NULL,NULL),(7,'Burrata con jamón crudo estilo italiano','ANTIPASTI',24000,NULL,'Burrata con prosciutto',NULL,NULL),(8,'Calamaretti alla piastra','ANTIPASTI',22500,NULL,'Chipirones a la plancha con papas de campo y cebolla caramelizada',NULL,NULL),(9,'Tartare di salmone','ANTIPASTI',24000,NULL,'Crudo de salmón con palta, salsa de soja, jugo de lima, aceite de sésamo y salsa de ostras',NULL,NULL),(10,'Gamberi alla milanese','ANTIPASTI',30500,NULL,'Langostinos apanados con mozzarella, mayonesa de verduras y mousse de palta',NULL,NULL),(11,'Carpaccio di manzo','ANTIPASTI',18000,NULL,'Preparación de carne cruda, aderezo tradicional, rúcula y parmesano',NULL,NULL),(12,'Consommé di zucca','ANTIPASTI',14000,NULL,'Sopa cremosa de calabaza',NULL,NULL),(13,'Risotto Frutti di Mare (sin TACC)','RISOTTI',36000,NULL,'Almejas, mejillones, langostinos, vieiras, chipirones y calamares',NULL,NULL),(14,'Risotto ai funghi','RISOTTI',29000,NULL,'Champignon, cebolla y vino blanco',NULL,NULL),(15,'Caesar con pollo','INSALATE',19500,NULL,'Salsa caesar, lechuga, parmesano, croutón y pollo',NULL,NULL),(16,'La Parolaccia','INSALATE',20000,NULL,'Rúcula, bocconcino, pomodorini, aceitunas negras, palta, huevo, queso azul y vinagreta',NULL,NULL),(17,'Rúcola, calamaretti e gamberi','INSALATE',24500,NULL,'Rúcula, pomodorini, palta, cebolla, morrón, chipirones y langostinos',NULL,NULL),(18,'Camembert del campo','INSALATE',22500,NULL,'Rúcula, peras, camembert gratinado, almendras y vinagreta de mostaza y miel',NULL,NULL),(19,'Abadejo alla siciliana','PESCE',27500,NULL,'Pomodorini, morrón, cebolla, aceitunas negras y oliva; espárragos a la parmesana',NULL,NULL),(20,'Salmone rosa alla piastra','PESCE',37000,NULL,'Acompañado con papas del campo',NULL,NULL),(21,'Bife de chorizo (300 g)','CARNI',32500,NULL,'Cocción tradicional italiana con rúcula, grana y pomodorini',NULL,NULL),(22,'Milanese di Vitello alla parmigiana','CARNI',31500,NULL,'Milanesa de ternera con salsa de pomodoro y mozzarella, con papas de campo',NULL,NULL),(23,'Milanese di Vitello con fettuccine Alfredo','CARNI',31500,NULL,'Milanesa de ternera con fettuccine en salsa de crema y parmesano',NULL,NULL),(24,'Pollito al limone','POLLI',25000,NULL,'Crema y limón, acompañado con papas españolas',NULL,NULL),(25,'Suprema dell egeo','POLLI',25000,NULL,'Pechuga rellena con jamón cocido y mozzarella, salsa de queso azul y mil hojas de papa',NULL,NULL),(26,'Paillard di pollo alla griglia','POLLI',22000,NULL,'Acompañado con espinacas salteadas',NULL,NULL),(27,'Sorrentinos gran caruso','PASTA RIPIENA',27500,NULL,'Rellenos de mozzarella y jamón cocido, gratinados con crema, jamón, champignon, ave y pomodoro fresco',NULL,NULL),(28,'Sorrentinos uso nostro','PASTA RIPIENA',27500,NULL,'Rellenos de mozzarella y jamón cocido; pomodoro, pesto y mozzarella gratinados',NULL,NULL),(29,'Cappelletti al gruyere gratinati','PASTA RIPIENA',27500,NULL,'Rellenos de jamón y pollo con crema, gruyere y parmesano gratinado',NULL,NULL),(30,'Cappellacci di zucca al mascarpone','PASTA RIPIENA',27500,NULL,'Relleno de calabaza cabutiá con crema mascarpone, panceta crocante y salvia',NULL,NULL),(31,'Lasagna alla bolognese','PASTA RIPIENA',27500,NULL,'Carne de ternera, salsa blanca, tomate y parmesano',NULL,NULL),(32,'Ravioloni di brasato ai funghi','PASTA RIPIENA',27500,NULL,'Champignon y crema',NULL,NULL),(33,'Ravioli di burrata pomodoro e melanzane','PASTA RIPIENA',27500,NULL,'Burrata, tomates secos y albahaca con salsa pomodoro y berenjena',NULL,NULL),(34,'Tortelloni verdi di gruyere','PASTA RIPIENA',27500,NULL,'Tortelloni de gruyere gratinados con crema',NULL,NULL),(35,'Fettuccine alla bolognese','PASTA',26000,NULL,'Pomodoro y carne de ternera',NULL,NULL),(36,'Fettuccine Alfredo','PASTA',26000,NULL,'Crema, parmesano y yema de huevo',NULL,NULL),(37,'Gnocchi soufflé La Parolaccia','PASTA',26000,NULL,'Gnocchi de espinaca gratinados con ave, crema, champignon, pesto, parmesano y jamón cocido',NULL,NULL),(38,'Gnocchi di patate gorgonzola','PASTA',26000,NULL,'Queso azul y crema',NULL,NULL),(39,'Gnocchi di patate bolognese','PASTA',26000,NULL,'Pomodoro y carne de ternera',NULL,NULL),(40,'Bucatini con polpette di vitello','PASTA',26000,NULL,'Pasta seca italiana con pomodoro, morrones, cebolla, ajo, albahaca y albóndigas de ternera',NULL,NULL),(41,'Lasagna di vegetales','PASTA',27500,NULL,'Verduras mixtas: calabaza, zucchini, berenjenas, espinaca, ricota y mozzarella',NULL,NULL),(42,'Ravioli verdi scarparo','PASTA',27500,NULL,'Espinaca y ricota; pomodoro, verdeo, pesto, ajo y tomate seco',NULL,NULL),(43,'Crepe di spinaci alla romana','PASTA',27500,NULL,'Espinaca y ricota gratinado con crema, pomodoro y parmesano',NULL,NULL),(44,'Rigatoni all? arrabbiata','PASTA',26000,NULL,'Pomodoro, ajo, peperoncino, tomate concassé, oliva y perejil',NULL,NULL),(45,'Cuerdas de guitarra pomodoro e basilico','PASTA',26000,NULL,'Pomodoro y albahaca',NULL,NULL),(46,'Spaghetti cacio e pepe','PASTA',26000,NULL,'Queso pecorino estacionado y pimienta negra',NULL,NULL),(47,'Spaghetti alla napoletana','PASTA',26000,NULL,'Pesto de pomodoro secchi con pesto di basílico e burrata',NULL,NULL),(48,'Trofie al pesto genovese','PASTA',26000,NULL,'Receta original del pesto genovés',NULL,NULL),(49,'Fusilli al fierrito Don Corleone','PASTA',26000,NULL,'Pomodoro, oliva, ajo, aceitunas negras y alcaparras',NULL,NULL),(50,'Malfatti di spinaci','PASTA',26000,NULL,'Espinaca y ricota gratinado con crema, pomodoro y parmesano',NULL,NULL),(51,'Penne rigate pomodoro e basilico (sin TACC)','PASTA',26000,NULL,'Pomodoro y albahaca',NULL,NULL),(52,'Spaghetti ai frutti di mare','SPECIALI',32000,NULL,'Pomodoro, langostinos, calamar, vieiras, chipirones, almejas y mejillones',NULL,NULL),(53,'Ravioli neri panna e gamberi','SPECIALI',30000,NULL,'Raviol negro de salmón con salsa de vino blanco, langostinos y crema',NULL,NULL),(54,'Tagliolini nere panna e gamberi','SPECIALI',28500,NULL,'Crema y langostinos',NULL,NULL),(55,'Volcán de dulce de leche','DOLCI',11500,NULL,'Soufflé de dulce de leche con helado de crema y crocante de nuez',NULL,NULL),(56,'Tatén di mela con gelato','DOLCI',11500,NULL,'Tarta tibia de manzana con helado de crema y crocante de nuez',NULL,NULL),(57,'Merengatta','DOLCI',11500,NULL,'Merengue italiano, helado de crema y frutillas',NULL,NULL),(58,'Tiramisú al mascarpone','DOLCI',11500,NULL,'Clásico tiramisú con mascarpone',NULL,NULL),(59,'Seduzione di cioccolato','DOLCI',11500,NULL,'Volcán de chocolate con helado de crema',NULL,NULL),(60,'Crepe de dulce de leche','DOLCI',11500,NULL,'Crepe de dulce de leche con helado de crema',NULL,NULL),(61,'Gelato','DOLCI',11500,NULL,'',NULL,NULL),(62,'Mousse di cioccolato (sin TACC)','DOLCI',11500,NULL,'Soufflé de chocolate con crema chantilly y praliné de almendras',NULL,NULL),(63,'Piccola torta di limone','DOLCI',11500,NULL,'Pequeña torta de limón con salsa de frutos del bosque',NULL,NULL),(64,'Flan de claras','DOLCI',11500,NULL,'Confitura de naranja, yogur de vainilla, almendras y pasas de uva',NULL,NULL),(65,'Caffè expresso','CAFFETTERIA',3800,NULL,'Con Petit Four artesanal',NULL,NULL),(66,'Caffè expresso en jarrito','CAFFETTERIA',4600,NULL,'Con Petit Four artesanal',NULL,NULL),(67,'Té','CAFFETTERIA',3800,NULL,'Con Petit Four artesanal',NULL,NULL),(68,'Limonada','BEBIDAS',5000,NULL,'',NULL,NULL),(69,'Agua mineral','BEBIDAS',3800,NULL,'',NULL,NULL),(70,'Jugo exprimido de naranja','BEBIDAS',5000,NULL,'',NULL,NULL),(71,'Villa del Sur Levité','BEBIDAS',3800,NULL,'',NULL,NULL),(72,'Gaseosas','BEBIDAS',3800,NULL,'',NULL,NULL),(73,'We by Ser (Citrus / Lemon)','BEBIDAS',3800,NULL,'',NULL,NULL),(74,'Imperial (500 cc)','CERVEZA',5300,NULL,'',NULL,NULL),(75,'Imperial Cream Stout (500 cc)','CERVEZA',5300,NULL,'',NULL,NULL),(76,'Imperial Roja (500 cc)','CERVEZA',5300,NULL,'',NULL,NULL),(77,'Imperial IPA (500 cc)','CERVEZA',5300,NULL,'',NULL,NULL),(78,'Miller (355 cc)','CERVEZA',5050,NULL,'',NULL,NULL),(79,'Heineken (330 cc)','CERVEZA',5100,NULL,'',NULL,NULL),(80,'Heineken 0.0 (355 cc)','CERVEZA',5100,NULL,'',NULL,NULL),(81,'Ramazzotti Tonic','APERITIVO',8500,NULL,'Aperitivo Ramazzotti rosato, agua tónica y rodaja de limón',NULL,NULL),(82,'Ramazzotti Spritz','APERITIVO',8500,NULL,'Aperitivo Ramazzotti rosato, espumante y rodaja de limón',NULL,NULL);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'restaurant_app'
--

--
-- Dumping routines for database 'restaurant_app'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-13 16:37:33
