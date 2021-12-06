CREATE SCHEMA IF NOT EXISTS vendor;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DO
$$
    BEGIN
        CREATE TYPE vendor.product_type AS ENUM ( 'TONAL_CREAM'
            );
    EXCEPTION
        WHEN duplicate_object THEN
            NULL;
    END
$$;

create table if not exists vendor.vendor
(
    id   uuid default uuid_generate_v4() not null
        constraint vendor_vendor_pkey
            primary key,
    name text                            not null,
    url  varchar(200)
);

create table if not exists vendor.vendor_color
(
    id        uuid default uuid_generate_v4() not null
        constraint vendor_color_pk
            primary key,
    name      text                            not null,
    color     varchar(18)                     not null,
    vendor_id uuid                            not null
        constraint vendor_color_vendor_id_fk
            references vendor.vendor
            on delete cascade
);

create table if not exists vendor.product
(
    id        uuid default uuid_generate_v4() not null
        constraint vendor_product_pkey
            primary key,
    name      text                            not null,
    type      vendor.product_type             not null,
    vendor_id uuid                            not null
        constraint vendor_product_vendor_id_fk_vendor_vendor_id
            references vendor.vendor
            on delete cascade
            deferrable initially deferred,
    color_id  uuid                            not null
        constraint vendor_product_color_id_fk_vendor_vendor_color_id
            references vendor.vendor_color
            on delete cascade
            deferrable initially deferred,
    url       text
);


