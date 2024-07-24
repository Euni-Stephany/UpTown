-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2024 at 11:05 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uptownmenu`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `detail_bundling` (IN `input_name` VARCHAR(255))   BEGIN
	DECLARE menu_details varchar(255);
    DECLARE price_details float;
    
    -- mendapat harga
    SELECT Price INTO price_details FROM special_bundling WHERE Name = input_name;
    
    -- mendapat detail sesuai nama
	CASE input_name
    WHEN 'Paket UpTown 1' THEN
    	SET menu_details = 'nasi, soup, pilihan ayam/ikan, pilihan masakan sayuran, sambal, kerupuk, buah, teh, air 			mineral';
    WHEN 'Paket UpTown 2' THEN
    	SET menu_details = 'nasi, pilihan soup, pilihan ayam/ikan, tumisan sayur, pilihan lauk pendamping, sambal, 			kerupuk, buah, teh, air mineral';
    WHEN 'Paket UpTown 3' THEN
    	SET menu_details = 'nasi, pilihan soup, pilihan ayam/ikan, tumisan sayur, lauk pendamping, sambal, kerupuk, 		buah, teh, mineral, soft drink'; 
    WHEN 'Paket UpTown 4' THEN
    	SET menu_details = 'nasi, pilihan soup, pilihan ayam/ikan, tumisan sayur, lauk pendamping, sambal, kerupuk, 		buah, teh, air mineral, es krim soft drink' ;
    WHEN 'Paket UpTown 5' THEN
    	SET menu_details = 'nasi, pilihan soup, pilihan ayam/ikan, pilihan masakan daging, tumisan sayur, sambal, 			kerupuk, pudding, es krim, buah, teh, air mineral, soft drink' ;
    WHEN 'Paket UpTown 6' THEN
    	SET menu_details = 'nasi, pilihan soup, pilihan masakan ayam, pilihan masakan daging, pilihan masakan 				ikan/seafood, tumisan sayur, sambal, kerupuk, pudding, es krim, buah/salah buah, teh, air mineral, soft 			drink';
    WHEN 'Paket UpTown 7' THEN
    	SET menu_details = 'nasi, pilihan soup, pilihan masakan ayam, pilihan masakan daging, pilihan masakan 				ikan/seafood, tumisan sayur, pilihan masakan pelengkap, pilihan penyegar, sambal, kerupuk, pudding, es krim,		buah, teh, air mineral, soft drink' ;
	ELSE
    	SET menu_details = 'Paket Tidak Ditemukan';
    END CASE;
    
    SELECT menu_details AS Bundling_Details, price_details;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `drink_status` (IN `input_name` VARCHAR(255))   BEGIN
	DECLARE current_status varchar(50);
	SELECT status INTO current_status FROM drink_menu WHERE Name = input_name;
	IF(current_status = 'Available') THEN
	UPDATE drink_menu SET status = 'Not Available' WHERE Name = input_name;
    ELSE
    UPDATE drink_menu SET status = 'Available' WHERE Name = input_name;
    END IF;
    SELECT * FROM drink_menu WHERE Name = input_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `food_status` (IN `input_name` VARCHAR(255))   BEGIN
	DECLARE current_status varchar(50);
	SELECT status INTO current_status FROM food_menu WHERE Name = input_name;
	IF(current_status = 'Available') THEN
	UPDATE food_menu SET status = 'Not Available' WHERE Name = input_name;
    ELSE
    UPDATE food_menu SET status = 'Available' WHERE Name = input_name;
    END IF;
    SELECT * FROM food_menu WHERE Name = input_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_by_name` (IN `input_name` VARCHAR(255))   BEGIN
	 DECLARE item_found INT DEFAULT 0;
    -- Cari item di food_menu
    IF EXISTS (SELECT 1 FROM food_menu WHERE name = input_name) THEN
    	SELECT f.ID, f.Name, f.Price, c.Name FROM food_menu f
		JOIN food_categories c ON ID_Cat = c.ID
		WHERE f.Name = input_name;
        SET item_found = 1;
    END IF;
    -- Jika tidak ditemukan di food_menu, cek di drink_menu
    IF item_found = 0 THEN
    	IF EXISTS (SELECT 1 FROM drink_menu WHERE name = input_name) THEN
        	SELECT d.ID, d.Name, d.Price, c.Name 
			FROM drink_menu d
			JOIN drink_categories c ON Cat_ID = c.ID
			WHERE d.Name = input_name;
        	SET item_found = 1;
    	END IF;
    END IF;
    -- Jika tidak ditemukan di kedua tabel
    IF item_found = 0 THEN
        SELECT 'Item tidak ditemukan' AS result;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `drink_total_price` (`in_name` VARCHAR(255)) RETURNS FLOAT  BEGIN
	DECLARE menu_price float;
    DECLARE total float;
    
    -- Mendapatkan harga item dari tabel menu berdasarkan name
    SELECT Price INTO menu_price
    FROM drink_menu
    WHERE Name = in_name;
    
    -- Menghitung total harga ditambah pajak 10%
    SET total = menu_price * 1.10;
    
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `food_total_price` (`in_name` VARCHAR(255)) RETURNS FLOAT  BEGIN
	DECLARE menu_price float;
    DECLARE total float;
    
    -- Mendapatkan harga item dari tabel menu berdasarkan ID
    SELECT Price INTO menu_price
    FROM food_menu
    WHERE Name = in_name;
    
    -- Menghitung total harga ditambah pajak 10%
    SET total = menu_price * 1.10;
    
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `drink_categories`
--

CREATE TABLE `drink_categories` (
  `ID` varchar(5) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Categories of Food in menu';

--
-- Dumping data for table `drink_categories`
--

INSERT INTO `drink_categories` (`ID`, `Name`, `Description`) VALUES
('DC001', 'Healthy Drink', 'Minuman sehat untuk kalian yang sedang menjaga asupan gizi'),
('DC002', 'Basic Coffee', 'Minuman dengan bahan dasar kopi yang ditambahkan varian flavours'),
('DC003', 'Traditional Drink', 'Minuman tradisional khas Indonesia yang terbuat dari berbagai rempah asli Indonesia dan memiliki banyak khasiat'),
('DC004', 'Coffee Addicted', 'Minuman original kopi dengan berbagai teknik penyajian'),
('DC005', 'Non Coffee', 'Minuman yang terbuat dari bahan selain kopi'),
('DC006', 'Milkshake', 'Minuman yang terbuat dari campuran susu dengan buah, powder, ataupun cookies'),
('DC007', 'Milkshake Float', 'Minuman yang terbuat dari campuran susu dengan buah, powder, ataupun cookies serta tambahan es krim sebagai toppingnya'),
('DC008', 'Fruit + Ice Cream', 'Campuran es krim dan buah'),
('DC009', 'Bread + Ice Cream', 'Variasi es krim yang dibalut dengan roti tawar dan terdapat topping pada ujung lapisannya'),
('DC010', 'Soda', 'Minuman bersoda dicampur dengan berbagai macam varian sirup dan susu'),
('DC011', 'Yakult', 'Minuman dengan bahan dasar yakult yang dicampur dengan berbagai varian sirup');

--
-- Triggers `drink_categories`
--
DELIMITER $$
CREATE TRIGGER `id_for_cat_drink` BEFORE INSERT ON `drink_categories` FOR EACH ROW BEGIN
    DECLARE new_id VARCHAR(5);
    DECLARE prefix VARCHAR(2) DEFAULT 'DC';
    DECLARE number_part INT;

    -- Mengambil nilai ID terakhir dan memisahkan bagian angka
    SELECT IFNULL(MAX(CAST(SUBSTRING(ID, 3, 3) AS UNSIGNED)), 0) + 1 INTO number_part
    FROM drink_categories
    WHERE id LIKE CONCAT(prefix, '%');

    -- Membuat ID baru
    SET new_id = CONCAT(prefix, LPAD(number_part, 3, '0'));

    -- Mengatur nilai ID baru
    SET NEW.ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `drink_menu`
--

CREATE TABLE `drink_menu` (
  `ID` varchar(5) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Price` float NOT NULL,
  `Cat_ID` varchar(5) NOT NULL,
  `status` varchar(50) DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Categories of Food in menu';

--
-- Dumping data for table `drink_menu`
--

INSERT INTO `drink_menu` (`ID`, `Name`, `Price`, `Cat_ID`, `status`) VALUES
('DR001', 'Jus Jambu', 10000, 'DC001', 'Available'),
('DR002', 'Jus Jeruk', 10000, 'DC001', 'Available'),
('DR003', 'Jus Tomat', 10000, 'DC001', 'Available'),
('DR004', 'Jus Wortel', 10000, 'DC001', 'Available'),
('DR005', 'Jus Strawberry', 12000, 'DC001', 'Available'),
('DR006', 'Jus Alpukat', 14000, 'DC001', 'Available'),
('DR007', 'Jus Buah Naga', 14000, 'DC001', 'Available'),
('DR008', 'Jus Mangga', 14000, 'DC001', 'Not Available'),
('DR009', 'Kopi Lemon Hot', 9000, 'DC002', 'Available'),
('DR010', 'Americano Hot', 12000, 'DC002', 'Available'),
('DR011', 'Cappucinno Hot', 12000, 'DC002', 'Available'),
('DR012', 'Kopi Latte Hot', 12000, 'DC002', 'Available'),
('DR013', 'Kopi Gula Aren Hot', 12000, 'DC002', 'Available'),
('DR014', 'Moccacino Latte Hot', 12000, 'DC002', 'Available'),
('DR015', 'Mojito Kopi Hot', 13000, 'DC002', 'Available'),
('DR016', 'Hazelnut Latte Hot', 14000, 'DC002', 'Available'),
('DR017', 'Vanilla Latte Hot', 14000, 'DC002', 'Available'),
('DR018', 'Caramel Latte Hot', 14000, 'DC002', 'Available'),
('DR019', 'Pandan Latte Hot', 16000, 'DC002', 'Available'),
('DR020', 'Almond Latte Hot', 16000, 'DC002', 'Available'),
('DR021', 'Kopi Lemon Ice', 10000, 'DC002', 'Available'),
('DR022', 'Americano Ice', 13000, 'DC002', 'Available'),
('DR023', 'Cappucinno Ice', 13000, 'DC002', 'Available'),
('DR024', 'Kopi Latte Ice', 13000, 'DC002', 'Available'),
('DR025', 'Kopi Gula Aren Ice', 13000, 'DC002', 'Available'),
('DR026', 'Moccacino Latte Ice', 13000, 'DC002', 'Available'),
('DR027', 'Mojito Kopi Ice', 14000, 'DC002', 'Available'),
('DR028', 'Hazelnut Latte Ice', 15000, 'DC002', 'Available'),
('DR029', 'Vanilla Latte Ice', 15000, 'DC002', 'Available'),
('DR030', 'Caramel Latte Ice', 15000, 'DC002', 'Available'),
('DR031', 'Pandan Latte Ice', 17000, 'DC002', 'Available'),
('DR032', 'Almond Latte Ice', 17000, 'DC002', 'Available'),
('DR033', 'Avogato Ice', 15000, 'DC002', 'Available'),
('DR034', 'Kopi Uptown Ice', 18000, 'DC002', 'Available'),
('DR035', 'Telang', 8000, 'DC003', 'Available'),
('DR036', 'Wedang Jahe', 8000, 'DC003', 'Available'),
('DR037', 'Wedang Sekoteng', 8000, 'DC003', 'Available'),
('DR038', 'Wedang Secang', 8000, 'DC003', 'Available'),
('DR039', 'Teh Jahe', 10000, 'DC003', 'Available'),
('DR040', 'Wedang Uwuh', 10000, 'DC003', 'Available'),
('DR041', 'Lemon Telang', 12000, 'DC003', 'Available'),
('DR042', 'Wedang Susu Jahe', 12000, 'DC003', 'Available'),
('DR043', 'Wedang Jeniper', 14000, 'DC003', 'Available'),
('DR044', 'Natural Robusta Tubruk', 5000, 'DC004', 'Available'),
('DR045', 'Honey Arabika Tubruk', 14000, 'DC004', 'Available'),
('DR046', 'Natural Arabika Tubruk', 14000, 'DC004', 'Available'),
('DR047', 'Lanang Arabika Tubruk', 15000, 'DC004', 'Available'),
('DR048', 'Wine Arabika Tubruk', 15000, 'DC004', 'Available'),
('DR049', 'Natural Robusta V60', 7000, 'DC004', 'Available'),
('DR050', 'Honey Arabika V60', 15000, 'DC004', 'Available'),
('DR051', 'Natural Arabika V60', 15000, 'DC004', 'Available'),
('DR052', 'Lanang Arabika V60', 17000, 'DC004', 'Available'),
('DR053', 'Wine Arabika V60', 17000, 'DC004', 'Available'),
('DR054', 'Natural Robusta Japanese', 8000, 'DC004', 'Available'),
('DR055', 'Honey Arabika Japanese', 15000, 'DC004', 'Available'),
('DR056', 'Natural Arabika Japanese', 15000, 'DC004', 'Available'),
('DR057', 'Lanang Arabika Japanese', 17000, 'DC004', 'Available'),
('DR058', 'Wine Arabika Japanese', 17000, 'DC004', 'Available'),
('DR059', 'Natural Robusta V-Drip', 9000, 'DC004', 'Available'),
('DR060', 'Honey Arabika V-Drip', 16000, 'DC004', 'Available'),
('DR061', 'Natural Arabika V-Drip', 16000, 'DC004', 'Available'),
('DR062', 'Lanang Arabika V-Drip', 18000, 'DC004', 'Available'),
('DR063', 'Wine Arabika V-Drip', 18000, 'DC004', 'Available'),
('DR064', 'Teh Hot', 5000, 'DC005', 'Available'),
('DR065', 'Leci Tea Hot', 6000, 'DC005', 'Available'),
('DR066', 'Jeruk Peras/Nipis Hot', 7000, 'DC005', 'Available'),
('DR067', 'Lemon Tea Hot', 8000, 'DC005', 'Available'),
('DR068', 'Milk Tea Hot', 10000, 'DC005', 'Available'),
('DR069', 'Matcha Hot', 12000, 'DC005', 'Available'),
('DR070', 'Coklat Hot', 13000, 'DC005', 'Available'),
('DR071', 'Mojito Tea', 13000, 'DC005', 'Available'),
('DR072', 'Matcha Latte Hot', 14000, 'DC005', 'Available'),
('DR073', 'Redvelvet', 14000, 'DC005', 'Available'),
('DR074', 'Teh Ice', 6000, 'DC005', 'Available'),
('DR075', 'Leci Tea Ice', 7000, 'DC005', 'Available'),
('DR076', 'Jeruk Peras/Nipis Ice', 8000, 'DC005', 'Available'),
('DR077', 'Lemon Tea Ice', 9000, 'DC005', 'Available'),
('DR078', 'Milk Tea Ice', 11000, 'DC005', 'Available'),
('DR079', 'Matcha Ice', 13000, 'DC005', 'Available'),
('DR080', 'Coklat Ice', 14000, 'DC005', 'Available'),
('DR081', 'Mojito Ice', 14000, 'DC005', 'Available'),
('DR082', 'Matcha Latte Ice', 15000, 'DC005', 'Available'),
('DR083', 'Redvelvet Ice', 15000, 'DC005', 'Available'),
('DR084', 'Milkshake Banana', 15000, 'DC006', 'Available'),
('DR085', 'Milkshake Coklat', 15000, 'DC006', 'Available'),
('DR086', 'Milkshake Oreo Bland', 15000, 'DC006', 'Available'),
('DR087', 'Milkshake Strawberry', 15000, 'DC006', 'Available'),
('DR088', 'Milkshake Taro', 15000, 'DC006', 'Available'),
('DR089', 'Milkshake Vanilla', 15000, 'DC006', 'Available'),
('DR090', 'Milkshake Choco Strawberry', 15000, 'DC006', 'Available'),
('DR091', 'Milkshake Banana Float', 18000, 'DC007', 'Available'),
('DR092', 'Milkshake Coklat Float', 18000, 'DC007', 'Available'),
('DR093', 'Milkshake Oreo Bland Float', 18000, 'DC007', 'Available'),
('DR094', 'Milkshake Strawberry Float', 18000, 'DC007', 'Available'),
('DR095', 'Milkshake Taro Float', 18000, 'DC007', 'Available'),
('DR096', 'Milkshake Vanilla Float', 18000, 'DC007', 'Available'),
('DR097', 'Milkshake Choco Strawberry Float', 18000, 'DC007', 'Available'),
('DR098', 'Coffee Float', 17000, 'DC008', 'Available'),
('DR099', 'Avocado Float', 17000, 'DC008', 'Available'),
('DR100', 'Banana Float', 17000, 'DC008', 'Available'),
('DR101', 'Mango Float', 17000, 'DC008', 'Available'),
('DR102', 'Strawberry Float', 17000, 'DC008', 'Available'),
('DR103', 'Orange Float', 17000, 'DC008', 'Available'),
('DR104', 'Towar Vanilla Ice Cream', 15000, 'DC009', 'Not Available'),
('DR105', 'Towar Coklat Ice Cream', 15000, 'DC009', 'Not Available'),
('DR106', 'Towar Strawberry Ice Cream', 15000, 'DC009', 'Not Available'),
('DR107', 'Towar Mix Ice Cream', 15000, 'DC009', 'Not Available'),
('DR108', 'Coca-cola Float', 12000, 'DC010', 'Available'),
('DR109', 'Fanta Float', 12000, 'DC010', 'Available'),
('DR110', 'Soda Gembira', 12000, 'DC010', 'Available'),
('DR111', 'Mojito Orange Squash', 17000, 'DC010', 'Available'),
('DR112', 'Mojito Leci Squash', 17000, 'DC010', 'Available'),
('DR113', 'Mojito Strawberry', 17000, 'DC010', 'Available'),
('DR114', 'Mojito Mango', 17000, 'DC010', 'Available'),
('DR115', 'Yakult Float', 15000, 'DC011', 'Available'),
('DR116', 'Ice Leci Yakult', 16000, 'DC011', 'Available'),
('DR117', 'Ice Lemon Yakult', 16000, 'DC011', 'Available'),
('DR118', 'Ice Strawberry Yakult', 16000, 'DC011', 'Available'),
('DR119', 'Ice Mango Yakult', 16000, 'DC011', 'Available');

--
-- Triggers `drink_menu`
--
DELIMITER $$
CREATE TRIGGER `id_for_drink` BEFORE INSERT ON `drink_menu` FOR EACH ROW BEGIN
    DECLARE new_id VARCHAR(5);
    DECLARE prefix VARCHAR(2) DEFAULT 'DR';
    DECLARE number_part INT;

    -- Mengambil nilai ID terakhir dan memisahkan bagian angka
    SELECT IFNULL(MAX(CAST(SUBSTRING(ID, 3, 3) AS UNSIGNED)), 0) + 1 INTO number_part
    FROM drink_menu
    WHERE id LIKE CONCAT(prefix, '%');

    -- Membuat ID baru
    SET new_id = CONCAT(prefix, LPAD(number_part, 3, '0'));

    -- Mengatur nilai ID baru
    SET NEW.ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `food_categories`
--

CREATE TABLE `food_categories` (
  `ID` varchar(5) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Categories of Food in menu';

--
-- Dumping data for table `food_categories`
--

INSERT INTO `food_categories` (`ID`, `Name`, `Description`) VALUES
('FC001', 'Snack', 'Cemilan ringan dengan berbagai macam rasa'),
('FC002', 'Rice Bowl', 'Sajian Makanan yang berisi Nasi dan varian Lauk ditambah dengan extra Saus Barbeque/Lada Hitam/Asam Manis'),
('FC003', 'Nasi Goreng', 'Sajian Makanan Nasi Goreng yang berisikan topping didalamnya seperti Telur/Bakso/Sosis'),
('FC004', 'Nasi + Lauk', 'Sajian Nasi dengan berbagai lauk Pilihan'),
('FC005', 'Spaghetti', 'Sajian olahan Pasta Spagehtti dengan topping saus Bolognise, Carbonara, atau tanpa saus'),
('FC006', 'Mie', 'Sajian Makanan olahan berbahan dasar Mie'),
('FC007', 'Sayur', 'Sajian Makanan olahan sayur dengan campuran varian berbagai Topping seperti Bakso, Sosis');

--
-- Triggers `food_categories`
--
DELIMITER $$
CREATE TRIGGER `id_for_cat_food` BEFORE INSERT ON `food_categories` FOR EACH ROW BEGIN
    DECLARE new_id VARCHAR(5);
    DECLARE prefix VARCHAR(2) DEFAULT 'FC';
    DECLARE number_part INT;

    -- Mengambil nilai ID terakhir dan memisahkan bagian angka
    SELECT IFNULL(MAX(CAST(SUBSTRING(ID, 3, 3) AS UNSIGNED)), 0) + 1 INTO number_part
    FROM food_categories
    WHERE id LIKE CONCAT(prefix, '%');

    -- Membuat ID baru
    SET new_id = CONCAT(prefix, LPAD(number_part, 3, '0'));

    -- Mengatur nilai ID baru
    SET NEW.ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `food_menu`
--

CREATE TABLE `food_menu` (
  `ID` varchar(5) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Price` float NOT NULL,
  `ID_Cat` varchar(5) NOT NULL,
  `status` varchar(50) DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Categories of Food in menu';

--
-- Dumping data for table `food_menu`
--

INSERT INTO `food_menu` (`ID`, `Name`, `Price`, `ID_Cat`, `status`) VALUES
('FD001', 'Pisang Goreng', 12000, 'FC001', 'Available'),
('FD002', 'Roti Bakar', 15000, 'FC001', 'Available'),
('FD003', 'Singkong Goreng', 11000, 'FC001', 'Available'),
('FD004', 'Mendoan', 10000, 'FC001', 'Available'),
('FD005', 'Cireng', 12000, 'FC001', 'Available'),
('FD006', 'Tempura', 12000, 'FC001', 'Available'),
('FD007', 'French Fries', 12000, 'FC001', 'Available'),
('FD008', 'Nugget', 12000, 'FC001', 'Available'),
('FD009', 'Otak-Otak', 12000, 'FC001', 'Available'),
('FD010', 'Mix Platter', 17000, 'FC001', 'Available'),
('FD011', 'Onion Rings', 19000, 'FC001', 'Available'),
('FD012', 'Egg Ricebowl', 12000, 'FC002', 'Available'),
('FD013', 'Chicken Ricebowl', 18000, 'FC002', 'Available'),
('FD014', 'Seafood Ricebowl', 22000, 'FC002', 'Available'),
('FD015', 'Nasi Goreng Uptown', 20000, 'FC003', 'Not Available'),
('FD016', 'Nasi Goreng Bakso', 14000, 'FC003', 'Available'),
('FD017', 'Nasi Goreng Sosis', 14000, 'FC003', 'Available'),
('FD018', 'Nasi Goreng telur', 12000, 'FC003', 'Available'),
('FD019', 'Nasi Katsu Original', 18000, 'FC004', 'Available'),
('FD020', 'Nasi Ayam Geprek', 15000, 'FC004', 'Available'),
('FD021', 'Nasi Telur Pontianak', 12000, 'FC004', 'Available'),
('FD022', 'Nasi Telur Sambal', 10000, 'FC004', 'Available'),
('FD023', 'Spaghetti Bolognise', 20000, 'FC005', 'Available'),
('FD024', 'Spaghetti Carbonara', 20000, 'FC005', 'Available'),
('FD025', 'Spaghetti Aglio Olio', 15000, 'FC005', 'Available'),
('FD026', 'Bakmi Special (G/R)', 18000, 'FC006', 'Available'),
('FD027', 'Indomie Special (G/R)', 15000, 'FC006', 'Available'),
('FD028', 'Bakmi Ayam/Sosis (G/R)', 15000, 'FC006', 'Available'),
('FD029', 'Kwetiaw Goreng', 15000, 'FC006', 'Available'),
('FD030', 'Indomie Telur (G/R)', 12000, 'FC006', 'Available'),
('FD031', 'Indomie Polos (G/R)', 8000, 'FC006', 'Available'),
('FD032', 'Capcay Special (G/R)', 18000, 'FC007', 'Available'),
('FD033', 'Capcay Sayur Biasa (G/R)', 14000, 'FC007', 'Available'),
('FD034', 'Capcay Ayam(G/R)', 16000, 'FC007', 'Available');

--
-- Triggers `food_menu`
--
DELIMITER $$
CREATE TRIGGER `id_for_food` BEFORE INSERT ON `food_menu` FOR EACH ROW BEGIN
    DECLARE new_id VARCHAR(5);
    DECLARE prefix VARCHAR(2) DEFAULT 'FD';
    DECLARE number_part INT;

    -- Mengambil nilai ID terakhir dan memisahkan bagian angka
    SELECT IFNULL(MAX(CAST(SUBSTRING(ID, 3, 3) AS UNSIGNED)), 0) + 1 INTO number_part
    FROM food_menu
    WHERE id LIKE CONCAT(prefix, '%');

    -- Membuat ID baru
    SET new_id = CONCAT(prefix, LPAD(number_part, 3, '0'));

    -- Mengatur nilai ID baru
    SET NEW.ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `special_bundling`
--

CREATE TABLE `special_bundling` (
  `ID` varchar(5) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Categories of Food in menu';

--
-- Dumping data for table `special_bundling`
--

INSERT INTO `special_bundling` (`ID`, `Name`, `Price`) VALUES
('SB001', 'Paket Uptown 1', 30000),
('SB002', 'Paket Uptown 2', 35000),
('SB003', 'Paket Uptown 3', 40000),
('SB004', 'Paket Uptown 4', 45000),
('SB005', 'Paket Uptown 5', 50000),
('SB006', 'Paket Uptown 6', 55000),
('SB007', 'Paket Uptown 7', 60000);

--
-- Triggers `special_bundling`
--
DELIMITER $$
CREATE TRIGGER `id_for_special_bundling` BEFORE INSERT ON `special_bundling` FOR EACH ROW BEGIN
    DECLARE new_id VARCHAR(5);
    DECLARE prefix VARCHAR(2) DEFAULT 'SB';
    DECLARE number_part INT;

    -- Mengambil nilai ID terakhir dan memisahkan bagian angka
    SELECT IFNULL(MAX(CAST(SUBSTRING(ID, 3, 3) AS UNSIGNED)), 0) + 1 INTO number_part
    FROM special_bundling
    WHERE id LIKE CONCAT(prefix, '%');

    -- Membuat ID baru
    SET new_id = CONCAT(prefix, LPAD(number_part, 3, '0'));

    -- Mengatur nilai ID baru
    SET NEW.ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_drink_not_available`
-- (See below for the actual view)
--
CREATE TABLE `v_drink_not_available` (
`ID` varchar(5)
,`Name` varchar(255)
,`Price` float
,`category` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_food_not_available`
-- (See below for the actual view)
--
CREATE TABLE `v_food_not_available` (
`ID` varchar(5)
,`Name` varchar(255)
,`Price` float
,`category` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure for view `v_drink_not_available`
--
DROP TABLE IF EXISTS `v_drink_not_available`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_drink_not_available`  AS SELECT `d`.`ID` AS `ID`, `d`.`Name` AS `Name`, `d`.`Price` AS `Price`, `c`.`Name` AS `category` FROM (`drink_menu` `d` join `drink_categories` `c` on(`d`.`Cat_ID` = `c`.`ID`)) WHERE `d`.`status` = 'Not Available' ;

-- --------------------------------------------------------

--
-- Structure for view `v_food_not_available`
--
DROP TABLE IF EXISTS `v_food_not_available`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_food_not_available`  AS SELECT `f`.`ID` AS `ID`, `f`.`Name` AS `Name`, `f`.`Price` AS `Price`, `c`.`Name` AS `category` FROM (`food_menu` `f` join `food_categories` `c` on(`f`.`ID_Cat` = `c`.`ID`)) WHERE `f`.`status` = 'Not Available' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `drink_categories`
--
ALTER TABLE `drink_categories`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `drink_menu`
--
ALTER TABLE `drink_menu`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Cat_ID` (`Cat_ID`);

--
-- Indexes for table `food_categories`
--
ALTER TABLE `food_categories`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `food_menu`
--
ALTER TABLE `food_menu`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID_Cat` (`ID_Cat`);

--
-- Indexes for table `special_bundling`
--
ALTER TABLE `special_bundling`
  ADD PRIMARY KEY (`ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `drink_menu`
--
ALTER TABLE `drink_menu`
  ADD CONSTRAINT `drink_menu_ibfk_1` FOREIGN KEY (`Cat_ID`) REFERENCES `drink_categories` (`ID`);

--
-- Constraints for table `food_menu`
--
ALTER TABLE `food_menu`
  ADD CONSTRAINT `food_menu_ibfk_1` FOREIGN KEY (`ID_Cat`) REFERENCES `food_categories` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
