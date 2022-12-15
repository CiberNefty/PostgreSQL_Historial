DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
use library;

CREATE TABLE authors (
author_id int unsigned NOT NULL auto_increment,
name varchar(100) not null,
nationality varchar(100) default NULL,
PRIMARY KEY  (author_id),
UNIQUE KEY uniq_author (name)
)ENGINE = InnoDB Auto_increment =193 default CHARSET=utf8mb4;

CREATE TABLE books(
book_id int unsigned not null auto_increment,
author_id int unsigned default null,
title varchar(100) not null,
year int not null default '1900',
language varchar(2) not null comment 'ISO 639-1 Language',
cover_url varchar(500) default null,
price double(6,2) default null,
sellable tinyint(1) not null default '0',
copies int not null default '1',
description text,
PRIMARY KEY (book_id),
UNIQUE KEY book_language (title,language)
)ENGINE=INNODB AUTO_INCREMENT=199 default charset=utf8mb4;

CREATE TABLE clients(
client_id int unsigned not null auto_increment,
name varchar(50) default null,
email varchar(100) not null,
birthdate DATE default null,
gender enum('M','F') DEfault null,
active tinyint(1) not null default '1',
created_at timestamp not null default current_timestamp,
PRIMARY KEY (client_id),
UNIQUE KEY email (email)
)ENGINE=INNODB auto_increment =101 default charset =utf8mb4;

CREATE TABLE transactions(
transaction_id int unsigned not null auto_increment,
book_id int unsigned not null,
client_id int unsigned not null,
type enum('lend','sell') not null,
created_at timestamp not null default current_timestamp,
modified_at timestamp not null default current_timestamp on update current_timestamp,
finished tinyint(1) not null default '0',
PRIMARY KEY (transaction_id)
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
