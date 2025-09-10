-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Temps de generació: 06-03-2023 a les 17:05:59
-- Versió del servidor: 8.0.32
-- Versió de PHP: 8.1.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de dades: `batoibook`
--

-- --------------------------------------------------------

--
-- Estructura de la taula `books`
--

CREATE TABLE `books` (
                         `id` int NOT NULL,
                         `idUser` int NOT NULL,
                         `idModule` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                         `publisher` varchar(50) COLLATE utf8mb4_es_0900_as_cs NOT NULL,
                         `price` decimal(10,0) NOT NULL DEFAULT '0',
                         `pages` smallint DEFAULT NULL,
                         `status` enum('new','good','used','bad') COLLATE utf8mb4_es_0900_as_cs NOT NULL DEFAULT 'good',
                         `photo` varchar(200) COLLATE utf8mb4_es_0900_as_cs NOT NULL,
                         `comments` text COLLATE utf8mb4_es_0900_as_cs NOT NULL,
                         `soldDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_es_0900_as_cs;

-- --------------------------------------------------------

--
-- Estructura de la taula `courses`
--

CREATE TABLE `courses` (
                           `id` int NOT NULL,
                           `cycle` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                           `idFamily` tinyint NOT NULL,
                           `vliteral` varchar(100) DEFAULT NULL,
                           `cliteral` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Bolcament de dades per a la taula `courses`
--

INSERT INTO `courses` (`id`, `cycle`, `idFamily`, `vliteral`, `cliteral`) VALUES
                                                                              (3, 'CFM APD (LOE)', 2, 'Atenció a persones en situació de dependència', 'Atención a personas en situación de dependencia'),
                                                                              (4, 'CFM FARMACIA (LOE)', 6, 'Farmàcia i parafarmàcia', 'Farmacia y parafarmacia'),
                                                                              (8, 'CFM CAE (LOGSE)', 6, 'Cures auxiliares d\'infermeria', 'Cuidados auxiliares de enfermería'),
(12, 'CFM CUINA (LOE)', 10, 'Cuina i gastronomia', 'Cocina y gastronomía'),
(16, 'CFM ESTÈTICA I BELL. (LOE)', 3, 'Estètica i bellesa', 'Estética y belleza'),
(18, 'CFM GESTIÓ ADMVA. (LOE)', 5, 'Gestió administrativa', 'Gestión administrativa'),
(20, 'CFM PERRUQUERIA (LOE)', 3, 'Perruqueria i cosmètica capilar', 'Peluquería y cosmética capilar'),
(22, 'CFM SERV. RESTAURACIÓ (LOE)', 10, 'Servicis en restauració', 'Servicios en restauración'),
(24, 'CFM SMX  (LOE)', 24, 'Sistemes microinformàtics i xarxes', 'Sistemas microinformáticos y redes'),
(28, 'CFS ADM. I FINANC. (LOE)', 5, 'Administració i finances', 'Administración y finanzas'),
(29, 'CFS ASSISTENCIA A LA DIRECCIÓ (LOE)', 5, 'Assitència a la direcció', 'Asistencia a la dirección'),
(30, 'CFS ASIX (LOE)', 24, 'Administració de sistemes informàtics en xarxa', 'Administración de sistemas informáticos en red'),
(32, 'CFS DAM (LOE)', 24, 'Desenrotllament d\'aplicacions multiplataforma', 'Desarrollo de aplicaciones multiplataforma'),
                                                                              (35, 'CFS DAW (LOE)', 24, 'Desenrotllament d\'aplicacions web', 'Desarrollo de aplicaciones  web'),
(36, 'CFS DIREC. CUINA (LOE)', 10, 'Direcció de cuina', 'Dirección de cocina'),
(38, 'CFS DIREC.RESTAURACIÓ (LOE)', 10, 'Direcció en servicis de restauració', 'Dirección en servicios de restauración'),
(39, 'CFS EDUC.INFANTIL (LOE)', 2, 'Educació infantil', 'Educación infantil'),
(42, 'CFS ESTET.INTEG. (LOE)', 3, 'Estètica integral i benestar', 'Estética integral y bienestar'),
(44, 'CFS INTEGR.SOCIAL (LOE)', 2, 'Integració Social', 'Integración Social'),
(45, 'CFS LABORATORI (LOE)', 6, 'Laboratori clínic i biomèdic', 'Laboratorio clinico y biomédico'),
(51, 'CFS RXMN (LOE)', 6, 'Imatge per al diagnòtic i medicina nuclear', 'Imagen para el diagnóstico y medicina nuclear'),
(54, 'CFS SALUT AMBIENTAL (LOGSE)', 6, 'Salut ambiental', 'Salud ambiental'),
(56, 'CFS TASOCIT (LOE)', 2, 'Animació Sociocultural i turística', 'Animación Sociocultural y turística'),
(57, 'TPB Perruqueria i Estética', 3, 'FP Bàsica Perruqueria i Estètica', 'FP Básica Peluqueria i Estética'),
(58, 'CFS QUIMICA I SALUT AMBIENTAL', 25, 'Química i Salut Ambiental', 'Química i Salut Ambiental'),
(59, 'MASTER CIBERSEGURETAT', 24, 'Curs d\'EspecialiTzació en Ciberseguretat en Entorns de les Tecnologies de la Información', 'Curso de Especialización en Ciberseguridad en Entornos de las Tecnologías de la Información');

-- --------------------------------------------------------

--
-- Estructura de la taula `families`
--

CREATE TABLE `families` (
                            `id` tinyint NOT NULL,
                            `cliteral` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                            `vliteral` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
                           `code` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                           `cliteral` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                           `vliteral` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                           `idCycle` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Bolcament de dades per a la taula `modules`
--

INSERT INTO `modules` (`code`, `cliteral`, `vliteral`, `idCycle`) VALUES
                                                                      ('0011', 'Didáctica de la educación infantil', 'Didàctica de l\'educación infantil', 39),
('0012', 'Autonomía personal y salud infantil', 'Autonomia personal i salut infantil', 39),
('0013', 'El juego infantil y su metodología', 'El joc infantil i la seua metodolog', 39),
('0014', 'Expresión y comunicación', 'Expressió i comunicació', 39),
('0015', 'Desarrollo cognitivo y motor', 'Desenrotllament cognitiu i motor', 39),
('0016', 'Desarrollo socioafectivo', 'Desenrotllament socioafectiu', 39),
('0017', 'Habilidades sociales', 'Habilitats socials', 39),
('0018', 'Intervención con familias y atenc.', 'Intervenció amb famílies i atenció ', 39),
('0020', 'Primeros auxilios', 'Primers auxilis', 3),
('0021', 'Formación y orientación laboral', 'Formació i orientació laboral', 39),
('0022', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 39),
('0026', 'Procesos básicos de pastelería y repostería', 'Processos bàsics de pastisseria i rebosteria', 12),
('0028', 'Postres en restauración', 'Postres en restauració', 12),
('0031', 'Seguridad e higiene en la manipulación de alimentos', 'Seguretat i higiene en la manipulació d\'aliments', 12),
                                                                      ('0045', 'Ofertas gastronómicas', 'Ofertes gastronòmiques', 12),
                                                                      ('0046', 'Preelaboración y conservación de al', 'Preelaboració i conservació d\'alime', 12),
('0047', 'Técnicas culinarias', 'Tècniques culinàries', 12),
('0048', 'Productos culinarios', 'Productes culinaris', 12),
('0049', 'Formación y orientación laboral', 'Formació i orientació laboral', 12),
('0050', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 12),
('0061', 'Anatomofisiología y patología básicas', 'Anatomofisiologia i patologia bàsiques', 4),
('0099', 'Disposición y venta de productos', 'Disposició i venda de productes', 4),
('0100', 'Oficina de farmacia', 'Oficina de farmàcia', 4),
('0101', 'Dispensación de productos farmaceút', 'Dispensació de productes farmacèut.', 4),
('0102', 'Dispensación de productos parafarm.', 'Dispensació de productes parafarmac', 4),
('0103', 'Operaciones básicas de laboratorio', 'Operacions bàsiques de laboratori', 4),
('0104', 'Formulación magistral', 'Formulació magistral', 4),
('0105', 'Promoción de la salud', 'Promoció de la salut', 4),
('0106', 'Formación y orientación laboral', 'Formació i orientació laboral', 4),
('0107', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 4),
('0150', 'Operaciones básicas en bar-cafeterí', 'Operacions bàsiques en bar cafeteri', 22),
('0151', 'Operaciones básicas en restaurante', 'Operacions bàsiques en restaurant', 22),
('0152', 'Servicios en bar-cafetería', 'Servicis en bar cafeteria', 22),
('0153', 'Servicios en restaurante y eventos ', 'Servicis en restaurant i esdevenime', 22),
('0154', 'El vino y su servicio', 'El vi i el seu servici', 22),
('0155', 'Técnicas de comunicación en restaur', 'Tècniques de comunicació en restaur', 22),
('0156', 'Inglés', 'Anglés', 18),
('0157', 'Formación y orientación laboral', 'Formació i orientació laboral', 22),
('0158', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 22),
('0179', 'Inglés', 'Anglés', 28),
('0180', 'Segunda lengua extranjera', 'Segona Llengua estrangera', 38),
('0210', 'Organización de la atención a las personas en situación dedependencia', 'Organització de l\'atenció a les persones en situació de dependència', 3),
                                                                      ('0211', 'Destrezas sociales', 'Destreses socials', 3),
                                                                      ('0212', 'Características y necesidades de las personas en situación de dependencia', 'Característiques i necessitats de les persones en situació de dependència', 3),
                                                                      ('0213', 'Atención y apoyo psicosocial', 'Atenció i suport psicosocial', 3),
                                                                      ('0214', 'Apoyo a la comunicación', 'Suport a la comunicació', 3),
                                                                      ('0215', 'Apoyo domiciliario', 'Suport domiciliari', 3),
                                                                      ('0216', 'Atención sanitaria', 'Atenció sanitària', 3),
                                                                      ('0217', 'Atención higiénica', 'Atenció higiènica', 3),
                                                                      ('0218', 'Formación y orientación laboral.', 'Formació i orientació laboral.', 3),
                                                                      ('0219', 'Empresa e iniciativa emprendedora.', 'Empresa i iniciativa emprenedora.', 3),
                                                                      ('0221', 'Montaje y mantenimiento de equipos', 'Muntatge i manteniment d\'equips', 24),
('0222', 'Sistemas operativos monopuesto', 'Sistemes operatius monolloc', 24),
('0223', 'Aplicaciones ofimáticas', 'Aplicacions ofimàtiques', 24),
('0224', 'Sistemas operativos en red', 'Sistemes operatius en xarxa', 24),
('0225', 'Redes locales', 'Xarxes locals', 24),
('0226', 'Seguridad informática', 'Seguretat informàtica', 24),
('0227', 'Servicios en red', 'Servicis en xarxa', 24),
('0228', 'Aplicaciones web', 'Aplicacions web', 24),
('0229', 'Formación y orientación laboral', 'Formació i orientació laboral', 24),
('0230', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 24),
('028001', 'Formación y orientación laboral', 'Formació i orientació laboral', 8),
('028100', 'Relaciones en el equipo de trabajo', 'Relacions en l\'equip de treball', 8),
                                                                      ('028501', 'Operaciones administrativas y documentación sanitaria', 'Operacions administratives i documentació sanitària', 8),
                                                                      ('028502', 'Técnicas básicas de enfermería', 'Tècniques bàsiques d\'infermeria', 8),
('028503', 'Higiene del medio hospitalario y limpieza de material', 'Higiene del medi hospitalari i neteja de material', 8),
('028504', 'Promoción de la salud y apoyo psicológico al paciente', 'Promoció de la salut i suport psicològic al pacient', 8),
('028505', 'Técnicas de ayuda odontológica/estomatológica', 'Tècniques d\'ajuda odontològica/estomatològica', 8),
                                                                      ('029001', 'Formación y orientación laboral', 'Formació i orientació laboral', 54),
                                                                      ('029506', 'Organización y gestión de la unidad', 'Organització i gestió de la unitat ', 54),
                                                                      ('029507', 'Aguas de uso y consumo', 'Aigües d\'ús i consum', 54),
('029508', 'Residuos sólidos y medio construido', 'Residus sòlids i medi construït', 54),
('029509', 'Control y vigilancia de la contamin', 'Control i vigilància de la contam.', 54),
('029510', 'Contaminación atmosférica, ruidos ', 'Contaminació atmosfèrica, sorolls', 54),
('029511', 'Productos químicos y vectores ', 'Productes químics i vectors ', 54),
('029512', 'Educación sanitaria y promoción ', 'Educació sanitària i promoció ', 54),
('0337', 'Contexto de la intervención social', 'Context de la intervenció social', 44),
('0338', 'Inserción sociolaboral', 'Inserció sociolaboral', 44),
('0339', 'Atención a las unidades de convivencia', 'Atenció a les unitats de convivència', 44),
('0340', 'Mediación comunitaria', 'Mediació comunitària', 44),
('0341', 'Apoyo a la intervención educativa', 'Suport a la intervenció educativa', 44),
('0342', 'Promoción de la autonomía personal', 'Promoció de l\'autonomia personal', 44),
                                                                      ('0343', 'Sistemas alternativos y aumentativos de comunicación', 'Sistemes alternatius i augmentatius de comunicació', 44),
                                                                      ('0344', 'Metodología de la intervención social', 'Metodologia de la intervenció social', 44),
                                                                      ('0346', 'Formación y orientación laboral', 'Formació i orientació laboral', 44),
                                                                      ('0347', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 44),
                                                                      ('0369', 'Implantación de Sistemas Operativos', 'Implantació de Sistemes Operatius', 30),
                                                                      ('0370', 'Planificación y Administración de Redes', 'Planificació i Administració de Xarxes', 30),
                                                                      ('0371', 'Fundamentos de Hardware', 'Fonaments de Maquinari', 30),
                                                                      ('0372', 'Gestión de Bases de Datos', 'Gestió de Bases de Dades', 30),
                                                                      ('0373', 'Lenguajes de marcas y sistemas de gestión de información', 'Llenguatges de marques i sistemes de gestió d\'informació', 30),
('0374', 'Administración de Sistemas Operativos', 'Administració de Sistemes Operatius', 30),
('0375', 'Servicios de Red e Internet', 'Servicis de Xarxa i Internet', 30),
('0376', 'Implantación de Aplicaciones Web', 'Implantació d\'Aplicacions Web', 30),
                                                                      ('0377', 'Administración de Sistemas Gestores de Bases de Datos', 'Administració de Sistemes Gestors de Bases de Dades', 30),
                                                                      ('0378', 'Seguridad y Alta Disponibilidad', 'Seguretat i Alta Disponibilitat', 30),
                                                                      ('0380', 'Formación y orientación laboral', 'Formació i orientació laboral', 30),
                                                                      ('0381', 'Empresa e Iniciativa emprendedora', 'Empresa i Iniciativa emprenedora', 30),
                                                                      ('0437', 'Comunicación empresarial y atención al cliente', 'Comunicació empresarial i atenció al client', 18),
                                                                      ('0438', 'Operaciones administrativa de compra-venta', 'Operacions administrativa de compra-venda', 18),
                                                                      ('0439', 'Empresa y administración', 'Empresa i administració', 18),
                                                                      ('0440', 'Tratamiento informático de la información ', 'Tractament informàtic de la informació ', 18),
                                                                      ('0441', 'Técnica contable', 'Tècnica comptable', 18),
                                                                      ('0442', 'Operaciones administrativas de recursos humanos', 'Operacions administratives de recursos humans', 18),
                                                                      ('0443', 'Tratamiento de la documentación contable', 'Tractament de la documentació comptable', 18),
                                                                      ('0446', 'Empresa en el aula', 'Empresa en l\'aula', 18),
('0448', 'Operaciones auxiliares de gestión de tesorería', 'Operacions auxiliars de gestió de tresoreria', 18),
('0449', 'Formación y orientación laboral', 'Formació i orientació laboral', 18),
('0483', 'Sistemas informáticos', 'Sistemes informàtics', 32),
('0484', 'Bases de Datos', 'Bases de Dades', 32),
('0485', 'Programación', 'Programació', 32),
('0486', 'Acceso a datos', 'Accés a dades', 32),
('0487', 'Entornos de desarrollo', 'Entorns de desenrotllament', 32),
('0488', 'Desarrollo de interfaces', 'Desenrotllament d\'interfícies', 32),
                                                                      ('0489', 'Programación multimedia y dispositivos móviles', 'Programació multimèdia i dispositius mòbils', 32),
                                                                      ('0490', 'Programación de servicios y procesos', 'Programació de servicis i processos', 32),
                                                                      ('0491', 'Sistemas de gestión empresarial', 'Sistemes de gestió empresarial', 32),
                                                                      ('0493', 'Formación y orientación laboral', 'Formació i orientació laboral', 32),
                                                                      ('0494', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 32),
                                                                      ('0496', 'Control del aprovisionamiento de materias primas', 'Control de l\'aprovisionament  de matèries primeres', 36),
('0497', 'Procesos de preelaboración y conservación en cocina', 'Processos de preelaboració i conservació en cuina', 36),
('0498', 'Elaboraciones de pastelería y repostería', 'Elaboracions de pastisseria i rebosteria', 36),
('0499', 'Procesos de elaboración culinaria', 'Processos d\'elaboració culinària', 36),
                                                                      ('0500', 'Gestión de la producción en cocina', 'Gestión de la producción en cocina', 36),
                                                                      ('0501', 'Gestión de la calidad y de la seguridad e higiene alimentaria', 'Gestió de la qualitat i de la seguretat i higiene alimentàries', 36),
                                                                      ('0502', 'Gastronomía y nutrición', 'Gastronomia i nutrició', 36),
                                                                      ('0503', 'Gestión administrativa y comercial en restauración', 'Gestió administrativa i comercial en restauració', 36),
                                                                      ('0504', 'Recursos humanos y dirección de equipos en restauración', 'Recursos humans i direcció d\'equips en restauració', 36),
('0506', 'Formación y orientación laboral', 'Formació i orientació laboral', 36),
('0507', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 36),
('0509', 'Procesos de servicios en bar-cafetería', 'Processos de servicis en bar-cafeteria', 38),
('0510', 'Procesos de servicios en restaurante', 'Processos de servicis en restaurant', 38),
('0511', 'Sumillería', 'Sumilleria', 38),
('0512', 'Planificación y dirección de servicios y eventos en restauración', 'Planificació i direcció de servicis i esdeveniments en restauració', 38),
('0514', 'Formación y orientación laboral', 'Formació i orientació laboral', 38),
('0515', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 38),
('0612', 'Desarrollo WEB en entorno cliente', 'Desenrotllament WEB en entorn client', 35),
('0613', 'Desarrollo WEB en entorno servidor', 'Desenrotllament WEB en entorn servidor', 35),
('0614', 'Despliegue de aplicaciones WEB', 'Desplegament d\'aplicacions WEB', 35),
                                                                      ('0615', 'Diseño de interfaces WEB', 'Disseny d\'interfícies WEB', 35),
('0617', 'Formación y orientación laboral', 'Formació i orientació laboral', 35),
('0618', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 35),
('0633', 'Técnicas de higiene facial y corporal', 'Tècniques d\'higiene facial i corporal', 16),
                                                                      ('0634', 'Maquillaje', 'Maquillatge', 16),
                                                                      ('0635', 'DEPILACIÓN MECÁNICA Y DECOLORACIÓN DEL VELLO', 'DEPILACIÓ MECÀNICA I DECOLORACIÓ DEL BORRISSOL', 16),
                                                                      ('0636', 'Estética de manos y pies', 'Estètica de mans i peus', 16),
                                                                      ('0637', 'TÉCNICAS DE UÑAS ARTIFICIALES', 'TÈCNIQUES D\'UNGLES ARTIFICIALS', 16),
('0638', 'Análisis estético', 'Anàlisi estètica', 16),
('0639', 'ACTIVIDADES EN CABINA DE ESTÉTICA', 'ACTIVITATS EN CABINA D\'ESTÈTICA', 16),
                                                                      ('0640', 'Imagen corporal y hábitos saludables', 'Imatge corporal i hàbits saludables', 16),
                                                                      ('0641', 'Cosmetología para estética y belleza', 'Cosmetologia per a estètica i bellesa', 16),
                                                                      ('0642', 'PERFUMERÍA Y COSMÉTICA NATURAL', 'PERFUMERIA I COSMÈTICA NATURAL', 16),
                                                                      ('0643', 'Marketing y venta en imagen personal', 'Màrqueting i venda en imatge personal.', 16),
                                                                      ('0644', 'FORMACIÓN Y ORIENTACIÓN LABORAL', 'FORMACIÓ I ORIENTACIÓ LABORAL', 16),
                                                                      ('0645', 'EMPRESA E INICIATIVA EMPRENDEDORA', 'EMPRESA I INICIATIVA EMPRENEDORA', 16),
                                                                      ('0647', 'Gestión de la documentación jurídica y empresarial', 'Gestió de la documentació jurídica i empresarial', 28),
                                                                      ('0648', 'Recursos humanos y responsabilidad social corporativa', 'Recursos humans i responsabilitat social corporativa ', 28),
                                                                      ('0649', 'Ofimática y proceso de la información', 'Ofimàtica i procés de la informació', 28),
                                                                      ('0650', 'Proceso integral de la actividad comercial', 'Procés integral de l\'activitat comercial', 28),
('0651', 'Comunicación y atención al cliente', 'Comunicació i atenció al client', 28),
('0652', 'Gestión de recursos humanos', 'Gestió de recursos humans', 28),
('0653', 'Gestión financiera', 'Gestió financera ', 28),
('0654', 'Contabilidad y fiscalidad', 'Comptabilitat i fiscalitat', 28),
('0655', 'Gestión logística y comercial', 'Gestió logística i comercial', 28),
('0656', 'Simulación empresarial', 'Simulació empresarial', 28),
('0658', 'Formación y orientación laboral', 'Formació i orientació laboral', 28),
('0665', 'Formación y orientación laboral', 'Formació i orientació laboral', 29),
('0744', 'Aparatología estética', 'Aparellologia estètica ', 42),
('0745', 'Estética hidrotermal', 'Estètica hidrotermal', 42),
('0746', 'Depilación avanzada', 'Depilació avançada', 42),
('0747', 'Masaje estético', 'Massatge estètic', 42),
('0748', 'Drenaje estético y técnicas por presión', 'Drenatge estètic i tècniques per pressió', 42),
('0749', 'Micropigmentación', 'Micropigmentació', 42),
('0750', 'Procesos fisiológicos y de higiene en imagen personal ', 'Processos fisiològics i d\'higiene en imatge personal', 42),
                                                                      ('0751', 'Dermoestética', 'Dermoestètica', 42),
                                                                      ('0752', 'Cosmética aplicada a estética y bienestar ', 'Cosmètica aplicada a estètica i benestar', 42),
                                                                      ('0753', 'Tratamientos estéticos integrales', 'Tractaments estètics integrals', 42),
                                                                      ('0755', 'Formación y orientación laboral ', 'Formació i orientació laboral', 42),
                                                                      ('0756', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 42),
                                                                      ('0831', 'Teleasistencia', 'Teleasistència', 3),
                                                                      ('0842', 'Peinados y recogidos', 'Pentinats i arreplegats', 20),
                                                                      ('0843', 'Coloración capilar', 'Coloració capil·lar', 20),
                                                                      ('0844', 'Cosmética para peluquería', 'Cosmètica per a perruqueria', 20),
                                                                      ('0845', 'Técnicas de corte del cabello', 'Tècniques de tall del cabell', 20),
                                                                      ('0846', 'Cambios de forma permanente del cabello', 'Canvis de forma permanent del cabell', 20),
                                                                      ('0848', 'Peluquería y estilismo masculino', 'Perruqueria i estilisme masculí', 20),
                                                                      ('0849', 'Análisis capilar', 'Anàlisi capil·lar', 20),
                                                                      ('0851', 'Formación y orientación laboral', 'Formació i orientació laboral.', 20),
                                                                      ('0852', 'Empresa e iniciativa emprendedora.', 'Empresa i iniciativa emprenedora.', 20),
                                                                      ('1123', 'ACTIVIDADES DE OCIO Y TIEMPO LIBRE', 'ACTIVITATS D\'OCI I TEMPS LLIURE', 56),
('1124', 'DINAMIZACIÓN GRUPAL', 'DINAMITZACIÓ GRUPAL', 56),
('1125', 'ANIMACIÓN Y GESTIÓN CULTURAL', 'ANIMACIÓ I GESTIÓ CULTURAL', 56),
('1126', 'ANIMACIÓN TURÍSTICA', 'ANIMACIÓ TURÍSTICA', 56),
('1128', 'Desarrollo comunitario', 'Desenrotllament comunitari', 56),
('1129', 'INFORMACIÓN JUVENIL', 'INFORMACIÓ JUVENIL', 56),
('1130', 'INTERVENCIÓN SOCIOEDUCATIVA CON JÓVENES', 'INTERVENCIÓ SOCIOEDUCATIVA AMB JÓVENS', 56),
('1131', 'CONTEXTO DE LA ANIMACIÓN SOCIOCULTURAL', 'CONTEXT DE L\'ANIMACIÓ SOCIOCULTURAL', 56),
                                                                      ('1133', 'FORMACIÓN Y ORIENTACIÓN LABORAL', 'FORMACIÓ I ORIENTACIÓ LABORAL', 56),
                                                                      ('1134', 'EMPRESA E INICIATIVA EMPRENDEDORA', 'EMPRESA I INICIATIVA EMPRENEDORA', 56),
                                                                      ('1345', 'Atención al paciente', 'Atenció al pacient', 51),
                                                                      ('1346', 'Fundamentos físicos y equipos', 'Fonaments físics i equips', 51),
                                                                      ('1347', 'Anatomía por la imagen', 'Anatomia per la imatge', 51),
                                                                      ('1348', 'Protección radiológica', 'Protecció radiològica', 51),
                                                                      ('1349', 'Técnicas de radiología simple', 'Tècniques de radiologia simple', 51),
                                                                      ('1350', 'Técnicas de radiología especial', 'Tècniques de radiologia especial', 51),
                                                                      ('1351', 'Técnicas de tomografía computarizada y ecografía', 'Tècniques de tomografia computada i ecografia', 51),
                                                                      ('1352', 'Técnicas de imagen por resonancia magnética', 'Tècniques d¿imatge per ressonància magnètica', 51),
                                                                      ('1353', 'Técnicas de imagen en medicina nuclear', 'Tècniques d¿imatge en medicina nuclear', 51),
                                                                      ('1354', 'Técnicas de radiofarmacia', 'Tècniques de radiofarmàcia', 51),
                                                                      ('1355', 'Proyecto de imagen para el diagnóstico y medicina nuclear', 'Projecte d¿Imatge per al Diagnòstic i Medicina Nuclear', 51),
                                                                      ('1356', 'Formación y orientación laboral', 'Formació i orientació laboral', 51),
                                                                      ('1357', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 51),
                                                                      ('1358', 'Formación en centros de trabajo', 'Formació en Centres de Treball', 51),
                                                                      ('1367', 'Gestión de muestras biológicas', 'Gestió de mostres biològiques', 45),
                                                                      ('1368', 'Técnicas generales de laboratorio', 'Tècniques generals de laboratori', 45),
                                                                      ('1369', 'Biología molecular y citogenética', 'Biologia molecular i citogenètica', 45),
                                                                      ('1370', 'Fisiopatología general', 'Fisiopatologia general', 45),
                                                                      ('1371', 'Análisis bioquímico', 'Anàlisi bioquímica', 45),
                                                                      ('1372', 'Técnicas de inmunodiagnóstico', 'Tècniques d¿immunodiagnòstic', 45),
                                                                      ('1373', 'Microbiología clínica', 'Microbiologia clínica', 45),
                                                                      ('1374', 'Técnicas de análisis hematológico', 'Tècniques d¿anàlisi hematològica', 45),
                                                                      ('1376', 'Formación y orientación laboral', 'Formació i orientació laboral', 45),
                                                                      ('1377', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 45),
                                                                      ('1546', 'Sistemas de gestión ambiental', 'Sistemes de gestió ambiental', 58),
                                                                      ('1547', 'Educación para la salud y el medio ambiente', 'Educació per a la salut i el medi ambient', 58),
                                                                      ('1548', 'Control de aguas', 'Control d\'aigües', 58),
('1549', 'Control de residuos', 'Control de residus', 58),
('1550', 'Salud y riesgos del medio construido', 'Salut i riscos del mig construït', 58),
('1551', 'Control y seguridad alimentaria', 'Control i seguretat alimentària', 58),
('1552', 'Contaminación ambiental y atmosférica', 'Contaminació ambiental i atmosfèrica', 58),
('1553', 'Control de organismos nocivos', 'Control d\'organismes nocius', 58),
                                                                      ('1554', 'Unidad de salud ambiental', 'Unitat de salut ambiental', 58),
                                                                      ('1556', 'Formación y orientación laboral', 'Formació i orientació laboral', 58),
                                                                      ('1557', 'Empresa e iniciativa emprendedora', 'Empresa i iniciativa emprenedora', 58),
                                                                      ('3005', 'Atención al cliente', 'Atenció al client', 57),
                                                                      ('3009', 'Ciencias Aplicadas I', 'Ciències aplicades I', 57),
                                                                      ('3011', 'Comunicación y Sociedad I', 'Comunicació i societat I', 57),
                                                                      ('3011cv', 'Castellano-Valenciano', 'Castellà-Valencià', 57),
                                                                      ('3011e', 'Lengua Extranjera', 'Llengua Estrangera', 57),
                                                                      ('3011s', 'Ciencias Sociales ', 'Ciències Socials ', 57),
                                                                      ('3012', 'Comunicación y Sociedad II', 'Comunicació i Societat II', 57),
                                                                      ('3012cv', 'Castellano-Valenciano II', 'Castellà-Valencià II', 57),
                                                                      ('3012e', 'Lengua Extranjera II', 'Llengua Estrangera II', 57),
                                                                      ('3012s', 'Ciencias Sociales II', 'Ciències Socials II', 57),
                                                                      ('3042', 'Ciencias Aplicadas II', 'Ciències Aplicades II', 57),
                                                                      ('3060', 'Preparación del entorno profesional', 'Preparació de l\'entorn professional', 57),
('3061', 'Cuidados estéticos básicos de uñas', 'Cures estètiques bàsiques d\'ungles', 57),
                                                                      ('3062', 'Depilación mecánica y decoloración del vello superfluo', 'Depilació mecànica i decoloració del borrissol superflu', 57),
                                                                      ('3063', 'Maquillaje', 'Maquillatge', 57),
                                                                      ('3064', 'Lavado y cambios de forma del cabello', 'Llavat i canvis de forma del cabell', 57),
                                                                      ('3065', 'Cambio de color del cabello', 'Canvi de color del cabell', 57),
                                                                      ('3067p', 'Formación en centros de trabajo (UF1)', 'Formació en centres de treball (UF1)', 57),
                                                                      ('5021', 'Incidentes de ciberseguridad', 'Incidents de ciberseguretat', 59),
                                                                      ('5022', 'Bastionado de redes y sistemas', 'Bastionado de xarxes i sistemes', 59),
                                                                      ('5023', 'Puesta en producción segura', 'Posada en producció segura', 59),
                                                                      ('5024', 'Análisis forense informático', 'Anàlisi forense informàtic', 59),
                                                                      ('5025', 'Hacking ético', 'Hacking ètic', 59),
                                                                      ('5026', 'Normativa de ciberseguridad', 'Normativa de ciberseguretat', 59),
                                                                      ('CV0001', 'Inglés Técnico I-M / Horario reservado para la docencia en inglés', 'Anglés Tècnic I-M / Horari reservat per a la docència en anglés', 3),
                                                                      ('CV0002', 'Inglés Técnico II-M / Horario reservado para la docencia en inglés', 'Anglés Tècnic II-M / Horari reservat per a la docència en anglés', 3),
                                                                      ('CV0003', 'Inglés Técnico I-S / Horario reservado para la docencia en inglés', 'Inglés Técnico I-S / Horario reservado para la docencia en inglés', 28),
                                                                      ('CV0004', 'Inglés Técnico II-S / Horario reservado para la docencia en inglés', 'Anglés Tècnic II-S / Horari reservat per a la docència en anglés', 28),
                                                                      ('CV0005', 'Formación y orientación laboral ', 'Formació i orientació laboral ', 57),
                                                                      ('CV0006', 'Formación y Orientación Laboral II', 'Formació i Orientació Laboral II', 57);

-- --------------------------------------------------------

--
-- Estructura de la taula `sales`
--

CREATE TABLE `sales` (
                         `id` int NOT NULL,
                         `idBook` int NOT NULL,
                         `idUser` int NOT NULL,
                         `date` date NOT NULL,
                         `status` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_es_0900_as_cs;

-- --------------------------------------------------------

--
-- Estructura de la taula `users`
--

CREATE TABLE `users` (
                         `id` int NOT NULL,
                         `email` varchar(100) COLLATE utf8mb4_es_0900_as_cs NOT NULL,
                         `nick` varchar(100) COLLATE utf8mb4_es_0900_as_cs NOT NULL,
                         `password` varchar(100) COLLATE utf8mb4_es_0900_as_cs NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_es_0900_as_cs;

--
-- Bolcament de dades per a la taula `users`
--

INSERT INTO `users` (`id`, `email`, `nick`, `password`) VALUES
    (2, 'ignasi.gomis.mullor@gmail.com', 'Ignasi', '81dc9bdb52d04dc20036dbd8313ed055');

--
-- Índexs per a les taules bolcades
--

--
-- Índexs per a la taula `books`
--
ALTER TABLE `books`
    ADD PRIMARY KEY (`id`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `books_modules` (`idModule`);

--
-- Índexs per a la taula `courses`
--
ALTER TABLE `courses`
    ADD PRIMARY KEY (`id`),
  ADD KEY `ciclos_departamento_foreign` (`idFamily`);

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
  ADD KEY `modules_cycles` (`idCycle`);

--
-- Índexs per a la taula `sales`
--
ALTER TABLE `sales`
    ADD PRIMARY KEY (`id`),
  ADD KEY `salesUsers` (`idUser`),
  ADD KEY `salesBooks` (`idBook`);

--
-- Índexs per a la taula `users`
--
ALTER TABLE `users`
    ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT per les taules bolcades
--

--
-- AUTO_INCREMENT per la taula `books`
--
ALTER TABLE `books`
    MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la taula `courses`
--
ALTER TABLE `courses`
    MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT per la taula `sales`
--
ALTER TABLE `sales`
    MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la taula `users`
--
ALTER TABLE `users`
    MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restriccions per a les taules bolcades
--

--
-- Restriccions per a la taula `books`
--
ALTER TABLE `books`
    ADD CONSTRAINT `books_modules` FOREIGN KEY (`idModule`) REFERENCES `modules` (`code`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `books_users` FOREIGN KEY (`idUser`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restriccions per a la taula `courses`
--
ALTER TABLE `courses`
    ADD CONSTRAINT `cycle_family` FOREIGN KEY (`idFamily`) REFERENCES `families` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restriccions per a la taula `modules`
--
ALTER TABLE `modules`
    ADD CONSTRAINT `modules_cycles` FOREIGN KEY (`idCycle`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restriccions per a la taula `sales`
--
ALTER TABLE `sales`
    ADD CONSTRAINT `salesBooks` FOREIGN KEY (`idBook`) REFERENCES `books` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `salesUsers` FOREIGN KEY (`idUser`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;