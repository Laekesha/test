-- 3. Structure creation.

CREATE TABLE a_shops
(
    id         number(20)    NOT NULL
        CONSTRAINT a_shop_pk PRIMARY KEY,
    name       varchar2(200) NOT NULL,
    region     varchar2(200) NOT NULL,
    city       varchar2(200) NOT NULL,
    address    varchar2(200) NOT NULL,
    manager_id number(20)    NOT NULL
);

CREATE TABLE a_employees
(
    id         number(20)    NOT NULL
        CONSTRAINT a_employees_pk
            PRIMARY KEY,
    first_name varchar2(100) NOT NULL,
    last_name  varchar2(100) NOT NULL,
    phone      varchar2(50)  NOT NULL,
    e_mail     varchar2(50)  NOT NULL,
    job_name   varchar2(50)  NOT NULL,
    shop_id    number(20, 0)
);

ALTER TABLE a_shops
    ADD CONSTRAINT a_shops_a_employees_id_fk FOREIGN KEY (manager_id)
        REFERENCES a_employees (id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE a_employees
    ADD CONSTRAINT a_employees_a_shops_shop_id_fk FOREIGN KEY (shop_id)
        REFERENCES a_shops (id) DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE a_products
(
    id   number(20)    NOT NULL
        CONSTRAINT a_products_pk
            PRIMARY KEY,
    code varchar2(50)  NOT NULL,
    name varchar2(200) NOT NULL
);

CREATE TABLE a_purchases
(
    id        number(20) NOT NULL
        CONSTRAINT a_purchases_pk
            PRIMARY KEY,
    datetime  date       NOT NULL,
    amount    number(20) NOT NULL,
    seller_id number(20)
        CONSTRAINT a_purchases_a_employees_id_fk
            REFERENCES a_employees
);

CREATE TABLE a_purchase_receipts
(
    purchase_id     number(20)    NOT NULL
        CONSTRAINT a_purchase_receipts_a_purchases_id_fk
            REFERENCES a_purchases
                DEFERRABLE INITIALLY DEFERRED,
    ordinal_number  number(5)     NOT NULL,
    product_id      number(20)    NOT NULL
        CONSTRAINT a_purchase_receipts_a_products_id_fk
            REFERENCES a_products,
    --deferrable initially deferred,
    quantity        number(25, 5) NOT NULL,
    amount_full     number(20)    NOT NULL,
    amount_discount number(20)    NOT NULL,
    CONSTRAINT a_purchase_receipts_pk_2
        PRIMARY KEY (purchase_id, ordinal_number)
);

CREATE UNIQUE INDEX a_products_code_uindex ON a_products (code);



-- 4. Data generation.

-- создание и заполнение вспомогательных таблиц

CREATE TABLE a_shop_name
(
    name varchar2(200)
);

INSERT INTO a_shop_name
VALUES ('Noni');

INSERT INTO a_shop_name
VALUES ('Pepino');

INSERT INTO a_shop_name
VALUES ('Mushmula');

INSERT INTO a_shop_name
VALUES ('Datura');

INSERT INTO a_shop_name
VALUES ('Velvichia');

INSERT INTO a_shop_name
VALUES ('Kosmey');

INSERT INTO a_shop_name
VALUES ('Kinkan');

INSERT INTO a_shop_name
VALUES ('Neomarika');

INSERT INTO a_shop_name
VALUES ('Nertera');

INSERT INTO a_shop_name
VALUES ('Litops');

CREATE TABLE a_region
(
    region varchar2(200)
);

INSERT INTO a_region
VALUES ('Svealand');

INSERT INTO a_region
VALUES ('Norrland');

INSERT INTO a_region
VALUES ('Gotaland');

CREATE TABLE a_city
(
    city varchar2(200)
);

INSERT INTO a_city
VALUES ('Stockholm');

INSERT INTO a_city
VALUES ('Gothenburg');

INSERT INTO a_city
VALUES ('Malmo');

INSERT INTO a_city
VALUES ('Uppsala');

INSERT INTO a_city
VALUES ('Orebro');

INSERT INTO a_city
VALUES ('Linkoping');

INSERT INTO a_city
VALUES ('Helsinborg');

INSERT INTO a_city
VALUES ('Jonkoping');

INSERT INTO a_city
VALUES ('Lund');

INSERT INTO a_city
VALUES ('Umea');

CREATE TABLE a_address_street
(
    street varchar2(200)
);

INSERT INTO a_address_street
VALUES ('Langa Gatan');

INSERT INTO a_address_street
VALUES ('Strandvagen');

INSERT INTO a_address_street
VALUES ('Svartensgaten');

INSERT INTO a_address_street
VALUES ('Ringvagen');

INSERT INTO a_address_street
VALUES ('Storgatan');

INSERT INTO a_address_street
VALUES ('Skolgatan');

INSERT INTO a_address_street
VALUES ('Huvudgata');

INSERT INTO a_address_street
VALUES ('Kanalgata');

INSERT INTO a_address_street
VALUES ('Malarstrand');

INSERT INTO a_address_street
VALUES ('Augustendalsvagen');

CREATE TABLE a_first_name
(
    first_name varchar2(100)
);

INSERT INTO a_first_name
VALUES ('Karl');

INSERT INTO a_first_name
VALUES ('Gustav');

INSERT INTO a_first_name
VALUES ('Anders');

INSERT INTO a_first_name
VALUES ('Mikael');

INSERT INTO a_first_name
VALUES ('Olof');

INSERT INTO a_first_name
VALUES ('Eva');

INSERT INTO a_first_name
VALUES ('Ida');

INSERT INTO a_first_name
VALUES ('Sara');

INSERT INTO a_first_name
VALUES ('Katarina');

INSERT INTO a_first_name
VALUES ('Ulrika');

CREATE TABLE a_last_name
(
    last_name varchar2(100)
);

INSERT INTO a_last_name
VALUES ('Svensson');

INSERT INTO a_last_name
VALUES ('Lindberg');

INSERT INTO a_last_name
VALUES ('Karlsstrom');

INSERT INTO a_last_name
VALUES ('Nilsgren');

INSERT INTO a_last_name
VALUES ('Lind');

INSERT INTO a_last_name
VALUES ('Berglund');

INSERT INTO a_last_name
VALUES ('Wallin');

INSERT INTO a_last_name
VALUES ('Lundin');

INSERT INTO a_last_name
VALUES ('Holm');

INSERT INTO a_last_name
VALUES ('Bergman');

INSERT INTO a_last_name
VALUES ('Blomqvist');

INSERT INTO a_last_name
VALUES ('Hansen');

CREATE TABLE a_job_name
(
    job_name varchar2(50)
);

INSERT INTO a_job_name
VALUES ('Охранник');

INSERT INTO a_job_name
VALUES ('Уборщик');

INSERT INTO a_job_name
VALUES ('Бухгалтер');

INSERT INTO a_job_name
VALUES ('Юрист');

INSERT INTO a_job_name
VALUES ('Маркетолог');

INSERT INTO a_job_name
VALUES ('Грузчик');

INSERT INTO a_job_name
VALUES ('Водитель');

INSERT INTO a_job_name
VALUES ('HR-менеджер');

INSERT INTO a_job_name
VALUES ('Менеджер по закупкам');

INSERT INTO a_job_name
VALUES ('Системный администратор');

INSERT INTO a_job_name
VALUES ('Программист');

INSERT INTO a_job_name
VALUES ('Кладовщик');



CREATE FUNCTION gen_select(table_name IN varchar2)
    RETURN varchar2
AS

    random_value varchar2(200);

BEGIN
    EXECUTE IMMEDIATE 'select * from ' || table_name ||
                      ' order by DBMS_RANDOM.value offset 0 rows fetch next 1 rows only' INTO random_value;
    RETURN random_value;
END;



CREATE FUNCTION gen_select_number_field(table_name varchar2, table_field varchar2)
    RETURN number
AS

    random_value number;

BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || table_field || ' from ' || table_name ||
                      ' order by DBMS_RANDOM.value OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY' INTO random_value;
    RETURN random_value;
END;



CREATE FUNCTION random_value(from_value number, to_value number) RETURN number AS
BEGIN
    RETURN trunc(dbms_random.value(from_value, to_value));
END random_value;



CREATE FUNCTION random_string(string_param IN varchar2
                             , from_value IN number
                             , to_value IN number)
    RETURN varchar2 AS

BEGIN
    RETURN dbms_random.string(string_param, dbms_random.value(from_value, to_value));
END random_string;



CREATE FUNCTION gen_id(table_name IN varchar2)
    RETURN number
AS

    table_count number;
    table_id    number(20);

BEGIN

    LOOP

        table_id := trunc(dbms_random.value(1000000000, 99999999999999999999));
        EXECUTE IMMEDIATE 'select count(*) from ' || table_name || ' where id = ' || table_id INTO table_count;
        EXIT WHEN table_count = 0;

    END LOOP;

    RETURN table_id;

END;



CREATE PROCEDURE gen_shop(shop_id number, manager_id_value number)
AS
BEGIN

    INSERT INTO a_shops
    VALUES ( shop_id
           , gen_select('A_SHOP_NAME')
           , gen_select('A_REGION')
           , gen_select('A_CITY')
           , gen_select('A_ADDRESS_STREET') || ' ' || trunc(dbms_random.value(01, 200))
           , manager_id_value);

END gen_shop;



CREATE PROCEDURE gen_employee(employee_id number, job_name_value varchar2, shop_id_value number)
AS

BEGIN

    INSERT INTO a_employees
    VALUES ( employee_id
           , gen_select('A_FIRST_NAME')
           , gen_select('A_LAST_NAME')
           , random_value(0001, 9999) || '-' || random_value(00000001, 99999999)
           , random_string('u', 10, 20) || '@' || random_string('u', 10, 20)
           , job_name_value
           , shop_id_value);

END gen_employee;



CREATE PROCEDURE gen_purchase_receipt(purchase_id number, receipt_count number) AS
BEGIN
    FOR ordinal_number IN 1..receipt_count
        LOOP
            INSERT INTO a_purchase_receipts
            VALUES ( purchase_id
                   , ordinal_number
                   , gen_select_number_field('A_PRODUCTS', 'ID')
                   , trunc(dbms_random.value(0.01, 100.99), 2)
                   , trunc(random_value(100, 10000))
                   , trunc(random_value(0, 100)));
        END LOOP;
END;



CREATE FUNCTION a_select_seller
    RETURN varchar2
AS

    seller_id number;

BEGIN

    SELECT id
    INTO seller_id
    FROM a_employees
    WHERE job_name IN ('продавец-кассир', 'продавец-консультант')
    ORDER BY dbms_random.value
    OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

    RETURN seller_id;

END a_select_seller;



CREATE PROCEDURE a_delete_purchases(employees_count number) AS
    CURSOR c_employees IS
        SELECT id
        FROM a_employees
        ORDER BY dbms_random.value;
    emp_id number;
    c      number := 0;
BEGIN
    OPEN c_employees;
    LOOP
        FETCH c_employees INTO emp_id;
        EXIT WHEN c_employees%NOTFOUND OR c = employees_count;
        dbms_output.put_line(emp_id);
        DELETE
        FROM a_purchase_receipts
        WHERE purchase_id IN (SELECT id FROM a_purchases WHERE seller_id = emp_id);
        DELETE
        FROM a_purchases
        WHERE seller_id = emp_id;
        c := c + 1;
    END LOOP;

    COMMIT;
END;


-- fail, wrong amount

CREATE PROCEDURE a_delete_products(products_count number) AS
    CURSOR c_products IS
        SELECT id
        FROM a_products
        ORDER BY dbms_random.value;
    prod_id number;
    c       number := 0;
BEGIN
    OPEN c_products;
    LOOP
        FETCH c_products INTO prod_id;
        EXIT WHEN c_products%NOTFOUND OR c = products_count;
        dbms_output.put_line(prod_id);
        DELETE a_purchase_receipts
        WHERE product_id = prod_id;
        c := c + 1;
    END LOOP;

    COMMIT;
END;



CREATE PROCEDURE gen_main(shops_count number, purchases_count number, not_sealed_employees_count number,
                          not_sealed_products_count number)
AS

    manager_id      number;
    shop_id         number;
    new_purchase_id number;
    total           number;

BEGIN

    FOR i IN 1..shops_count
        LOOP
            shop_id := gen_id('A_SHOPS');
            manager_id := gen_id('A_EMPLOYEES');
            gen_employee(manager_id, 'директор магазина', shop_id);
            gen_shop(shop_id, manager_id);

            FOR i IN 1..4
                LOOP
                    gen_employee(gen_id('A_EMPLOYEES'), 'продавец-кассир', shop_id);
                    gen_employee(gen_id('A_EMPLOYEES'), 'продавец-консультант', shop_id);
                END LOOP;

            FOR i IN 1..2
                LOOP
                    gen_employee(gen_id('A_EMPLOYEES'), 'уборщик', shop_id);
                    gen_employee(gen_id('A_EMPLOYEES'), 'охранник', shop_id);
                END LOOP;

        END LOOP;

    gen_employee(gen_id('A_EMPLOYEES'), 'юрист', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'маркетолог', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'hr-менеджер', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'секретарь', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'программист', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'менеджер по закупкам', NULL);

    gen_employee(gen_id('A_EMPLOYEES'), 'системный администратор', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'системный администратор', NULL);

    gen_employee(gen_id('A_EMPLOYEES'), 'грузчик', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'грузчик', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'грузчик', NULL);

    gen_employee(gen_id('A_EMPLOYEES'), 'кладовшик', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'кладовшик', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'кладовшик', NULL);

    gen_employee(gen_id('A_EMPLOYEES'), 'водитель', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'водитель', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'водитель', NULL);

    gen_employee(gen_id('A_EMPLOYEES'), 'бухгалтер', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'бухгалтер', NULL);
    gen_employee(gen_id('A_EMPLOYEES'), 'бухгалтер', NULL);

    FOR i IN 1..200
        LOOP
            INSERT INTO a_products
            VALUES ( gen_id('A_PRODUCTS')
                   , random_string('x', 10, 50)
                   , random_string('u', 10, 200));
        END LOOP;


    FOR i IN 1..purchases_count
        LOOP
            new_purchase_id := gen_id('A_PURCHASES');
            gen_purchase_receipt(new_purchase_id, random_value(1, 50));
            SELECT sum(amount_full * (1 - amount_discount * 0.01))
            INTO total
            FROM a_purchase_receipts
            WHERE a_purchase_receipts.purchase_id = new_purchase_id;

            INSERT INTO a_purchases
            VALUES ( new_purchase_id
                   , add_months(sysdate, -12) + random_value(0, 86400 * 365 * 2)  86400
                   , total
                   , a_select_seller);

        END LOOP;

    COMMIT;

    a_delete_purchases(not_sealed_employees_count);
    a_delete_products(not_sealed_products_count);

    COMMIT;

END gen_main;



-- 1.  Marketing reports.

CREATE VIEW a_last_month_sales AS
SELECT id, datetime, amount, seller_id
FROM a_purchases
WHERE datetime BETWEEN add_months(trunc(sysdate, 'mm'), -1) AND trunc(sysdate, 'mm');

-- a.

CREATE VIEW a_not_sold_products AS
SELECT code, name
FROM a_products
WHERE id NOT IN (SELECT DISTINCT product_id
                 FROM (SELECT * FROM a_purchase_receipts WHERE purchase_id IN (SELECT id FROM a_last_month_sales)));

-- b.

CREATE VIEW a_best_sellers AS
SELECT seller_id, sum(amount) "amount", name
FROM a_last_month_sales
         INNER JOIN a_employees ON a_last_month_sales.seller_id = a_employees.id
         INNER JOIN a_shops "as" ON a_employees.shop_id = "as".id
GROUP BY seller_id, name
ORDER BY name, "amount" DESC;


CREATE VIEW a_sel_without_sales AS
SELECT first_name || ' ' || last_name "employee", job_name, name "shop name"
FROM a_employees
         INNER JOIN a_shops "as" ON a_employees.shop_id = "as".id
WHERE job_name IN ('продавец-кассир', 'продавец-консультант')
  AND a_employees.id NOT IN (SELECT DISTINCT seller_id FROM a_last_month_sales)
ORDER BY name;

-- c.

CREATE VIEW a_region_sales AS
SELECT "as".region, SUM(alm.amount) total
FROM a_last_month_sales alm
         INNER JOIN a_employees ae ON alm.seller_id = ae.id
         INNER JOIN a_shops "as" ON ae.shop_id = "as".id
GROUP BY "as".region
ORDER BY total DESC;



-- 2. Failure report.

CREATE VIEW a_fails AS
SELECT "as".name, datetime, amount, wrong_amount, ABS(amount - wrong_amount) diff
FROM (SELECT amount,
             datetime,
             seller_id,
             (SELECT sum(amount_full * (1 - amount_discount * 0.01))
              FROM a_purchase_receipts
              WHERE a_last_month_sales.id = purchase_id) wrong_amount
      FROM a_last_month_sales)
         INNER JOIN a_employees ae ON seller_id = ae.id
         INNER JOIN a_shops "as" ON ae.shop_id = "as".id
WHERE ABS(amount - wrong_amount) > 1;

BEGIN
    gen_main(shops_count => 20,
             purchases_count => 10000,
             not_sealed_employees_count => 5,
             not_sealed_products_count => 20);
END;