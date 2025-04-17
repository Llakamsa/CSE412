--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Ubuntu 14.17-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.17 (Ubuntu 14.17-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: membership; Type: TABLE; Schema: public; Owner: residence_user
--

CREATE TABLE public.membership (
    membership_id integer NOT NULL,
    join_date date,
    user_id integer,
    group_id integer
);


ALTER TABLE public.membership OWNER TO residence_user;

--
-- Name: membership_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: residence_user
--

CREATE SEQUENCE public.membership_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.membership_membership_id_seq OWNER TO residence_user;

--
-- Name: membership_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: residence_user
--

ALTER SEQUENCE public.membership_membership_id_seq OWNED BY public.membership.membership_id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: residence_user
--

CREATE TABLE public.notification (
    notification_id integer NOT NULL,
    message text,
    sent_date timestamp without time zone,
    user_id integer,
    status character varying(50),
    group_id integer
);


ALTER TABLE public.notification OWNER TO residence_user;

--
-- Name: notification_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: residence_user
--

CREATE SEQUENCE public.notification_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_notification_id_seq OWNER TO residence_user;

--
-- Name: notification_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: residence_user
--

ALTER SEQUENCE public.notification_notification_id_seq OWNED BY public.notification.notification_id;


--
-- Name: payment; Type: TABLE; Schema: public; Owner: residence_user
--

CREATE TABLE public.payment (
    payment_id integer NOT NULL,
    payment_date date,
    amount_paid numeric(10,2),
    notes text,
    status character varying(50),
    user_id integer,
    group_id integer
);


ALTER TABLE public.payment OWNER TO residence_user;

--
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: residence_user
--

CREATE SEQUENCE public.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_payment_id_seq OWNER TO residence_user;

--
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: residence_user
--

ALTER SEQUENCE public.payment_payment_id_seq OWNED BY public.payment.payment_id;


--
-- Name: residencegroup; Type: TABLE; Schema: public; Owner: residence_user
--

CREATE TABLE public.residencegroup (
    group_id integer NOT NULL,
    group_name character varying(255),
    due_date date,
    total_rent numeric(10,2),
    address character varying(255)
);


ALTER TABLE public.residencegroup OWNER TO residence_user;

--
-- Name: residencegroup_group_id_seq; Type: SEQUENCE; Schema: public; Owner: residence_user
--

CREATE SEQUENCE public.residencegroup_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.residencegroup_group_id_seq OWNER TO residence_user;

--
-- Name: residencegroup_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: residence_user
--

ALTER SEQUENCE public.residencegroup_group_id_seq OWNED BY public.residencegroup.group_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: residence_user
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    full_name character varying(255),
    email character varying(255),
    password character varying(255),
    phone_number character varying(20)
);


ALTER TABLE public.users OWNER TO residence_user;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: residence_user
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO residence_user;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: residence_user
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: membership membership_id; Type: DEFAULT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.membership ALTER COLUMN membership_id SET DEFAULT nextval('public.membership_membership_id_seq'::regclass);


--
-- Name: notification notification_id; Type: DEFAULT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.notification ALTER COLUMN notification_id SET DEFAULT nextval('public.notification_notification_id_seq'::regclass);


--
-- Name: payment payment_id; Type: DEFAULT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.payment ALTER COLUMN payment_id SET DEFAULT nextval('public.payment_payment_id_seq'::regclass);


--
-- Name: residencegroup group_id; Type: DEFAULT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.residencegroup ALTER COLUMN group_id SET DEFAULT nextval('public.residencegroup_group_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: residence_user
--

COPY public.membership (membership_id, join_date, user_id, group_id) FROM stdin;
1	2025-04-03	2	1
34	2025-04-04	2	34
35	2025-04-04	4	1
36	2025-04-04	4	34
37	2025-04-04	5	35
38	2025-04-04	5	1
39	2025-04-04	6	36
40	2025-04-04	6	1
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: residence_user
--

COPY public.notification (notification_id, message, sent_date, user_id, status, group_id) FROM stdin;
2	Hello There!	2025-04-04 16:14:30.34544	2	Unread	34
3	Testing testing	2025-04-04 16:21:19.662389	2	Unread	1
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: residence_user
--

COPY public.payment (payment_id, payment_date, amount_paid, notes, status, user_id, group_id) FROM stdin;
1	2025-04-04	300.00	Test Note	Paid	2	1
2	2025-04-04	400.00	Test Again	Paid	2	34
35	2025-04-04	10.00	Note	Paid	2	1
\.


--
-- Data for Name: residencegroup; Type: TABLE DATA; Schema: public; Owner: residence_user
--

COPY public.residencegroup (group_id, group_name, due_date, total_rent, address) FROM stdin;
1	a	2025-04-05	1200.00	a
34	b	2025-04-11	1200.00	b
35	rt	2025-04-24	1200.00	704 Both st
36	c	2025-04-22	1111.00	svdfv
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: residence_user
--

COPY public.users (user_id, full_name, email, password, phone_number) FROM stdin;
1	Bob	bob@gmail.com	\\x2432622431322450684931445a4e44537a61484d2e38643871796a37756645317053345261636b653366514d4b7742507a6270794a597365437a612e	1234567890
2	brad	brad@gmail.com	123	1234444444
4	sean	sean@gmail.com	111	1234567891
5	Rasa	rtr@gmail.com	1	3333333333
6	Trial	trial@gmail.com	12	1434343434
\.


--
-- Name: membership_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: residence_user
--

SELECT pg_catalog.setval('public.membership_membership_id_seq', 40, true);


--
-- Name: notification_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: residence_user
--

SELECT pg_catalog.setval('public.notification_notification_id_seq', 3, true);


--
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: residence_user
--

SELECT pg_catalog.setval('public.payment_payment_id_seq', 35, true);


--
-- Name: residencegroup_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: residence_user
--

SELECT pg_catalog.setval('public.residencegroup_group_id_seq', 36, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: residence_user
--

SELECT pg_catalog.setval('public.users_user_id_seq', 6, true);


--
-- Name: membership membership_pkey; Type: CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_pkey PRIMARY KEY (membership_id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (notification_id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: residencegroup residencegroup_pkey; Type: CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.residencegroup
    ADD CONSTRAINT residencegroup_pkey PRIMARY KEY (group_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: membership membership_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.residencegroup(group_id) ON DELETE CASCADE;


--
-- Name: membership membership_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: notification notification_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.residencegroup(group_id) ON DELETE CASCADE;


--
-- Name: notification notification_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: payment payment_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.residencegroup(group_id) ON DELETE CASCADE;


--
-- Name: payment payment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: residence_user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

