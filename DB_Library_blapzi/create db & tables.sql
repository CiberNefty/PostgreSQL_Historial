DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
use library;

CREATE TABLE authors(
author_id serial,
name varchar(100) not null,
nationality varchar(100) default NULL,
CONSTRAINT authors_pkey PRIMARY KEY (author_id)
);
--comment 'ISO 639-1 Language'
CREATE TABLE public.books
(
    book_id serial,
    author_id integer DEFAULT null,
    title character varying(100) NOT NULL,
    year integer NOT NULL DEFAULT '1900',
    language character varying(2) NOT NULL,
    cover_url character varying(500) DEFAULT null,
    price double precision,
    sellable smallint DEFAULT 0,
    copies integer DEFAULT 1,
    description text,
    CONSTRAINT books_pkey PRIMARY KEY (book_id),
    CONSTRAINT uniq_books_title UNIQUE (title),
    CONSTRAINT uniq_books_language UNIQUE (language),
    CONSTRAINT books_authors FOREIGN KEY (author_id)
        REFERENCES public.authors (author_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
);
TRUNCATE TABLE books;
CONSTRAINT uniq_books_language (language)
CONSTRAINT unique_author_name UNIQUE (name)INCLUDE (name);
	
CREATE TABLE public.clients
(
    client_id serial NOT NULL,
    name character varying(50) DEFAULT null,
    email character varying(100) NOT NULL,
    birthdate date DEFAULT null,
    gender character varying(1),
    active smallint DEFAULT 1,
    create_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
    CONSTRAINT clients PRIMARY KEY (client_id),
    CONSTRAINT uniq_clients_email UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS public.transactions
(
    transaction_id integer NOT NULL DEFAULT nextval('transactions_transaction_id_seq'::regclass),
    book_id integer NOT NULL,
    client_id integer NOT NULL,
    type character varying(4) COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_ad timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished smallint DEFAULT 0,
    CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id),
    CONSTRAINT transactions_books_fkey FOREIGN KEY (book_id)
        REFERENCES public.books (book_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT transactions_clients_fkey FOREIGN KEY (client_id)
        REFERENCES public.clients (client_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)