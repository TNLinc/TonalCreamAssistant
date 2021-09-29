-- Создаем отдельную схему для производителей чтобы не перемешалось с сущностями Django
CREATE SCHEMA IF NOT EXISTS vendor;
-- Подключение расширения с поддержкой генерации uuid
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- Производители косметики
CREATE TABLE IF NOT EXISTS vendor.vendor
(
    id   uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    url  character varying(200),
    CONSTRAINT vendor_vendor_pkey PRIMARY KEY (id)
);
-- Создание перечисления для выбора типа продукта косметики
DO
$$
    BEGIN
        CREATE TYPE vendor.product_type AS ENUM ('TONAL_CREAM');
    EXCEPTION
        WHEN duplicate_object THEN null;
    END
$$;
-- Продукты косметики
CREATE TABLE IF NOT EXISTS vendor.product
(
    id        uuid                  NOT NULL DEFAULT uuid_generate_v4(),
    name      text                  NOT NULL,
    type      vendor.product_type   NOT NULL,
    color     character varying(18) NOT NULL,
    vendor_id uuid                  NOT NULL,
    CONSTRAINT vendor_product_pkey PRIMARY KEY (id),
    CONSTRAINT vendor_product_vendor_id_fk_vendor_vendor_id FOREIGN KEY (vendor_id)
        REFERENCES vendor.vendor (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED
);