--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying,
    body text,
    resource_id character varying NOT NULL,
    resource_type character varying NOT NULL,
    author_type character varying,
    author_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: booking_item_stocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE booking_item_stocks (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    item_stock_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: booking_item_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE booking_item_stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: booking_item_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE booking_item_stocks_id_seq OWNED BY booking_item_stocks.id;


--
-- Name: booking_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE booking_items (
    id integer NOT NULL,
    item_id integer NOT NULL,
    booking_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity_ordered integer DEFAULT 0
);


--
-- Name: booking_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE booking_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: booking_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE booking_items_id_seq OWNED BY booking_items.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bookings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    address character varying NOT NULL,
    booking_type integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_name character varying(50) DEFAULT ''::character varying,
    contact_phone character varying(20) DEFAULT ''::character varying,
    read boolean DEFAULT false,
    status integer DEFAULT 0,
    comment text DEFAULT ''::text,
    city character varying DEFAULT ''::character varying,
    suburb character varying DEFAULT ''::character varying,
    state character varying DEFAULT ''::character varying,
    country character varying DEFAULT ''::character varying,
    tracking_id character varying DEFAULT ''::character varying
);


--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bookings_id_seq OWNED BY bookings.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contacts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    address character varying NOT NULL,
    phone character varying(20) NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    suburb character varying DEFAULT ''::character varying,
    city character varying DEFAULT ''::character varying,
    state character varying DEFAULT ''::character varying,
    country character varying DEFAULT ''::character varying
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE identities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    provider character varying,
    uid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invoices (
    id integer NOT NULL,
    user_id integer NOT NULL,
    space_usage double precision DEFAULT 0.0,
    num_items integer DEFAULT 0,
    invoice_date timestamp without time zone,
    paid boolean DEFAULT false,
    pdf_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


--
-- Name: item_location_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_location_histories (
    id integer NOT NULL,
    location_id integer NOT NULL,
    item_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_location_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_location_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_location_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_location_histories_id_seq OWNED BY item_location_histories.id;


--
-- Name: item_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_shares (
    id integer NOT NULL,
    item_id integer NOT NULL,
    secondary_owner_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_shares_id_seq OWNED BY item_shares.id;


--
-- Name: item_stocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_stocks (
    id integer NOT NULL,
    item_id integer NOT NULL,
    quantity_diff integer DEFAULT 0,
    quantity_in_storage integer DEFAULT 0,
    adjustment_type integer DEFAULT 0,
    description text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_stocks_id_seq OWNED BY item_stocks.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE items (
    id integer NOT NULL,
    user_id integer NOT NULL,
    image character varying DEFAULT ''::character varying NOT NULL,
    physical_id character varying DEFAULT ''::character varying NOT NULL,
    string character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    volume double precision DEFAULT 0.0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location_id integer,
    sku character varying DEFAULT ''::character varying,
    weight double precision DEFAULT 0.0,
    height double precision DEFAULT 0.0,
    width double precision DEFAULT 0.0,
    length double precision DEFAULT 0.0
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locations (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    "row" character varying DEFAULT ''::character varying,
    bay character varying DEFAULT ''::character varying,
    height character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: warehouses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE warehouses (
    id integer NOT NULL,
    address_1 character varying(100) DEFAULT ''::character varying,
    address_2 character varying(100) DEFAULT ''::character varying,
    suburb character varying(100) DEFAULT ''::character varying,
    postal_code character varying(100) DEFAULT ''::character varying,
    state integer DEFAULT 0,
    capacity integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: warehouses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE warehouses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE warehouses_id_seq OWNED BY warehouses.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: booking_item_stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_item_stocks ALTER COLUMN id SET DEFAULT nextval('booking_item_stocks_id_seq'::regclass);


--
-- Name: booking_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_items ALTER COLUMN id SET DEFAULT nextval('booking_items_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookings ALTER COLUMN id SET DEFAULT nextval('bookings_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


--
-- Name: item_location_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_location_histories ALTER COLUMN id SET DEFAULT nextval('item_location_histories_id_seq'::regclass);


--
-- Name: item_shares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_shares ALTER COLUMN id SET DEFAULT nextval('item_shares_id_seq'::regclass);


--
-- Name: item_stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_stocks ALTER COLUMN id SET DEFAULT nextval('item_stocks_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY warehouses ALTER COLUMN id SET DEFAULT nextval('warehouses_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: booking_item_stocks booking_item_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_item_stocks
    ADD CONSTRAINT booking_item_stocks_pkey PRIMARY KEY (id);


--
-- Name: booking_items booking_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_items
    ADD CONSTRAINT booking_items_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: item_location_histories item_location_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_location_histories
    ADD CONSTRAINT item_location_histories_pkey PRIMARY KEY (id);


--
-- Name: item_shares item_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_shares
    ADD CONSTRAINT item_shares_pkey PRIMARY KEY (id);


--
-- Name: item_stocks item_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_stocks
    ADD CONSTRAINT item_stocks_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_booking_item_stocks_on_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_booking_item_stocks_on_booking_id ON booking_item_stocks USING btree (booking_id);


--
-- Name: index_booking_item_stocks_on_item_stock_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_booking_item_stocks_on_item_stock_id ON booking_item_stocks USING btree (item_stock_id);


--
-- Name: index_booking_items_on_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_booking_items_on_booking_id ON booking_items USING btree (booking_id);


--
-- Name: index_booking_items_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_booking_items_on_item_id ON booking_items USING btree (item_id);


--
-- Name: index_booking_items_on_item_id_and_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_booking_items_on_item_id_and_booking_id ON booking_items USING btree (item_id, booking_id);


--
-- Name: index_bookings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_user_id ON bookings USING btree (user_id);


--
-- Name: index_contacts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_user_id ON contacts USING btree (user_id);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_user_id ON identities USING btree (user_id);


--
-- Name: index_invoices_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_user_id ON invoices USING btree (user_id);


--
-- Name: index_item_location_histories_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_location_histories_on_item_id ON item_location_histories USING btree (item_id);


--
-- Name: index_item_location_histories_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_location_histories_on_location_id ON item_location_histories USING btree (location_id);


--
-- Name: index_item_shares_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_shares_on_item_id ON item_shares USING btree (item_id);


--
-- Name: index_item_shares_on_item_id_and_secondary_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_shares_on_item_id_and_secondary_owner_id ON item_shares USING btree (item_id, secondary_owner_id);


--
-- Name: index_item_shares_on_secondary_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_shares_on_secondary_owner_id ON item_shares USING btree (secondary_owner_id);


--
-- Name: index_item_stocks_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_stocks_on_item_id ON item_stocks USING btree (item_id);


--
-- Name: index_items_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_location_id ON items USING btree (location_id);


--
-- Name: index_items_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_user_id ON items USING btree (user_id);


--
-- Name: index_locations_on_warehouse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_warehouse_id ON locations USING btree (warehouse_id);


--
-- Name: index_locations_on_warehouse_id_and_row_and_bay_and_height; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_warehouse_id_and_row_and_bay_and_height ON locations USING btree (warehouse_id, "row", bay, height);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: booking_item_stocks fk_rails_2d9f60da98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_item_stocks
    ADD CONSTRAINT fk_rails_2d9f60da98 FOREIGN KEY (booking_id) REFERENCES bookings(id);


--
-- Name: booking_items fk_rails_3a296e793d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_items
    ADD CONSTRAINT fk_rails_3a296e793d FOREIGN KEY (booking_id) REFERENCES bookings(id);


--
-- Name: invoices fk_rails_3d1522a0d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT fk_rails_3d1522a0d8 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: identities fk_rails_5373344100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT fk_rails_5373344100 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: booking_item_stocks fk_rails_53860f9061; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_item_stocks
    ADD CONSTRAINT fk_rails_53860f9061 FOREIGN KEY (item_stock_id) REFERENCES item_stocks(id) ON DELETE CASCADE;


--
-- Name: locations fk_rails_5ca549b87e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT fk_rails_5ca549b87e FOREIGN KEY (warehouse_id) REFERENCES warehouses(id);


--
-- Name: booking_items fk_rails_74745067bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY booking_items
    ADD CONSTRAINT fk_rails_74745067bf FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: contacts fk_rails_8d2134e55e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT fk_rails_8d2134e55e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: item_location_histories fk_rails_93313a6c5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_location_histories
    ADD CONSTRAINT fk_rails_93313a6c5f FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: item_stocks fk_rails_95760101ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_stocks
    ADD CONSTRAINT fk_rails_95760101ae FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE;


--
-- Name: item_location_histories fk_rails_af5fabe583; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_location_histories
    ADD CONSTRAINT fk_rails_af5fabe583 FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: item_shares fk_rails_c53748a8b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_shares
    ADD CONSTRAINT fk_rails_c53748a8b4 FOREIGN KEY (secondary_owner_id) REFERENCES users(id);


--
-- Name: item_shares fk_rails_ce0b898b9f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_shares
    ADD CONSTRAINT fk_rails_ce0b898b9f FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: items fk_rails_d4b6334db2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_d4b6334db2 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: items fk_rails_e8ed83a2e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_e8ed83a2e6 FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: bookings fk_rails_ef0571f117; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookings
    ADD CONSTRAINT fk_rails_ef0571f117 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160817162141'), ('20160817164349'), ('20160817171944'), ('20160817171946'), ('20160818000436'), ('20160819025730'), ('20160822120506'), ('20160826052746'), ('20160928014604'), ('20161002165900'), ('20161003143142'), ('20161003152403'), ('20161004032353'), ('20161012155456'), ('20161028065015'), ('20161115015017'), ('20161118081232'), ('20161124013518'), ('20161124072220'), ('20161124074512'), ('20161127025226'), ('20161127123250'), ('20161202025354'), ('20170110024324'), ('20170110024915'), ('20170110064014'), ('20170113033804'), ('20170116014102'), ('20170116014520'), ('20170117020941'), ('20170118004837'), ('20170206055544'), ('20170209051430'), ('20170214012434'), ('20170215050652'), ('20170227080659'), ('20170316124920'), ('20170316124959'), ('20170316130933'), ('20170316131150'), ('20170320122633'), ('20170322125818'), ('20170322130141'), ('20170403061831'), ('20170403062042'), ('20170403062055'), ('20170403062107'), ('20170403062249'), ('20170403062338'), ('20170403062404'), ('20170403062418'), ('20170424063249');


