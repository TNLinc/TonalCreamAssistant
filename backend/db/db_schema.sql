CREATE SCHEMA IF NOT EXISTS vendor;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DO $$
BEGIN
    CREATE TYPE vendor.product_type AS ENUM ( 'TONAL_CREAM'
);
EXCEPTION
WHEN duplicate_object THEN
    NULL;
END $$;

CREATE TABLE IF NOT EXISTS vendor.vendor (
        id uuid DEFAULT uuid_generate_v4 () NOT NULL CONSTRAINT vendor_vendor_pkey PRIMARY KEY,
        name text NOT NULL,
        url varchar(200)
);

CREATE TABLE IF NOT EXISTS vendor.vendor_color (
        id uuid DEFAULT uuid_generate_v4 () NOT NULL CONSTRAINT vendor_color_pk PRIMARY KEY,
        name text NOT NULL,
        color varchar(18) NOT NULL
);

CREATE TABLE IF NOT EXISTS vendor.product (
        id uuid DEFAULT uuid_generate_v4 () NOT NULL CONSTRAINT vendor_product_pkey PRIMARY KEY,
        name text NOT NULL,
        TYPE vendor.product_type NOT NULL,
        vendor_id uuid NOT NULL CONSTRAINT vendor_product_vendor_id_fk_vendor_vendor_id REFERENCES vendor.vendor ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
        color_id uuid NOT NULL CONSTRAINT vendor_product_color_id_fk_vendor_vendor_color_id REFERENCES vendor.vendor_color ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
        url text
);

