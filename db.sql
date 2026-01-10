--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-10-15 19:25:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 243 (class 1255 OID 24579)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW."updatedAt" = now();
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 240 (class 1259 OID 32772)
-- Name: bank_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_assignments (
    id integer NOT NULL,
    caseid character varying(50) NOT NULL,
    bankid integer NOT NULL,
    document_config jsonb NOT NULL,
    createdat timestamp without time zone DEFAULT now(),
    updatedat timestamp without time zone DEFAULT now(),
    status character varying(36) DEFAULT 'pending'::character varying
);


ALTER TABLE public.bank_assignments OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24580)
-- Name: banks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banks (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    phone character varying(20),
    products jsonb
);


ALTER TABLE public.banks OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24585)
-- Name: banks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banks_id_seq OWNER TO postgres;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 218
-- Name: banks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banks_id_seq OWNED BY public.banks.id;


--
-- TOC entry 219 (class 1259 OID 24586)
-- Name: case_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.case_assignments (
    id integer NOT NULL,
    caseid character varying(20) NOT NULL,
    assigned_to integer,
    role character varying(50) NOT NULL,
    assigned_by integer,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    assigned_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.case_assignments OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24591)
-- Name: case_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.case_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.case_assignments_id_seq OWNER TO postgres;

--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 220
-- Name: case_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.case_assignments_id_seq OWNED BY public.case_assignments.id;


--
-- TOC entry 221 (class 1259 OID 24592)
-- Name: case_stages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.case_stages (
    id integer NOT NULL,
    caseid character varying(50),
    stage character varying(50),
    status character varying(20) DEFAULT 'Pending'::character varying,
    updated_by integer,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.case_stages OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24597)
-- Name: case_stages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.case_stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.case_stages_id_seq OWNER TO postgres;

--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 222
-- Name: case_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.case_stages_id_seq OWNED BY public.case_stages.id;


--
-- TOC entry 223 (class 1259 OID 24598)
-- Name: cases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cases (
    id integer NOT NULL,
    caseid character varying(20),
    companyname character varying(100),
    clientname character varying(100),
    role character varying(50),
    status character varying(50),
    createdby integer,
    productname character varying(100),
    assigned_to_name character varying(100),
    assignee character varying(100),
    stage character varying(50),
    bankname character varying(100),
    updatedat timestamp without time zone DEFAULT now(),
    spocname text,
    spocemail text,
    spocphonenumber text,
    leadsource text,
    date text,
    "time" text,
    phonenumber text,
    turnover text,
    location text,
    companyemail character varying(255),
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    assigneddate timestamp without time zone,
    requirement_amount character varying(50) DEFAULT NULL::character varying,
    status_updated_on timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cases OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24605)
-- Name: cases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cases_id_seq OWNER TO postgres;

--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 224
-- Name: cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cases_id_seq OWNED BY public.cases.id;


--
-- TOC entry 225 (class 1259 OID 24606)
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    caseid character varying(20),
    comment text,
    role character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    commentby character varying(100)
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24612)
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO postgres;

--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 226
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- TOC entry 239 (class 1259 OID 32771)
-- Name: document_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.document_configurations_id_seq OWNER TO postgres;

--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 239
-- Name: document_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_configurations_id_seq OWNED BY public.bank_assignments.id;


--
-- TOC entry 227 (class 1259 OID 24613)
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    caseid character varying(20),
    doctype character varying(50),
    filename text,
    uploadedat timestamp without time zone DEFAULT now(),
    docname text
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24619)
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO postgres;

--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 228
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- TOC entry 242 (class 1259 OID 40963)
-- Name: provisional_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provisional_documents (
    id integer NOT NULL,
    caseid character varying(50) NOT NULL,
    document_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    requested_by integer
);


ALTER TABLE public.provisional_documents OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 40962)
-- Name: provisional_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.provisional_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.provisional_documents_id_seq OWNER TO postgres;

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 241
-- Name: provisional_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.provisional_documents_id_seq OWNED BY public.provisional_documents.id;


--
-- TOC entry 229 (class 1259 OID 24620)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    rolename character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24623)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 230
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 231 (class 1259 OID 24624)
-- Name: status_matrix; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_matrix (
    id integer NOT NULL,
    roleid integer NOT NULL,
    key integer,
    value character varying(255),
    "subStatus" json
);


ALTER TABLE public.status_matrix OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24629)
-- Name: status_matrix_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_matrix_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_matrix_id_seq OWNER TO postgres;

--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 232
-- Name: status_matrix_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_matrix_id_seq OWNED BY public.status_matrix.id;


--
-- TOC entry 233 (class 1259 OID 24630)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    password text,
    phone character varying(20),
    company character varying(100),
    roleid integer,
    pocname character varying(255),
    pocphone character varying(20)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24635)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 234
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 235 (class 1259 OID 24636)
-- Name: workflow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow (
    id integer NOT NULL,
    caseid character varying(20),
    stage character varying(50),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.workflow OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24640)
-- Name: workflow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workflow_id_seq OWNER TO postgres;

--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 236
-- Name: workflow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_id_seq OWNED BY public.workflow.id;


--
-- TOC entry 237 (class 1259 OID 24641)
-- Name: workflow_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_logs (
    id integer NOT NULL,
    caseid character varying(255) NOT NULL,
    stage character varying(255) NOT NULL,
    updatedby character varying(255) NOT NULL,
    updatedat timestamp with time zone NOT NULL
);


ALTER TABLE public.workflow_logs OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 24646)
-- Name: workflow_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workflow_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 238
-- Name: workflow_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_logs_id_seq OWNED BY public.workflow_logs.id;


--
-- TOC entry 4825 (class 2604 OID 32775)
-- Name: bank_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_assignments ALTER COLUMN id SET DEFAULT nextval('public.document_configurations_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 24647)
-- Name: banks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banks ALTER COLUMN id SET DEFAULT nextval('public.banks_id_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 24648)
-- Name: case_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments ALTER COLUMN id SET DEFAULT nextval('public.case_assignments_id_seq'::regclass);


--
-- TOC entry 4807 (class 2604 OID 24649)
-- Name: case_stages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages ALTER COLUMN id SET DEFAULT nextval('public.case_stages_id_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 24650)
-- Name: cases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases ALTER COLUMN id SET DEFAULT nextval('public.cases_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 24651)
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 24652)
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- TOC entry 4829 (class 2604 OID 40966)
-- Name: provisional_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provisional_documents ALTER COLUMN id SET DEFAULT nextval('public.provisional_documents_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 24653)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 24654)
-- Name: status_matrix id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_matrix ALTER COLUMN id SET DEFAULT nextval('public.status_matrix_id_seq'::regclass);


--
-- TOC entry 4821 (class 2604 OID 24655)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 24656)
-- Name: workflow id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow ALTER COLUMN id SET DEFAULT nextval('public.workflow_id_seq'::regclass);


--
-- TOC entry 4824 (class 2604 OID 24657)
-- Name: workflow_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_logs ALTER COLUMN id SET DEFAULT nextval('public.workflow_logs_id_seq'::regclass);


--
-- TOC entry 5046 (class 0 OID 32772)
-- Dependencies: 240
-- Data for Name: bank_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_assignments (id, caseid, bankid, document_config, createdat, updatedat, status) FROM stdin;
20	CASE1757226559546	1	{"partA_Debt sheet": false, "partA_Company profile": false, "partA_Sanction Letters": true, "partB_Company and promoters KYC": true}	2025-09-08 21:19:54.471786	2025-09-08 21:19:54.471786	pending
21	CASE1757226559546	3	{"partA_Debt sheet": true, "onePager_OnePager": false, "partB_Collateral full set": false, "partA_Work order - if applicable": true}	2025-09-08 21:19:54.474235	2025-09-08 21:19:54.474235	pending
33	CASE1757322293741	1	{"partA_Debt sheet": true, "provisional_Ops Prov Doc One": true, "partA_Latest year provisionals": true, "partA_Work order - if applicable": true}	2025-09-16 10:47:33.747937	2025-09-16 10:48:44.914509	ACCEPT
34	CASE050	4	{"partA_Debt sheet": true, "onePager_OnePager": true, "partB_Collateral full set": true, "provisional_opr_prv_doc_1": true, "partA_Latest year provisionals": true}	2025-10-15 08:15:46.140326	2025-10-15 08:49:41.122851	ACCEPT
\.


--
-- TOC entry 5023 (class 0 OID 24580)
-- Dependencies: 217
-- Data for Name: banks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banks (id, name, email, phone, products) FROM stdin;
4	ICICI Bank	icici@bank.com	9999990004	["Business Expansion Loan"]
3	Axis Bank	hello@axisbank.com	9999990003	["Vehicle Finance", "Working Capital Loan"]
2	HDFC Bank	priya@hdfc.com	9999990002	["Loan Against Property"]
1	State Bank of India	contact@sbi.com	9999990001	["Working Capital Loan", "Loan Against Property"]
6	State Bank of India	sbi1@bankmail.com	+919000000001	["Home Loan", "Car Loan", "Personal Loan"]
7	HDFC Bank	hdfc2@bankmail.com	+919000000002	["Business Loan", "Education Loan", "Fixed Deposit"]
8	ICICI Bank	icici3@bankmail.com	+919000000003	["Working Capital Loan", "Loan Against Property"]
9	Axis Bank	axis4@bankmail.com	+919000000004	["Gold Loan", "Corporate Loan"]
10	Punjab National Bank	pnb5@bankmail.com	+919000000005	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
11	State Bank of India	sbi6@bankmail.com	+919000000006	["Home Loan", "Car Loan", "Personal Loan"]
12	HDFC Bank	hdfc7@bankmail.com	+919000000007	["Business Loan", "Education Loan", "Fixed Deposit"]
13	ICICI Bank	icici8@bankmail.com	+919000000008	["Working Capital Loan", "Loan Against Property"]
14	Axis Bank	axis9@bankmail.com	+919000000009	["Gold Loan", "Corporate Loan"]
15	Punjab National Bank	pnb10@bankmail.com	+919000000010	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
16	State Bank of India	sbi11@bankmail.com	+919000000011	["Home Loan", "Car Loan", "Personal Loan"]
17	HDFC Bank	hdfc12@bankmail.com	+919000000012	["Business Loan", "Education Loan", "Fixed Deposit"]
18	ICICI Bank	icici13@bankmail.com	+919000000013	["Working Capital Loan", "Loan Against Property"]
19	Axis Bank	axis14@bankmail.com	+919000000014	["Gold Loan", "Corporate Loan"]
20	Punjab National Bank	pnb15@bankmail.com	+919000000015	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
21	State Bank of India	sbi16@bankmail.com	+919000000016	["Home Loan", "Car Loan", "Personal Loan"]
22	HDFC Bank	hdfc17@bankmail.com	+919000000017	["Business Loan", "Education Loan", "Fixed Deposit"]
23	ICICI Bank	icici18@bankmail.com	+919000000018	["Working Capital Loan", "Loan Against Property"]
24	Axis Bank	axis19@bankmail.com	+919000000019	["Gold Loan", "Corporate Loan"]
25	Punjab National Bank	pnb20@bankmail.com	+919000000020	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
26	State Bank of India	sbi21@bankmail.com	+919000000021	["Home Loan", "Car Loan", "Personal Loan"]
27	HDFC Bank	hdfc22@bankmail.com	+919000000022	["Business Loan", "Education Loan", "Fixed Deposit"]
28	ICICI Bank	icici23@bankmail.com	+919000000023	["Working Capital Loan", "Loan Against Property"]
29	Axis Bank	axis24@bankmail.com	+919000000024	["Gold Loan", "Corporate Loan"]
30	Punjab National Bank	pnb25@bankmail.com	+919000000025	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
31	State Bank of India	sbi26@bankmail.com	+919000000026	["Home Loan", "Car Loan", "Personal Loan"]
32	HDFC Bank	hdfc27@bankmail.com	+919000000027	["Business Loan", "Education Loan", "Fixed Deposit"]
33	ICICI Bank	icici28@bankmail.com	+919000000028	["Working Capital Loan", "Loan Against Property"]
34	Axis Bank	axis29@bankmail.com	+919000000029	["Gold Loan", "Corporate Loan"]
35	Punjab National Bank	pnb30@bankmail.com	+919000000030	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
36	State Bank of India	sbi31@bankmail.com	+919000000031	["Home Loan", "Car Loan", "Personal Loan"]
37	HDFC Bank	hdfc32@bankmail.com	+919000000032	["Business Loan", "Education Loan", "Fixed Deposit"]
38	ICICI Bank	icici33@bankmail.com	+919000000033	["Working Capital Loan", "Loan Against Property"]
39	Axis Bank	axis34@bankmail.com	+919000000034	["Gold Loan", "Corporate Loan"]
40	Punjab National Bank	pnb35@bankmail.com	+919000000035	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
41	State Bank of India	sbi36@bankmail.com	+919000000036	["Home Loan", "Car Loan", "Personal Loan"]
42	HDFC Bank	hdfc37@bankmail.com	+919000000037	["Business Loan", "Education Loan", "Fixed Deposit"]
43	ICICI Bank	icici38@bankmail.com	+919000000038	["Working Capital Loan", "Loan Against Property"]
44	Axis Bank	axis39@bankmail.com	+919000000039	["Gold Loan", "Corporate Loan"]
45	Punjab National Bank	pnb40@bankmail.com	+919000000040	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
46	State Bank of India	sbi41@bankmail.com	+919000000041	["Home Loan", "Car Loan", "Personal Loan"]
47	HDFC Bank	hdfc42@bankmail.com	+919000000042	["Business Loan", "Education Loan", "Fixed Deposit"]
48	ICICI Bank	icici43@bankmail.com	+919000000043	["Working Capital Loan", "Loan Against Property"]
49	Axis Bank	axis44@bankmail.com	+919000000044	["Gold Loan", "Corporate Loan"]
50	Punjab National Bank	pnb45@bankmail.com	+919000000045	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
51	State Bank of India	sbi46@bankmail.com	+919000000046	["Home Loan", "Car Loan", "Personal Loan"]
52	HDFC Bank	hdfc47@bankmail.com	+919000000047	["Business Loan", "Education Loan", "Fixed Deposit"]
53	ICICI Bank	icici48@bankmail.com	+919000000048	["Working Capital Loan", "Loan Against Property"]
54	Axis Bank	axis49@bankmail.com	+919000000049	["Gold Loan", "Corporate Loan"]
55	Punjab National Bank	pnb50@bankmail.com	+919000000050	["Overdraft Facility", "Savings Account", "Recurring Deposit"]
\.


--
-- TOC entry 5025 (class 0 OID 24586)
-- Dependencies: 219
-- Data for Name: case_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.case_assignments (id, caseid, assigned_to, role, assigned_by, assigned_at, assigned_date) FROM stdin;
119	CASE1757220089910	4	KAM	\N	2025-09-07 10:11:30.039117	2025-09-07 10:11:30.039117
120	CASE1757220089910	6	Operations	\N	2025-09-07 10:11:30.047139	2025-09-07 10:11:30.047139
121	CASE1757220089910	3	Telecaller	\N	2025-09-07 10:11:30.048612	2025-09-07 10:11:30.048612
122	CASE1757226559546	4	KAM	\N	2025-09-07 11:59:19.713467	2025-09-07 11:59:19.713467
123	CASE1757226559546	6	Operations	\N	2025-09-07 11:59:19.719796	2025-09-07 11:59:19.719796
124	CASE1757226559546	3	Telecaller	\N	2025-09-07 11:59:19.72204	2025-09-07 11:59:19.72204
125	CASE1757226559546	5	UW	\N	2025-09-07 12:21:38.073114	2025-09-07 12:21:38.073114
153	CASE1757322293741	27	Banker	\N	2025-09-16 10:47:33.749194	2025-09-16 10:47:33.749194
156	CASE1759117612803	4	KAM	\N	2025-09-29 09:16:53.08849	2025-09-29 09:16:53.08849
157	CASE1759117612803	6	Operations	\N	2025-09-29 09:16:53.098545	2025-09-29 09:16:53.098545
158	CASE1759117612803	3	Telecaller	\N	2025-09-29 09:16:53.099797	2025-09-29 09:16:53.099797
165	CASE050	\N	Banker	\N	2025-10-15 08:15:46.150353	2025-10-15 08:15:46.150353
\.


--
-- TOC entry 5027 (class 0 OID 24592)
-- Dependencies: 221
-- Data for Name: case_stages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.case_stages (id, caseid, stage, status, updated_by, updated_at) FROM stdin;
\.


--
-- TOC entry 5029 (class 0 OID 24598)
-- Dependencies: 223
-- Data for Name: cases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cases (id, caseid, companyname, clientname, role, status, createdby, productname, assigned_to_name, assignee, stage, bankname, updatedat, spocname, spocemail, spocphonenumber, leadsource, date, "time", phonenumber, turnover, location, companyemail, createddate, assigneddate, requirement_amount, status_updated_on) FROM stdin;
30	CASE001	Tech Solutions Ltd	John Smith	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	John Smith	john@techsolutions.com	9876543210	\N	2025-01-15	10:00	9876543210	50 CR	Mumbai	info@techsolutions.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	5000000	2025-10-15 07:33:13.240987
31	CASE002	Global Enterprises	Sarah Johnson	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Sarah Johnson	sarah@global.com	9876543211	\N	2025-01-15	11:00	9876543211	75 CR	Delhi	contact@global.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7500000	2025-10-15 07:33:13.240987
32	CASE003	Innovation Corp	Mike Wilson	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Mike Wilson	mike@innovation.com	9876543212	\N	2025-01-15	12:00	9876543212	30 CR	Bangalore	info@innovation.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3000000	2025-10-15 07:33:13.240987
33	CASE004	Future Industries	Emily Davis	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Emily Davis	emily@future.com	9876543213	\N	2025-01-15	13:00	9876543213	100 CR	Chennai	contact@future.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	10000000	2025-10-15 07:33:13.240987
34	CASE005	Smart Manufacturing	David Brown	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	David Brown	david@smart.com	9876543214	\N	2025-01-15	14:00	9876543214	60 CR	Pune	info@smart.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6000000	2025-10-15 07:33:13.240987
35	CASE006	Alpha Trading	Lisa Garcia	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Lisa Garcia	lisa@alpha.com	9876543215	\N	2025-01-15	15:00	9876543215	45 CR	Hyderabad	contact@alpha.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4500000	2025-10-15 07:33:13.240987
36	CASE007	Beta Services	Robert Miller	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Robert Miller	robert@beta.com	9876543216	\N	2025-01-15	16:00	9876543216	25 CR	Kolkata	info@beta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2500000	2025-10-15 07:33:13.240987
37	CASE008	Gamma Solutions	Jennifer Taylor	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Jennifer Taylor	jennifer@gamma.com	9876543217	\N	2025-01-15	17:00	9876543217	80 CR	Ahmedabad	contact@gamma.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	8000000	2025-10-15 07:33:13.240987
38	CASE009	Delta Logistics	Christopher Anderson	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Christopher Anderson	chris@delta.com	9876543218	\N	2025-01-15	18:00	9876543218	35 CR	Jaipur	info@delta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3500000	2025-10-15 07:33:13.240987
39	CASE010	Epsilon Tech	Amanda Thomas	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Amanda Thomas	amanda@epsilon.com	9876543219	\N	2025-01-15	09:00	9876543219	90 CR	Surat	contact@epsilon.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	9000000	2025-10-15 07:33:13.240987
40	CASE011	Zeta Industries	Daniel Jackson	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Daniel Jackson	daniel@zeta.com	9876543220	\N	2025-01-16	10:00	9876543220	40 CR	Lucknow	info@zeta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4000000	2025-10-15 07:33:13.240987
41	CASE012	Eta Manufacturing	Michelle White	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Michelle White	michelle@eta.com	9876543221	\N	2025-01-16	11:00	9876543221	65 CR	Kanpur	contact@eta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6500000	2025-10-15 07:33:13.240987
42	CASE013	Theta Consulting	Joshua Harris	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Joshua Harris	joshua@theta.com	9876543222	\N	2025-01-16	12:00	9876543222	55 CR	Nagpur	info@theta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	5500000	2025-10-15 07:33:13.240987
43	CASE014	Iota Enterprises	Ashley Martin	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Ashley Martin	ashley@iota.com	9876543223	\N	2025-01-16	13:00	9876543223	70 CR	Indore	contact@iota.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7000000	2025-10-15 07:33:13.240987
44	CASE015	Kappa Solutions	Matthew Thompson	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Matthew Thompson	matthew@kappa.com	9876543224	\N	2025-01-16	14:00	9876543224	20 CR	Thane	info@kappa.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2000000	2025-10-15 07:33:13.240987
45	CASE016	Lambda Trading	Stephanie Garcia	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Stephanie Garcia	stephanie@lambda.com	9876543225	\N	2025-01-16	15:00	9876543225	85 CR	Bhopal	contact@lambda.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	8500000	2025-10-15 07:33:13.240987
46	CASE017	Mu Services	Andrew Martinez	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Andrew Martinez	andrew@mu.com	9876543226	\N	2025-01-16	16:00	9876543226	42 CR	Visakhapatnam	info@mu.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4200000	2025-10-15 07:33:13.240987
47	CASE018	Nu Industries	Rachel Robinson	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Rachel Robinson	rachel@nu.com	9876543227	\N	2025-01-16	17:00	9876543227	58 CR	Pimpri	contact@nu.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	5800000	2025-10-15 07:33:13.240987
26	CASE1757322293741	Zettamin	Sekhar	Telecaller	One Pager	3	Loan Against Property	\N	\N	One Pager	\N	2025-09-16 04:23:27.28	Sekhar	sekhar@zettamine.com	7032125558	\N	2025-09-08	19:45	7032125558	1500 CR	https://www.google.com/maps?q=17.4293727874756,78.4560394287109	\N	2025-09-08 14:34:53.814	2025-09-08 14:34:53.814	150000000	2025-09-16 09:52:51.802466
48	CASE019	Xi Corporation	Kevin Clark	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Kevin Clark	kevin@xi.com	9876543228	\N	2025-01-16	18:00	9876543228	32 CR	Patna	info@xi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3200000	2025-10-15 07:33:13.240987
25	CASE1757226559546	Jamaswaive	Ravi Krishna	Telecaller	Underwriting	3	Working Capital Loan	\N	\N	Underwriting	\N	2025-09-09 03:08:19.662	Ravi	ravi@client.com	8333091257	\N	2025-09-07	14:00	8333091257	2500 CR	https://jsdl.in/DT-28SFNUBNP8X	\N	2025-09-07 11:59:19.585	2025-09-07 11:59:19.585	20000000	2025-09-16 08:04:00.669239
49	CASE020	Omicron Tech	Lauren Rodriguez	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Lauren Rodriguez	lauren@omicron.com	9876543229	\N	2025-01-16	09:00	9876543229	78 CR	Vadodara	contact@omicron.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7800000	2025-10-15 07:33:13.240987
29	CASE1759117612803	YERK Tech	Yugandhar Peddi	Telecaller	Open	3	\N	\N	\N	Documentation	\N	2025-09-29 09:16:53.038996	Yugandhar	yugandhar@yerk.com	9959281216	\N	2025-10-09	14:30	9959281216	12000000	https://www.google.com/local/place/fid/0x3a3943bc004232bd:0xf271506d5bf42435/photosphere?iu=https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid%3D7bOHj9HzklnElC2Tk8cyIg%26cb_client%3Dsearch.gws-prod.gps%26yaw%3D286.96033%26pitch%3D0%26thumbfov%3D100%26w%3D0%26h%3D0&ik=CAISFjdiT0hqOUh6a2xuRWxDMlRrOGN5SWc%3D&sa=X&ved=2ahUKEwjxpYH7hf2PAxURRmwGHTaJHMgQpx96BAhREAU	\N	2025-09-29 09:16:52.954	2025-09-29 09:16:52.954	\N	2025-09-29 09:16:53.038996
50	CASE021	Pi Solutions	Brandon Lewis	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Brandon Lewis	brandon@pi.com	9876543230	\N	2025-01-17	10:00	9876543230	48 CR	Ghaziabad	info@pi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4800000	2025-10-15 07:33:13.240987
51	CASE022	Rho Enterprises	Samantha Lee	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Samantha Lee	samantha@rho.com	9876543231	\N	2025-01-17	11:00	9876543231	63 CR	Ludhiana	contact@rho.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6300000	2025-10-15 07:33:13.240987
52	CASE023	Sigma Manufacturing	Tyler Walker	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Tyler Walker	tyler@sigma.com	9876543232	\N	2025-01-17	12:00	9876543232	28 CR	Agra	info@sigma.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2800000	2025-10-15 07:33:13.240987
53	CASE024	Tau Industries	Nicole Hall	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Nicole Hall	nicole@tau.com	9876543233	\N	2025-01-17	13:00	9876543233	73 CR	Nashik	contact@tau.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7300000	2025-10-15 07:33:13.240987
54	CASE025	Upsilon Services	Justin Allen	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Justin Allen	justin@upsilon.com	9876543234	\N	2025-01-17	14:00	9876543234	38 CR	Faridabad	info@upsilon.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3800000	2025-10-15 07:33:13.240987
55	CASE026	Phi Corporation	Crystal Young	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Crystal Young	crystal@phi.com	9876543235	\N	2025-01-17	15:00	9876543235	68 CR	Meerut	contact@phi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6800000	2025-10-15 07:33:13.240987
56	CASE027	Chi Trading	Austin Hernandez	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Austin Hernandez	austin@chi.com	9876543236	\N	2025-01-17	16:00	9876543236	24 CR	Rajkot	info@chi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2400000	2025-10-15 07:33:13.240987
57	CASE028	Psi Solutions	Brittany King	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Brittany King	brittany@psi.com	9876543237	\N	2025-01-17	17:00	9876543237	82 CR	Kalyan	contact@psi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	8200000	2025-10-15 07:33:13.240987
58	CASE029	Omega Enterprises	Cody Wright	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Cody Wright	cody@omega.com	9876543238	\N	2025-01-17	18:00	9876543238	52 CR	Vasai	info@omega.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	5200000	2025-10-15 07:33:13.240987
59	CASE030	Alpha Beta Corp	Megan Lopez	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Megan Lopez	megan@alphabeta.com	9876543239	\N	2025-01-17	09:00	9876543239	76 CR	Aurangabad	contact@alphabeta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7600000	2025-10-15 07:33:13.240987
60	CASE031	Beta Gamma Ltd	Trevor Hill	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Trevor Hill	trevor@betagamma.com	9876543240	\N	2025-01-18	10:00	9876543240	31 CR	Dhanbad	info@betagamma.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3100000	2025-10-15 07:33:13.240987
61	CASE032	Gamma Delta Inc	Courtney Scott	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Courtney Scott	courtney@gammadelta.com	9876543241	\N	2025-01-18	11:00	9876543241	67 CR	Amritsar	contact@gammadelta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6700000	2025-10-15 07:33:13.240987
62	CASE033	Delta Epsilon Co	Ian Green	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Ian Green	ian@deltaepsilon.com	9876543242	\N	2025-01-18	12:00	9876543242	41 CR	Allahabad	info@deltaepsilon.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4100000	2025-10-15 07:33:13.240987
63	CASE034	Epsilon Zeta LLC	Jenna Adams	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Jenna Adams	jenna@epsilonzeta.com	9876543243	\N	2025-01-18	13:00	9876543243	59 CR	Ranchi	contact@epsilonzeta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	5900000	2025-10-15 07:33:13.240987
64	CASE035	Zeta Eta Group	Derek Baker	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Derek Baker	derek@zetaeta.com	9876543244	\N	2025-01-18	14:00	9876543244	26 CR	Howrah	info@zetaeta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2600000	2025-10-15 07:33:13.240987
65	CASE036	Eta Theta Corp	Danielle Gonzalez	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Danielle Gonzalez	danielle@etatheta.com	9876543245	\N	2025-01-18	15:00	9876543245	74 CR	Jabalpur	contact@etatheta.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7400000	2025-10-15 07:33:13.240987
66	CASE037	Theta Iota Ltd	Caleb Nelson	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Caleb Nelson	caleb@thetaiota.com	9876543246	\N	2025-01-18	16:00	9876543246	44 CR	Gwalior	info@thetaiota.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4400000	2025-10-15 07:33:13.240987
67	CASE038	Iota Kappa Inc	Monica Carter	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Monica Carter	monica@iotakappa.com	9876543247	\N	2025-01-18	17:00	9876543247	61 CR	Coimbatore	contact@iotakappa.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6100000	2025-10-15 07:33:13.240987
68	CASE039	Kappa Lambda Co	Sean Mitchell	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Sean Mitchell	sean@kappalambda.com	9876543248	\N	2025-01-18	18:00	9876543248	29 CR	Madurai	info@kappalambda.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2900000	2025-10-15 07:33:13.240987
69	CASE040	Lambda Mu LLC	Tiffany Perez	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Tiffany Perez	tiffany@lambdamu.com	9876543249	\N	2025-01-18	09:00	9876543249	79 CR	Gurgaon	contact@lambdamu.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7900000	2025-10-15 07:33:13.240987
70	CASE041	Mu Nu Group	Jordan Roberts	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Jordan Roberts	jordan@munu.com	9876543250	\N	2025-01-19	10:00	9876543250	47 CR	Aligarh	info@munu.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4700000	2025-10-15 07:33:13.240987
71	CASE042	Nu Xi Corp	Heather Turner	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Heather Turner	heather@nuxi.com	9876543251	\N	2025-01-19	11:00	9876543251	64 CR	Moradabad	contact@nuxi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6400000	2025-10-15 07:33:13.240987
72	CASE043	Xi Omicron Ltd	Marcus Phillips	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Marcus Phillips	marcus@xiomicron.com	9876543252	\N	2025-01-19	12:00	9876543252	33 CR	Mysore	info@xiomicron.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3300000	2025-10-15 07:33:13.240987
73	CASE044	Omicron Pi Inc	Vanessa Campbell	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Vanessa Campbell	vanessa@omicronpi.com	9876543253	\N	2025-01-19	13:00	9876543253	71 CR	Bareilly	contact@omicronpi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7100000	2025-10-15 07:33:13.240987
74	CASE045	Pi Rho Co	Antonio Parker	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Antonio Parker	antonio@pirho.com	9876543254	\N	2025-01-19	14:00	9876543254	39 CR	Guntur	info@pirho.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	3900000	2025-10-15 07:33:13.240987
75	CASE046	Rho Sigma LLC	Patricia Evans	Telecaller	Open	1	Business Expansion Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Patricia Evans	patricia@rhosigma.com	9876543255	\N	2025-01-19	15:00	9876543255	66 CR	Jamnagar	contact@rhosigma.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	6600000	2025-10-15 07:33:13.240987
76	CASE047	Sigma Tau Group	Jesse Edwards	Telecaller	Open	1	Vehicle Finance	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Jesse Edwards	jesse@sigmatau.com	9876543256	\N	2025-01-19	16:00	9876543256	27 CR	Ulhasnagar	info@sigmatau.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	2700000	2025-10-15 07:33:13.240987
77	CASE048	Tau Upsilon Corp	Katherine Collins	Telecaller	Open	1	Loan Against Property	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Katherine Collins	katherine@tauupsilon.com	9876543257	\N	2025-01-19	17:00	9876543257	77 CR	Malegaon	contact@tauupsilon.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	7700000	2025-10-15 07:33:13.240987
78	CASE049	Upsilon Phi Ltd	Zachary Stewart	Telecaller	Open	1	Working Capital Loan	\N	\N	Open	\N	2025-10-15 07:33:13.240987	Zachary Stewart	zachary@upsilonphi.com	9876543258	\N	2025-01-19	18:00	9876543258	43 CR	Gaya	info@upsilonphi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	4300000	2025-10-15 07:33:13.240987
79	CASE050	Phi Chi Inc	Christina Sanchez	Telecaller	One Pager	1	Business Expansion Loan	\N	\N	One Pager	\N	2025-10-15 02:44:56.116	Christina Sanchez	christina@phichi.com	9876543259	\N	2025-01-19	09:00	9876543259	69 CR	Jalgaon	contact@phichi.com	2025-10-15 07:33:13.240987	2025-10-15 07:33:13.240987	70000000	2025-10-15 08:14:21.34086
\.


--
-- TOC entry 5031 (class 0 OID 24606)
-- Dependencies: 225
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, caseid, comment, role, created_at, commentby) FROM stdin;
1	C005	Testing	\N	2025-08-03 12:49:10.556152	Telecaller
2	C005	Testing new	\N	2025-08-03 12:50:40.990407	Telecaller
3	C005	updated just now	\N	2025-08-03 12:51:15.558561	Telecaller
4	C005	Testing	\N	2025-08-03 12:56:13.90533	Telecaller
5	C005	Testing	\N	2025-08-03 13:07:27.607086	Telecaller
6	C005	Hi	Unknown	2025-08-03 13:25:13.282308	\N
7	CASE1754208303971	\N	Unknown	2025-08-04 12:07:02.696136	\N
8	CASE1754208303971	\N	Unknown	2025-08-04 12:07:07.307003	\N
9	CASE1754208303971	\N	Unknown	2025-08-04 12:22:52.0175	\N
10	CASE1754208303971	\N	Unknown	2025-08-04 12:22:57.040466	\N
11	CASE1754208303971	\N	Unknown	2025-08-04 12:25:50.152455	\N
12	CASE1754208303971	\N	Unknown	2025-08-04 12:27:16.351249	\N
13	CASE1754208303971	\N	Unknown	2025-08-04 12:33:28.70811	\N
14	CASE1754208081740	\N	Unknown	2025-08-04 13:17:51.884777	\N
15	C1754332404663	Testing	Admin	2025-08-07 10:08:47.22496	Rayudu Ravi Krishna
16	CASE1754542124097	NA	Admin	2025-08-07 10:30:01.198457	Rayudu Ravi Krishna
17	CASE1754542843424	NA	Admin	2025-08-07 12:37:34.127186	Rayudu Ravi Krishna
18	CASE1754542843424	Hello	Admin	2025-08-07 12:38:41.757212	Rayudu Ravi Krishna
19	CASE1754551708434	NA	Admin	2025-08-07 13:27:24.351814	Rayudu Ravi Krishna
20	C1754553875896	NA	Admin	2025-08-07 15:21:02.000154	Rayudu Ravi Krishna
21	CASE1754560919286	No Comments	Telecaller	2025-08-26 15:17:53.84807	Sita Reddy
\.


--
-- TOC entry 5033 (class 0 OID 24613)
-- Dependencies: 227
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, caseid, doctype, filename, uploadedat, docname) FROM stdin;
1	C1754332495113	partA	1754535763938_main.e245b9b2.js	2025-08-07 08:32:43.949137	Last 3 years financials Along with ITR’s
2	C1754332495113	partA	1754536085333_affm_mcp_roadmap.md	2025-08-07 08:38:05.394521	Latest year provisionals
3	C1754332495113	partA	1754536324438_AFFM_Masters.json	2025-08-07 08:42:04.486694	Debt sheet
4	C1754332495113	partA	1754536501603_Accessibility_FInal_List.xls	2025-08-07 08:45:01.67019	Work order - if applicable
6	C1754332495113	partB	1754536977791_AFFM_Clear_explanation_1.docx	2025-08-07 08:52:57.84435	Sanction Letters
7	C1754332495113	partA	1754537066152_AFFM_Masters.json	2025-08-07 08:54:26.155748	Company profile
8	C1754332404663	partA	1754537089718_AFFM_Masters.json	2025-08-07 08:54:49.780954	Last 3 years financials Along with ITR’s
9	C1754332404663	partA	1754537090549_AFFM_Clear_explanation_1.docx	2025-08-07 08:54:50.55129	Latest year provisionals
10	C1754332404663	partA	1754537091433_AFFM_Clear_explanation_1.docx	2025-08-07 08:54:51.435591	Debt sheet
11	C1754332404663	partA	1754537092265_sample.txt	2025-08-07 08:54:52.267653	Work order - if applicable
12	C1754332404663	partA	1754537093180_sample.txt	2025-08-07 08:54:53.184464	Company profile
13	C1754332404663	partB	1754537094046_AFFM_Clear_explanation_1.docx	2025-08-07 08:54:54.049461	Sanction Letters
14	C1754332404663	partB	1754537094796_AFFM_Masters.json	2025-08-07 08:54:54.798013	Company and promoters KYC
16	C1754332404663	partB	1754537135454_sample.txt	2025-08-07 08:55:35.500552	Collateral full set
19	C999	onePager	1754538083739_main.e245b9b2.js	2025-08-07 09:11:23.777664	OnePager
22	CASE1754560919286	partA	1756834655128_GNV_Jewelers.xlsx	2025-09-02 23:07:35.201007	Debt sheet
26	CASE1754560919286	partA	1756835631412_Interview_preparation.docx	2025-09-02 23:23:51.425272	Work order - if applicable
29	CASE1754560919286	partA	1756836817792_GNV_Jewelers.xlsx	2025-09-02 23:43:37.902098	Last 3 years financials Along with ITR’s
30	CASE1754560919286	partA	1756836821684_GNV_Jewelers.xlsx	2025-09-02 23:43:41.695842	Latest year provisionals
34	CASE1754560919286	partA	1756837491459_GNV_Jewelers.xlsx	2025-09-02 23:54:51.519091	Company profile
41	CASE1754560919286	partA	1756879765018_GNV_Jewelers.xlsx	2025-09-03 11:39:25.252864	Sanction Letters
44	CASE1754560919286	onePager	1757039831994_GNV_Jewelers.xlsx	2025-09-05 08:07:12.077978	OnePager
45	CASE1754542124097	partA	1757219512414_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:01:52.747334	Last 3 years financials Along with ITR’s
46	CASE1754542124097	partA	1757219516238_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:01:56.320823	Latest year provisionals
47	CASE1754542124097	partA	1757219520035_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:02:00.052957	Debt sheet
48	CASE1754542124097	partA	1757219523740_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:02:03.754615	Work order - if applicable
49	CASE1754542124097	partA	1757219527586_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:02:07.598966	Company profile
50	CASE1754542124097	partA	1757219531120_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:02:11.182435	Sanction Letters
51	CASE1754542124097	onePager	1757219643223_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 10:04:03.337298	OnePager
52	CASE1757226559546	partA	1757227880044_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 12:21:20.135528	Last 3 years financials Along with ITR’s
54	CASE1757226559546	partA	1757227887570_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 12:21:27.576894	Debt sheet
55	CASE1757226559546	partA	1757227891230_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 12:21:31.237816	Work order - if applicable
56	CASE1757226559546	partA	1757227894631_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 12:21:34.63699	Company profile
57	CASE1757226559546	partA	1757227897948_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 12:21:37.955088	Sanction Letters
59	CASE1757226559546	onePager	1757227976207_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-07 12:22:56.280599	OnePager
60	CASE1757322293741	partA	1757322395362_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:36:35.620211	Last 3 years financials Along with ITR’s
61	CASE1757322293741	partA	1757322400230_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:36:40.249927	Latest year provisionals
62	CASE1757322293741	partA	1757322404413_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:36:44.45888	Debt sheet
63	CASE1757322293741	partA	1757322409277_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:36:49.285834	Work order - if applicable
64	CASE1757322293741	partA	1757322413832_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:36:53.869422	Company profile
65	CASE1757322293741	partA	1757322418760_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:36:58.772723	Sanction Letters
66	CASE1757322293741	partB	1757322424970_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 14:37:04.988078	undefined
69	CASE1757322293741	provisional	1757349889140_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 22:14:49.150831	Document Two
70	CASE1757226559546	partB	1757387180018_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-09 08:36:20.099462	undefined
71	CASE1757226559546	partB	1757387289959_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-09 08:38:09.968244	Company and promoters KYC
72	CASE1757226559546	partB	1757387295184_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-09 08:38:15.193247	Collateral full set
75	CASE1757322293741	provisional	1757995894704_WhatsApp_Image_2025-09-15_at_12.41.09_4d5dc525.jpg	2025-09-16 09:41:34.798988	Bank Prov Doc One
77	CASE1757322293741	provisional	1757996571690_WhatsApp_Image_2025-09-15_at_12.41.09_4d5dc525.jpg	2025-09-16 09:52:51.724437	Ops Prov Doc One
78	CASE1757322293741	onePager	1757996607196_WhatsApp_Image_2025-09-15_at_12.41.09_4d5dc525.jpg	2025-09-16 09:53:27.265994	OnePager
68	CASE1757226559546	provisional	1757347272929_1756837491459_GNV_Jewelers_(1).xlsx	2025-09-08 21:31:13.012076	Prov Doc One
79	CASE050	partA	1760494434322_titles.jpg	2025-10-15 07:43:54.359167	Last 3 years financials Along with ITR’s
80	CASE050	partA	1760494438096_titles.jpg	2025-10-15 07:43:58.100385	Latest year provisionals
81	CASE050	partA	1760494443305_titles.jpg	2025-10-15 07:44:03.309039	Debt sheet
82	CASE050	partA	1760494447528_titles.jpg	2025-10-15 07:44:07.534306	Work order - if applicable
83	CASE050	partA	1760494452347_titles.jpg	2025-10-15 07:44:12.356916	Company profile
84	CASE050	partA	1760494462859_titles.jpg	2025-10-15 07:44:23.037953	Sanction Letters
85	CASE050	partB	1760494471629_titles.jpg	2025-10-15 07:44:31.639809	Company and promoters KYC
86	CASE050	partB	1760494479251_titles.jpg	2025-10-15 07:44:39.26071	Collateral full set
89	CASE050	provisional	1760496260994_titles.jpg	2025-10-15 08:14:21.008794	opr_prv_doc_1
90	CASE050	onePager	1760496296061_titles.jpg	2025-10-15 08:14:56.069469	OnePager
\.


--
-- TOC entry 5048 (class 0 OID 40963)
-- Dependencies: 242
-- Data for Name: provisional_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provisional_documents (id, caseid, document_name, created_at, requested_by) FROM stdin;
2	CASE1757226559546	Document One	2025-09-08 21:16:16.582772	\N
7	CASE1757322293741	Ops Prov Doc One	2025-09-16 09:44:16.54483	6
6	CASE1757226559546	Bank Prov Doc One	2025-09-16 09:39:32.661415	27
8	CASE050	opr_prv_doc_1	2025-10-15 07:43:40.377218	6
\.


--
-- TOC entry 5035 (class 0 OID 24620)
-- Dependencies: 229
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, rolename) FROM stdin;
1	Individual
2	Telecaller
3	KAM
4	UW
5	Operations
6	Admin
7	Banker
\.


--
-- TOC entry 5037 (class 0 OID 24624)
-- Dependencies: 231
-- Data for Name: status_matrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_matrix (id, roleid, key, value, "subStatus") FROM stdin;
\.


--
-- TOC entry 5039 (class 0 OID 24630)
-- Dependencies: 233
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, phone, company, roleid, pocname, pocphone) FROM stdin;
1	Admin User	admin@rwot.com	1111111111	9999999991	RWOT HQ	6	\N	\N
3	Sita Reddy	sita@tele.com	1111111111	9999999993	RWOT Tele	2	\N	\N
4	Rohit Das	rohit@kam.com	1111111111	9999999994	RWOT Field	3	\N	\N
5	Divya Shah	divya@uw.com	1111111111	9999999995	RWOT UW	4	\N	\N
6	Anil Mehta	anil@ops.com	1111111111	9999999996	RWOT Ops	5	\N	\N
10	Rayudu Ravi Krishna	ravikrishna.rayudu1@gmail.com	1234567890	9966633876	Jamas Waive IT Solutions Private	6	\N	\N
2	Ravi Kumar	ravi@client.com	1111111111	9999999992	Testing	1	Jinesh	8341194888
24	Data Driven Solutions	ravikrishna.rayudu@gmail.com	1234567890	9966633876	Data Driven Technologies	1	Nutan	9160656934
25	Leela	leela@gmail.com	1234567890	8341194888	Internal	2	\N	\N
7	Priya Nair	priya@hdfc.com	1111111111	9999999997	HDFC Bank	7	\N	\N
27	SBI Bank	contact@sbi.com	1111111111	9999999997	SBI Bank	7	\N	\N
9	Admin	admin@rwot.in	1111111111	9876543210	RWOT Corp	6	\N	\N
28	ICICI Bank	icici@bank.com	1111111111	7852378523	ICICI Bank	7	\N	\N
\.


--
-- TOC entry 5041 (class 0 OID 24636)
-- Dependencies: 235
-- Data for Name: workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow (id, caseid, stage, "timestamp") FROM stdin;
1	CASE1754208303971	One Pager Uploaded	2025-08-04 10:49:17.669465
2	CASE1754208303971	One Pager Uploaded	2025-08-04 10:51:26.722983
3	CASE1754208303971	Ready to Share	2025-08-04 12:29:01.111873
4	CASE1754208303971	Ready to Share	2025-08-04 12:54:15.239289
5	CASE1754208303971	Ready to Share	2025-08-04 13:13:08.825459
6	CASE1754208207921	Ready to Share	2025-08-04 13:13:31.612171
7	CASE1754208303971	Ready to Share	2025-08-04 13:26:16.783625
8	C1754332495113	One-pager Uploaded	2025-08-06 23:26:57.313911
9	C1754332495113	Banker Review	2025-08-06 23:41:35.549917
10	C1754332495113	Banker Review	2025-08-06 23:48:13.39553
11	C999	One-pager Uploaded	2025-08-07 08:05:09.759873
12	C1754332404663	One-pager Uploaded	2025-08-07 08:59:22.180912
13	C1754332404663	Banker Review	2025-08-07 09:01:01.290309
14	C1754332495113	One-pager Uploaded	2025-08-07 09:10:17.935138
15	C999	One-pager Uploaded	2025-08-07 09:11:23.787926
16	C1754332495113	One-pager Uploaded	2025-08-07 09:20:33.175648
17	C999	Banker Review	2025-08-07 13:20:38.25678
18	CASE1754560919286	Underwriter	2025-09-03 08:55:01.647633
19	CASE1754560919286	Underwriter	2025-09-03 08:57:49.797792
20	CASE1754560919286	Underwriter	2025-09-03 08:58:34.039445
21	CASE1754560919286	Underwriter	2025-09-03 11:39:25.645371
22	CASE1754560919286	One Pager	2025-09-05 08:01:04.972147
23	CASE1754560919286	One Pager	2025-09-05 08:07:12.153856
24	CASE1754542124097	Underwriting	2025-09-07 10:02:11.502472
25	CASE1754542124097	One Pager	2025-09-07 10:04:03.358112
26	CASE1757226559546	Underwriting	2025-09-07 12:21:38.063351
27	CASE1757226559546	Underwriting	2025-09-07 12:21:42.178506
28	CASE1757226559546	One Pager	2025-09-07 12:22:56.31461
29	CASE1757322293741	Underwriting	2025-09-08 14:36:59.006471
30	CASE1757322293741	Underwriting	2025-09-08 14:37:05.108101
31	CASE1757322293741	One Pager	2025-09-08 14:37:45.752746
32	CASE1757226559546	Underwriting	2025-09-08 21:31:13.156667
33	CASE1757322293741	Underwriting	2025-09-08 22:14:49.298653
34	CASE1757226559546	Underwriting	2025-09-09 08:36:20.360361
35	CASE1757226559546	Underwriting	2025-09-09 08:38:10.136916
36	CASE1757226559546	Underwriting	2025-09-09 08:38:15.264683
37	CASE1757226559546	Underwriting	2025-09-09 08:38:19.662601
38	CASE1757322293741	Underwriting	2025-09-09 08:39:31.776912
39	CASE1757322293741	One Pager	2025-09-09 08:39:40.714214
40	CASE1757322293741	Underwriting	2025-09-16 09:41:35.013839
41	CASE1757322293741	Underwriting	2025-09-16 09:42:15.622936
42	CASE1757322293741	One Pager	2025-09-16 09:42:20.797918
43	CASE1757322293741	Underwriting	2025-09-16 09:52:51.94176
44	CASE1757322293741	Underwriting	2025-09-16 09:53:15.663636
45	CASE1757322293741	One Pager	2025-09-16 09:53:27.28121
46	CASE050	Underwriting	2025-10-15 07:44:23.18334
47	CASE050	Underwriting	2025-10-15 07:44:31.76516
48	CASE050	Underwriting	2025-10-15 07:44:39.417283
49	CASE050	Underwriting	2025-10-15 07:44:45.662502
50	CASE050	One Pager	2025-10-15 08:13:37.042556
51	CASE050	Underwriting	2025-10-15 08:14:21.117354
52	CASE050	Underwriting	2025-10-15 08:14:50.191344
53	CASE050	One Pager	2025-10-15 08:14:56.118065
\.


--
-- TOC entry 5043 (class 0 OID 24641)
-- Dependencies: 237
-- Data for Name: workflow_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_logs (id, caseid, stage, updatedby, updatedat) FROM stdin;
\.


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 218
-- Name: banks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banks_id_seq', 55, true);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 220
-- Name: case_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.case_assignments_id_seq', 165, true);


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 222
-- Name: case_stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.case_stages_id_seq', 6, true);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 224
-- Name: cases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cases_id_seq', 79, true);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 226
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 21, true);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 239
-- Name: document_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_configurations_id_seq', 34, true);


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 228
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 90, true);


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 241
-- Name: provisional_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.provisional_documents_id_seq', 8, true);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 230
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 232
-- Name: status_matrix_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_matrix_id_seq', 1, false);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 234
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 28, true);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 236
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_id_seq', 53, true);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 238
-- Name: workflow_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_logs_id_seq', 1, false);


--
-- TOC entry 4832 (class 2606 OID 24659)
-- Name: banks banks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (id);


--
-- TOC entry 4834 (class 2606 OID 24661)
-- Name: case_assignments case_assignments_caseid_role_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_caseid_role_unique UNIQUE (caseid, role);


--
-- TOC entry 4836 (class 2606 OID 24663)
-- Name: case_assignments case_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 4840 (class 2606 OID 24665)
-- Name: case_stages case_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages
    ADD CONSTRAINT case_stages_pkey PRIMARY KEY (id);


--
-- TOC entry 4843 (class 2606 OID 24667)
-- Name: cases cases_caseid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_caseid_key UNIQUE (caseid);


--
-- TOC entry 4845 (class 2606 OID 24669)
-- Name: cases cases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 24671)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 32783)
-- Name: bank_assignments document_configurations_caseid_bankid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_assignments
    ADD CONSTRAINT document_configurations_caseid_bankid_key UNIQUE (caseid, bankid);


--
-- TOC entry 4869 (class 2606 OID 32781)
-- Name: bank_assignments document_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_assignments
    ADD CONSTRAINT document_configurations_pkey PRIMARY KEY (id);


--
-- TOC entry 4851 (class 2606 OID 24673)
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4871 (class 2606 OID 40971)
-- Name: provisional_documents provisional_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provisional_documents
    ADD CONSTRAINT provisional_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 24675)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 24677)
-- Name: roles roles_rolename_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_rolename_key UNIQUE (rolename);


--
-- TOC entry 4857 (class 2606 OID 24679)
-- Name: status_matrix status_matrix_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_matrix
    ADD CONSTRAINT status_matrix_pkey PRIMARY KEY (id);


--
-- TOC entry 4847 (class 2606 OID 24681)
-- Name: cases unique_caseid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT unique_caseid UNIQUE (caseid);


--
-- TOC entry 4838 (class 2606 OID 24683)
-- Name: case_assignments unique_caseid_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT unique_caseid_role UNIQUE (caseid, role);


--
-- TOC entry 4859 (class 2606 OID 24685)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4861 (class 2606 OID 24687)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 24689)
-- Name: workflow_logs workflow_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_logs
    ADD CONSTRAINT workflow_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4863 (class 2606 OID 24691)
-- Name: workflow workflow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow
    ADD CONSTRAINT workflow_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 1259 OID 24692)
-- Name: idx_case_stages_caseid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_case_stages_caseid ON public.case_stages USING btree (caseid);


--
-- TOC entry 4872 (class 2606 OID 24693)
-- Name: case_assignments case_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- TOC entry 4873 (class 2606 OID 24698)
-- Name: case_assignments case_assignments_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- TOC entry 4874 (class 2606 OID 24703)
-- Name: case_stages case_stages_caseid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages
    ADD CONSTRAINT case_stages_caseid_fkey FOREIGN KEY (caseid) REFERENCES public.cases(caseid) ON DELETE CASCADE;


--
-- TOC entry 4875 (class 2606 OID 24708)
-- Name: case_stages case_stages_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages
    ADD CONSTRAINT case_stages_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 4876 (class 2606 OID 24713)
-- Name: cases cases_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_createdby_fkey FOREIGN KEY (createdby) REFERENCES public.users(id);


--
-- TOC entry 4877 (class 2606 OID 24718)
-- Name: users users_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_roleid_fkey FOREIGN KEY (roleid) REFERENCES public.roles(id);


-- Completed on 2025-10-15 19:25:38

--
-- PostgreSQL database dump complete
--

