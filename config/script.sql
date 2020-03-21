USE damianir_rosiki;

CREATE TABLE `MATCH`
(
    ID_MATCH           INTEGER       PRIMARY KEY, 
    MATCH_NAME         VARCHAR(256)  UNIQUE,
    `DATE`             DATE          NOT NULL,
    ID_WINNING_PLAYER  TINYINT
);

CREATE TABLE TARGET_CARD
(
    ID_CARD      TINYINT       NOT NULL,
    DESCRIPTION  VARCHAR(256)  NOT NULL,

    PRIMARY KEY (ID_CARD)
);

CREATE TABLE PLAYER
(
    ID_PLAYER       TINYINT  NOT NULL,
    ID_MATCH        INTEGER  NOT NULL,
    COLOUR          CHAR(1),
    NICKNAME        VARCHAR(256),
    ID_TARGET_CARD  TINYINT,
    TURN_POSITION   TINYINT,
    N_TROOPS        SMALLINT DEFAULT 0,
    
    PRIMARY KEY (ID_PLAYER, ID_MATCH),
    FOREIGN KEY (ID_MATCH) REFERENCES `MATCH`(ID_MATCH) ON DELETE CASCADE,
    FOREIGN KEY (ID_TARGET_CARD) REFERENCES TARGET_CARD(ID_CARD),
    CHECK (COLOUR IN('R', 'N', 'G', 'V', 'B', 'U'))
);

CREATE TABLE TURN
(
    ID_TURN    INTEGER  DEFAULT 0,
    ID_MATCH   INTEGER  NOT NULL,
    ID_PLAYER  TINYINT  NOT NULL,
 
    PRIMARY KEY (ID_TURN, ID_MATCH),
    FOREIGN KEY (ID_MATCH) REFERENCES `MATCH`(ID_MATCH) ON DELETE CASCADE,
    FOREIGN KEY (ID_PLAYER, ID_MATCH) REFERENCES PLAYER(ID_PLAYER, ID_MATCH) ON DELETE CASCADE
);

CREATE TABLE TERRITORY
(
    ID_TERRITORY    TINYINT       NOT NULL,
    TERRITORY_NAME  VARCHAR(256)  UNIQUE,
    ID_CONTINENT    TINYINT       NOT NULL,
    CONTINENT_NAME  VARCHAR(256)  NOT NULL,
   
    PRIMARY KEY (ID_TERRITORY)
);

CREATE TABLE REINFORCEMENT
(
    ID_REINFORCEMENT  INTEGER   NOT NULL,
    ID_TURN           INTEGER   NOT NULL,
    ID_MATCH          INTEGER   NOT NULL,
    BACKUP_TROOPS     SMALLINT  NOT NULL,
    POSITIONING_TYPE  TINYINT   NOT NULL,
    ID_TERRITORY      TINYINT   NOT NULL,
	  
    PRIMARY KEY (ID_REINFORCEMENT, ID_TURN, ID_MATCH),
    FOREIGN KEY (ID_TURN, ID_MATCH) REFERENCES TURN(ID_TURN, ID_MATCH) ON DELETE CASCADE,
    FOREIGN KEY (ID_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY),
	CHECK (POSITIONING_TYPE IN('0','1','2','3','4','5','6','7','8'))
);

CREATE TABLE ATTACK
(
    ID_ATTACK               INTEGER  NOT NULL,
    ID_TURN                 INTEGER  NOT NULL,
    ID_MATCH                INTEGER  NOT NULL,
    ID_DEFENDING_PLAYER     TINYINT  NOT NULL,
    RESULT                  TINYINT,
    POSITIONING_TYPE        TINYINT,
    ID_ATTACKING_TERRITORY  TINYINT  NOT NULL,
    ID_DEFENDING_TERRITORY  TINYINT  NOT NULL,
    
    PRIMARY KEY (ID_ATTACK, ID_TURN, ID_MATCH),
    FOREIGN KEY (ID_TURN, ID_MATCH) REFERENCES TURN(ID_TURN, ID_MATCH) ON DELETE CASCADE,
    FOREIGN KEY (ID_ATTACKING_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY),
    FOREIGN KEY (ID_DEFENDING_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY),
    FOREIGN KEY (ID_DEFENDING_PLAYER, ID_MATCH) REFERENCES PLAYER(ID_PLAYER, ID_MATCH) ON DELETE CASCADE,
    CHECK((POSITIONING_TYPE = 1) OR ( POSITIONING_TYPE = 2)),
    CHECK((RESULT = 0) OR (RESULT = 1))
);

CREATE TABLE DICE_ROLL
(
    ID_ATTACK   INTEGER,
    N_ROLL      INTEGER  NOT NULL,
    ID_TURN     INTEGER  NOT NULL,
    ID_MATCH    INTEGER  NOT NULL,
    DIE1_ATT    TINYINT  NOT NULL,
    DIE2_ATT    TINYINT,
    DIE3_ATT    TINYINT,
    DIE1_DEF    TINYINT  NOT NULL,
    DIE2_DEF    TINYINT,
    DIE3_DEF    TINYINT,
	
    PRIMARY KEY (ID_ATTACK, N_ROLL, ID_TURN, ID_MATCH),
    FOREIGN KEY (ID_ATTACK, ID_TURN, ID_MATCH) REFERENCES ATTACK(ID_ATTACK, ID_TURN, ID_MATCH) ON DELETE CASCADE,
    CHECK((DIE1_ATT BETWEEN 1 AND 6) AND (DIE2_ATT BETWEEN 1 AND 6) 
      AND (DIE3_ATT BETWEEN 1 AND 6) AND (DIE1_DEF BETWEEN 1 AND 6) 
      AND (DIE2_DEF BETWEEN 1 AND 6) AND (DIE3_DEF BETWEEN 1 AND 6))
);

CREATE TABLE STRATEGIC_POSITIONING
(
    ID_TURN                INTEGER  NOT NULL,
    ID_MATCH               INTEGER  NOT NULL,
    ID_STARTING_TERRITORY  TINYINT  NOT NULL,
    ID_LANDING_TERRITORY   TINYINT  NOT NULL,
    MOVING_TROOPS          SMALLINT NOT NULL,
    
    PRIMARY KEY (ID_TURN, ID_MATCH),
    FOREIGN KEY (ID_TURN, ID_MATCH) REFERENCES TURN(ID_TURN, ID_MATCH) ON DELETE CASCADE,
    FOREIGN KEY (ID_STARTING_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY),
    FOREIGN KEY (ID_LANDING_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY)
);

CREATE TABLE BORDER
(
    ID_TERRITORY TINYINT  NOT NULL,
    ID_NEIGHBOUR TINYINT  NOT NULL,
   
    FOREIGN KEY (ID_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY),
    FOREIGN KEY (ID_NEIGHBOUR) REFERENCES TERRITORY(ID_TERRITORY)
);

CREATE TABLE TERRITORY_CARD
(
    ID_CARD         INTEGER       NOT NULL,
    TERRITORY_NAME  VARCHAR(256)  UNIQUE,
    TYPE            CHAR,

    PRIMARY KEY (ID_CARD),
    CHECK(TYPE IN('J', 'O', 'F', 'C', 'A')) -- The fuck is 'O'?
);

CREATE TABLE ASS_CARD_TERRITORY_PLAYER
(
    ID_CARD    INTEGER  NOT NULL,
    ID_PLAYER  TINYINT  NOT NULL,
    ID_MATCH   INTEGER  NOT NULL,

    PRIMARY KEY (ID_CARD, ID_PLAYER, ID_MATCH),
    FOREIGN KEY (ID_PLAYER,ID_MATCH) REFERENCES PLAYER(ID_PLAYER,ID_MATCH) ON DELETE CASCADE,
    FOREIGN KEY (ID_CARD) REFERENCES TERRITORY_CARD(ID_CARD) ON DELETE CASCADE
);

CREATE TABLE OCCUPIED_TERRITORY
(
    ID_TERRITORY      INTEGER  NOT NULL,
    OCCUPYING_PLAYER  TINYINT  NOT NULL,
    ID_MATCH          INTEGER  NOT NULL,
    N_TROOPS          SMALLINT DEFAULT 1,

    PRIMARY KEY (ID_TERRITORY, OCCUPYING_PLAYER, ID_MATCH),
    FOREIGN KEY(ID_TERRITORY) REFERENCES TERRITORY(ID_TERRITORY),
    FOREIGN KEY (OCCUPYING_PLAYER, ID_MATCH) REFERENCES PLAYER(ID_PLAYER, ID_MATCH) ON DELETE CASCADE
);

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (1, 'Conquer 18 territories, controlling each of them with at least 2 troops.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (2, 'Conquer 24 territories.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (3, 'Conquer the entirety of North America and Africa.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (4, 'Conquer the entirety of North America and Australia.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (5, 'Conquer the entirety of Asia and Sud America.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (6, 'Conquer the entirety of Asia and Africa.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (7, 'Conquer the entirety of Europe, South America and a third continent of your choice.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (8, 'Conquer the entirety of Europe, Australia and a third continent of your choice.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (9, 'Annihilate the BLACK Army. If the army is not available or if it belongs to the player itself, the objective turns into conquering 24 territories.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (10, 'Annihilate the GREEN Army. If the army is not available or if it belongs to the player itself, the objective turns into conquering 24 territories.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (11, 'Annihilate the RED Army. If the army is not available or if it belongs to the player itself, the objective turns into conquering 24 territories.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (12, 'Annihilate the YELLOW Army. If the army is not available or if it belongs to the player itself, the objective turns into conquering 24 territories.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (13, 'Annihilate the BLUE Army. If the army is not available or if it belongs to the player itself, the objective turns into conquering 24 territories.');

Insert into TARGET_CARD(ID_CARD, DESCRIPTION)
Values (14, 'Annihilate the PURPLE Army. If the army is not available or if it belongs to the player itself, the objective turns into conquering 24 territories.');

Insert into TERRITORY_CARD
values(1, 'Alaska', 'F');

Insert into TERRITORY_CARD
values(2, 'North West Territory', 'A');

Insert into TERRITORY_CARD
values(3, 'Greenland', 'C');

Insert into TERRITORY_CARD
values(4, 'Alberta', 'F');

Insert into TERRITORY_CARD
values(5, 'Ontario', 'C');

Insert into TERRITORY_CARD
values(6, 'Quebec', 'A');

Insert into TERRITORY_CARD
values(7, 'Western United States', 'F');

Insert into TERRITORY_CARD
values(8, 'Eastern United States', 'A');

Insert into TERRITORY_CARD
values(9, 'Central America', 'C');

Insert into TERRITORY_CARD
values(10, 'Venezuela', 'A');

Insert into TERRITORY_CARD
values(11, 'Brazil', 'A');

Insert into TERRITORY_CARD
values(12, 'Peru', 'C');

Insert into TERRITORY_CARD
values(13, 'Argentina', 'F');

Insert into TERRITORY_CARD
values(14, 'Iceland', 'F');

Insert into TERRITORY_CARD
values(15, 'Scandinavia', 'A');

Insert into TERRITORY_CARD
values(16, 'Great Britain', 'C');

Insert into TERRITORY_CARD
values(17, 'Ukraine', 'A');

Insert into TERRITORY_CARD
values(18, 'Northern Europe', 'C');

Insert into TERRITORY_CARD
values(19, 'Western Europe', 'F');

Insert into TERRITORY_CARD
values(20, 'Southern Europe', 'C');

Insert into TERRITORY_CARD
values(21, 'North Africa', 'F');

Insert into TERRITORY_CARD
values(22, 'Egypt', 'F');

Insert into TERRITORY_CARD
values(23, 'Congo', 'C');

Insert into TERRITORY_CARD
values(24, 'East Africa', 'A');

Insert into TERRITORY_CARD
values(25, 'South Africa', 'A');

Insert into TERRITORY_CARD
values(26, 'Madagascar', 'F');

Insert into TERRITORY_CARD
values(27, 'Ural', 'C');

Insert into TERRITORY_CARD
values(28, 'Afghanistan', 'F');

Insert into TERRITORY_CARD
values(29, 'Middle East', 'A');

Insert into TERRITORY_CARD
values(30, 'Siberia', 'A');

Insert into TERRITORY_CARD
values(31, 'China', 'C');

Insert into TERRITORY_CARD
values(32, 'Mongolia', 'A');

Insert into TERRITORY_CARD
values(33, 'Irkutsk', 'F');

Insert into TERRITORY_CARD
values(34, 'Yakutsk', 'C');

Insert into TERRITORY_CARD
values(35, 'Kamchatka', 'C');

Insert into TERRITORY_CARD
values(36, 'Japan', 'F');

Insert into TERRITORY_CARD
values(37, 'India', 'F');

Insert into TERRITORY_CARD
values(38, 'Siam', 'A');

Insert into TERRITORY_CARD
values(39, 'Indonesia', 'C');

Insert into TERRITORY_CARD
values(40, 'New Guinea', 'C');

Insert into TERRITORY_CARD
values(41, 'Western Australia', 'A');

Insert into TERRITORY_CARD
values(42, 'Eastern Australia', 'F');

Insert into TERRITORY_CARD
values(43, 'Jolly1', 'J');

Insert into TERRITORY_CARD
values(44, 'Jolly2', 'J');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(1, 'Alaska', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(2, 'North West Territory', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(3, 'Greenland', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(4,'Alberta', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(5, 'Ontario', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(6, 'Quebec', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(7, 'Western United States', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(8, 'Eastern United States', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(9, 'Central America', 1, 'North America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(10, 'Venezuela', 2, 'South America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(11, 'Brazil', 2, 'South America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(12, 'Peru', 2, 'South America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(13, 'Argentina', 2, 'South America');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(14, 'Iceland', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(15, 'Scandinavia', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(16, 'Great Britain', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(17, 'Ukraine', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(18,'Northern Europe', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(19, 'Western Europe', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(20, 'Southern Europe', 3, 'Europe');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(21, 'North Africa', 4, 'Africa');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(22, 'Egypt', 4, 'Africa');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(23, 'Congo', 4, 'Africa');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(24, 'East Africa', 4, 'Africa');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(25, 'South Africa', 4, 'Africa');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(26, 'Madagascar', 4, 'Africa');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(27, 'Ural', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(28, 'Afghanistan', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(29, 'Middle East', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(30, 'Siberia', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(31, 'China', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(32, 'Mongolia', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(33, 'Irkutsk', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(34, 'Yakutsk' , 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(35, 'Kamchatka', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(36, 'Japan', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(37, 'India', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(38, 'Siam', 5, 'Asia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(39, 'Indonesia', 6, 'Australia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(40, 'New Guinea', 6, 'Australia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(41, 'Western Australia', 6, 'Australia');

insert into TERRITORY(ID_TERRITORY, TERRITORY_NAME, ID_CONTINENT, CONTINENT_NAME)
values(42, 'Eastern Australia', 6, 'Australia');

/* Alaska */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(1, 4);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(1, 2);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(1, 35);

/* North West Territory */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(2, 1);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(2, 4);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(2, 5);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(2, 3);

/* Greenland */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(3, 2);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(3, 5);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(3, 14);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(3, 6);

/* Alberta */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(4, 1);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(4, 2);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(4, 5);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(4, 7);

/* Ontario */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(5, 2);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(5, 3);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(5, 4);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(5, 7);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(5, 8);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(5, 6);

/* Quebec */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(6, 5);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(6, 8);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(6, 3);

/* Western United States */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(7, 4);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(7, 5);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(7, 8);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(7, 9);

/* Eastern United States */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(8, 5);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(8, 6);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(8, 7);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(8, 9);

/* Central America */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(9, 7);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(9, 8);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(9, 10);

/* Venezuela */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(10, 9);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(10, 11);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(10, 12);

/* Brazil */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(11, 10);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(11, 12);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(11, 13);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(11, 21);

/* Peru */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(12, 10);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(12, 11);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(12, 13);

/* Argentina */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(13, 11);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(13, 12);

/* Iceland */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(14, 3);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(14, 15);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(14, 16);

/* Scandinavia */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(15, 14);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(15, 16);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(15, 18);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(15, 17);

/* Great Britain */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(16, 14);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(16, 15);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(16, 18);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(16, 19);

/* Ukraine */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(17, 15);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(17, 18);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(17, 20);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(17, 27);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(17, 28);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(17, 29);

/* Northern Europe */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(18, 15);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(18, 16);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(18, 19);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(18, 20);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(18, 17);

/* Western Europe */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(19, 16);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(19, 18);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(19, 20);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(19, 21);

/* Southern Europe */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(20, 19);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(20, 18);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(20, 17);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(20, 29);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(20, 21);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(20, 22);

/* North Africa */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(21, 11);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(21, 19);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(21, 20);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(21, 22);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(21, 23);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(21, 24);

/* Egypt */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(22, 21);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(22, 24);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(22, 29);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(22, 20);

/* Congo */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(23, 21);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(23, 24);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(23, 25);

/* East Africa */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(24, 22);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(24, 23);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(24, 25);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(24, 26);

/* South Africa */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(25, 24);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(25, 23);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(25, 26);

/* Madagascar */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(26, 24);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(26, 25);

/* Ural */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(27, 17);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(27, 28);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(27, 30);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(27, 31);

/* Afghanistan */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(28, 17);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(28, 27);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(28, 31);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(28, 29);

/* Middle East */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(29, 20);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(29, 22);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(29, 17);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(29, 28);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(29, 31);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(29, 37);

/* Siberia */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(30, 27);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(30, 34);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(30, 33);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(30, 32);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(30, 31);

/* China */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 32);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 38);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 37);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 29);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 28);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 27);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(31, 30);

/* Mongolia */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(32, 33);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(32, 35);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(32, 36);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(32, 31);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(32, 30);

/* Irkutsk */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(33, 30);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(33, 34);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(33, 35);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(33, 32);

/* Yakutsk */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(34, 33);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(34, 30);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(34, 35);

/* Kamchatka */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(35, 1);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(35, 36);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(35, 33);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(35, 34);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(35, 32);

/* Japan */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(36, 35);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(36, 32);

/* India */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(37, 38);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(37, 31);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(37, 29);

/* Siam */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(38, 31);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(38, 37);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(38, 39);

/* Indonesia */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(39, 38);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(39, 40);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(39, 41);

/* New Guinea */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(40, 39);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(40, 41);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(40, 42);

/* Western Australia */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(41, 39);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(41, 40);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(41, 42);

/* Eastern Australia */
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(42, 40);
Insert into BORDER(ID_TERRITORY, ID_NEIGHBOUR)
Values(42, 41);
