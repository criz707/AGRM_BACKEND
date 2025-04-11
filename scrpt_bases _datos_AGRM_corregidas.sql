CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`perfil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`perfil` (
  `ID_PERFIL` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico del perfil en la base de datos de perfiles',
  `NOMBRE` VARCHAR(45) NOT NULL COMMENT 'Nombre del perfil',
  `CORREO` VARCHAR(45) NOT NULL COMMENT 'Corre del perfil',
  `FOTO` VARCHAR(45) NOT NULL COMMENT 'Url de la foto del perfil',
  `CONTRASENA` VARCHAR(45) NOT NULL COMMENT 'Contrasena del perfil',
  PRIMARY KEY (`ID_PERFIL`));


-- -----------------------------------------------------
-- Table `mydb`.`administrador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`administrador` (
  `ID_ADMINISTRADOR` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id del administrador, brinda una diferencia entre el perfil general, y el perfil de administrador',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_ADMINISTRADOR`, `ID_PERFIL`),
  INDEX `fk_administrador_perfil1_idx` (`ID_PERFIL` ASC),
  CONSTRAINT `fk_administrador_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));


-- -----------------------------------------------------
-- Table `mydb`.`gerente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`gerente` (
  `ID_GERENTE` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico de los perfiles de gerente',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_GERENTE`, `ID_PERFIL`),
  INDEX `fk_gerente_perfil1_idx` (`ID_PERFIL` ASC) ,
  CONSTRAINT `fk_gerente_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));


-- -----------------------------------------------------
-- Table `mydb`.`mesa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mesa` (
  `ID_MESA` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificadror unico de la mesa',
  `NUMERO` VARCHAR(10) NOT NULL COMMENT 'Numero con el que se identifica la mesa',
  `SILLAS` VARCHAR(10) NOT NULL COMMENT 'Numero de sillas que posee la mesa',
  `ADMINISTRADOR_ID_ADMINISTRADOR` INT(11) NOT NULL COMMENT 'Llave foranea que conecta al administrador con las multiples reseravas',
  PRIMARY KEY (`ID_MESA`, `ADMINISTRADOR_ID_ADMINISTRADOR`),
  INDEX `fk_MESA_ADMINISTRADOR1_idx` (`ADMINISTRADOR_ID_ADMINISTRADOR` ASC) ,
  CONSTRAINT `fk_MESA_ADMINISTRADOR1`
    FOREIGN KEY (`ADMINISTRADOR_ID_ADMINISTRADOR`)
    REFERENCES `mydb`.`administrador` (`ID_ADMINISTRADOR`));



-- -----------------------------------------------------
-- Table `mydb`.`recepcionista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`recepcionista` (
  `ID_RECEPCIONISTA` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id que diferencia a los tipos de perfil de recepcionistas',
  `perfil_ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_RECEPCIONISTA`, `perfil_ID_PERFIL`),
  INDEX `fk_recepcionista_perfil1_idx` (`perfil_ID_PERFIL` ASC) ,
  CONSTRAINT `fk_recepcionista_perfil1`
    FOREIGN KEY (`perfil_ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));
-- -----------------------------------------------------
-- Table `mydb`.`reporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reporte` (
  `ID_REPORTE` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico del reporte',
  `FECHA` DATETIME NOT NULL COMMENT 'Fecha en la que se genero el reporte, tiene un limite de uno por mes por cuestiones de almacenamiento',
  `URL` VARCHAR(45) NOT NULL COMMENT 'Url de donde se almaceno el reporte',
  `ID_GERENTE` INT(11) NOT NULL COMMENT 'Id del gerente que genero el reporte',
  PRIMARY KEY (`ID_REPORTE`, `ID_GERENTE`),
  INDEX `fk_REPORTE_GERENTE1_idx` (`ID_GERENTE` ASC) ,
  CONSTRAINT `fk_REPORTE_GERENTE1`
    FOREIGN KEY (`ID_GERENTE`)
    REFERENCES `mydb`.`gerente` (`ID_GERENTE`));

-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `ID_USUARIO` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id del usuario , separa a todos los periles de tipo usuario',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_USUARIO`, `ID_PERFIL`),
  UNIQUE INDEX `idtable1_UNIQUE` (`ID_USUARIO` ASC) ,
  INDEX `fk_usuario_perfil1_idx` (`ID_PERFIL` ASC) ,
  CONSTRAINT `fk_usuario_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));

-- -----------------------------------------------------
-- Table `mydb`.`reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reserva` (
  `ID_RESERVA` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico de la reserva',
  `ID_USUARIO` INT(11) NOT NULL COMMENT 'Id del usuario que realiza la reserva',
  `ID_MESA` INT(11) NOT NULL COMMENT 'Identificador unico de la mesa',
  `FECHA` DATETIME NOT NULL COMMENT 'Fecha en la que se llevara a cabo la reserva',
  `HORA_INICIO` DATETIME NOT NULL COMMENT 'Hora en la que inicia la reserva, despues de trancuridos 15 minutos se libera para el uso libre',
  `HORA_FINAL` DATETIME NOT NULL COMMENT 'La hora en la que termina la reserva, se tiene planes a futuro de  implementar una notificacion  para que avise al usuario para que se prepare con quince minutos de antelacion',
  `ID_RECEPCIONISTA` INT(11) NOT NULL COMMENT 'Id del recepcioista que confirma el uso de la reserva',
  PRIMARY KEY (`ID_RESERVA`, `ID_USUARIO`, `ID_MESA`, `ID_RECEPCIONISTA`),
  INDEX `fk_USUARIO_has_MESA_MESA1_idx` (`ID_MESA` ASC) ,
  INDEX `fk_USUARIO_has_MESA_USUARIO_idx` (`ID_USUARIO` ASC) ,
  INDEX `fk_RESERVA_RECEPCIONISTA1_idx` (`ID_RECEPCIONISTA` ASC),
  CONSTRAINT `fk_RESERVA_RECEPCIONISTA1`
    FOREIGN KEY (`ID_RECEPCIONISTA`)
    REFERENCES `mydb`.`recepcionista` (`ID_RECEPCIONISTA`),
  CONSTRAINT `fk_USUARIO_has_MESA_MESA1`
    FOREIGN KEY (`ID_MESA`)
    REFERENCES `mydb`.`mesa` (`ID_MESA`),
  CONSTRAINT `fk_USUARIO_has_MESA_USUARIO`
    FOREIGN KEY (`ID_USUARIO`)
    REFERENCES `mydb`.`usuario` (`ID_USUARIO`));
    
    
    
-- -----------------------------------------------------
-- Table `mydb`.`Actualiza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Actualiza` (
  `ID_ADMINISTRADOR` INT(11) NOT NULL,
  `ID_PERFIL` INT(11) NOT NULL,
  `perfil_ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_ADMINISTRADOR`, `ID_PERFIL`, `perfil_ID_PERFIL`),
  INDEX `fk_administrador_has_perfil_perfil1_idx` (`perfil_ID_PERFIL` ASC) ,
  INDEX `fk_administrador_has_perfil_administrador1_idx` (`ID_ADMINISTRADOR` ASC, `ID_PERFIL` ASC) ,
  CONSTRAINT `fk_administrador_has_perfil_administrador1`
    FOREIGN KEY (`ID_ADMINISTRADOR` , `ID_PERFIL`)
    REFERENCES `mydb`.`administrador` (`ID_ADMINISTRADOR` , `ID_PERFIL`),
  CONSTRAINT `fk_administrador_has_perfil_perfil1`
    FOREIGN KEY (`perfil_ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));