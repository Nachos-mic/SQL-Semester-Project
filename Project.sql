--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 15.2

-- Started on 2023-06-16 16:03:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 20 (class 2615 OID 237216)
-- Name: assignment; Type: SCHEMA; Schema: -; Owner: 2023_ciurej_michal
--

CREATE SCHEMA assignment;


ALTER SCHEMA assignment OWNER TO "2023_ciurej_michal";

--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 20
-- Name: SCHEMA assignment; Type: COMMENT; Schema: -; Owner: 2023_ciurej_michal
--

COMMENT ON SCHEMA assignment IS 'Nowa wersja , poprzednią źle nazwałem
';


--
-- TOC entry 725 (class 1255 OID 237226)
-- Name: task_3(integer); Type: FUNCTION; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE FUNCTION assignment.task_3(ects integer) RETURNS SETOF dziekanat.przedmioty
    LANGUAGE plpgsql
    AS $$
DECLARE
	przedmioty dziekanat.przedmioty;
BEGIN
	IF ects < 1 OR ects > 8 THEN
		RAISE NOTICE 'Błędna liczba punktów ECTS , proszę wpisać liczbę pomiędzy 1 , a 8';
		RETURN NEXT NULL;
	END IF;	
	
	FOR przedmioty IN SELECT * FROM dziekanat.przedmioty LOOP
		IF przedmioty.ects = ects THEN
            		RETURN NEXT przedmioty;
        	END IF;
    	END LOOP;
    	RETURN;
	
END;
$$;


ALTER FUNCTION assignment.task_3(ects integer) OWNER TO "2023_ciurej_michal";

--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 725
-- Name: FUNCTION task_3(ects integer); Type: COMMENT; Schema: assignment; Owner: 2023_ciurej_michal
--

COMMENT ON FUNCTION assignment.task_3(ects integer) IS 'Utwórz funkcję , która zwróci przedmioty o wpisanej do niej ilości punktów ects ,
przy podaniu błędnej ilości punktów ECTS , wypisz o tym informację';


--
-- TOC entry 726 (class 1255 OID 237235)
-- Name: task_4_function(); Type: FUNCTION; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE FUNCTION assignment.task_4_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

	IF NEW.sprzedane = true THEN 
		INSERT INTO assignment.komputery_log (nr_katalogowy , data_sprzedazy , cena_zl)
			VALUES (OLD.nr_katalogowy , LOCALTIMESTAMP , OLD.cena_zl);
			RAISE NOTICE 'Sprzedano komputer o numerze katalogowym: %' ,OLD.nr_katalogowy;
	END IF;
	
	IF NEW.sprzedane = OLD.sprzedane THEN 
		RAISE NOTICE 'Bez zmian';
	END IF;
	
	
RETURN NEW;
END;
$$;


ALTER FUNCTION assignment.task_4_function() OWNER TO "2023_ciurej_michal";

--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 726
-- Name: FUNCTION task_4_function(); Type: COMMENT; Schema: assignment; Owner: 2023_ciurej_michal
--

COMMENT ON FUNCTION assignment.task_4_function() IS 'Zapisuje do logów informację o sprzedaży komputera';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 257 (class 1259 OID 237335)
-- Name: komputery; Type: TABLE; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE TABLE assignment.komputery (
    nr_katalogowy integer NOT NULL,
    cena_zl double precision NOT NULL,
    sprzedane boolean NOT NULL
);


ALTER TABLE assignment.komputery OWNER TO "2023_ciurej_michal";

--
-- TOC entry 258 (class 1259 OID 237340)
-- Name: komputery_log; Type: TABLE; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE TABLE assignment.komputery_log (
    nr_katalogowy integer NOT NULL,
    data_sprzedazy timestamp without time zone NOT NULL,
    cena_zl double precision NOT NULL
);


ALTER TABLE assignment.komputery_log OWNER TO "2023_ciurej_michal";

--
-- TOC entry 255 (class 1259 OID 237217)
-- Name: task_1; Type: VIEW; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE VIEW assignment.task_1 AS
 SELECT d.imie AS "Imię",
    d.nazwisko AS "Nazwisko",
    d.nr_albumu AS "Numer albumu"
   FROM dziekanat.studenci d
  WHERE (d.adres_zamieszkania IN ( SELECT o.id_adresu
           FROM dziekanat.adresy o
          WHERE (((o.miejscowosc)::text = 'Tarnów'::text) AND ((o.kod_pocztowy)::bpchar = '33-100'::bpchar))))
  ORDER BY d.nr_albumu DESC;


ALTER TABLE assignment.task_1 OWNER TO "2023_ciurej_michal";

--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 255
-- Name: VIEW task_1; Type: COMMENT; Schema: assignment; Owner: 2023_ciurej_michal
--

COMMENT ON VIEW assignment.task_1 IS 'Utwórz zapytanie które wypisze nr_albumu, imiona i nazwiska wszystkich osób które mieszkają w Tarnowie 
z poprawnym kodem pocztowym dla powiatu Tarnowskiego (33-100)';


--
-- TOC entry 256 (class 1259 OID 237221)
-- Name: task_2; Type: VIEW; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE VIEW assignment.task_2 AS
 SELECT d.tytul AS "Tytuł",
    d.imie AS "Imię",
    d.nazwisko AS "Nazwisko",
    d.placa_zasadnicza AS "Płaca zasadnicza",
    d.id_prowadzacego AS "ID prowadzącego"
   FROM (kadry.prowadzacy d
     JOIN dziekanat.przedmioty s ON ((s.id_prowadzacego = d.id_prowadzacego)))
  GROUP BY d.tytul, d.imie, d.nazwisko, d.placa_zasadnicza, d.id_prowadzacego
 HAVING (count(*) >= 2)
  ORDER BY d.placa_zasadnicza DESC;


ALTER TABLE assignment.task_2 OWNER TO "2023_ciurej_michal";

--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 256
-- Name: VIEW task_2; Type: COMMENT; Schema: assignment; Owner: 2023_ciurej_michal
--

COMMENT ON VIEW assignment.task_2 IS 'Utwórz zapytanie , które wypisze imię , nazwisko , płacę zasadniczą oraz id prowadzącego
, którzy prowadzą dwa lub więcej przedmiotów , posortuj po płacy zasadniczej';


--
-- TOC entry 4852 (class 0 OID 237335)
-- Dependencies: 257
-- Data for Name: komputery; Type: TABLE DATA; Schema: assignment; Owner: 2023_ciurej_michal
--

COPY assignment.komputery (nr_katalogowy, cena_zl, sprzedane) FROM stdin;
1	3700	f
2	5400	f
3	10000	t
\.


--
-- TOC entry 4853 (class 0 OID 237340)
-- Dependencies: 258
-- Data for Name: komputery_log; Type: TABLE DATA; Schema: assignment; Owner: 2023_ciurej_michal
--

COPY assignment.komputery_log (nr_katalogowy, data_sprzedazy, cena_zl) FROM stdin;
3	2023-06-16 15:48:36.384447	10000
\.


--
-- TOC entry 4706 (class 2606 OID 237339)
-- Name: komputery komputery_nr_katalogowy_key; Type: CONSTRAINT; Schema: assignment; Owner: 2023_ciurej_michal
--

ALTER TABLE ONLY assignment.komputery
    ADD CONSTRAINT komputery_nr_katalogowy_key UNIQUE (nr_katalogowy);


--
-- TOC entry 4707 (class 2620 OID 237343)
-- Name: komputery task_4_trigger; Type: TRIGGER; Schema: assignment; Owner: 2023_ciurej_michal
--

CREATE TRIGGER task_4_trigger AFTER UPDATE ON assignment.komputery FOR EACH ROW EXECUTE FUNCTION assignment.task_4_function();


--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 4707
-- Name: TRIGGER task_4_trigger ON komputery; Type: COMMENT; Schema: assignment; Owner: 2023_ciurej_michal
--

COMMENT ON TRIGGER task_4_trigger ON assignment.komputery IS 'Wyzwala się przy aktualizacji statusu sprzedaży';


-- Completed on 2023-06-16 16:03:13

--
-- PostgreSQL database dump complete
--

