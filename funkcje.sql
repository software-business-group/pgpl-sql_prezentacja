CREATE OR REPLACE FUNCTION get_sum(
 a NUMERIC,
 b NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
 RETURN a + b;
END; $$

LANGUAGE plpgsql;

SELECT get_sum(10,20);

/***************************************************************/

CREATE OR REPLACE FUNCTION hi_lo(
 a NUMERIC,
 b NUMERIC,
 c NUMERIC,
        OUT hi NUMERIC,
 OUT lo NUMERIC)
AS $$
BEGIN
 hi := GREATEST(a,b,c);
 lo := LEAST(a,b,c);
END; $$

LANGUAGE plpgsql;

SELECT hi_lo(10,20,30);


SELECT * FROM hi_lo(10,20,30);

/***************************************************************/


CREATE OR REPLACE FUNCTION square(
 INOUT a NUMERIC)
AS $$
BEGIN
 a := a * a;
END; $$
LANGUAGE plpgsql;

SELECT square(4);

/***************************************************************/


CREATE OR REPLACE FUNCTION sum_avg(
 VARIADIC list NUMERIC[],
 OUT total NUMERIC,
        OUT average NUMERIC)
AS $$
BEGIN
   SELECT INTO total SUM(list[i])
   FROM generate_subscripts(list, 1) g(i);

   SELECT INTO average AVG(list[i])
   FROM generate_subscripts(list, 1) g(i);

END; $$
LANGUAGE plpgsql;

SELECT * FROM sum_avg(10,20,30);

/***************************************************************/

CREATE OR REPLACE FUNCTION get_film_titles(p_year INTEGER)
   RETURNS text AS $$
DECLARE
 titles TEXT DEFAULT '';
 rec_film   RECORD;
 cur_films CURSOR(p_year INTEGER)
 FOR SELECT
 FROM film
 WHERE release_year = p_year;
BEGIN
   -- Open the cursor
   OPEN cur_films(p_year);

   LOOP
    -- fetch row into the film
      FETCH cur_films INTO rec_film;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;

    -- build the output
      IF rec_film.title LIKE '%ful%' THEN
         titles := titles || ',' || rec_film.title || ':' || rec_film.release_year;
      END IF;
   END LOOP;

   -- Close the cursor
   CLOSE cur_films;

   RETURN titles;
END; $$

LANGUAGE plpgsql;

SELECT get_film_titles(2006);
