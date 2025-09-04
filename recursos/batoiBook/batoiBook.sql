-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Temps de generació: 07-11-2024 a les 12:11:16
-- Versió del servidor: 8.0.36
-- Versió de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de dades: `batoiBook`
--

-- --------------------------------------------------------

--
-- Estructura de la taula `books`
--

CREATE TABLE `books` (
  `id` int NOT NULL,
  `userId` int DEFAULT NULL,
  `moduleCode` varchar(10) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `pages` int DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `comments` text,
  `soldDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de la taula `courses`
--

CREATE TABLE `courses` (
  `id` int NOT NULL,
  `course` varchar(255) DEFAULT NULL,
  `familyId` int DEFAULT NULL,
  `vliteral` varchar(255) DEFAULT NULL,
  `cliteral` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Bolcament de dades per a la taula `courses`
--

INSERT INTO `courses` (`id`, `course`, `familyId`, `vliteral`, `cliteral`) VALUES
(3, 'CFM APD (LOE)', 2, 'Atenció a persones en situació de dependència', 'Atención a personas en situación de dependencia'),
(4, 'CFM FARMACIA (LOE)', 6, 'Farmàcia i parafarmàcia', 'Farmacia y parafarmacia'),
(8, 'CFM CAE (LOGSE)', 6, 'Cures auxiliares d\'infermeria', 'Cuidados auxiliares de enfermería'),
(12, 'CFM CUINA (LOE)', 10, 'Cuina i gastronomia', 'Cocina y gastronomía');

-- --------------------------------------------------------

--
-- Estructura de la taula `families`
--

CREATE TABLE `families` (
  `id` int NOT NULL,
  `cliteral` varchar(255) DEFAULT NULL,
  `vliteral` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Bolcament de dades per a la taula `families`
--

INSERT INTO `families` (`id`, `cliteral`, `vliteral`) VALUES
(1, 'INGLES', 'ANGLES'),
(2, 'SERVICIOS A LA COMUNIDAD', 'SEVEIS A LA COMUNITAT'),
(3, 'IMAGEN PERSONAL', 'IMATGE PERSONAL'),
(5, 'DEPARTAMENTO ADMINISTRATIVO', 'DEPARTAMENT ADMINISTRACIÓ'),
(6, 'DEPARTAMENTO SANITARIO', 'DEPARTAMENT SANITARI'),
(9, 'EXTENSION CULTURAL', 'EXTENSIO CULTURAL'),
(10, 'HOSTELERIA Y TURISMO', 'HOSTELERIA I TURISME'),
(12, 'FORMACION Y ORIENTACION LABORA', 'FORMACIO I ORIENTACIO LABORAL'),
(18, 'ORIENTACION', 'ORIENTACIO'),
(24, 'DEPARTAMENTO INFORMATICA', 'DEPARTAMENT INFORMÀTICA'),
(25, 'Seguridad y Medio Ambiente', 'Seguretat i Medi Ambient');

-- --------------------------------------------------------

--
-- Estructura de la taula `modules`
--

CREATE TABLE `modules` (
  `code` varchar(10) NOT NULL,
  `cliteral` varchar(255) DEFAULT NULL,
  `vliteral` varchar(255) DEFAULT NULL,
  `courseId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de la taula `sales`
--

CREATE TABLE `sales` (
  `id` int NOT NULL,
  `bookId` int DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `status` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de la taula `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `isAdmin` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Bolcament de dades per a la taula `users`
--

INSERT INTO `users` (`id`, `email`, `nick`, `password`, `isAdmin`) VALUES
(12, 'ignasi@teleline.es', 'natxo', '$2y$10$9b43MDwO53/yHufk7WROueEtFnuftPaQUdzC1H0BNe7Q6o6BsIJN2', 0);

--
-- Índexs per a les taules bolcades
--

--
-- Índexs per a la taula `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD KEY `moduleCode` (`moduleCode`),
  ADD KEY `userId` (`userId`);

--
-- Índexs per a la taula `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `familyId` (`familyId`);

--
-- Índexs per a la taula `families`
--
ALTER TABLE `families`
  ADD PRIMARY KEY (`id`);

--
-- Índexs per a la taula `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`code`),
  ADD KEY `courseId` (`courseId`);

--
-- Índexs per a la taula `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookId` (`bookId`),
  ADD KEY `userId` (`userId`);

--
-- Índexs per a la taula `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT per les taules bolcades
--

--
-- AUTO_INCREMENT per la taula `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restriccions per a les taules bolcades
--

--
-- Restriccions per a la taula `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`moduleCode`) REFERENCES `modules` (`code`),
  ADD CONSTRAINT `books_ibfk_3` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Restriccions per a la taula `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`familyId`) REFERENCES `families` (`id`);

--
-- Restriccions per a la taula `modules`
--
ALTER TABLE `modules`
  ADD CONSTRAINT `modules_ibfk_1` FOREIGN KEY (`courseId`) REFERENCES `courses` (`id`);

--
-- Restriccions per a la taula `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `books` (`id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
