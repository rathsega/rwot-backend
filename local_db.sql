--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

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
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS '';


--
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
-- Name: banks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banks_id_seq OWNED BY public.banks.id;


--
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
-- Name: case_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.case_assignments_id_seq OWNED BY public.case_assignments.id;


--
-- Name: case_product_requirements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.case_product_requirements (
    id integer NOT NULL,
    caseid character varying(20) NOT NULL,
    productname character varying(100) NOT NULL,
    requirement_amount character varying(50),
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.case_product_requirements OWNER TO postgres;

--
-- Name: case_product_requirements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.case_product_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.case_product_requirements_id_seq OWNER TO postgres;

--
-- Name: case_product_requirements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.case_product_requirements_id_seq OWNED BY public.case_product_requirements.id;


--
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
-- Name: case_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.case_stages_id_seq OWNED BY public.case_stages.id;


--
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
    status_updated_on timestamp without time zone DEFAULT now(),
    meeting_done_date date
);


ALTER TABLE public.cases OWNER TO postgres;

--
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
-- Name: cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cases_id_seq OWNED BY public.cases.id;


--
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
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
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
-- Name: document_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_configurations_id_seq OWNED BY public.bank_assignments.id;


--
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
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
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
-- Name: provisional_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.provisional_documents_id_seq OWNED BY public.provisional_documents.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    rolename character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
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
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
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
-- Name: status_matrix_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_matrix_id_seq OWNED BY public.status_matrix.id;


--
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
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
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
-- Name: workflow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_id_seq OWNED BY public.workflow.id;


--
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
-- Name: workflow_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_logs_id_seq OWNED BY public.workflow_logs.id;


--
-- Name: bank_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_assignments ALTER COLUMN id SET DEFAULT nextval('public.document_configurations_id_seq'::regclass);


--
-- Name: banks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banks ALTER COLUMN id SET DEFAULT nextval('public.banks_id_seq'::regclass);


--
-- Name: case_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments ALTER COLUMN id SET DEFAULT nextval('public.case_assignments_id_seq'::regclass);


--
-- Name: case_product_requirements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_product_requirements ALTER COLUMN id SET DEFAULT nextval('public.case_product_requirements_id_seq'::regclass);


--
-- Name: case_stages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages ALTER COLUMN id SET DEFAULT nextval('public.case_stages_id_seq'::regclass);


--
-- Name: cases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases ALTER COLUMN id SET DEFAULT nextval('public.cases_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: provisional_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provisional_documents ALTER COLUMN id SET DEFAULT nextval('public.provisional_documents_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: status_matrix id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_matrix ALTER COLUMN id SET DEFAULT nextval('public.status_matrix_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workflow id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow ALTER COLUMN id SET DEFAULT nextval('public.workflow_id_seq'::regclass);


--
-- Name: workflow_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_logs ALTER COLUMN id SET DEFAULT nextval('public.workflow_logs_id_seq'::regclass);


--
-- Data for Name: bank_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_assignments (id, caseid, bankid, document_config, createdat, updatedat, status) FROM stdin;
1	CASE1762753606380	5	{"partA_Debt sheet": false, "partA_Latest year provisionals": false, "partA_Work order - if applicable": false, "partA_Last 3 years financials Along with ITR’s": true}	2025-11-10 08:13:52.111363	2025-11-10 08:31:56.308728	ACCEPT
8	CASE1761910111749	9	{"onePager_OnePager": true}	2025-11-28 11:04:58.087384	2025-11-28 11:04:58.087384	pending
7	CASE1761910111749	2	{"partA_Debt sheet": true, "onePager_OnePager": true, "partA_Last 3 years financials Along with ITR’s": true}	2025-11-28 11:04:58.081073	2025-11-29 12:30:49.012328	DONE
10	CASE1762842917468	7	{"onePager_OnePager": true, "partA_Last 3 years financials Along with ITR’s": true}	2025-11-29 03:37:24.881643	2025-11-29 13:01:40.323905	DONE
11	CASE1764421233518	86	{"onePager_OnePager": true}	2025-12-08 11:07:13.07313	2025-12-08 11:07:13.07313	pending
12	CASE1764402810649	87	{"onePager_OnePager": true}	2025-12-08 11:18:38.180959	2025-12-08 11:18:38.180959	pending
13	CASE1764402510984	86	{"onePager_OnePager": true}	2025-12-08 12:03:07.694981	2025-12-08 12:03:07.694981	pending
\.


--
-- Data for Name: banks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banks (id, name, email, phone, products) FROM stdin;
1	SCB	jaiprakash.singh@sc.com	8977146218	["BL"]
2	AU Small Finance Bank	narender.kedika@aubank.in	9912352347	["WC"]
3	Aditya Birla	subhash.kumar4@adityabirlacapital.com	7899582121	["small LAP - upto 7cr"]
4	Axisfin	venkatesh.elisetty@axisfinance.in	8686869804	["Small LAP upto 7CR"]
5	ORIX	varun.dharanikota@orixindia.com	8977253463	["Machinery funding upto 7cr", "Small LAP upto 7cr"]
6	SBM	prashanthravi.cm@sbmbank.co.in	9885096696	["Small LAP - upto 5CR"]
7	KVB	bommagouniarjun@kvbmail.com	7075508084	["OD"]
8	UGROW CAPITAL	dharanikota.sivaji@ugrocapital.com	8247737963	["Secured LAP"]
9	HDFC	ramesh.g4@hdfcbank.com	9000099744	["WC"]
10	Hinduja Leyland finance	pallatimahenderreddy@hindujaleylandfinance.com	98852 55787	["LAP"]
11	Motilal Oswal	ashish.mehta@motilaloswal.com	90048 93498	["Construction Finance"]
15	Nido Home Finance	chandrakanth.tiwari@nidohomefin.com	9492775948	["LAP"]
17	Integrow Asset Management	parth.mahajan@integrowamc.com	+91 90228 05529	["Real Estate Assest. Management Company"]
45	YES BANK > RAJU 	msmeoperations@myrwot.com	9849255486	["WC - SME"]
16	( MAHESH ) KOTAK BANK 	maheshvarma.vachavai@kotak.com	8885378949	["LAP"]
14	(BHASKAR ) KOTAK BANK	Gandamala.bhaskar1@kotak.com	9603917807	["SECURED WC UPTO 30CR"]
19	( ABHISHEK ) KOTAK BANK 	abhisek.mohapatra@kotak.com	9777725062	["BL"]
20	( HARI ) IDBI 	msmeoperations@myrwot.com	9994842222	["SECURED WC UPTO 30CR", "LAP"]
21	UC INCLUSIVE CREDIT  (ABHIJIT RAY DIRECTOR)	aray@ucinclusive.com	9986067941	["LAP(1CR TO 10CR ),ANGEL FUNDING ,VENTURE DEBT,PRIVATE  CREDIT,EQITY"]
46	YES BANK > SURESH	msmeoperations@myrwot.com	6300895082	["WC - 30CR"]
24	GVL Narasimha Murthy	murthygvl@kvbmail.com	9959988569	["LAP", "Bill discoutning", "WC"]
25	BAJAJ -IBCM  ( BHABESH KANHAR ) 	bhabesh.kanhar1@bajajfinserv.in	9163897509	["PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)"]
26	IDFC > HARISH > VIJAYWADA	MSMEOPERATIONS@MYRWOT.COM	7989764799	["WC - 20CR", "LAP - 10CR"]
23	IDFC > SHANKAR > PRAKASH NAGAR	Shanker.reddy@idfcfirstbank.com	9700062738	["LAP - 20CR"]
27	Poonawalla Fincorp	b.reddy1@poonawallafincorp.com	9030332967	["BL"]
28	Aditya Birla Alternates  ( VIVEK SINGH )	vivek.r.singh@adityabirlacapital.com	9848227713	["NCD,PRIVATE EQUITY,STOCKS,MUTUAL FUND"]
13	True North Credit  ( KSHITIJ AGARWAL ,VP, MUMBAI)	kshitij@truenorth.co.in	99996 01085	["Private Credit (NCD, Secure Lending ) 50cr to 1000cr"]
12	( PRASAD ) KOTAK BANK 	Prasad.akarapu@kotak.com	8179420050	["UNSECURED & SECURED OD", "CGTMSE", "BANK GURANTEE", "CASH CREDIT", "MACHINERY FUNDING", "PROPERTY PURCHASE", "FCLT ( FOREIGN CURRENCY TERM LOAN )"]
18	Neo Asset Management Pvt. Ltd. ( VAIBHAV AGARWAL ,VP ,MUMBAI)	vaibhav.agrawal@neoassetmanagement.com	75060 53341	["Private Credit and Secure Lending (100cr to 1000cr)"]
30	DCB Bank	Satyanarayana.battini@dcbbank.com	9618398959	["LAP"]
31	INDULAND > RAGHUNATH 	msmeoperations@myrwot.com	9885430535	["CGTMSE - 30CR", "LAP - 30CR"]
33	True North Credit ( TUSHARA GARG ,VP , MUMBAI )	tushara@truenorth.co.in	95674 45076 	["Private Equity (75cr - 1000cr)"]
34	HDFC 	Saiindra.neiljorige@hdfcbank.com	7013155736	["Working capital SME"]
35	Nuvama 	yathagiri.ram@nuvama.com	9963741225	["Home Loan", "Corporate FDs & Bonds"]
36	IIFL Capital  ( KRISHNA )	P.kristappa23@iiflcapital.com	9959969960 	["NCD,MUTUAL FUND ,PRIVATE EQUITY"]
37	ICICI > MADHAVI 	madhavi.ketharaju@icicibank.com	8169452048	["WC", "LAP"]
39	ICICI > RAMESH 	ramesh.beemanaveni@icicibank.com	7995007286	["WC", "LAP"]
40	360 ONE ASSET. 	sanket.hegde@360.one	98339 14523	["PRIVATE CREDIT ( MINIMUM 75CR )"]
41	ICICI > MAHESHWARI	90047223@icicibank.com	8169452048	["WC", "LAP"]
29	INDUSLAND > SRIKANTH 	govula.srikanth@indusind.com	8125310057	["LAP", "WC - 30CR"]
59	SUNDARAM > SRINIVAS 	Dugyanisrinivas@sundaramhome.in	9640648435	["LAP"]
43	YES BANK > NAVEEN > 	Naveen.vasireddy@yesbank.in	8886661296	["LAP"]
44	YES BANK > PRASANNA > 	msmeoperations@myrwot.com	9985119276	["BL"]
32	FEDBANK > SHIVA 	shiva.prasad@fedfina.com	9642525123	["LAP - 3CR"]
47	YES BANK > PRAVEEN	msmeoperations@myrwot.com	9393494959	["LAP"]
48	JIO CREDIT ( ABHISHEK ,SOUTH HEAD )	kumarabhishek.jha@jiocredit.in	99999831784	["LAP UPTO 100CR"]
38	SIDBI Venture Capital LTD. (  Kiran Poojary , AVP , MUMBAI )	kiran@sidbiventure.co.in	 98201 40416	["Startup Venture Funding for early stage"]
50	AXIS FIN > MAHESH 	mahesh.pagidimarri@axisfinance.in	9966294989	["LAP"]
49	AXIS > VISHWAJITH 	msmeoperations@myrwot.com	9985877966	["LAP"]
51	AXIS FIN > RANI 	msmeoperations@myrwot.com	7569824255	["LAP"]
52	RBL > PHANIKANTH	msmeoperations@myrwot.com	8121545979	["HL - 15CR", "LAP - 75 LAKHS"]
53	RBL > ANKUR 	msmeoperations@myrwot.com	9826924999	["WC - 30CR", "LAP - 30CR"]
54	RBL > RAGHURAM	msmeoperations@myrwot.com	9160668822	["LAP - 30CR"]
55	KVB > AVINASH 	avinashreddyg@kvbmail.com	9121047575	["WC", "LAP"]
56	KVB > ARJUN 	bommagouniarjun@kvbmail.com	7075508084	["WC", "LAP"]
57	SRAVAN > PIRAMAL 	Sravan.komirisetti@piramal.com	8790977756	["LAP"]
58	SUNDARAM > SANTHOSH 	BM.Kompally@sundaramhome.in	6382134563	["LAP"]
42	HDB > PRASAD > CLUSTER HEAD	dp.katla1994@gmail.com	8367393743	["LAP - 20CR"]
60	POONAWALA > RAVINDER	ravinder.reddy@poonawallafincorp.com	9704214905	["WC"]
61	Shinhan Financial Group,  RAVI  	L.ravi@shinhan.com	9160609888	["LAP UPTO 50CR."]
62	UGRO Capital Zonal Head - Secured	ashok.mariappan@ugrocapital.com	9840080905	["secured Loans"]
63	DCB Bank	sudheerreddy.mitta@dcbbank.com	9885492881	["SME"]
64	Sundaram Home	rakeshg@sundaramhome.in	9989553405	["Home FInance"]
65	Kotak	Gandamala.bhaskar1@kotak.com	9603917807	["SBE"]
66	Indian Overseas Bank	iob2757@iob.in	8925952757	["WC"]
67	NORTHERN ARC ( DEEPIKA BANG ,MUMBAI )	deepika.bang@northernarc.com	 9549027274	["WC,LAP,NCD(ABOVE 8CR),UNSECURED FUNDING UPTO 75CR,CHANNEL FINANCE,AIF,PMS"]
68	Bajaj Finserv	mahesh.kulkarni1@bajajfinserv.in	9849016804	["Commercial Lending"]
69	Bajaj Finserv	ashutosh.ashutosh@bajajhousing.co.in	8939549754	["LAP"]
70	Indusind Bank	pc.kumar@indusind.com	8919222371	["Agri Business"]
71	Indusind Bank	govula.srikanth@indusind.com	8125310057	["Agri Business"]
72	NORTHERN ARC , AKASH ,GURGAON , 	Akash.Khurana@northernarc.com	7397585999	["WC,LAP,BILL DISCOUNTING,AIF,PMS,NCD ABOVE 8CR"]
73	Mizuho Capsave Finance Pvt. Ltd, ANGEL ,MUMBAI 	angel.nadar@mizuho-cf.co.in	8898756559	["UNSECURED FUNDING ,BILL DISCOUNTING ,WC"]
74	Mizuho Capsave Finance Pvt. Ltd , SUNIL ,MUMBAI 	sunil.kurmi@mizuho-cf.co.in	9819776641	["BILL DISCOUNTING,UNSECURED FUNDING"]
75	Mizuho Capsave Finance Pvt. Ltd ,ADIL KHAN , MUMBAI 	adil.khan@mizuho-cf.co.in	9044851840	["BILL DISCOUNTING,UNSECURED FUNDING ,SECURED"]
76	GETVANTAGE ,SURAJ ,MUMBAI 	suraj.shinde@getvantage.co	9152568892 	["NCD,BILL DISCOUNTING ,UNSECURED ,5CR IN 1 TRANCH"]
77	VIVRITI CAPITAL , SOUMYA SINGHAROY ,SOUTH ZONAL HEAD 	soumya.singharoy@vivriticapital.com	9849018920	["LAP,WC,LAS,NCD,CO LENDING,BILL DISCOUNTING , TERM LOAN , FACTORING"]
78	VAYANA  ,SUNDAR ,SOUTH HEAD ,HYDERABAD 	sundar.rajan@vayana.com	9791388979	["BILL DISCOUNTING,BUSINESS LOAN AND TERM LOAN", "SECURED"]
79	MINTIFI , MITHILESH , HYDERABAD	mithilesh.kumar@mintifi.com	8655403423 	["SUPPLY CHAIN FINANCE"]
80	DBS ,AKHIL , HYDERABAD 	akhilgunta@dbs.com	 9618309865	["UNSECURED,BILL DISCOUNTING ,SME,CORPORATE LENDING"]
81	DRIP CAPITAL,  RISHIKESH , MUMBAI 	rishikesh.hamand@dripcapital.com	8655887699	["IMPORT/EXPORT FACTORING"]
82	RXIL ,PRAVEEN ,MUMBAI 	praveen.shetty@rxil.in	9920607771	["BILL DISCOUNTING"]
83	KREDX ,SURAJ , MUMBAI	suraj.chandake@kredx.com	7770006813	["SME FUNDING, SUPPLY CHANNEL FINANCE"]
84	BIG FIN LOAN	Bigfinloanhyd@gmail.com	9505920202	["PRIVATE FUNDING"]
22	IDFC > YASHWANTH > PRAKASH NAGAR	alamuri.harish@idfcbank.com	9542058144	["WC - 20CR", "LAP - 10CR"]
85	Kotak	archana.kumari5@kotak.com	8424016284	["WC upto 70cr"]
86	UCO	jubmcc@uco.bank.in	8961194127	["WC"]
87	Kotak SME	arun.s16@kotak.com	9398871893	["WC"]
\.


--
-- Data for Name: case_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.case_assignments (id, caseid, assigned_to, role, assigned_by, assigned_at, assigned_date) FROM stdin;
2	CASE1761904567946	29	Telecaller	\N	2025-10-31 09:56:08.734797	2025-10-31 09:56:08.734797
95	CASE1762248461034	39	Operations	\N	2025-11-04 09:27:40.695775	2025-11-04 09:27:40.695775
96	CASE1762248461034	33	Telecaller	\N	2025-11-04 09:27:40.69777	2025-11-04 09:27:40.69777
98	CASE1762249044960	39	Operations	\N	2025-11-04 09:37:24.622614	2025-11-04 09:37:24.622614
99	CASE1762249044960	33	Telecaller	\N	2025-11-04 09:37:24.624683	2025-11-04 09:37:24.624683
101	CASE1762249679995	39	Operations	\N	2025-11-04 09:47:59.762628	2025-11-04 09:47:59.762628
102	CASE1762249679995	30	Telecaller	\N	2025-11-04 09:47:59.764692	2025-11-04 09:47:59.764692
1	CASE1761904567946	34	KAM	\N	2025-10-31 09:56:08.726856	2025-10-31 10:13:25.428247
2617	CASE1766406148156	39	Operations	\N	2025-12-22 12:22:29.318857	2025-12-22 12:22:29.318857
2618	CASE1766406148156	32	Telecaller	\N	2025-12-22 12:22:29.320859	2025-12-22 12:22:29.320859
19	CASE1761910299582	39	Operations	\N	2025-10-31 11:31:39.658782	2025-10-31 11:31:39.658782
20	CASE1761910299582	33	Telecaller	\N	2025-10-31 11:31:39.660941	2025-10-31 11:31:39.660941
2616	CASE1766406148156	36	KAM	\N	2025-12-22 12:22:29.312653	2025-12-22 12:24:08.505986
22	CASE1761910298881	39	Operations	\N	2025-10-31 11:31:40.699895	2025-10-31 11:31:40.699895
23	CASE1761910298881	32	Telecaller	\N	2025-10-31 11:31:40.702051	2025-10-31 11:31:40.702051
105	CASE1762257392648	39	Operations	\N	2025-11-04 11:56:28.235832	2025-11-04 11:56:28.235832
106	CASE1762257392648	31	Telecaller	\N	2025-11-04 11:56:28.237864	2025-11-04 11:56:28.237864
88	CASE1762247921899	34	KAM	\N	2025-11-04 09:18:41.535781	2025-11-29 06:26:43.777198
108	CASE1762257883874	39	Operations	\N	2025-11-04 12:04:44.626567	2025-11-04 12:04:44.626567
109	CASE1762257883874	32	Telecaller	\N	2025-11-04 12:04:44.628694	2025-11-04 12:04:44.628694
107	CASE1762257883874	34	KAM	\N	2025-11-04 12:04:44.620605	2025-11-04 12:05:03.830346
18	CASE1761910299582	34	KAM	\N	2025-10-31 11:31:39.652543	2025-11-29 06:30:32.761429
33	CASE1761977530872	39	Operations	\N	2025-11-01 06:12:11.846565	2025-11-01 06:12:11.846565
34	CASE1761977530872	31	Telecaller	\N	2025-11-01 06:12:11.848899	2025-11-01 06:12:11.848899
36	CASE1761977532523	39	Operations	\N	2025-11-01 06:12:12.191849	2025-11-01 06:12:12.191849
37	CASE1761977532523	31	Telecaller	\N	2025-11-01 06:12:12.194426	2025-11-01 06:12:12.194426
39	CASE1761978382155	39	Operations	\N	2025-11-01 06:26:22.35619	2025-11-01 06:26:22.35619
40	CASE1761978382155	32	Telecaller	\N	2025-11-01 06:26:22.358541	2025-11-01 06:26:22.358541
51	CASE1761996927236	34	KAM	\N	2025-11-01 11:35:26.936669	2025-11-29 06:33:53.394114
43	CASE1761979443916	39	Operations	\N	2025-11-01 06:44:04.763573	2025-11-01 06:44:04.763573
44	CASE1761979443916	30	Telecaller	\N	2025-11-01 06:44:04.76566	2025-11-01 06:44:04.76566
94	CASE1762248461034	34	KAM	\N	2025-11-04 09:27:40.690082	2025-11-29 06:49:07.442752
47	CASE1761990784698	39	Operations	\N	2025-11-01 09:53:05.042952	2025-11-01 09:53:05.042952
48	CASE1761990784698	30	Telecaller	\N	2025-11-01 09:53:05.044993	2025-11-01 09:53:05.044993
76	CASE1762166837309	34	KAM	\N	2025-11-03 10:47:17.971146	2025-11-29 06:36:55.932533
128	CASE1762339872019	39	Operations	\N	2025-11-05 10:51:07.646779	2025-11-05 10:51:07.646779
52	CASE1761996927236	39	Operations	\N	2025-11-01 11:35:26.942745	2025-11-01 11:35:26.942745
53	CASE1761996927236	32	Telecaller	\N	2025-11-01 11:35:26.944807	2025-11-01 11:35:26.944807
147	CASE1762414031380	37	KAM	\N	2025-11-06 07:27:12.563901	2025-11-29 06:34:46.292102
150	CASE1762425626265	34	KAM	\N	2025-11-06 10:40:26.785292	2025-11-29 06:31:15.652388
57	CASE1762145457677	39	Operations	\N	2025-11-03 04:50:57.289448	2025-11-03 04:50:57.289448
58	CASE1762145457677	32	Telecaller	\N	2025-11-03 04:50:57.29143	2025-11-03 04:50:57.29143
35	CASE1761977532523	35	KAM	\N	2025-11-01 06:12:12.18365	2025-11-04 12:42:01.834361
61	CASE1762145698483	39	Operations	\N	2025-11-03 04:54:58.129567	2025-11-03 04:54:58.129567
62	CASE1762145698483	32	Telecaller	\N	2025-11-03 04:54:58.131532	2025-11-03 04:54:58.131532
91	CASE1762248282595	35	KAM	\N	2025-11-04 09:24:42.321903	2025-11-04 12:42:07.108941
83	CASE1762231819322	35	KAM	\N	2025-11-04 04:50:18.86505	2025-11-29 06:36:23.272861
56	CASE1762145457677	34	KAM	\N	2025-11-03 04:50:57.283504	2025-11-03 04:58:14.245301
129	CASE1762339872019	31	Telecaller	\N	2025-11-05 10:51:07.648772	2025-11-05 10:51:07.648772
68	CASE1762146702285	39	Operations	\N	2025-11-03 05:11:42.309782	2025-11-03 05:11:42.309782
69	CASE1762146702285	33	Telecaller	\N	2025-11-03 05:11:42.312094	2025-11-03 05:11:42.312094
71	CASE1762146979894	39	Operations	\N	2025-11-03 05:16:19.880401	2025-11-03 05:16:19.880401
72	CASE1762146979894	33	Telecaller	\N	2025-11-03 05:16:19.882356	2025-11-03 05:16:19.882356
74	CASE1762148391654	39	Operations	\N	2025-11-03 05:39:50.649331	2025-11-03 05:39:50.649331
75	CASE1762148391654	30	Telecaller	\N	2025-11-03 05:39:50.651936	2025-11-03 05:39:50.651936
77	CASE1762166837309	39	Operations	\N	2025-11-03 10:47:17.977639	2025-11-03 10:47:17.977639
78	CASE1762166837309	32	Telecaller	\N	2025-11-03 10:47:17.979785	2025-11-03 10:47:17.979785
104	CASE1762257392648	35	KAM	\N	2025-11-04 11:56:28.229891	2025-11-29 06:39:07.443181
81	CASE1762168226331	39	Operations	\N	2025-11-03 11:10:27.121958	2025-11-03 11:10:27.121958
82	CASE1762168226331	30	Telecaller	\N	2025-11-03 11:10:27.124125	2025-11-03 11:10:27.124125
84	CASE1762231819322	39	Operations	\N	2025-11-04 04:50:18.871266	2025-11-04 04:50:18.871266
85	CASE1762231819322	31	Telecaller	\N	2025-11-04 04:50:18.873274	2025-11-04 04:50:18.873274
131	CASE1762339933194	39	Operations	\N	2025-11-05 10:52:13.814384	2025-11-05 10:52:13.814384
89	CASE1762247921899	39	Operations	\N	2025-11-04 09:18:41.542377	2025-11-04 09:18:41.542377
90	CASE1762247921899	33	Telecaller	\N	2025-11-04 09:18:41.544379	2025-11-04 09:18:41.544379
92	CASE1762248282595	39	Operations	\N	2025-11-04 09:24:42.328265	2025-11-04 09:24:42.328265
93	CASE1762248282595	30	Telecaller	\N	2025-11-04 09:24:42.330716	2025-11-04 09:24:42.330716
97	CASE1762249044960	35	KAM	\N	2025-11-04 09:37:24.616303	2025-11-29 06:21:52.613837
80	CASE1762168226331	35	KAM	\N	2025-11-03 11:10:27.116027	2025-11-04 12:42:21.758598
73	CASE1762148391654	35	KAM	\N	2025-11-03 05:39:50.643132	2025-11-04 12:42:32.686787
46	CASE1761990784698	35	KAM	\N	2025-11-01 09:53:05.036812	2025-11-04 12:42:44.188105
42	CASE1761979443916	35	KAM	\N	2025-11-01 06:44:04.757739	2025-11-04 12:42:59.199283
132	CASE1762339933194	30	Telecaller	\N	2025-11-05 10:52:13.816449	2025-11-05 10:52:13.816449
67	CASE1762146702285	37	KAM	\N	2025-11-03 05:11:42.302119	2025-11-29 06:29:09.781557
125	CASE1762322142972	39	Operations	\N	2025-11-05 05:54:42.633423	2025-11-05 05:54:42.633423
126	CASE1762322142972	30	Telecaller	\N	2025-11-05 05:54:42.635402	2025-11-05 05:54:42.635402
124	CASE1762322142972	35	KAM	\N	2025-11-05 05:54:42.627305	2025-11-05 10:54:02.710095
130	CASE1762339933194	35	KAM	\N	2025-11-05 10:52:13.80853	2025-11-05 10:54:28.149379
136	CASE1762346321840	34	KAM	\N	2025-11-05 12:38:42.491793	2025-11-05 12:38:42.491793
137	CASE1762346321840	39	Operations	\N	2025-11-05 12:38:42.497819	2025-11-05 12:38:42.497819
138	CASE1762346321840	29	Telecaller	\N	2025-11-05 12:38:42.499779	2025-11-05 12:38:42.499779
139	CASE1762346413807	34	KAM	\N	2025-11-05 12:40:14.48916	2025-11-05 12:40:14.48916
140	CASE1762346413807	39	Operations	\N	2025-11-05 12:40:14.495173	2025-11-05 12:40:14.495173
141	CASE1762346413807	29	Telecaller	\N	2025-11-05 12:40:14.497202	2025-11-05 12:40:14.497202
143	CASE1762410652316	39	Operations	\N	2025-11-06 06:30:51.82848	2025-11-06 06:30:51.82848
144	CASE1762410652316	30	Telecaller	\N	2025-11-06 06:30:51.830614	2025-11-06 06:30:51.830614
142	CASE1762410652316	35	KAM	\N	2025-11-06 06:30:51.822233	2025-11-06 07:16:52.01636
148	CASE1762414031380	39	Operations	\N	2025-11-06 07:27:12.570036	2025-11-06 07:27:12.570036
149	CASE1762414031380	33	Telecaller	\N	2025-11-06 07:27:12.572038	2025-11-06 07:27:12.572038
151	CASE1762425626265	39	Operations	\N	2025-11-06 10:40:26.791523	2025-11-06 10:40:26.791523
152	CASE1762425626265	30	Telecaller	\N	2025-11-06 10:40:26.793579	2025-11-06 10:40:26.793579
70	CASE1762146979894	35	KAM	\N	2025-11-03 05:16:19.874702	2025-11-29 06:32:28.540247
154	CASE1762428558548	34	KAM	\N	2025-11-06 11:29:19.233746	2025-11-06 11:29:19.233746
32	CASE1761977530872	35	KAM	\N	2025-11-01 06:12:11.840067	2025-11-29 06:19:01.658012
60	CASE1762145698483	34	KAM	\N	2025-11-03 04:54:58.123759	2025-11-29 06:35:22.920296
38	CASE1761978382155	34	KAM	\N	2025-11-01 06:26:22.349916	2025-11-29 06:32:34.771508
2628	CASE1766473798208	35	KAM	\N	2025-12-23 07:10:08.046257	2025-12-24 07:04:37.648033
100	CASE1762249679995	35	KAM	\N	2025-11-04 09:47:59.756444	2025-11-29 06:30:50.008709
155	CASE1762428558548	39	Operations	\N	2025-11-06 11:29:19.239503	2025-11-06 11:29:19.239503
156	CASE1762428558548	46	Telecaller	\N	2025-11-06 11:29:19.244452	2025-11-06 11:29:19.244452
158	CASE1762428638541	39	Operations	\N	2025-11-06 11:30:39.231306	2025-11-06 11:30:39.231306
159	CASE1762428638541	29	Telecaller	\N	2025-11-06 11:30:39.233273	2025-11-06 11:30:39.233273
157	CASE1762428638541	34	KAM	\N	2025-11-06 11:30:39.225621	2025-11-06 11:31:03.225116
161	CASE1762428745324	34	KAM	\N	2025-11-06 11:32:25.971933	2025-11-06 11:32:25.971933
162	CASE1762428745324	39	Operations	\N	2025-11-06 11:32:25.977062	2025-11-06 11:32:25.977062
163	CASE1762428745324	29	Telecaller	\N	2025-11-06 11:32:25.979112	2025-11-06 11:32:25.979112
164	CASE1762428815824	34	KAM	\N	2025-11-06 11:33:36.497756	2025-11-06 11:33:36.497756
165	CASE1762428815824	39	Operations	\N	2025-11-06 11:33:36.50352	2025-11-06 11:33:36.50352
166	CASE1762428815824	29	Telecaller	\N	2025-11-06 11:33:36.505672	2025-11-06 11:33:36.505672
168	CASE1762495682299	39	Operations	\N	2025-11-07 06:08:02.850313	2025-11-07 06:08:02.850313
169	CASE1762495682299	33	Telecaller	\N	2025-11-07 06:08:02.85239	2025-11-07 06:08:02.85239
171	CASE1762496116023	39	Operations	\N	2025-11-07 06:15:11.381287	2025-11-07 06:15:11.381287
172	CASE1762496116023	31	Telecaller	\N	2025-11-07 06:15:11.383261	2025-11-07 06:15:11.383261
175	CASE1762580970506	39	Operations	\N	2025-11-08 05:49:30.5018	2025-11-08 05:49:30.5018
176	CASE1762580970506	30	Telecaller	\N	2025-11-08 05:49:30.503808	2025-11-08 05:49:30.503808
195	CASE1762750626899	35	KAM	\N	2025-11-10 04:57:07.352561	2025-11-29 06:31:51.426346
179	CASE1762581367103	39	Operations	\N	2025-11-08 05:56:01.917523	2025-11-08 05:56:01.917523
180	CASE1762581367103	31	Telecaller	\N	2025-11-08 05:56:01.919628	2025-11-08 05:56:01.919628
182	CASE1762581369675	39	Operations	\N	2025-11-08 05:56:03.61854	2025-11-08 05:56:03.61854
183	CASE1762581369675	31	Telecaller	\N	2025-11-08 05:56:03.620572	2025-11-08 05:56:03.620572
170	CASE1762496116023	36	KAM	\N	2025-11-07 06:15:11.37524	2025-11-29 06:18:33.582984
186	CASE1762588856050	39	Operations	\N	2025-11-08 08:00:56.73316	2025-11-08 08:00:56.73316
187	CASE1762588856050	32	Telecaller	\N	2025-11-08 08:00:56.735245	2025-11-08 08:00:56.735245
248	CASE1762835661410	34	KAM	\N	2025-11-11 04:34:22.468078	2025-11-11 04:34:39.017329
190	CASE1762594309945	39	Operations	\N	2025-11-08 09:31:50.31859	2025-11-08 09:31:50.31859
191	CASE1762594309945	32	Telecaller	\N	2025-11-08 09:31:50.320874	2025-11-08 09:31:50.320874
189	CASE1762594309945	37	KAM	\N	2025-11-08 09:31:50.311597	2025-11-08 09:32:24.563222
185	CASE1762588856050	37	KAM	\N	2025-11-08 08:00:56.726715	2025-11-10 04:44:06.167586
196	CASE1762750626899	39	Operations	\N	2025-11-10 04:57:07.358734	2025-11-10 04:57:07.358734
197	CASE1762750626899	30	Telecaller	\N	2025-11-10 04:57:07.360723	2025-11-10 04:57:07.360723
242	CASE1762835524312	35	KAM	\N	2025-11-11 04:32:04.073282	2025-11-29 06:32:08.48675
202	CASE1762753646383	34	KAM	\N	2025-11-10 05:47:27.053927	2025-11-10 05:47:27.053927
203	CASE1762753646383	39	Operations	\N	2025-11-10 05:47:27.060003	2025-11-10 05:47:27.060003
204	CASE1762753646383	29	Telecaller	\N	2025-11-10 05:47:27.062185	2025-11-10 05:47:27.062185
245	CASE1762835526007	35	KAM	\N	2025-11-11 04:32:05.189482	2025-11-11 04:34:50.108607
207	CASE1762753729616	34	KAM	\N	2025-11-10 05:48:50.241709	2025-11-10 05:48:50.241709
208	CASE1762753729616	39	Operations	\N	2025-11-10 05:48:50.247378	2025-11-10 05:48:50.247378
209	CASE1762753729616	29	Telecaller	\N	2025-11-10 05:48:50.249419	2025-11-10 05:48:50.249419
254	CASE1762835719858	39	Operations	\N	2025-11-11 04:35:13.343295	2025-11-11 04:35:13.343295
255	CASE1762835719858	31	Telecaller	\N	2025-11-11 04:35:13.34538	2025-11-11 04:35:13.34538
174	CASE1762580970506	35	KAM	\N	2025-11-08 05:49:30.495777	2025-11-29 06:31:34.658924
214	CASE1762755936693	39	Operations	\N	2025-11-10 06:25:37.406092	2025-11-10 06:25:37.406092
215	CASE1762755936693	33	Telecaller	\N	2025-11-10 06:25:37.40801	2025-11-10 06:25:37.40801
219	CASE1762756077071	39	Operations	\N	2025-11-10 06:27:57.902712	2025-11-10 06:27:57.902712
220	CASE1762756077071	33	Telecaller	\N	2025-11-10 06:27:57.904717	2025-11-10 06:27:57.904717
221	CASE1762753606380	\N	Banker	\N	2025-11-10 08:13:52.11812	2025-11-10 08:13:52.11812
223	CASE1762769139453	39	Operations	\N	2025-11-10 10:05:39.690888	2025-11-10 10:05:39.690888
224	CASE1762769139453	32	Telecaller	\N	2025-11-10 10:05:39.692922	2025-11-10 10:05:39.692922
222	CASE1762769139453	37	KAM	\N	2025-11-10 10:05:39.684588	2025-11-10 10:06:00.767095
227	CASE1762834354822	39	Operations	\N	2025-11-11 04:12:28.343364	2025-11-11 04:12:28.343364
228	CASE1762834354822	31	Telecaller	\N	2025-11-11 04:12:28.345362	2025-11-11 04:12:28.345362
230	CASE1762835221103	39	Operations	\N	2025-11-11 04:26:54.422724	2025-11-11 04:26:54.422724
231	CASE1762835221103	31	Telecaller	\N	2025-11-11 04:26:54.424875	2025-11-11 04:26:54.424875
253	CASE1762835719858	34	KAM	\N	2025-11-11 04:35:13.337446	2025-11-29 06:21:09.676937
181	CASE1762581369675	37	KAM	\N	2025-11-08 05:56:03.613428	2025-11-29 06:18:21.37253
235	CASE1762835256981	39	Operations	\N	2025-11-11 04:27:36.698671	2025-11-11 04:27:36.698671
236	CASE1762835256981	30	Telecaller	\N	2025-11-11 04:27:36.700681	2025-11-11 04:27:36.700681
234	CASE1762835256981	35	KAM	\N	2025-11-11 04:27:36.692533	2025-11-11 04:27:48.618874
267	CASE1762836019957	35	KAM	\N	2025-11-11 04:40:13.444054	2025-11-29 06:21:26.277604
127	CASE1762339872019	34	KAM	\N	2025-11-05 10:51:07.640794	2025-11-29 06:18:44.210698
178	CASE1762581367103	35	KAM	\N	2025-11-08 05:56:01.911111	2025-11-11 04:30:45.528169
243	CASE1762835524312	39	Operations	\N	2025-11-11 04:32:04.079303	2025-11-11 04:32:04.079303
244	CASE1762835524312	30	Telecaller	\N	2025-11-11 04:32:04.08146	2025-11-11 04:32:04.08146
246	CASE1762835526007	39	Operations	\N	2025-11-11 04:32:05.194387	2025-11-11 04:32:05.194387
247	CASE1762835526007	30	Telecaller	\N	2025-11-11 04:32:05.196405	2025-11-11 04:32:05.196405
249	CASE1762835661410	39	Operations	\N	2025-11-11 04:34:22.474116	2025-11-11 04:34:22.474116
250	CASE1762835661410	32	Telecaller	\N	2025-11-11 04:34:22.476059	2025-11-11 04:34:22.476059
259	CASE1762835826376	39	Operations	\N	2025-11-11 04:37:06.188077	2025-11-11 04:37:06.188077
260	CASE1762835826376	30	Telecaller	\N	2025-11-11 04:37:06.190101	2025-11-11 04:37:06.190101
258	CASE1762835826376	35	KAM	\N	2025-11-11 04:37:06.182168	2025-11-11 04:37:20.90436
213	CASE1762755936693	36	KAM	\N	2025-11-10 06:25:37.400168	2025-11-29 06:33:32.209749
265	CASE1762836004507	39	Operations	\N	2025-11-11 04:40:04.961655	2025-11-11 04:40:04.961655
266	CASE1762836004507	32	Telecaller	\N	2025-11-11 04:40:04.96375	2025-11-11 04:40:04.96375
268	CASE1762836019957	39	Operations	\N	2025-11-11 04:40:13.448988	2025-11-11 04:40:13.448988
269	CASE1762836019957	31	Telecaller	\N	2025-11-11 04:40:13.450877	2025-11-11 04:40:13.450877
264	CASE1762836004507	35	KAM	\N	2025-11-11 04:40:04.955567	2025-11-11 04:40:20.235961
279	CASE1762836174853	35	KAM	\N	2025-11-11 04:42:55.292792	2025-11-11 04:43:11.117996
274	CASE1762836168025	39	Operations	\N	2025-11-11 04:42:48.995597	2025-11-11 04:42:48.995597
275	CASE1762836168025	33	Telecaller	\N	2025-11-11 04:42:48.997583	2025-11-11 04:42:48.997583
277	CASE1762836168765	39	Operations	\N	2025-11-11 04:42:49.383228	2025-11-11 04:42:49.383228
278	CASE1762836168765	33	Telecaller	\N	2025-11-11 04:42:49.385268	2025-11-11 04:42:49.385268
280	CASE1762836174853	39	Operations	\N	2025-11-11 04:42:55.297633	2025-11-11 04:42:55.297633
281	CASE1762836174853	32	Telecaller	\N	2025-11-11 04:42:55.299618	2025-11-11 04:42:55.299618
284	CASE1762836213700	39	Operations	\N	2025-11-11 04:43:27.08305	2025-11-11 04:43:27.08305
285	CASE1762836213700	31	Telecaller	\N	2025-11-11 04:43:27.085021	2025-11-11 04:43:27.085021
283	CASE1762836213700	35	KAM	\N	2025-11-11 04:43:27.077304	2025-11-11 04:44:20.294026
290	CASE1762836379252	39	Operations	\N	2025-11-11 04:46:12.610145	2025-11-11 04:46:12.610145
291	CASE1762836379252	31	Telecaller	\N	2025-11-11 04:46:12.612071	2025-11-11 04:46:12.612071
226	CASE1762834354822	35	KAM	\N	2025-11-11 04:12:28.337256	2025-11-29 06:17:25.220613
294	CASE1762836399409	39	Operations	\N	2025-11-11 04:46:39.863315	2025-11-11 04:46:39.863315
276	CASE1762836168765	35	KAM	\N	2025-11-11 04:42:49.378438	2025-11-29 06:35:35.816429
273	CASE1762836168025	35	KAM	\N	2025-11-11 04:42:48.98975	2025-11-11 05:55:19.47543
289	CASE1762836379252	35	KAM	\N	2025-11-11 04:46:12.597676	2025-11-29 06:17:07.262888
218	CASE1762756077071	36	KAM	\N	2025-11-10 06:27:57.896415	2025-11-11 05:57:22.344095
229	CASE1762835221103	35	KAM	\N	2025-11-11 04:26:54.416679	2025-11-29 06:20:22.914213
295	CASE1762836399409	32	Telecaller	\N	2025-11-11 04:46:39.867981	2025-11-11 04:46:39.867981
297	CASE1762836402193	39	Operations	\N	2025-11-11 04:46:41.879778	2025-11-11 04:46:41.879778
298	CASE1762836402193	30	Telecaller	\N	2025-11-11 04:46:41.881716	2025-11-11 04:46:41.881716
384	CASE1762837520722	35	KAM	\N	2025-11-11 05:05:20.496408	2025-11-11 05:05:31.614979
306	CASE1762836549855	35	KAM	\N	2025-11-11 04:49:09.529684	2025-11-29 06:32:58.357533
293	CASE1762836399409	34	KAM	\N	2025-11-11 04:46:39.857715	2025-11-11 04:46:55.892953
303	CASE1762836537215	39	Operations	\N	2025-11-11 04:48:50.706196	2025-11-11 04:48:50.706196
304	CASE1762836537215	31	Telecaller	\N	2025-11-11 04:48:50.70813	2025-11-11 04:48:50.70813
403	CASE1762837859229	35	KAM	\N	2025-11-11 05:11:00.202485	2025-11-29 06:21:27.799348
307	CASE1762836549855	39	Operations	\N	2025-11-11 04:49:09.534613	2025-11-11 04:49:09.534613
308	CASE1762836549855	30	Telecaller	\N	2025-11-11 04:49:09.536566	2025-11-11 04:49:09.536566
310	CASE1762836582698	39	Operations	\N	2025-11-11 04:49:43.174201	2025-11-11 04:49:43.174201
311	CASE1762836582698	32	Telecaller	\N	2025-11-11 04:49:43.176245	2025-11-11 04:49:43.176245
309	CASE1762836582698	34	KAM	\N	2025-11-11 04:49:43.16826	2025-11-11 04:49:57.781693
315	CASE1762836724833	39	Operations	\N	2025-11-11 04:52:04.671994	2025-11-11 04:52:04.671994
316	CASE1762836724833	30	Telecaller	\N	2025-11-11 04:52:04.673901	2025-11-11 04:52:04.673901
318	CASE1762836738117	39	Operations	\N	2025-11-11 04:52:11.54056	2025-11-11 04:52:11.54056
319	CASE1762836738117	31	Telecaller	\N	2025-11-11 04:52:11.54263	2025-11-11 04:52:11.54263
321	CASE1762836735232	39	Operations	\N	2025-11-11 04:52:15.676994	2025-11-11 04:52:15.676994
322	CASE1762836735232	32	Telecaller	\N	2025-11-11 04:52:15.678904	2025-11-11 04:52:15.678904
388	CASE1762837578102	35	KAM	\N	2025-11-11 05:06:19.072174	2025-11-29 06:23:37.266348
320	CASE1762836735232	34	KAM	\N	2025-11-11 04:52:15.672233	2025-11-11 04:52:30.294931
350	CASE1762837124187	35	KAM	\N	2025-11-11 04:58:43.794255	2025-11-29 06:33:26.364372
314	CASE1762836724833	35	KAM	\N	2025-11-11 04:52:04.666256	2025-11-11 04:52:45.61721
328	CASE1762836984668	39	Operations	\N	2025-11-11 04:56:24.419765	2025-11-11 04:56:24.419765
329	CASE1762836984668	30	Telecaller	\N	2025-11-11 04:56:24.421728	2025-11-11 04:56:24.421728
331	CASE1762836984464	39	Operations	\N	2025-11-11 04:56:24.884248	2025-11-11 04:56:24.884248
332	CASE1762836984464	32	Telecaller	\N	2025-11-11 04:56:24.886256	2025-11-11 04:56:24.886256
334	CASE1762837001046	39	Operations	\N	2025-11-11 04:56:34.449441	2025-11-11 04:56:34.449441
335	CASE1762837001046	31	Telecaller	\N	2025-11-11 04:56:34.451319	2025-11-11 04:56:34.451319
327	CASE1762836984668	35	KAM	\N	2025-11-11 04:56:24.413809	2025-11-11 04:56:37.223159
333	CASE1762837001046	35	KAM	\N	2025-11-11 04:56:34.44458	2025-11-11 04:56:45.405657
330	CASE1762836984464	34	KAM	\N	2025-11-11 04:56:24.879336	2025-11-11 04:56:48.264141
340	CASE1762837053506	39	Operations	\N	2025-11-11 04:57:34.447837	2025-11-11 04:57:34.447837
341	CASE1762837053506	33	Telecaller	\N	2025-11-11 04:57:34.449818	2025-11-11 04:57:34.449818
343	CASE1762837105115	39	Operations	\N	2025-11-11 04:58:18.626757	2025-11-11 04:58:18.626757
344	CASE1762837105115	31	Telecaller	\N	2025-11-11 04:58:18.628872	2025-11-11 04:58:18.628872
389	CASE1762837578102	39	Operations	\N	2025-11-11 05:06:19.077714	2025-11-11 05:06:19.077714
347	CASE1762837109762	39	Operations	\N	2025-11-11 04:58:30.359228	2025-11-11 04:58:30.359228
348	CASE1762837109762	32	Telecaller	\N	2025-11-11 04:58:30.361233	2025-11-11 04:58:30.361233
2622	CASE1766407652250	39	Operations	\N	2025-12-22 12:47:34.086049	2025-12-22 12:47:34.086049
351	CASE1762837124187	39	Operations	\N	2025-11-11 04:58:43.799342	2025-11-11 04:58:43.799342
352	CASE1762837124187	30	Telecaller	\N	2025-11-11 04:58:43.801377	2025-11-11 04:58:43.801377
342	CASE1762837105115	35	KAM	\N	2025-11-11 04:58:18.620683	2025-11-11 04:58:43.974949
363	CASE1762837335105	34	KAM	\N	2025-11-11 05:02:14.859631	2025-11-29 06:33:45.225617
356	CASE1762837235453	39	Operations	\N	2025-11-11 05:00:35.93582	2025-11-11 05:00:35.93582
357	CASE1762837235453	32	Telecaller	\N	2025-11-11 05:00:35.937886	2025-11-11 05:00:35.937886
355	CASE1762837235453	34	KAM	\N	2025-11-11 05:00:35.929862	2025-11-11 05:00:49.450486
360	CASE1762837275126	39	Operations	\N	2025-11-11 05:01:08.583164	2025-11-11 05:01:08.583164
361	CASE1762837275126	31	Telecaller	\N	2025-11-11 05:01:08.585199	2025-11-11 05:01:08.585199
302	CASE1762836537215	35	KAM	\N	2025-11-11 04:48:50.70045	2025-11-29 06:16:47.387843
364	CASE1762837335105	39	Operations	\N	2025-11-11 05:02:14.865326	2025-11-11 05:02:14.865326
365	CASE1762837335105	30	Telecaller	\N	2025-11-11 05:02:14.867286	2025-11-11 05:02:14.867286
390	CASE1762837578102	33	Telecaller	\N	2025-11-11 05:06:19.079798	2025-11-11 05:06:19.079798
369	CASE1762837371975	39	Operations	\N	2025-11-11 05:02:52.705567	2025-11-11 05:02:52.705567
370	CASE1762837371975	32	Telecaller	\N	2025-11-11 05:02:52.707717	2025-11-11 05:02:52.707717
368	CASE1762837371975	35	KAM	\N	2025-11-11 05:02:52.699229	2025-11-11 05:03:09.602482
418	CASE1762838034709	35	KAM	\N	2025-11-11 05:13:54.377238	2025-11-29 06:42:40.884361
374	CASE1762837414827	39	Operations	\N	2025-11-11 05:03:35.748054	2025-11-11 05:03:35.748054
375	CASE1762837414827	33	Telecaller	\N	2025-11-11 05:03:35.750031	2025-11-11 05:03:35.750031
377	CASE1762837439358	39	Operations	\N	2025-11-11 05:03:52.755345	2025-11-11 05:03:52.755345
378	CASE1762837439358	31	Telecaller	\N	2025-11-11 05:03:52.757537	2025-11-11 05:03:52.757537
391	CASE1762837620495	35	KAM	\N	2025-11-11 05:06:53.956815	2025-11-29 06:26:40.964249
381	CASE1762837499901	39	Operations	\N	2025-11-11 05:05:00.338092	2025-11-11 05:05:00.338092
382	CASE1762837499901	32	Telecaller	\N	2025-11-11 05:05:00.340296	2025-11-11 05:05:00.340296
380	CASE1762837499901	35	KAM	\N	2025-11-11 05:05:00.33111	2025-11-11 05:05:18.425145
385	CASE1762837520722	39	Operations	\N	2025-11-11 05:05:20.501346	2025-11-11 05:05:20.501346
386	CASE1762837520722	30	Telecaller	\N	2025-11-11 05:05:20.503357	2025-11-11 05:05:20.503357
392	CASE1762837620495	39	Operations	\N	2025-11-11 05:06:53.962559	2025-11-11 05:06:53.962559
393	CASE1762837620495	31	Telecaller	\N	2025-11-11 05:06:53.964616	2025-11-11 05:06:53.964616
296	CASE1762836402193	35	KAM	\N	2025-11-11 04:46:41.874833	2025-11-29 06:32:40.738273
396	CASE1762837712030	39	Operations	\N	2025-11-11 05:08:32.61896	2025-11-11 05:08:32.61896
397	CASE1762837712030	32	Telecaller	\N	2025-11-11 05:08:32.620893	2025-11-11 05:08:32.620893
395	CASE1762837712030	34	KAM	\N	2025-11-11 05:08:32.613155	2025-11-11 05:08:45.624893
400	CASE1762837751316	39	Operations	\N	2025-11-11 05:09:04.693446	2025-11-11 05:09:04.693446
401	CASE1762837751316	31	Telecaller	\N	2025-11-11 05:09:04.696028	2025-11-11 05:09:04.696028
359	CASE1762837275126	35	KAM	\N	2025-11-11 05:01:08.577298	2025-11-29 06:16:31.892709
404	CASE1762837859229	39	Operations	\N	2025-11-11 05:11:00.209834	2025-11-11 05:11:00.209834
405	CASE1762837859229	33	Telecaller	\N	2025-11-11 05:11:00.212579	2025-11-11 05:11:00.212579
407	CASE1762837864196	39	Operations	\N	2025-11-11 05:11:03.990991	2025-11-11 05:11:03.990991
408	CASE1762837864196	30	Telecaller	\N	2025-11-11 05:11:03.993049	2025-11-11 05:11:03.993049
406	CASE1762837864196	35	KAM	\N	2025-11-11 05:11:03.985977	2025-11-11 05:11:15.633369
411	CASE1762837899223	39	Operations	\N	2025-11-11 05:11:39.650086	2025-11-11 05:11:39.650086
412	CASE1762837899223	32	Telecaller	\N	2025-11-11 05:11:39.652114	2025-11-11 05:11:39.652114
414	CASE1762837917691	39	Operations	\N	2025-11-11 05:11:51.280489	2025-11-11 05:11:51.280489
415	CASE1762837917691	31	Telecaller	\N	2025-11-11 05:11:51.282471	2025-11-11 05:11:51.282471
399	CASE1762837751316	35	KAM	\N	2025-11-11 05:09:04.68763	2025-11-29 06:16:14.022252
410	CASE1762837899223	34	KAM	\N	2025-11-11 05:11:39.644233	2025-11-11 05:12:04.121064
419	CASE1762838034709	39	Operations	\N	2025-11-11 05:13:54.383347	2025-11-11 05:13:54.383347
420	CASE1762838034709	30	Telecaller	\N	2025-11-11 05:13:54.385383	2025-11-11 05:13:54.385383
346	CASE1762837109762	34	KAM	\N	2025-11-11 04:58:30.354297	2025-12-18 04:44:56.161817
423	CASE1762838049088	39	Operations	\N	2025-11-11 05:14:09.565766	2025-11-11 05:14:09.565766
424	CASE1762838049088	32	Telecaller	\N	2025-11-11 05:14:09.567791	2025-11-11 05:14:09.567791
422	CASE1762838049088	34	KAM	\N	2025-11-11 05:14:09.560638	2025-11-11 05:14:40.632909
339	CASE1762837053506	35	KAM	\N	2025-11-11 04:57:34.441959	2025-11-29 06:24:36.551777
317	CASE1762836738117	35	KAM	\N	2025-11-11 04:52:11.535798	2025-11-29 06:21:41.551257
376	CASE1762837439358	35	KAM	\N	2025-11-11 05:03:52.749118	2025-11-29 06:25:18.876661
413	CASE1762837917691	35	KAM	\N	2025-11-11 05:11:51.274708	2025-11-29 06:15:27.616745
426	CASE1762838066302	39	Operations	\N	2025-11-11 05:14:19.660353	2025-11-11 05:14:19.660353
427	CASE1762838066302	31	Telecaller	\N	2025-11-11 05:14:19.663749	2025-11-11 05:14:19.663749
430	CASE1762838073669	39	Operations	\N	2025-11-11 05:14:34.623944	2025-11-11 05:14:34.623944
431	CASE1762838073669	33	Telecaller	\N	2025-11-11 05:14:34.62593	2025-11-11 05:14:34.62593
434	CASE1762838202548	39	Operations	\N	2025-11-11 05:16:36.045502	2025-11-11 05:16:36.045502
435	CASE1762838202548	31	Telecaller	\N	2025-11-11 05:16:36.047531	2025-11-11 05:16:36.047531
425	CASE1762838066302	35	KAM	\N	2025-11-11 05:14:19.655323	2025-11-29 06:14:56.914789
438	CASE1762838228852	39	Operations	\N	2025-11-11 05:17:09.737233	2025-11-11 05:17:09.737233
439	CASE1762838228852	32	Telecaller	\N	2025-11-11 05:17:09.739282	2025-11-11 05:17:09.739282
441	CASE1762838234335	39	Operations	\N	2025-11-11 05:17:15.274749	2025-11-11 05:17:15.274749
442	CASE1762838234335	33	Telecaller	\N	2025-11-11 05:17:15.276956	2025-11-11 05:17:15.276956
437	CASE1762838228852	34	KAM	\N	2025-11-11 05:17:09.731595	2025-11-11 05:17:25.063236
445	CASE1762838265880	39	Operations	\N	2025-11-11 05:17:45.55415	2025-11-11 05:17:45.55415
446	CASE1762838265880	30	Telecaller	\N	2025-11-11 05:17:45.556174	2025-11-11 05:17:45.556174
448	CASE1762838267468	39	Operations	\N	2025-11-11 05:17:46.579024	2025-11-11 05:17:46.579024
449	CASE1762838267468	30	Telecaller	\N	2025-11-11 05:17:46.583897	2025-11-11 05:17:46.583897
517	CASE1762839104555	35	KAM	\N	2025-11-11 05:31:44.286495	2025-11-11 05:31:54.955237
444	CASE1762838265880	35	KAM	\N	2025-11-11 05:17:45.547996	2025-11-11 05:18:05.421825
453	CASE1762838320280	39	Operations	\N	2025-11-11 05:18:33.81369	2025-11-11 05:18:33.81369
454	CASE1762838320280	31	Telecaller	\N	2025-11-11 05:18:33.815739	2025-11-11 05:18:33.815739
472	CASE1762838563629	35	KAM	\N	2025-11-11 05:22:37.119559	2025-11-29 06:27:12.957603
457	CASE1762838356178	39	Operations	\N	2025-11-11 05:19:16.66058	2025-11-11 05:19:16.66058
458	CASE1762838356178	32	Telecaller	\N	2025-11-11 05:19:16.662652	2025-11-11 05:19:16.662652
456	CASE1762838356178	34	KAM	\N	2025-11-11 05:19:16.654951	2025-11-11 05:19:32.736689
447	CASE1762838267468	35	KAM	\N	2025-11-11 05:17:46.571981	2025-11-11 05:20:15.189783
462	CASE1762838419599	39	Operations	\N	2025-11-11 05:20:20.532572	2025-11-11 05:20:20.532572
463	CASE1762838419599	33	Telecaller	\N	2025-11-11 05:20:20.534688	2025-11-11 05:20:20.534688
465	CASE1762838444569	39	Operations	\N	2025-11-11 05:20:38.025854	2025-11-11 05:20:38.025854
466	CASE1762838444569	31	Telecaller	\N	2025-11-11 05:20:38.027918	2025-11-11 05:20:38.027918
464	CASE1762838444569	35	KAM	\N	2025-11-11 05:20:38.01981	2025-11-11 05:20:48.17068
469	CASE1762838515302	39	Operations	\N	2025-11-11 05:21:55.781626	2025-11-11 05:21:55.781626
470	CASE1762838515302	32	Telecaller	\N	2025-11-11 05:21:55.783656	2025-11-11 05:21:55.783656
468	CASE1762838515302	34	KAM	\N	2025-11-11 05:21:55.776087	2025-11-11 05:22:10.121709
473	CASE1762838563629	39	Operations	\N	2025-11-11 05:22:37.125721	2025-11-11 05:22:37.125721
474	CASE1762838563629	31	Telecaller	\N	2025-11-11 05:22:37.127723	2025-11-11 05:22:37.127723
514	CASE1762839103794	34	KAM	\N	2025-11-11 05:31:44.238487	2025-11-11 05:32:02.956003
440	CASE1762838234335	35	KAM	\N	2025-11-11 05:17:15.26976	2025-11-29 06:36:41.47293
478	CASE1762838587556	39	Operations	\N	2025-11-11 05:23:07.190676	2025-11-11 05:23:07.190676
479	CASE1762838587556	30	Telecaller	\N	2025-11-11 05:23:07.192609	2025-11-11 05:23:07.192609
481	CASE1762838589367	39	Operations	\N	2025-11-11 05:23:08.625488	2025-11-11 05:23:08.625488
482	CASE1762838589367	30	Telecaller	\N	2025-11-11 05:23:08.627415	2025-11-11 05:23:08.627415
477	CASE1762838587556	35	KAM	\N	2025-11-11 05:23:07.185639	2025-11-11 05:23:24.358427
486	CASE1762838665957	39	Operations	\N	2025-11-11 05:24:26.457012	2025-11-11 05:24:26.457012
487	CASE1762838665957	32	Telecaller	\N	2025-11-11 05:24:26.458988	2025-11-11 05:24:26.458988
485	CASE1762838665957	34	KAM	\N	2025-11-11 05:24:26.451022	2025-11-11 05:24:41.567024
490	CASE1762838692597	39	Operations	\N	2025-11-11 05:24:46.115503	2025-11-11 05:24:46.115503
491	CASE1762838692597	31	Telecaller	\N	2025-11-11 05:24:46.117535	2025-11-11 05:24:46.117535
433	CASE1762838202548	35	KAM	\N	2025-11-11 05:16:36.039493	2025-11-29 06:14:44.899222
480	CASE1762838589367	35	KAM	\N	2025-11-11 05:23:08.620517	2025-11-11 05:25:39.041009
495	CASE1762838801310	39	Operations	\N	2025-11-11 05:26:34.760623	2025-11-11 05:26:34.760623
496	CASE1762838801310	31	Telecaller	\N	2025-11-11 05:26:34.76267	2025-11-11 05:26:34.76267
489	CASE1762838692597	35	KAM	\N	2025-11-11 05:24:46.110681	2025-11-29 06:14:19.630294
498	CASE1762838828736	34	KAM	\N	2025-11-11 05:27:09.202364	2025-11-11 05:27:09.202364
499	CASE1762838828736	39	Operations	\N	2025-11-11 05:27:09.208139	2025-11-11 05:27:09.208139
500	CASE1762838828736	32	Telecaller	\N	2025-11-11 05:27:09.210235	2025-11-11 05:27:09.210235
502	CASE1762838889522	39	Operations	\N	2025-11-11 05:28:10.489498	2025-11-11 05:28:10.489498
503	CASE1762838889522	33	Telecaller	\N	2025-11-11 05:28:10.491594	2025-11-11 05:28:10.491594
505	CASE1762838890789	39	Operations	\N	2025-11-11 05:28:11.24579	2025-11-11 05:28:11.24579
506	CASE1762838890789	33	Telecaller	\N	2025-11-11 05:28:11.247854	2025-11-11 05:28:11.247854
507	CASE1762838931738	34	KAM	\N	2025-11-11 05:28:52.292491	2025-11-11 05:28:52.292491
508	CASE1762838931738	39	Operations	\N	2025-11-11 05:28:52.298392	2025-11-11 05:28:52.298392
509	CASE1762838931738	32	Telecaller	\N	2025-11-11 05:28:52.300383	2025-11-11 05:28:52.300383
511	CASE1762839001224	39	Operations	\N	2025-11-11 05:29:54.567581	2025-11-11 05:29:54.567581
512	CASE1762839001224	31	Telecaller	\N	2025-11-11 05:29:54.569491	2025-11-11 05:29:54.569491
494	CASE1762838801310	35	KAM	\N	2025-11-11 05:26:34.755391	2025-11-29 06:14:00.497385
515	CASE1762839103794	39	Operations	\N	2025-11-11 05:31:44.244286	2025-11-11 05:31:44.244286
516	CASE1762839103794	32	Telecaller	\N	2025-11-11 05:31:44.246309	2025-11-11 05:31:44.246309
518	CASE1762839104555	39	Operations	\N	2025-11-11 05:31:44.293346	2025-11-11 05:31:44.293346
519	CASE1762839104555	30	Telecaller	\N	2025-11-11 05:31:44.295234	2025-11-11 05:31:44.295234
523	CASE1762839165909	39	Operations	\N	2025-11-11 05:32:39.28746	2025-11-11 05:32:39.28746
524	CASE1762839165909	31	Telecaller	\N	2025-11-11 05:32:39.289431	2025-11-11 05:32:39.289431
510	CASE1762839001224	35	KAM	\N	2025-11-11 05:29:54.56182	2025-11-29 06:13:09.176425
527	CASE1762839184224	39	Operations	\N	2025-11-11 05:33:05.217249	2025-11-11 05:33:05.217249
528	CASE1762839184224	33	Telecaller	\N	2025-11-11 05:33:05.219291	2025-11-11 05:33:05.219291
530	CASE1762839185573	39	Operations	\N	2025-11-11 05:33:06.188724	2025-11-11 05:33:06.188724
531	CASE1762839185573	33	Telecaller	\N	2025-11-11 05:33:06.190856	2025-11-11 05:33:06.190856
532	CASE1762839244514	34	KAM	\N	2025-11-11 05:34:04.978321	2025-11-11 05:34:04.978321
533	CASE1762839244514	39	Operations	\N	2025-11-11 05:34:04.983907	2025-11-11 05:34:04.983907
534	CASE1762839244514	32	Telecaller	\N	2025-11-11 05:34:04.985915	2025-11-11 05:34:04.985915
2623	CASE1766407652250	33	Telecaller	\N	2025-12-22 12:47:34.08829	2025-12-22 12:47:34.08829
536	CASE1762839307825	39	Operations	\N	2025-11-11 05:35:01.167025	2025-11-11 05:35:01.167025
537	CASE1762839307825	31	Telecaller	\N	2025-11-11 05:35:01.169616	2025-11-11 05:35:01.169616
539	CASE1762839304365	39	Operations	\N	2025-11-11 05:35:04.00972	2025-11-11 05:35:04.00972
540	CASE1762839304365	30	Telecaller	\N	2025-11-11 05:35:04.011851	2025-11-11 05:35:04.011851
522	CASE1762839165909	35	KAM	\N	2025-11-11 05:32:39.281464	2025-11-29 06:12:58.194025
538	CASE1762839304365	35	KAM	\N	2025-11-11 05:35:04.004255	2025-11-11 05:35:19.010923
544	CASE1762839387128	39	Operations	\N	2025-11-11 05:36:20.453629	2025-11-11 05:36:20.453629
545	CASE1762839387128	31	Telecaller	\N	2025-11-11 05:36:20.455636	2025-11-11 05:36:20.455636
547	CASE1762839385207	39	Operations	\N	2025-11-11 05:36:25.652896	2025-11-11 05:36:25.652896
548	CASE1762839385207	32	Telecaller	\N	2025-11-11 05:36:25.655043	2025-11-11 05:36:25.655043
546	CASE1762839385207	34	KAM	\N	2025-11-11 05:36:25.647894	2025-11-11 05:36:38.926067
501	CASE1762838889522	34	KAM	\N	2025-11-11 05:28:10.483585	2025-11-11 05:36:41.698367
429	CASE1762838073669	35	KAM	\N	2025-11-11 05:14:34.61898	2025-11-29 06:25:20.588361
526	CASE1762839184224	35	KAM	\N	2025-11-11 05:33:05.209811	2025-11-11 05:50:32.535073
529	CASE1762839185573	35	KAM	\N	2025-11-11 05:33:06.183508	2025-11-29 06:20:24.28484
461	CASE1762838419599	35	KAM	\N	2025-11-11 05:20:20.527366	2025-11-11 05:50:58.979833
452	CASE1762838320280	35	KAM	\N	2025-11-11 05:18:33.808061	2025-11-29 06:27:00.954273
504	CASE1762838890789	34	KAM	\N	2025-11-11 05:28:11.240675	2025-11-11 06:04:13.825043
553	CASE1762839508375	39	Operations	\N	2025-11-11 05:38:28.852763	2025-11-11 05:38:28.852763
554	CASE1762839508375	32	Telecaller	\N	2025-11-11 05:38:28.854824	2025-11-11 05:38:28.854824
167	CASE1762495682299	36	KAM	\N	2025-11-07 06:08:02.844256	2025-11-29 06:51:47.263474
556	CASE1762839665865	34	KAM	\N	2025-11-11 05:41:06.373971	2025-11-11 05:41:06.373971
557	CASE1762839665865	39	Operations	\N	2025-11-11 05:41:06.37972	2025-11-11 05:41:06.37972
558	CASE1762839665865	32	Telecaller	\N	2025-11-11 05:41:06.381773	2025-11-11 05:41:06.381773
560	CASE1762839684196	39	Operations	\N	2025-11-11 05:41:17.651316	2025-11-11 05:41:17.651316
561	CASE1762839684196	31	Telecaller	\N	2025-11-11 05:41:17.653346	2025-11-11 05:41:17.653346
578	CASE1762839927486	35	KAM	\N	2025-11-11 05:45:20.808772	2025-11-29 06:28:14.826988
564	CASE1762839734700	39	Operations	\N	2025-11-11 05:42:14.415076	2025-11-11 05:42:14.415076
565	CASE1762839734700	30	Telecaller	\N	2025-11-11 05:42:14.417019	2025-11-11 05:42:14.417019
563	CASE1762839734700	35	KAM	\N	2025-11-11 05:42:14.40956	2025-11-11 05:42:26.43857
568	CASE1762839773376	39	Operations	\N	2025-11-11 05:42:53.867508	2025-11-11 05:42:53.867508
569	CASE1762839773376	32	Telecaller	\N	2025-11-11 05:42:53.869482	2025-11-11 05:42:53.869482
567	CASE1762839773376	34	KAM	\N	2025-11-11 05:42:53.86177	2025-11-11 05:43:08.305041
572	CASE1762839819406	39	Operations	\N	2025-11-11 05:43:32.959572	2025-11-11 05:43:32.959572
573	CASE1762839819406	31	Telecaller	\N	2025-11-11 05:43:32.9616	2025-11-11 05:43:32.9616
543	CASE1762839387128	35	KAM	\N	2025-11-11 05:36:20.447951	2025-11-29 06:11:50.640519
576	CASE1762839915087	39	Operations	\N	2025-11-11 05:45:15.551068	2025-11-11 05:45:15.551068
577	CASE1762839915087	32	Telecaller	\N	2025-11-11 05:45:15.553019	2025-11-11 05:45:15.553019
579	CASE1762839927486	39	Operations	\N	2025-11-11 05:45:20.813643	2025-11-11 05:45:20.813643
580	CASE1762839927486	31	Telecaller	\N	2025-11-11 05:45:20.815751	2025-11-11 05:45:20.815751
595	CASE1762840090042	35	KAM	\N	2025-11-11 05:48:03.437643	2025-11-29 06:28:23.78157
575	CASE1762839915087	34	KAM	\N	2025-11-11 05:45:15.545316	2025-11-11 05:45:32.689487
584	CASE1762839957202	39	Operations	\N	2025-11-11 05:45:58.182804	2025-11-11 05:45:58.182804
585	CASE1762839957202	33	Telecaller	\N	2025-11-11 05:45:58.184815	2025-11-11 05:45:58.184815
583	CASE1762839957202	34	KAM	\N	2025-11-11 05:45:58.177182	2025-11-11 05:47:26.124782
590	CASE1762840077926	39	Operations	\N	2025-11-11 05:47:57.647091	2025-11-11 05:47:57.647091
591	CASE1762840077926	30	Telecaller	\N	2025-11-11 05:47:57.64906	2025-11-11 05:47:57.64906
593	CASE1762840077981	39	Operations	\N	2025-11-11 05:47:58.41884	2025-11-11 05:47:58.41884
594	CASE1762840077981	32	Telecaller	\N	2025-11-11 05:47:58.420828	2025-11-11 05:47:58.420828
596	CASE1762840090042	39	Operations	\N	2025-11-11 05:48:03.442517	2025-11-11 05:48:03.442517
597	CASE1762840090042	31	Telecaller	\N	2025-11-11 05:48:03.444482	2025-11-11 05:48:03.444482
669	CASE1762840798511	39	Operations	\N	2025-11-11 05:59:51.918713	2025-11-11 05:59:51.918713
668	CASE1762840798511	35	KAM	\N	2025-11-11 05:59:51.91298	2025-11-29 06:29:33.809981
592	CASE1762840077981	36	KAM	\N	2025-11-11 05:47:58.414078	2025-11-11 05:48:17.066905
589	CASE1762840077926	35	KAM	\N	2025-11-11 05:47:57.641304	2025-11-11 05:48:23.920748
603	CASE1762840210341	39	Operations	\N	2025-11-11 05:50:03.684029	2025-11-11 05:50:03.684029
604	CASE1762840210341	31	Telecaller	\N	2025-11-11 05:50:03.686136	2025-11-11 05:50:03.686136
602	CASE1762840210341	35	KAM	\N	2025-11-11 05:50:03.677998	2025-11-11 05:50:14.844002
615	CASE1762840317547	39	Operations	\N	2025-11-11 05:51:51.010146	2025-11-11 05:51:51.010146
616	CASE1762840317547	31	Telecaller	\N	2025-11-11 05:51:51.012284	2025-11-11 05:51:51.012284
649	CASE1762840615660	35	KAM	\N	2025-11-11 05:56:49.090082	2025-11-29 06:41:29.323978
621	CASE1762840358280	39	Operations	\N	2025-11-11 05:52:38.795354	2025-11-11 05:52:38.795354
622	CASE1762840358280	32	Telecaller	\N	2025-11-11 05:52:38.797584	2025-11-11 05:52:38.797584
620	CASE1762840358280	34	KAM	\N	2025-11-11 05:52:38.789214	2025-11-11 05:52:57.755882
625	CASE1762840434189	39	Operations	\N	2025-11-11 05:53:47.671589	2025-11-11 05:53:47.671589
626	CASE1762840434189	31	Telecaller	\N	2025-11-11 05:53:47.673521	2025-11-11 05:53:47.673521
571	CASE1762839819406	35	KAM	\N	2025-11-11 05:43:32.953758	2025-11-29 06:11:26.118606
629	CASE1762840480660	39	Operations	\N	2025-11-11 05:54:41.349594	2025-11-11 05:54:41.349594
630	CASE1762840480660	32	Telecaller	\N	2025-11-11 05:54:41.351642	2025-11-11 05:54:41.351642
628	CASE1762840480660	34	KAM	\N	2025-11-11 05:54:41.343545	2025-11-11 05:54:55.701264
633	CASE1762840513111	39	Operations	\N	2025-11-11 05:55:06.600916	2025-11-11 05:55:06.600916
634	CASE1762840513111	31	Telecaller	\N	2025-11-11 05:55:06.602936	2025-11-11 05:55:06.602936
632	CASE1762840513111	35	KAM	\N	2025-11-11 05:55:06.595932	2025-11-11 05:55:15.945208
638	CASE1762840525206	39	Operations	\N	2025-11-11 05:55:24.917297	2025-11-11 05:55:24.917297
639	CASE1762840525206	30	Telecaller	\N	2025-11-11 05:55:24.919213	2025-11-11 05:55:24.919213
637	CASE1762840525206	35	KAM	\N	2025-11-11 05:55:24.912534	2025-11-11 05:55:40.773749
2621	CASE1766407652250	36	KAM	\N	2025-12-22 12:47:34.079681	2025-12-22 12:49:16.707278
614	CASE1762840317547	35	KAM	\N	2025-11-11 05:51:51.004483	2025-11-29 06:39:51.138888
650	CASE1762840615660	39	Operations	\N	2025-11-11 05:56:49.095092	2025-11-11 05:56:49.095092
651	CASE1762840615660	31	Telecaller	\N	2025-11-11 05:56:49.097026	2025-11-11 05:56:49.097026
552	CASE1762839508375	34	KAM	\N	2025-11-11 05:38:28.846728	2025-11-29 06:42:16.361004
655	CASE1762840635394	39	Operations	\N	2025-11-11 05:57:15.835923	2025-11-11 05:57:15.835923
656	CASE1762840635394	32	Telecaller	\N	2025-11-11 05:57:15.837876	2025-11-11 05:57:15.837876
661	CASE1762840663805	39	Operations	\N	2025-11-11 05:57:43.499767	2025-11-11 05:57:43.499767
662	CASE1762840663805	30	Telecaller	\N	2025-11-11 05:57:43.501833	2025-11-11 05:57:43.501833
660	CASE1762840663805	35	KAM	\N	2025-11-11 05:57:43.49357	2025-11-11 05:58:25.586263
670	CASE1762840798511	31	Telecaller	\N	2025-11-11 05:59:51.920745	2025-11-11 05:59:51.920745
672	CASE1762840794380	39	Operations	\N	2025-11-11 05:59:54.824583	2025-11-11 05:59:54.824583
673	CASE1762840794380	32	Telecaller	\N	2025-11-11 05:59:54.826655	2025-11-11 05:59:54.826655
671	CASE1762840794380	34	KAM	\N	2025-11-11 05:59:54.819625	2025-11-11 06:00:17.68548
683	CASE1762840950332	39	Operations	\N	2025-11-11 06:02:30.804726	2025-11-11 06:02:30.804726
684	CASE1762840950332	32	Telecaller	\N	2025-11-11 06:02:30.806743	2025-11-11 06:02:30.806743
682	CASE1762840950332	34	KAM	\N	2025-11-11 06:02:30.799061	2025-11-11 06:02:46.838101
687	CASE1762840983637	39	Operations	\N	2025-11-11 06:03:03.265115	2025-11-11 06:03:03.265115
688	CASE1762840983637	30	Telecaller	\N	2025-11-11 06:03:03.267093	2025-11-11 06:03:03.267093
686	CASE1762840983637	35	KAM	\N	2025-11-11 06:03:03.259969	2025-11-11 06:03:21.077249
695	CASE1762841235636	39	Operations	\N	2025-11-11 06:07:09.161347	2025-11-11 06:07:09.161347
696	CASE1762841235636	31	Telecaller	\N	2025-11-11 06:07:09.163274	2025-11-11 06:07:09.163274
624	CASE1762840434189	35	KAM	\N	2025-11-11 05:53:47.665955	2025-11-29 06:11:05.175659
699	CASE1762841256000	39	Operations	\N	2025-11-11 06:07:35.62953	2025-11-11 06:07:35.62953
700	CASE1762841256000	30	Telecaller	\N	2025-11-11 06:07:35.631616	2025-11-11 06:07:35.631616
698	CASE1762841256000	35	KAM	\N	2025-11-11 06:07:35.623794	2025-11-11 06:07:46.999386
703	CASE1762841277799	39	Operations	\N	2025-11-11 06:07:58.244332	2025-11-11 06:07:58.244332
704	CASE1762841277799	32	Telecaller	\N	2025-11-11 06:07:58.246436	2025-11-11 06:07:58.246436
702	CASE1762841277799	34	KAM	\N	2025-11-11 06:07:58.239347	2025-11-11 06:08:17.443754
707	CASE1762841323679	39	Operations	\N	2025-11-11 06:08:44.662023	2025-11-11 06:08:44.662023
708	CASE1762841323679	33	Telecaller	\N	2025-11-11 06:08:44.664048	2025-11-11 06:08:44.664048
710	CASE1762841324795	39	Operations	\N	2025-11-11 06:08:45.381305	2025-11-11 06:08:45.381305
711	CASE1762841324795	33	Telecaller	\N	2025-11-11 06:08:45.383246	2025-11-11 06:08:45.383246
713	CASE1762841372227	39	Operations	\N	2025-11-11 06:09:31.828351	2025-11-11 06:09:31.828351
714	CASE1762841372227	30	Telecaller	\N	2025-11-11 06:09:31.830271	2025-11-11 06:09:31.830271
712	CASE1762841372227	35	KAM	\N	2025-11-11 06:09:31.822631	2025-11-11 06:17:13.928578
706	CASE1762841323679	35	KAM	\N	2025-11-11 06:08:44.656373	2025-11-11 06:20:02.193895
694	CASE1762841235636	35	KAM	\N	2025-11-11 06:07:09.15576	2025-11-29 06:10:39.214858
559	CASE1762839684196	35	KAM	\N	2025-11-11 05:41:17.645314	2025-11-29 06:12:29.690446
717	CASE1762841516298	39	Operations	\N	2025-11-11 06:11:49.840806	2025-11-11 06:11:49.840806
718	CASE1762841516298	31	Telecaller	\N	2025-11-11 06:11:49.842816	2025-11-11 06:11:49.842816
720	CASE1762841648757	35	KAM	\N	2025-11-11 06:14:02.118965	2025-11-29 06:32:39.667286
721	CASE1762841648757	39	Operations	\N	2025-11-11 06:14:02.125755	2025-11-11 06:14:02.125755
722	CASE1762841648757	31	Telecaller	\N	2025-11-11 06:14:02.127981	2025-11-11 06:14:02.127981
733	CASE1762841872228	35	KAM	\N	2025-11-11 06:17:45.740531	2025-11-29 06:32:51.271237
725	CASE1762841771663	39	Operations	\N	2025-11-11 06:16:05.071001	2025-11-11 06:16:05.071001
726	CASE1762841771663	31	Telecaller	\N	2025-11-11 06:16:05.073002	2025-11-11 06:16:05.073002
724	CASE1762841771663	35	KAM	\N	2025-11-11 06:16:05.065106	2025-11-11 06:16:15.177203
729	CASE1762841792863	39	Operations	\N	2025-11-11 06:16:33.53106	2025-11-11 06:16:33.53106
730	CASE1762841792863	32	Telecaller	\N	2025-11-11 06:16:33.533052	2025-11-11 06:16:33.533052
728	CASE1762841792863	34	KAM	\N	2025-11-11 06:16:33.525395	2025-11-11 06:16:52.891549
734	CASE1762841872228	39	Operations	\N	2025-11-11 06:17:45.746882	2025-11-11 06:17:45.746882
735	CASE1762841872228	31	Telecaller	\N	2025-11-11 06:17:45.748902	2025-11-11 06:17:45.748902
786	CASE1762843909171	35	KAM	\N	2025-11-11 06:51:48.883728	2025-11-29 06:43:58.765172
738	CASE1762841987974	39	Operations	\N	2025-11-11 06:19:48.501993	2025-11-11 06:19:48.501993
739	CASE1762841987974	32	Telecaller	\N	2025-11-11 06:19:48.503976	2025-11-11 06:19:48.503976
737	CASE1762841987974	34	KAM	\N	2025-11-11 06:19:48.496148	2025-11-11 06:20:06.464862
743	CASE1762842152318	39	Operations	\N	2025-11-11 06:22:32.842879	2025-11-11 06:22:32.842879
744	CASE1762842152318	32	Telecaller	\N	2025-11-11 06:22:32.844882	2025-11-11 06:22:32.844882
830	CASE1763185646398	36	KAM	\N	2025-11-15 05:47:27.272907	2025-11-15 05:47:57.164319
747	CASE1762842780781	39	Operations	\N	2025-11-11 06:32:54.281544	2025-11-11 06:32:54.281544
748	CASE1762842780781	31	Telecaller	\N	2025-11-11 06:32:54.283458	2025-11-11 06:32:54.283458
746	CASE1762842780781	35	KAM	\N	2025-11-11 06:32:54.27567	2025-11-11 06:33:22.89767
752	CASE1762842910656	39	Operations	\N	2025-11-11 06:35:04.238467	2025-11-11 06:35:04.238467
753	CASE1762842910656	31	Telecaller	\N	2025-11-11 06:35:04.240504	2025-11-11 06:35:04.240504
755	CASE1762842911935	39	Operations	\N	2025-11-11 06:35:04.938248	2025-11-11 06:35:04.938248
756	CASE1762842911935	31	Telecaller	\N	2025-11-11 06:35:04.940431	2025-11-11 06:35:04.940431
758	CASE1762842912358	39	Operations	\N	2025-11-11 06:35:05.354434	2025-11-11 06:35:05.354434
759	CASE1762842912358	31	Telecaller	\N	2025-11-11 06:35:05.356517	2025-11-11 06:35:05.356517
776	CASE1762843384332	35	KAM	\N	2025-11-11 06:42:57.860478	2025-11-29 06:06:26.906713
2626	CASE1766473725578	39	Operations	\N	2025-12-23 07:08:48.449629	2025-12-23 07:08:48.449629
2627	CASE1766473725578	31	Telecaller	\N	2025-12-23 07:08:48.451593	2025-12-23 07:08:48.451593
798	CASE1762845747413	36	KAM	\N	2025-11-11 07:22:20.6284	2025-11-29 05:56:31.412047
801	CASE1762845744485	35	KAM	\N	2025-11-11 07:22:23.965672	2025-11-29 06:24:53.520341
767	CASE1762843138846	39	Operations	\N	2025-11-11 06:38:58.530653	2025-11-11 06:38:58.530653
768	CASE1762843138846	30	Telecaller	\N	2025-11-11 06:38:58.532733	2025-11-11 06:38:58.532733
770	CASE1762843142249	39	Operations	\N	2025-11-11 06:39:01.300838	2025-11-11 06:39:01.300838
771	CASE1762843142249	30	Telecaller	\N	2025-11-11 06:39:01.302857	2025-11-11 06:39:01.302857
751	CASE1762842910656	35	KAM	\N	2025-11-11 06:35:04.232542	2025-11-29 06:45:05.464526
818	CASE1762856134388	35	KAM	\N	2025-11-11 10:15:33.760751	2025-11-29 06:19:44.425342
2640	CASE1766558929074	37	KAM	\N	2025-12-24 06:48:50.05652	2025-12-24 07:02:47.599415
777	CASE1762843384332	39	Operations	\N	2025-11-11 06:42:57.873212	2025-11-11 06:42:57.873212
778	CASE1762843384332	31	Telecaller	\N	2025-11-11 06:42:57.877997	2025-11-11 06:42:57.877997
757	CASE1762842912358	35	KAM	\N	2025-11-11 06:35:05.348743	2025-11-29 06:08:05.090118
813	CASE1762846378686	39	Operations	\N	2025-11-11 07:32:58.160887	2025-11-11 07:32:58.160887
769	CASE1762843142249	35	KAM	\N	2025-11-11 06:39:01.295836	2025-11-11 06:43:11.901059
783	CASE1762843520415	39	Operations	\N	2025-11-11 06:45:20.12986	2025-11-11 06:45:20.12986
784	CASE1762843520415	30	Telecaller	\N	2025-11-11 06:45:20.131808	2025-11-11 06:45:20.131808
782	CASE1762843520415	35	KAM	\N	2025-11-11 06:45:20.12409	2025-11-11 06:45:31.272379
787	CASE1762843909171	39	Operations	\N	2025-11-11 06:51:48.889966	2025-11-11 06:51:48.889966
788	CASE1762843909171	30	Telecaller	\N	2025-11-11 06:51:48.891994	2025-11-11 06:51:48.891994
790	CASE1762844229667	39	Operations	\N	2025-11-11 06:57:09.305987	2025-11-11 06:57:09.305987
791	CASE1762844229667	30	Telecaller	\N	2025-11-11 06:57:09.307894	2025-11-11 06:57:09.307894
766	CASE1762843138846	35	KAM	\N	2025-11-11 06:38:58.524517	2025-11-29 06:44:17.201078
21	CASE1761910298881	37	KAM	\N	2025-10-31 11:31:40.694795	2025-11-29 06:30:45.84069
795	CASE1762845471662	39	Operations	\N	2025-11-11 07:17:51.158893	2025-11-11 07:17:51.158893
796	CASE1762845471662	30	Telecaller	\N	2025-11-11 07:17:51.161102	2025-11-11 07:17:51.161102
789	CASE1762844229667	35	KAM	\N	2025-11-11 06:57:09.299069	2025-11-29 06:26:19.953264
799	CASE1762845747413	39	Operations	\N	2025-11-11 07:22:20.635271	2025-11-11 07:22:20.635271
800	CASE1762845747413	31	Telecaller	\N	2025-11-11 07:22:20.637365	2025-11-11 07:22:20.637365
802	CASE1762845744485	39	Operations	\N	2025-11-11 07:22:23.970725	2025-11-11 07:22:23.970725
803	CASE1762845744485	30	Telecaller	\N	2025-11-11 07:22:23.972788	2025-11-11 07:22:23.972788
754	CASE1762842911935	35	KAM	\N	2025-11-11 06:35:04.933247	2025-11-29 05:57:16.640923
814	CASE1762846378686	30	Telecaller	\N	2025-11-11 07:32:58.162921	2025-11-11 07:32:58.162921
794	CASE1762845471662	35	KAM	\N	2025-11-11 07:17:51.15261	2025-11-29 06:25:42.581965
808	CASE1762845923683	39	Operations	\N	2025-11-11 07:25:23.161064	2025-11-11 07:25:23.161064
809	CASE1762845923683	30	Telecaller	\N	2025-11-11 07:25:23.163117	2025-11-11 07:25:23.163117
807	CASE1762845923683	35	KAM	\N	2025-11-11 07:25:23.15526	2025-11-29 06:21:16.974841
742	CASE1762842152318	37	KAM	\N	2025-11-11 06:22:32.837259	2025-11-11 08:16:09.050304
819	CASE1762856134388	39	Operations	\N	2025-11-11 10:15:33.767455	2025-11-11 10:15:33.767455
820	CASE1762856134388	30	Telecaller	\N	2025-11-11 10:15:33.769465	2025-11-11 10:15:33.769465
835	CASE1763185803230	39	Operations	\N	2025-11-15 05:50:04.212744	2025-11-15 05:50:04.212744
823	CASE1762857249375	39	Operations	\N	2025-11-11 10:34:09.246016	2025-11-11 10:34:09.246016
824	CASE1762857249375	32	Telecaller	\N	2025-11-11 10:34:09.248079	2025-11-11 10:34:09.248079
826	CASE1762858802202	36	KAM	\N	2025-11-11 11:00:03.036807	2025-11-24 08:52:38.474684
827	CASE1762858802202	39	Operations	\N	2025-11-11 11:00:03.043029	2025-11-11 11:00:03.043029
828	CASE1762858802202	33	Telecaller	\N	2025-11-11 11:00:03.045182	2025-11-11 11:00:03.045182
709	CASE1762841324795	35	KAM	\N	2025-11-11 06:08:45.376488	2025-11-29 06:19:48.122914
831	CASE1763185646398	39	Operations	\N	2025-11-15 05:47:27.284911	2025-11-15 05:47:27.284911
832	CASE1763185646398	32	Telecaller	\N	2025-11-15 05:47:27.286944	2025-11-15 05:47:27.286944
836	CASE1763185803230	32	Telecaller	\N	2025-11-15 05:50:04.214796	2025-11-15 05:50:04.214796
834	CASE1763185803230	36	KAM	\N	2025-11-15 05:50:04.206241	2025-11-15 05:50:19.605121
839	CASE1763185984378	39	Operations	\N	2025-11-15 05:53:05.271882	2025-11-15 05:53:05.271882
840	CASE1763185984378	32	Telecaller	\N	2025-11-15 05:53:05.273885	2025-11-15 05:53:05.273885
842	CASE1763185986592	39	Operations	\N	2025-11-15 05:53:06.564028	2025-11-15 05:53:06.564028
843	CASE1763185986592	32	Telecaller	\N	2025-11-15 05:53:06.566005	2025-11-15 05:53:06.566005
841	CASE1763185986592	36	KAM	\N	2025-11-15 05:53:06.558719	2025-11-15 05:55:21.587037
838	CASE1763185984378	36	KAM	\N	2025-11-15 05:53:05.266125	2025-11-15 05:56:02.494147
848	CASE1763186470651	39	Operations	\N	2025-11-15 06:01:11.677201	2025-11-15 06:01:11.677201
849	CASE1763186470651	32	Telecaller	\N	2025-11-15 06:01:11.67912	2025-11-15 06:01:11.67912
847	CASE1763186470651	37	KAM	\N	2025-11-15 06:01:11.671239	2025-11-15 06:01:44.312204
852	CASE1763186683929	39	Operations	\N	2025-11-15 06:04:44.79491	2025-11-15 06:04:44.79491
853	CASE1763186683929	32	Telecaller	\N	2025-11-15 06:04:44.797162	2025-11-15 06:04:44.797162
851	CASE1763186683929	37	KAM	\N	2025-11-15 06:04:44.788802	2025-11-15 06:05:58.507768
822	CASE1762857249375	34	KAM	\N	2025-11-11 10:34:09.239934	2025-11-19 09:01:15.346567
812	CASE1762846378686	35	KAM	\N	2025-11-11 07:32:58.154866	2025-11-29 06:20:32.02428
716	CASE1762841516298	35	KAM	\N	2025-11-11 06:11:49.835105	2025-11-29 06:31:58.054024
857	CASE1763186948340	39	Operations	\N	2025-11-15 06:09:09.238902	2025-11-15 06:09:09.238902
858	CASE1763186948340	32	Telecaller	\N	2025-11-15 06:09:09.241728	2025-11-15 06:09:09.241728
856	CASE1763186948340	36	KAM	\N	2025-11-15 06:09:09.2327	2025-11-15 06:09:31.660288
861	CASE1763187103363	39	Operations	\N	2025-11-15 06:11:44.401029	2025-11-15 06:11:44.401029
862	CASE1763187103363	32	Telecaller	\N	2025-11-15 06:11:44.40317	2025-11-15 06:11:44.40317
892	CASE1763372371236	34	KAM	\N	2025-11-17 09:39:32.165155	2025-11-29 06:24:18.352141
865	CASE1763368979329	39	Operations	\N	2025-11-17 08:42:58.907343	2025-11-17 08:42:58.907343
866	CASE1763368979329	32	Telecaller	\N	2025-11-17 08:42:58.909448	2025-11-17 08:42:58.909448
880	CASE1763370566141	36	KAM	\N	2025-11-17 09:09:26.876318	2025-11-29 06:37:47.276237
869	CASE1763369621865	39	Operations	\N	2025-11-17 08:53:42.817773	2025-11-17 08:53:42.817773
870	CASE1763369621865	33	Telecaller	\N	2025-11-17 08:53:42.819881	2025-11-17 08:53:42.819881
872	CASE1763369623343	39	Operations	\N	2025-11-17 08:53:43.259557	2025-11-17 08:53:43.259557
873	CASE1763369623343	33	Telecaller	\N	2025-11-17 08:53:43.261468	2025-11-17 08:53:43.261468
958	CASE1763615717221	36	KAM	\N	2025-11-20 05:15:18.177009	2025-11-29 06:21:09.708312
877	CASE1763370420586	39	Operations	\N	2025-11-17 09:07:00.286081	2025-11-17 09:07:00.286081
878	CASE1763370420586	32	Telecaller	\N	2025-11-17 09:07:00.288484	2025-11-17 09:07:00.288484
955	CASE1763554564523	39	Operations	\N	2025-11-19 12:16:04.482975	2025-11-19 12:16:04.482975
881	CASE1763370566141	39	Operations	\N	2025-11-17 09:09:26.882444	2025-11-17 09:09:26.882444
882	CASE1763370566141	33	Telecaller	\N	2025-11-17 09:09:26.884557	2025-11-17 09:09:26.884557
884	CASE1763370568575	39	Operations	\N	2025-11-17 09:09:28.467106	2025-11-17 09:09:28.467106
885	CASE1763370568575	33	Telecaller	\N	2025-11-17 09:09:28.469447	2025-11-17 09:09:28.469447
956	CASE1763554564523	32	Telecaller	\N	2025-11-19 12:16:04.485046	2025-11-19 12:16:04.485046
954	CASE1763554564523	34	KAM	\N	2025-11-19 12:16:04.476432	2025-11-19 12:16:24.983372
959	CASE1763615717221	39	Operations	\N	2025-11-20 05:15:18.183631	2025-11-20 05:15:18.183631
883	CASE1763370568575	36	KAM	\N	2025-11-17 09:09:28.461714	2025-11-17 09:15:23.67301
893	CASE1763372371236	39	Operations	\N	2025-11-17 09:39:32.171804	2025-11-17 09:39:32.171804
894	CASE1763372371236	32	Telecaller	\N	2025-11-17 09:39:32.173902	2025-11-17 09:39:32.173902
876	CASE1763370420586	37	KAM	\N	2025-11-17 09:07:00.278816	2025-11-29 06:25:56.364495
864	CASE1763368979329	37	KAM	\N	2025-11-17 08:42:58.900997	2025-11-29 06:28:10.759588
898	CASE1763442514766	39	Operations	\N	2025-11-18 05:08:24.287571	2025-11-18 05:08:24.287571
899	CASE1763442514766	31	Telecaller	\N	2025-11-18 05:08:24.289676	2025-11-18 05:08:24.289676
960	CASE1763615717221	32	Telecaller	\N	2025-11-20 05:15:18.185724	2025-11-20 05:15:18.185724
902	CASE1763442727419	39	Operations	\N	2025-11-18 05:11:56.961801	2025-11-18 05:11:56.961801
903	CASE1763442727419	31	Telecaller	\N	2025-11-18 05:11:56.963874	2025-11-18 05:11:56.963874
905	CASE1763442861051	39	Operations	\N	2025-11-18 05:14:10.608688	2025-11-18 05:14:10.608688
906	CASE1763442861051	31	Telecaller	\N	2025-11-18 05:14:10.610769	2025-11-18 05:14:10.610769
983	CASE1763702492835	37	KAM	\N	2025-11-21 05:21:21.723867	2025-11-29 05:52:11.790099
910	CASE1763442996709	39	Operations	\N	2025-11-18 05:16:26.234422	2025-11-18 05:16:26.234422
911	CASE1763442996709	31	Telecaller	\N	2025-11-18 05:16:26.236513	2025-11-18 05:16:26.236513
963	CASE1763618269726	39	Operations	\N	2025-11-20 05:57:38.653212	2025-11-20 05:57:38.653212
930	CASE1763542084786	37	KAM	\N	2025-11-19 08:48:04.521884	2025-11-29 06:14:40.870575
909	CASE1763442996709	37	KAM	\N	2025-11-18 05:16:26.22856	2025-11-29 06:08:56.883887
904	CASE1763442861051	37	KAM	\N	2025-11-18 05:14:10.602568	2025-11-29 06:02:51.597573
897	CASE1763442514766	37	KAM	\N	2025-11-18 05:08:24.280973	2025-11-18 07:31:22.658568
917	CASE1763451322432	37	KAM	\N	2025-11-18 07:35:11.972582	2025-11-18 07:35:11.972582
918	CASE1763451322432	39	Operations	\N	2025-11-18 07:35:11.979144	2025-11-18 07:35:11.979144
919	CASE1763451322432	31	Telecaller	\N	2025-11-18 07:35:11.981275	2025-11-18 07:35:11.981275
921	CASE1763534794920	39	Operations	\N	2025-11-19 06:46:24.150098	2025-11-19 06:46:24.150098
922	CASE1763534794920	31	Telecaller	\N	2025-11-19 06:46:24.152081	2025-11-19 06:46:24.152081
901	CASE1763442727419	37	KAM	\N	2025-11-18 05:11:56.955773	2025-11-29 05:54:51.459566
860	CASE1763187103363	36	KAM	\N	2025-11-15 06:11:44.394961	2025-11-19 08:13:23.646974
928	CASE1763542082443	39	Operations	\N	2025-11-19 08:48:03.044654	2025-11-19 08:48:03.044654
929	CASE1763542082443	33	Telecaller	\N	2025-11-19 08:48:03.046852	2025-11-19 08:48:03.046852
931	CASE1763542084786	39	Operations	\N	2025-11-19 08:48:04.526951	2025-11-19 08:48:04.526951
932	CASE1763542084786	33	Telecaller	\N	2025-11-19 08:48:04.528971	2025-11-19 08:48:04.528971
964	CASE1763618269726	31	Telecaller	\N	2025-11-20 05:57:38.655384	2025-11-20 05:57:38.655384
990	CASE1763704870223	35	KAM	\N	2025-11-21 06:01:10.214822	2025-11-29 06:16:03.815543
936	CASE1763542475926	39	Operations	\N	2025-11-19 08:54:36.509073	2025-11-19 08:54:36.509073
937	CASE1763542475926	33	Telecaller	\N	2025-11-19 08:54:36.511144	2025-11-19 08:54:36.511144
939	CASE1763542676760	39	Operations	\N	2025-11-19 08:57:57.319203	2025-11-19 08:57:57.319203
940	CASE1763542676760	33	Telecaller	\N	2025-11-19 08:57:57.321135	2025-11-19 08:57:57.321135
920	CASE1763534794920	37	KAM	\N	2025-11-19 06:46:24.143807	2025-11-29 05:54:32.466535
987	CASE1763702934728	35	KAM	\N	2025-11-21 05:28:54.596519	2025-11-29 06:18:38.16268
945	CASE1763542806642	39	Operations	\N	2025-11-19 08:59:56.671277	2025-11-19 08:59:56.671277
946	CASE1763542806642	31	Telecaller	\N	2025-11-19 08:59:56.673361	2025-11-19 08:59:56.673361
871	CASE1763369623343	34	KAM	\N	2025-11-17 08:53:43.254181	2025-11-19 08:59:57.537332
944	CASE1763542806642	36	KAM	\N	2025-11-19 08:59:56.6656	2025-11-19 09:00:12.12403
951	CASE1763544129762	39	Operations	\N	2025-11-19 09:22:09.760169	2025-11-19 09:22:09.760169
952	CASE1763544129762	32	Telecaller	\N	2025-11-19 09:22:09.762212	2025-11-19 09:22:09.762212
967	CASE1763618459035	39	Operations	\N	2025-11-20 06:00:47.925299	2025-11-20 06:00:47.925299
968	CASE1763618459035	31	Telecaller	\N	2025-11-20 06:00:47.927341	2025-11-20 06:00:47.927341
962	CASE1763618269726	37	KAM	\N	2025-11-20 05:57:38.646819	2025-11-29 05:52:32.595773
971	CASE1763640521596	39	Operations	\N	2025-11-20 12:08:42.553769	2025-11-20 12:08:42.553769
972	CASE1763640521596	33	Telecaller	\N	2025-11-20 12:08:42.555822	2025-11-20 12:08:42.555822
974	CASE1763701219138	39	Operations	\N	2025-11-21 05:00:19.79622	2025-11-21 05:00:19.79622
975	CASE1763701219138	32	Telecaller	\N	2025-11-21 05:00:19.798224	2025-11-21 05:00:19.798224
973	CASE1763701219138	34	KAM	\N	2025-11-21 05:00:19.789693	2025-11-21 05:00:42.316414
978	CASE1763702198816	39	Operations	\N	2025-11-21 05:16:39.532605	2025-11-21 05:16:39.532605
979	CASE1763702198816	33	Telecaller	\N	2025-11-21 05:16:39.534629	2025-11-21 05:16:39.534629
981	CASE1763702200488	39	Operations	\N	2025-11-21 05:16:40.65142	2025-11-21 05:16:40.65142
982	CASE1763702200488	33	Telecaller	\N	2025-11-21 05:16:40.653433	2025-11-21 05:16:40.653433
984	CASE1763702492835	39	Operations	\N	2025-11-21 05:21:21.729771	2025-11-21 05:21:21.729771
985	CASE1763702492835	31	Telecaller	\N	2025-11-21 05:21:21.731716	2025-11-21 05:21:21.731716
966	CASE1763618459035	35	KAM	\N	2025-11-20 06:00:47.918035	2025-11-29 05:52:21.285978
988	CASE1763702934728	39	Operations	\N	2025-11-21 05:28:54.602619	2025-11-21 05:28:54.602619
989	CASE1763702934728	30	Telecaller	\N	2025-11-21 05:28:54.604631	2025-11-21 05:28:54.604631
991	CASE1763704870223	39	Operations	\N	2025-11-21 06:01:10.2213	2025-11-21 06:01:10.2213
992	CASE1763704870223	30	Telecaller	\N	2025-11-21 06:01:10.22335	2025-11-21 06:01:10.22335
868	CASE1763369621865	34	KAM	\N	2025-11-17 08:53:42.811695	2025-11-29 06:18:42.405004
980	CASE1763702200488	36	KAM	\N	2025-11-21 05:16:40.646215	2025-11-29 06:16:26.052466
996	CASE1763708290628	39	Operations	\N	2025-11-21 06:58:10.541028	2025-11-21 06:58:10.541028
997	CASE1763708290628	30	Telecaller	\N	2025-11-21 06:58:10.54308	2025-11-21 06:58:10.54308
927	CASE1763542082443	37	KAM	\N	2025-11-19 08:48:03.038024	2025-11-29 06:17:04.899208
977	CASE1763702198816	37	KAM	\N	2025-11-21 05:16:39.526334	2025-11-21 07:32:44.021203
950	CASE1763544129762	37	KAM	\N	2025-11-19 09:22:09.753573	2025-11-29 06:22:28.724823
970	CASE1763640521596	37	KAM	\N	2025-11-20 12:08:42.547309	2025-11-21 07:33:13.592237
935	CASE1763542475926	37	KAM	\N	2025-11-19 08:54:36.502999	2025-11-24 08:52:02.454692
1104	CASE1764136624464	35	KAM	\N	2025-11-26 05:57:03.391948	2025-11-29 06:12:17.450384
1001	CASE1763708523280	39	Operations	\N	2025-11-21 07:02:04.051387	2025-11-21 07:02:04.051387
1002	CASE1763708523280	33	Telecaller	\N	2025-11-21 07:02:04.05373	2025-11-21 07:02:04.05373
1109	CASE1764136680225	39	Operations	\N	2025-11-26 05:58:00.252442	2025-11-26 05:58:00.252442
938	CASE1763542676760	37	KAM	\N	2025-11-19 08:57:57.31394	2025-11-21 07:33:59.982277
1012	CASE1763714634849	39	Operations	\N	2025-11-21 08:43:55.090374	2025-11-21 08:43:55.090374
1013	CASE1763714634849	32	Telecaller	\N	2025-11-21 08:43:55.092464	2025-11-21 08:43:55.092464
1098	CASE1764065401623	36	KAM	\N	2025-11-25 10:10:02.780378	2025-11-29 06:34:49.940824
1017	CASE1763717344445	39	Operations	\N	2025-11-21 09:29:03.612768	2025-11-21 09:29:03.612768
1018	CASE1763717344445	30	Telecaller	\N	2025-11-21 09:29:03.614908	2025-11-21 09:29:03.614908
995	CASE1763708290628	35	KAM	\N	2025-11-21 06:58:10.53465	2025-11-29 06:15:41.220967
1062	CASE1763973946337	37	KAM	\N	2025-11-24 08:45:46.428014	2025-11-29 06:15:56.53896
1024	CASE1763961099583	39	Operations	\N	2025-11-24 05:11:40.203792	2025-11-24 05:11:40.203792
1025	CASE1763961099583	32	Telecaller	\N	2025-11-24 05:11:40.205945	2025-11-24 05:11:40.205945
1023	CASE1763961099583	36	KAM	\N	2025-11-24 05:11:40.196518	2025-11-24 05:12:00.308786
1027	CASE1763961482563	34	KAM	\N	2025-11-24 05:18:03.654993	2025-11-24 05:18:03.654993
1028	CASE1763961482563	39	Operations	\N	2025-11-24 05:18:03.660578	2025-11-24 05:18:03.660578
1029	CASE1763961482563	29	Telecaller	\N	2025-11-24 05:18:03.66252	2025-11-24 05:18:03.66252
1030	CASE1763961484646	34	KAM	\N	2025-11-24 05:18:04.860814	2025-11-24 05:18:04.860814
1031	CASE1763961484646	39	Operations	\N	2025-11-24 05:18:04.866622	2025-11-24 05:18:04.866622
1032	CASE1763961484646	29	Telecaller	\N	2025-11-24 05:18:04.868545	2025-11-24 05:18:04.868545
1033	CASE1763961486296	34	KAM	\N	2025-11-24 05:18:06.761067	2025-11-24 05:18:06.761067
1034	CASE1763961486296	39	Operations	\N	2025-11-24 05:18:06.765778	2025-11-24 05:18:06.765778
1035	CASE1763961486296	29	Telecaller	\N	2025-11-24 05:18:06.767734	2025-11-24 05:18:06.767734
1036	CASE1763961487013	34	KAM	\N	2025-11-24 05:18:07.210888	2025-11-24 05:18:07.210888
1037	CASE1763961487013	39	Operations	\N	2025-11-24 05:18:07.215538	2025-11-24 05:18:07.215538
1038	CASE1763961487013	29	Telecaller	\N	2025-11-24 05:18:07.217334	2025-11-24 05:18:07.217334
1039	CASE1763961580379	34	KAM	\N	2025-11-24 05:19:41.480466	2025-11-24 05:19:41.480466
1040	CASE1763961580379	39	Operations	\N	2025-11-24 05:19:41.486414	2025-11-24 05:19:41.486414
1041	CASE1763961580379	29	Telecaller	\N	2025-11-24 05:19:41.488456	2025-11-24 05:19:41.488456
1042	CASE1763961635844	34	KAM	\N	2025-11-24 05:20:36.39513	2025-11-24 05:20:36.39513
1043	CASE1763961635844	39	Operations	\N	2025-11-24 05:20:36.400579	2025-11-24 05:20:36.400579
1044	CASE1763961635844	29	Telecaller	\N	2025-11-24 05:20:36.402466	2025-11-24 05:20:36.402466
1045	CASE1763961694158	34	KAM	\N	2025-11-24 05:21:35.183712	2025-11-24 05:21:35.183712
1046	CASE1763961694158	39	Operations	\N	2025-11-24 05:21:35.189485	2025-11-24 05:21:35.189485
1047	CASE1763961694158	29	Telecaller	\N	2025-11-24 05:21:35.192531	2025-11-24 05:21:35.192531
1048	CASE1763961798076	34	KAM	\N	2025-11-24 05:23:19.176504	2025-11-24 05:23:19.176504
1049	CASE1763961798076	39	Operations	\N	2025-11-24 05:23:19.182494	2025-11-24 05:23:19.182494
1050	CASE1763961798076	29	Telecaller	\N	2025-11-24 05:23:19.184492	2025-11-24 05:23:19.184492
1051	CASE1763961873906	34	KAM	\N	2025-11-24 05:24:35.083885	2025-11-24 05:24:35.083885
1052	CASE1763961873906	39	Operations	\N	2025-11-24 05:24:35.092866	2025-11-24 05:24:35.092866
1053	CASE1763961873906	29	Telecaller	\N	2025-11-24 05:24:35.09495	2025-11-24 05:24:35.09495
1055	CASE1763963147413	39	Operations	\N	2025-11-24 05:45:45.951659	2025-11-24 05:45:45.951659
1056	CASE1763963147413	30	Telecaller	\N	2025-11-24 05:45:45.954193	2025-11-24 05:45:45.954193
1143	CASE1764235668458	36	KAM	\N	2025-11-27 09:27:49.052783	2025-11-29 06:14:16.001905
1059	CASE1763973936989	39	Operations	\N	2025-11-24 08:45:34.154287	2025-11-24 08:45:34.154287
1060	CASE1763973936989	31	Telecaller	\N	2025-11-24 08:45:34.156339	2025-11-24 08:45:34.156339
1080	CASE1764052495073	37	KAM	\N	2025-11-25 06:34:54.099995	2025-11-29 06:06:15.269695
1063	CASE1763973946337	39	Operations	\N	2025-11-24 08:45:46.432984	2025-11-24 08:45:46.432984
1064	CASE1763973946337	33	Telecaller	\N	2025-11-24 08:45:46.435053	2025-11-24 08:45:46.435053
1066	CASE1763973948471	39	Operations	\N	2025-11-24 08:45:47.807253	2025-11-24 08:45:47.807253
1067	CASE1763973948471	33	Telecaller	\N	2025-11-24 08:45:47.809305	2025-11-24 08:45:47.809305
1110	CASE1764136680225	31	Telecaller	\N	2025-11-26 05:58:00.254966	2025-11-26 05:58:00.254966
1000	CASE1763708523280	37	KAM	\N	2025-11-21 07:02:04.04461	2025-11-24 08:50:59.146562
1108	CASE1764136680225	37	KAM	\N	2025-11-26 05:58:00.245096	2025-11-29 05:51:35.427689
2629	CASE1766473798208	39	Operations	\N	2025-12-23 07:10:08.053433	2025-12-23 07:10:08.053433
1065	CASE1763973948471	37	KAM	\N	2025-11-24 08:45:47.802447	2025-11-25 06:31:50.889222
1078	CASE1764052492961	39	Operations	\N	2025-11-25 06:34:52.846765	2025-11-25 06:34:52.846765
1079	CASE1764052492961	33	Telecaller	\N	2025-11-25 06:34:52.848934	2025-11-25 06:34:52.848934
1081	CASE1764052495073	39	Operations	\N	2025-11-25 06:34:54.105177	2025-11-25 06:34:54.105177
1082	CASE1764052495073	33	Telecaller	\N	2025-11-25 06:34:54.107165	2025-11-25 06:34:54.107165
1114	CASE1764139259788	39	Operations	\N	2025-11-26 06:41:00.799938	2025-11-26 06:41:00.799938
1086	CASE1764054076409	39	Operations	\N	2025-11-25 07:01:16.659103	2025-11-25 07:01:16.659103
1087	CASE1764054076409	30	Telecaller	\N	2025-11-25 07:01:16.661058	2025-11-25 07:01:16.661058
1054	CASE1763963147413	35	KAM	\N	2025-11-24 05:45:45.945209	2025-11-29 06:13:57.507939
1089	CASE1763973948471	42	UW	\N	2025-11-25 07:03:02.131139	2025-11-25 07:03:02.131139
1092	CASE1763442514766	42	UW	\N	2025-11-25 07:05:38.724744	2025-11-25 07:05:38.724744
1095	CASE1764064444019	39	Operations	\N	2025-11-25 09:54:04.964557	2025-11-25 09:54:04.964557
1096	CASE1764064444019	32	Telecaller	\N	2025-11-25 09:54:04.966614	2025-11-25 09:54:04.966614
1011	CASE1763714634849	37	KAM	\N	2025-11-21 08:43:55.083575	2025-11-29 06:19:56.076959
1099	CASE1764065401623	39	Operations	\N	2025-11-25 10:10:02.787004	2025-11-25 10:10:02.787004
1100	CASE1764065401623	31	Telecaller	\N	2025-11-25 10:10:02.789102	2025-11-25 10:10:02.789102
1139	CASE1764234777768	35	KAM	\N	2025-11-27 09:12:58.705991	2025-11-29 06:11:09.85188
1115	CASE1764139259788	32	Telecaller	\N	2025-11-26 06:41:00.80187	2025-11-26 06:41:00.80187
1113	CASE1764139259788	37	KAM	\N	2025-11-26 06:41:00.793533	2025-11-29 06:16:08.764832
1105	CASE1764136624464	39	Operations	\N	2025-11-26 05:57:03.398244	2025-11-26 05:57:03.398244
1106	CASE1764136624464	30	Telecaller	\N	2025-11-26 05:57:03.400337	2025-11-26 05:57:03.400337
1094	CASE1764064444019	36	KAM	\N	2025-11-25 09:54:04.958307	2025-11-29 06:18:05.314347
1118	CASE1764140926286	39	Operations	\N	2025-11-26 07:08:47.500234	2025-11-26 07:08:47.500234
1119	CASE1764140926286	32	Telecaller	\N	2025-11-26 07:08:47.5023	2025-11-26 07:08:47.5023
1117	CASE1764140926286	36	KAM	\N	2025-11-26 07:08:47.493288	2025-11-26 07:09:06.279083
1122	CASE1764147995254	39	Operations	\N	2025-11-26 09:06:35.33825	2025-11-26 09:06:35.33825
1123	CASE1764147995254	31	Telecaller	\N	2025-11-26 09:06:35.340386	2025-11-26 09:06:35.340386
1085	CASE1764054076409	35	KAM	\N	2025-11-25 07:01:16.653311	2025-11-29 06:13:26.002016
1127	CASE1764150571308	39	Operations	\N	2025-11-26 09:49:32.30177	2025-11-26 09:49:32.30177
1128	CASE1764150571308	32	Telecaller	\N	2025-11-26 09:49:32.304067	2025-11-26 09:49:32.304067
1126	CASE1764150571308	36	KAM	\N	2025-11-26 09:49:32.29418	2025-11-26 09:49:55.659669
1132	CASE1764223128315	39	Operations	\N	2025-11-27 05:58:47.552434	2025-11-27 05:58:47.552434
1133	CASE1764223128315	30	Telecaller	\N	2025-11-27 05:58:47.554369	2025-11-27 05:58:47.554369
1058	CASE1763973936989	37	KAM	\N	2025-11-24 08:45:34.147771	2025-11-29 06:09:19.841024
1140	CASE1764234777768	39	Operations	\N	2025-11-27 09:12:58.711969	2025-11-27 09:12:58.711969
1141	CASE1764234777768	30	Telecaller	\N	2025-11-27 09:12:58.71396	2025-11-27 09:12:58.71396
1131	CASE1764223128315	35	KAM	\N	2025-11-27 05:58:47.546525	2025-11-29 06:11:54.654917
1144	CASE1764235668458	39	Operations	\N	2025-11-27 09:27:49.058825	2025-11-27 09:27:49.058825
1145	CASE1764235668458	32	Telecaller	\N	2025-11-27 09:27:49.060806	2025-11-27 09:27:49.060806
1016	CASE1763717344445	35	KAM	\N	2025-11-21 09:29:03.606398	2025-11-29 06:15:08.71952
1148	CASE1764237339048	39	Operations	\N	2025-11-27 09:55:40.707846	2025-11-27 09:55:40.707846
1077	CASE1764052492961	34	KAM	\N	2025-11-25 06:34:52.840095	2025-11-29 05:02:58.720271
1121	CASE1764147995254	36	KAM	\N	2025-11-26 09:06:35.331985	2025-11-29 05:51:21.642266
1149	CASE1764237339048	33	Telecaller	\N	2025-11-27 09:55:40.709826	2025-11-27 09:55:40.709826
1151	CASE1764237341283	39	Operations	\N	2025-11-27 09:55:42.079632	2025-11-27 09:55:42.079632
1152	CASE1764237341283	33	Telecaller	\N	2025-11-27 09:55:42.082099	2025-11-27 09:55:42.082099
1154	CASE1764244386142	39	Operations	\N	2025-11-27 11:53:07.16363	2025-11-27 11:53:07.16363
1155	CASE1764244386142	32	Telecaller	\N	2025-11-27 11:53:07.165613	2025-11-27 11:53:07.165613
373	CASE1762837414827	35	KAM	\N	2025-11-11 05:03:35.743259	2025-11-29 06:22:24.780091
1158	CASE1764305260862	39	Operations	\N	2025-11-28 04:47:40.346671	2025-11-28 04:47:40.346671
1159	CASE1764305260862	30	Telecaller	\N	2025-11-28 04:47:40.348683	2025-11-28 04:47:40.348683
1153	CASE1764244386142	37	KAM	\N	2025-11-27 11:53:07.157567	2025-11-29 06:11:49.912605
1150	CASE1764237341283	36	KAM	\N	2025-11-27 09:55:42.073277	2025-11-28 06:47:38.979209
2630	CASE1766473798208	31	Telecaller	\N	2025-12-23 07:10:08.05585	2025-12-23 07:10:08.05585
1165	CASE1764313285505	39	Operations	\N	2025-11-28 07:01:26.181184	2025-11-28 07:01:26.181184
1166	CASE1764313285505	33	Telecaller	\N	2025-11-28 07:01:26.183267	2025-11-28 07:01:26.183267
1259	CASE1764397890381	47	KAM	\N	2025-11-29 06:00:16.658729	2025-11-29 06:00:16.658729
1169	CASE1764315646071	34	KAM	\N	2025-11-28 07:40:47.015314	2025-11-28 07:40:47.015314
1170	CASE1764315646071	39	Operations	\N	2025-11-28 07:40:47.021278	2025-11-28 07:40:47.021278
1171	CASE1764315646071	29	Telecaller	\N	2025-11-28 07:40:47.023315	2025-11-28 07:40:47.023315
1172	CASE1764315650438	34	KAM	\N	2025-11-28 07:40:50.540308	2025-11-28 07:40:50.540308
1173	CASE1764315650438	39	Operations	\N	2025-11-28 07:40:50.545431	2025-11-28 07:40:50.545431
1174	CASE1764315650438	29	Telecaller	\N	2025-11-28 07:40:50.54737	2025-11-28 07:40:50.54737
1176	CASE1764320467400	39	Operations	\N	2025-11-28 09:01:08.437403	2025-11-28 09:01:08.437403
1177	CASE1764320467400	33	Telecaller	\N	2025-11-28 09:01:08.439365	2025-11-28 09:01:08.439365
1179	CASE1764322859980	39	Operations	\N	2025-11-28 09:40:58.104299	2025-11-28 09:40:58.104299
1180	CASE1764322859980	31	Telecaller	\N	2025-11-28 09:40:58.106614	2025-11-28 09:40:58.106614
1260	CASE1764397890381	39	Operations	\N	2025-11-29 06:00:16.664689	2025-11-29 06:00:16.664689
1183	CASE1764324178635	39	Operations	\N	2025-11-28 10:02:59.574899	2025-11-28 10:02:59.574899
1184	CASE1764324178635	30	Telecaller	\N	2025-11-28 10:02:59.576957	2025-11-28 10:02:59.576957
1261	CASE1764397890381	1	Telecaller	\N	2025-11-29 06:00:16.666834	2025-11-29 06:00:16.666834
1187	CASE1764324293934	39	Operations	\N	2025-11-28 10:04:54.862068	2025-11-28 10:04:54.862068
1188	CASE1764324293934	30	Telecaller	\N	2025-11-28 10:04:54.864174	2025-11-28 10:04:54.864174
535	CASE1762839307825	35	KAM	\N	2025-11-11 05:35:01.159674	2025-11-29 06:12:46.638129
1262	CASE1764398022989	47	KAM	\N	2025-11-29 06:02:29.253194	2025-11-29 06:02:29.253194
1192	CASE1761910111749	\N	Banker	\N	2025-11-28 11:04:58.083299	2025-11-28 11:04:58.089276
1195	CASE1764328583558	39	Operations	\N	2025-11-28 11:16:24.559519	2025-11-28 11:16:24.559519
1196	CASE1764328583558	32	Telecaller	\N	2025-11-28 11:16:24.561463	2025-11-28 11:16:24.561463
1342	CASE1764399261969	47	KAM	\N	2025-11-29 06:23:08.231101	2025-11-29 06:23:08.231101
1199	CASE1764328696142	39	Operations	\N	2025-11-28 11:18:17.127687	2025-11-28 11:18:17.127687
1200	CASE1764328696142	32	Telecaller	\N	2025-11-28 11:18:17.130129	2025-11-28 11:18:17.130129
1343	CASE1764399261969	39	Operations	\N	2025-11-29 06:23:08.237181	2025-11-29 06:23:08.237181
1202	CASE1762834354822	42	UW	\N	2025-11-28 12:12:40.639138	2025-11-28 12:12:40.639138
1205	CASE1762842917468	51	Banker	\N	2025-11-29 03:37:24.883912	2025-11-29 03:37:24.883912
1164	CASE1764313285505	37	KAM	\N	2025-11-28 07:01:26.175326	2025-11-29 04:56:07.819732
1175	CASE1764320467400	36	KAM	\N	2025-11-28 09:01:08.431187	2025-11-29 05:01:19.900086
1263	CASE1764398022989	39	Operations	\N	2025-11-29 06:02:29.258404	2025-11-29 06:02:29.258404
1147	CASE1764237339048	36	KAM	\N	2025-11-27 09:55:40.701783	2025-11-29 05:03:19.76785
1215	CASE1764393663992	34	KAM	\N	2025-11-29 05:21:05.108412	2025-11-29 05:21:05.108412
1216	CASE1764393663992	39	Operations	\N	2025-11-29 05:21:05.114326	2025-11-29 05:21:05.114326
1217	CASE1764393663992	29	Telecaller	\N	2025-11-29 05:21:05.116289	2025-11-29 05:21:05.116289
1218	CASE1764393725908	34	KAM	\N	2025-11-29 05:22:07.029463	2025-11-29 05:22:07.029463
1219	CASE1764393725908	39	Operations	\N	2025-11-29 05:22:07.035644	2025-11-29 05:22:07.035644
1220	CASE1764393725908	29	Telecaller	\N	2025-11-29 05:22:07.0377	2025-11-29 05:22:07.0377
1221	CASE1764393797557	35	KAM	\N	2025-11-29 05:23:18.651742	2025-11-29 05:23:18.651742
1222	CASE1764393797557	39	Operations	\N	2025-11-29 05:23:18.657542	2025-11-29 05:23:18.657542
1223	CASE1764393797557	29	Telecaller	\N	2025-11-29 05:23:18.659505	2025-11-29 05:23:18.659505
1226	CASE1764394837734	39	Operations	\N	2025-11-29 05:40:36.419329	2025-11-29 05:40:36.419329
1227	CASE1764394837734	30	Telecaller	\N	2025-11-29 05:40:36.421278	2025-11-29 05:40:36.421278
1225	CASE1764394837734	35	KAM	\N	2025-11-29 05:40:36.414091	2025-11-29 05:40:48.776968
1229	CASE1761910111749	42	UW	\N	2025-11-29 05:40:50.056929	2025-11-29 05:40:50.056929
1231	CASE1764396908165	47	KAM	\N	2025-11-29 05:43:54.435986	2025-11-29 05:43:54.435986
1232	CASE1764396908165	39	Operations	\N	2025-11-29 05:43:54.441175	2025-11-29 05:43:54.441175
1233	CASE1764396908165	1	Telecaller	\N	2025-11-29 05:43:54.443164	2025-11-29 05:43:54.443164
1234	CASE1764397172528	47	KAM	\N	2025-11-29 05:48:18.849839	2025-11-29 05:48:18.849839
1235	CASE1764397172528	39	Operations	\N	2025-11-29 05:48:18.855919	2025-11-29 05:48:18.855919
1236	CASE1764397172528	1	Telecaller	\N	2025-11-29 05:48:18.857912	2025-11-29 05:48:18.857912
1237	CASE1764397290284	47	KAM	\N	2025-11-29 05:50:16.578242	2025-11-29 05:50:16.578242
1238	CASE1764397290284	39	Operations	\N	2025-11-29 05:50:16.584491	2025-11-29 05:50:16.584491
1239	CASE1764397290284	1	Telecaller	\N	2025-11-29 05:50:16.58654	2025-11-29 05:50:16.58654
1157	CASE1764305260862	35	KAM	\N	2025-11-28 04:47:40.340675	2025-12-01 12:43:45.863981
1182	CASE1764324178635	35	KAM	\N	2025-11-28 10:02:59.568717	2025-11-29 05:52:00.69457
1249	CASE1764397510346	47	KAM	\N	2025-11-29 05:53:56.715917	2025-11-29 05:53:56.715917
1250	CASE1764397510346	39	Operations	\N	2025-11-29 05:53:56.721617	2025-11-29 05:53:56.721617
1251	CASE1764397510346	1	Telecaller	\N	2025-11-29 05:53:56.723562	2025-11-29 05:53:56.723562
1256	CASE1764397813628	47	KAM	\N	2025-11-29 05:59:00.018361	2025-11-29 05:59:00.018361
1257	CASE1764397813628	39	Operations	\N	2025-11-29 05:59:00.040559	2025-11-29 05:59:00.040559
1258	CASE1764397813628	1	Telecaller	\N	2025-11-29 05:59:00.049695	2025-11-29 05:59:00.049695
1264	CASE1764398022989	1	Telecaller	\N	2025-11-29 06:02:29.260627	2025-11-29 06:02:29.260627
1266	CASE1764398180082	47	KAM	\N	2025-11-29 06:05:06.330087	2025-11-29 06:05:06.330087
1267	CASE1764398180082	39	Operations	\N	2025-11-29 06:05:06.336684	2025-11-29 06:05:06.336684
1268	CASE1764398180082	1	Telecaller	\N	2025-11-29 06:05:06.338935	2025-11-29 06:05:06.338935
1271	CASE1764398305303	47	KAM	\N	2025-11-29 06:07:11.533028	2025-11-29 06:07:11.533028
1272	CASE1764398305303	39	Operations	\N	2025-11-29 06:07:11.538058	2025-11-29 06:07:11.538058
1273	CASE1764398305303	1	Telecaller	\N	2025-11-29 06:07:11.540028	2025-11-29 06:07:11.540028
1198	CASE1764328696142	37	KAM	\N	2025-11-28 11:18:17.120381	2025-11-29 06:08:12.739175
1186	CASE1764324293934	35	KAM	\N	2025-11-28 10:04:54.856246	2025-11-29 06:10:04.857622
1194	CASE1764328583558	36	KAM	\N	2025-11-28 11:16:24.553584	2025-11-29 06:10:09.112779
1280	CASE1764398494363	47	KAM	\N	2025-11-29 06:10:20.584038	2025-11-29 06:10:20.584038
1281	CASE1764398494363	39	Operations	\N	2025-11-29 06:10:20.589325	2025-11-29 06:10:20.589325
1282	CASE1764398494363	1	Telecaller	\N	2025-11-29 06:10:20.591295	2025-11-29 06:10:20.591295
1288	CASE1764398574617	47	KAM	\N	2025-11-29 06:11:40.862082	2025-11-29 06:11:40.862082
1289	CASE1764398574617	39	Operations	\N	2025-11-29 06:11:40.86756	2025-11-29 06:11:40.86756
1290	CASE1764398574617	1	Telecaller	\N	2025-11-29 06:11:40.869421	2025-11-29 06:11:40.869421
1344	CASE1764399261969	1	Telecaller	\N	2025-11-29 06:23:08.239189	2025-11-29 06:23:08.239189
1348	CASE1764399356040	47	KAM	\N	2025-11-29 06:24:42.206836	2025-11-29 06:24:42.206836
1349	CASE1764399356040	39	Operations	\N	2025-11-29 06:24:42.213349	2025-11-29 06:24:42.213349
1350	CASE1764399356040	1	Telecaller	\N	2025-11-29 06:24:42.216236	2025-11-29 06:24:42.216236
1352	CASE1764397511816	34	KAM	\N	2025-11-29 06:25:12.639706	2025-11-29 06:25:12.639706
1353	CASE1764397511816	39	Operations	\N	2025-11-29 06:25:12.64527	2025-11-29 06:25:12.64527
1354	CASE1764397511816	29	Telecaller	\N	2025-11-29 06:25:12.647217	2025-11-29 06:25:12.647217
1178	CASE1764322859980	36	KAM	\N	2025-11-28 09:40:58.097066	2025-11-29 13:16:52.40235
1361	CASE1764397582102	34	KAM	\N	2025-11-29 06:26:22.924478	2025-11-29 06:26:22.924478
1362	CASE1764397582102	39	Operations	\N	2025-11-29 06:26:22.929582	2025-11-29 06:26:22.929582
1363	CASE1764397582102	29	Telecaller	\N	2025-11-29 06:26:22.931738	2025-11-29 06:26:22.931738
1369	CASE1764399553000	47	KAM	\N	2025-11-29 06:27:59.186654	2025-11-29 06:27:59.186654
1370	CASE1764399553000	39	Operations	\N	2025-11-29 06:27:59.191462	2025-11-29 06:27:59.191462
1371	CASE1764399553000	1	Telecaller	\N	2025-11-29 06:27:59.193393	2025-11-29 06:27:59.193393
1375	CASE1764397707340	35	KAM	\N	2025-11-29 06:28:28.188677	2025-11-29 06:28:28.188677
1376	CASE1764397707340	39	Operations	\N	2025-11-29 06:28:28.194098	2025-11-29 06:28:28.194098
1377	CASE1764397707340	29	Telecaller	\N	2025-11-29 06:28:28.196068	2025-11-29 06:28:28.196068
1379	CASE1764399640887	47	KAM	\N	2025-11-29 06:29:27.059296	2025-11-29 06:29:27.059296
1380	CASE1764399640887	39	Operations	\N	2025-11-29 06:29:27.064957	2025-11-29 06:29:27.064957
1381	CASE1764399640887	1	Telecaller	\N	2025-11-29 06:29:27.06692	2025-11-29 06:29:27.06692
2625	CASE1766473725578	35	KAM	\N	2025-12-23 07:08:48.443622	2025-12-23 07:14:14.829766
1385	CASE1764397837815	35	KAM	\N	2025-11-29 06:30:38.644288	2025-11-29 06:30:38.644288
1386	CASE1764397837815	39	Operations	\N	2025-11-29 06:30:38.64994	2025-11-29 06:30:38.64994
1387	CASE1764397837815	29	Telecaller	\N	2025-11-29 06:30:38.651881	2025-11-29 06:30:38.651881
1388	CASE1764399719391	47	KAM	\N	2025-11-29 06:30:45.587899	2025-11-29 06:30:45.587899
1389	CASE1764399719391	39	Operations	\N	2025-11-29 06:30:45.592951	2025-11-29 06:30:45.592951
1390	CASE1764399719391	1	Telecaller	\N	2025-11-29 06:30:45.59498	2025-11-29 06:30:45.59498
1395	CASE1764399772011	47	KAM	\N	2025-11-29 06:31:37.605894	2025-11-29 06:31:37.605894
1396	CASE1764399772011	39	Operations	\N	2025-11-29 06:31:37.610716	2025-11-29 06:31:37.610716
1397	CASE1764399772011	1	Telecaller	\N	2025-11-29 06:31:37.612669	2025-11-29 06:31:37.612669
1398	CASE1764397899384	34	KAM	\N	2025-11-29 06:31:40.15987	2025-11-29 06:31:40.15987
1399	CASE1764397899384	39	Operations	\N	2025-11-29 06:31:40.165437	2025-11-29 06:31:40.165437
1400	CASE1764397899384	29	Telecaller	\N	2025-11-29 06:31:40.169064	2025-11-29 06:31:40.169064
1406	CASE1764397958287	34	KAM	\N	2025-11-29 06:32:39.139212	2025-11-29 06:32:39.139212
1407	CASE1764397958287	39	Operations	\N	2025-11-29 06:32:39.144416	2025-11-29 06:32:39.144416
1408	CASE1764397958287	29	Telecaller	\N	2025-11-29 06:32:39.146492	2025-11-29 06:32:39.146492
1413	CASE1764399864948	47	KAM	\N	2025-11-29 06:33:11.142071	2025-11-29 06:33:11.142071
1414	CASE1764399864948	39	Operations	\N	2025-11-29 06:33:11.148092	2025-11-29 06:33:11.148092
1415	CASE1764399864948	1	Telecaller	\N	2025-11-29 06:33:11.150462	2025-11-29 06:33:11.150462
1419	CASE1764398029125	34	KAM	\N	2025-11-29 06:33:49.902354	2025-11-29 06:33:49.902354
1420	CASE1764398029125	39	Operations	\N	2025-11-29 06:33:49.907541	2025-11-29 06:33:49.907541
1421	CASE1764398029125	29	Telecaller	\N	2025-11-29 06:33:49.909514	2025-11-29 06:33:49.909514
1425	CASE1764398094112	35	KAM	\N	2025-11-29 06:34:54.937829	2025-11-29 06:34:54.937829
1426	CASE1764398094112	39	Operations	\N	2025-11-29 06:34:54.943069	2025-11-29 06:34:54.943069
1427	CASE1764398094112	29	Telecaller	\N	2025-11-29 06:34:54.944976	2025-11-29 06:34:54.944976
1430	CASE1764398153114	35	KAM	\N	2025-11-29 06:35:53.630564	2025-11-29 06:35:53.630564
1431	CASE1764398153114	39	Operations	\N	2025-11-29 06:35:53.635871	2025-11-29 06:35:53.635871
1432	CASE1764398153114	29	Telecaller	\N	2025-11-29 06:35:53.637887	2025-11-29 06:35:53.637887
1436	CASE1764400133429	47	KAM	\N	2025-11-29 06:37:39.567789	2025-11-29 06:37:39.567789
1437	CASE1764400133429	39	Operations	\N	2025-11-29 06:37:39.572823	2025-11-29 06:37:39.572823
1438	CASE1764400133429	1	Telecaller	\N	2025-11-29 06:37:39.574785	2025-11-29 06:37:39.574785
1442	CASE1764398447312	34	KAM	\N	2025-11-29 06:40:48.098273	2025-11-29 06:40:48.098273
1443	CASE1764398447312	39	Operations	\N	2025-11-29 06:40:48.10666	2025-11-29 06:40:48.10666
1444	CASE1764398447312	29	Telecaller	\N	2025-11-29 06:40:48.108851	2025-11-29 06:40:48.108851
1445	CASE1764400345406	47	KAM	\N	2025-11-29 06:41:11.575264	2025-11-29 06:41:11.575264
1446	CASE1764400345406	39	Operations	\N	2025-11-29 06:41:11.581132	2025-11-29 06:41:11.581132
1447	CASE1764400345406	1	Telecaller	\N	2025-11-29 06:41:11.58316	2025-11-29 06:41:11.58316
1449	CASE1764398500046	34	KAM	\N	2025-11-29 06:41:40.569347	2025-11-29 06:41:40.569347
1450	CASE1764398500046	39	Operations	\N	2025-11-29 06:41:40.574424	2025-11-29 06:41:40.574424
1451	CASE1764398500046	29	Telecaller	\N	2025-11-29 06:41:40.576433	2025-11-29 06:41:40.576433
1454	CASE1764398580483	34	KAM	\N	2025-11-29 06:43:01.251033	2025-11-29 06:43:01.251033
1455	CASE1764398580483	39	Operations	\N	2025-11-29 06:43:01.256945	2025-11-29 06:43:01.256945
1456	CASE1764398580483	29	Telecaller	\N	2025-11-29 06:43:01.259102	2025-11-29 06:43:01.259102
1457	CASE1764400479563	47	KAM	\N	2025-11-29 06:43:25.719761	2025-11-29 06:43:25.719761
1458	CASE1764400479563	39	Operations	\N	2025-11-29 06:43:25.72569	2025-11-29 06:43:25.72569
1459	CASE1764400479563	1	Telecaller	\N	2025-11-29 06:43:25.727782	2025-11-29 06:43:25.727782
1461	CASE1764398641321	34	KAM	\N	2025-11-29 06:44:02.158786	2025-11-29 06:44:02.158786
1462	CASE1764398641321	39	Operations	\N	2025-11-29 06:44:02.164285	2025-11-29 06:44:02.164285
1463	CASE1764398641321	29	Telecaller	\N	2025-11-29 06:44:02.166307	2025-11-29 06:44:02.166307
1464	CASE1764400527166	47	KAM	\N	2025-11-29 06:44:13.265498	2025-11-29 06:44:13.265498
1465	CASE1764400527166	39	Operations	\N	2025-11-29 06:44:13.270573	2025-11-29 06:44:13.270573
1466	CASE1764400527166	1	Telecaller	\N	2025-11-29 06:44:13.272505	2025-11-29 06:44:13.272505
1468	CASE1764398702239	34	KAM	\N	2025-11-29 06:45:02.984083	2025-11-29 06:45:02.984083
1469	CASE1764398702239	39	Operations	\N	2025-11-29 06:45:02.989263	2025-11-29 06:45:02.989263
1470	CASE1764398702239	29	Telecaller	\N	2025-11-29 06:45:02.991247	2025-11-29 06:45:02.991247
1472	CASE1762842917468	35	KAM	\N	2025-11-29 06:45:07.106507	2025-11-29 06:45:07.106507
1473	CASE1764400588436	47	KAM	\N	2025-11-29 06:45:13.98812	2025-11-29 06:45:13.98812
1474	CASE1764400588436	39	Operations	\N	2025-11-29 06:45:13.993255	2025-11-29 06:45:13.993255
1475	CASE1764400588436	1	Telecaller	\N	2025-11-29 06:45:13.995294	2025-11-29 06:45:13.995294
1476	CASE1764400673424	47	KAM	\N	2025-11-29 06:46:39.574258	2025-11-29 06:46:39.574258
1477	CASE1764400673424	39	Operations	\N	2025-11-29 06:46:39.580053	2025-11-29 06:46:39.580053
1478	CASE1764400673424	1	Telecaller	\N	2025-11-29 06:46:39.582142	2025-11-29 06:46:39.582142
1479	CASE1764398843814	34	KAM	\N	2025-11-29 06:47:24.623828	2025-11-29 06:47:24.623828
1480	CASE1764398843814	39	Operations	\N	2025-11-29 06:47:24.629646	2025-11-29 06:47:24.629646
1481	CASE1764398843814	29	Telecaller	\N	2025-11-29 06:47:24.631703	2025-11-29 06:47:24.631703
1482	CASE1764398908649	34	KAM	\N	2025-11-29 06:48:29.40296	2025-11-29 06:48:29.40296
1483	CASE1764398908649	39	Operations	\N	2025-11-29 06:48:29.408588	2025-11-29 06:48:29.408588
1484	CASE1764398908649	29	Telecaller	\N	2025-11-29 06:48:29.410588	2025-11-29 06:48:29.410588
1486	CASE1764400823481	47	KAM	\N	2025-11-29 06:49:09.653105	2025-11-29 06:49:09.653105
1487	CASE1764400823481	39	Operations	\N	2025-11-29 06:49:09.658083	2025-11-29 06:49:09.658083
1488	CASE1764400823481	1	Telecaller	\N	2025-11-29 06:49:09.659986	2025-11-29 06:49:09.659986
1489	CASE1764400877417	47	KAM	\N	2025-11-29 06:50:03.280326	2025-11-29 06:50:03.280326
1490	CASE1764400877417	39	Operations	\N	2025-11-29 06:50:03.286331	2025-11-29 06:50:03.286331
1491	CASE1764400877417	1	Telecaller	\N	2025-11-29 06:50:03.288318	2025-11-29 06:50:03.288318
1492	CASE1764399019505	34	KAM	\N	2025-11-29 06:50:20.245409	2025-11-29 06:50:20.245409
1493	CASE1764399019505	39	Operations	\N	2025-11-29 06:50:20.250407	2025-11-29 06:50:20.250407
1494	CASE1764399019505	29	Telecaller	\N	2025-11-29 06:50:20.25244	2025-11-29 06:50:20.25244
1495	CASE1764399054691	34	KAM	\N	2025-11-29 06:50:55.405772	2025-11-29 06:50:55.405772
1496	CASE1764399054691	39	Operations	\N	2025-11-29 06:50:55.411689	2025-11-29 06:50:55.411689
1497	CASE1764399054691	29	Telecaller	\N	2025-11-29 06:50:55.413721	2025-11-29 06:50:55.413721
1498	CASE1764399031890	34	KAM	\N	2025-11-29 06:50:56.786832	2025-11-29 06:50:56.786832
1499	CASE1764399031890	39	Operations	\N	2025-11-29 06:50:56.792298	2025-11-29 06:50:56.792298
1500	CASE1764399031890	29	Telecaller	\N	2025-11-29 06:50:56.794337	2025-11-29 06:50:56.794337
1501	CASE1764399043290	34	KAM	\N	2025-11-29 06:50:57.800451	2025-11-29 06:50:57.800451
1502	CASE1764399043290	39	Operations	\N	2025-11-29 06:50:57.806116	2025-11-29 06:50:57.806116
1503	CASE1764399043290	29	Telecaller	\N	2025-11-29 06:50:57.808149	2025-11-29 06:50:57.808149
1504	CASE1764400962688	47	KAM	\N	2025-11-29 06:51:28.776684	2025-11-29 06:51:28.776684
1505	CASE1764400962688	39	Operations	\N	2025-11-29 06:51:28.781621	2025-11-29 06:51:28.781621
1506	CASE1764400962688	1	Telecaller	\N	2025-11-29 06:51:28.783624	2025-11-29 06:51:28.783624
1508	CASE1764401024408	47	KAM	\N	2025-11-29 06:52:30.498443	2025-11-29 06:52:30.498443
1509	CASE1764401024408	39	Operations	\N	2025-11-29 06:52:30.505745	2025-11-29 06:52:30.505745
1510	CASE1764401024408	1	Telecaller	\N	2025-11-29 06:52:30.509215	2025-11-29 06:52:30.509215
1511	CASE1764401080828	47	KAM	\N	2025-11-29 06:53:26.442392	2025-11-29 06:53:26.442392
1512	CASE1764401080828	39	Operations	\N	2025-11-29 06:53:26.447867	2025-11-29 06:53:26.447867
1513	CASE1764401080828	1	Telecaller	\N	2025-11-29 06:53:26.449793	2025-11-29 06:53:26.449793
1514	CASE1764401244052	47	KAM	\N	2025-11-29 06:56:10.101567	2025-11-29 06:56:10.101567
1515	CASE1764401244052	39	Operations	\N	2025-11-29 06:56:10.106924	2025-11-29 06:56:10.106924
1516	CASE1764401244052	1	Telecaller	\N	2025-11-29 06:56:10.108948	2025-11-29 06:56:10.108948
1517	CASE1764401292539	47	KAM	\N	2025-11-29 06:56:58.376736	2025-11-29 06:56:58.376736
1518	CASE1764401292539	39	Operations	\N	2025-11-29 06:56:58.382409	2025-11-29 06:56:58.382409
1519	CASE1764401292539	1	Telecaller	\N	2025-11-29 06:56:58.384409	2025-11-29 06:56:58.384409
1520	CASE1764399554188	34	KAM	\N	2025-11-29 06:59:15.16796	2025-11-29 06:59:15.16796
1521	CASE1764399554188	39	Operations	\N	2025-11-29 06:59:15.172954	2025-11-29 06:59:15.172954
1522	CASE1764399554188	29	Telecaller	\N	2025-11-29 06:59:15.174895	2025-11-29 06:59:15.174895
1523	CASE1764401456648	47	KAM	\N	2025-11-29 06:59:42.693662	2025-11-29 06:59:42.693662
1524	CASE1764401456648	39	Operations	\N	2025-11-29 06:59:42.698951	2025-11-29 06:59:42.698951
1525	CASE1764401456648	1	Telecaller	\N	2025-11-29 06:59:42.700946	2025-11-29 06:59:42.700946
1526	CASE1764401583687	47	KAM	\N	2025-11-29 07:01:49.785953	2025-11-29 07:01:49.785953
1527	CASE1764401583687	39	Operations	\N	2025-11-29 07:01:49.790873	2025-11-29 07:01:49.790873
1528	CASE1764401583687	1	Telecaller	\N	2025-11-29 07:01:49.792849	2025-11-29 07:01:49.792849
1529	CASE1764401671008	47	KAM	\N	2025-11-29 07:03:17.061352	2025-11-29 07:03:17.061352
1530	CASE1764401671008	39	Operations	\N	2025-11-29 07:03:17.06782	2025-11-29 07:03:17.06782
1531	CASE1764401671008	1	Telecaller	\N	2025-11-29 07:03:17.070158	2025-11-29 07:03:17.070158
1532	CASE1764401783731	47	KAM	\N	2025-11-29 07:05:09.784128	2025-11-29 07:05:09.784128
1533	CASE1764401783731	39	Operations	\N	2025-11-29 07:05:09.789408	2025-11-29 07:05:09.789408
1534	CASE1764401783731	1	Telecaller	\N	2025-11-29 07:05:09.791325	2025-11-29 07:05:09.791325
1535	CASE1764401841000	47	KAM	\N	2025-11-29 07:06:06.872889	2025-11-29 07:06:06.872889
1536	CASE1764401841000	39	Operations	\N	2025-11-29 07:06:06.878608	2025-11-29 07:06:06.878608
1537	CASE1764401841000	1	Telecaller	\N	2025-11-29 07:06:06.880498	2025-11-29 07:06:06.880498
1538	CASE1764402003625	47	KAM	\N	2025-11-29 07:08:49.769219	2025-11-29 07:08:49.769219
1539	CASE1764402003625	39	Operations	\N	2025-11-29 07:08:49.775067	2025-11-29 07:08:49.775067
1540	CASE1764402003625	1	Telecaller	\N	2025-11-29 07:08:49.777021	2025-11-29 07:08:49.777021
1541	CASE1764402245387	47	KAM	\N	2025-11-29 07:12:51.52347	2025-11-29 07:12:51.52347
1542	CASE1764402245387	39	Operations	\N	2025-11-29 07:12:51.529482	2025-11-29 07:12:51.529482
1543	CASE1764402245387	1	Telecaller	\N	2025-11-29 07:12:51.531693	2025-11-29 07:12:51.531693
1544	CASE1764400464450	34	KAM	\N	2025-11-29 07:14:25.424526	2025-11-29 07:14:25.424526
1545	CASE1764400464450	39	Operations	\N	2025-11-29 07:14:25.430037	2025-11-29 07:14:25.430037
1546	CASE1764400464450	29	Telecaller	\N	2025-11-29 07:14:25.432008	2025-11-29 07:14:25.432008
1547	CASE1764400621134	34	KAM	\N	2025-11-29 07:17:04.117119	2025-11-29 07:17:04.117119
1548	CASE1764400621134	39	Operations	\N	2025-11-29 07:17:04.123191	2025-11-29 07:17:04.123191
1549	CASE1764400621134	29	Telecaller	\N	2025-11-29 07:17:04.125347	2025-11-29 07:17:04.125347
2633	CASE1766482276572	39	Operations	\N	2025-12-23 09:31:28.589637	2025-12-23 09:31:28.589637
2634	CASE1766482276572	32	Telecaller	\N	2025-12-23 09:31:28.591847	2025-12-23 09:31:28.591847
1553	CASE1764402574087	47	KAM	\N	2025-11-29 07:18:20.135425	2025-11-29 07:18:20.135425
1554	CASE1764402574087	39	Operations	\N	2025-11-29 07:18:20.141009	2025-11-29 07:18:20.141009
1555	CASE1764402574087	1	Telecaller	\N	2025-11-29 07:18:20.14299	2025-11-29 07:18:20.14299
1557	CASE1764400707502	39	Operations	\N	2025-11-29 07:18:28.401849	2025-11-29 07:18:28.401849
1558	CASE1764400707502	29	Telecaller	\N	2025-11-29 07:18:28.40385	2025-11-29 07:18:28.40385
1556	CASE1764400707502	34	KAM	\N	2025-11-29 07:18:28.397192	2025-11-29 07:19:10.623181
1560	CASE1764402666075	47	KAM	\N	2025-11-29 07:19:52.111893	2025-11-29 07:19:52.111893
1561	CASE1764402666075	39	Operations	\N	2025-11-29 07:19:52.117529	2025-11-29 07:19:52.117529
1562	CASE1764402666075	1	Telecaller	\N	2025-11-29 07:19:52.119603	2025-11-29 07:19:52.119603
1563	CASE1764402752496	47	KAM	\N	2025-11-29 07:21:18.499466	2025-11-29 07:21:18.499466
1564	CASE1764402752496	39	Operations	\N	2025-11-29 07:21:18.505487	2025-11-29 07:21:18.505487
1565	CASE1764402752496	1	Telecaller	\N	2025-11-29 07:21:18.50751	2025-11-29 07:21:18.50751
2632	CASE1766482276572	37	KAM	\N	2025-12-23 09:31:28.582419	2025-12-23 09:34:00.828403
2647	CASE1766565547307	39	Operations	\N	2025-12-24 08:39:06.474049	2025-12-24 08:39:06.474049
1569	CASE1764400948936	34	KAM	\N	2025-11-29 07:22:29.845481	2025-11-29 07:22:29.845481
1570	CASE1764400948936	39	Operations	\N	2025-11-29 07:22:29.850618	2025-11-29 07:22:29.850618
1571	CASE1764400948936	29	Telecaller	\N	2025-11-29 07:22:29.852642	2025-11-29 07:22:29.852642
1572	CASE1764400993387	34	KAM	\N	2025-11-29 07:23:14.049713	2025-11-29 07:23:14.049713
1573	CASE1764400993387	39	Operations	\N	2025-11-29 07:23:14.055843	2025-11-29 07:23:14.055843
1574	CASE1764400993387	29	Telecaller	\N	2025-11-29 07:23:14.057888	2025-11-29 07:23:14.057888
1575	CASE1764402879354	47	KAM	\N	2025-11-29 07:23:25.352004	2025-11-29 07:23:25.352004
1576	CASE1764402879354	39	Operations	\N	2025-11-29 07:23:25.357014	2025-11-29 07:23:25.357014
1577	CASE1764402879354	1	Telecaller	\N	2025-11-29 07:23:25.359021	2025-11-29 07:23:25.359021
1578	CASE1764401064872	34	KAM	\N	2025-11-29 07:24:25.803941	2025-11-29 07:24:25.803941
1579	CASE1764401064872	39	Operations	\N	2025-11-29 07:24:25.80979	2025-11-29 07:24:25.80979
1580	CASE1764401064872	29	Telecaller	\N	2025-11-29 07:24:25.811856	2025-11-29 07:24:25.811856
1581	CASE1764401143706	34	KAM	\N	2025-11-29 07:25:44.649551	2025-11-29 07:25:44.649551
1582	CASE1764401143706	39	Operations	\N	2025-11-29 07:25:44.655257	2025-11-29 07:25:44.655257
1583	CASE1764401143706	29	Telecaller	\N	2025-11-29 07:25:44.657259	2025-11-29 07:25:44.657259
1584	CASE1764403066579	47	KAM	\N	2025-11-29 07:26:32.676358	2025-11-29 07:26:32.676358
1585	CASE1764403066579	39	Operations	\N	2025-11-29 07:26:32.682073	2025-11-29 07:26:32.682073
1586	CASE1764403066579	1	Telecaller	\N	2025-11-29 07:26:32.683997	2025-11-29 07:26:32.683997
1587	CASE1764403113981	47	KAM	\N	2025-11-29 07:27:19.706796	2025-11-29 07:27:19.706796
1588	CASE1764403113981	39	Operations	\N	2025-11-29 07:27:19.712287	2025-11-29 07:27:19.712287
1589	CASE1764403113981	1	Telecaller	\N	2025-11-29 07:27:19.714158	2025-11-29 07:27:19.714158
1590	CASE1764401238989	34	KAM	\N	2025-11-29 07:27:19.894929	2025-11-29 07:27:19.894929
1591	CASE1764401238989	39	Operations	\N	2025-11-29 07:27:19.900377	2025-11-29 07:27:19.900377
1592	CASE1764401238989	29	Telecaller	\N	2025-11-29 07:27:19.902321	2025-11-29 07:27:19.902321
1593	CASE1764401308743	34	KAM	\N	2025-11-29 07:28:34.658334	2025-11-29 07:28:34.658334
1594	CASE1764401308743	39	Operations	\N	2025-11-29 07:28:34.66387	2025-11-29 07:28:34.66387
1595	CASE1764401308743	29	Telecaller	\N	2025-11-29 07:28:34.665893	2025-11-29 07:28:34.665893
1596	CASE1764403325160	47	KAM	\N	2025-11-29 07:30:51.161899	2025-11-29 07:30:51.161899
1597	CASE1764403325160	39	Operations	\N	2025-11-29 07:30:51.168444	2025-11-29 07:30:51.168444
1598	CASE1764403325160	1	Telecaller	\N	2025-11-29 07:30:51.170627	2025-11-29 07:30:51.170627
1599	CASE1764403404546	47	KAM	\N	2025-11-29 07:32:10.539248	2025-11-29 07:32:10.539248
1600	CASE1764403404546	39	Operations	\N	2025-11-29 07:32:10.544825	2025-11-29 07:32:10.544825
1601	CASE1764403404546	1	Telecaller	\N	2025-11-29 07:32:10.546799	2025-11-29 07:32:10.546799
1602	CASE1764401564061	34	KAM	\N	2025-11-29 07:32:44.997042	2025-11-29 07:32:44.997042
1603	CASE1764401564061	39	Operations	\N	2025-11-29 07:32:45.008341	2025-11-29 07:32:45.008341
1604	CASE1764401564061	29	Telecaller	\N	2025-11-29 07:32:45.020469	2025-11-29 07:32:45.020469
1605	CASE1764403476101	47	KAM	\N	2025-11-29 07:33:22.181057	2025-11-29 07:33:22.181057
1606	CASE1764403476101	39	Operations	\N	2025-11-29 07:33:22.186775	2025-11-29 07:33:22.186775
1607	CASE1764403476101	1	Telecaller	\N	2025-11-29 07:33:22.188683	2025-11-29 07:33:22.188683
2648	CASE1766565547307	30	Telecaller	\N	2025-12-24 08:39:06.476095	2025-12-24 08:39:06.476095
2656	CASE1766574714586	39	Operations	\N	2025-12-24 11:11:55.276474	2025-12-24 11:11:55.276474
1608	CASE1764401619661	34	KAM	\N	2025-11-29 07:33:40.334773	2025-11-29 07:33:40.334773
1609	CASE1764401619661	39	Operations	\N	2025-11-29 07:33:40.341476	2025-11-29 07:33:40.341476
1610	CASE1764401619661	29	Telecaller	\N	2025-11-29 07:33:40.343748	2025-11-29 07:33:40.343748
1611	CASE1764403540104	47	KAM	\N	2025-11-29 07:34:26.176324	2025-11-29 07:34:26.176324
1612	CASE1764403540104	39	Operations	\N	2025-11-29 07:34:26.182443	2025-11-29 07:34:26.182443
1613	CASE1764403540104	1	Telecaller	\N	2025-11-29 07:34:26.184696	2025-11-29 07:34:26.184696
1614	CASE1764401687030	34	KAM	\N	2025-11-29 07:34:47.993533	2025-11-29 07:34:47.993533
1615	CASE1764401687030	39	Operations	\N	2025-11-29 07:34:47.999883	2025-11-29 07:34:47.999883
1616	CASE1764401687030	29	Telecaller	\N	2025-11-29 07:34:48.00351	2025-11-29 07:34:48.00351
1617	CASE1764403601606	47	KAM	\N	2025-11-29 07:35:27.599113	2025-11-29 07:35:27.599113
1618	CASE1764403601606	39	Operations	\N	2025-11-29 07:35:27.604931	2025-11-29 07:35:27.604931
1619	CASE1764403601606	1	Telecaller	\N	2025-11-29 07:35:27.606919	2025-11-29 07:35:27.606919
1620	CASE1764403660876	47	KAM	\N	2025-11-29 07:36:26.585762	2025-11-29 07:36:26.585762
1621	CASE1764403660876	39	Operations	\N	2025-11-29 07:36:26.591681	2025-11-29 07:36:26.591681
1622	CASE1764403660876	1	Telecaller	\N	2025-11-29 07:36:26.59376	2025-11-29 07:36:26.59376
1623	CASE1764403718264	47	KAM	\N	2025-11-29 07:37:24.268906	2025-11-29 07:37:24.268906
1624	CASE1764403718264	39	Operations	\N	2025-11-29 07:37:24.274459	2025-11-29 07:37:24.274459
1625	CASE1764403718264	1	Telecaller	\N	2025-11-29 07:37:24.276387	2025-11-29 07:37:24.276387
1626	CASE1764401868147	34	KAM	\N	2025-11-29 07:37:49.50205	2025-11-29 07:37:49.50205
1627	CASE1764401868147	39	Operations	\N	2025-11-29 07:37:49.507859	2025-11-29 07:37:49.507859
1628	CASE1764401868147	29	Telecaller	\N	2025-11-29 07:37:49.509839	2025-11-29 07:37:49.509839
1629	CASE1764403758015	47	KAM	\N	2025-11-29 07:38:03.692683	2025-11-29 07:38:03.692683
1630	CASE1764403758015	39	Operations	\N	2025-11-29 07:38:03.69768	2025-11-29 07:38:03.69768
1631	CASE1764403758015	1	Telecaller	\N	2025-11-29 07:38:03.699779	2025-11-29 07:38:03.699779
1632	CASE1764401953363	34	KAM	\N	2025-11-29 07:39:14.280609	2025-11-29 07:39:14.280609
1633	CASE1764401953363	39	Operations	\N	2025-11-29 07:39:14.285711	2025-11-29 07:39:14.285711
1634	CASE1764401953363	29	Telecaller	\N	2025-11-29 07:39:14.287827	2025-11-29 07:39:14.287827
1635	CASE1764403830668	47	KAM	\N	2025-11-29 07:39:16.621646	2025-11-29 07:39:16.621646
1636	CASE1764403830668	39	Operations	\N	2025-11-29 07:39:16.62717	2025-11-29 07:39:16.62717
1637	CASE1764403830668	1	Telecaller	\N	2025-11-29 07:39:16.629072	2025-11-29 07:39:16.629072
1638	CASE1764402001664	34	KAM	\N	2025-11-29 07:40:02.398494	2025-11-29 07:40:02.398494
1639	CASE1764402001664	39	Operations	\N	2025-11-29 07:40:02.404462	2025-11-29 07:40:02.404462
1640	CASE1764402001664	29	Telecaller	\N	2025-11-29 07:40:02.406455	2025-11-29 07:40:02.406455
1641	CASE1764403879721	47	KAM	\N	2025-11-29 07:40:05.464729	2025-11-29 07:40:05.464729
1642	CASE1764403879721	39	Operations	\N	2025-11-29 07:40:05.470557	2025-11-29 07:40:05.470557
1643	CASE1764403879721	1	Telecaller	\N	2025-11-29 07:40:05.47266	2025-11-29 07:40:05.47266
1644	CASE1764403884306	47	KAM	\N	2025-11-29 07:40:09.686111	2025-11-29 07:40:09.686111
1645	CASE1764403884306	39	Operations	\N	2025-11-29 07:40:09.691174	2025-11-29 07:40:09.691174
1646	CASE1764403884306	1	Telecaller	\N	2025-11-29 07:40:09.693192	2025-11-29 07:40:09.693192
1647	CASE1764402044696	34	KAM	\N	2025-11-29 07:40:45.678614	2025-11-29 07:40:45.678614
1648	CASE1764402044696	39	Operations	\N	2025-11-29 07:40:45.68441	2025-11-29 07:40:45.68441
1649	CASE1764402044696	29	Telecaller	\N	2025-11-29 07:40:45.686425	2025-11-29 07:40:45.686425
1650	CASE1764403925856	47	KAM	\N	2025-11-29 07:40:52.113745	2025-11-29 07:40:52.113745
1651	CASE1764403925856	39	Operations	\N	2025-11-29 07:40:52.119059	2025-11-29 07:40:52.119059
1652	CASE1764403925856	1	Telecaller	\N	2025-11-29 07:40:52.121645	2025-11-29 07:40:52.121645
1653	CASE1764403993876	47	KAM	\N	2025-11-29 07:41:59.840009	2025-11-29 07:41:59.840009
1654	CASE1764403993876	39	Operations	\N	2025-11-29 07:41:59.845899	2025-11-29 07:41:59.845899
1655	CASE1764403993876	1	Telecaller	\N	2025-11-29 07:41:59.847968	2025-11-29 07:41:59.847968
1656	CASE1764404074214	47	KAM	\N	2025-11-29 07:43:20.186313	2025-11-29 07:43:20.186313
1657	CASE1764404074214	39	Operations	\N	2025-11-29 07:43:20.19215	2025-11-29 07:43:20.19215
1658	CASE1764404074214	1	Telecaller	\N	2025-11-29 07:43:20.194113	2025-11-29 07:43:20.194113
1659	CASE1764402218280	34	KAM	\N	2025-11-29 07:43:39.237984	2025-11-29 07:43:39.237984
1660	CASE1764402218280	39	Operations	\N	2025-11-29 07:43:39.244223	2025-11-29 07:43:39.244223
1661	CASE1764402218280	29	Telecaller	\N	2025-11-29 07:43:39.246327	2025-11-29 07:43:39.246327
1662	CASE1764402288049	34	KAM	\N	2025-11-29 07:44:48.960341	2025-11-29 07:44:48.960341
1663	CASE1764402288049	39	Operations	\N	2025-11-29 07:44:48.966212	2025-11-29 07:44:48.966212
1664	CASE1764402288049	29	Telecaller	\N	2025-11-29 07:44:48.968164	2025-11-29 07:44:48.968164
1665	CASE1764404174002	47	KAM	\N	2025-11-29 07:44:59.997524	2025-11-29 07:44:59.997524
1666	CASE1764404174002	39	Operations	\N	2025-11-29 07:45:00.091574	2025-11-29 07:45:00.091574
1667	CASE1764404174002	1	Telecaller	\N	2025-11-29 07:45:00.140371	2025-11-29 07:45:00.140371
1668	CASE1764404230572	47	KAM	\N	2025-11-29 07:45:56.525654	2025-11-29 07:45:56.525654
1669	CASE1764404230572	39	Operations	\N	2025-11-29 07:45:56.531286	2025-11-29 07:45:56.531286
1670	CASE1764404230572	1	Telecaller	\N	2025-11-29 07:45:56.533296	2025-11-29 07:45:56.533296
1671	CASE1764402358583	34	KAM	\N	2025-11-29 07:45:59.521421	2025-11-29 07:45:59.521421
1672	CASE1764402358583	39	Operations	\N	2025-11-29 07:45:59.526189	2025-11-29 07:45:59.526189
1673	CASE1764402358583	29	Telecaller	\N	2025-11-29 07:45:59.528079	2025-11-29 07:45:59.528079
1674	CASE1764404297259	47	KAM	\N	2025-11-29 07:47:03.226267	2025-11-29 07:47:03.226267
1675	CASE1764404297259	39	Operations	\N	2025-11-29 07:47:03.231963	2025-11-29 07:47:03.231963
1676	CASE1764404297259	1	Telecaller	\N	2025-11-29 07:47:03.233958	2025-11-29 07:47:03.233958
1677	CASE1764404355328	47	KAM	\N	2025-11-29 07:48:01.037251	2025-11-29 07:48:01.037251
1678	CASE1764404355328	39	Operations	\N	2025-11-29 07:48:01.043812	2025-11-29 07:48:01.043812
1679	CASE1764404355328	1	Telecaller	\N	2025-11-29 07:48:01.045949	2025-11-29 07:48:01.045949
1680	CASE1764402474550	34	KAM	\N	2025-11-29 07:48:06.227801	2025-11-29 07:48:06.227801
1681	CASE1764402474550	39	Operations	\N	2025-11-29 07:48:06.232785	2025-11-29 07:48:06.232785
1682	CASE1764402474550	29	Telecaller	\N	2025-11-29 07:48:06.235096	2025-11-29 07:48:06.235096
1683	CASE1764404413398	47	KAM	\N	2025-11-29 07:48:59.138679	2025-11-29 07:48:59.138679
1684	CASE1764404413398	39	Operations	\N	2025-11-29 07:48:59.144241	2025-11-29 07:48:59.144241
1685	CASE1764404413398	1	Telecaller	\N	2025-11-29 07:48:59.146241	2025-11-29 07:48:59.146241
1686	CASE1764402574717	34	KAM	\N	2025-11-29 07:49:35.32697	2025-11-29 07:49:35.32697
1687	CASE1764402574717	39	Operations	\N	2025-11-29 07:49:35.333015	2025-11-29 07:49:35.333015
1688	CASE1764402574717	29	Telecaller	\N	2025-11-29 07:49:35.335111	2025-11-29 07:49:35.335111
1689	CASE1764404483701	47	KAM	\N	2025-11-29 07:50:09.356706	2025-11-29 07:50:09.356706
1690	CASE1764404483701	39	Operations	\N	2025-11-29 07:50:09.362734	2025-11-29 07:50:09.362734
1691	CASE1764404483701	1	Telecaller	\N	2025-11-29 07:50:09.364805	2025-11-29 07:50:09.364805
1692	CASE1764402607785	34	KAM	\N	2025-11-29 07:50:43.420469	2025-11-29 07:50:43.420469
1693	CASE1764402607785	39	Operations	\N	2025-11-29 07:50:43.42677	2025-11-29 07:50:43.42677
1694	CASE1764402607785	29	Telecaller	\N	2025-11-29 07:50:43.428873	2025-11-29 07:50:43.428873
1695	CASE1764404561455	47	KAM	\N	2025-11-29 07:51:27.101765	2025-11-29 07:51:27.101765
1696	CASE1764404561455	39	Operations	\N	2025-11-29 07:51:27.107557	2025-11-29 07:51:27.107557
1697	CASE1764404561455	1	Telecaller	\N	2025-11-29 07:51:27.109742	2025-11-29 07:51:27.109742
1698	CASE1764402687733	34	KAM	\N	2025-11-29 07:51:28.177465	2025-11-29 07:51:28.177465
1699	CASE1764402687733	39	Operations	\N	2025-11-29 07:51:28.183022	2025-11-29 07:51:28.183022
1700	CASE1764402687733	29	Telecaller	\N	2025-11-29 07:51:28.185314	2025-11-29 07:51:28.185314
1701	CASE1764402789600	34	KAM	\N	2025-11-29 07:53:10.529452	2025-11-29 07:53:10.529452
1702	CASE1764402789600	39	Operations	\N	2025-11-29 07:53:10.535278	2025-11-29 07:53:10.535278
1703	CASE1764402789600	29	Telecaller	\N	2025-11-29 07:53:10.537273	2025-11-29 07:53:10.537273
1704	CASE1764402887918	34	KAM	\N	2025-11-29 07:54:48.820284	2025-11-29 07:54:48.820284
1705	CASE1764402887918	39	Operations	\N	2025-11-29 07:54:48.826327	2025-11-29 07:54:48.826327
1706	CASE1764402887918	29	Telecaller	\N	2025-11-29 07:54:48.828299	2025-11-29 07:54:48.828299
1707	CASE1764402966570	34	KAM	\N	2025-11-29 07:56:07.485939	2025-11-29 07:56:07.485939
1708	CASE1764402966570	39	Operations	\N	2025-11-29 07:56:07.492144	2025-11-29 07:56:07.492144
1709	CASE1764402966570	29	Telecaller	\N	2025-11-29 07:56:07.494873	2025-11-29 07:56:07.494873
1710	CASE1764403012771	34	KAM	\N	2025-11-29 07:56:53.505081	2025-11-29 07:56:53.505081
1711	CASE1764403012771	39	Operations	\N	2025-11-29 07:56:53.510943	2025-11-29 07:56:53.510943
1712	CASE1764403012771	29	Telecaller	\N	2025-11-29 07:56:53.512936	2025-11-29 07:56:53.512936
1713	CASE1764403067551	34	KAM	\N	2025-11-29 07:57:48.552882	2025-11-29 07:57:48.552882
1714	CASE1764403067551	39	Operations	\N	2025-11-29 07:57:48.558537	2025-11-29 07:57:48.558537
1715	CASE1764403067551	29	Telecaller	\N	2025-11-29 07:57:48.560471	2025-11-29 07:57:48.560471
1716	CASE1764403114252	34	KAM	\N	2025-11-29 07:58:34.979967	2025-11-29 07:58:34.979967
1717	CASE1764403114252	39	Operations	\N	2025-11-29 07:58:34.986043	2025-11-29 07:58:34.986043
1718	CASE1764403114252	29	Telecaller	\N	2025-11-29 07:58:34.988076	2025-11-29 07:58:34.988076
1719	CASE1764403219320	34	KAM	\N	2025-11-29 08:00:20.248096	2025-11-29 08:00:20.248096
1720	CASE1764403219320	39	Operations	\N	2025-11-29 08:00:20.25405	2025-11-29 08:00:20.25405
1721	CASE1764403219320	29	Telecaller	\N	2025-11-29 08:00:20.256129	2025-11-29 08:00:20.256129
1722	CASE1764405101400	47	KAM	\N	2025-11-29 08:00:27.268227	2025-11-29 08:00:27.268227
1723	CASE1764405101400	39	Operations	\N	2025-11-29 08:00:27.273408	2025-11-29 08:00:27.273408
1724	CASE1764405101400	1	Telecaller	\N	2025-11-29 08:00:27.27545	2025-11-29 08:00:27.27545
1725	CASE1764405153656	47	KAM	\N	2025-11-29 08:01:19.328664	2025-11-29 08:01:19.328664
1726	CASE1764405153656	39	Operations	\N	2025-11-29 08:01:19.334466	2025-11-29 08:01:19.334466
1727	CASE1764405153656	1	Telecaller	\N	2025-11-29 08:01:19.336469	2025-11-29 08:01:19.336469
1728	CASE1764405311977	47	KAM	\N	2025-11-29 08:03:57.888304	2025-11-29 08:03:57.888304
1729	CASE1764405311977	39	Operations	\N	2025-11-29 08:03:57.894247	2025-11-29 08:03:57.894247
1730	CASE1764405311977	1	Telecaller	\N	2025-11-29 08:03:57.896246	2025-11-29 08:03:57.896246
1731	CASE1764403446118	34	KAM	\N	2025-11-29 08:04:06.977325	2025-11-29 08:04:06.977325
1732	CASE1764403446118	39	Operations	\N	2025-11-29 08:04:06.982401	2025-11-29 08:04:06.982401
1733	CASE1764403446118	29	Telecaller	\N	2025-11-29 08:04:06.98437	2025-11-29 08:04:06.98437
1734	CASE1764403492004	34	KAM	\N	2025-11-29 08:04:52.704428	2025-11-29 08:04:52.704428
1735	CASE1764403492004	39	Operations	\N	2025-11-29 08:04:52.709715	2025-11-29 08:04:52.709715
1736	CASE1764403492004	29	Telecaller	\N	2025-11-29 08:04:52.711701	2025-11-29 08:04:52.711701
1737	CASE1764405423550	47	KAM	\N	2025-11-29 08:05:49.537408	2025-11-29 08:05:49.537408
1738	CASE1764405423550	39	Operations	\N	2025-11-29 08:05:49.543052	2025-11-29 08:05:49.543052
1739	CASE1764405423550	1	Telecaller	\N	2025-11-29 08:05:49.544885	2025-11-29 08:05:49.544885
1740	CASE1764403715806	34	KAM	\N	2025-11-29 08:08:36.741018	2025-11-29 08:08:36.741018
1741	CASE1764403715806	39	Operations	\N	2025-11-29 08:08:36.746677	2025-11-29 08:08:36.746677
1742	CASE1764403715806	29	Telecaller	\N	2025-11-29 08:08:36.748688	2025-11-29 08:08:36.748688
1743	CASE1764405630877	47	KAM	\N	2025-11-29 08:09:16.784158	2025-11-29 08:09:16.784158
1744	CASE1764405630877	39	Operations	\N	2025-11-29 08:09:16.789903	2025-11-29 08:09:16.789903
1745	CASE1764405630877	1	Telecaller	\N	2025-11-29 08:09:16.791779	2025-11-29 08:09:16.791779
1746	CASE1764403803238	34	KAM	\N	2025-11-29 08:10:04.157482	2025-11-29 08:10:04.157482
1747	CASE1764403803238	39	Operations	\N	2025-11-29 08:10:04.163576	2025-11-29 08:10:04.163576
1748	CASE1764403803238	29	Telecaller	\N	2025-11-29 08:10:04.165609	2025-11-29 08:10:04.165609
1749	CASE1764405764801	47	KAM	\N	2025-11-29 08:11:30.783976	2025-11-29 08:11:30.783976
1750	CASE1764405764801	39	Operations	\N	2025-11-29 08:11:30.78969	2025-11-29 08:11:30.78969
1751	CASE1764405764801	1	Telecaller	\N	2025-11-29 08:11:30.79167	2025-11-29 08:11:30.79167
1752	CASE1764403929506	34	KAM	\N	2025-11-29 08:12:10.470683	2025-11-29 08:12:10.470683
1753	CASE1764403929506	39	Operations	\N	2025-11-29 08:12:10.476561	2025-11-29 08:12:10.476561
1754	CASE1764403929506	29	Telecaller	\N	2025-11-29 08:12:10.478798	2025-11-29 08:12:10.478798
1755	CASE1764404023674	34	KAM	\N	2025-11-29 08:13:44.60597	2025-11-29 08:13:44.60597
1756	CASE1764404023674	39	Operations	\N	2025-11-29 08:13:44.611687	2025-11-29 08:13:44.611687
1757	CASE1764404023674	29	Telecaller	\N	2025-11-29 08:13:44.613594	2025-11-29 08:13:44.613594
1758	CASE1764406031731	47	KAM	\N	2025-11-29 08:15:57.596016	2025-11-29 08:15:57.596016
1759	CASE1764406031731	39	Operations	\N	2025-11-29 08:15:57.601925	2025-11-29 08:15:57.601925
1760	CASE1764406031731	1	Telecaller	\N	2025-11-29 08:15:57.603908	2025-11-29 08:15:57.603908
1761	CASE1764404171475	34	KAM	\N	2025-11-29 08:16:12.400559	2025-11-29 08:16:12.400559
1762	CASE1764404171475	39	Operations	\N	2025-11-29 08:16:12.405563	2025-11-29 08:16:12.405563
1763	CASE1764404171475	29	Telecaller	\N	2025-11-29 08:16:12.407467	2025-11-29 08:16:12.407467
1764	CASE1764420111611	47	KAM	\N	2025-11-29 12:10:36.861502	2025-11-29 12:10:36.861502
1765	CASE1764420111611	39	Operations	\N	2025-11-29 12:10:36.867449	2025-11-29 12:10:36.867449
1766	CASE1764420111611	1	Telecaller	\N	2025-11-29 12:10:36.869668	2025-11-29 12:10:36.869668
1767	CASE1764420194165	47	KAM	\N	2025-11-29 12:11:59.343757	2025-11-29 12:11:59.343757
1768	CASE1764420194165	39	Operations	\N	2025-11-29 12:11:59.349959	2025-11-29 12:11:59.349959
1769	CASE1764420194165	1	Telecaller	\N	2025-11-29 12:11:59.352047	2025-11-29 12:11:59.352047
1770	CASE1764418327230	34	KAM	\N	2025-11-29 12:12:08.137965	2025-11-29 12:12:08.137965
1771	CASE1764418327230	39	Operations	\N	2025-11-29 12:12:08.143085	2025-11-29 12:12:08.143085
1772	CASE1764418327230	29	Telecaller	\N	2025-11-29 12:12:08.144959	2025-11-29 12:12:08.144959
1773	CASE1764418481981	34	KAM	\N	2025-11-29 12:14:42.944743	2025-11-29 12:14:42.944743
1774	CASE1764418481981	39	Operations	\N	2025-11-29 12:14:42.951153	2025-11-29 12:14:42.951153
1775	CASE1764418481981	29	Telecaller	\N	2025-11-29 12:14:42.953409	2025-11-29 12:14:42.953409
1776	CASE1764418541962	34	KAM	\N	2025-11-29 12:15:42.668056	2025-11-29 12:15:42.668056
1777	CASE1764418541962	39	Operations	\N	2025-11-29 12:15:42.673888	2025-11-29 12:15:42.673888
1778	CASE1764418541962	29	Telecaller	\N	2025-11-29 12:15:42.675962	2025-11-29 12:15:42.675962
1780	CASE1764418550347	39	Operations	\N	2025-11-29 12:15:51.323334	2025-11-29 12:15:51.323334
1781	CASE1764418550347	30	Telecaller	\N	2025-11-29 12:15:51.325347	2025-11-29 12:15:51.325347
1779	CASE1764418550347	35	KAM	\N	2025-11-29 12:15:51.318107	2025-11-29 12:16:05.305379
1783	CASE1764418618914	34	KAM	\N	2025-11-29 12:16:59.953166	2025-11-29 12:16:59.953166
1784	CASE1764418618914	39	Operations	\N	2025-11-29 12:16:59.958933	2025-11-29 12:16:59.958933
1785	CASE1764418618914	29	Telecaller	\N	2025-11-29 12:16:59.96099	2025-11-29 12:16:59.96099
1786	CASE1764420648439	47	KAM	\N	2025-11-29 12:19:33.522026	2025-11-29 12:19:33.522026
1787	CASE1764420648439	39	Operations	\N	2025-11-29 12:19:33.527562	2025-11-29 12:19:33.527562
1788	CASE1764420648439	1	Telecaller	\N	2025-11-29 12:19:33.529612	2025-11-29 12:19:33.529612
1789	CASE1764420654423	47	KAM	\N	2025-11-29 12:19:38.983357	2025-11-29 12:19:38.983357
1790	CASE1764420654423	39	Operations	\N	2025-11-29 12:19:38.988793	2025-11-29 12:19:38.988793
1791	CASE1764420654423	1	Telecaller	\N	2025-11-29 12:19:38.990749	2025-11-29 12:19:38.990749
1792	CASE1764418867359	34	KAM	\N	2025-11-29 12:21:08.390565	2025-11-29 12:21:08.390565
1793	CASE1764418867359	39	Operations	\N	2025-11-29 12:21:08.396467	2025-11-29 12:21:08.396467
1794	CASE1764418867359	29	Telecaller	\N	2025-11-29 12:21:08.398606	2025-11-29 12:21:08.398606
1796	CASE1764418874859	39	Operations	\N	2025-11-29 12:21:15.64377	2025-11-29 12:21:15.64377
1797	CASE1764418874859	30	Telecaller	\N	2025-11-29 12:21:15.645712	2025-11-29 12:21:15.645712
1799	CASE1764418917559	39	Operations	\N	2025-11-29 12:21:58.520484	2025-11-29 12:21:58.520484
1800	CASE1764418917559	30	Telecaller	\N	2025-11-29 12:21:58.52254	2025-11-29 12:21:58.52254
1801	CASE1764420806880	47	KAM	\N	2025-11-29 12:22:12.071134	2025-11-29 12:22:12.071134
1802	CASE1764420806880	39	Operations	\N	2025-11-29 12:22:12.077318	2025-11-29 12:22:12.077318
1803	CASE1764420806880	1	Telecaller	\N	2025-11-29 12:22:12.079374	2025-11-29 12:22:12.079374
1804	CASE1764418937576	34	KAM	\N	2025-11-29 12:22:18.577385	2025-11-29 12:22:18.577385
1805	CASE1764418937576	39	Operations	\N	2025-11-29 12:22:18.58225	2025-11-29 12:22:18.58225
1806	CASE1764418937576	29	Telecaller	\N	2025-11-29 12:22:18.584297	2025-11-29 12:22:18.584297
1808	CASE1764418950129	39	Operations	\N	2025-11-29 12:22:30.863265	2025-11-29 12:22:30.863265
1807	CASE1764418950129	35	KAM	\N	2025-11-29 12:22:30.858215	2025-11-29 12:28:26.748408
1798	CASE1764418917559	35	KAM	\N	2025-11-29 12:21:58.514928	2025-12-05 06:15:02.042515
1809	CASE1764418950129	30	Telecaller	\N	2025-11-29 12:22:30.865301	2025-11-29 12:22:30.865301
1811	CASE1764418982578	39	Operations	\N	2025-11-29 12:23:03.57884	2025-11-29 12:23:03.57884
1812	CASE1764418982578	30	Telecaller	\N	2025-11-29 12:23:03.580895	2025-11-29 12:23:03.580895
1813	CASE1764420879684	47	KAM	\N	2025-11-29 12:23:24.772397	2025-11-29 12:23:24.772397
1814	CASE1764420879684	39	Operations	\N	2025-11-29 12:23:24.777258	2025-11-29 12:23:24.777258
1815	CASE1764420879684	1	Telecaller	\N	2025-11-29 12:23:24.779169	2025-11-29 12:23:24.779169
1817	CASE1764419024198	39	Operations	\N	2025-11-29 12:23:44.934496	2025-11-29 12:23:44.934496
1818	CASE1764419024198	30	Telecaller	\N	2025-11-29 12:23:44.936414	2025-11-29 12:23:44.936414
1820	CASE1764419171180	39	Operations	\N	2025-11-29 12:26:11.958429	2025-11-29 12:26:11.958429
1821	CASE1764419171180	30	Telecaller	\N	2025-11-29 12:26:11.960469	2025-11-29 12:26:11.960469
1819	CASE1764419171180	35	KAM	\N	2025-11-29 12:26:11.952633	2025-11-29 12:26:30.243059
1795	CASE1764418874859	35	KAM	\N	2025-11-29 12:21:15.638693	2025-11-29 12:26:44.445894
1825	CASE1764419234382	39	Operations	\N	2025-11-29 12:27:15.373412	2025-11-29 12:27:15.373412
1826	CASE1764419234382	30	Telecaller	\N	2025-11-29 12:27:15.375478	2025-11-29 12:27:15.375478
1816	CASE1764419024198	35	KAM	\N	2025-11-29 12:23:44.929766	2025-11-29 12:27:34.247068
1828	CASE1764421139481	47	KAM	\N	2025-11-29 12:27:44.536601	2025-11-29 12:27:44.536601
1829	CASE1764421139481	39	Operations	\N	2025-11-29 12:27:44.54193	2025-11-29 12:27:44.54193
1830	CASE1764421139481	1	Telecaller	\N	2025-11-29 12:27:44.543789	2025-11-29 12:27:44.543789
1824	CASE1764419234382	35	KAM	\N	2025-11-29 12:27:15.367652	2025-11-29 12:27:48.725549
1897	CASE1764420443807	35	KAM	\N	2025-11-29 12:47:24.716387	2025-11-29 12:47:48.937984
1810	CASE1764418982578	35	KAM	\N	2025-11-29 12:23:03.572469	2025-11-29 12:28:15.704309
1834	CASE1764421178349	47	KAM	\N	2025-11-29 12:28:23.148735	2025-11-29 12:28:23.148735
1835	CASE1764421178349	39	Operations	\N	2025-11-29 12:28:23.153832	2025-11-29 12:28:23.153832
1836	CASE1764421178349	1	Telecaller	\N	2025-11-29 12:28:23.155872	2025-11-29 12:28:23.155872
2636	CASE1766482376257	39	Operations	\N	2025-12-23 09:32:57.92359	2025-12-23 09:32:57.92359
2637	CASE1766482376257	32	Telecaller	\N	2025-12-23 09:32:57.925617	2025-12-23 09:32:57.925617
1842	CASE1764419414576	34	KAM	\N	2025-11-29 12:30:15.599607	2025-11-29 12:30:15.599607
1843	CASE1764419414576	39	Operations	\N	2025-11-29 12:30:15.605624	2025-11-29 12:30:15.605624
1844	CASE1764419414576	29	Telecaller	\N	2025-11-29 12:30:15.607593	2025-11-29 12:30:15.607593
1845	CASE1764421302673	47	KAM	\N	2025-11-29 12:30:27.736773	2025-11-29 12:30:27.736773
1846	CASE1764421302673	39	Operations	\N	2025-11-29 12:30:27.74174	2025-11-29 12:30:27.74174
1847	CASE1764421302673	1	Telecaller	\N	2025-11-29 12:30:27.743802	2025-11-29 12:30:27.743802
1849	CASE1764419444510	39	Operations	\N	2025-11-29 12:30:45.210687	2025-11-29 12:30:45.210687
1850	CASE1764419444510	30	Telecaller	\N	2025-11-29 12:30:45.213091	2025-11-29 12:30:45.213091
1848	CASE1764419444510	35	KAM	\N	2025-11-29 12:30:45.203943	2025-11-29 12:30:59.353273
1852	CASE1764419528742	35	KAM	\N	2025-11-29 12:32:09.667272	2025-11-29 12:32:09.667272
1853	CASE1764419528742	39	Operations	\N	2025-11-29 12:32:09.673122	2025-11-29 12:32:09.673122
1854	CASE1764419528742	30	Telecaller	\N	2025-11-29 12:32:09.675097	2025-11-29 12:32:09.675097
1856	CASE1764419541526	39	Operations	\N	2025-11-29 12:32:22.254966	2025-11-29 12:32:22.254966
1857	CASE1764419541526	30	Telecaller	\N	2025-11-29 12:32:22.257009	2025-11-29 12:32:22.257009
1855	CASE1764419541526	35	KAM	\N	2025-11-29 12:32:22.248841	2025-11-29 12:32:40.321408
1859	CASE1764419655103	35	KAM	\N	2025-11-29 12:34:15.997333	2025-11-29 12:34:15.997333
1860	CASE1764419655103	39	Operations	\N	2025-11-29 12:34:16.00443	2025-11-29 12:34:16.00443
1861	CASE1764419655103	30	Telecaller	\N	2025-11-29 12:34:16.006922	2025-11-29 12:34:16.006922
1862	CASE1764421595004	47	KAM	\N	2025-11-29 12:35:20.105226	2025-11-29 12:35:20.105226
1863	CASE1764421595004	39	Operations	\N	2025-11-29 12:35:20.111297	2025-11-29 12:35:20.111297
1864	CASE1764421595004	1	Telecaller	\N	2025-11-29 12:35:20.113297	2025-11-29 12:35:20.113297
1865	CASE1764419721175	34	KAM	\N	2025-11-29 12:35:22.134286	2025-11-29 12:35:22.134286
1866	CASE1764419721175	39	Operations	\N	2025-11-29 12:35:22.140245	2025-11-29 12:35:22.140245
1867	CASE1764419721175	29	Telecaller	\N	2025-11-29 12:35:22.142479	2025-11-29 12:35:22.142479
1868	CASE1764419755394	35	KAM	\N	2025-11-29 12:35:56.265917	2025-11-29 12:35:56.265917
1869	CASE1764419755394	39	Operations	\N	2025-11-29 12:35:56.271288	2025-11-29 12:35:56.271288
1870	CASE1764419755394	30	Telecaller	\N	2025-11-29 12:35:56.273358	2025-11-29 12:35:56.273358
1871	CASE1764419800592	34	KAM	\N	2025-11-29 12:36:41.530001	2025-11-29 12:36:41.530001
1872	CASE1764419800592	39	Operations	\N	2025-11-29 12:36:41.535304	2025-11-29 12:36:41.535304
1873	CASE1764419800592	29	Telecaller	\N	2025-11-29 12:36:41.537349	2025-11-29 12:36:41.537349
1875	CASE1764419924041	39	Operations	\N	2025-11-29 12:38:45.097492	2025-11-29 12:38:45.097492
1876	CASE1764419924041	29	Telecaller	\N	2025-11-29 12:38:45.100061	2025-11-29 12:38:45.100061
1874	CASE1764419924041	34	KAM	\N	2025-11-29 12:38:45.081814	2025-11-29 12:39:17.129919
1879	CASE1764419986719	39	Operations	\N	2025-11-29 12:39:47.491268	2025-11-29 12:39:47.491268
1880	CASE1764419986719	30	Telecaller	\N	2025-11-29 12:39:47.493226	2025-11-29 12:39:47.493226
1878	CASE1764419986719	35	KAM	\N	2025-11-29 12:39:47.486076	2025-11-29 12:39:58.977495
1882	CASE1764420063211	35	KAM	\N	2025-11-29 12:41:04.107678	2025-11-29 12:41:04.107678
1883	CASE1764420063211	39	Operations	\N	2025-11-29 12:41:04.113542	2025-11-29 12:41:04.113542
1884	CASE1764420063211	30	Telecaller	\N	2025-11-29 12:41:04.115551	2025-11-29 12:41:04.115551
1885	CASE1764420087778	35	KAM	\N	2025-11-29 12:41:28.565742	2025-11-29 12:41:28.565742
1886	CASE1764420087778	39	Operations	\N	2025-11-29 12:41:28.571581	2025-11-29 12:41:28.571581
1887	CASE1764420087778	30	Telecaller	\N	2025-11-29 12:41:28.57363	2025-11-29 12:41:28.57363
1888	CASE1764420182973	35	KAM	\N	2025-11-29 12:43:03.691719	2025-11-29 12:43:03.691719
1889	CASE1764420182973	39	Operations	\N	2025-11-29 12:43:03.697706	2025-11-29 12:43:03.697706
1890	CASE1764420182973	30	Telecaller	\N	2025-11-29 12:43:03.699659	2025-11-29 12:43:03.699659
1891	CASE1764420250070	35	KAM	\N	2025-11-29 12:44:10.867417	2025-11-29 12:44:10.867417
1892	CASE1764420250070	39	Operations	\N	2025-11-29 12:44:10.873004	2025-11-29 12:44:10.873004
1893	CASE1764420250070	30	Telecaller	\N	2025-11-29 12:44:10.874901	2025-11-29 12:44:10.874901
1894	CASE1764420309445	35	KAM	\N	2025-11-29 12:45:10.365774	2025-11-29 12:45:10.365774
1895	CASE1764420309445	39	Operations	\N	2025-11-29 12:45:10.373248	2025-11-29 12:45:10.373248
1896	CASE1764420309445	30	Telecaller	\N	2025-11-29 12:45:10.375181	2025-11-29 12:45:10.375181
1898	CASE1764420443807	39	Operations	\N	2025-11-29 12:47:24.722201	2025-11-29 12:47:24.722201
1899	CASE1764420443807	30	Telecaller	\N	2025-11-29 12:47:24.724266	2025-11-29 12:47:24.724266
1900	CASE1764420450010	35	KAM	\N	2025-11-29 12:47:30.733515	2025-11-29 12:47:30.733515
1901	CASE1764420450010	39	Operations	\N	2025-11-29 12:47:30.738392	2025-11-29 12:47:30.738392
1902	CASE1764420450010	30	Telecaller	\N	2025-11-29 12:47:30.740357	2025-11-29 12:47:30.740357
1904	CASE1764420512032	35	KAM	\N	2025-11-29 12:48:32.75291	2025-11-29 12:48:32.75291
1905	CASE1764420512032	39	Operations	\N	2025-11-29 12:48:32.758608	2025-11-29 12:48:32.758608
1906	CASE1764420512032	30	Telecaller	\N	2025-11-29 12:48:32.760593	2025-11-29 12:48:32.760593
1907	CASE1764420561995	35	KAM	\N	2025-11-29 12:49:22.214992	2025-11-29 12:49:22.214992
1908	CASE1764420561995	39	Operations	\N	2025-11-29 12:49:22.220833	2025-11-29 12:49:22.220833
1909	CASE1764420561995	30	Telecaller	\N	2025-11-29 12:49:22.222843	2025-11-29 12:49:22.222843
1910	CASE1764422440696	47	KAM	\N	2025-11-29 12:49:25.697304	2025-11-29 12:49:25.697304
1911	CASE1764422440696	39	Operations	\N	2025-11-29 12:49:25.702257	2025-11-29 12:49:25.702257
1912	CASE1764422440696	1	Telecaller	\N	2025-11-29 12:49:25.704239	2025-11-29 12:49:25.704239
1913	CASE1764422503150	47	KAM	\N	2025-11-29 12:50:28.168281	2025-11-29 12:50:28.168281
1914	CASE1764422503150	39	Operations	\N	2025-11-29 12:50:28.174241	2025-11-29 12:50:28.174241
1915	CASE1764422503150	1	Telecaller	\N	2025-11-29 12:50:28.176263	2025-11-29 12:50:28.176263
1916	CASE1764420646573	35	KAM	\N	2025-11-29 12:50:47.38539	2025-11-29 12:50:47.38539
1917	CASE1764420646573	39	Operations	\N	2025-11-29 12:50:47.391555	2025-11-29 12:50:47.391555
1918	CASE1764420646573	30	Telecaller	\N	2025-11-29 12:50:47.393533	2025-11-29 12:50:47.393533
1919	CASE1764420658463	35	KAM	\N	2025-11-29 12:50:59.317607	2025-11-29 12:50:59.317607
1920	CASE1764420658463	39	Operations	\N	2025-11-29 12:50:59.322447	2025-11-29 12:50:59.322447
2646	CASE1766565547307	35	KAM	\N	2025-12-24 08:39:06.467775	2025-12-24 08:39:25.397716
1921	CASE1764420658463	30	Telecaller	\N	2025-11-29 12:50:59.324456	2025-11-29 12:50:59.324456
1922	CASE1764420696817	35	KAM	\N	2025-11-29 12:51:37.031644	2025-11-29 12:51:37.031644
1923	CASE1764420696817	39	Operations	\N	2025-11-29 12:51:37.037658	2025-11-29 12:51:37.037658
1924	CASE1764420696817	30	Telecaller	\N	2025-11-29 12:51:37.039659	2025-11-29 12:51:37.039659
1925	CASE1764420766374	35	KAM	\N	2025-11-29 12:52:47.189724	2025-11-29 12:52:47.189724
1926	CASE1764420766374	39	Operations	\N	2025-11-29 12:52:47.195633	2025-11-29 12:52:47.195633
1927	CASE1764420766374	30	Telecaller	\N	2025-11-29 12:52:47.198362	2025-11-29 12:52:47.198362
1928	CASE1764420808925	35	KAM	\N	2025-11-29 12:53:29.170733	2025-11-29 12:53:29.170733
1929	CASE1764420808925	39	Operations	\N	2025-11-29 12:53:29.17578	2025-11-29 12:53:29.17578
1930	CASE1764420808925	30	Telecaller	\N	2025-11-29 12:53:29.177652	2025-11-29 12:53:29.177652
1931	CASE1764422706393	47	KAM	\N	2025-11-29 12:53:52.032812	2025-11-29 12:53:52.032812
1932	CASE1764422706393	39	Operations	\N	2025-11-29 12:53:52.038209	2025-11-29 12:53:52.038209
1933	CASE1764422706393	1	Telecaller	\N	2025-11-29 12:53:52.040372	2025-11-29 12:53:52.040372
1934	CASE1764420876643	35	KAM	\N	2025-11-29 12:54:37.384309	2025-11-29 12:54:37.384309
1935	CASE1764420876643	39	Operations	\N	2025-11-29 12:54:37.390166	2025-11-29 12:54:37.390166
1936	CASE1764420876643	30	Telecaller	\N	2025-11-29 12:54:37.392215	2025-11-29 12:54:37.392215
1937	CASE1764422765346	47	KAM	\N	2025-11-29 12:54:50.200316	2025-11-29 12:54:50.200316
1938	CASE1764422765346	39	Operations	\N	2025-11-29 12:54:50.206253	2025-11-29 12:54:50.206253
1939	CASE1764422765346	1	Telecaller	\N	2025-11-29 12:54:50.208223	2025-11-29 12:54:50.208223
1940	CASE1764420902424	35	KAM	\N	2025-11-29 12:55:03.353789	2025-11-29 12:55:03.353789
1941	CASE1764420902424	39	Operations	\N	2025-11-29 12:55:03.358955	2025-11-29 12:55:03.358955
1942	CASE1764420902424	30	Telecaller	\N	2025-11-29 12:55:03.360975	2025-11-29 12:55:03.360975
1943	CASE1764420963610	35	KAM	\N	2025-11-29 12:56:04.359572	2025-11-29 12:56:04.359572
1944	CASE1764420963610	39	Operations	\N	2025-11-29 12:56:04.365276	2025-11-29 12:56:04.365276
1945	CASE1764420963610	30	Telecaller	\N	2025-11-29 12:56:04.367258	2025-11-29 12:56:04.367258
1946	CASE1764420999210	35	KAM	\N	2025-11-29 12:56:40.147202	2025-11-29 12:56:40.147202
1947	CASE1764420999210	39	Operations	\N	2025-11-29 12:56:40.153649	2025-11-29 12:56:40.153649
1948	CASE1764420999210	30	Telecaller	\N	2025-11-29 12:56:40.155786	2025-11-29 12:56:40.155786
1949	CASE1764422899787	47	KAM	\N	2025-11-29 12:57:04.768875	2025-11-29 12:57:04.768875
1950	CASE1764422899787	39	Operations	\N	2025-11-29 12:57:04.774827	2025-11-29 12:57:04.774827
1951	CASE1764422899787	1	Telecaller	\N	2025-11-29 12:57:04.776866	2025-11-29 12:57:04.776866
1952	CASE1764421035350	35	KAM	\N	2025-11-29 12:57:16.148294	2025-11-29 12:57:16.148294
1953	CASE1764421035350	39	Operations	\N	2025-11-29 12:57:16.153233	2025-11-29 12:57:16.153233
1954	CASE1764421035350	30	Telecaller	\N	2025-11-29 12:57:16.155175	2025-11-29 12:57:16.155175
1956	CASE1764421093546	39	Operations	\N	2025-11-29 12:58:14.449037	2025-11-29 12:58:14.449037
1957	CASE1764421093546	30	Telecaller	\N	2025-11-29 12:58:14.450982	2025-11-29 12:58:14.450982
1955	CASE1764421093546	35	KAM	\N	2025-11-29 12:58:14.443234	2025-11-29 12:58:37.430731
1959	CASE1764421133007	35	KAM	\N	2025-11-29 12:58:53.768905	2025-11-29 12:58:53.768905
1960	CASE1764421133007	39	Operations	\N	2025-11-29 12:58:53.774912	2025-11-29 12:58:53.774912
1961	CASE1764421133007	30	Telecaller	\N	2025-11-29 12:58:53.776793	2025-11-29 12:58:53.776793
1962	CASE1764423026960	47	KAM	\N	2025-11-29 12:59:11.946049	2025-11-29 12:59:11.946049
1963	CASE1764423026960	39	Operations	\N	2025-11-29 12:59:11.952714	2025-11-29 12:59:11.952714
1964	CASE1764423026960	1	Telecaller	\N	2025-11-29 12:59:11.954906	2025-11-29 12:59:11.954906
1965	CASE1764421200261	35	KAM	\N	2025-11-29 13:00:01.210469	2025-11-29 13:00:01.210469
1966	CASE1764421200261	39	Operations	\N	2025-11-29 13:00:01.219232	2025-11-29 13:00:01.219232
1967	CASE1764421200261	30	Telecaller	\N	2025-11-29 13:00:01.221897	2025-11-29 13:00:01.221897
1968	CASE1764423096914	47	KAM	\N	2025-11-29 13:00:21.928973	2025-11-29 13:00:21.928973
1969	CASE1764423096914	39	Operations	\N	2025-11-29 13:00:21.93483	2025-11-29 13:00:21.93483
1970	CASE1764423096914	1	Telecaller	\N	2025-11-29 13:00:21.936802	2025-11-29 13:00:21.936802
1971	CASE1764421309103	35	KAM	\N	2025-11-29 13:01:49.827039	2025-11-29 13:01:49.827039
1972	CASE1764421309103	39	Operations	\N	2025-11-29 13:01:49.832222	2025-11-29 13:01:49.832222
1973	CASE1764421309103	30	Telecaller	\N	2025-11-29 13:01:49.834235	2025-11-29 13:01:49.834235
1975	CASE1764421380531	39	Operations	\N	2025-11-29 13:03:01.490635	2025-11-29 13:03:01.490635
1976	CASE1764421380531	30	Telecaller	\N	2025-11-29 13:03:01.492695	2025-11-29 13:03:01.492695
1977	CASE1764421403218	35	KAM	\N	2025-11-29 13:03:24.01741	2025-11-29 13:03:24.01741
1978	CASE1764421403218	39	Operations	\N	2025-11-29 13:03:24.023536	2025-11-29 13:03:24.023536
1979	CASE1764421403218	30	Telecaller	\N	2025-11-29 13:03:24.025581	2025-11-29 13:03:24.025581
1980	CASE1764423292157	47	KAM	\N	2025-11-29 13:03:37.167293	2025-11-29 13:03:37.167293
1981	CASE1764423292157	39	Operations	\N	2025-11-29 13:03:37.173154	2025-11-29 13:03:37.173154
1982	CASE1764423292157	1	Telecaller	\N	2025-11-29 13:03:37.175274	2025-11-29 13:03:37.175274
1983	CASE1764423337859	47	KAM	\N	2025-11-29 13:04:22.562821	2025-11-29 13:04:22.562821
1984	CASE1764423337859	39	Operations	\N	2025-11-29 13:04:22.568653	2025-11-29 13:04:22.568653
1985	CASE1764423337859	1	Telecaller	\N	2025-11-29 13:04:22.570669	2025-11-29 13:04:22.570669
1986	CASE1764421467023	35	KAM	\N	2025-11-29 13:04:27.770951	2025-11-29 13:04:27.770951
1987	CASE1764421467023	39	Operations	\N	2025-11-29 13:04:27.775778	2025-11-29 13:04:27.775778
1988	CASE1764421467023	30	Telecaller	\N	2025-11-29 13:04:27.777694	2025-11-29 13:04:27.777694
1989	CASE1764421534594	35	KAM	\N	2025-11-29 13:05:35.488197	2025-11-29 13:05:35.488197
1990	CASE1764421534594	39	Operations	\N	2025-11-29 13:05:35.494123	2025-11-29 13:05:35.494123
1991	CASE1764421534594	30	Telecaller	\N	2025-11-29 13:05:35.496133	2025-11-29 13:05:35.496133
1992	CASE1764423412880	47	KAM	\N	2025-11-29 13:05:37.834252	2025-11-29 13:05:37.834252
1993	CASE1764423412880	39	Operations	\N	2025-11-29 13:05:37.839186	2025-11-29 13:05:37.839186
1994	CASE1764423412880	1	Telecaller	\N	2025-11-29 13:05:37.841109	2025-11-29 13:05:37.841109
1995	CASE1764421583812	35	KAM	\N	2025-11-29 13:06:24.635035	2025-11-29 13:06:24.635035
1996	CASE1764421583812	39	Operations	\N	2025-11-29 13:06:24.640615	2025-11-29 13:06:24.640615
1997	CASE1764421583812	30	Telecaller	\N	2025-11-29 13:06:24.642578	2025-11-29 13:06:24.642578
1998	CASE1764423491534	47	KAM	\N	2025-11-29 13:06:56.59015	2025-11-29 13:06:56.59015
1999	CASE1764423491534	39	Operations	\N	2025-11-29 13:06:56.595786	2025-11-29 13:06:56.595786
2000	CASE1764423491534	1	Telecaller	\N	2025-11-29 13:06:56.597698	2025-11-29 13:06:56.597698
2001	CASE1764421630952	35	KAM	\N	2025-11-29 13:07:11.818335	2025-11-29 13:07:11.818335
2002	CASE1764421630952	39	Operations	\N	2025-11-29 13:07:11.823284	2025-11-29 13:07:11.823284
2003	CASE1764421630952	30	Telecaller	\N	2025-11-29 13:07:11.82518	2025-11-29 13:07:11.82518
2004	CASE1764421653947	35	KAM	\N	2025-11-29 13:07:34.71188	2025-11-29 13:07:34.71188
2005	CASE1764421653947	39	Operations	\N	2025-11-29 13:07:34.717321	2025-11-29 13:07:34.717321
2006	CASE1764421653947	30	Telecaller	\N	2025-11-29 13:07:34.719218	2025-11-29 13:07:34.719218
2007	CASE1764421707811	35	KAM	\N	2025-11-29 13:08:28.655982	2025-11-29 13:08:28.655982
2008	CASE1764421707811	39	Operations	\N	2025-11-29 13:08:28.661175	2025-11-29 13:08:28.661175
2009	CASE1764421707811	30	Telecaller	\N	2025-11-29 13:08:28.663208	2025-11-29 13:08:28.663208
2010	CASE1764423635874	47	KAM	\N	2025-11-29 13:09:20.903193	2025-11-29 13:09:20.903193
2011	CASE1764423635874	39	Operations	\N	2025-11-29 13:09:20.908582	2025-11-29 13:09:20.908582
2012	CASE1764423635874	1	Telecaller	\N	2025-11-29 13:09:20.91039	2025-11-29 13:09:20.91039
2013	CASE1764421801269	35	KAM	\N	2025-11-29 13:10:02.185377	2025-11-29 13:10:02.185377
2014	CASE1764421801269	39	Operations	\N	2025-11-29 13:10:02.192221	2025-11-29 13:10:02.192221
2015	CASE1764421801269	30	Telecaller	\N	2025-11-29 13:10:02.194333	2025-11-29 13:10:02.194333
2017	CASE1764421818016	39	Operations	\N	2025-11-29 13:10:18.784301	2025-11-29 13:10:18.784301
2018	CASE1764421818016	30	Telecaller	\N	2025-11-29 13:10:18.786226	2025-11-29 13:10:18.786226
2019	CASE1764421862985	35	KAM	\N	2025-11-29 13:11:03.893774	2025-11-29 13:11:03.893774
2020	CASE1764421862985	39	Operations	\N	2025-11-29 13:11:03.899655	2025-11-29 13:11:03.899655
2021	CASE1764421862985	30	Telecaller	\N	2025-11-29 13:11:03.901705	2025-11-29 13:11:03.901705
1974	CASE1764421380531	35	KAM	\N	2025-11-29 13:03:01.484564	2025-12-04 08:34:50.72176
2022	CASE1764423749647	47	KAM	\N	2025-11-29 13:11:14.594137	2025-11-29 13:11:14.594137
2023	CASE1764423749647	39	Operations	\N	2025-11-29 13:11:14.599455	2025-11-29 13:11:14.599455
2024	CASE1764423749647	1	Telecaller	\N	2025-11-29 13:11:14.60158	2025-11-29 13:11:14.60158
2025	CASE1764421890082	35	KAM	\N	2025-11-29 13:11:30.829591	2025-11-29 13:11:30.829591
2026	CASE1764421890082	39	Operations	\N	2025-11-29 13:11:30.834669	2025-11-29 13:11:30.834669
2027	CASE1764421890082	30	Telecaller	\N	2025-11-29 13:11:30.836597	2025-11-29 13:11:30.836597
2028	CASE1764423793116	47	KAM	\N	2025-11-29 13:11:57.899402	2025-11-29 13:11:57.899402
2029	CASE1764423793116	39	Operations	\N	2025-11-29 13:11:57.905136	2025-11-29 13:11:57.905136
2030	CASE1764423793116	1	Telecaller	\N	2025-11-29 13:11:57.907215	2025-11-29 13:11:57.907215
2016	CASE1764421818016	35	KAM	\N	2025-11-29 13:10:18.778641	2025-11-29 13:12:00.40039
2033	CASE1764421936753	39	Operations	\N	2025-11-29 13:12:17.64135	2025-11-29 13:12:17.64135
2034	CASE1764421936753	30	Telecaller	\N	2025-11-29 13:12:17.643451	2025-11-29 13:12:17.643451
2035	CASE1764423885171	47	KAM	\N	2025-11-29 13:13:30.133854	2025-11-29 13:13:30.133854
2036	CASE1764423885171	39	Operations	\N	2025-11-29 13:13:30.139654	2025-11-29 13:13:30.139654
2037	CASE1764423885171	1	Telecaller	\N	2025-11-29 13:13:30.141663	2025-11-29 13:13:30.141663
1214	CASE1761910111749	34	KAM	\N	2025-11-29 05:18:39.742947	2025-11-29 13:22:41.732169
2040	CASE1762753606380	42	UW	\N	2025-11-29 13:29:02.695626	2025-11-29 13:29:02.695626
2041	CASE1764565490802	34	KAM	\N	2025-12-01 05:04:51.837889	2025-12-01 05:04:51.837889
2042	CASE1764565490802	39	Operations	\N	2025-12-01 05:04:51.844766	2025-12-01 05:04:51.844766
2043	CASE1764565490802	29	Telecaller	\N	2025-12-01 05:04:51.846781	2025-12-01 05:04:51.846781
2044	CASE1764565550201	34	KAM	\N	2025-12-01 05:05:50.915706	2025-12-01 05:05:50.915706
2045	CASE1764565550201	39	Operations	\N	2025-12-01 05:05:50.921035	2025-12-01 05:05:50.921035
2046	CASE1764565550201	29	Telecaller	\N	2025-12-01 05:05:50.923036	2025-12-01 05:05:50.923036
2048	CASE1764573615748	39	Operations	\N	2025-12-01 07:20:13.708443	2025-12-01 07:20:13.708443
2049	CASE1764573615748	30	Telecaller	\N	2025-12-01 07:20:13.710464	2025-12-01 07:20:13.710464
2047	CASE1764573615748	35	KAM	\N	2025-12-01 07:20:13.702147	2025-12-01 07:21:37.948027
2032	CASE1764421936753	35	KAM	\N	2025-11-29 13:12:17.635548	2025-12-01 07:25:45.074493
2053	CASE1764585167172	39	Operations	\N	2025-12-01 10:32:45.240866	2025-12-01 10:32:45.240866
2054	CASE1764585167172	31	Telecaller	\N	2025-12-01 10:32:45.24295	2025-12-01 10:32:45.24295
2052	CASE1764585167172	37	KAM	\N	2025-12-01 10:32:45.234144	2025-12-01 10:32:56.418122
2057	CASE1764591677538	39	Operations	\N	2025-12-01 12:21:18.219753	2025-12-01 12:21:18.219753
2058	CASE1764591677538	29	Telecaller	\N	2025-12-01 12:21:18.221826	2025-12-01 12:21:18.221826
2059	CASE1764591754069	35	KAM	\N	2025-12-01 12:22:34.747616	2025-12-01 12:22:34.747616
2060	CASE1764591754069	39	Operations	\N	2025-12-01 12:22:34.753326	2025-12-01 12:22:34.753326
2061	CASE1764591754069	29	Telecaller	\N	2025-12-01 12:22:34.755238	2025-12-01 12:22:34.755238
2056	CASE1764591677538	35	KAM	\N	2025-12-01 12:21:18.21377	2025-12-01 12:22:47.056713
2065	CASE1764667542283	39	Operations	\N	2025-12-02 09:25:42.747509	2025-12-02 09:25:42.747509
2066	CASE1764667542283	31	Telecaller	\N	2025-12-02 09:25:42.749447	2025-12-02 09:25:42.749447
2064	CASE1764667542283	36	KAM	\N	2025-12-02 09:25:42.741955	2025-12-02 09:25:58.196199
2069	CASE1764670358929	39	Operations	\N	2025-12-02 10:12:39.973378	2025-12-02 10:12:39.973378
2070	CASE1764670358929	31	Telecaller	\N	2025-12-02 10:12:39.976037	2025-12-02 10:12:39.976037
2068	CASE1764670358929	37	KAM	\N	2025-12-02 10:12:39.967348	2025-12-02 10:12:51.263265
2073	CASE1764758265597	39	Operations	\N	2025-12-03 10:37:44.47416	2025-12-03 10:37:44.47416
2074	CASE1764758265597	30	Telecaller	\N	2025-12-03 10:37:44.476239	2025-12-03 10:37:44.476239
2136	CASE1764925774102	36	KAM	\N	2025-12-05 09:09:33.654176	2025-12-05 09:09:33.654176
2077	CASE1764758383466	39	Operations	\N	2025-12-03 10:39:42.346945	2025-12-03 10:39:42.346945
2078	CASE1764758383466	30	Telecaller	\N	2025-12-03 10:39:42.349188	2025-12-03 10:39:42.349188
2076	CASE1764758383466	35	KAM	\N	2025-12-03 10:39:42.339587	2025-12-03 10:39:57.903415
2081	CASE1764758563126	39	Operations	\N	2025-12-03 10:42:41.928483	2025-12-03 10:42:41.928483
2082	CASE1764758563126	30	Telecaller	\N	2025-12-03 10:42:41.930482	2025-12-03 10:42:41.930482
2137	CASE1764925774102	39	Operations	\N	2025-12-05 09:09:33.659796	2025-12-05 09:09:33.659796
2085	CASE1764758733768	39	Operations	\N	2025-12-03 10:45:32.552207	2025-12-03 10:45:32.552207
2086	CASE1764758733768	30	Telecaller	\N	2025-12-03 10:45:32.554252	2025-12-03 10:45:32.554252
2084	CASE1764758733768	35	KAM	\N	2025-12-03 10:45:32.546271	2025-12-03 10:45:45.621984
2089	CASE1764758921219	39	Operations	\N	2025-12-03 10:48:42.114153	2025-12-03 10:48:42.114153
2090	CASE1764758921219	32	Telecaller	\N	2025-12-03 10:48:42.117244	2025-12-03 10:48:42.117244
2088	CASE1764758921219	37	KAM	\N	2025-12-03 10:48:42.105941	2025-12-03 10:48:59.707072
2093	CASE1764759080426	39	Operations	\N	2025-12-03 10:51:21.167886	2025-12-03 10:51:21.167886
2094	CASE1764759080426	32	Telecaller	\N	2025-12-03 10:51:21.16996	2025-12-03 10:51:21.16996
2092	CASE1764759080426	37	KAM	\N	2025-12-03 10:51:21.161894	2025-12-03 10:51:37.01289
2097	CASE1764759245269	39	Operations	\N	2025-12-03 10:54:06.108699	2025-12-03 10:54:06.108699
2098	CASE1764759245269	32	Telecaller	\N	2025-12-03 10:54:06.110784	2025-12-03 10:54:06.110784
2096	CASE1764759245269	36	KAM	\N	2025-12-03 10:54:06.102817	2025-12-03 10:54:24.18266
2115	CASE1764830414143	35	KAM	\N	2025-12-04 06:40:14.815458	2025-12-04 07:04:20.984078
2138	CASE1764925774102	33	Telecaller	\N	2025-12-05 09:09:33.661849	2025-12-05 09:09:33.661849
2103	CASE1764765294809	39	Operations	\N	2025-12-03 12:34:54.510102	2025-12-03 12:34:54.510102
2104	CASE1764765294809	31	Telecaller	\N	2025-12-03 12:34:54.512094	2025-12-03 12:34:54.512094
2102	CASE1764765294809	37	KAM	\N	2025-12-03 12:34:54.503975	2025-12-03 12:35:10.01353
2107	CASE1764765397812	39	Operations	\N	2025-12-03 12:36:37.518332	2025-12-03 12:36:37.518332
2108	CASE1764765397812	31	Telecaller	\N	2025-12-03 12:36:37.52041	2025-12-03 12:36:37.52041
2106	CASE1764765397812	37	KAM	\N	2025-12-03 12:36:37.512335	2025-12-03 12:36:47.803367
2111	CASE1764765465033	39	Operations	\N	2025-12-03 12:37:44.755741	2025-12-03 12:37:44.755741
2112	CASE1764765465033	31	Telecaller	\N	2025-12-03 12:37:44.757665	2025-12-03 12:37:44.757665
2110	CASE1764765465033	37	KAM	\N	2025-12-03 12:37:44.75032	2025-12-03 12:38:08.207336
2116	CASE1764830414143	39	Operations	\N	2025-12-04 06:40:14.821743	2025-12-04 06:40:14.821743
2117	CASE1764830414143	30	Telecaller	\N	2025-12-04 06:40:14.823784	2025-12-04 06:40:14.823784
2122	CASE1764847094848	39	Operations	\N	2025-12-04 11:18:14.949081	2025-12-04 11:18:14.949081
2123	CASE1764847094848	33	Telecaller	\N	2025-12-04 11:18:14.951038	2025-12-04 11:18:14.951038
2080	CASE1764758563126	35	KAM	\N	2025-12-03 10:42:41.922544	2025-12-05 04:58:59.331907
2072	CASE1764758265597	35	KAM	\N	2025-12-03 10:37:44.467746	2025-12-05 04:59:56.212342
2128	CASE1764924175994	39	Operations	\N	2025-12-05 08:42:55.553722	2025-12-05 08:42:55.553722
2129	CASE1764924175994	33	Telecaller	\N	2025-12-05 08:42:55.55742	2025-12-05 08:42:55.55742
2121	CASE1764847094848	37	KAM	\N	2025-12-04 11:18:14.94268	2025-12-05 08:43:26.984584
2127	CASE1764924175994	37	KAM	\N	2025-12-05 08:42:55.54753	2025-12-05 08:44:38.997283
2133	CASE1764925645970	39	Operations	\N	2025-12-05 09:07:25.872017	2025-12-05 09:07:25.872017
2134	CASE1764925645970	30	Telecaller	\N	2025-12-05 09:07:25.873952	2025-12-05 09:07:25.873952
2132	CASE1764925645970	35	KAM	\N	2025-12-05 09:07:25.866303	2025-12-05 09:07:40.333696
2140	CASE1764925775028	39	Operations	\N	2025-12-05 09:09:34.877615	2025-12-05 09:09:34.877615
2141	CASE1764925775028	30	Telecaller	\N	2025-12-05 09:09:34.879663	2025-12-05 09:09:34.879663
2139	CASE1764925775028	35	KAM	\N	2025-12-05 09:09:34.87265	2025-12-05 09:09:51.065223
2143	CASE1764931685625	34	KAM	\N	2025-12-05 10:48:05.195143	2025-12-05 10:48:05.195143
2144	CASE1764931685625	39	Operations	\N	2025-12-05 10:48:05.201576	2025-12-05 10:48:05.201576
2145	CASE1764931685625	33	Telecaller	\N	2025-12-05 10:48:05.20365	2025-12-05 10:48:05.20365
2147	CASE1765172269352	39	Operations	\N	2025-12-08 05:37:47.451764	2025-12-08 05:37:47.451764
2148	CASE1765172269352	30	Telecaller	\N	2025-12-08 05:37:47.453759	2025-12-08 05:37:47.453759
2146	CASE1765172269352	35	KAM	\N	2025-12-08 05:37:47.444542	2025-12-08 05:38:08.884228
2635	CASE1766482376257	37	KAM	\N	2025-12-23 09:32:57.917464	2025-12-23 09:36:53.044444
2151	CASE1765186854031	39	Operations	\N	2025-12-08 09:40:48.351958	2025-12-08 09:40:48.351958
2152	CASE1765186854031	31	Telecaller	\N	2025-12-08 09:40:48.353992	2025-12-08 09:40:48.353992
2150	CASE1765186854031	37	KAM	\N	2025-12-08 09:40:48.345328	2025-12-08 09:41:01.206847
2155	CASE1765186938057	39	Operations	\N	2025-12-08 09:42:11.557166	2025-12-08 09:42:11.557166
2156	CASE1765186938057	31	Telecaller	\N	2025-12-08 09:42:11.559186	2025-12-08 09:42:11.559186
2154	CASE1765186938057	34	KAM	\N	2025-12-08 09:42:11.551227	2025-12-08 09:42:33.427655
2159	CASE1764421233518	\N	Banker	\N	2025-12-08 11:07:13.076216	2025-12-08 11:07:13.076216
2160	CASE1764758733768	42	UW	\N	2025-12-08 11:09:22.363937	2025-12-08 11:09:22.363937
2161	CASE1764402810649	\N	Banker	\N	2025-12-08 11:18:38.183455	2025-12-08 11:18:38.183455
2162	CASE1765195048440	36	KAM	\N	2025-12-08 11:57:28.953003	2025-12-08 11:57:28.953003
2163	CASE1765195048440	39	Operations	\N	2025-12-08 11:57:28.959379	2025-12-08 11:57:28.959379
2164	CASE1765195048440	33	Telecaller	\N	2025-12-08 11:57:28.961398	2025-12-08 11:57:28.961398
2165	CASE1765195385335	37	KAM	\N	2025-12-08 12:03:05.816273	2025-12-08 12:03:05.816273
2166	CASE1765195385335	39	Operations	\N	2025-12-08 12:03:05.821846	2025-12-08 12:03:05.821846
2167	CASE1765195385335	33	Telecaller	\N	2025-12-08 12:03:05.823834	2025-12-08 12:03:05.823834
2168	CASE1764402510984	\N	Banker	\N	2025-12-08 12:03:07.697338	2025-12-08 12:03:07.697338
2169	CASE1765273433703	37	KAM	\N	2025-12-09 09:43:52.985829	2025-12-09 09:43:52.985829
2170	CASE1765273433703	39	Operations	\N	2025-12-09 09:43:52.991834	2025-12-09 09:43:52.991834
2171	CASE1765273433703	33	Telecaller	\N	2025-12-09 09:43:52.99388	2025-12-09 09:43:52.99388
2172	CASE1765273717401	36	KAM	\N	2025-12-09 09:48:36.696517	2025-12-09 09:48:36.696517
2173	CASE1765273717401	39	Operations	\N	2025-12-09 09:48:36.702288	2025-12-09 09:48:36.702288
2174	CASE1765273717401	33	Telecaller	\N	2025-12-09 09:48:36.704324	2025-12-09 09:48:36.704324
2176	CASE1765285300082	39	Operations	\N	2025-12-09 13:01:41.266478	2025-12-09 13:01:41.266478
2177	CASE1765285300082	31	Telecaller	\N	2025-12-09 13:01:41.268472	2025-12-09 13:01:41.268472
2179	CASE1765285368534	39	Operations	\N	2025-12-09 13:02:49.659859	2025-12-09 13:02:49.659859
2180	CASE1765285368534	31	Telecaller	\N	2025-12-09 13:02:49.661805	2025-12-09 13:02:49.661805
2175	CASE1765285300082	36	KAM	\N	2025-12-09 13:01:41.260152	2025-12-09 13:03:29.10963
2178	CASE1765285368534	37	KAM	\N	2025-12-09 13:02:49.65426	2025-12-09 13:04:07.592878
2183	CASE1764758265597	42	UW	\N	2025-12-10 09:31:34.241721	2025-12-10 09:31:34.241721
2185	CASE1765369465418	39	Operations	\N	2025-12-10 12:24:25.840089	2025-12-10 12:24:25.840089
2186	CASE1765369465418	31	Telecaller	\N	2025-12-10 12:24:25.842294	2025-12-10 12:24:25.842294
2184	CASE1765369465418	36	KAM	\N	2025-12-10 12:24:25.833258	2025-12-10 12:24:37.159441
2189	CASE1765369604671	39	Operations	\N	2025-12-10 12:26:45.096262	2025-12-10 12:26:45.096262
2190	CASE1765369604671	31	Telecaller	\N	2025-12-10 12:26:45.103146	2025-12-10 12:26:45.103146
2188	CASE1765369604671	37	KAM	\N	2025-12-10 12:26:45.084071	2025-12-10 12:26:56.019421
2192	CASE1765452417328	37	KAM	\N	2025-12-11 11:26:57.636007	2025-12-11 11:26:57.636007
2193	CASE1765452417328	39	Operations	\N	2025-12-11 11:26:57.642237	2025-12-11 11:26:57.642237
2194	CASE1765452417328	33	Telecaller	\N	2025-12-11 11:26:57.644304	2025-12-11 11:26:57.644304
2195	CASE1765452794978	36	KAM	\N	2025-12-11 11:33:15.191666	2025-12-11 11:33:15.191666
2196	CASE1765452794978	39	Operations	\N	2025-12-11 11:33:15.198094	2025-12-11 11:33:15.198094
2197	CASE1765452794978	33	Telecaller	\N	2025-12-11 11:33:15.20014	2025-12-11 11:33:15.20014
2199	CASE1765517825133	39	Operations	\N	2025-12-12 05:37:03.538415	2025-12-12 05:37:03.538415
2200	CASE1765517825133	31	Telecaller	\N	2025-12-12 05:37:03.540375	2025-12-12 05:37:03.540375
2198	CASE1765517825133	35	KAM	\N	2025-12-12 05:37:03.532273	2025-12-12 05:37:27.739175
2203	CASE1765541147781	39	Operations	\N	2025-12-12 12:05:48.41098	2025-12-12 12:05:48.41098
2204	CASE1765541147781	31	Telecaller	\N	2025-12-12 12:05:48.413083	2025-12-12 12:05:48.413083
2207	CASE1765541373746	39	Operations	\N	2025-12-12 12:09:34.501598	2025-12-12 12:09:34.501598
2208	CASE1765541373746	31	Telecaller	\N	2025-12-12 12:09:34.503727	2025-12-12 12:09:34.503727
2206	CASE1765541373746	36	KAM	\N	2025-12-12 12:09:34.495832	2025-12-12 12:09:44.02512
2211	CASE1765542471523	39	Operations	\N	2025-12-12 12:27:51.752267	2025-12-12 12:27:51.752267
2212	CASE1765542471523	30	Telecaller	\N	2025-12-12 12:27:51.754256	2025-12-12 12:27:51.754256
2210	CASE1765542471523	35	KAM	\N	2025-12-12 12:27:51.746071	2025-12-12 12:28:25.554314
2215	CASE1765542595738	39	Operations	\N	2025-12-12 12:29:56.096444	2025-12-12 12:29:56.096444
2216	CASE1765542595738	30	Telecaller	\N	2025-12-12 12:29:56.098614	2025-12-12 12:29:56.098614
2214	CASE1765542595738	35	KAM	\N	2025-12-12 12:29:56.089444	2025-12-12 12:30:13.105125
2219	CASE1765542741046	39	Operations	\N	2025-12-12 12:32:21.244297	2025-12-12 12:32:21.244297
2220	CASE1765542741046	30	Telecaller	\N	2025-12-12 12:32:21.246385	2025-12-12 12:32:21.246385
2222	CASE1765542753297	39	Operations	\N	2025-12-12 12:32:33.353995	2025-12-12 12:32:33.353995
2223	CASE1765542753297	30	Telecaller	\N	2025-12-12 12:32:33.356093	2025-12-12 12:32:33.356093
2247	CASE1765780742990	39	Operations	\N	2025-12-15 06:39:00.539792	2025-12-15 06:39:00.539792
2221	CASE1765542753297	35	KAM	\N	2025-12-12 12:32:33.347844	2025-12-12 12:33:42.390673
2218	CASE1765542741046	35	KAM	\N	2025-12-12 12:32:21.238076	2025-12-12 12:35:20.211328
2228	CASE1765543026283	39	Operations	\N	2025-12-12 12:37:06.461014	2025-12-12 12:37:06.461014
2229	CASE1765543026283	30	Telecaller	\N	2025-12-12 12:37:06.46308	2025-12-12 12:37:06.46308
2227	CASE1765543026283	35	KAM	\N	2025-12-12 12:37:06.455323	2025-12-12 12:37:27.372175
2232	CASE1765544103935	39	Operations	\N	2025-12-12 12:55:05.635144	2025-12-12 12:55:05.635144
2233	CASE1765544103935	32	Telecaller	\N	2025-12-12 12:55:05.637198	2025-12-12 12:55:05.637198
2231	CASE1765544103935	36	KAM	\N	2025-12-12 12:55:05.629268	2025-12-12 12:55:22.510368
2236	CASE1765544231068	39	Operations	\N	2025-12-12 12:57:12.889243	2025-12-12 12:57:12.889243
2237	CASE1765544231068	32	Telecaller	\N	2025-12-12 12:57:12.891253	2025-12-12 12:57:12.891253
2235	CASE1765544231068	37	KAM	\N	2025-12-12 12:57:12.88353	2025-12-12 12:57:30.615471
2240	CASE1765776076188	39	Operations	\N	2025-12-15 05:21:17.409825	2025-12-15 05:21:17.409825
2241	CASE1765776076188	32	Telecaller	\N	2025-12-15 05:21:17.411904	2025-12-15 05:21:17.411904
2239	CASE1765776076188	36	KAM	\N	2025-12-15 05:21:17.402761	2025-12-15 05:21:40.95332
2244	CASE1765780648376	39	Operations	\N	2025-12-15 06:37:26.230356	2025-12-15 06:37:26.230356
2245	CASE1765780648376	31	Telecaller	\N	2025-12-15 06:37:26.232388	2025-12-15 06:37:26.232388
2248	CASE1765780742990	31	Telecaller	\N	2025-12-15 06:39:00.541785	2025-12-15 06:39:00.541785
2250	CASE1765780902354	39	Operations	\N	2025-12-15 06:41:39.990992	2025-12-15 06:41:39.990992
2251	CASE1765780902354	31	Telecaller	\N	2025-12-15 06:41:39.993127	2025-12-15 06:41:39.993127
2253	CASE1765781004948	39	Operations	\N	2025-12-15 06:43:22.651789	2025-12-15 06:43:22.651789
2254	CASE1765781004948	31	Telecaller	\N	2025-12-15 06:43:22.653811	2025-12-15 06:43:22.653811
2252	CASE1765781004948	36	KAM	\N	2025-12-15 06:43:22.645897	2025-12-15 06:43:37.55381
2249	CASE1765780902354	37	KAM	\N	2025-12-15 06:41:39.984813	2025-12-15 06:43:51.342138
2246	CASE1765780742990	37	KAM	\N	2025-12-15 06:39:00.533965	2025-12-15 06:44:04.416046
2243	CASE1765780648376	36	KAM	\N	2025-12-15 06:37:26.224092	2025-12-15 06:44:15.886968
2259	CASE1765781122565	37	KAM	\N	2025-12-15 06:45:23.535226	2025-12-15 06:45:23.535226
2260	CASE1765781122565	39	Operations	\N	2025-12-15 06:45:23.540866	2025-12-15 06:45:23.540866
2261	CASE1765781122565	33	Telecaller	\N	2025-12-15 06:45:23.542806	2025-12-15 06:45:23.542806
2202	CASE1765541147781	37	KAM	\N	2025-12-12 12:05:48.404825	2025-12-15 06:54:42.378134
2264	CASE1765781750961	39	Operations	\N	2025-12-15 06:55:47.593023	2025-12-15 06:55:47.593023
2265	CASE1765781750961	30	Telecaller	\N	2025-12-15 06:55:47.595669	2025-12-15 06:55:47.595669
2267	CASE1765781880773	36	KAM	\N	2025-12-15 06:58:01.724076	2025-12-15 06:58:01.724076
2268	CASE1765781880773	39	Operations	\N	2025-12-15 06:58:01.730089	2025-12-15 06:58:01.730089
2269	CASE1765781880773	33	Telecaller	\N	2025-12-15 06:58:01.73211	2025-12-15 06:58:01.73211
2271	CASE1765781901195	39	Operations	\N	2025-12-15 06:58:17.795308	2025-12-15 06:58:17.795308
2272	CASE1765781901195	30	Telecaller	\N	2025-12-15 06:58:17.797323	2025-12-15 06:58:17.797323
2270	CASE1765781901195	35	KAM	\N	2025-12-15 06:58:17.789237	2025-12-15 06:58:33.725745
2274	CASE1765782445782	37	KAM	\N	2025-12-15 07:07:26.789431	2025-12-15 07:07:26.789431
2275	CASE1765782445782	39	Operations	\N	2025-12-15 07:07:26.795714	2025-12-15 07:07:26.795714
2276	CASE1765782445782	33	Telecaller	\N	2025-12-15 07:07:26.797792	2025-12-15 07:07:26.797792
2277	CASE1765782609925	36	KAM	\N	2025-12-15 07:10:10.94634	2025-12-15 07:10:10.94634
2278	CASE1765782609925	39	Operations	\N	2025-12-15 07:10:10.954371	2025-12-15 07:10:10.954371
2279	CASE1765782609925	33	Telecaller	\N	2025-12-15 07:10:10.956493	2025-12-15 07:10:10.956493
2281	CASE1765782821542	39	Operations	\N	2025-12-15 07:13:38.162515	2025-12-15 07:13:38.162515
2282	CASE1765782821542	30	Telecaller	\N	2025-12-15 07:13:38.164548	2025-12-15 07:13:38.164548
2280	CASE1765782821542	35	KAM	\N	2025-12-15 07:13:38.15633	2025-12-15 07:13:59.22025
2285	CASE1765791842740	39	Operations	\N	2025-12-15 09:44:03.854178	2025-12-15 09:44:03.854178
2286	CASE1765791842740	30	Telecaller	\N	2025-12-15 09:44:03.856272	2025-12-15 09:44:03.856272
2370	CASE1765805935611	34	KAM	\N	2025-12-15 13:38:56.438035	2025-12-15 13:38:56.438035
2284	CASE1765791842740	35	KAM	\N	2025-12-15 09:44:03.847782	2025-12-15 10:46:09.443528
2289	CASE1765797390222	34	KAM	\N	2025-12-15 11:16:31.380037	2025-12-15 11:16:31.380037
2290	CASE1765797390222	39	Operations	\N	2025-12-15 11:16:31.38615	2025-12-15 11:16:31.38615
2291	CASE1765797390222	29	Telecaller	\N	2025-12-15 11:16:31.388327	2025-12-15 11:16:31.388327
2292	CASE1765797453989	34	KAM	\N	2025-12-15 11:17:34.836156	2025-12-15 11:17:34.836156
2293	CASE1765797453989	39	Operations	\N	2025-12-15 11:17:34.84249	2025-12-15 11:17:34.84249
2294	CASE1765797453989	29	Telecaller	\N	2025-12-15 11:17:34.844572	2025-12-15 11:17:34.844572
2295	CASE1765797531654	34	KAM	\N	2025-12-15 11:18:52.795828	2025-12-15 11:18:52.795828
2296	CASE1765797531654	39	Operations	\N	2025-12-15 11:18:52.80146	2025-12-15 11:18:52.80146
2297	CASE1765797531654	29	Telecaller	\N	2025-12-15 11:18:52.803504	2025-12-15 11:18:52.803504
2299	CASE1765797992997	39	Operations	\N	2025-12-15 11:26:34.365522	2025-12-15 11:26:34.365522
2300	CASE1765797992997	32	Telecaller	\N	2025-12-15 11:26:34.367569	2025-12-15 11:26:34.367569
2371	CASE1765805935611	39	Operations	\N	2025-12-15 13:38:56.443756	2025-12-15 13:38:56.443756
2298	CASE1765797992997	37	KAM	\N	2025-12-15 11:26:34.35917	2025-12-15 11:27:09.045424
2304	CASE1765798184893	39	Operations	\N	2025-12-15 11:29:46.20141	2025-12-15 11:29:46.20141
2305	CASE1765798184893	32	Telecaller	\N	2025-12-15 11:29:46.203511	2025-12-15 11:29:46.203511
2303	CASE1765798184893	37	KAM	\N	2025-12-15 11:29:46.195489	2025-12-15 11:30:26.695909
2308	CASE1765798256021	39	Operations	\N	2025-12-15 11:30:56.973405	2025-12-15 11:30:56.973405
2309	CASE1765798256021	30	Telecaller	\N	2025-12-15 11:30:56.975508	2025-12-15 11:30:56.975508
2372	CASE1765805935611	29	Telecaller	\N	2025-12-15 13:38:56.445865	2025-12-15 13:38:56.445865
2312	CASE1765798393919	39	Operations	\N	2025-12-15 11:33:15.204628	2025-12-15 11:33:15.204628
2313	CASE1765798393919	32	Telecaller	\N	2025-12-15 11:33:15.206702	2025-12-15 11:33:15.206702
2311	CASE1765798393919	36	KAM	\N	2025-12-15 11:33:15.198546	2025-12-15 11:33:50.929436
2316	CASE1765799504631	39	Operations	\N	2025-12-15 11:51:45.60586	2025-12-15 11:51:45.60586
2317	CASE1765799504631	32	Telecaller	\N	2025-12-15 11:51:45.607905	2025-12-15 11:51:45.607905
2319	CASE1765799518213	39	Operations	\N	2025-12-15 11:51:59.033887	2025-12-15 11:51:59.033887
2320	CASE1765799518213	31	Telecaller	\N	2025-12-15 11:51:59.035899	2025-12-15 11:51:59.035899
2315	CASE1765799504631	37	KAM	\N	2025-12-15 11:51:45.599696	2025-12-15 11:52:02.389907
2318	CASE1765799518213	37	KAM	\N	2025-12-15 11:51:59.028133	2025-12-15 11:52:16.185744
2325	CASE1765799696432	39	Operations	\N	2025-12-15 11:54:57.406796	2025-12-15 11:54:57.406796
2326	CASE1765799696432	32	Telecaller	\N	2025-12-15 11:54:57.408874	2025-12-15 11:54:57.408874
2324	CASE1765799696432	36	KAM	\N	2025-12-15 11:54:57.400762	2025-12-15 11:55:18.318982
2329	CASE1765799895380	39	Operations	\N	2025-12-15 11:58:16.403115	2025-12-15 11:58:16.403115
2330	CASE1765799895380	32	Telecaller	\N	2025-12-15 11:58:16.405138	2025-12-15 11:58:16.405138
2328	CASE1765799895380	36	KAM	\N	2025-12-15 11:58:16.397041	2025-12-15 11:58:38.916889
2307	CASE1765798256021	35	KAM	\N	2025-12-15 11:30:56.967523	2025-12-15 12:29:11.225066
2333	CASE1765805103148	34	KAM	\N	2025-12-15 13:25:03.712199	2025-12-15 13:25:03.712199
2334	CASE1765805103148	39	Operations	\N	2025-12-15 13:25:03.718769	2025-12-15 13:25:03.718769
2335	CASE1765805103148	29	Telecaller	\N	2025-12-15 13:25:03.720838	2025-12-15 13:25:03.720838
2336	CASE1765805145831	34	KAM	\N	2025-12-15 13:25:46.734175	2025-12-15 13:25:46.734175
2337	CASE1765805145831	39	Operations	\N	2025-12-15 13:25:46.740192	2025-12-15 13:25:46.740192
2338	CASE1765805145831	29	Telecaller	\N	2025-12-15 13:25:46.74215	2025-12-15 13:25:46.74215
2339	CASE1765805199116	34	KAM	\N	2025-12-15 13:26:39.661698	2025-12-15 13:26:39.661698
2340	CASE1765805199116	39	Operations	\N	2025-12-15 13:26:39.667523	2025-12-15 13:26:39.667523
2341	CASE1765805199116	29	Telecaller	\N	2025-12-15 13:26:39.66945	2025-12-15 13:26:39.66945
2342	CASE1765805264249	34	KAM	\N	2025-12-15 13:27:45.142196	2025-12-15 13:27:45.142196
2343	CASE1765805264249	39	Operations	\N	2025-12-15 13:27:45.198608	2025-12-15 13:27:45.198608
2344	CASE1765805264249	29	Telecaller	\N	2025-12-15 13:27:45.202588	2025-12-15 13:27:45.202588
2346	CASE1765805317066	34	KAM	\N	2025-12-15 13:28:37.596578	2025-12-15 13:28:37.596578
2347	CASE1765805317066	39	Operations	\N	2025-12-15 13:28:37.602304	2025-12-15 13:28:37.602304
2348	CASE1765805317066	29	Telecaller	\N	2025-12-15 13:28:37.604461	2025-12-15 13:28:37.604461
2349	CASE1765805365766	34	KAM	\N	2025-12-15 13:29:26.602507	2025-12-15 13:29:26.602507
2350	CASE1765805365766	39	Operations	\N	2025-12-15 13:29:26.608408	2025-12-15 13:29:26.608408
2351	CASE1765805365766	29	Telecaller	\N	2025-12-15 13:29:26.610424	2025-12-15 13:29:26.610424
2352	CASE1765805431246	34	KAM	\N	2025-12-15 13:30:32.163566	2025-12-15 13:30:32.163566
2353	CASE1765805431246	39	Operations	\N	2025-12-15 13:30:32.169727	2025-12-15 13:30:32.169727
2354	CASE1765805431246	29	Telecaller	\N	2025-12-15 13:30:32.171807	2025-12-15 13:30:32.171807
2355	CASE1765805483081	34	KAM	\N	2025-12-15 13:31:23.61768	2025-12-15 13:31:23.61768
2356	CASE1765805483081	39	Operations	\N	2025-12-15 13:31:23.624159	2025-12-15 13:31:23.624159
2357	CASE1765805483081	29	Telecaller	\N	2025-12-15 13:31:23.627646	2025-12-15 13:31:23.627646
2358	CASE1765805600647	34	KAM	\N	2025-12-15 13:33:21.833425	2025-12-15 13:33:21.833425
2359	CASE1765805600647	39	Operations	\N	2025-12-15 13:33:21.839205	2025-12-15 13:33:21.839205
2360	CASE1765805600647	29	Telecaller	\N	2025-12-15 13:33:21.841227	2025-12-15 13:33:21.841227
2361	CASE1765805652133	34	KAM	\N	2025-12-15 13:34:12.987314	2025-12-15 13:34:12.987314
2362	CASE1765805652133	39	Operations	\N	2025-12-15 13:34:12.993384	2025-12-15 13:34:12.993384
2363	CASE1765805652133	29	Telecaller	\N	2025-12-15 13:34:12.995426	2025-12-15 13:34:12.995426
2364	CASE1765805708463	34	KAM	\N	2025-12-15 13:35:09.508332	2025-12-15 13:35:09.508332
2365	CASE1765805708463	39	Operations	\N	2025-12-15 13:35:09.514506	2025-12-15 13:35:09.514506
2366	CASE1765805708463	29	Telecaller	\N	2025-12-15 13:35:09.516561	2025-12-15 13:35:09.516561
2367	CASE1765805887695	34	KAM	\N	2025-12-15 13:38:08.885019	2025-12-15 13:38:08.885019
2368	CASE1765805887695	39	Operations	\N	2025-12-15 13:38:08.891235	2025-12-15 13:38:08.891235
2369	CASE1765805887695	29	Telecaller	\N	2025-12-15 13:38:08.893261	2025-12-15 13:38:08.893261
2374	CASE1765806537439	39	Operations	\N	2025-12-15 13:48:01.182749	2025-12-15 13:48:01.182749
2375	CASE1765806537439	30	Telecaller	\N	2025-12-15 13:48:01.184832	2025-12-15 13:48:01.184832
2373	CASE1765806537439	35	KAM	\N	2025-12-15 13:48:01.17626	2025-12-15 13:48:17.769381
2378	CASE1765806706545	39	Operations	\N	2025-12-15 13:50:50.291459	2025-12-15 13:50:50.291459
2379	CASE1765806706545	30	Telecaller	\N	2025-12-15 13:50:50.293488	2025-12-15 13:50:50.293488
2377	CASE1765806706545	35	KAM	\N	2025-12-15 13:50:50.285649	2025-12-15 13:51:01.782038
2382	CASE1765806937224	39	Operations	\N	2025-12-15 13:54:41.009487	2025-12-15 13:54:41.009487
2383	CASE1765806937224	30	Telecaller	\N	2025-12-15 13:54:41.011622	2025-12-15 13:54:41.011622
2381	CASE1765806937224	35	KAM	\N	2025-12-15 13:54:41.002465	2025-12-15 13:55:36.705459
2385	CASE1765808188316	34	KAM	\N	2025-12-15 14:16:29.483441	2025-12-15 14:16:29.483441
2386	CASE1765808188316	39	Operations	\N	2025-12-15 14:16:29.489726	2025-12-15 14:16:29.489726
2387	CASE1765808188316	29	Telecaller	\N	2025-12-15 14:16:29.491981	2025-12-15 14:16:29.491981
2388	CASE1765809134711	34	KAM	\N	2025-12-15 14:32:15.958369	2025-12-15 14:32:15.958369
2389	CASE1765809134711	39	Operations	\N	2025-12-15 14:32:15.964319	2025-12-15 14:32:15.964319
2390	CASE1765809134711	29	Telecaller	\N	2025-12-15 14:32:15.966365	2025-12-15 14:32:15.966365
2641	CASE1766558929074	39	Operations	\N	2025-12-24 06:48:50.063175	2025-12-24 06:48:50.063175
2392	CASE1765863217086	39	Operations	\N	2025-12-16 05:33:38.267474	2025-12-16 05:33:38.267474
2393	CASE1765863217086	29	Telecaller	\N	2025-12-16 05:33:38.269499	2025-12-16 05:33:38.269499
2395	CASE1765867786766	39	Operations	\N	2025-12-16 06:49:47.999616	2025-12-16 06:49:47.999616
2396	CASE1765867786766	32	Telecaller	\N	2025-12-16 06:49:48.002475	2025-12-16 06:49:48.002475
2397	CASE1765867795356	36	KAM	\N	2025-12-16 06:49:55.421875	2025-12-16 06:49:55.421875
2398	CASE1765867795356	39	Operations	\N	2025-12-16 06:49:55.427221	2025-12-16 06:49:55.427221
2399	CASE1765867795356	33	Telecaller	\N	2025-12-16 06:49:55.429276	2025-12-16 06:49:55.429276
2402	CASE1765868100771	39	Operations	\N	2025-12-16 06:55:01.17957	2025-12-16 06:55:01.17957
2403	CASE1765868100771	30	Telecaller	\N	2025-12-16 06:55:01.181999	2025-12-16 06:55:01.181999
2401	CASE1765868100771	35	KAM	\N	2025-12-16 06:55:01.171791	2025-12-16 06:55:17.048966
2406	CASE1765868332721	39	Operations	\N	2025-12-16 06:58:52.502064	2025-12-16 06:58:52.502064
2407	CASE1765868332721	31	Telecaller	\N	2025-12-16 06:58:52.504082	2025-12-16 06:58:52.504082
2405	CASE1765868332721	37	KAM	\N	2025-12-16 06:58:52.495774	2025-12-16 06:59:05.600302
2394	CASE1765867786766	36	KAM	\N	2025-12-16 06:49:47.992356	2025-12-16 07:09:19.863915
2411	CASE1765869207377	39	Operations	\N	2025-12-16 07:13:28.157518	2025-12-16 07:13:28.157518
2412	CASE1765869207377	29	Telecaller	\N	2025-12-16 07:13:28.159522	2025-12-16 07:13:28.159522
2414	CASE1765869773926	39	Operations	\N	2025-12-16 07:22:54.740119	2025-12-16 07:22:54.740119
2415	CASE1765869773926	29	Telecaller	\N	2025-12-16 07:22:54.742165	2025-12-16 07:22:54.742165
2488	CASE1765972205778	39	Operations	\N	2025-12-17 11:50:06.871812	2025-12-17 11:50:06.871812
2489	CASE1765972205778	29	Telecaller	\N	2025-12-17 11:50:06.873932	2025-12-17 11:50:06.873932
2419	CASE1765869821744	39	Operations	\N	2025-12-16 07:23:42.831558	2025-12-16 07:23:42.831558
2420	CASE1765869821744	32	Telecaller	\N	2025-12-16 07:23:42.833636	2025-12-16 07:23:42.833636
2487	CASE1765972205778	47	KAM	\N	2025-12-17 11:50:06.864721	2025-12-17 11:50:40.330017
2418	CASE1765869821744	37	KAM	\N	2025-12-16 07:23:42.826207	2025-12-16 07:24:06.648572
2484	CASE1765972147915	36	KAM	\N	2025-12-17 11:49:08.997322	2025-12-17 11:51:30.728735
2413	CASE1765869773926	34	KAM	\N	2025-12-16 07:22:54.734071	2025-12-16 07:32:30.305973
2410	CASE1765869207377	34	KAM	\N	2025-12-16 07:13:28.151398	2025-12-16 07:32:38.717228
2391	CASE1765863217086	34	KAM	\N	2025-12-16 05:33:38.261081	2025-12-16 07:32:48.932878
2430	CASE1765871860313	39	Operations	\N	2025-12-16 07:57:40.987159	2025-12-16 07:57:40.987159
2431	CASE1765871860313	29	Telecaller	\N	2025-12-16 07:57:40.989202	2025-12-16 07:57:40.989202
2493	CASE1765973513849	39	Operations	\N	2025-12-17 12:11:59.852346	2025-12-17 12:11:59.852346
2494	CASE1765973513849	31	Telecaller	\N	2025-12-17 12:11:59.854505	2025-12-17 12:11:59.854505
2429	CASE1765871860313	34	KAM	\N	2025-12-16 07:57:40.980832	2025-12-16 08:06:07.974323
2436	CASE1765877494508	39	Operations	\N	2025-12-16 09:31:39.177893	2025-12-16 09:31:39.177893
2437	CASE1765877494508	31	Telecaller	\N	2025-12-16 09:31:39.179996	2025-12-16 09:31:39.179996
2435	CASE1765877494508	36	KAM	\N	2025-12-16 09:31:39.171172	2025-12-16 09:41:58.002648
2440	CASE1765878383285	39	Operations	\N	2025-12-16 09:46:23.374477	2025-12-16 09:46:23.374477
2441	CASE1765878383285	33	Telecaller	\N	2025-12-16 09:46:23.376588	2025-12-16 09:46:23.376588
2439	CASE1765878383285	37	KAM	\N	2025-12-16 09:46:23.368066	2025-12-16 09:50:35.274581
2444	CASE1765884689702	39	Operations	\N	2025-12-16 11:31:29.447476	2025-12-16 11:31:29.447476
2445	CASE1765884689702	30	Telecaller	\N	2025-12-16 11:31:29.449377	2025-12-16 11:31:29.449377
2492	CASE1765973513849	37	KAM	\N	2025-12-17 12:11:59.845731	2025-12-17 12:12:13.294982
2448	CASE1765888796146	39	Operations	\N	2025-12-16 12:39:56.8296	2025-12-16 12:39:56.8296
2449	CASE1765888796146	29	Telecaller	\N	2025-12-16 12:39:56.831898	2025-12-16 12:39:56.831898
2447	CASE1765888796146	34	KAM	\N	2025-12-16 12:39:56.823092	2025-12-16 12:43:41.729211
2452	CASE1765953930127	34	KAM	\N	2025-12-17 06:45:31.088145	2025-12-17 06:45:31.088145
2453	CASE1765953930127	39	Operations	\N	2025-12-17 06:45:31.094371	2025-12-17 06:45:31.094371
2454	CASE1765953930127	29	Telecaller	\N	2025-12-17 06:45:31.096411	2025-12-17 06:45:31.096411
2456	CASE1765955160767	39	Operations	\N	2025-12-17 07:06:05.821228	2025-12-17 07:06:05.821228
2457	CASE1765955160767	31	Telecaller	\N	2025-12-17 07:06:05.82325	2025-12-17 07:06:05.82325
2455	CASE1765955160767	36	KAM	\N	2025-12-17 07:06:05.815031	2025-12-17 07:06:28.946987
2460	CASE1765955469368	39	Operations	\N	2025-12-17 07:11:09.20068	2025-12-17 07:11:09.20068
2461	CASE1765955469368	33	Telecaller	\N	2025-12-17 07:11:09.202737	2025-12-17 07:11:09.202737
2463	CASE1765955746080	39	Operations	\N	2025-12-17 07:15:46.9852	2025-12-17 07:15:46.9852
2464	CASE1765955746080	30	Telecaller	\N	2025-12-17 07:15:46.987247	2025-12-17 07:15:46.987247
2462	CASE1765955746080	35	KAM	\N	2025-12-17 07:15:46.978935	2025-12-17 07:16:00.639444
2459	CASE1765955469368	37	KAM	\N	2025-12-17 07:11:09.194398	2025-12-17 07:26:27.067869
2469	CASE1765960294090	39	Operations	\N	2025-12-17 08:31:34.893693	2025-12-17 08:31:34.893693
2470	CASE1765960294090	32	Telecaller	\N	2025-12-17 08:31:34.895767	2025-12-17 08:31:34.895767
2468	CASE1765960294090	36	KAM	\N	2025-12-17 08:31:34.887016	2025-12-17 08:31:54.250225
2473	CASE1765961054261	39	Operations	\N	2025-12-17 08:44:14.287572	2025-12-17 08:44:14.287572
2474	CASE1765961054261	33	Telecaller	\N	2025-12-17 08:44:14.290031	2025-12-17 08:44:14.290031
2472	CASE1765961054261	34	KAM	\N	2025-12-17 08:44:14.281459	2025-12-17 08:50:07.121824
2477	CASE1765966770731	39	Operations	\N	2025-12-17 10:19:36.536511	2025-12-17 10:19:36.536511
2478	CASE1765966770731	31	Telecaller	\N	2025-12-17 10:19:36.538527	2025-12-17 10:19:36.538527
2481	CASE1765968009674	39	Operations	\N	2025-12-17 10:40:10.29859	2025-12-17 10:40:10.29859
2482	CASE1765968009674	30	Telecaller	\N	2025-12-17 10:40:10.300694	2025-12-17 10:40:10.300694
2480	CASE1765968009674	35	KAM	\N	2025-12-17 10:40:10.292156	2025-12-17 10:42:00.274546
2485	CASE1765972147915	39	Operations	\N	2025-12-17 11:49:09.004263	2025-12-17 11:49:09.004263
2486	CASE1765972147915	32	Telecaller	\N	2025-12-17 11:49:09.006452	2025-12-17 11:49:09.006452
2497	CASE1765974676348	39	Operations	\N	2025-12-17 12:31:16.878193	2025-12-17 12:31:16.878193
2498	CASE1765974676348	30	Telecaller	\N	2025-12-17 12:31:16.880148	2025-12-17 12:31:16.880148
2515	CASE1766042983358	39	Operations	\N	2025-12-18 07:29:44.489701	2025-12-18 07:29:44.489701
2502	CASE1766036300240	39	Operations	\N	2025-12-18 05:38:19.688598	2025-12-18 05:38:19.688598
2503	CASE1766036300240	30	Telecaller	\N	2025-12-18 05:38:19.690485	2025-12-18 05:38:19.690485
2501	CASE1766036300240	35	KAM	\N	2025-12-18 05:38:19.682552	2025-12-18 05:38:36.915591
2505	CASE1766040125206	34	KAM	\N	2025-12-18 06:42:06.302049	2025-12-18 06:42:06.302049
2506	CASE1766040125206	39	Operations	\N	2025-12-18 06:42:06.308323	2025-12-18 06:42:06.308323
2507	CASE1766040125206	29	Telecaller	\N	2025-12-18 06:42:06.310326	2025-12-18 06:42:06.310326
2509	CASE1766040156538	39	Operations	\N	2025-12-18 06:42:43.267351	2025-12-18 06:42:43.267351
2510	CASE1766040156538	31	Telecaller	\N	2025-12-18 06:42:43.269327	2025-12-18 06:42:43.269327
2508	CASE1766040156538	36	KAM	\N	2025-12-18 06:42:43.260113	2025-12-18 06:42:56.962846
2496	CASE1765974676348	35	KAM	\N	2025-12-17 12:31:16.871983	2025-12-18 06:54:13.982258
2476	CASE1765966770731	37	KAM	\N	2025-12-17 10:19:36.530271	2025-12-18 07:18:53.31943
2516	CASE1766042983358	33	Telecaller	\N	2025-12-18 07:29:44.491676	2025-12-18 07:29:44.491676
2518	CASE1766050517326	39	Operations	\N	2025-12-18 09:35:18.686301	2025-12-18 09:35:18.686301
2519	CASE1766050517326	32	Telecaller	\N	2025-12-18 09:35:18.68829	2025-12-18 09:35:18.68829
2517	CASE1766050517326	37	KAM	\N	2025-12-18 09:35:18.68007	2025-12-18 09:35:35.248177
2514	CASE1766042983358	37	KAM	\N	2025-12-18 07:29:44.483621	2025-12-18 11:25:36.407891
2522	CASE1766058366830	36	KAM	\N	2025-12-18 11:46:07.773771	2025-12-18 11:46:07.773771
2523	CASE1766058366830	39	Operations	\N	2025-12-18 11:46:07.779939	2025-12-18 11:46:07.779939
2524	CASE1766058366830	33	Telecaller	\N	2025-12-18 11:46:07.781957	2025-12-18 11:46:07.781957
2526	CASE1766123371530	39	Operations	\N	2025-12-19 05:49:32.529325	2025-12-19 05:49:32.529325
2527	CASE1766123371530	32	Telecaller	\N	2025-12-19 05:49:32.531267	2025-12-19 05:49:32.531267
2263	CASE1765781750961	35	KAM	\N	2025-12-15 06:55:47.586945	2025-12-19 05:55:52.352036
2525	CASE1766123371530	36	KAM	\N	2025-12-19 05:49:32.52298	2025-12-19 05:52:15.011609
2531	CASE1766123866517	34	KAM	\N	2025-12-19 05:57:46.974608	2025-12-19 05:57:46.974608
2532	CASE1766123866517	39	Operations	\N	2025-12-19 05:57:46.980996	2025-12-19 05:57:46.980996
2533	CASE1766123866517	29	Telecaller	\N	2025-12-19 05:57:46.982946	2025-12-19 05:57:46.982946
2443	CASE1765884689702	35	KAM	\N	2025-12-16 11:31:29.441769	2025-12-19 06:15:05.841265
2535	CASE1766124521620	39	Operations	\N	2025-12-19 06:08:42.603871	2025-12-19 06:08:42.603871
2536	CASE1766124521620	30	Telecaller	\N	2025-12-19 06:08:42.606754	2025-12-19 06:08:42.606754
2534	CASE1766124521620	35	KAM	\N	2025-12-19 06:08:42.597397	2025-12-19 06:11:50.531767
2539	CASE1766124912325	34	KAM	\N	2025-12-19 06:15:13.227611	2025-12-19 06:15:13.227611
2540	CASE1766124912325	39	Operations	\N	2025-12-19 06:15:13.233161	2025-12-19 06:15:13.233161
2541	CASE1766124912325	29	Telecaller	\N	2025-12-19 06:15:13.235286	2025-12-19 06:15:13.235286
2543	CASE1766125139154	39	Operations	\N	2025-12-19 06:19:00.298756	2025-12-19 06:19:00.298756
2544	CASE1766125139154	31	Telecaller	\N	2025-12-19 06:19:00.301286	2025-12-19 06:19:00.301286
2608	CASE1766404672112	35	KAM	\N	2025-12-22 11:57:52.665316	2025-12-22 12:09:54.966924
2547	CASE1766125172313	39	Operations	\N	2025-12-19 06:19:32.357839	2025-12-19 06:19:32.357839
2548	CASE1766125172313	33	Telecaller	\N	2025-12-19 06:19:32.359865	2025-12-19 06:19:32.359865
2542	CASE1766125139154	36	KAM	\N	2025-12-19 06:19:00.291622	2025-12-19 06:23:07.801087
2611	CASE1766405380422	35	KAM	\N	2025-12-22 12:09:41.023932	2025-12-22 12:10:09.815798
2546	CASE1766125172313	36	KAM	\N	2025-12-19 06:19:32.351942	2025-12-19 06:38:32.334345
2553	CASE1766126514843	39	Operations	\N	2025-12-19 06:41:54.873581	2025-12-19 06:41:54.873581
2554	CASE1766126514843	33	Telecaller	\N	2025-12-19 06:41:54.875563	2025-12-19 06:41:54.875563
2552	CASE1766126514843	37	KAM	\N	2025-12-19 06:41:54.867491	2025-12-19 06:43:31.447075
2556	CASE1766137474018	34	KAM	\N	2025-12-19 09:44:35.080853	2025-12-19 09:44:35.080853
2557	CASE1766137474018	39	Operations	\N	2025-12-19 09:44:35.087255	2025-12-19 09:44:35.087255
2558	CASE1766137474018	29	Telecaller	\N	2025-12-19 09:44:35.089417	2025-12-19 09:44:35.089417
2559	CASE1766142806610	34	KAM	\N	2025-12-19 11:13:27.669669	2025-12-19 11:13:27.669669
2560	CASE1766142806610	39	Operations	\N	2025-12-19 11:13:27.676699	2025-12-19 11:13:27.676699
2561	CASE1766142806610	29	Telecaller	\N	2025-12-19 11:13:27.678855	2025-12-19 11:13:27.678855
2563	CASE1766144009222	39	Operations	\N	2025-12-19 11:33:30.261058	2025-12-19 11:33:30.261058
2564	CASE1766144009222	32	Telecaller	\N	2025-12-19 11:33:30.263046	2025-12-19 11:33:30.263046
2642	CASE1766558929074	33	Telecaller	\N	2025-12-24 06:48:50.065384	2025-12-24 06:48:50.065384
2562	CASE1766144009222	37	KAM	\N	2025-12-19 11:33:30.25503	2025-12-19 11:35:19.712201
2568	CASE1766144563918	39	Operations	\N	2025-12-19 11:42:44.697724	2025-12-19 11:42:44.697724
2569	CASE1766144563918	30	Telecaller	\N	2025-12-19 11:42:44.699597	2025-12-19 11:42:44.699597
2571	CASE1766146196651	34	KAM	\N	2025-12-19 12:09:58.29865	2025-12-19 12:09:58.29865
2572	CASE1766146196651	39	Operations	\N	2025-12-19 12:09:58.305143	2025-12-19 12:09:58.305143
2573	CASE1766146196651	29	Telecaller	\N	2025-12-19 12:09:58.307189	2025-12-19 12:09:58.307189
2567	CASE1766144563918	35	KAM	\N	2025-12-19 11:42:44.691934	2025-12-22 05:30:10.129548
2576	CASE1766385005023	39	Operations	\N	2025-12-22 06:30:06.685378	2025-12-22 06:30:06.685378
2577	CASE1766385005023	30	Telecaller	\N	2025-12-22 06:30:06.687344	2025-12-22 06:30:06.687344
2575	CASE1766385005023	35	KAM	\N	2025-12-22 06:30:06.678341	2025-12-22 06:30:24.499066
2579	CASE1766387768554	34	KAM	\N	2025-12-22 07:16:09.981881	2025-12-22 07:16:09.981881
2580	CASE1766387768554	39	Operations	\N	2025-12-22 07:16:09.988209	2025-12-22 07:16:09.988209
2581	CASE1766387768554	29	Telecaller	\N	2025-12-22 07:16:09.990261	2025-12-22 07:16:09.990261
2583	CASE1766394491531	39	Operations	\N	2025-12-22 09:08:12.503912	2025-12-22 09:08:12.503912
2584	CASE1766394491531	32	Telecaller	\N	2025-12-22 09:08:12.505991	2025-12-22 09:08:12.505991
2651	CASE1766569075779	39	Operations	\N	2025-12-24 09:37:56.534866	2025-12-24 09:37:56.534866
2582	CASE1766394491531	37	KAM	\N	2025-12-22 09:08:12.49775	2025-12-22 09:09:57.687307
2588	CASE1766395058186	39	Operations	\N	2025-12-22 09:17:40.016813	2025-12-22 09:17:40.016813
2589	CASE1766395058186	33	Telecaller	\N	2025-12-22 09:17:40.019254	2025-12-22 09:17:40.019254
2587	CASE1766395058186	37	KAM	\N	2025-12-22 09:17:40.007879	2025-12-22 09:27:32.455562
2592	CASE1766398846008	39	Operations	\N	2025-12-22 10:20:47.031456	2025-12-22 10:20:47.031456
2593	CASE1766398846008	32	Telecaller	\N	2025-12-22 10:20:47.0336	2025-12-22 10:20:47.0336
2652	CASE1766569075779	30	Telecaller	\N	2025-12-24 09:37:56.536863	2025-12-24 09:37:56.536863
2675	CASE1766746452094	35	KAM	\N	2025-12-26 10:54:12.972635	2025-12-26 10:56:53.123588
2596	CASE1766399937938	34	KAM	\N	2025-12-22 10:38:58.907955	2025-12-22 10:38:58.907955
2597	CASE1766399937938	39	Operations	\N	2025-12-22 10:38:58.917967	2025-12-22 10:38:58.917967
2598	CASE1766399937938	29	Telecaller	\N	2025-12-22 10:38:58.920863	2025-12-22 10:38:58.920863
2599	CASE1766399969704	34	KAM	\N	2025-12-22 10:39:31.814861	2025-12-22 10:39:31.814861
2600	CASE1766399969704	39	Operations	\N	2025-12-22 10:39:31.820688	2025-12-22 10:39:31.820688
2601	CASE1766399969704	29	Telecaller	\N	2025-12-22 10:39:31.822634	2025-12-22 10:39:31.822634
2603	CASE1766402098739	39	Operations	\N	2025-12-22 11:14:59.803762	2025-12-22 11:14:59.803762
2604	CASE1766402098739	32	Telecaller	\N	2025-12-22 11:14:59.805888	2025-12-22 11:14:59.805888
2650	CASE1766569075779	35	KAM	\N	2025-12-24 09:37:56.528572	2025-12-24 09:42:22.752049
2602	CASE1766402098739	36	KAM	\N	2025-12-22 11:14:59.797192	2025-12-22 11:16:22.702842
2591	CASE1766398846008	37	KAM	\N	2025-12-22 10:20:47.02511	2025-12-22 11:21:47.703531
2609	CASE1766404672112	39	Operations	\N	2025-12-22 11:57:52.67158	2025-12-22 11:57:52.67158
2610	CASE1766404672112	30	Telecaller	\N	2025-12-22 11:57:52.673649	2025-12-22 11:57:52.673649
2612	CASE1766405380422	39	Operations	\N	2025-12-22 12:09:41.030114	2025-12-22 12:09:41.030114
2613	CASE1766405380422	30	Telecaller	\N	2025-12-22 12:09:41.032158	2025-12-22 12:09:41.032158
2657	CASE1766574714586	32	Telecaller	\N	2025-12-24 11:11:55.278548	2025-12-24 11:11:55.278548
2655	CASE1766574714586	36	KAM	\N	2025-12-24 11:11:55.270406	2025-12-24 11:13:31.786504
2661	CASE1766730842551	39	Operations	\N	2025-12-26 06:34:01.241891	2025-12-26 06:34:01.241891
2662	CASE1766730842551	30	Telecaller	\N	2025-12-26 06:34:01.244043	2025-12-26 06:34:01.244043
2660	CASE1766730842551	35	KAM	\N	2025-12-26 06:34:01.235066	2025-12-26 06:42:02.226476
2664	CASE1766731483043	36	KAM	\N	2025-12-26 06:44:42.982555	2025-12-26 06:44:42.982555
2665	CASE1766731483043	39	Operations	\N	2025-12-26 06:44:42.988701	2025-12-26 06:44:42.988701
2666	CASE1766731483043	33	Telecaller	\N	2025-12-26 06:44:42.99075	2025-12-26 06:44:42.99075
2668	CASE1766732829433	39	Operations	\N	2025-12-26 07:07:10.494335	2025-12-26 07:07:10.494335
2669	CASE1766732829433	31	Telecaller	\N	2025-12-26 07:07:10.496253	2025-12-26 07:07:10.496253
2667	CASE1766732829433	35	KAM	\N	2025-12-26 07:07:10.488306	2025-12-26 07:07:21.499262
2672	CASE1766744912321	39	Operations	\N	2025-12-26 10:28:33.91445	2025-12-26 10:28:33.91445
2673	CASE1766744912321	31	Telecaller	\N	2025-12-26 10:28:33.916426	2025-12-26 10:28:33.916426
2671	CASE1766744912321	35	KAM	\N	2025-12-26 10:28:33.908462	2025-12-26 10:29:17.698958
2676	CASE1766746452094	39	Operations	\N	2025-12-26 10:54:12.978829	2025-12-26 10:54:12.978829
2677	CASE1766746452094	30	Telecaller	\N	2025-12-26 10:54:12.980863	2025-12-26 10:54:12.980863
2678	CASE1766746602117	37	KAM	\N	2025-12-26 10:56:42.177772	2025-12-26 10:56:42.177772
2679	CASE1766746602117	39	Operations	\N	2025-12-26 10:56:42.186001	2025-12-26 10:56:42.186001
2680	CASE1766746602117	33	Telecaller	\N	2025-12-26 10:56:42.188537	2025-12-26 10:56:42.188537
2682	CASE1766747403449	47	KAM	\N	2025-12-26 11:10:03.951784	2025-12-26 11:10:03.951784
2683	CASE1766747403449	39	Operations	\N	2025-12-26 11:10:03.957929	2025-12-26 11:10:03.957929
2684	CASE1766747403449	1	Telecaller	\N	2025-12-26 11:10:03.95994	2025-12-26 11:10:03.95994
2686	CASE1766988143114	39	Operations	\N	2025-12-29 06:02:26.481725	2025-12-29 06:02:26.481725
2687	CASE1766988143114	31	Telecaller	\N	2025-12-29 06:02:26.483786	2025-12-29 06:02:26.483786
2685	CASE1766988143114	35	KAM	\N	2025-12-29 06:02:26.472576	2025-12-29 06:02:55.019978
2690	CASE1766988598289	39	Operations	\N	2025-12-29 06:09:59.666824	2025-12-29 06:09:59.666824
2691	CASE1766988598289	32	Telecaller	\N	2025-12-29 06:09:59.669165	2025-12-29 06:09:59.669165
2694	CASE1766989499319	34	KAM	\N	2025-12-29 06:24:59.468282	2025-12-29 06:24:59.468282
2689	CASE1766988598289	36	KAM	\N	2025-12-29 06:09:59.660595	2025-12-29 06:11:35.52913
2695	CASE1766989499319	39	Operations	\N	2025-12-29 06:24:59.474948	2025-12-29 06:24:59.474948
2696	CASE1766989499319	29	Telecaller	\N	2025-12-29 06:24:59.477256	2025-12-29 06:24:59.477256
2698	CASE1766992073748	39	Operations	\N	2025-12-29 07:07:50.283668	2025-12-29 07:07:50.283668
2699	CASE1766992073748	30	Telecaller	\N	2025-12-29 07:07:50.285633	2025-12-29 07:07:50.285633
2697	CASE1766992073748	35	KAM	\N	2025-12-29 07:07:50.277672	2025-12-29 07:21:05.305746
2701	CASE1766993107450	34	KAM	\N	2025-12-29 07:25:08.546263	2025-12-29 07:25:08.546263
2702	CASE1766993107450	39	Operations	\N	2025-12-29 07:25:08.552514	2025-12-29 07:25:08.552514
2703	CASE1766993107450	29	Telecaller	\N	2025-12-29 07:25:08.554551	2025-12-29 07:25:08.554551
2705	CASE1767077662539	39	Operations	\N	2025-12-30 06:54:22.609966	2025-12-30 06:54:22.609966
2706	CASE1767077662539	30	Telecaller	\N	2025-12-30 06:54:22.612054	2025-12-30 06:54:22.612054
2794	CASE1767355224663	35	KAM	\N	2026-01-02 12:00:26.921423	2026-01-02 12:00:26.921423
2704	CASE1767077662539	35	KAM	\N	2025-12-30 06:54:22.603322	2025-12-30 06:56:47.484851
2709	CASE1767087723662	37	KAM	\N	2025-12-30 09:42:04.16366	2025-12-30 09:42:04.16366
2710	CASE1767087723662	39	Operations	\N	2025-12-30 09:42:04.170102	2025-12-30 09:42:04.170102
2711	CASE1767087723662	33	Telecaller	\N	2025-12-30 09:42:04.172163	2025-12-30 09:42:04.172163
2713	CASE1767087968707	39	Operations	\N	2025-12-30 09:46:10.477104	2025-12-30 09:46:10.477104
2714	CASE1767087968707	32	Telecaller	\N	2025-12-30 09:46:10.479104	2025-12-30 09:46:10.479104
2795	CASE1767355224663	39	Operations	\N	2026-01-02 12:00:26.927769	2026-01-02 12:00:26.927769
2712	CASE1767087968707	37	KAM	\N	2025-12-30 09:46:10.470887	2025-12-30 09:47:56.130744
2718	CASE1767088588360	39	Operations	\N	2025-12-30 09:56:30.054035	2025-12-30 09:56:30.054035
2719	CASE1767088588360	31	Telecaller	\N	2025-12-30 09:56:30.056191	2025-12-30 09:56:30.056191
2722	CASE1767090169643	39	Operations	\N	2025-12-30 10:22:51.365456	2025-12-30 10:22:51.365456
2723	CASE1767090169643	30	Telecaller	\N	2025-12-30 10:22:51.367521	2025-12-30 10:22:51.367521
2721	CASE1767090169643	35	KAM	\N	2025-12-30 10:22:51.359225	2025-12-30 10:23:32.473132
2726	CASE1767163083911	39	Operations	\N	2025-12-31 06:38:05.679129	2025-12-31 06:38:05.679129
2727	CASE1767163083911	32	Telecaller	\N	2025-12-31 06:38:05.681187	2025-12-31 06:38:05.681187
2796	CASE1767355224663	31	Telecaller	\N	2026-01-02 12:00:26.9298	2026-01-02 12:00:26.9298
2725	CASE1767163083911	37	KAM	\N	2025-12-31 06:38:05.672187	2025-12-31 06:40:15.577679
2731	CASE1767163774422	39	Operations	\N	2025-12-31 06:49:35.219678	2025-12-31 06:49:35.219678
2732	CASE1767163774422	33	Telecaller	\N	2025-12-31 06:49:35.221694	2025-12-31 06:49:35.221694
2730	CASE1767163774422	36	KAM	\N	2025-12-31 06:49:35.213358	2025-12-31 06:51:02.548912
2735	CASE1767165539198	39	Operations	\N	2025-12-31 07:19:02.68459	2025-12-31 07:19:02.68459
2736	CASE1767165539198	31	Telecaller	\N	2025-12-31 07:19:02.686838	2025-12-31 07:19:02.686838
2734	CASE1767165539198	35	KAM	\N	2025-12-31 07:19:02.677825	2025-12-31 07:19:27.176585
654	CASE1762840635394	36	KAM	\N	2025-11-11 05:57:15.830238	2025-12-31 09:04:38.133445
2740	CASE1767172063807	39	Operations	\N	2025-12-31 09:07:44.427097	2025-12-31 09:07:44.427097
2741	CASE1767172063807	33	Telecaller	\N	2025-12-31 09:07:44.429217	2025-12-31 09:07:44.429217
2739	CASE1767172063807	37	KAM	\N	2025-12-31 09:07:44.420953	2025-12-31 09:12:23.992843
2744	CASE1767177477882	39	Operations	\N	2025-12-31 10:37:59.239903	2025-12-31 10:37:59.239903
2745	CASE1767177477882	32	Telecaller	\N	2025-12-31 10:37:59.241982	2025-12-31 10:37:59.241982
2797	CASE1767590002853	35	KAM	\N	2026-01-05 05:13:25.127822	2026-01-05 05:13:25.127822
2743	CASE1767177477882	36	KAM	\N	2025-12-31 10:37:59.233604	2025-12-31 10:39:25.354053
2749	CASE1767179852377	39	Operations	\N	2025-12-31 11:17:34.710733	2025-12-31 11:17:34.710733
2750	CASE1767179852377	30	Telecaller	\N	2025-12-31 11:17:34.712801	2025-12-31 11:17:34.712801
2751	CASE1767241771522	34	KAM	\N	2026-01-01 04:29:34.97976	2026-01-01 04:29:34.97976
2752	CASE1767241771522	39	Operations	\N	2026-01-01 04:29:34.986185	2026-01-01 04:29:34.986185
2753	CASE1767241771522	30	Telecaller	\N	2026-01-01 04:29:34.988235	2026-01-01 04:29:34.988235
2754	CASE1767242989155	38	KAM	\N	2026-01-01 04:49:53.155952	2026-01-01 04:49:53.155952
2755	CASE1767242989155	39	Operations	\N	2026-01-01 04:49:53.164284	2026-01-01 04:49:53.164284
2756	CASE1767242989155	30	Telecaller	\N	2026-01-01 04:49:53.166534	2026-01-01 04:49:53.166534
2758	CASE1767331550849	39	Operations	\N	2026-01-02 05:25:52.205299	2026-01-02 05:25:52.205299
2759	CASE1767331550849	32	Telecaller	\N	2026-01-02 05:25:52.207296	2026-01-02 05:25:52.207296
2760	CASE1767331552281	34	KAM	\N	2026-01-02 05:25:53.339132	2026-01-02 05:25:53.339132
2761	CASE1767331552281	39	Operations	\N	2026-01-02 05:25:53.344338	2026-01-02 05:25:53.344338
2762	CASE1767331552281	29	Telecaller	\N	2026-01-02 05:25:53.346365	2026-01-02 05:25:53.346365
2757	CASE1767331550849	36	KAM	\N	2026-01-02 05:25:52.198622	2026-01-02 05:26:58.749486
2765	CASE1767333621957	39	Operations	\N	2026-01-02 06:00:24.14568	2026-01-02 06:00:24.14568
2766	CASE1767333621957	30	Telecaller	\N	2026-01-02 06:00:24.147791	2026-01-02 06:00:24.147791
2748	CASE1767179852377	35	KAM	\N	2025-12-31 11:17:34.704381	2026-01-02 06:00:50.404133
2768	CASE1767335407691	35	KAM	\N	2026-01-02 06:30:10.756167	2026-01-02 06:30:10.756167
2769	CASE1767335407691	39	Operations	\N	2026-01-02 06:30:10.762494	2026-01-02 06:30:10.762494
2770	CASE1767335407691	31	Telecaller	\N	2026-01-02 06:30:10.764509	2026-01-02 06:30:10.764509
2772	CASE1767337052202	39	Operations	\N	2026-01-02 06:57:33.761825	2026-01-02 06:57:33.761825
2773	CASE1767337052202	32	Telecaller	\N	2026-01-02 06:57:33.763753	2026-01-02 06:57:33.763753
2771	CASE1767337052202	37	KAM	\N	2026-01-02 06:57:33.755895	2026-01-02 06:57:47.273748
2775	CASE1767338345580	37	KAM	\N	2026-01-02 07:19:07.537955	2026-01-02 07:19:07.537955
2776	CASE1767338345580	39	Operations	\N	2026-01-02 07:19:07.544349	2026-01-02 07:19:07.544349
2777	CASE1767338345580	33	Telecaller	\N	2026-01-02 07:19:07.546411	2026-01-02 07:19:07.546411
2778	CASE1767341860182	34	KAM	\N	2026-01-02 08:17:40.513432	2026-01-02 08:17:40.513432
2779	CASE1767341860182	39	Operations	\N	2026-01-02 08:17:40.519662	2026-01-02 08:17:40.519662
2780	CASE1767341860182	29	Telecaller	\N	2026-01-02 08:17:40.521596	2026-01-02 08:17:40.521596
2782	CASE1767343930542	39	Operations	\N	2026-01-02 08:52:13.106074	2026-01-02 08:52:13.106074
2783	CASE1767343930542	33	Telecaller	\N	2026-01-02 08:52:13.108209	2026-01-02 08:52:13.108209
2781	CASE1767343930542	36	KAM	\N	2026-01-02 08:52:13.09946	2026-01-02 08:57:21.651395
2785	CASE1767344756304	35	KAM	\N	2026-01-02 09:05:55.23094	2026-01-02 09:05:55.23094
2786	CASE1767344756304	39	Operations	\N	2026-01-02 09:05:55.237316	2026-01-02 09:05:55.237316
2787	CASE1767344756304	30	Telecaller	\N	2026-01-02 09:05:55.239316	2026-01-02 09:05:55.239316
2788	CASE1767348297611	35	KAM	\N	2026-01-02 10:04:59.852049	2026-01-02 10:04:59.852049
2789	CASE1767348297611	39	Operations	\N	2026-01-02 10:04:59.858363	2026-01-02 10:04:59.858363
2790	CASE1767348297611	30	Telecaller	\N	2026-01-02 10:04:59.860428	2026-01-02 10:04:59.860428
2791	CASE1767349903214	35	KAM	\N	2026-01-02 10:31:45.314039	2026-01-02 10:31:45.314039
2792	CASE1767349903214	39	Operations	\N	2026-01-02 10:31:45.320534	2026-01-02 10:31:45.320534
2793	CASE1767349903214	30	Telecaller	\N	2026-01-02 10:31:45.322825	2026-01-02 10:31:45.322825
2798	CASE1767590002853	39	Operations	\N	2026-01-05 05:13:25.136806	2026-01-05 05:13:25.136806
2799	CASE1767590002853	30	Telecaller	\N	2026-01-05 05:13:25.138911	2026-01-05 05:13:25.138911
2800	CASE1767591651178	35	KAM	\N	2026-01-05 05:40:52.901671	2026-01-05 05:40:52.901671
2801	CASE1767591651178	39	Operations	\N	2026-01-05 05:40:52.908268	2026-01-05 05:40:52.908268
2802	CASE1767591651178	30	Telecaller	\N	2026-01-05 05:40:52.910322	2026-01-05 05:40:52.910322
2804	CASE1767593152349	39	Operations	\N	2026-01-05 06:05:53.759275	2026-01-05 06:05:53.759275
2805	CASE1767593152349	32	Telecaller	\N	2026-01-05 06:05:53.76121	2026-01-05 06:05:53.76121
2803	CASE1767593152349	37	KAM	\N	2026-01-05 06:05:53.753077	2026-01-05 06:06:57.346252
2807	CASE1767593432693	34	KAM	\N	2026-01-05 06:10:33.009277	2026-01-05 06:10:33.009277
2808	CASE1767593432693	39	Operations	\N	2026-01-05 06:10:33.016018	2026-01-05 06:10:33.016018
2809	CASE1767593432693	29	Telecaller	\N	2026-01-05 06:10:33.018155	2026-01-05 06:10:33.018155
2811	CASE1767593762406	39	Operations	\N	2026-01-05 06:16:02.607639	2026-01-05 06:16:02.607639
2812	CASE1767593762406	33	Telecaller	\N	2026-01-05 06:16:02.612361	2026-01-05 06:16:02.612361
2810	CASE1767593762406	36	KAM	\N	2026-01-05 06:16:02.601267	2026-01-05 06:17:11.704544
2815	CASE1767593949748	39	Operations	\N	2026-01-05 06:19:11.108728	2026-01-05 06:19:11.108728
2816	CASE1767593949748	30	Telecaller	\N	2026-01-05 06:19:11.110821	2026-01-05 06:19:11.110821
2814	CASE1767593949748	35	KAM	\N	2026-01-05 06:19:11.102734	2026-01-05 06:19:25.561387
2764	CASE1767333621957	35	KAM	\N	2026-01-02 06:00:24.138638	2026-01-05 09:28:02.26153
2717	CASE1767088588360	35	KAM	\N	2025-12-30 09:56:30.047282	2026-01-06 07:14:51.743264
2819	CASE1767594702214	39	Operations	\N	2026-01-05 06:31:43.661279	2026-01-05 06:31:43.661279
2820	CASE1767594702214	32	Telecaller	\N	2026-01-05 06:31:43.665201	2026-01-05 06:31:43.665201
2818	CASE1767594702214	36	KAM	\N	2026-01-05 06:31:43.654616	2026-01-05 06:32:49.325978
2823	CASE1767595807476	39	Operations	\N	2026-01-05 06:50:08.547904	2026-01-05 06:50:08.547904
2824	CASE1767595807476	33	Telecaller	\N	2026-01-05 06:50:08.550813	2026-01-05 06:50:08.550813
2826	CASE1767597155155	47	KAM	\N	2026-01-05 07:12:36.313832	2026-01-05 07:12:36.313832
2827	CASE1767597155155	39	Operations	\N	2026-01-05 07:12:36.319799	2026-01-05 07:12:36.319799
2828	CASE1767597155155	29	Telecaller	\N	2026-01-05 07:12:36.321731	2026-01-05 07:12:36.321731
2829	CASE1767601998038	35	KAM	\N	2026-01-05 08:33:20.400217	2026-01-05 08:33:20.400217
2830	CASE1767601998038	39	Operations	\N	2026-01-05 08:33:20.406342	2026-01-05 08:33:20.406342
2831	CASE1767601998038	30	Telecaller	\N	2026-01-05 08:33:20.408437	2026-01-05 08:33:20.408437
2833	CASE1767607175381	35	KAM	\N	2026-01-05 09:59:38.028258	2026-01-05 09:59:38.028258
2834	CASE1767607175381	39	Operations	\N	2026-01-05 09:59:38.035112	2026-01-05 09:59:38.035112
2835	CASE1767607175381	31	Telecaller	\N	2026-01-05 09:59:38.037322	2026-01-05 09:59:38.037322
2822	CASE1767595807476	37	KAM	\N	2026-01-05 06:50:08.541096	2026-01-05 10:31:17.33443
2838	CASE1767609628698	39	Operations	\N	2026-01-05 10:40:29.801325	2026-01-05 10:40:29.801325
2839	CASE1767609628698	33	Telecaller	\N	2026-01-05 10:40:29.803358	2026-01-05 10:40:29.803358
2837	CASE1767609628698	36	KAM	\N	2026-01-05 10:40:29.794559	2026-01-05 10:42:59.812391
2841	CASE1767610395573	47	KAM	\N	2026-01-05 10:53:16.754972	2026-01-05 10:53:16.754972
2842	CASE1767610395573	39	Operations	\N	2026-01-05 10:53:16.760841	2026-01-05 10:53:16.760841
2843	CASE1767610395573	29	Telecaller	\N	2026-01-05 10:53:16.762797	2026-01-05 10:53:16.762797
2844	CASE1767612203387	37	KAM	\N	2026-01-05 11:23:24.704891	2026-01-05 11:23:24.704891
2845	CASE1767612203387	39	Operations	\N	2026-01-05 11:23:24.711357	2026-01-05 11:23:24.711357
2846	CASE1767612203387	29	Telecaller	\N	2026-01-05 11:23:24.713413	2026-01-05 11:23:24.713413
2847	CASE1767613865308	35	KAM	\N	2026-01-05 11:51:08.481912	2026-01-05 11:51:08.481912
2848	CASE1767613865308	39	Operations	\N	2026-01-05 11:51:08.487995	2026-01-05 11:51:08.487995
2849	CASE1767613865308	31	Telecaller	\N	2026-01-05 11:51:08.490151	2026-01-05 11:51:08.490151
2850	CASE1767675073745	35	KAM	\N	2026-01-06 04:51:17.124713	2026-01-06 04:51:17.124713
2851	CASE1767675073745	39	Operations	\N	2026-01-06 04:51:17.131329	2026-01-06 04:51:17.131329
2852	CASE1767675073745	31	Telecaller	\N	2026-01-06 04:51:17.133412	2026-01-06 04:51:17.133412
2854	CASE1767679468216	39	Operations	\N	2026-01-06 06:04:29.172166	2026-01-06 06:04:29.172166
2855	CASE1767679468216	33	Telecaller	\N	2026-01-06 06:04:29.174141	2026-01-06 06:04:29.174141
2856	CASE1767679706045	35	KAM	\N	2026-01-06 06:08:27.933184	2026-01-06 06:08:27.933184
2857	CASE1767679706045	39	Operations	\N	2026-01-06 06:08:27.9389	2026-01-06 06:08:27.9389
2858	CASE1767679706045	30	Telecaller	\N	2026-01-06 06:08:27.941036	2026-01-06 06:08:27.941036
2853	CASE1767679468216	36	KAM	\N	2026-01-06 06:04:29.166157	2026-01-06 06:10:23.920117
2860	CASE1767680648362	35	KAM	\N	2026-01-06 06:24:12.041241	2026-01-06 06:24:12.041241
2861	CASE1767680648362	39	Operations	\N	2026-01-06 06:24:12.04788	2026-01-06 06:24:12.04788
2862	CASE1767680648362	31	Telecaller	\N	2026-01-06 06:24:12.049955	2026-01-06 06:24:12.049955
2864	CASE1767682841450	39	Operations	\N	2026-01-06 07:00:43.295456	2026-01-06 07:00:43.295456
2865	CASE1767682841450	32	Telecaller	\N	2026-01-06 07:00:43.297503	2026-01-06 07:00:43.297503
2863	CASE1767682841450	36	KAM	\N	2026-01-06 07:00:43.28924	2026-01-06 07:01:54.548543
2869	CASE1767684274406	39	Operations	\N	2026-01-06 07:24:36.349472	2026-01-06 07:24:36.349472
2870	CASE1767684274406	33	Telecaller	\N	2026-01-06 07:24:36.351435	2026-01-06 07:24:36.351435
2868	CASE1767684274406	34	KAM	\N	2026-01-06 07:24:36.343143	2026-01-06 07:26:48.250099
2873	CASE1767689044969	39	Operations	\N	2026-01-06 08:44:06.50259	2026-01-06 08:44:06.50259
2874	CASE1767689044969	33	Telecaller	\N	2026-01-06 08:44:06.505029	2026-01-06 08:44:06.505029
2872	CASE1767689044969	34	KAM	\N	2026-01-06 08:44:06.495688	2026-01-06 08:46:11.815473
2876	CASE1767689524137	35	KAM	\N	2026-01-06 08:52:08.010788	2026-01-06 08:52:08.010788
2877	CASE1767689524137	39	Operations	\N	2026-01-06 08:52:08.017478	2026-01-06 08:52:08.017478
2878	CASE1767689524137	31	Telecaller	\N	2026-01-06 08:52:08.019624	2026-01-06 08:52:08.019624
2879	CASE1767690557871	35	KAM	\N	2026-01-06 09:09:19.299495	2026-01-06 09:09:19.299495
2880	CASE1767690557871	39	Operations	\N	2026-01-06 09:09:19.30574	2026-01-06 09:09:19.30574
2881	CASE1767690557871	30	Telecaller	\N	2026-01-06 09:09:19.307705	2026-01-06 09:09:19.307705
2882	CASE1767692309351	37	KAM	\N	2026-01-06 09:38:30.876865	2026-01-06 09:38:30.876865
2883	CASE1767692309351	39	Operations	\N	2026-01-06 09:38:30.883276	2026-01-06 09:38:30.883276
2884	CASE1767692309351	33	Telecaller	\N	2026-01-06 09:38:30.885353	2026-01-06 09:38:30.885353
2885	CASE1767692365690	34	KAM	\N	2026-01-06 09:39:26.812528	2026-01-06 09:39:26.812528
2886	CASE1767692365690	39	Operations	\N	2026-01-06 09:39:26.818549	2026-01-06 09:39:26.818549
2887	CASE1767692365690	29	Telecaller	\N	2026-01-06 09:39:26.820669	2026-01-06 09:39:26.820669
2888	CASE1767692739556	34	KAM	\N	2026-01-06 09:45:40.632584	2026-01-06 09:45:40.632584
2889	CASE1767692739556	39	Operations	\N	2026-01-06 09:45:40.638609	2026-01-06 09:45:40.638609
2890	CASE1767692739556	29	Telecaller	\N	2026-01-06 09:45:40.640598	2026-01-06 09:45:40.640598
2891	CASE1767693823173	34	KAM	\N	2026-01-06 10:03:44.363355	2026-01-06 10:03:44.363355
2892	CASE1767693823173	39	Operations	\N	2026-01-06 10:03:44.36969	2026-01-06 10:03:44.36969
2893	CASE1767693823173	29	Telecaller	\N	2026-01-06 10:03:44.371762	2026-01-06 10:03:44.371762
2894	CASE1767696138044	34	KAM	\N	2026-01-06 10:42:19.232765	2026-01-06 10:42:19.232765
2895	CASE1767696138044	39	Operations	\N	2026-01-06 10:42:19.238852	2026-01-06 10:42:19.238852
2896	CASE1767696138044	29	Telecaller	\N	2026-01-06 10:42:19.240841	2026-01-06 10:42:19.240841
2897	CASE1767697827356	37	KAM	\N	2026-01-06 11:10:28.465133	2026-01-06 11:10:28.465133
2898	CASE1767697827356	39	Operations	\N	2026-01-06 11:10:28.472167	2026-01-06 11:10:28.472167
2899	CASE1767697827356	29	Telecaller	\N	2026-01-06 11:10:28.474308	2026-01-06 11:10:28.474308
2900	CASE1767702881195	34	KAM	\N	2026-01-06 12:34:42.36515	2026-01-06 12:34:42.36515
2901	CASE1767702881195	39	Operations	\N	2026-01-06 12:34:42.373521	2026-01-06 12:34:42.373521
2902	CASE1767702881195	29	Telecaller	\N	2026-01-06 12:34:42.376218	2026-01-06 12:34:42.376218
2903	CASE1767764174464	35	KAM	\N	2026-01-07 05:36:13.969538	2026-01-07 05:36:13.969538
2904	CASE1767764174464	39	Operations	\N	2026-01-07 05:36:13.975795	2026-01-07 05:36:13.975795
2905	CASE1767764174464	30	Telecaller	\N	2026-01-07 05:36:13.977842	2026-01-07 05:36:13.977842
2907	CASE1767765282525	39	Operations	\N	2026-01-07 05:54:42.87612	2026-01-07 05:54:42.87612
2908	CASE1767765282525	33	Telecaller	\N	2026-01-07 05:54:42.878075	2026-01-07 05:54:42.878075
2906	CASE1767765282525	37	KAM	\N	2026-01-07 05:54:42.870116	2026-01-07 05:57:24.517955
2910	CASE1767765524344	35	KAM	\N	2026-01-07 05:58:44.617271	2026-01-07 05:58:44.617271
2911	CASE1767765524344	39	Operations	\N	2026-01-07 05:58:44.623006	2026-01-07 05:58:44.623006
2912	CASE1767765524344	30	Telecaller	\N	2026-01-07 05:58:44.625027	2026-01-07 05:58:44.625027
2914	CASE1767766580242	39	Operations	\N	2026-01-07 06:16:21.474111	2026-01-07 06:16:21.474111
2915	CASE1767766580242	32	Telecaller	\N	2026-01-07 06:16:21.476068	2026-01-07 06:16:21.476068
2913	CASE1767766580242	36	KAM	\N	2026-01-07 06:16:21.467829	2026-01-07 06:17:28.332422
2918	CASE1767767426172	39	Operations	\N	2026-01-07 06:30:27.496982	2026-01-07 06:30:27.496982
2919	CASE1767767426172	33	Telecaller	\N	2026-01-07 06:30:27.499047	2026-01-07 06:30:27.499047
2917	CASE1767767426172	36	KAM	\N	2026-01-07 06:30:27.490398	2026-01-07 13:00:34.401318
2922	CASE1767776191203	39	Operations	\N	2026-01-07 08:56:32.518545	2026-01-07 08:56:32.518545
2923	CASE1767776191203	33	Telecaller	\N	2026-01-07 08:56:32.520618	2026-01-07 08:56:32.520618
2926	CASE1767777447471	35	KAM	\N	2026-01-07 09:17:29.234841	2026-01-07 09:17:29.234841
2921	CASE1767776191203	37	KAM	\N	2026-01-07 08:56:32.511863	2026-01-07 09:00:17.872532
2927	CASE1767777447471	39	Operations	\N	2026-01-07 09:17:29.241317	2026-01-07 09:17:29.241317
2928	CASE1767777447471	31	Telecaller	\N	2026-01-07 09:17:29.243382	2026-01-07 09:17:29.243382
2930	CASE1767780407690	39	Operations	\N	2026-01-07 10:06:49.448122	2026-01-07 10:06:49.448122
2931	CASE1767780407690	32	Telecaller	\N	2026-01-07 10:06:49.450301	2026-01-07 10:06:49.450301
2929	CASE1767780407690	36	KAM	\N	2026-01-07 10:06:49.441655	2026-01-07 10:08:09.769979
2936	CASE1767783712290	39	Operations	\N	2026-01-07 11:01:54.553306	2026-01-07 11:01:54.553306
2937	CASE1767783712290	32	Telecaller	\N	2026-01-07 11:01:54.555448	2026-01-07 11:01:54.555448
2935	CASE1767783712290	37	KAM	\N	2026-01-07 11:01:54.546721	2026-01-07 11:03:11.226439
2940	CASE1767849871347	35	KAM	\N	2026-01-08 05:24:34.715395	2026-01-08 05:24:34.715395
2941	CASE1767849871347	39	Operations	\N	2026-01-08 05:24:34.721765	2026-01-08 05:24:34.721765
2942	CASE1767849871347	30	Telecaller	\N	2026-01-08 05:24:34.723776	2026-01-08 05:24:34.723776
2944	CASE1767851581547	39	Operations	\N	2026-01-08 05:53:04.655328	2026-01-08 05:53:04.655328
2945	CASE1767851581547	31	Telecaller	\N	2026-01-08 05:53:04.657427	2026-01-08 05:53:04.657427
2947	CASE1767853363206	39	Operations	\N	2026-01-08 06:22:45.733613	2026-01-08 06:22:45.733613
2948	CASE1767853363206	31	Telecaller	\N	2026-01-08 06:22:45.735687	2026-01-08 06:22:45.735687
2943	CASE1767851581547	35	KAM	\N	2026-01-08 05:53:04.648777	2026-01-08 06:25:22.122706
2951	CASE1767854708605	39	Operations	\N	2026-01-08 06:45:10.319275	2026-01-08 06:45:10.319275
2952	CASE1767854708605	32	Telecaller	\N	2026-01-08 06:45:10.321283	2026-01-08 06:45:10.321283
2950	CASE1767854708605	36	KAM	\N	2026-01-08 06:45:10.312853	2026-01-08 06:46:32.090045
2946	CASE1767853363206	35	KAM	\N	2026-01-08 06:22:45.726893	2026-01-08 07:26:24.89988
2955	CASE1767863067753	35	KAM	\N	2026-01-08 09:04:32.769793	2026-01-08 09:04:32.769793
2956	CASE1767863067753	39	Operations	\N	2026-01-08 09:04:32.776179	2026-01-08 09:04:32.776179
2957	CASE1767863067753	30	Telecaller	\N	2026-01-08 09:04:32.778229	2026-01-08 09:04:32.778229
2959	CASE1767870273043	39	Operations	\N	2026-01-08 11:04:34.654488	2026-01-08 11:04:34.654488
2960	CASE1767870273043	33	Telecaller	\N	2026-01-08 11:04:34.656598	2026-01-08 11:04:34.656598
2958	CASE1767870273043	36	KAM	\N	2026-01-08 11:04:34.647776	2026-01-08 11:05:47.553298
2963	CASE1767938577183	39	Operations	\N	2026-01-09 06:02:58.2362	2026-01-09 06:02:58.2362
2964	CASE1767938577183	32	Telecaller	\N	2026-01-09 06:02:58.238291	2026-01-09 06:02:58.238291
2962	CASE1767938577183	36	KAM	\N	2026-01-09 06:02:58.22633	2026-01-09 06:04:11.472381
2966	CASE1767950089584	35	KAM	\N	2026-01-09 09:14:52.310024	2026-01-09 09:14:52.310024
2967	CASE1767950089584	39	Operations	\N	2026-01-09 09:14:52.316562	2026-01-09 09:14:52.316562
2968	CASE1767950089584	30	Telecaller	\N	2026-01-09 09:14:52.318619	2026-01-09 09:14:52.318619
2969	CASE1767950333036	35	KAM	\N	2026-01-09 09:18:55.923564	2026-01-09 09:18:55.923564
2970	CASE1767950333036	39	Operations	\N	2026-01-09 09:18:55.929537	2026-01-09 09:18:55.929537
2971	CASE1767950333036	31	Telecaller	\N	2026-01-09 09:18:55.931565	2026-01-09 09:18:55.931565
2973	CASE1767954139374	39	Operations	\N	2026-01-09 10:22:20.701365	2026-01-09 10:22:20.701365
2974	CASE1767954139374	33	Telecaller	\N	2026-01-09 10:22:20.703531	2026-01-09 10:22:20.703531
2972	CASE1767954139374	37	KAM	\N	2026-01-09 10:22:20.69498	2026-01-09 13:02:43.071197
\.


--
-- Data for Name: case_product_requirements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.case_product_requirements (id, caseid, productname, requirement_amount, description, created_at, updated_at) FROM stdin;
1	CASE1764765294809	LAP	200000000	\N	2025-12-04 11:19:48.252408	2026-01-10 06:23:37.484937
2	CASE1763618269726	WC	60000000	\N	2025-11-29 07:12:40.251982	2026-01-10 06:23:37.484937
3	CASE1763542082443	WC	1000000000	\N	2025-12-29 10:02:07.068468	2026-01-10 06:23:37.484937
4	CASE1764401064872	BL	100000000	\N	2025-12-29 09:51:15.159944	2026-01-10 06:23:37.484937
5	CASE1762839001224	BL	1	\N	2025-12-15 14:18:36.223996	2026-01-10 06:23:37.484937
6	CASE1765798256021	WC	250000000	\N	2025-12-29 09:42:30.997739	2026-01-10 06:23:37.484937
7	CASE1762835526007	BL	1	\N	2025-12-16 11:48:55.534393	2026-01-10 06:23:37.484937
8	CASE1762836019957	BL	10000000	\N	2025-11-29 06:21:26.27532	2026-01-10 06:23:37.484937
9	CASE1764402666075	WC	100000000	\N	2025-12-29 09:59:35.405589	2026-01-10 06:23:37.484937
10	CASE1765542471523	BL	50000000	\N	2025-12-12 12:51:01.120542	2026-01-10 06:23:37.484937
11	CASE1765452417328	OD	100000000	\N	2025-12-17 12:10:29.54386	2026-01-10 06:23:37.484937
12	CASE1762753606380	Machinery funding upto 7cr	10000000	\N	2025-11-29 13:29:22.827	2026-01-10 06:23:37.484937
13	CASE1762257883874	BL	0	\N	2025-11-29 06:36:37.495294	2026-01-10 06:23:37.484937
14	CASE1761978382155	BL	1000000	\N	2025-11-29 06:34:07.059214	2026-01-10 06:23:37.484937
15	CASE1762837414827	small LAP - upto 7cr	70000000	\N	2025-12-29 10:04:30.62615	2026-01-10 06:23:37.484937
16	CASE1762249044960	BL	1	\N	2025-12-16 11:46:37.112172	2026-01-10 06:23:37.484937
17	CASE1762840525206	BL	5000000	\N	2025-11-29 05:12:16.703789	2026-01-10 06:23:37.484937
18	CASE1763542475926	BL	1	\N	2025-12-16 11:36:20.809142	2026-01-10 06:23:37.484937
19	CASE1764401080828	WC	600000000	\N	2025-12-29 10:01:19.727494	2026-01-10 06:23:37.484937
20	CASE1762838589367	BL	1	\N	2025-12-15 14:18:59.341065	2026-01-10 06:23:37.484937
21	CASE1764401238989	SECURED	50000000	\N	2025-12-29 09:52:36.47594	2026-01-10 06:23:37.484937
22	CASE1762839927486	WC	1	\N	2025-12-15 14:27:13.246835	2026-01-10 06:23:37.484937
23	CASE1764403492004	WC	300000000	\N	2025-12-11 13:19:05.960299	2026-01-10 06:23:37.484937
24	CASE1764403476101	LAP	150000000	\N	2025-12-01 08:04:15.343803	2026-01-10 06:23:37.484937
25	CASE1764401583687	WC	1000000000	\N	2025-12-29 09:53:28.473126	2026-01-10 06:23:37.484937
26	CASE1764419655103	LAP	100000000	\N	2025-12-01 05:06:35.442226	2026-01-10 06:23:37.484937
27	CASE1764403601606	LAP	150000000	\N	2025-12-01 08:04:03.165897	2026-01-10 06:23:37.484937
28	CASE1767697827356	Real Estate Assest. Management Company	40	\N	2026-01-07 04:58:37.977852	2026-01-10 06:23:37.484937
29	CASE1764421035350	BANK GURANTEE	10000000	\N	2025-12-01 05:23:40.496494	2026-01-10 06:23:37.484937
30	CASE1763542676760	BL	1	\N	2025-11-29 06:36:45.096041	2026-01-10 06:23:37.484937
31	CASE1764419755394	LAP	200000000	\N	2025-12-01 04:50:51.934239	2026-01-10 06:23:37.484937
32	CASE1762838320280	BL	1	\N	2025-11-29 06:27:00.950863	2026-01-10 06:23:37.484937
33	CASE1766744912321	Bill discoutning	15000000	\N	2025-12-30 04:54:46.73569	2026-01-10 06:23:37.484937
34	CASE1762838444569	BL	1	\N	2025-12-16 11:37:17.210338	2026-01-10 06:23:37.484937
35	CASE1762580970506	BL	1	\N	2025-12-16 11:48:45.021169	2026-01-10 06:23:37.484937
36	CASE1762838801310	Small LAP upto 7CR	1	\N	2025-12-15 14:18:50.45495	2026-01-10 06:23:37.484937
37	CASE1762837859229	BL	1	\N	2025-12-16 11:38:51.36528	2026-01-10 06:23:37.484937
38	CASE1764397511816	LAP	500000000	\N	2025-12-15 12:47:03.655063	2026-01-10 06:23:37.484937
39	CASE1762837109762	small LAP - upto 7cr	10000000	\N	2025-12-18 04:44:56.155531	2026-01-10 06:23:37.484937
40	CASE1762346321840	BL	0	\N	2025-11-29 06:37:31.092383	2026-01-10 06:23:37.484937
41	CASE1761979443916	BL	150000000	\N	2025-11-05 04:38:53.326013	2026-01-10 06:23:37.484937
42	CASE1765517825133	WC	2500000	\N	2025-12-29 09:56:33.315092	2026-01-10 06:23:37.484937
43	CASE1767612203387	Real Estate Assest. Management Company	3	\N	2026-01-06 04:29:27.509746	2026-01-10 06:23:37.484937
44	CASE1766730842551	SME	50000000	\N	2026-01-02 04:57:46.831454	2026-01-10 06:23:37.484937
45	CASE1766125172313	WC - 20CR	200000000	\N	2025-12-26 09:13:37.187287	2026-01-10 06:23:37.484937
46	CASE1764420646573	LAP	10000000	\N	2025-12-01 05:05:16.808844	2026-01-10 06:23:37.484937
47	CASE1762840077981	BL	50000000	\N	2025-11-29 07:04:54.729726	2026-01-10 06:23:37.484937
48	CASE1762840983637	BL	2000000	\N	2025-11-29 05:14:46.66936	2026-01-10 06:23:37.484937
49	CASE1764403012771	PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)	40000000	\N	2025-12-29 09:44:51.893228	2026-01-10 06:23:37.484937
50	CASE1764402001664	LAP	10000000	\N	2025-12-31 12:14:25.165292	2026-01-10 06:23:37.484937
51	CASE1763187103363	WC	500000000	\N	2025-11-29 07:03:22.661765	2026-01-10 06:23:37.484937
52	CASE1762835661410	BL	30000000	\N	2025-11-21 12:17:53.88765	2026-01-10 06:23:37.484937
53	CASE1762841987974	BL	0	\N	2025-11-29 06:26:28.55228	2026-01-10 06:23:37.484937
54	CASE1762841872228	BL	1	\N	2025-12-15 14:24:24.008683	2026-01-10 06:23:37.484937
55	CASE1762843138846	Small LAP - upto 5CR	1	\N	2025-12-15 14:23:46.45944	2026-01-10 06:23:37.484937
56	CASE1762425626265	WC	100000000	\N	2025-11-29 06:32:48.04161	2026-01-10 06:23:37.484937
57	CASE1762428558548	BL	200000000	\N	2025-11-06 11:32:23.199663	2026-01-10 06:23:37.484937
58	CASE1763961487013	BL	3500000	\N	2025-11-29 06:37:30.399085	2026-01-10 06:23:37.484937
59	CASE1764402687733	WC	80000000	\N	2025-12-11 13:22:00.731922	2026-01-10 06:23:37.484937
60	CASE1767601998038	Construction Finance	1000000000	\N	2026-01-06 12:43:09.16723	2026-01-10 06:23:37.484937
61	CASE1762838931738	BL	0	\N	2025-11-29 06:35:13.516367	2026-01-10 06:23:37.484937
62	CASE1762845923683	BL	1	\N	2025-12-15 14:22:26.29234	2026-01-10 06:23:37.484937
63	CASE1765805708463	LAP	7000000	\N	2025-12-15 14:20:54.293945	2026-01-10 06:23:37.484937
64	CASE1764402218280	WC	30000000	\N	2025-12-15 12:25:52.240072	2026-01-10 06:23:37.484937
65	CASE1765799696432	BL	7000000000	\N	2025-12-17 06:36:28.295741	2026-01-10 06:23:37.484937
66	CASE1764420512032	WC	15000000	\N	2025-12-01 12:30:56.860197	2026-01-10 06:23:37.484937
67	CASE1764405764801	WC	200000000	\N	2025-12-01 08:01:22.651664	2026-01-10 06:23:37.484937
68	CASE1764758265597	Bill discoutning	100000000	\N	2025-12-29 10:06:35.091125	2026-01-10 06:23:37.484937
69	CASE1765780742990	LAP	30	\N	2025-12-18 04:34:37.873688	2026-01-10 06:23:37.484937
70	CASE1764402288049	LAP	10000000	\N	2025-12-15 12:06:23.667108	2026-01-10 06:23:37.484937
71	CASE1764759245269	OD	1000000	\N	2025-12-03 12:07:23.203194	2026-01-10 06:23:37.484937
72	CASE1761977532523	BL	1	\N	2025-12-16 11:45:53.660361	2026-01-10 06:23:37.484937
73	CASE1762414031380	BL	5000000	\N	2025-11-29 07:19:47.954773	2026-01-10 06:23:37.484937
74	CASE1764402966570	LAP	300000000	\N	2025-12-04 04:47:59.93416	2026-01-10 06:23:37.484937
75	CASE1764765397812	WC	1	\N	2025-12-15 14:19:45.604259	2026-01-10 06:23:37.484937
76	CASE1764401456648	WC	800000000	\N	2025-12-08 10:40:42.189513	2026-01-10 06:23:37.484937
77	CASE1762842911935	Machinery funding upto 7cr	1	\N	2025-12-15 14:23:56.927144	2026-01-10 06:23:37.484937
78	CASE1764322859980	OD	750000000	\N	2025-11-29 13:16:52.400036	2026-01-10 06:23:37.484937
79	CASE1764419924041	BL	500000000	\N	2025-12-29 09:43:17.397429	2026-01-10 06:23:37.484937
80	CASE1762839819406	BL	1	\N	2025-12-15 14:27:21.813287	2026-01-10 06:23:37.484937
81	CASE1764420063211	WC	1200000000	\N	2025-12-29 09:57:32.587341	2026-01-10 06:23:37.484937
82	CASE1762839304365	BL	1	\N	2025-12-15 14:28:09.077907	2026-01-10 06:23:37.484937
83	CASE1764420658463	Machinery funding upto 7cr	50000000	\N	2025-12-01 05:06:17.927743	2026-01-10 06:23:37.484937
84	CASE1762839307825	WC	1	\N	2025-12-29 09:54:56.617633	2026-01-10 06:23:37.484937
85	CASE1762837620495	Small LAP upto 7CR	1	\N	2025-12-16 11:39:11.438763	2026-01-10 06:23:37.484937
86	CASE1762840090042	BL	1	\N	2025-12-17 09:16:16.854881	2026-01-10 06:23:37.484937
87	CASE1766407652250	LAP	500000000	\N	2025-12-29 09:40:43.914815	2026-01-10 06:23:37.484937
88	CASE1762247921899	Private Equity (75cr - 1000cr)	500000000	\N	2025-12-15 12:24:40.46176	2026-01-10 06:23:37.484937
89	CASE1764418867359	LAP	400000000	\N	2025-12-15 11:57:54.204685	2026-01-10 06:23:37.484937
90	CASE1764398447312	PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)	50000000	\N	2025-12-15 12:30:58.322695	2026-01-10 06:23:37.484937
91	CASE1762842917468	OD	1	\N	2025-11-29 06:45:07.103921	2026-01-10 06:23:37.484937
92	CASE1767590002853	BL	100000000	\N	2026-01-06 12:43:45.931033	2026-01-10 06:23:37.484937
93	CASE1767692309351	Real Estate Assest. Management Company	70	\N	2026-01-07 09:28:21.059557	2026-01-10 06:23:37.484937
94	CASE1762846378686	OD	250000000	\N	2025-12-29 10:02:26.047027	2026-01-10 06:23:37.484937
95	CASE1764418618914	Private Credit and Secure Lending (100cr to 1000cr)	500000000	\N	2025-12-15 12:27:17.616857	2026-01-10 06:23:37.484937
96	CASE1765369604671	WC	40	\N	2025-12-16 11:28:55.832772	2026-01-10 06:23:37.484937
97	CASE1762840210341	BL	5000000	\N	2025-12-01 13:30:01.877519	2026-01-10 06:23:37.484937
98	CASE1762428638541	Small LAP upto 7CR	800000000	\N	2025-11-07 06:51:56.055956	2026-01-10 06:23:37.484937
99	CASE1762843384332	BL	1	\N	2025-12-15 14:23:27.902193	2026-01-10 06:23:37.484937
100	CASE1764418327230	LAP	150000000	\N	2025-12-11 13:17:45.15272	2026-01-10 06:23:37.484937
101	CASE1764402574087	WC	250000000	\N	2025-12-29 09:59:46.692437	2026-01-10 06:23:37.484937
102	CASE1762839104555	BL	1	\N	2025-12-15 14:28:27.049461	2026-01-10 06:23:37.484937
103	CASE1762840635394	BL	0	\N	2025-12-31 09:04:38.117514	2026-01-10 06:23:37.484937
104	CASE1767355224663	BILL DISCOUNTING,UNSECURED FUNDING	100000000	\N	2026-01-05 12:29:36.357418	2026-01-10 06:23:37.484937
105	CASE1765797531654	LAP	50000000	\N	2025-12-16 13:05:17.086861	2026-01-10 06:23:37.484937
106	CASE1764421093546	WC	100000000	\N	2025-12-01 05:22:02.705071	2026-01-10 06:23:37.484937
107	CASE1765285368534	WC	30000000	\N	2025-12-10 11:04:11.935447	2026-01-10 06:23:37.484937
108	CASE1764399864948	BANK GURANTEE	50000000	\N	2025-11-29 13:25:14.543474	2026-01-10 06:23:37.484937
109	CASE1764419986719	LAP	80000000	\N	2025-12-29 09:57:40.692606	2026-01-10 06:23:37.484937
110	CASE1762839103794	small LAP - upto 7cr	50000000	\N	2025-11-29 06:28:49.407022	2026-01-10 06:23:37.484937
111	CASE1762835719858	BL	500000000	\N	2025-11-29 06:31:00.151797	2026-01-10 06:23:37.484937
112	CASE1762837520722	BL	10000000	\N	2025-11-28 05:05:40.169075	2026-01-10 06:23:37.484937
113	CASE1762753646383	WC	1000000000	\N	2025-11-29 06:31:37.226431	2026-01-10 06:23:37.484937
114	CASE1766405380422	CGTMSE	10000000	\N	2025-12-31 12:10:04.524545	2026-01-10 06:23:37.484937
115	CASE1764759080426	Machinery funding upto 7cr	150000000	\N	2025-12-03 11:40:59.546319	2026-01-10 06:23:37.484937
116	CASE1764404355328	WC	600000000	\N	2025-12-01 08:03:48.647724	2026-01-10 06:23:37.484937
117	CASE1764400133429	BANK GURANTEE	50000000	\N	2025-11-29 13:24:11.144404	2026-01-10 06:23:37.484937
118	CASE1764401244052	UNSECURED & SECURED OD	500000000	\N	2025-12-15 13:28:16.388	2026-01-10 06:23:37.484937
119	CASE1764402358583	LAP	50000000	\N	2025-12-15 12:06:11.341424	2026-01-10 06:23:37.484937
120	CASE1764420999210	LAP	10000000	\N	2025-12-08 05:18:27.477209	2026-01-10 06:23:37.484937
121	CASE1762837899223	OD	20000000	\N	2025-11-29 06:30:04.710435	2026-01-10 06:23:37.484937
122	CASE1765806937224	WC	10000000	\N	2025-12-22 12:37:22.037111	2026-01-10 06:23:37.484937
123	CASE1764136624464	Machinery funding upto 7cr	200000000	\N	2025-11-29 06:12:17.446946	2026-01-10 06:23:37.484937
124	CASE1764585167172	LAP	20000000	\N	2025-12-01 12:01:43.172555	2026-01-10 06:23:37.484937
125	CASE1762835826376	BL	1	\N	2025-12-16 11:49:14.39889	2026-01-10 06:23:37.484937
126	CASE1764418937576	Secured LAP	100000000	\N	2025-12-15 11:57:37.968641	2026-01-10 06:23:37.484937
127	CASE1761910298881	Small LAP upto 7CR	1	\N	2025-12-16 11:45:39.769474	2026-01-10 06:23:37.484937
128	CASE1763186948340	Small LAP upto 7CR	40000000	\N	2025-11-29 07:03:35.863867	2026-01-10 06:23:37.484937
129	CASE1764400993387	LAP	40000000	\N	2025-12-15 12:19:29.307373	2026-01-10 06:23:37.484937
130	CASE1763714634849	Small LAP - upto 5CR	35000000	\N	2025-11-29 07:02:30.534706	2026-01-10 06:23:37.484937
131	CASE1764420194165	WC	10000000	\N	2025-12-29 09:57:59.056632	2026-01-10 06:23:37.484937
132	CASE1763370420586	WC	1	\N	2025-11-29 06:36:16.442719	2026-01-10 06:23:37.484937
133	CASE1766125139154	MACHINERY FUNDING	250000000	\N	2025-12-22 12:18:59.771427	2026-01-10 06:23:37.484937
134	CASE1765781880773	BL	30000000	\N	2025-12-15 12:16:56.694813	2026-01-10 06:23:37.484937
135	CASE1762838587556	BL	1200000	\N	2025-12-08 15:11:55.411977	2026-01-10 06:23:37.484937
136	CASE1765972205778	Bill discoutning	500000000	\N	2026-01-02 07:34:21.609258	2026-01-10 06:23:37.484937
137	CASE1764401619661	WC	300000000	\N	2025-12-29 09:45:30.584126	2026-01-10 06:23:37.484937
138	CASE1762841256000	BL	2000000	\N	2025-11-29 05:14:27.501949	2026-01-10 06:23:37.484937
139	CASE1762837275126	Small LAP - upto 5CR	20000000	\N	2025-11-29 06:16:31.89055	2026-01-10 06:23:37.484937
140	CASE1763708290628	WC	1	\N	2025-12-16 11:34:11.893345	2026-01-10 06:23:37.484937
141	CASE1762836402193	BL	1	\N	2025-12-16 11:40:53.009678	2026-01-10 06:23:37.484937
142	CASE1764403114252	BL	1000000000	\N	2025-12-11 13:21:11.183133	2026-01-10 06:23:37.484937
143	CASE1762839184224	BL	1	\N	2025-12-15 14:28:18.777322	2026-01-10 06:23:37.484937
144	CASE1764401671008	WC	200000000	\N	2025-12-01 08:04:58.693395	2026-01-10 06:23:37.484937
145	CASE1764397958287	LAP	50000000	\N	2025-12-15 12:21:38.908854	2026-01-10 06:23:37.484937
146	CASE1765871860313	BANK GURANTEE	10000000	\N	2025-12-18 10:29:07.063167	2026-01-10 06:23:37.484937
147	CASE1762845744485	BL	1	\N	2025-12-15 14:22:44.660809	2026-01-10 06:23:37.484937
148	CASE1762857249375	BL	0	\N	2025-11-29 06:26:09.093588	2026-01-10 06:23:37.484937
149	CASE1764403803238	BL	100000000	\N	2025-12-11 13:18:32.990238	2026-01-10 06:23:37.484937
150	CASE1764401564061	WC	300000000	\N	2025-12-15 12:17:00.138479	2026-01-10 06:23:37.484937
151	CASE1761910111749	WC	30000000	\N	2025-12-15 13:23:29.573	2026-01-10 06:23:37.484937
152	CASE1762837335105	BL	0	\N	2025-12-16 11:51:13.463215	2026-01-10 06:23:37.484937
153	CASE1762838034709	BL	1	\N	2025-12-16 11:38:20.371249	2026-01-10 06:23:37.484937
154	CASE1762145457677	small LAP - upto 7cr	0	\N	2025-11-29 06:37:18.417652	2026-01-10 06:23:37.484937
155	CASE1763717344445	BL	1	\N	2025-12-16 11:34:00.126304	2026-01-10 06:23:37.484937
156	CASE1762838356178	BL	0	\N	2025-11-29 06:36:00.735349	2026-01-10 06:23:37.484937
157	CASE1763702492835	BL	60000000	\N	2025-11-29 07:11:08.575922	2026-01-10 06:23:37.484937
158	CASE1763442861051	WC	10000000	\N	2025-11-29 06:36:25.381367	2026-01-10 06:23:37.484937
159	CASE1764065401623	BL	30000000	\N	2025-11-29 07:02:00.229691	2026-01-10 06:23:37.484937
160	CASE1764237339048	Secured LAP	900000000	\N	2025-11-29 07:01:10.590927	2026-01-10 06:23:37.484937
161	CASE1765781004948	Bill discoutning	100000000	\N	2025-12-17 06:38:38.107563	2026-01-10 06:23:37.484937
162	CASE1764402245387	WC	300000000	\N	2025-12-01 08:04:50.417592	2026-01-10 06:23:37.484937
163	CASE1764420696817	BL	5000000	\N	2025-12-08 15:02:34.164857	2026-01-10 06:23:37.484937
164	CASE1762839508375	BL	0	\N	2025-11-29 06:42:16.357107	2026-01-10 06:23:37.484937
165	CASE1765805935611	LAP	50000000	\N	2025-12-15 14:19:51.473201	2026-01-10 06:23:37.484937
166	CASE1764418481981	Secured LAP	100000000	\N	2025-12-03 06:01:32.44736	2026-01-10 06:23:37.484937
167	CASE1762839915087	BL	0	\N	2025-11-29 06:27:41.297451	2026-01-10 06:23:37.484937
168	CASE1762257392648	BL	1	\N	2025-12-16 11:48:14.080586	2026-01-10 06:23:37.484937
169	CASE1763973936989	BL	1	\N	2025-11-29 06:37:23.646849	2026-01-10 06:23:37.484937
170	CASE1764401308743	LAP	1000000000	\N	2025-12-29 09:45:45.064105	2026-01-10 06:23:37.484937
171	CASE1762836399409	BL	0	\N	2025-11-29 06:37:49.330224	2026-01-10 06:23:37.484937
172	CASE1763186683929	WC	40000000	\N	2025-12-08 15:08:37.266712	2026-01-10 06:23:37.484937
173	CASE1763372371236	BL	80000000	\N	2025-11-29 06:25:11.173976	2026-01-10 06:23:37.484937
174	CASE1762146702285	BL	1	\N	2025-11-29 06:34:14.617748	2026-01-10 06:23:37.484937
175	CASE1763368979329	BL	1	\N	2025-11-29 06:35:59.68155	2026-01-10 06:23:37.484937
176	CASE1762837371975	WC	20000000	\N	2025-12-01 13:29:42.475846	2026-01-10 06:23:37.484937
177	CASE1762231819322	small LAP - upto 7cr	30000000	\N	2025-11-29 06:36:23.27066	2026-01-10 06:23:37.484937
178	CASE1763442514766	Small LAP - upto 5CR	20000000	\N	2025-12-29 10:01:58.42093	2026-01-10 06:23:37.484937
179	CASE1763451322432	BL	40	\N	2025-12-15 14:25:18.62918	2026-01-10 06:23:37.484937
180	CASE1764402510984	WC	350000000	\N	2025-12-29 09:59:56.219742	2026-01-10 06:23:37.484937
181	CASE1764419234382	LAP	10000000	\N	2025-12-08 10:21:59.527019	2026-01-10 06:23:37.484937
182	CASE1764419171180	WC	50000000	\N	2025-12-01 04:59:49.302319	2026-01-10 06:23:37.484937
183	CASE1765955469368	WC,LAP,NCD(ABOVE 8CR),UNSECURED FUNDING UPTO 75CR,CHANNEL FINANCE,AIF,PMS	150000000	\N	2025-12-29 09:40:58.245865	2026-01-10 06:23:37.484937
184	CASE1762839385207	BL	0	\N	2025-11-29 06:28:26.365577	2026-01-10 06:23:37.484937
185	CASE1762839734700	BL	1	\N	2025-12-15 14:27:30.820766	2026-01-10 06:23:37.484937
186	CASE1764420309445	BL	10000000	\N	2025-12-01 04:48:13.536288	2026-01-10 06:23:37.484937
187	CASE1764758921219	BL	50	\N	2025-12-15 14:20:42.380145	2026-01-10 06:23:37.484937
188	CASE1764420902424	BL	5000000	\N	2025-12-01 12:36:55.878637	2026-01-10 06:23:37.484937
189	CASE1762843909171	BL	1	\N	2025-12-15 14:23:10.722179	2026-01-10 06:23:37.484937
190	CASE1762837499901	BL	2000000	\N	2025-11-29 05:11:46.455619	2026-01-10 06:23:37.484937
191	CASE1764420087778	WC	10000000	\N	2025-12-29 09:57:21.231276	2026-01-10 06:23:37.484937
192	CASE1762837053506	Machinery funding upto 7cr	10000000	\N	2025-11-29 06:24:36.549401	2026-01-10 06:23:37.484937
193	CASE1763185803230	small LAP - upto 7cr	40000000	\N	2025-11-29 07:04:09.077397	2026-01-10 06:23:37.484937
194	CASE1762837105115	BL	1	\N	2025-12-16 11:40:04.782058	2026-01-10 06:23:37.484937
195	CASE1762428745324	BL	0	\N	2025-11-29 06:32:20.743948	2026-01-10 06:23:37.484937
196	CASE1762838419599	BL	1	\N	2025-11-28 05:11:13.533644	2026-01-10 06:23:37.484937
197	CASE1762839957202	BL	50000000	\N	2025-11-29 06:27:24.661961	2026-01-10 06:23:37.484937
198	CASE1764398094112	OD	20000000	\N	2025-11-29 12:06:56.401377	2026-01-10 06:23:37.484937
199	CASE1764400707502	WC	4000000	\N	2025-12-29 09:53:44.552172	2026-01-10 06:23:37.484937
200	CASE1764758563126	NCD,BILL DISCOUNTING ,UNSECURED ,5CR IN 1 TRANCH	1500000000	\N	2025-12-17 12:09:18.055862	2026-01-10 06:23:37.484937
201	CASE1767593762406	UNSECURED & SECURED OD	150000000	\N	2026-01-05 12:04:40.736593	2026-01-10 06:23:37.484937
202	CASE1764401687030	LAP	100000000	\N	2025-12-15 12:16:45.129097	2026-01-10 06:23:37.484937
203	CASE1765369465418	OD	150000000	\N	2025-12-11 09:32:59.531029	2026-01-10 06:23:37.484937
204	CASE1766123866517	LAP	3000000	\N	2025-12-22 12:57:51.073057	2026-01-10 06:23:37.484937
205	CASE1766482376257	LAP	30000000	\N	2025-12-31 12:09:50.187632	2026-01-10 06:23:37.484937
206	CASE1763185986592	BL	50000000	\N	2025-12-29 09:54:29.184139	2026-01-10 06:23:37.484937
207	CASE1764402752496	WC	100000000	\N	2025-12-01 07:56:14.181528	2026-01-10 06:23:37.484937
208	CASE1763640521596	BL	20000000	\N	2025-11-29 07:11:45.260516	2026-01-10 06:23:37.484937
209	CASE1764305260862	BL	30000000	\N	2025-12-08 12:30:05.243062	2026-01-10 06:23:37.484937
210	CASE1762838665957	BL	0	\N	2025-11-29 06:35:48.387149	2026-01-10 06:23:37.484937
211	CASE1762346413807	WC	4000000000	\N	2025-11-21 12:06:45.170902	2026-01-10 06:23:37.484937
212	CASE1762836984464	BL	0	\N	2025-11-29 06:40:53.228897	2026-01-10 06:23:37.484937
213	CASE1762837578102	OD	100000000	\N	2025-11-29 06:23:37.26297	2026-01-10 06:23:37.484937
214	CASE1762588856050	BL	1	\N	2025-11-29 06:35:25.370615	2026-01-10 06:23:37.484937
215	CASE1764404230572	WC	100000000	\N	2025-12-29 09:58:11.655667	2026-01-10 06:23:37.484937
216	CASE1764420450010	LAP	100000000	\N	2025-12-01 13:28:41.946014	2026-01-10 06:23:37.484937
217	CASE1763702198816	WC	5	\N	2025-11-29 06:36:54.904199	2026-01-10 06:23:37.484937
218	CASE1762837124187	small LAP - upto 7cr	220000000	\N	2025-11-29 06:33:26.36201	2026-01-10 06:23:37.484937
219	CASE1762837917691	Small LAP upto 7cr	1	\N	2025-12-16 11:38:43.62815	2026-01-10 06:23:37.484937
220	CASE1762839185573	small LAP - upto 7cr	20000000	\N	2025-12-29 10:02:32.390188	2026-01-10 06:23:37.484937
221	CASE1762836379252	small LAP - upto 7cr	1	\N	2025-12-16 11:40:47.073665	2026-01-10 06:23:37.484937
222	CASE1762841277799	BL	0	\N	2025-11-29 06:35:00.237776	2026-01-10 06:23:37.484937
223	CASE1765869821744	WC	60	\N	2025-12-26 11:43:38.619397	2026-01-10 06:23:37.484937
224	CASE1762844229667	BL	1	\N	2025-12-15 14:23:02.663003	2026-01-10 06:23:37.484937
225	CASE1762249679995	OD	100000000	\N	2025-11-29 13:33:04.588582	2026-01-10 06:23:37.484937
226	CASE1767593949748	Construction Finance	1500000000	\N	2026-01-06 12:43:29.035769	2026-01-10 06:23:37.484937
227	CASE1765961054261	BL	50000000	\N	2025-12-18 10:28:24.298998	2026-01-10 06:23:37.484937
228	CASE1764400948936	OD	49000000	\N	2025-12-29 09:52:52.351944	2026-01-10 06:23:37.484937
229	CASE1764401024408	Private Credit (NCD, Secure Lending ) 50cr to 1000cr	50000000	\N	2025-12-01 07:51:33.228346	2026-01-10 06:23:37.484937
230	CASE1764422503150	WC	500000000	\N	2025-12-20 09:56:44.50646	2026-01-10 06:23:37.484937
231	CASE1762839684196	BL	1	\N	2025-12-15 14:27:40.458005	2026-01-10 06:23:37.484937
232	CASE1762840615660	OD	10000000	\N	2025-11-29 06:41:29.320628	2026-01-10 06:23:37.484937
233	CASE1762581369675	BL	70000000	\N	2025-11-29 07:19:24.328335	2026-01-10 06:23:37.484937
234	CASE1764420250070	LAP	12500000	\N	2025-12-29 09:56:58.722104	2026-01-10 06:23:37.484937
235	CASE1762836213700	BL	1	\N	2025-12-16 11:50:40.38449	2026-01-10 06:23:37.484937
236	CASE1763185646398	WC	20000000	\N	2025-11-29 07:04:23.611668	2026-01-10 06:23:37.484937
237	CASE1761904567946	Small LAP - upto 5CR	5000000	\N	2025-11-29 06:34:36.215763	2026-01-10 06:23:37.484937
238	CASE1767343930542	BL	15000000	\N	2026-01-07 04:57:26.293537	2026-01-10 06:23:37.484937
239	CASE1762838234335	BL	1	\N	2025-12-16 11:51:32.686902	2026-01-10 06:23:37.484937
240	CASE1764419024198	BANK GURANTEE	10000000	\N	2025-12-31 12:12:49.325109	2026-01-10 06:23:37.484937
241	CASE1763708523280	LAP	40000000	\N	2025-12-01 10:03:24.706428	2026-01-10 06:23:37.484937
242	CASE1764400962688	Private Credit (NCD, Secure Lending ) 50cr to 1000cr	50000000	\N	2025-12-29 10:01:39.305748	2026-01-10 06:23:37.484937
243	CASE1764847094848	WC	20000000	\N	2025-12-05 11:18:29.984454	2026-01-10 06:23:37.484937
244	CASE1763542806642	Small LAP - upto 5CR	40000000	\N	2025-11-29 07:02:56.884191	2026-01-10 06:23:37.484937
245	CASE1764419541526	SECURED	350000000	\N	2025-12-01 04:53:43.175251	2026-01-10 06:23:37.484937
246	CASE1764402879354	LAP UPTO 50CR.	3500000000	\N	2025-12-29 09:59:16.196229	2026-01-10 06:23:37.484937
247	CASE1762839387128	small LAP - upto 7cr	150000000	\N	2025-11-29 06:11:50.637157	2026-01-10 06:23:37.484937
248	CASE1764421233518	WC	250000000	\N	2025-12-29 09:57:47.111314	2026-01-10 06:23:37.484937
249	CASE1764420443807	LAP	150000000	\N	2025-12-01 04:47:54.388298	2026-01-10 06:23:37.484937
250	CASE1762836004507	BL	1	\N	2025-12-16 11:49:22.972539	2026-01-10 06:23:37.484937
251	CASE1766569075779	BANK GURANTEE	50000000	\N	2025-12-30 04:55:32.768634	2026-01-10 06:23:37.484937
252	CASE1763554564523	WC	1000000000	\N	2025-11-29 06:58:13.022817	2026-01-10 06:23:37.484937
253	CASE1764403113981	small LAP - upto 7cr	40000000	\N	2025-12-01 08:04:07.801373	2026-01-10 06:23:37.484937
254	CASE1762837235453	WC	80000000	\N	2025-11-29 06:30:37.814608	2026-01-10 06:23:37.484937
255	CASE1766126514843	MACHINERY FUNDING	10000000	\N	2025-12-22 10:28:29.449349	2026-01-10 06:23:37.484937
256	CASE1762836738117	BL	1	\N	2025-12-16 11:40:12.346032	2026-01-10 06:23:37.484937
257	CASE1762839244514	BL	0	\N	2025-11-29 06:28:34.543198	2026-01-10 06:23:37.484937
258	CASE1764418874859	BL	100000000	\N	2025-12-01 12:31:55.905037	2026-01-10 06:23:37.484937
259	CASE1764052495073	WC	60000000	\N	2025-11-29 07:00:59.879883	2026-01-10 06:23:37.484937
260	CASE1764420766374	WC	20000000	\N	2025-12-01 13:31:52.921641	2026-01-10 06:23:37.484937
261	CASE1764403929506	WC	50000000	\N	2025-12-11 13:18:17.475918	2026-01-10 06:23:37.484937
262	CASE1762756077071	BL	1	\N	2025-11-29 07:16:16.119943	2026-01-10 06:23:37.484937
263	CASE1762837439358	BL	1	\N	2025-12-16 11:39:49.24693	2026-01-10 06:23:37.484937
264	CASE1762845471662	Small LAP upto 7cr	1	\N	2025-12-15 14:22:36.421189	2026-01-10 06:23:37.484937
265	CASE1762836549855	Small LAP upto 7CR	1	\N	2025-12-16 11:40:20.355445	2026-01-10 06:23:37.484937
266	CASE1763961482563	BL	3500000	\N	2025-12-15 12:23:16.535093	2026-01-10 06:23:37.484937
267	CASE1765867795356	BL	1	\N	2025-12-26 11:43:32.627802	2026-01-10 06:23:37.484937
268	CASE1764403219320	WC	450000000	\N	2025-12-29 09:44:29.382631	2026-01-10 06:23:37.484937
269	CASE1764420182973	LAP	50000000	\N	2025-12-31 12:12:29.754652	2026-01-10 06:23:37.484937
270	CASE1762858802202	BL	12000000	\N	2025-11-29 07:04:42.690599	2026-01-10 06:23:37.484937
271	CASE1762838049088	BL	4500000	\N	2025-11-29 06:29:38.429063	2026-01-10 06:23:37.484937
272	CASE1762322142972	BL	1	\N	2025-12-16 11:48:28.369033	2026-01-10 06:23:37.484937
273	CASE1765884689702	BL	20000000	\N	2025-12-19 06:15:05.835479	2026-01-10 06:23:37.484937
274	CASE1762839665865	BL	0	\N	2025-11-29 06:28:06.811155	2026-01-10 06:23:37.484937
275	CASE1762842152318	small LAP - upto 7cr	1	\N	2025-11-29 06:34:24.831574	2026-01-10 06:23:37.484937
276	CASE1764418950129	LAP	100000000	\N	2025-12-01 12:31:38.335504	2026-01-10 06:23:37.484937
277	CASE1764402887918	WC	300000000	\N	2025-12-11 13:21:36.117249	2026-01-10 06:23:37.484937
278	CASE1762837712030	BL	0	\N	2025-11-29 06:36:20.458368	2026-01-10 06:23:37.484937
279	CASE1763961873906	BL	0	\N	2025-11-29 06:23:51.834035	2026-01-10 06:23:37.484937
280	CASE1764418982578	WC	150000000	\N	2025-12-01 12:31:18.538383	2026-01-10 06:23:37.484937
281	CASE1763542084786	Machinery funding upto 7cr	1	\N	2025-11-29 06:39:12.698637	2026-01-10 06:23:37.484937
282	CASE1766402098739	OD	30000000	\N	2025-12-24 10:51:19.283412	2026-01-10 06:23:37.484937
283	CASE1764418541962	Real Estate Assest. Management Company	50000000	\N	2025-12-29 09:43:44.508361	2026-01-10 06:23:37.484937
284	CASE1764403066579	UNSECURED & SECURED OD	200000000	\N	2025-12-29 09:59:02.577257	2026-01-10 06:23:37.484937
285	CASE1762148391654	BL	1	\N	2025-12-16 11:46:10.387086	2026-01-10 06:23:37.484937
286	CASE1765781122565	LAP	20000000	\N	2025-12-15 11:56:34.408353	2026-01-10 06:23:37.484937
287	CASE1762834354822	small LAP - upto 7cr	200000000	\N	2025-12-29 10:04:40.812158	2026-01-10 06:23:37.484937
288	CASE1767609628698	BL	15000000	\N	2026-01-06 10:08:21.21065	2026-01-10 06:23:37.484937
289	CASE1764419721175	LAP	10000000	\N	2025-12-15 11:23:23.558607	2026-01-10 06:23:37.484937
290	CASE1762838267468	BL	1	\N	2025-12-16 11:37:43.677086	2026-01-10 06:23:37.484937
291	CASE1766144563918	WC	20000000	\N	2025-12-22 12:35:17.408941	2026-01-10 06:23:37.484937
292	CASE1764924175994	OD	20000000	\N	2025-12-08 11:09:01.740391	2026-01-10 06:23:37.484937
293	CASE1764402574717	CGTMSE	50000000	\N	2025-12-15 12:05:41.205447	2026-01-10 06:23:37.484937
294	CASE1763534794920	WC	150000000	\N	2025-11-29 07:15:43.758252	2026-01-10 06:23:37.484937
295	CASE1762838066302	BL	1	\N	2025-12-16 11:38:04.856853	2026-01-10 06:23:37.484937
296	CASE1762836724833	BL	1	\N	2025-12-16 11:51:01.106575	2026-01-10 06:23:37.484937
297	CASE1766385005023	BL	50000000	\N	2025-12-22 12:34:58.286134	2026-01-10 06:23:37.484937
298	CASE1762838692597	small LAP - upto 7cr	1	\N	2025-12-15 14:29:40.388812	2026-01-10 06:23:37.484937
299	CASE1764758733768	LAP	70000000	\N	2025-12-29 09:56:43.720158	2026-01-10 06:23:37.484937
300	CASE1762839773376	BL	0	\N	2025-11-29 06:27:49.901856	2026-01-10 06:23:37.484937
301	CASE1764421818016	BL	5000000	\N	2025-12-04 04:39:41.426547	2026-01-10 06:23:37.484937
302	CASE1762838073669	BL	1	\N	2025-12-16 11:51:25.927733	2026-01-10 06:23:37.484937
303	CASE1762496116023	WC	2000000	\N	2025-11-29 07:05:06.855094	2026-01-10 06:23:37.484937
304	CASE1763369621865	WC	1000000000	\N	2025-11-29 06:18:42.402644	2026-01-10 06:23:37.484937
305	CASE1767594702214	OD	10000000	\N	2026-01-06 11:05:16.384718	2026-01-10 06:23:37.484937
306	CASE1764393663992	WC	750000000	\N	2025-12-15 12:22:10.486069	2026-01-10 06:23:37.484937
307	CASE1766142806610	LAP	30000000	\N	2025-12-22 12:56:58.906836	2026-01-10 06:23:37.484937
308	CASE1764402810649	WC	700000000	\N	2025-12-29 09:59:21.387045	2026-01-10 06:23:37.484937
309	CASE1764401783731	WC	500000000	\N	2025-12-29 10:00:18.865826	2026-01-10 06:23:37.484937
310	CASE1764064444019	BL	30000000	\N	2025-11-29 07:02:12.449887	2026-01-10 06:23:37.484937
311	CASE1764419528742	LAP	100000000	\N	2025-12-01 04:54:09.285365	2026-01-10 06:23:37.484937
312	CASE1762836174853	BL	5000000	\N	2025-12-08 12:20:24.911104	2026-01-10 06:23:37.484937
313	CASE1763370566141	OD	15000000	\N	2025-12-29 10:02:15.355512	2026-01-10 06:23:37.484937
314	CASE1762843142249	BL	1	\N	2025-12-15 14:26:33.918796	2026-01-10 06:23:37.484937
315	CASE1762836537215	BL	1	\N	2025-12-16 11:40:28.136241	2026-01-10 06:23:37.484937
316	CASE1764419414576	LAP	250000000	\N	2025-12-15 12:25:10.294948	2026-01-10 06:23:37.484937
317	CASE1762841792863	BL	8000000	\N	2025-11-21 12:13:37.560519	2026-01-10 06:23:37.484937
318	CASE1762840077926	WC	1	\N	2025-12-15 14:26:50.405822	2026-01-10 06:23:37.484937
319	CASE1762838515302	BL	0	\N	2025-11-29 06:35:55.615307	2026-01-10 06:23:37.484937
320	CASE1766988143114	OD	1000000	\N	2025-12-30 09:03:01.867614	2026-01-10 06:23:37.484937
321	CASE1763544129762	WC	60000000	\N	2025-12-08 15:07:20.83168	2026-01-10 06:23:37.484937
322	CASE1763618459035	BL	1	\N	2025-12-16 11:34:40.377417	2026-01-10 06:23:37.484937
323	CASE1762339872019	Small LAP - upto 5CR	20000000	\N	2025-11-29 06:33:34.73196	2026-01-10 06:23:37.484937
324	CASE1762838202548	BL	1	\N	2025-12-16 11:37:58.217105	2026-01-10 06:23:37.484937
325	CASE1764420561995	BL	5000000	\N	2025-12-01 05:05:47.150339	2026-01-10 06:23:37.484937
326	CASE1762838265880	small LAP - upto 7cr	1	\N	2025-12-16 11:37:50.478567	2026-01-10 06:23:37.484937
327	CASE1763973946337	WC	300000000	\N	2025-11-29 07:01:48.835348	2026-01-10 06:23:37.484937
328	CASE1763973948471	BL	1	\N	2025-11-29 06:37:38.012227	2026-01-10 06:23:37.484937
329	CASE1764403446118	LAP	80000000	\N	2025-12-11 13:19:28.859329	2026-01-10 06:23:37.484937
330	CASE1765782609925	Bill discoutning	10000000	\N	2025-12-17 06:38:06.239124	2026-01-10 06:23:37.484937
331	CASE1764404023674	PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)	150000000	\N	2025-12-15 12:25:36.885259	2026-01-10 06:23:37.484937
332	CASE1764403067551	LAP	10000000	\N	2025-12-15 11:59:12.411243	2026-01-10 06:23:37.484937
333	CASE1764830414143	BL	5000000	\N	2025-12-08 11:54:43.386758	2026-01-10 06:23:37.484937
334	CASE1764420876643	BL	30000000	\N	2025-12-01 13:32:12.537819	2026-01-10 06:23:37.484937
335	CASE1764402003625	WC	300000000	\N	2025-12-29 10:00:08.658277	2026-01-10 06:23:37.484937
336	CASE1762838228852	BL	0	\N	2025-11-29 06:36:12.265222	2026-01-10 06:23:37.484937
337	CASE1762836735232	BL	0	\N	2025-11-29 06:38:05.017152	2026-01-10 06:23:37.484937
338	CASE1763369623343	WC	600000000	\N	2025-11-19 08:59:57.535271	2026-01-10 06:23:37.484937
339	CASE1762856134388	Small LAP - upto 5CR	1	\N	2025-12-15 14:25:39.030219	2026-01-10 06:23:37.484937
340	CASE1764403718264	LAP	130000000	\N	2025-12-29 09:58:53.51664	2026-01-10 06:23:37.484937
341	CASE1762840663805	BL	3000000	\N	2025-11-29 12:08:04.475387	2026-01-10 06:23:37.484937
342	CASE1767077662539	NCD,PRIVATE EQUITY,STOCKS,MUTUAL FUND	200000000	\N	2026-01-02 04:54:46.096115	2026-01-10 06:23:37.484937
343	CASE1764403715806	WC	330000000	\N	2025-12-29 09:44:08.793283	2026-01-10 06:23:37.484937
344	CASE1763442727419	Machinery funding upto 7cr	20000000	\N	2025-11-29 07:17:25.823146	2026-01-10 06:23:37.484937
345	CASE1764401841000	WC	12000000000	\N	2025-12-29 09:53:06.261661	2026-01-10 06:23:37.484937
346	CASE1764405423550	WC	1000000000	\N	2025-12-01 08:01:08.269395	2026-01-10 06:23:37.484937
347	CASE1762839165909	small LAP - upto 7cr	1	\N	2025-12-29 10:02:44.075325	2026-01-10 06:23:37.484937
348	CASE1764401143706	LAP	70000000	\N	2025-12-29 09:50:57.420147	2026-01-10 06:23:37.484937
349	CASE1762838563629	small LAP - upto 7cr	1	\N	2025-12-16 11:37:10.629246	2026-01-10 06:23:37.484937
350	CASE1762836582698	BL	0	\N	2025-11-29 06:37:58.554192	2026-01-10 06:23:37.484937
351	CASE1763442996709	BL	1	\N	2025-12-15 14:25:10.463526	2026-01-10 06:23:37.484937
352	CASE1764402474550	WC	85000000	\N	2025-12-29 09:45:13.488642	2026-01-10 06:23:37.484937
353	CASE1762495682299	BL	5000000	\N	2025-11-29 07:05:20.005558	2026-01-10 06:23:37.484937
354	CASE1763704870223	Secured LAP	1	\N	2025-12-16 11:34:27.400269	2026-01-10 06:23:37.484937
355	CASE1764573615748	WC	30000000	\N	2025-12-08 14:59:47.362519	2026-01-10 06:23:37.484937
356	CASE1761977530872	WC	30000000	\N	2025-11-29 06:19:01.653969	2026-01-10 06:23:37.484937
357	CASE1765799895380	OD	65000000	\N	2025-12-17 06:36:00.7117	2026-01-10 06:23:37.484937
358	CASE1765544103935	LAP	25000000	\N	2025-12-15 14:11:12.630143	2026-01-10 06:23:37.484937
359	CASE1762837751316	BL	1	\N	2025-12-16 11:39:06.310098	2026-01-10 06:23:37.484937
360	CASE1762842910656	Small LAP upto 7cr	1	\N	2025-12-15 14:24:05.614346	2026-01-10 06:23:37.484937
361	CASE1762753729616	WC	300000000	\N	2025-11-29 06:31:22.238299	2026-01-10 06:23:37.484937
362	CASE1761910299582	WC	50000000	\N	2025-11-29 06:34:23.688	2026-01-10 06:23:37.484937
363	CASE1764324178635	BANK GURANTEE	50000000	\N	2025-12-01 13:27:27.740201	2026-01-10 06:23:37.484937
364	CASE1762841324795	WC	5000000	\N	2025-11-29 06:19:48.120558	2026-01-10 06:23:37.484937
365	CASE1766747403449	Bill discoutning	100000000	\N	2026-01-02 07:34:38.757819	2026-01-10 06:23:37.484937
386	CASE1767702881195	Machinery funding upto 7cr	100001	This is requirement details...	2026-01-23 13:39:35.519746	2026-01-23 13:39:35.519746
387	CASE1767702881195	OD	5000	This is requirement details...	2026-01-23 13:39:35.526503	2026-01-23 13:39:35.526503
\.


--
-- Data for Name: case_stages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.case_stages (id, caseid, stage, status, updated_by, updated_at) FROM stdin;
\.


--
-- Data for Name: cases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cases (id, caseid, companyname, clientname, role, status, createdby, productname, assigned_to_name, assignee, stage, bankname, updatedat, spocname, spocemail, spocphonenumber, leadsource, date, "time", phonenumber, turnover, location, companyemail, createddate, assigneddate, requirement_amount, status_updated_on, meeting_done_date) FROM stdin;
7	CASE1761978382155	Shri Vaishnavi Retail India LLP	Aftab CFO	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:34:07.059214				Prema	2025-11-03	11:00	9966002843	50-100cr	Hyderabad	\N	2025-11-01 06:26:22.314	2025-11-01 06:26:22.314	1000000	2025-11-29 06:34:07.059214	\N
5	CASE1761977530872	VICTOR LUXURY LUMIOUNISE PVT.LTD	Dinesh -MD	Telecaller	Documentation Initiated	31	WC	\N	\N	\N	\N	2025-11-29 06:19:01.653969				Mounika	2025-11-04	13:00	8977520890	25-50cr	https://maps.app.goo.gl/UZ16KGWJQaFQSBf5A	\N	2025-11-01 06:12:11.794	2025-11-01 06:12:11.794	30000000	2025-11-05 04:53:59.742114	\N
24	CASE1762257392648	NAVA SANJIVANI DRUGS	SUBRAMANYAM -MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:48:14.080586				Prema	2025-11-05	17:30	9849021073	25-50cr	PANJAGUTA	\N	2025-11-04 11:56:28.195	2025-11-04 11:56:28.195	1	2025-12-16 11:48:14.080586	\N
18	CASE1762231819322	om international	prasanth - MD	Telecaller	Meeting Done	31	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 06:36:23.27066				Prema	2025-11-04	15:30	9849097260	25-50cr	https://maps.app.goo.gl/XtRqMFZbLMfzv1vQ9	\N	2025-11-04 04:50:18.828	2025-11-04 04:50:18.828	30000000	2025-11-05 04:38:43.436755	\N
29	CASE1762346321840	Baheti Steel Industries	Manoj	Telecaller	No Requirement	29	BL	\N	\N	Documentation	\N	2025-11-29 06:37:31.092383				\N	2025-11-05	10:30	9391037995	100+ cr	Rangareddy	\N	2025-11-05 12:38:42.456	2025-11-05 12:38:42.456	0	2025-11-29 06:37:31.092383	\N
10	CASE1761996927236	Jain Sadguru Constructions LLP	Surendar k CFO	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:31:49.213929				Monika	2025-11-03	12:00	8106340480	100+ cr	Hyderabad	\N	2025-11-01 11:35:26.891	2025-11-01 11:35:26.891	\N	2025-12-15 12:31:49.213929	\N
27	CASE1762339872019	FUTURE APEX INFRASTRUCTURE	Aleem -MD	Telecaller	Documentation In Progress	31	Small LAP - upto 5CR	\N	\N	\N	\N	2025-11-29 06:33:34.73196					2025-11-05	15:30	8686356628	25-50cr	https://maps.app.goo.gl/tCyvmfgxHou9dNCd7	\N	2025-11-05 10:51:07.605	2025-11-05 10:51:07.605	20000000	2025-11-29 06:33:34.73196	\N
13	CASE1762146702285	INDIAN METALS	SHAHJAD -MD	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-11-29 06:34:14.617748				PREMA	2025-11-21	11:30	8125100534	5-25cr	RAJENDERNAGAR	\N	2025-11-03 05:11:42.262	2025-11-03 05:11:42.262	1	2025-11-29 06:34:14.617748	\N
8	CASE1761979443916	Sree Nandini Kraft Boards Private Limited	trinadha raju	Telecaller	Meeting Done	30	BL	\N	\N	\N	\N	2025-11-05 04:38:53.326013				prema	2025-11-01	12:00	9866344666	50-100cr		\N	2025-11-01 06:44:04.724	2025-11-01 06:44:04.724	150000000	2025-11-05 04:38:53.326013	\N
14	CASE1762146979894	MEHFIL RESTAURANT	MD.KHADHER -CFO	Telecaller	No Requirement	33	\N	\N	\N	\N	\N	2025-11-29 06:32:28.537848				PREMA	2025-11-03	16:00	9885179494	100+ cr	MADHAPUR	\N	2025-11-03 05:16:19.842	2025-11-03 05:16:19.842	\N	2025-11-28 06:41:18.085535	\N
19	CASE1762247921899	SURAKSHA PHARMA	SRIDHAR -SENIOR VICE PRESIDENT	Telecaller	Meeting Done	33	Private Equity (75cr - 1000cr)	\N	\N	\N	\N	2025-12-15 12:24:40.46176				PREMA	2025-11-04	11:30	7702277666	25-50cr	KUKATPALLY	\N	2025-11-04 09:18:41.503	2025-11-04 09:18:41.503	500000000	2025-12-15 12:24:40.46176	\N
1	CASE1761904567946	Sai Traders	Santosh Kumar	Telecaller	Documentation In Progress	29	Small LAP - upto 5CR	\N	\N	\N	\N	2025-11-29 06:34:36.215763	Santosh kumar		9440379670	self	2025-10-31	12:00	9440379670	25-50cr	Adilabad	\N	2025-10-31 09:56:08.689	2025-10-31 09:56:08.689	5000000	2025-11-29 06:34:36.215763	\N
21	CASE1762248461034	VEERAMANI BISCUITS	ABHI -CFO	Telecaller	No Requirement	33	\N	\N	\N	\N	\N	2025-12-15 12:23:48.847286				MOUNIKA	2025-11-05	11:30	8333983171	100+ cr	HYDERABAD	\N	2025-11-04 09:27:40.657	2025-11-04 09:27:40.657	\N	2025-12-15 12:23:48.847286	\N
9	CASE1761990784698	principle acs engineering india private limited	Promod	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-04 12:42:44.18464				prema	2025-11-03	12:30	9866699153	50-100cr	https://maps.app.goo.gl/d3QRH88TFeQ9Swr38	\N	2025-11-01 09:53:04.999	2025-11-01 09:53:04.999	\N	2025-11-01 09:53:05.030906	\N
15	CASE1762148391654	khazana	Venkata subbarao	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:46:10.387086				prema	2025-11-04	16:00	9618822011	25-50cr	https://maps.app.goo.gl/xDgiZDqBGwxBsDy88	\N	2025-11-03 05:39:50.606	2025-11-03 05:39:50.606	1	2025-12-16 11:46:10.387086	\N
20	CASE1762248282595	j k fenner (india) limited	Srinivasa rao	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-04 12:42:07.106647				prema	2025-11-05	14:00	9949910893	100+ cr		\N	2025-11-04 09:24:42.317	2025-11-04 09:24:42.317	\N	2025-11-04 09:24:42.318555	\N
26	CASE1762322142972	rajashri construction company	Anand kumar	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:48:28.369033				Prema	2025-11-06	19:00	9885163689	25-50cr		\N	2025-11-05 05:54:42.583	2025-11-05 05:54:42.583	1	2025-12-16 11:48:28.369033	\N
17	CASE1762168226331	SRI VASAVI CHEMICAL CORPORATION	Venugopal	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-04 12:42:21.756356				prema	2025-11-04	15:00	9849000569	100+ cr	Himayat nagar	\N	2025-11-03 11:10:27.081	2025-11-03 11:10:27.081	\N	2025-11-03 11:10:27.112306	\N
22	CASE1762249044960	UNITED THREADS	SHAH -M.D	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-12-16 11:46:37.112172				MOUNIKA	2025-11-05	11:30	7207307407	5-25cr	SECUNDERABAD	\N	2025-11-04 09:37:24.58	2025-11-04 09:37:24.58	1	2025-12-16 11:46:37.112172	\N
135	CASE1762839684196	Tirumala Drugs	VASU - MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-15 14:27:40.458005				Google	2025-06-17	16:00	9666090666	5-25cr	Hyderabad	\N	2025-11-11 05:41:17.612	2025-11-11 05:41:17.612	1	2025-12-15 14:27:40.458005	\N
28	CASE1762339933194	INDUS MEGA FOOD PARK PRIVATE LIMITED	Ganesh kumar	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-05 10:54:28.145668				Prema	2025-11-06	18:30	8106199477	25-50cr	https://maps.app.goo.gl/Z5dmdK4mD5VUWpJL7	\N	2025-11-05 10:52:13.775	2025-11-05 10:52:13.775	\N	2025-11-05 10:52:13.805146	\N
31	CASE1762410652316	 home vista decor and furnishings private limited 	Vikaram	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-06 07:16:52.012876		Vikram@synergy-insurance.com		Prema	2025-11-07	14:00	 9844825929	100+ cr	Bengaluru	\N	2025-11-06 06:30:51.787	2025-11-06 06:30:51.787	\N	2025-11-06 06:30:51.816566	\N
16	CASE1762166837309	Averina International Resorts Private Limited	Ramnath K Shenvi CFO	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:35:52.016662				Srilatha	2025-11-04	03:30	9822102390	100+ cr	Hyderabad	\N	2025-11-03 10:47:17.927	2025-11-03 10:47:17.927	\N	2025-12-15 12:35:52.016662	\N
6	CASE1761977532523	LAPTOP STORE	Rajkumar	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:45:53.660361				Srilatha	2025-11-03	14:00	9566219995	25-50cr	Banglore	\N	2025-11-01 06:12:12.18	2025-11-01 06:12:12.18	1	2025-12-16 11:45:53.660361	\N
3	CASE1761910299582	ARIHANT AGENCIES	SHREYANSH SETH -MD	Telecaller	Documentation In Progress	33	WC	\N	\N	\N	\N	2025-11-29 06:34:23.688				PREMA	2025-11-01	01:00	9246157811	25-50cr	https://maps.app.goo.gl/rw2Zvf4hJoAu9TxR7	\N	2025-10-31 11:31:39.617	2025-10-31 11:31:39.617	50000000	2025-11-29 06:34:23.688	\N
12	CASE1762145698483	M/S Sree Sivaram & Company	Shiva Ram Director	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:33:02.326268				Prema	2025-11-03	13:00	9490164433	50-100cr	Hyderabad	\N	2025-11-03 04:54:58.091	2025-11-03 04:54:58.091	\N	2025-12-15 12:33:02.326268	\N
32	CASE1762414031380	INDRA PETRO PRODUCTS	TARUN TANDON -MD	Telecaller	Meeting Done	33	BL	\N	\N	\N	\N	2025-11-29 07:19:47.954773	TARUN TANDON -MD		9948033111	SRILATHA	2025-11-06	03:30	9948033111	100+ cr	BANJARA HILLS	\N	2025-11-06 07:27:12.52	2025-11-06 07:27:12.52	5000000	2025-11-16 05:44:51.351664	\N
493	CASE1764423793116	Tatva public school	MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:16:50.18				\N	2025-11-25	03:00	7337365333			\N	2025-11-29 13:11:57.866	2025-11-29 13:11:57.866	\N	2025-11-29 13:16:50.18	\N
172	CASE1762842780781	Srinivas Enterprises	Srinivas	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-11 06:33:22.894336				Prema	2025-09-02	14:00	9704854545	5-25cr	https://maps.app.goo.gl/VPZYaoMuFZ9MLKJAA	\N	2025-11-11 06:32:54.243	2025-11-11 06:32:54.243	\N	2025-11-11 06:32:54.271752	\N
30	CASE1762346413807	Pista House	Mohammed Abdul 	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-11-21 12:06:45.170902				\N	2025-11-05	11:00	9966022786	100+ cr		\N	2025-11-05 12:40:14.456	2025-11-05 12:40:14.456	4000000000	2025-11-21 12:06:45.170902	\N
23	CASE1762249679995	SPACENET ENTERPRISES INDIA LIMITED	Ganesh kumar (CFO)	Telecaller	One Pager	30	OD	\N	\N	\N	\N	2025-11-29 13:33:04.588582				prema	2025-11-05	19:00	9000484951	100+ cr	https://maps.app.goo.gl/FcsimZE4Ri54m2GS6	\N	2025-11-04 09:47:59.722	2025-11-04 09:47:59.722	100000000	2025-11-29 13:33:04.588582	\N
42	CASE1762581369675	RAJ PACKAGING INDUSTRIES	PREM - MD	Telecaller	Meeting Done	31	BL	\N	\N	\N	\N	2025-11-29 07:19:24.328335	PREM - MD		9848033140	PREMA	2025-11-10	12:30	9848033140	50-100cr	https://maps.app.goo.gl/5xhJS2kYmjFe5Kod7	\N	2025-11-08 05:56:03.609	2025-11-08 05:56:03.609	70000000	2025-11-10 12:01:39.219927	\N
63	CASE1762836168765	HERODEALERS	SUBBARAO-MD	Telecaller	Open	33	\N	\N	\N	\N	\N	2025-11-29 06:35:35.814136				SELF	2025-08-11	11:30	9848269494	25-50cr	HYDERABAD	\N	2025-11-11 04:42:49.375	2025-11-11 04:42:49.375	\N	2025-11-11 04:42:49.37621	\N
48	CASE1762753729616	Sidhartha Jewellers	Krishna Prasad	Telecaller	Documentation In Progress	29	WC	\N	\N	Documentation	\N	2025-11-29 06:31:22.238299				\N	2025-11-10	02:30	9505695056	100+ cr		\N	2025-11-10 05:48:50.209	2025-11-10 05:48:50.209	300000000	2025-11-29 06:31:22.238299	\N
44	CASE1762594309945	Trane Technologies India Pvt Ltd	Karan 	Telecaller	Open	32	\N	\N	\N	\N	\N	2025-11-08 09:32:24.558909				Monika	2025-11-10	14:00	9999790780	100+ cr	Hyderabad	\N	2025-11-08 09:31:50.275	2025-11-08 09:31:50.275	\N	2025-11-08 09:31:50.304613	\N
60	CASE1762836004507	Life Slimming and Cosmetic pvt Ltd	Jaani Basha 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-12-16 11:49:22.972539				Monika	2025-09-08	12:00	9581688882	5-25cr	Hyderabad	\N	2025-11-11 04:40:04.921	2025-11-11 04:40:04.921	1	2025-12-16 11:49:22.972539	\N
34	CASE1762428558548	Lohiya Edible Oils	Bala	Telecaller	Documentation Initiated	46	BL	\N	\N	Documentation	\N	2025-11-06 11:32:23.199663				\N	2025-11-06	15:00	9912789891	5000cr		\N	2025-11-06 11:29:19.198	2025-11-06 11:29:19.198	200000000	2025-11-06 11:32:23.199663	\N
37	CASE1762428815824	vensar Constructions pvt ltd	Srinjoy Sharma	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-11-06 11:33:36.494371				\N	2025-11-07	11:00	8860724093	2000crs		\N	2025-11-06 11:33:36.464	2025-11-06 11:33:36.464	\N	2025-11-06 11:33:36.494371	\N
33	CASE1762425626265	Sri venkata sai engineering pvt Ltd  	Balaji (MD)	Telecaller	Documentation In Progress	30	WC	\N	\N	\N	\N	2025-11-29 06:32:48.04161				prema	2025-11-05	16:00	  9966406492	50-100cr	https://maps.app.goo.gl/YLfoLfxGBqvJqSiJ9	\N	2025-11-06 10:40:26.75	2025-11-06 10:40:26.75	100000000	2025-11-29 06:32:48.04161	\N
55	CASE1762835524312	ravoos laboratories limited	Rajesh (CFO)	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-29 06:32:08.484489			77995 67815	prema	2025-08-25	14:30	7799951122 	100+ cr	https://maps.app.goo.gl/zZrSgSuT2yZWt1wW7	\N	2025-11-11 04:32:04.038	2025-11-11 04:32:04.038	\N	2025-11-11 04:32:04.069674	\N
39	CASE1762496116023	SKYLIMIT ENTITY PVT.LTD	Srikanth -MD	Telecaller	Meeting Done	31	WC	\N	\N	\N	\N	2025-11-29 07:05:06.855094	Srikanth -MD			Srilatha	2025-11-08	10:30	9849578785	25-50cr	https://maps.app.goo.gl/cQQUoA3W7vi7AGkw6	\N	2025-11-07 06:15:11.337	2025-11-07 06:15:11.337	2000000	2025-11-11 06:04:32.153939	\N
35	CASE1762428638541	vsa infra projects limited	kondal reddy	Telecaller	Documentation In Progress	29	Small LAP upto 7CR	\N	\N	\N	\N	2025-11-07 06:51:56.055956					2025-11-06	11:00	9866010800	350crs		\N	2025-11-06 11:30:39.192	2025-11-06 11:30:39.192	800000000	2025-11-07 06:51:56.055956	\N
43	CASE1762588856050	Vasantha Rice Industries	Kiran	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:35:25.370615				Prema	2025-11-10	13:30	7032703555	100+ cr	Nalgonda	\N	2025-11-08 08:00:56.681	2025-11-08 08:00:56.681	1	2025-11-29 06:35:25.370615	\N
45	CASE1762750626899	maheswari mining & energy private limited	Srikanth (CFO)	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-29 06:31:51.42404				Prema	2025-11-11	11:30	8519995348	25-50cr	https://maps.app.goo.gl/SyvpoziyGGbwLEWV7	\N	2025-11-10 04:57:07.317	2025-11-10 04:57:07.317	\N	2025-11-10 04:57:07.347857	\N
41	CASE1762581367103	AKASH JEWELLERS	DINESH	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-11 04:30:45.52482				Prema	2025-11-10	11:30	9347232256	25-50cr	Hyderabad	\N	2025-11-08 05:56:01.876	2025-11-08 05:56:01.876	\N	2025-11-08 05:56:01.907199	\N
49	CASE1762755936693	BANU ENTERPRISES	BANU -CFO	Telecaller	No Requirement	33	\N	\N	\N	\N	\N	2025-11-29 06:33:32.207494				SRILATHA	2025-11-10	11:30	9440607963	5-25cr	SHAMSHABAD	\N	2025-11-10 06:25:37.394	2025-11-10 06:25:37.394	\N	2025-11-25 10:32:40.534016	\N
64	CASE1762836174853	AGP oils Pvt Ltd	Govind Pallod	Telecaller	Documentation Initiated	32	BL	\N	\N	\N	\N	2025-12-08 12:20:24.911104				Monika	2025-09-12	12:00	9849399931	100+ cr	Zaheerabad	\N	2025-11-11 04:42:55.289	2025-11-11 04:42:55.289	5000000	2025-12-08 12:20:24.911104	\N
46	CASE1762753606380	company pvt ltd	gouthami	Telecaller	One Pager	30	Machinery funding upto 7cr	\N	\N	One Pager	\N	2025-11-29 13:29:22.827				prema	2025-11-11	13:30	6300041550	5-25cr	https://maps.app.goo.gl/yD2voAvfbJhaE5sf6	\N	2025-11-10 05:46:46.872	2025-11-10 05:46:46.872	10000000	2025-11-10 06:27:15.2889	\N
51	CASE1762769139453	Monocept Consulting Private Limited	Bhavana	Telecaller	Open	32	\N	\N	\N	\N	\N	2025-11-10 10:06:00.762791				Monika	2025-11-11	12:00	9154131228	50-100cr	Hyderabad	\N	2025-11-10 10:05:39.639	2025-11-10 10:05:39.639	\N	2025-11-10 10:05:39.676986	\N
54	CASE1762835256981	SRI VINAYAKA AGENCIES	Bhupalam ranga swamy	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-11 04:27:48.615535				MOUNIKA	2025-09-04	14:00	8688886117  	5-25cr	Hyderabad	\N	2025-11-11 04:27:36.659	2025-11-11 04:27:36.659	\N	2025-11-11 04:27:36.688778	\N
53	CASE1762835221103	Challa Infra Projects pvt.ltd	Rakesh reddy -MD	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-29 06:20:22.911846				Mounika	2025-09-10	10:30	9703561234	50-100cr	Hyderabad	\N	2025-11-11 04:26:54.384	2025-11-11 04:26:54.384	\N	2025-11-11 04:26:54.413036	\N
57	CASE1762835661410	Trident Properties Private limited	Bhaskar Rao Vedula	Telecaller	Meeting Done	32	BL	\N	\N	\N	\N	2025-11-21 12:17:53.88765				Monika	2025-09-09	11:00	8374799900	5-25cr	Hyderabad	\N	2025-11-11 04:34:22.434	2025-11-11 04:34:22.434	30000000	2025-11-21 12:17:53.88765	\N
59	CASE1762835826376	Zuper Led	Mallikarjuna	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:49:14.39889				mounika	2025-11-09	13:00	8247348117	5-25cr	https://maps.app.goo.gl/8SJ77R4pPnr2XnND7	\N	2025-11-11 04:37:06.149	2025-11-11 04:37:06.149	1	2025-12-16 11:49:14.39889	\N
61	CASE1762836019957	Sindhuri Constructions and Engineers 	Venkatesh -MD	Telecaller	Meeting Done	31	BL	\N	\N	\N	\N	2025-11-29 06:21:26.27532				Mounika	2025-08-19	11:30	9000484724	1-5cr	Hyderabad	\N	2025-11-11 04:40:13.44	2025-11-11 04:40:13.44	10000000	2025-11-29 05:03:17.347674	\N
36	CASE1762428745324	Rithwik Projects Private Limited	Ajay Cfo	Telecaller	No Requirement	29	BL	\N	\N	Documentation	\N	2025-11-29 06:32:20.743948				\N	2025-11-07	11:00	9121167880			\N	2025-11-06 11:32:25.968	2025-11-06 11:32:25.968	0	2025-11-29 06:32:20.743948	\N
50	CASE1762756077071	JAIN INDIA STEEL CORPORATION PRIVATE LIMITED	ROHITH JAIN - MD	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-11-29 07:16:16.119943	ROHITH JAIN - MD			SRILATHA	2025-11-10	12:30	9849911288	50-100cr	JUBLEE HILLS	\N	2025-11-10 06:27:57.835	2025-11-10 06:27:57.835	1	2025-11-29 06:39:18.742629	\N
40	CASE1762580970506	Rocksand Minerals Private Limited	Anirudh (CFO)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:48:45.021169				Prema	2025-11-10	15:00	9866999299	100+ cr	https://maps.app.goo.gl/h49WzcmH9omzo3re9	\N	2025-11-08 05:49:30.46	2025-11-08 05:49:30.46	1	2025-12-16 11:48:45.021169	\N
38	CASE1762495682299	ELECTRONICS AND CONTROLS POWER SYTEMS PVT LTD	SHANKAR - MD	Telecaller	Meeting Done	33	BL	\N	\N	\N	\N	2025-11-29 07:05:20.005558	SHANKAR - MD	BANGLORE		PREMA	2025-11-07	11:30	9845092457	25-50cr		\N	2025-11-07 06:08:02.805	2025-11-07 06:08:02.805	5000000	2025-11-11 06:04:14.918172	\N
56	CASE1762835526007	viva interiors private limited	Karthik	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:48:55.534393				Prema	2025-09-10	14:30	 9966403544	5-25cr		\N	2025-11-11 04:32:05.186	2025-11-11 04:32:05.186	1	2025-12-16 11:48:55.534393	\N
62	CASE1762836168025	NAGARJUNA FERTILIZERS AND CHEMICALS LTD	SUDHIR BANSALI	Telecaller	Open	33	\N	\N	\N	\N	\N	2025-11-11 05:55:19.472897				PREMA	2025-08-05	11:30	9676752424	50-100cr	HYDERABAD	\N	2025-11-11 04:42:48.956	2025-11-11 04:42:48.956	\N	2025-11-11 04:42:48.985854	\N
58	CASE1762835719858	Smr Builders Pvt.Ltd	Govindh Reddy - CFO	Telecaller	Documentation In Progress	31	BL	\N	\N	\N	\N	2025-11-29 06:31:00.151797				Mounika	2025-11-24	15:00	9951463329	50-100cr	Hyderabad	\N	2025-11-11 04:35:13.303	2025-11-11 04:35:13.303	500000000	2025-11-29 06:31:00.151797	\N
73	CASE1762836738117	SRI KRISHNA PHARMA	ABHISHEK -MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:40:12.346032				Prema	2025-09-09	12:30	9849265058	5-25cr	Hyderabad	\N	2025-11-11 04:52:11.532	2025-11-11 04:52:11.532	1	2025-12-16 11:40:12.346032	\N
72	CASE1762836724833	APOLLO COMPUTING LABORATORIES PRIVATE LIMITED	Sandeep	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:51:01.106575				Prema	2025-09-22	13:00	 8977931553	25-50cr	https://maps.app.goo.gl/bdhpeFWRdRFgc2MF9	\N	2025-11-11 04:52:04.632	2025-11-11 04:52:04.632	1	2025-12-16 11:51:01.106575	\N
93	CASE1762837751316	Sarath chandra constructions	Sarath chandra -MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:39:06.310098				Mounika	2025-10-16	15:00	9848152389	25-50cr	Hyderabad	\N	2025-11-11 05:09:04.654	2025-11-11 05:09:04.654	1	2025-12-16 11:39:06.310098	\N
92	CASE1762837712030	Sri Krishna Lubricant 	Naveen Surajmal Agarwal 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:36:20.458368				Monika	2025-09-27	14:30	9849011040	25-50cr	Hyderabad	\N	2025-11-11 05:08:32.579	2025-11-11 05:08:32.579	0	2025-11-29 06:36:20.458368	\N
69	CASE1762836537215	Vijai Electricals pvt.ltd	Srinivasa rao -CFO	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:40:28.136241				Prema	2025-09-09	15:00	 7997718989	100+ cr	https://maps.app.goo.gl/JxAdAKqQUAfajSrR8	\N	2025-11-11 04:48:50.666	2025-11-11 04:48:50.666	1	2025-12-16 11:40:28.136241	\N
71	CASE1762836582698	Shah Batteries	Md Mustafa Hussain 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:37:58.554192				Monika	2025-09-13	13:30	9985510000	100+ cr	Hyderabad	\N	2025-11-11 04:49:43.134	2025-11-11 04:49:43.134	0	2025-11-29 06:37:58.554192	\N
68	CASE1762836402193	Sri Balaji Apparels	Rithesh (Director)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:40:53.009678				Prema	2025-09-09	17:00	 9246802300	5-25cr	Hyderabad	\N	2025-11-11 04:46:41.871	2025-11-11 04:46:41.871	1	2025-12-16 11:40:53.009678	\N
74	CASE1762836735232	M/s Sri Hari Constructions	Giridhar Reddy 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:38:05.017152				Monika	2025-09-16	13:30	9440737083		Hyderabad	\N	2025-11-11 04:52:15.668	2025-11-11 04:52:15.668	0	2025-11-29 06:38:05.017152	\N
94	CASE1762837859229	PEOPLE LINK UNIFIED COMMUNICATINS PVT LTD	HANUMANTH -M.D	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-12-16 11:38:51.36528				MOUNIKA	2025-08-12	11:00	9248131920	25-50cr	HYDERBAD	\N	2025-11-11 05:11:00.165	2025-11-11 05:11:00.165	1	2025-12-16 11:38:51.36528	\N
76	CASE1762836984464	Sangameshwara Service Station	 Rajan Goud Vigram	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:40:53.228897				Monika	2025-09-22	11:00	9573917706		Gurgoan	\N	2025-11-11 04:56:24.876	2025-11-11 04:56:24.876	0	2025-11-29 06:40:53.228897	\N
87	CASE1762837439358	Globe Surgicals pvt.Ltd	Mohan reddy - MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:39:49.24693				Mounika	2025-09-15	11:00	9849009171	25-50cr	Hyderabad	\N	2025-11-11 05:03:52.715	2025-11-11 05:03:52.715	1	2025-12-16 11:39:49.24693	\N
80	CASE1762837109762	Sri Ram Enterprises 	Ganesh Chandak 	Telecaller	Meeting Done	32	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-18 04:44:56.155531				Monika	2025-09-22	14:30	9959671851		Hyderabad	\N	2025-11-11 04:58:30.351	2025-11-11 04:58:30.351	10000000	2025-11-21 12:23:54.45959	\N
75	CASE1762836984668	Teron Bio Solutions	Kantha reddy	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-11 04:56:37.220839				Google 	2025-09-18	13:00	 7013824117	1-5cr		\N	2025-11-11 04:56:24.378	2025-11-11 04:56:24.378	\N	2025-11-11 04:56:24.41021	\N
77	CASE1762837001046	Sri Srinivasa Ferrotech pvt.ltd	Srinivas	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-11 04:56:45.403287				Mounika	2025-09-10	13:30	9390587391	5-25cr		\N	2025-11-11 04:56:34.441	2025-11-11 04:56:34.441	\N	2025-11-11 04:56:34.442268	\N
98	CASE1762838034709	s c r nirman private limited	Rambabu (CFO)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:38:20.371249				prema	2025-09-23	13:00	 9666967712	100+ cr	https://maps.app.goo.gl/bdA1MMse5iUqrQPx9	\N	2025-11-11 05:13:54.343	2025-11-11 05:13:54.343	1	2025-12-16 11:38:20.371249	\N
88	CASE1762837499901	Al Kabeer Exports private Limited	Giri 	Telecaller	Meeting Done	32	BL	\N	\N	\N	\N	2025-11-29 05:11:46.455619				Prema	2025-09-24	13:00	9346932715	1-5cr	Hyderabad	\N	2025-11-11 05:05:00.295	2025-11-11 05:05:00.295	2000000	2025-11-29 05:11:46.455619	\N
86	CASE1762837414827	KAMINI METALICKS PVT LTD	SAMI BHAGAT -M.D	Telecaller	Disbursed	33	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-29 10:04:30.62615				MOUNIKA	2025-07-10	02:30	9849007211	25-50cr	HYDERABAD	\N	2025-11-11 05:03:35.739	2025-11-11 05:03:35.739	70000000	2025-12-29 10:04:30.62615	\N
65	CASE1762836213700	Sri Ganesh Krupa Service Station	Dileep	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:50:40.38449				Mounika	2025-09-03	12:30	9440207675	5-25cr	Asifabad	\N	2025-11-11 04:43:27.044	2025-11-11 04:43:27.044	1	2025-12-16 11:50:40.38449	\N
89	CASE1762837520722	stereo kem pharmaceuticals private limited	Srinivas	Telecaller	Meeting Done	30	BL	\N	\N	\N	\N	2025-11-28 05:05:40.169075				prema	2025-09-11	12:00	 8121476999	5-25cr	Uppal	\N	2025-11-11 05:05:20.492	2025-11-11 05:05:20.492	10000000	2025-11-28 05:05:40.169075	\N
85	CASE1762837371975	Metrix Automations India Pvt Ltd	Balakrishna Nuthakki	Telecaller	Meeting Done	32	WC	\N	\N	\N	\N	2025-12-01 13:29:42.475846				Monika	2025-09-23	11:00	9989822468	1-5cr	Hyderabad	\N	2025-11-11 05:02:52.664	2025-11-11 05:02:52.664	20000000	2025-12-01 13:29:42.475846	\N
90	CASE1762837578102	SRI BHAGYA LAKSHMI COTEX PVT LTD	YASHWANTH -M.D	Telecaller	Meeting Done	33	OD	\N	\N	\N	\N	2025-11-29 06:23:37.26297				PREMA	2025-09-05	01:30	8328486731	25-50cr	MADHAPUR	\N	2025-11-11 05:06:19.039	2025-11-11 05:06:19.039	100000000	2025-11-28 05:05:20.305034	\N
99	CASE1762838049088	M Rajaiah & Company 	Narahari Angarekula	Telecaller	Documentation In Progress	32	BL	\N	\N	\N	\N	2025-11-29 06:29:38.429063				Monika	2025-09-27	12:00	9440090288	100+ cr	Nizamabad	\N	2025-11-11 05:14:09.557	2025-11-11 05:14:09.557	4500000	2025-11-29 06:29:38.429063	\N
70	CASE1762836549855	PALLAVI CONSTRUCTIONS	Chandra shekar (CFO)	Telecaller	No Requirement	30	Small LAP upto 7CR	\N	\N	\N	\N	2025-12-16 11:40:20.355445				Prema	2025-09-09	12:30	9000494123	50-100cr		\N	2025-11-11 04:49:09.526	2025-11-11 04:49:09.526	1	2025-12-16 11:40:20.355445	\N
67	CASE1762836399409	Rayalaseema Steel Rerolling Mills Pvt Ltd	Balaram Agarwal	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:37:49.330224				Monika	2025-09-13	11:30	9848099662	100+ cr	Hyderabad	\N	2025-11-11 04:46:39.825	2025-11-11 04:46:39.825	0	2025-11-29 06:37:49.330224	\N
83	CASE1762837275126	Sri Ramanjaneya Traders	Gopi - MD	Telecaller	Meeting Done	31	Small LAP - upto 5CR	\N	\N	\N	\N	2025-11-29 06:16:31.89055				Mounika	2025-09-16	10:30	9490117180	25-50cr	Hyderabad	\N	2025-11-11 05:01:08.544	2025-11-11 05:01:08.544	20000000	2025-11-29 05:10:52.751318	\N
95	CASE1762837864196	CASPIAN IMPACT INVESTMENTS PRIVATE LIMITED	Vishwanath	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-11 05:11:15.630006				prema	2025-09-22	16:30	 9866786456	25-50cr		\N	2025-11-11 05:11:03.982	2025-11-11 05:11:03.982	\N	2025-11-11 05:11:03.983642	\N
78	CASE1762837053506	SPANSULES PHARMATECH PVT LTD	SUBBARAO -M.D	Telecaller	Meeting Done	33	Machinery funding upto 7cr	\N	\N	\N	\N	2025-11-29 06:24:36.549401				PREMA	2025-10-11	11:00	9849034189	25-50cr	HYDERABAD	\N	2025-11-11 04:57:34.408	2025-11-11 04:57:34.408	10000000	2025-11-28 05:04:04.42883	\N
82	CASE1762837235453	M/s Stirti AyurTherapies Pvt Ltd	Kumar Arvind Temura 	Telecaller	Documentation In Progress	32	WC	\N	\N	\N	\N	2025-11-29 06:30:37.814608				Monika	2025-09-22	14:30	9491042865	50-100cr	Hyderabad	\N	2025-11-11 05:00:35.895	2025-11-11 05:00:35.895	80000000	2025-11-29 06:30:37.814608	\N
66	CASE1762836379252	KNR infra projects	Adithya - MD	Telecaller	No Requirement	31	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-16 11:40:47.073665				Mounika	2025-08-21	12:00	9010099188	5-25cr	https://maps.app.goo.gl/Kxkr8gNbD2WiMhqF6	\N	2025-11-11 04:46:12.565	2025-11-11 04:46:12.565	1	2025-12-16 11:40:47.073665	\N
96	CASE1762837899223	Harsh Industries	Jayprakash 	Telecaller	Documentation In Progress	32	OD	\N	\N	\N	\N	2025-11-29 06:30:04.710435				Monika	2025-09-27	15:00	9849005550	50-100cr	Hyderabad	\N	2025-11-11 05:11:39.61	2025-11-11 05:11:39.61	20000000	2025-11-29 06:30:04.710435	\N
79	CASE1762837105115	Microbase Computers	Srilatha	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:40:04.782058				Mounika	2025-09-11	11:30	8885773300	25-50cr	Hyderabad	\N	2025-11-11 04:58:18.587	2025-11-11 04:58:18.587	1	2025-12-16 11:40:04.782058	\N
101	CASE1762838073669	GREENMINT AGRITECH PVT LTD	MURALI -M.D	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-12-16 11:51:25.927733				MOUNIKA	2025-06-10	02:00	9705700009	25-50cr	LBNAGAR	\N	2025-11-11 05:14:34.615	2025-11-11 05:14:34.615	1	2025-12-16 11:51:25.927733	\N
129	CASE1762839307825	Eagle boards and panels pvt.ltd	YASEEN MOHAMEED - MD	Telecaller	Login	31	WC	\N	\N	\N	\N	2025-12-29 09:54:56.617633				Mounika	2025-06-18	16:00	9010148148	50-100cr	Hyderabad	\N	2025-11-11 05:35:01.123	2025-11-11 05:35:01.123	1	2025-12-29 09:54:56.617633	\N
131	CASE1762839387128	Atnest pvt.ltd	NEHRU BABU - MD	Telecaller	Meeting Done	31	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 06:11:50.637157				Mounika	2025-06-23	11:30	 7479974799	25-50cr	Hyderabad	\N	2025-11-11 05:36:20.415	2025-11-11 05:36:20.415	150000000	2025-11-28 05:13:42.969311	\N
110	CASE1762838444569	Jabal Exim pvt.ltd	Hasan	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:37:17.210338				Google	2025-09-04	14:00	9381958057	5-25cr	https://share.google/xDUsyc87qn74MoZDY	\N	2025-11-11 05:20:37.987	2025-11-11 05:20:37.987	1	2025-12-16 11:37:17.210338	\N
103	CASE1762838228852	Mantri Developers Private Limited	Sathya Murthy Ravi 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:36:12.265222				Monika	2025-09-27	13:00	9000008175	100+ cr	Hyderabad	\N	2025-11-11 05:17:09.698	2025-11-11 05:17:09.698	0	2025-11-29 06:36:12.265222	\N
119	CASE1762838889522	VEERAMANI BISCUITS INDUSTRIES PVT LTD	ABHI	Telecaller	No Requirement	33	\N	\N	\N	\N	\N	2025-12-15 12:23:36.668521				MOUNIKA	2025-09-05	11:30	8333983171	100+ cr	HYDERABAD	\N	2025-11-11 05:28:10.449	2025-11-11 05:28:10.449	\N	2025-12-15 12:23:36.668521	\N
106	CASE1762838267468	rasha infrastructure	Kantha rao	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:37:43.677086				Prema	2025-10-07	13:30	 9908980024	25-50cr	https://maps.app.goo.gl/RWpUa6WP2dyQ4pQF6	\N	2025-11-11 05:17:46.568	2025-11-11 05:17:46.568	1	2025-12-16 11:37:43.677086	\N
108	CASE1762838356178	Shri Shyam Baba Electronic Pvt Ltd 	Rahul Goel 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:36:00.735349				Monika	2025-10-04	12:30	9030090030	100+ cr	Hyderabad	\N	2025-11-11 05:19:16.622	2025-11-11 05:19:16.622	0	2025-11-29 06:36:00.735349	\N
112	CASE1762838563629	Fortune Aluminium pvt.ltd	Sampath kumar - MD	Telecaller	No Requirement	31	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-16 11:37:10.629246				Google	2025-09-19	11:30	9951657666	25-50cr	Hyderabad	\N	2025-11-11 05:22:37.084	2025-11-11 05:22:37.084	1	2025-12-16 11:37:10.629246	\N
134	CASE1762839665865	PNK Constructions and Architects	PNK	Telecaller	No Requirement	32	BL	\N	\N	Documentation	\N	2025-11-29 06:28:06.811155				\N	2025-10-15	13:00	9493678153	25-50cr	Hyderabad	\N	2025-11-11 05:41:06.34	2025-11-11 05:41:06.34	0	2025-11-29 06:28:06.811155	\N
118	CASE1762838828736	Avanse Financial Services Limited	Sharad Ekanath Tikudave	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-11-11 05:27:09.198975				\N	2025-10-06	13:00	8691988897	100+ cr	Hyderabad	\N	2025-11-11 05:27:09.168	2025-11-11 05:27:09.168	\N	2025-11-11 05:27:09.198975	\N
100	CASE1762838066302	Honer developers pvt.ltd	Avinash -CFO	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:38:04.856853				Mounika	2025-10-27	14:30	8179149666	25-50cr	https://maps.app.goo.gl/HFLCu3a2nDxpK3de6?g_st=iwb	\N	2025-11-11 05:14:19.651	2025-11-11 05:14:19.651	1	2025-12-16 11:38:04.856853	\N
121	CASE1762838931738	Gtpl Broadband Private Limited	Bhatnakar	Telecaller	No Requirement	32	BL	\N	\N	Documentation	\N	2025-11-29 06:35:13.516367				\N	2025-10-09	13:30	7433033306		Hyderabad	\N	2025-11-11 05:28:52.259	2025-11-11 05:28:52.259	0	2025-11-29 06:35:13.516367	\N
124	CASE1762839104555	hanuman agro industries mancherial	Hanuman das	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:28:27.049461				Prema	2025-09-01	10:30	9885333300	5-25cr	Manchiryal	\N	2025-11-11 05:31:44.283	2025-11-11 05:31:44.283	1	2025-12-15 14:28:27.049461	\N
114	CASE1762838589367	PRAGATHI TOWNSHIP	Suresh babu	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:18:59.341065				prema	2025-10-21	16:00	9652911602	5-25cr	https://maps.app.goo.gl/bULoxNhCHXgWQUCR7	\N	2025-11-11 05:23:08.616	2025-11-11 05:23:08.616	1	2025-12-15 14:18:59.341065	\N
116	CASE1762838692597	Aushadi medical store	Venugopal reddy -MD	Telecaller	No Requirement	31	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-15 14:29:40.388812				Mounika	2025-09-19	11:00	9849705490	5-25cr	Hyderabad	\N	2025-11-11 05:24:46.107	2025-11-11 05:24:46.107	1	2025-12-15 14:29:40.388812	\N
109	CASE1762838419599	AMBIENCE POWER AND INFRATECH PVT  LTD	RAJAVARDHAN	Telecaller	Meeting Done	33	BL	\N	\N	\N	\N	2025-11-28 05:11:13.533644				MOUNIKA	2025-05-06	11:00	9848422333	50-100cr	HYDERABAD	\N	2025-11-11 05:20:20.523	2025-11-11 05:20:20.523	1	2025-11-28 05:11:13.533644	\N
113	CASE1762838587556	Ralos Energy	Kishore	Telecaller	One Pager	30	BL	\N	\N	\N	\N	2025-12-08 15:11:55.411977				prema	2025-08-12	12:00	9502772790	1-5cr		\N	2025-11-11 05:23:07.181	2025-11-11 05:23:07.181	1200000	2025-12-08 15:11:55.411977	\N
117	CASE1762838801310	Nandi infratech pvt.ltd	Kishore -CFO	Telecaller	No Requirement	31	Small LAP upto 7CR	\N	\N	\N	\N	2025-12-15 14:18:50.45495				prema	2025-10-23	11:00	8179915999	100+ cr	Hyderabad	\N	2025-11-11 05:26:34.751	2025-11-11 05:26:34.751	1	2025-12-15 14:18:50.45495	\N
130	CASE1762839304365	MEHAK FOOD AND SPICES	Naresh devnani	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:28:09.077907				Prema	2025-08-28	12:00	9246261891	1-5cr	https://maps.app.goo.gl/aE4bJBPAu48pJpzBA	\N	2025-11-11 05:35:04	2025-11-11 05:35:04	1	2025-12-15 14:28:09.077907	\N
127	CASE1762839185573	GAMPA VISHWANATHAN	SRINIVAS -M.D	Telecaller	Login	33	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-29 10:02:32.390188				PREMA	2025-10-15	03:00	9440534321	5-25cr	NALGONDA	\N	2025-11-11 05:33:06.18	2025-11-11 05:33:06.18	20000000	2025-12-29 10:02:32.390188	\N
128	CASE1762839244514	Scoria IT Private Limited	Sharath	Telecaller	No Requirement	32	BL	\N	\N	Documentation	\N	2025-11-29 06:28:34.543198				\N	2025-10-13	14:00	8106499500		Hyderabad	\N	2025-11-11 05:34:04.946	2025-11-11 05:34:04.946	0	2025-11-29 06:28:34.543198	\N
120	CASE1762838890789	ABHI ENGNEERING CORPERATION PVT LTD	SACHINKOREAKAR	Telecaller	No Requirement	33	\N	\N	\N	\N	\N	2025-12-15 12:47:44.408603				MOUNIKA	2025-10-10	11:30	8793241747	100+ cr	MUMBAI	\N	2025-11-11 05:28:11.237	2025-11-11 05:28:11.237	\N	2025-12-15 12:47:44.408603	\N
132	CASE1762839385207	Isgec Heavy Engineering Limited	Rahul Kumar Mishra	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:28:26.365577				Srilatha	2025-10-11	13:30	9540165930		Hyderabad	\N	2025-11-11 05:36:25.644	2025-11-11 05:36:25.644	0	2025-11-29 06:28:26.365577	\N
104	CASE1762838234335	VALVUM PRO SCIENCES	RAJESH -CFO	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-12-16 11:51:32.686902				MOUNIKA	2025-07-10	01:30	8885042777	5-25cr	MEERPET	\N	2025-11-11 05:17:15.266	2025-11-11 05:17:15.266	1	2025-12-16 11:51:32.686902	\N
107	CASE1762838320280	SK Gold	Nithin Agarwal - MD	Telecaller	Meeting Done	31	BL	\N	\N	\N	\N	2025-11-29 06:27:00.950863				Google	2025-10-27	12:30	9246370800	100+ cr	Hyderabad	\N	2025-11-11 05:18:33.775	2025-11-11 05:18:33.775	1	2025-11-28 05:11:04.251087	\N
125	CASE1762839165909	Banka bioloo limited	Padmanabham - CFO	Telecaller	Login	31	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-29 10:02:44.075325				Mounika	2025-10-17	14:00	9849270702	25-50cr	Hyderabad	\N	2025-11-11 05:32:39.248	2025-11-11 05:32:39.248	1	2025-12-29 10:02:44.075325	\N
123	CASE1762839103794	Shri Krishna Infotech 	Naveen 	Telecaller	Documentation In Progress	32	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 06:28:49.407022	Sai Krishna		7288888901		2025-10-09	14:30	8885526751 		Hyderabad	\N	2025-11-11 05:31:44.203	2025-11-11 05:31:44.203	50000000	2025-11-29 06:28:49.407022	\N
133	CASE1762839508375	Hasicon Infra Pvt Ltd	Jakkula Maheshwar Reddy Director	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:42:16.357107				Prema	2025-10-13	12:00	9000292727	25-50cr	Hyderabad	\N	2025-11-11 05:38:28.813	2025-11-11 05:38:28.813	0	2025-11-29 06:28:14.448027	\N
111	CASE1762838515302	Alteus Biogenics Private Limited	Ravi 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:35:55.615307				Monika	2025-10-04	11:30	9392345640	1-5cr	Hyderabad	\N	2025-11-11 05:21:55.74	2025-11-11 05:21:55.74	0	2025-11-29 06:35:55.615307	\N
122	CASE1762839001224	Metasports Media pvt.ltd	Priyatham - MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-15 14:18:36.223996				srilatha	2025-10-30	11:30	9550380223	25-50cr	https://maps.app.goo.gl/bcEkKkABy4Fm5ADF9	\N	2025-11-11 05:29:54.528	2025-11-11 05:29:54.528	1	2025-12-15 14:18:36.223996	\N
138	CASE1762839819406	Anika Constructions Pvt.Ltd	SUBBA RAO -MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-15 14:27:21.813287				Mounika	2025-08-18	14:30	9052464000	5-25cr	Hyderabad	\N	2025-11-11 05:43:32.921	2025-11-11 05:43:32.921	1	2025-12-15 14:27:21.813287	\N
163	CASE1762841324795	VISHNU SAI COTTON INDUSTRIES	VENKAT RAMULU - M.D	Telecaller	Meeting Done	33	WC	\N	\N	\N	\N	2025-11-29 06:19:48.120558				SELF	2025-05-11	11:00	7947412726	25-50cr	HYDERABAD	\N	2025-11-11 06:08:45.373	2025-11-11 06:08:45.373	5000000	2025-11-29 05:15:22.87315	\N
153	CASE1762840635394	VenkataRamana Motors	Ram Mohan Gattu 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-12-31 09:04:38.117514				Prema	2025-10-21	14:00	9966876333	25-50cr	Nalgonda	\N	2025-11-11 05:57:15.797	2025-11-11 05:57:15.797	0	2025-11-29 06:27:10.068382	\N
137	CASE1762839773376	Apl Healthcare Limited	Veeraswamy 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:27:49.901856				Monika	2025-10-16	14:00	9133396887		Hyderabad	\N	2025-11-11 05:42:53.828	2025-11-11 05:42:53.828	0	2025-11-29 06:27:49.901856	\N
143	CASE1762840077981	Sudarshan Farm Chemicals Pvt Ltd	Ajith  - CFO	Telecaller	Meeting Done	32	BL	\N	\N	\N	\N	2025-11-29 07:04:54.729726	Ajith  - CFO			Nikita Mam	2025-10-16	14:30	9820909777	100+ cr	Hyderabad	\N	2025-11-11 05:47:58.41	2025-11-11 05:47:58.41	50000000	2025-11-19 04:40:50.86206	\N
139	CASE1762839915087	Maniora	Manohar	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:27:41.297451				Google	2025-10-16	12:30	9640161711		Hyderabad	\N	2025-11-11 05:45:15.512	2025-11-11 05:45:15.512	0	2025-11-29 06:27:41.297451	\N
155	CASE1762840798511	Pennar Industries	Shankar - CFO	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-29 06:29:33.807594				Prema	2025-04-25	14:30	8008032102	25-50cr	Hyderabad	\N	2025-11-11 05:59:51.879	2025-11-11 05:59:51.879	\N	2025-11-11 05:59:51.909378	\N
140	CASE1762839927486	Sri Indu Constructions	Sreekanth - MD	Telecaller	No Requirement	31	WC	\N	\N	\N	\N	2025-12-15 14:27:13.246835				Mounika	2025-08-14	14:30	8686467989	5-25cr	Hyderabad	\N	2025-11-11 05:45:20.805	2025-11-11 05:45:20.805	1	2025-12-15 14:27:13.246835	\N
145	CASE1762840210341	Chandana Filling Station pvt.ltd	Ram naik	Telecaller	Meeting Done	31	BL	\N	\N	\N	\N	2025-12-01 13:30:01.877519				Mounika	2025-09-03	11:30	9441086666	5-25cr	Asifabad	\N	2025-11-11 05:50:03.643	2025-11-11 05:50:03.643	5000000	2025-12-01 13:30:01.877519	\N
152	CASE1762840615660	Magic Dream Corporation	Pareek - MD	Telecaller	Meeting Done	31	OD	\N	\N	\N	\N	2025-11-29 06:41:29.320628				Google	2025-05-14	11:00	7734001186	5-25cr	Hyderabad	\N	2025-11-11 05:56:49.086	2025-11-11 05:56:49.086	10000000	2025-11-29 05:13:56.651578	\N
169	CASE1762841872228	Covalense technologies pvt.ltd	Krishna Kumari - MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-15 14:24:24.008683				Mounika	2025-10-09	11:00	9948299935	25-50cr	Hyderabad	\N	2025-11-11 06:17:45.706	2025-11-11 06:17:45.706	1	2025-12-15 14:24:24.008683	\N
136	CASE1762839734700	Voltech Power Solutions	Rajashekar	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:27:30.820766				Google	2025-09-05	11:00	9398422625	1-5cr	https://maps.app.goo.gl/AwJyWiqDcxNRGFHF9	\N	2025-11-11 05:42:14.376	2025-11-11 05:42:14.376	1	2025-12-15 14:27:30.820766	\N
156	CASE1762840794380	Neogen Chemicals Limited	Santosh Reddy 	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:47:57.04198				Monika	2025-10-21	14:00	9640054689	50-100cr	Hyderabad	\N	2025-11-11 05:59:54.815	2025-11-11 05:59:54.815	\N	2025-12-15 12:47:57.04198	\N
157	CASE1762840950332	M/S Sree Sivaram & Company	Shiva Ram 	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:40:11.391869				Prema	2025-10-23	12:00	9490164433	50-100cr	Hyderabad	\N	2025-11-11 06:02:30.767	2025-11-11 06:02:30.767	\N	2025-12-15 12:40:11.391869	\N
151	CASE1762840525206	JJ Ceramics	Hardik deliwala	Telecaller	Meeting Done	30	BL	\N	\N	\N	\N	2025-11-29 05:12:16.703789				Mounika	2025-09-01	14:00	9246269369 	1-5cr	https://maps.app.goo.gl/DteNpPmMSts4e1Yv8	\N	2025-11-11 05:55:24.909	2025-11-11 05:55:24.909	5000000	2025-11-29 05:12:16.703789	\N
141	CASE1762839957202	ARIHANT AGENCIES	SHREYAYANSH SHETH	Telecaller	Documentation In Progress	33	BL	\N	\N	\N	\N	2025-11-29 06:27:24.661961				PREMA	2025-10-20	11:00	9246157811	25-50cr	BOIGUDA	\N	2025-11-11 05:45:58.144	2025-11-11 05:45:58.144	50000000	2025-11-29 06:27:24.661961	\N
154	CASE1762840663805	MULTI RESTAURANT	Sathyam	Telecaller	Meeting Done	30	BL	\N	\N	\N	\N	2025-11-29 12:08:04.475387				Prema	2025-08-12	11:30	9000425777 	5-25cr	Warangal	\N	2025-11-11 05:57:43.46	2025-11-11 05:57:43.46	3000000	2025-11-29 12:08:04.475387	\N
165	CASE1762841516298	Leading minds networking solutions	Lakshmidas - MD	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-29 06:31:58.051509				Mounika	2025-09-18	14:00	9246801124	25-50cr	Hyderabad	\N	2025-11-11 06:11:49.802	2025-11-11 06:11:49.802	\N	2025-11-11 06:11:49.831782	\N
144	CASE1762840090042	Integrated System Tools Pvt.Ltd	Praveen - MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-17 09:16:16.854881				Mounika	2025-08-28	15:30	9397607827	1-5cr	Hyderabad	\N	2025-11-11 05:48:03.434	2025-11-11 05:48:03.434	1	2025-12-17 09:16:16.854881	\N
149	CASE1762840480660	Sundaram Alternate Assets Limited	Akhil Cheedella	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:47:28.326872				Srilatha	2025-10-18	13:30	9493625978	100+ cr	Hyderabad	\N	2025-11-11 05:54:41.31	2025-11-11 05:54:41.31	\N	2025-12-15 12:47:28.326872	\N
158	CASE1762840983637	Maxx Electronics	KHAJA HUSSAIN MOHAMMED	Telecaller	Meeting Done	30	BL	\N	\N	\N	\N	2025-11-29 05:14:46.66936				Mounika	2025-09-15	13:30	9912065222	1-5cr		\N	2025-11-11 06:03:03.256	2025-11-11 06:03:03.256	2000000	2025-11-29 05:14:46.66936	\N
160	CASE1762841256000	pooja marketing	Ramesh	Telecaller	Meeting Done	30	BL	\N	\N	\N	\N	2025-11-29 05:14:27.501949				Mounika	2025-08-09	12:30	8179183955	1-5cr	https://maps.app.goo.gl/ffTCxv4WDtK1C4vg8	\N	2025-11-11 06:07:35.59	2025-11-11 06:07:35.59	2000000	2025-11-29 05:14:27.501949	\N
150	CASE1762840513111	Metronix pvt.ltd	Durga malleswar	Telecaller	No Requirement	31	\N	\N	\N	\N	\N	2025-12-04 04:40:24.726223				Google	2025-06-25	10:30	9347040916	1-5cr	Hyderabad	\N	2025-11-11 05:55:06.592	2025-11-11 05:55:06.592	\N	2025-12-04 04:40:24.726223	\N
146	CASE1762840317547	AMC Solutions pvt.ltd	Manohar - MD	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-29 06:39:51.136172				Google	2025-06-11	11:00	8686715909	1-5cr	Hyderabad	\N	2025-11-11 05:51:51	2025-11-11 05:51:51	\N	2025-11-11 05:51:51.001792	\N
166	CASE1762841648757	Cloud ace technologies pvt.ltd	Swarup - CFO	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-29 06:32:39.66414				Mounika	2025-09-22	11:00	9848663861	5-25cr	Hyderabad	\N	2025-11-11 06:14:02.077	2025-11-11 06:14:02.077	\N	2025-11-11 06:14:02.114879	\N
159	CASE1762841235636	Madhu plastics	MADHU - MD	Telecaller	No Requirement	31	\N	\N	\N	\N	\N	2025-11-29 06:10:39.211281				Google	2025-05-13	15:00	8121495937	1-5cr	Hyderabad	\N	2025-11-11 06:07:09.123	2025-11-11 06:07:09.123	\N	2025-11-25 07:03:06.010827	\N
148	CASE1762840434189	Shri Salasar industries	ANAND KUMAR - MD	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-29 06:11:05.173349				Prema	2025-06-23	15:00	9849668711	5-25cr	Hyderabad	\N	2025-11-11 05:53:47.633	2025-11-11 05:53:47.633	\N	2025-11-11 05:53:47.66248	\N
167	CASE1762841771663	Sri Sai Hardware	Raju	Telecaller	Open	31	\N	\N	\N	\N	\N	2025-11-11 06:16:15.174831				Prema	2025-10-09	15:00	9246507653	25-50cr	https://maps.app.goo.gl/j77cmex3gfPaJabg9	\N	2025-11-11 06:16:05.031	2025-11-11 06:16:05.031	\N	2025-11-11 06:16:05.061694	\N
168	CASE1762841792863	Sri Anjaneeya Siri Lucky Agencies	Ramesh Utlapally 	Telecaller	Meeting Done	32	BL	\N	\N	\N	\N	2025-11-21 12:13:37.560519				Prema	2025-10-28	13:30	9959152226	1-5cr	Hyderabad	\N	2025-11-11 06:16:33.492	2025-11-11 06:16:33.492	8000000	2025-11-21 12:13:37.560519	\N
164	CASE1762841372227	Aradhya Infra Projects Private Limited	Ramesh	Telecaller	Open	30	\N	\N	\N	\N	\N	2025-11-11 06:17:13.925283				Prema	2025-08-20	13:30	9949958853	1-5cr		\N	2025-11-11 06:09:31.789	2025-11-11 06:09:31.789	\N	2025-11-11 06:09:31.819126	\N
171	CASE1762842152318	P Satyanarayana Sons Private Limited	Kushal Gilda 	Telecaller	No Requirement	32	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 06:34:24.831574				Srilatha	2025-10-31	14:00	9030568659	100+ cr	Hyderabad	\N	2025-11-11 06:22:32.804	2025-11-11 06:22:32.804	1	2025-11-29 06:34:24.831574	\N
162	CASE1762841323679	JEWELLRY BUSINESS	VENKATESH	Telecaller	Open	33	\N	\N	\N	\N	\N	2025-11-11 06:20:02.190147				SELF	2025-05-11	11:00	9880637231	1-5cr	HYDERABAD	\N	2025-11-11 06:08:44.624	2025-11-11 06:08:44.624	\N	2025-11-11 06:08:44.652911	\N
161	CASE1762841277799	NCC 	Jatin Singhala 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:35:00.237776				Google	2025-10-25	13:00	9701666893	50-100cr	Hyderabad	\N	2025-11-11 06:07:58.236	2025-11-11 06:07:58.236	0	2025-11-29 06:35:00.237776	\N
184	CASE1762845747413	Flexid Technopack pvt.ltd	Ramesh -MD	Telecaller	No Requirement	31	\N	\N	\N	\N	\N	2025-11-29 05:58:44.227221				Nikitha	2025-11-12	11:30	9963944443	50-100cr	Hyderabad	\N	2025-11-11 07:22:20.595	2025-11-11 07:22:20.595	\N	2025-11-29 05:58:44.227221	\N
204	CASE1763370568575	AHALADA CLEAN ROOM TECH PVT LIMITED	CHENNAREDDY	Telecaller	No Requirement	33	\N	\N	\N	\N	\N	2025-12-18 11:44:10.981734				SRILATHA	2025-11-18	11:30	9182968864	50-100cr	HYDERABAD	\N	2025-11-17 09:09:28.457	2025-11-17 09:09:28.457	\N	2025-12-18 11:44:10.981734	\N
183	CASE1762845471662	Sai Balaji Digitals Private Limited	Mahesh (CFO)	Telecaller	No Requirement	30	Small LAP upto 7cr	\N	\N	\N	\N	2025-12-15 14:22:36.421189				Mounika	2025-09-30	12:30	8143222000	5-25cr	https://maps.app.goo.gl/vD8hjPHKoiaHoWGC7	\N	2025-11-11 07:17:51.107	2025-11-11 07:17:51.107	1	2025-12-15 14:22:36.421189	\N
179	CASE1762843384332	Mustang services	Anil - MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-15 14:23:27.902193				Prema	2025-10-24	11:30	9246531555	25-50cr	Hyderabad	\N	2025-11-11 06:42:57.793	2025-11-11 06:42:57.793	1	2025-12-15 14:23:27.902193	\N
200	CASE1763369621865	AURO INFRA	YASHWANTH -CFO	Telecaller	Meeting Done	33	WC	\N	\N	\N	\N	2025-11-29 06:18:42.402644				MOUNIKA	2025-11-14	13:30	9705206850	100+ cr	HYDERABAD	\N	2025-11-17 08:53:42.776	2025-11-17 08:53:42.776	1000000000	2025-11-21 12:12:12.503019	\N
174	CASE1762842911935	Hyuip systems limited	Vydehi -CFO	Telecaller	No Requirement	31	Machinery funding upto 7cr	\N	\N	\N	\N	2025-12-15 14:23:56.927144				Prema	2025-09-02	15:00	9281163625	50-100cr	Hyderabad	\N	2025-11-11 06:35:04.929	2025-11-11 06:35:04.929	1	2025-12-15 14:23:56.927144	\N
180	CASE1762843520415	chakravarthy agency	Shahnawaz	Telecaller	No Requirement	30	\N	\N	\N	\N	\N	2025-11-29 12:20:07.902217				prema	2025-09-25	13:30	8919292497	5-25cr		\N	2025-11-11 06:45:20.09	2025-11-11 06:45:20.09	\N	2025-11-29 12:20:07.902217	\N
4	CASE1761910298881	P Satyanarayan Sons Private Limited 	Kushal Gilda CFO	Telecaller	No Requirement	32	Small LAP upto 7CR	\N	\N	\N	\N	2025-12-16 11:45:39.769474				srilatha	2025-11-01	13:00	9030568659	100+ cr	Hyderabad	\N	2025-10-31 11:31:40.691	2025-10-31 11:31:40.691	1	2025-12-16 11:45:39.769474	\N
186	CASE1762845923683	ARY TECHNOLOGIES (OPC) PRIVATE LIMITED	Rehman (MD)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:22:26.29234				mounika	2025-10-09	04:00	8919798815	1-5cr		\N	2025-11-11 07:25:23.122	2025-11-11 07:25:23.122	1	2025-12-15 14:22:26.29234	\N
177	CASE1762843138846	SELFY TECHNOLOGIES	Venkat (CFO)	Telecaller	No Requirement	30	Small LAP - upto 5CR	\N	\N	\N	\N	2025-12-15 14:23:46.45944				Mounika	2025-08-12	12:30	9000081705	5-25cr		\N	2025-11-11 06:38:58.489	2025-11-11 06:38:58.489	1	2025-12-15 14:23:46.45944	\N
202	CASE1763370420586	Avinya Automations	Murthy CFO	Telecaller	No Requirement	32	WC	\N	\N	\N	\N	2025-11-29 06:36:16.442719				Monika	2025-11-17	11:00	9885339400	1-5cr	Hyderabad	\N	2025-11-17 09:07:00.234	2025-11-17 09:07:00.234	1	2025-11-29 06:36:16.442719	\N
175	CASE1762842912358	Sivasatya Engineering Services pvt.ltd	Arjun rao - MD	Telecaller	No Requirement	31	\N	\N	\N	\N	\N	2025-11-29 12:07:40.763353				Prema	2025-10-23	10:30	9666101818	100+ cr	https://maps.app.goo.gl/seYQaeFG6WqniCDp7	\N	2025-11-11 06:35:05.317	2025-11-11 06:35:05.317	\N	2025-11-29 12:07:40.763353	\N
178	CASE1762843142249	Eshsam Enterprises Pvt Ltd	Krishna prasad	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:26:33.918796				Google	2025-08-12	12:30	 9535566133	1-5cr		\N	2025-11-11 06:39:01.292	2025-11-11 06:39:01.292	1	2025-12-15 14:26:33.918796	\N
191	CASE1763185646398	GK Builders	Gopal Krishna Bobba - MD	Telecaller	Meeting Done	32	WC	\N	\N	\N	\N	2025-11-29 07:04:23.611668	Gopal Krishna Bobba - MD			Irfan Sir	2025-11-12	11:00	8125153011	5-25cr	Hyderabad	\N	2025-11-15 05:47:27.22	2025-11-15 05:47:27.22	20000000	2025-11-17 04:16:50.536753	\N
195	CASE1763186470651	M/S Sree Sivaram & Company	Shivaram Chitiki Reddy 	Telecaller	Open	32	\N	\N	\N	\N	\N	2025-11-15 06:01:44.308691				Prema	2025-11-14	13:00	9490164433	50-100cr	Hyderabad	\N	2025-11-15 06:01:11.638	2025-11-15 06:01:11.638	\N	2025-11-15 06:01:11.667301	\N
197	CASE1763186948340	Allied Auto Agencies Private Limited	Roopesh Kumandas Shah - MD	Telecaller	Documentation Initiated	32	Small LAP upto 7CR	\N	\N	\N	\N	2025-11-29 07:03:35.863867	Roopesh Kumandas Shah - MD			Monika	2025-11-14	14:30	9346234220	50-100cr	Hyderabad	\N	2025-11-15 06:09:09.196	2025-11-15 06:09:09.196	40000000	2025-11-17 09:33:47.371877	\N
182	CASE1762844229667	TELANGANA CHEMTECH CORPORATION	MD OMER 	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:23:02.663003				Google	2025-09-24	13:30	9989124090	1-5cr		\N	2025-11-11 06:57:09.266	2025-11-11 06:57:09.266	1	2025-12-15 14:23:02.663003	\N
176	CASE1762842917468	Madhura Landscapes	Srikanth (CFO)	Telecaller	One Pager	30	OD	\N	\N	One Pager	\N	2025-11-29 06:45:07.103921				Google	2025-08-14	12:00	9550070588 	5-25cr	https://maps.app.goo.gl/Pje4A2Rp7NjQZuwAA	\N	2025-11-11 06:35:17.102	2025-11-11 06:35:17.102	1	2025-11-29 03:29:20.696653	\N
115	CASE1762838665957	Wipro Vlsi Design Services India Pvt Ltd 	Leela Ravindra	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:35:48.387149				Prema	2025-10-04	15:00	9959431197		Hyderabad	\N	2025-11-11 05:24:26.417	2025-11-11 05:24:26.417	0	2025-11-29 06:35:48.387149	\N
203	CASE1763370566141	DIGIGRAIN SOLUTIONS PVT LIMITED	ROSIAH YELLURI -MD	Telecaller	One Pager	33	OD	\N	\N	\N	\N	2025-12-29 10:02:15.355512	ROSIAH YELLURI -MD			SRILATHA	2025-11-18	11:00	9324294357	100+ cr	HYDERABAD	\N	2025-11-17 09:09:26.839	2025-11-17 09:09:26.839	15000000	2025-12-29 10:02:15.355512	\N
185	CASE1762845744485	andhra timber & packing industries	Rohith (CFO)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:22:44.660809				mounika	2025-09-24	12:00	9533929291	5-25cr	https://maps.app.goo.gl/CkisheHP4vLHtuvX7	\N	2025-11-11 07:22:23.962	2025-11-11 07:22:23.962	1	2025-12-15 14:22:44.660809	\N
187	CASE1762846378686	haneesh constructions	Bhakthavatchala reddy (DIRECTOR)	Telecaller	One Pager	30	OD	\N	\N	\N	\N	2025-12-29 10:02:26.047027				Prema	2025-11-12	11:00	 9440790901	25-50cr	https://maps.app.goo.gl/2v1V2NVzGR4nw3acA	\N	2025-11-11 07:32:58.122	2025-11-11 07:32:58.122	250000000	2025-12-29 10:02:26.047027	\N
218	CASE1763554564523	Auro Infra Private Limited	Chenna Keshava	Telecaller	Meeting Done	32	WC	\N	\N	Documentation	\N	2025-11-29 06:58:13.022817				Srilatha	2025-11-20	13:30	9908549977	100+ cr	Hyderabad	\N	2025-11-19 12:16:04.441	2025-11-19 12:16:04.441	1000000000	2025-11-29 06:58:13.022817	\N
198	CASE1763187103363	Sudarshan Farm Chemicals Pvt Ltd	Ajith - MD	Telecaller	Meeting Done	32	WC	\N	\N	\N	\N	2025-11-29 07:03:22.661765	Ajith - MD			Nikita Mam 	2025-11-17	15:00	9820909777	100+ cr	Hyderabad	\N	2025-11-15 06:11:44.362	2025-11-15 06:11:44.362	500000000	2025-11-19 10:38:33.461565	\N
189	CASE1762857249375	AMD India Private Limited	Mahesh Shroff	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:26:09.093588				Monika	2025-11-12	11:30	9959455536	100+ cr	Hyderabad	\N	2025-11-11 10:34:09.206	2025-11-11 10:34:09.206	0	2025-11-29 06:26:09.093588	\N
192	CASE1763185803230	Roxy Automotives	Moiz - MD	Telecaller	Meeting Done	32	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 07:04:09.077397	Moiz - MD			Prema	2025-11-14	11:30	7799299909	100+ cr	Hyderabad	\N	2025-11-15 05:50:04.173	2025-11-15 05:50:04.173	40000000	2025-11-17 04:16:12.791113	\N
181	CASE1762843909171	Glo Led Private Limited	sambi reddy (CFO)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-15 14:23:10.722179				Mounika	2025-09-24	16:30	9441051844	5-25cr		\N	2025-11-11 06:51:48.849	2025-11-11 06:51:48.849	1	2025-12-15 14:23:10.722179	\N
193	CASE1763185984378	Yokohama India Private Limited	Kamal Jhawar	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-18 11:44:15.914318				Prema	2025-11-13	14:30	9830507137	100+ cr	Hyderabad	\N	2025-11-15 05:53:05.234	2025-11-15 05:53:05.234	\N	2025-12-18 11:44:15.914318	\N
199	CASE1763368979329	Rathna Sai Bharat Gas Agency 	Sanjay Kumar Uppulappu CFO	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:35:59.68155				Monika	2025-11-18	12:00	9030500000	25-50cr	Siddhipet 	\N	2025-11-17 08:42:58.862	2025-11-17 08:42:58.862	1	2025-11-29 06:35:59.68155	\N
201	CASE1763369623343	IN AND OUT FOOD INGREDIENTS	SRINIVAS RAO	Telecaller	Meeting Done	33	WC	\N	\N	Documentation	\N	2025-11-19 08:59:57.535271				IRFAN	2025-11-18	11:00	7093381999	100+ cr	HYDERABAD	\N	2025-11-17 08:53:43.221	2025-11-17 08:53:43.221	600000000	2025-11-18 09:22:41.590711	\N
207	CASE1763442727419	EXPAND ADS AND FABRICATIONS	SHAIK JAVEEDH -MD	Telecaller	Meeting Done	31	Machinery funding upto 7cr	\N	\N	Documentation	\N	2025-11-29 07:17:25.823146	SHAIK JAVEEDH -MD		8885451814	MOUNIKA	2025-11-18	12:00	8885451814	1-5cr	https://maps.app.goo.gl/hTWoqek9iWGyJMEn7?g_st=aw	\N	2025-11-18 05:11:56.922	2025-11-18 05:11:56.922	20000000	2025-11-18 07:31:33.043862	\N
229	CASE1763708290628	GHR Infra	Shailender (Director)	Telecaller	No Requirement	30	WC	\N	\N	Documentation	\N	2025-12-16 11:34:11.893345				Mounika	2025-11-24	13:00	9553918833	50-100cr	https://maps.app.goo.gl/VxXXJpn4TAp5pND2A	\N	2025-11-21 06:58:10.498	2025-11-21 06:58:10.498	1	2025-12-16 11:34:11.893345	\N
210	CASE1763451322432	REDDSON ENGINEERING	GANGADHAR REDDY - MD	Telecaller	No Requirement	31	BL	\N	\N	Documentation	\N	2025-12-15 14:25:18.62918	GANGADHAR REDDY - MD		9848050948		2025-11-18	11:00	9848050948	100+ cr	HYDERABAD	\N	2025-11-18 07:35:11.935	2025-11-18 07:35:11.935	40	2025-12-15 14:25:18.62918	\N
222	CASE1763640521596	EUROTECK ENVIRONMENTAL PVT LTD	VIJAY KUMAR - CFO	Telecaller	Meeting Done	33	BL	\N	\N	Documentation	\N	2025-11-29 07:11:45.260516	VIJAY KUMAR - CFO		9618888955	MOUNIKA	2025-11-20	06:00	9618888955	100+ cr	HITECH CITY	\N	2025-11-20 12:08:42.51	2025-11-20 12:08:42.51	20000000	2025-11-21 04:51:28.136378	\N
217	CASE1763544129762	Aryavart Agencies	Deepak Agarwal Director	Telecaller	Documentation In Progress	32	WC	\N	\N	Documentation	\N	2025-12-08 15:07:20.83168	Deepak Agarwal Director		8897430009	Srilatha	2025-11-20	14:00	8897430009	50-100cr	Hyderabad	\N	2025-11-19 09:22:09.715	2025-11-19 09:22:09.715	60000000	2025-12-08 15:07:20.83168	\N
223	CASE1763701219138	Mahalakshmi  Tayaru Kothamasu	Reddy	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-15 12:49:41.860887				Prema	2025-11-21	12:00	7396960505	5-25cr	Hyderabad	\N	2025-11-21 05:00:19.752	2025-11-21 05:00:19.752	\N	2025-12-15 12:49:41.860887	\N
231	CASE1763714634849	Sri Devi Associates India Private Limited	M Ganesh  Director	Telecaller	Documentation Initiated	32	Small LAP - upto 5CR	\N	\N	Documentation	\N	2025-11-29 07:02:30.534706	M Ganesh  Director		9866182857	Monika	2025-11-24	15:00	9866182857	100+ cr	Hyderabad	\N	2025-11-21 08:43:55.045	2025-11-21 08:43:55.045	35000000	2025-11-25 07:12:51.976395	\N
215	CASE1763542676760	SURYA ENTERPRISES	SRINIVAS	Telecaller	No Requirement	33	BL	\N	\N	Documentation	\N	2025-11-29 06:36:45.096041				IRFAN	2025-11-19	04:30	9440853810	25-50cr	ONGOLE	\N	2025-11-19 08:57:57.318	2025-11-19 08:57:57.318	1	2025-11-29 06:36:45.096041	\N
219	CASE1763615717221	Aneri Construction Private Limited	Vikas Upadhyay CFO	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-11-29 06:21:09.706117				Srilatha	2025-11-21	11:30	9558741111	25-50cr	Gujarat , Surat 	\N	2025-11-20 05:15:18.128	2025-11-20 05:15:18.128	\N	2025-11-25 10:32:30.410384	\N
205	CASE1763372371236	Sri Anjaneeya Siri Lucky Agencies	Ramesh Utlapally Director	Telecaller	Documentation In Progress	32	BL	\N	\N	\N	\N	2025-11-29 06:25:11.173976				Monika	2025-11-17	05:00	9959152226	5-25cr	Hyderabad 	\N	2025-11-17 09:39:32.127	2025-11-17 09:39:32.127	80000000	2025-11-29 06:25:11.173976	\N
84	CASE1762837335105	JAYRAM INDUSTRIES INDIA PRIVATE LIMITED	Sathish babu (MD)	Telecaller	No Requirement	30	BL	\N	\N	\N	\N	2025-12-16 11:51:13.463215	Sathyanarayana		 91005 52244	Prema	2025-09-09	14:00	 9560488888 	50-100cr	https://maps.app.goo.gl/B99UdwQ4KgvWufVo9	\N	2025-11-11 05:02:14.826	2025-11-11 05:02:14.826	0	2025-12-16 11:51:13.463215	\N
230	CASE1763708523280	SRI RAMA CONSTRUCTIONS	SRINIVAS RAO - MD	Telecaller	Meeting Done	33	LAP	\N	\N	Documentation	\N	2025-12-01 10:03:24.706428				SRILATHA	2025-11-22	11:30	9642616666	25-50cr	KUKATPALLY	\N	2025-11-21 07:02:04.005	2025-11-21 07:02:04.005	40000000	2025-12-01 10:03:24.706428	\N
214	CASE1763542475926	SPECTRALABS	VISHNU - MD	Telecaller	No Requirement	33	BL	\N	\N	Documentation	\N	2025-12-16 11:36:20.809142	VISHNU - MD		7702296279	IRFAN	2025-11-19	12:00	7702296279	5-25cr	HYDERABAD	\N	2025-11-19 08:54:36.477	2025-11-19 08:54:36.477	1	2025-12-16 11:36:20.809142	\N
224	CASE1763702198816	KOSCA DISTRIBUTION LLP	SATISH	Telecaller	No Requirement	33	WC	\N	\N	Documentation	\N	2025-11-29 06:36:54.904199				SRILATHA	2025-11-20	11:30	6380750904	25-50cr	CHENNAI	\N	2025-11-21 05:16:39.489	2025-11-21 05:16:39.489	5	2025-11-29 06:36:54.904199	\N
209	CASE1763442996709	BUILDSUVIDHA INDIA PVT.LTD	PRABHANJAN -MD	Telecaller	No Requirement	31	BL	\N	\N	Documentation	\N	2025-12-15 14:25:10.463526	PRABHANJAN -MD		9885647661	MOUNIKA	2025-11-18	11:30	9885647661	25-50cr	https://maps.app.goo.gl/JhJ6JFyw4pqPsk2aA	\N	2025-11-18 05:16:26.195	2025-11-18 05:16:26.195	1	2025-12-15 14:25:10.463526	\N
227	CASE1763702934728	pennant technologies private limited	Nagasubba reddy (CFO)	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 06:18:38.160439				Prema	2025-11-21	12:00	9666636267	100+ cr	https://maps.app.goo.gl/br9LMUvWRWxgrTmb7	\N	2025-11-21 05:28:54.563	2025-11-21 05:28:54.563	\N	2025-11-21 05:28:54.592681	\N
220	CASE1763618269726	POOJA JEWELLERS	RAJENDER -MD	Telecaller	Meeting Done	31	WC	\N	\N	Documentation	\N	2025-11-29 07:12:40.251982	RAJENDER -MD		9885074605	PREMA	2025-11-20	12:30	9885074605	100+ cr	https://maps.app.goo.gl/4cAUvktBhMViJmGu5	\N	2025-11-20 05:57:38.605	2025-11-20 05:57:38.605	60000000	2025-11-21 04:51:46.188959	\N
206	CASE1763442514766	M S HVAC ELECTROMECHANICALS PVT LTD	SARWAR - MD	Telecaller	Login	31	Small LAP - upto 5CR	\N	\N	Underwriting	\N	2025-12-29 10:01:58.42093	SARWAR - MD		 9849779706	PREMA	2025-11-18	11:30	 9849779706	1-5cr	HYDERABAD	\N	2025-11-18 05:08:24.241	2025-11-18 05:08:24.241	20000000	2025-12-29 10:01:58.42093	\N
232	CASE1763717344445	KSR Infra	Shiva kumar (Director)	Telecaller	No Requirement	30	BL	\N	\N	Documentation	\N	2025-12-16 11:34:00.126304				Mounika	2025-11-24	11:00	9542291000	5-25cr		\N	2025-11-21 09:29:03.568	2025-11-21 09:29:03.568	1	2025-12-16 11:34:00.126304	\N
211	CASE1763534794920	BLUEWAVE IT SOLUTIONS INDIA PVT.LTD	SRINIVASA RAJA -MD	Telecaller	Meeting Done	31	WC	\N	\N	Documentation	\N	2025-11-29 07:15:43.758252	SHASTRY - CFO		7989354779	MOUNIKA	2025-11-19	11:00	8885514488	100+ cr	https://maps.app.goo.gl/L1EgyFKGNW8DK7P48	\N	2025-11-19 06:46:24.122	2025-11-19 06:46:24.122	150000000	2025-11-19 08:48:07.879828	\N
221	CASE1763618459035	SANDEEP ISPAT	SANDEEP -MD	Telecaller	No Requirement	31	BL	\N	\N	Documentation	\N	2025-12-16 11:34:40.377417				MOUNIKA	2025-11-20	11:00	9849024112	100+ cr	https://maps.app.goo.gl/nCvo6KvR2QiKtJdH8	\N	2025-11-20 06:00:47.881	2025-11-20 06:00:47.881	1	2025-12-16 11:34:40.377417	\N
225	CASE1763702200488	Z INDUSTRIES PVT LTD	ABDUL -M.D	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-11-29 06:16:26.050173				MOUNIKA	2025-11-24	11:30	9246176867	25-50cr	BANJARA HILLS	\N	2025-11-21 05:16:40.642	2025-11-21 05:16:40.642	\N	2025-11-25 12:44:12.923149	\N
47	CASE1762753646383	Madhucon Projects	Samba Shiva Rao	Telecaller	Documentation In Progress	29	WC	\N	\N	Documentation	\N	2025-11-29 06:31:37.226431				\N	2025-11-10	11:30	9848018757	100+ cr		\N	2025-11-10 05:47:27.02	2025-11-10 05:47:27.02	1000000000	2025-11-29 06:31:37.226431	\N
213	CASE1763542084786	JAININDIA STEEL CORPERATION	ROHIT -CFO	Telecaller	No Requirement	33	Machinery funding upto 7cr	\N	\N	Documentation	\N	2025-11-29 06:39:12.698637				SRILATHA	2025-11-19	11:30	9849911288	100+ cr	HYDERABAD	\N	2025-11-19 08:48:04.527	2025-11-19 08:48:04.527	1	2025-11-29 06:39:12.698637	\N
212	CASE1763542082443	TSR NIRMAN PVT LTD	SURESH -M.D	Telecaller	One Pager	33	WC	\N	\N	Documentation	\N	2025-12-29 10:02:07.068468	SRINIVAS			CHAITHANYA	2025-11-20	11:30	9900021999	100+ cr	HYDERABAD	\N	2025-11-19 08:48:03.007	2025-11-19 08:48:03.007	1000000000	2025-12-29 10:02:07.068468	\N
208	CASE1763442861051	GLOBUS GLOBAL TRADE IMPORT AND EXPORT PVT.LTD	SYED BASHEER -MD	Telecaller	No Requirement	31	WC	\N	\N	Documentation	\N	2025-11-29 06:36:25.381367				MOUNIKA	2025-11-18	16:00	9912211126	1-5cr	https://maps.app.goo.gl/f58vutkHrBJykF2ZA	\N	2025-11-18 05:14:10.568	2025-11-18 05:14:10.568	10000000	2025-11-29 06:36:25.381367	\N
250	CASE1764064444019	M/S Srinivasa Sales & Service Pvt Ltd	Ganesh CFO	Telecaller	Meeting Done	32	BL	\N	\N	Documentation	\N	2025-11-29 07:02:12.449887	Ganesh CFO			Srilatha	2025-11-26	13:00	8297157999	100+ cr	Vijayawada	\N	2025-11-25 09:54:04.919	2025-11-25 09:54:04.919	30000000	2025-11-26 12:57:27.780058	\N
255	CASE1764140926286	S V Interiors Private Limited	Srinivasa Raju  -  MD	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-16 11:33:44.804228	Srinivasa Raju  -  MD			Irfan Sir	2025-11-24	14:00	9393114646	1-5cr	Hyderabad	\N	2025-11-26 07:08:47.447	2025-11-26 07:08:47.447	\N	2025-12-16 11:33:44.804228	\N
233	CASE1763961099583	Seneca Global IT Services Private Limited	Abhilash 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-11-24 05:12:00.30376				Monika	2025-11-24	12:00	9849824777	50-100cr	Hyderabad	\N	2025-11-24 05:11:40.145	2025-11-24 05:11:40.145	\N	2025-11-24 05:11:40.185202	\N
260	CASE1764235668458	Vbb Infra Private Limited	Vijay Bhahadur CFO	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-11-29 06:14:15.999236				Srilatha	2025-11-28	11:00	9999246514	50-100cr	Delhi	\N	2025-11-27 09:27:49.004	2025-11-27 09:27:49.004	\N	2025-11-28 12:59:13.328262	\N
252	CASE1764136624464	Best infra private limited	Srinivasa rao (Director)	Telecaller	Documentation In Progress	30	Machinery funding upto 7cr	\N	\N	Documentation	\N	2025-11-29 06:12:17.446946				Prema	2025-11-27	15:00	7702943339	100+ cr	https://maps.app.goo.gl/X6zKxrqG6bqm21mP9	\N	2025-11-26 05:57:03.342	2025-11-26 05:57:03.342	200000000	2025-11-28 06:25:37.939478	\N
246	CASE1763973948471	SREEVEN PHARMA	DEVENDRAPPA	Telecaller	No Requirement	33	BL	\N	\N	Underwriting	\N	2025-11-29 06:37:38.012227				M0UNIKA	2025-11-24	15:30	9342019055	50-100cr	BIDAR	\N	2025-11-24 08:45:47.799	2025-11-24 08:45:47.799	1	2025-11-29 06:37:38.012227	\N
258	CASE1764223128315	 ILIOS Power	Naveen (Director)	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-11-29 12:07:28.765811				Nitheesh sir	2025-11-28	04:00	 9177777734		https://maps.app.goo.gl/hEhqE1u8HCN1CKoB8	\N	2025-11-27 05:58:47.509	2025-11-27 05:58:47.509	\N	2025-11-29 12:07:28.765811	\N
243	CASE1763963147413	KSR Homes	Varma (Director)	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 06:13:57.504435				Nitheesh sir	2025-11-25	15:30	9000599599	5-25cr	Hyderabad	\N	2025-11-24 05:45:45.909	2025-11-24 05:45:45.909	\N	2025-11-24 05:45:45.938699	\N
241	CASE1763961798076	Vajram Constructions Pvt Ltd	Vajram Constructions Pvt Ltd	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-11-29 06:36:34.565558				\N	2025-11-24	12:30	8179007074	25-50cr	hyderabad	\N	2025-11-24 05:23:19.141	2025-11-24 05:23:19.141	\N	2025-11-29 06:36:34.565558	\N
259	CASE1764234777768	REALTIME INTEGRATED INFRATECH PRIVATE LIMITED	Balaraj (Director)	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 06:11:09.8495				Prema	2025-11-28	12:00	9000858557	100+ cr	Habsiguda	\N	2025-11-27 09:12:58.658	2025-11-27 09:12:58.658	\N	2025-11-27 09:12:58.696385	\N
245	CASE1763973946337	GEETHA AUTO	KOMAL CHINNA - CFO	Telecaller	Meeting Done	33	WC	\N	\N	Documentation	\N	2025-11-29 07:01:48.835348	KOMAL CHINNA - CFO		7337441552	PREMA	2025-11-25	12:00	7337441552	50-100cr	WARANGAL	\N	2025-11-24 08:45:46.425	2025-11-24 08:45:46.425	300000000	2025-11-28 06:25:54.705505	\N
249	CASE1764054076409	Sri scl infratech limited	Baskara chary (CFO)	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 06:13:25.999509				prema	2025-11-26	14:00	9246667709	100+ cr	Banjara hills road no.7	\N	2025-11-25 07:01:16.648	2025-11-25 07:01:16.648	\N	2025-11-25 07:01:16.649998	\N
253	CASE1764136680225	SAIBABA EXPORTS	VIKRAM -MD	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-11-29 06:38:33.683614				MOUNIKA	2025-11-26	14:00	7032654458	5-25cr	https://maps.app.goo.gl/A2YVMWGz6FMhRUp27?g_st=aw	\N	2025-11-26 05:58:00.209	2025-11-26 05:58:00.209	\N	2025-11-29 06:38:33.683614	\N
378	CASE1764404230572	Savitr Solar	Ramesh Anangi	Telecaller	Done	1	WC	\N	\N	Documentation	\N	2025-12-29 09:58:11.655667				\N	2025-11-05	02:00	9885100054	100+ cr		\N	2025-11-29 07:45:56.492	2025-11-29 07:45:56.492	100000000	2025-12-29 09:58:11.655667	\N
190	CASE1762858802202	GENNEX LABORATORIES LTD	SANTOSH - CFO	Telecaller	Meeting Done	33	BL	\N	\N	Documentation	\N	2025-11-29 07:04:42.690599	SANTOSH - CFO			IRFAN	2025-11-12	06:00	9346516027	100+ cr	SRINAGAR COLONY	\N	2025-11-11 11:00:02.999	2025-11-11 11:00:02.999	12000000	2025-11-17 11:19:10.488044	\N
251	CASE1764065401623	SAI SIRI ELECTRONICS INDIA PVT.LTD	SAI RAM - MD	Telecaller	Meeting Done	31	BL	\N	\N	Documentation	\N	2025-11-29 07:02:00.229691	SAI RAM - MD			MOUNIKA	2025-11-25	11:30	8790426230	100+ cr	HYDERABAD	\N	2025-11-25 10:10:02.733	2025-11-25 10:10:02.733	30000000	2025-11-25 10:32:05.843387	\N
257	CASE1764150571308	Vishal Personal Care Limited	Prasanna 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-11-26 09:49:55.656201				Srilatha	2025-11-27	14:30	8008811006	50-100cr	Hyderabad	\N	2025-11-26 09:49:32.249	2025-11-26 09:49:32.249	\N	2025-11-26 09:49:32.286665	\N
242	CASE1763961873906	Sai Jewellers	Sai Jewellers	Telecaller	No Requirement	29	BL	\N	\N	Documentation	\N	2025-11-29 06:23:51.834035				\N	2025-11-24	14:00	9346179170	380crs		\N	2025-11-24 05:24:35.041	2025-11-24 05:24:35.041	0	2025-11-29 06:23:51.834035	\N
248	CASE1764052495073	U.B.ENGNEERING	UDAY BHASKAR - DIRECTOR	Telecaller	Meeting Done	33	WC	\N	\N	Documentation	\N	2025-11-29 07:00:59.879883	UDAY BHASKAR - DIRECTOR		9849668859	CHAITHANYA	2025-11-28	02:00	9849668859	25-50cr	CHERLAPALLY	\N	2025-11-25 06:34:54.096	2025-11-25 06:34:54.096	60000000	2025-11-28 11:37:14.119906	\N
240	CASE1763961694158	engineers associates pvt ltd	engineers associates pvt ltd	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:31:29.727415				\N	2025-11-24	10:30	8008703636	50-100cr	banjara hills	\N	2025-11-24 05:21:35.148	2025-11-24 05:21:35.148	\N	2025-12-15 12:31:29.727415	\N
170	CASE1762841987974	Indie Jewel Fashions Private Limited	Mr Ghosh 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:26:28.55228				Prema	2025-10-29	13:30	8910022734	50-100cr	Hyderabad	\N	2025-11-11 06:19:48.463	2025-11-11 06:19:48.463	0	2025-11-29 06:26:28.55228	\N
244	CASE1763973936989	GHK INFRA PROJECTS PVT.LTD	HARI KRISHNA -MD	Telecaller	No Requirement	31	BL	\N	\N	Documentation	\N	2025-11-29 06:37:23.646849				MOUNIKA	2025-11-24	11:00	8106278999	5-25cr	https://maps.app.goo.gl/FAJnruR7oNSCi2cs9	\N	2025-11-24 08:45:34.11	2025-11-24 08:45:34.11	1	2025-11-29 06:37:23.646849	\N
237	CASE1763961487013	coverit flair	coverit flair	Telecaller	Meeting Done	29	BL	\N	\N	Documentation	\N	2025-11-29 06:37:30.399085				\N	2025-11-24	12:00	9989431666	5-25cr	hyderabad	\N	2025-11-24 05:18:07.207	2025-11-24 05:18:07.207	3500000	2025-11-29 06:37:30.399085	\N
239	CASE1763961635844	VN Marine Food	VN Marine Food	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:22:20.965276				\N	2025-11-24	13:00	9381215563	5-25cr	vizag	\N	2025-11-24 05:20:36.358	2025-11-24 05:20:36.358	\N	2025-12-15 12:22:20.965276	\N
379	CASE1764402358583	Akshara Engineering	Aditya	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:06:11.341424				\N	2025-11-29	11:30	9701346348		hyd	\N	2025-11-29 07:45:59.518	2025-11-29 07:45:59.518	50000000	2025-12-15 12:06:11.341424	\N
236	CASE1763961486296	coverit flair	coverit flair	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:22:34.756087				\N	2025-11-24	12:00	9989431666	5-25cr	hyderabad	\N	2025-11-24 05:18:06.757	2025-11-24 05:18:06.757	\N	2025-12-15 12:22:34.756087	\N
235	CASE1763961484646	coverit flair	coverit flair	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:22:43.182451				\N	2025-11-24	12:00	9989431666	5-25cr	hyderabad	\N	2025-11-24 05:18:04.827	2025-11-24 05:18:04.827	\N	2025-12-15 12:22:43.182451	\N
247	CASE1764052492961	RAGHURAM SYNTHESIS	ANUP	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-15 12:31:23.003511				MOUNIKA	2025-11-26	11:30	9440480000	100+ cr	HYDERABAD	\N	2025-11-25 06:34:52.802	2025-11-25 06:34:52.802	\N	2025-12-15 12:31:23.003511	\N
234	CASE1763961482563	coverit flair	coverit flair	Telecaller	Meeting Done	29	BL	\N	\N	Documentation	\N	2025-12-15 12:23:16.535093				\N	2025-11-24	12:00	9989431666	5-25cr	hyderabad	\N	2025-11-24 05:18:03.65	2025-11-24 05:18:03.65	3500000	2025-12-15 12:23:16.535093	\N
238	CASE1763961580379	clr facilities services pvt ltd	clr facilities services pvt ltd	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:31:32.289549				\N	2025-11-24	13:00	9763382441	500crs	Nalagonda	\N	2025-11-24 05:19:41.445	2025-11-24 05:19:41.445	\N	2025-12-15 12:31:32.289549	\N
256	CASE1764147995254	MANNE CONSTRUCTIONS	NARESH-MD	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-16 11:31:26.766442	NARESH-MD			MOUNIKA	2025-11-26	12:00	9676158899	5-25cr	HYDERABAD	\N	2025-11-26 09:06:35.285	2025-11-26 09:06:35.285	\N	2025-12-16 11:31:26.766442	\N
270	CASE1764324178635	ASR ENGINEERING & PROJECTS LIMITED	Kishan reddy (director)	Telecaller	Meeting Done	30	BANK GURANTEE	\N	\N	Documentation	\N	2025-12-01 13:27:27.740201	Prabhakar	7702004494		Srilatha	2025-12-01	15:00	9866766166	100+ cr	Madhapur	\N	2025-11-28 10:02:59.52	2025-11-28 10:02:59.52	50000000	2025-12-01 13:27:27.740201	\N
278	CASE1764396908165	Bhagyanagar Chlorides	AVS Prasad	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:21:14.191977	AVS Prasad		9440803679	\N	2025-11-01	00:00	9440803679	50-100cr		\N	2025-11-29 05:43:54.432	2025-11-29 05:43:54.432	\N	2025-11-29 13:21:14.191977	\N
267	CASE1764315650438	cpc jewellers	Ashok Chary	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-11-29 06:35:51.118425				\N	2025-11-28	13:00	9440027764	100crs	vikarabad	\N	2025-11-28 07:40:50.537	2025-11-28 07:40:50.537	\N	2025-11-29 06:35:51.118425	\N
91	CASE1762837620495	Tricolor Properties pvt.ltd	Madhav -CFO	Telecaller	No Requirement	31	Small LAP upto 7CR	\N	\N	\N	\N	2025-12-16 11:39:11.438763				Mounika	2025-09-29	15:00	9618055705	50-100cr	https://maps.app.goo.gl/inxcnG734PMZZRnv7	\N	2025-11-11 05:06:53.924	2025-11-11 05:06:53.924	1	2025-12-16 11:39:11.438763	\N
262	CASE1764237341283	IGNITE INTERNATIONAL	VENKATA SUBRAMANYAAM	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-01 12:26:43.713031				SRILATHA	2025-12-01	11:00	8978177765		HYDERABAD	\N	2025-11-27 09:55:42.068	2025-11-27 09:55:42.068	\N	2025-12-01 12:26:43.713031	\N
268	CASE1764320467400	SR. SHANKARAN HR SERVICES PVT LTD	RAJESH	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2025-11-29 05:01:19.896556				MOUNIKA	2025-12-01	02:00	9666600062	25-50cr	HYD	\N	2025-11-28 09:01:08.38	2025-11-28 09:01:08.38	\N	2025-11-28 09:01:08.42162	\N
271	CASE1764324293934	hyderabad institute of neuro sciences private limited	Karthik (CFO)	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-01 13:27:01.501575				Prema	2025-12-01	12:00	9491887798	100+ cr	https://maps.app.goo.gl/K9AFTTFsYxbCF9e67	\N	2025-11-28 10:04:54.822	2025-11-28 10:04:54.822	\N	2025-12-01 13:27:01.501575	\N
265	CASE1764313285505	RICHIE INTERIORS	ANAND	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-02 09:14:19.330376				SRILATHA	2025-12-01	02:00	9866640510	25-50cr	SOMAJIGUDA	\N	2025-11-28 07:01:26.142	2025-11-28 07:01:26.142	\N	2025-12-02 09:14:19.330376	\N
254	CASE1764139259788	Vadilal Industries Limited	Amit Saxena CFO	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-11-29 06:16:08.76239				Prema	2025-11-27	11:00	9824033989	50-100cr	Ahmedabad	\N	2025-11-26 06:41:00.742	2025-11-26 06:41:00.742	\N	2025-11-27 11:02:48.292218	\N
276	CASE1764393797557	Greenearth Shelters pvt ltd	Sriram	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-11-29 05:23:18.648308				\N	2025-11-29	12:30	9885713435	100+ cr	hyderabad	\N	2025-11-29 05:23:18.618	2025-11-29 05:23:18.618	\N	2025-11-29 05:23:18.648308	\N
263	CASE1764244386142	Preeti Enterprises	Ashok Kumar Jhawar Director	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-11-29 06:11:49.910311				Monika	2025-11-28	12:00	9848029317	50-100cr	Nizamabad	\N	2025-11-27 11:53:07.11	2025-11-27 11:53:07.11	\N	2025-11-28 11:36:57.555955	\N
81	CASE1762837124187	M/S GEETHA AUTO COMMERCIALS	Arun kumar (Director)	Telecaller	Meeting Done	30	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 06:33:26.36201				Google	2025-10-08	15:00	 9849177444	25-50cr	Warangal	\N	2025-11-11 04:58:43.79	2025-11-11 04:58:43.79	220000000	2025-11-28 05:04:23.756501	\N
264	CASE1764305260862	Joulepoint Private Limited	Divakar (Director)	Telecaller	Documentation Initiated	30	BL	\N	\N	Documentation	\N	2025-12-08 12:30:05.243062				Nitheesh sir	2025-11-28	12:00	9676662926	25-50cr	https://maps.app.goo.gl/c1JnfPXuHwmc2YV87	\N	2025-11-28 04:47:40.304	2025-11-28 04:47:40.304	30000000	2025-12-08 12:30:05.243062	\N
142	CASE1762840077926	NEVA IMPEX PRIVATE LIMITED	Vijaya krishna	Telecaller	No Requirement	30	WC	\N	\N	\N	\N	2025-12-15 14:26:50.405822			9966852888   	Prema	2025-09-10	15:00	8008947424	25-50cr	https://maps.app.goo.gl/vRBVF9J8Yh3ekH3S9	\N	2025-11-11 05:47:57.607	2025-11-11 05:47:57.607	1	2025-12-15 14:26:50.405822	\N
269	CASE1764322859980	MIC ELECTRONICS LTD	Rakshit Mathur	Telecaller	Meeting Done	31	OD	\N	\N	Documentation	\N	2025-11-29 13:16:52.400036	MURALI KRISHNA - CFO			MOUNIKA	2025-11-28	12:30	9769339779	25-50cr	https://maps.app.goo.gl/o7JYwSHk3ca7azXk7	\N	2025-11-28 09:40:58.047	2025-11-28 09:40:58.047	750000000	2025-11-29 04:58:20.854805	\N
277	CASE1764394837734	GOGULA CONSTRUCTIONS PVT LTD	Ganapathi reddy	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-11-29 12:07:21.593729				Google	2025-11-27	14:00	8885087623	50-100cr	Kukatpally	\N	2025-11-29 05:40:36.41	2025-11-29 05:40:36.41	\N	2025-11-29 12:07:21.593729	\N
272	CASE1764328583558	Eggway International Asia Private Limited	Srinivas Mamidi CFO	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-01 12:26:28.914988				Prema	2025-12-01	14:00	9959849977	100+ cr	Hyderabad	\N	2025-11-28 11:16:24.515	2025-11-28 11:16:24.515	\N	2025-12-01 12:26:28.914988	\N
261	CASE1764237339048	SRI VENKATESHWARA BUILDERS AND CONSTRUCTIONS372IONS	SHANKAR	Telecaller	Meeting Done	33	Secured LAP	\N	\N	Documentation	\N	2025-11-29 07:01:10.590927	SHANKAR			SRILATHA	2025-11-28	11:00	9849372949	5-25cr	VIZAG	\N	2025-11-27 09:55:40.654	2025-11-27 09:55:40.654	900000000	2025-11-28 12:58:44.43428	\N
52	CASE1762834354822	Aakruthi constructions and developers pvt.ltd	Bhaskar rao - MD	Telecaller	Sanctioned	31	small LAP - upto 7cr	\N	\N	Underwriting	\N	2025-12-29 10:04:40.812158	Yuktha			Mounika	2025-08-21	12:30	9856094512	50-100cr	Hyderabad	\N	2025-11-11 04:12:28.302	2025-11-11 04:12:28.302	200000000	2025-12-29 10:04:40.812158	\N
281	CASE1764397510346	Ayappa Infra private limited	Panuranga raju Kothapally MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:21:15.7427	Panuranga raju Kothapally MD			\N	2025-11-06	01:00	7680988999	50-100cr		\N	2025-11-29 05:53:56.682	2025-11-29 05:53:56.682	\N	2025-11-29 13:21:15.7427	\N
279	CASE1764397172528	KMC constructions	Ramaswamy Reddy CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:21:20.27573	Ramaswamy reddy CFO		9000928886	\N	2025-11-01	01:00	9000928886	100+ cr		\N	2025-11-29 05:48:18.816	2025-11-29 05:48:18.816	\N	2025-11-29 13:21:20.27573	\N
280	CASE1764397290284	Sri sai ram enterprises	Balmuri Anurag MDs Son	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:21:21.993886	Balmuri anurag		9000477115	\N	2025-11-07	01:30	9000477115	100+ cr		\N	2025-11-29 05:50:16.545	2025-11-29 05:50:16.545	\N	2025-11-29 13:21:21.993886	\N
188	CASE1762856134388	 DPR Infra Projects Private Limited	Sai charan (operations head)	Telecaller	No Requirement	30	Small LAP - upto 5CR	\N	\N	\N	\N	2025-12-15 14:25:39.030219				Google	2025-11-12	10:30	9964335991	5-25cr	https://maps.app.goo.gl/1D7MTk59SiMMbvx48	\N	2025-11-11 10:15:33.715	2025-11-11 10:15:33.715	1	2025-12-15 14:25:39.030219	\N
266	CASE1764315646071	cpc jewellers	Ashok Chary	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:39:37.22443				\N	2025-11-28	13:00	9440027764	100crs	vikarabad	\N	2025-11-28 07:40:46.98	2025-11-28 07:40:46.98	\N	2025-12-15 12:39:37.22443	\N
274	CASE1764393663992	Prashanth Polutry Farms	Prashanth	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-15 12:22:10.486069				\N	2025-11-29	12:00	9705302438	100+ cr	hyderabad	\N	2025-11-29 05:21:05.073	2025-11-29 05:21:05.073	750000000	2025-12-15 12:22:10.486069	\N
275	CASE1764393725908	Abhyudaya Farms Pvt ltd	Shashidhar	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:47:19.530884				\N	2025-11-29	13:00	9948094902	100+ cr	hyderabad	\N	2025-11-29 05:22:07.025	2025-11-29 05:22:07.025	\N	2025-12-15 12:47:19.530884	\N
2	CASE1761910111749	teena labs limited	Venkat subbarao (CFO)	Telecaller	One Pager	30	WC	\N	\N	One Pager	\N	2025-12-15 13:23:29.573				prema	2025-10-31	15:00	9502557733	50-100cr	https://maps.app.goo.gl/cY1ehiRLTr8hKraM8	\N	2025-10-31 11:28:32.692	2025-10-31 11:28:32.692	30000000	2025-11-28 06:55:56.089796	\N
126	CASE1762839184224	PENNAR INDUSTRIES LTD	SHANKAR KUMAR	Telecaller	No Requirement	33	BL	\N	\N	\N	\N	2025-12-15 14:28:18.777322				SRILATHA	2025-10-15	11:00	8008032102	100+ cr	HYDERABAD	\N	2025-11-11 05:33:05.176	2025-11-11 05:33:05.176	1	2025-12-15 14:28:18.777322	\N
105	CASE1762838265880	Sri Venkateswara Developers	Venkat reddy	Telecaller	No Requirement	30	small LAP - upto 7cr	\N	\N	\N	\N	2025-12-16 11:37:50.478567				prema	2025-09-19	16:00	9848571725	50-100cr	https://maps.app.goo.gl/jfyedbHK3baHAGdg8	\N	2025-11-11 05:17:45.514	2025-11-11 05:17:45.514	1	2025-12-16 11:37:50.478567	\N
273	CASE1764328696142	Cisb Services Private Limited	Ankit M  CFO	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-11-29 06:08:12.736763				Srilatha	2025-12-01	13:30	9372169394	100+ cr	Hyderabad	\N	2025-11-28 11:18:17.084	2025-11-28 11:18:17.084	\N	2025-11-28 11:18:17.116695	\N
294	CASE1764397707340	shri shyambaba electronic pvt ltd	Rahul	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-11-29 06:28:28.185461				\N	2025-11-29	12:00	9030090030	100+ cr		\N	2025-11-29 06:28:28.154	2025-11-29 06:28:28.154	\N	2025-11-29 06:28:28.185461	\N
296	CASE1764397837815	Sri Venkatesha Packaging Industry	Vasanth Kumar	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-11-29 06:30:38.64067				\N	2025-11-29	12:00	9866666565	100+ cr	hyderabad	\N	2025-11-29 06:30:38.611	2025-11-29 06:30:38.611	\N	2025-11-29 06:30:38.64067	\N
25	CASE1762257883874	Gathi Analytics Private Limited	Pavan Agarwal 	Telecaller	No Requirement	32	BL	\N	\N	\N	\N	2025-11-29 06:36:37.495294				Srilatha	2025-11-05	11:30	9866164707	50-100cr	https://www.google.com/maps/place/17%C2%B025'32.4%22N+78%C2%B027'13.2%22E/@17.4256744,78.4510994,17z/data=!3m1!4b1!4m4!3m3!8m2!3d17.4256744!4d78.4536743?hl=en&entry=ttu&g_ep=EgoyMDI1MTAyOS4yIKXMDSoASAFQAw%3D%3D	\N	2025-11-04 12:04:44.58	2025-11-04 12:04:44.58	0	2025-11-29 06:36:37.495294	\N
11	CASE1762145457677	Hiranandani Realtors Private Limited	Abhishikth Sattaluri	Telecaller	No Requirement	32	small LAP - upto 7cr	\N	\N	\N	\N	2025-11-29 06:37:18.417652				Prema	2025-11-03	12:30	8185951358	25-50cr	https://www.google.com/maps/place/17%C2%B025'54.2%22N+78%C2%B022'58.1%22E/@17.431715,78.38023,17z/data=!3m1!4b1!4m4!3m3!8m2!3d17.431715!4d78.3828049?hl=en&entry=ttu&g_ep=EgoyMDI1MTAyOS4yIKXMDSoASAFQAw%3D%3D	\N	2025-11-03 04:50:57.245	2025-11-03 04:50:57.245	0	2025-11-29 06:37:18.417652	\N
289	CASE1764399261969	venve light metals private limioted	Nani Babu	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:16:24.686052				\N	2025-11-29	01:30	9848051893	25-50cr		\N	2025-11-29 06:23:08.197	2025-11-29 06:23:08.197	\N	2025-11-29 13:16:24.686052	\N
303	CASE1764398094112	Sbl Technologies	Srinivasa Rao	Telecaller	Meeting Done	29	OD	\N	\N	Documentation	\N	2025-11-29 12:06:56.401377				\N	2025-11-29	12:00	7032900329	25-50cr	hyderabad	\N	2025-11-29 06:34:54.933	2025-11-29 06:34:54.933	20000000	2025-11-29 12:06:56.401377	\N
282	CASE1764397813628	Suryalatha spinning mills	Nageshwra rao MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:04.309731			9440683832	\N	2025-11-01	02:00	9440683832			\N	2025-11-29 05:58:59.969	2025-11-29 05:58:59.969	\N	2025-11-29 13:22:04.309731	\N
283	CASE1764397890381	Lokesh Machines	Sudhakar CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:11.617441			9866647845	\N	2025-11-12	01:00	9866647845			\N	2025-11-29 06:00:16.625	2025-11-29 06:00:16.625	\N	2025-11-29 13:22:11.617441	\N
287	CASE1764398494363	Alcom Extrusions Private Limited	Sri Ram Dasari	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:17.080671	Sri ram dasari		9989955586	\N	2025-11-14	01:00	9989955586	50-100cr		\N	2025-11-29 06:10:20.579	2025-11-29 06:10:20.579	\N	2025-11-29 13:22:17.080671	\N
288	CASE1764398574617	Sudhakar Infra	Nageshwara rao CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:35.608286	Nageshwara rao CFO			\N	2025-11-19	03:00	9290096045	50-100cr		\N	2025-11-29 06:11:40.83	2025-11-29 06:11:40.83	\N	2025-11-29 13:22:35.608286	\N
285	CASE1764398180082	Arete Hospitals	Prabhakar raju	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:37.130776	Sreenivasu Gundamoni 		9866185204	\N	2025-11-07	05:30	9966090099	100+ cr		\N	2025-11-29 06:05:06.295	2025-11-29 06:05:06.295	\N	2025-11-29 13:22:37.130776	\N
290	CASE1764399356040	Shyam Textiles	Pankaj khaitan	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:43.698951				\N	2025-11-14	01:30	9743175140	50-100cr		\N	2025-11-29 06:24:42.201	2025-11-29 06:24:42.201	\N	2025-11-29 13:22:43.698951	\N
286	CASE1764398305303	Shrushti contech	Srinivas reddy	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:45.662774	Srinivas reddy			\N	2025-11-13	02:00	7702411599	100+ cr		\N	2025-11-29 06:07:11.529	2025-11-29 06:07:11.529	\N	2025-11-29 13:22:45.662774	\N
293	CASE1764399553000	Bekem Infra Projects Private Limited	Maheshwari bekem	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:48.316261				\N	2025-11-12	03:30	9959455536	50-100cr		\N	2025-11-29 06:27:59.183	2025-11-29 06:27:59.183	\N	2025-11-29 13:22:48.316261	\N
298	CASE1764399772011	RVM Construction India pvt ltd	Suresh babu	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:53.964504				\N	2025-11-18	03:00	9652911602	50-100cr		\N	2025-11-29 06:31:37.602	2025-11-29 06:31:37.602	\N	2025-11-29 13:22:53.964504	\N
295	CASE1764399640887	Tannish Laboratories Private Limited	Somaiha	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:23:07.461425				\N	2025-11-14	00:30	7032033566	50-100cr		\N	2025-11-29 06:29:27.026	2025-11-29 06:29:27.026	\N	2025-11-29 13:23:07.461425	\N
297	CASE1764399719391	Suvarna durga bottles private limited	Jyothi prasad	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:23:08.898796				\N	2025-11-26	03:00	9849887687	100+ cr		\N	2025-11-29 06:30:45.584	2025-11-29 06:30:45.584	\N	2025-11-29 13:23:08.898796	\N
307	CASE1764400345406	AIMS Bangalore	Manohar Shah	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:23:19.033669				\N	2025-11-06	01:00	9972018055			\N	2025-11-29 06:41:11.542	2025-11-29 06:41:11.542	\N	2025-11-29 13:23:19.033669	\N
310	CASE1764400479563	RMN infrastructure	Harsha	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:25:25.880896				\N	2025-11-14	01:00	9989495557			\N	2025-11-29 06:43:25.687	2025-11-29 06:43:25.687	\N	2025-11-29 13:25:25.880896	\N
305	CASE1764400133429	C5 ENGINEERING	Nishant MD	Telecaller	Meeting Done	1	BANK GURANTEE	\N	\N	Documentation	\N	2025-11-29 13:24:11.144404				\N	2025-11-06	01:30	9989555555	100+ cr		\N	2025-11-29 06:37:39.564	2025-11-29 06:37:39.564	50000000	2025-11-29 13:24:11.144404	\N
301	CASE1764399864948	Hugel trading center	Anand Mohan	Telecaller	Meeting Done	1	BANK GURANTEE	\N	\N	Documentation	\N	2025-11-29 13:25:14.543474				\N	2025-11-04	01:30	7715077576	50-100cr		\N	2025-11-29 06:33:11.108	2025-11-29 06:33:11.108	50000000	2025-11-29 13:25:14.543474	\N
309	CASE1764398580483	coverit flair	coverit flair	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:32:31.898294				\N	2025-11-29	11:00	9989431666	5-25cr	hyderabad	\N	2025-11-29 06:43:01.217	2025-11-29 06:43:01.217	\N	2025-12-15 12:32:31.898294	\N
300	CASE1764397958287	Brs Refineries Private Limited	Ashok	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:21:38.908854				\N	2025-11-29	12:00	9885415000	400crs	hyderabad	\N	2025-11-29 06:32:39.136	2025-11-29 06:32:39.136	50000000	2025-12-15 12:21:38.908854	\N
306	CASE1764398447312	ssr crest engineers & constructions ltd	naveen reddy 	Telecaller	Meeting Done	29	PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)	\N	\N	Documentation	\N	2025-12-15 12:30:58.322695				\N	2025-11-29	12:00	9000444897	50-100cr	hyderabad	\N	2025-11-29 06:40:48.093	2025-11-29 06:40:48.093	50000000	2025-12-15 12:30:58.322695	\N
292	CASE1764397582102	mythri Drugs	Mythri drugs	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 13:17:20.933546				\N	2025-11-29	13:00	9000885685	200crs	hyderabad	\N	2025-11-29 06:26:22.921	2025-11-29 06:26:22.921	\N	2025-12-15 13:17:20.933546	\N
291	CASE1764397511816	sri laxmi Narsimha Polutry farms pvt ltd	govind	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:47:03.655063				\N	2025-11-29	12:30	9866992323	100+ cr		\N	2025-11-29 06:25:12.605	2025-11-29 06:25:12.605	500000000	2025-12-15 12:47:03.655063	\N
102	CASE1762838202548	Analinear imaging systems pvt.ltd	Tarun -MD	Telecaller	No Requirement	31	BL	\N	\N	\N	\N	2025-12-16 11:37:58.217105				Prema	2025-10-31	12:30	9959955506	50-100cr	https://maps.app.goo.gl/mRJe5y1PgtuWdffN9	\N	2025-11-11 05:16:36.006	2025-11-11 05:16:36.006	1	2025-12-16 11:37:58.217105	\N
299	CASE1764397899384	Swapna Ginning And Pressing Factory	Vishwanand	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:32:12.102789				\N	2025-11-29	13:00	9440060733	100+ cr	hyderabad	\N	2025-11-29 06:31:40.156	2025-11-29 06:31:40.156	\N	2025-12-18 10:32:12.102789	\N
308	CASE1764398500046	Dwarka Ispat pvt ltd	ravindar reddy	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-19 05:36:42.299117				\N	2025-11-29	13:00	9533799999	400crs	hyderabad	\N	2025-11-29 06:41:40.566	2025-11-29 06:41:40.566	\N	2025-12-19 05:36:42.299117	\N
216	CASE1763542806642	NVR TOWNSHIP PVT.LTD	VENKATA RAMAN - MD	Telecaller	Documentation Initiated	31	Small LAP - upto 5CR	\N	\N	Documentation	\N	2025-11-29 07:02:56.884191	VENKATA RAMAN - MD			MOUNIKA	2025-11-19	11:00	9966366667	1-5cr	https://maps.app.goo.gl/BqEBoJJTxP2JQfZV7	\N	2025-11-19 08:59:56.67	2025-11-19 08:59:56.67	40000000	2025-11-22 06:03:01.563293	\N
226	CASE1763702492835	MISHRA POLYPACK PVT.LTD	SHISHIR KUMAR MISHRA -MD	Telecaller	Documentation Initiated	31	BL	\N	\N	Documentation	\N	2025-11-29 07:11:08.575922	SHISHIR KUMAR MISHRA -MD		9848052515	MOUNIKA	2025-11-21	11:30	9848052515	100+ cr	https://maps.app.goo.gl/XqNJazx1YwCbBGLH9	\N	2025-11-21 05:21:21.69	2025-11-21 05:21:21.69	60000000	2025-11-22 05:57:33.238922	\N
340	CASE1764402574087	Civet 	Siva reddy civet	Telecaller	Login	1	WC	\N	\N	Documentation	\N	2025-12-29 09:59:46.692437					2025-11-04	02:00	7093642361	50-100cr		\N	2025-11-29 07:18:20.103	2025-11-29 07:18:20.103	250000000	2025-12-29 09:59:46.692437	\N
316	CASE1764398843814	Engineers Associates Private Limited	Nagendra Prasad	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:21:02.116021				\N	2025-11-29	13:00	8008703636	50-100cr	hyderabad	\N	2025-11-29 06:47:24.591	2025-11-29 06:47:24.591	\N	2025-12-15 12:21:02.116021	\N
312	CASE1764400527166	Mango media	Ananda babu	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:23:16.429722				\N	2025-11-08	01:30	9391025518	50-100cr		\N	2025-11-29 06:44:13.262	2025-11-29 06:44:13.262	\N	2025-11-29 13:23:16.429722	\N
318	CASE1764400823481	RKN Projects	Ramesh Kumar nallapaneni	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:23:21.699794	Ramesh Son		9440278345	\N	2025-11-14	03:30	9440275536	100+ cr		\N	2025-11-29 06:49:09.65	2025-11-29 06:49:09.65	\N	2025-11-29 13:23:21.699794	\N
319	CASE1764400877417	SRRR INRA&SRR Projects	Jawahar CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:25:20.061773				\N	2025-11-13	01:30	9246225504			\N	2025-11-29 06:50:03.246	2025-11-29 06:50:03.246	\N	2025-11-29 13:25:20.061773	\N
315	CASE1764400673424	Dwarka Holdings	Gopal CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:25:29.499357				\N	2025-11-11	03:30	9963457345	50-100cr		\N	2025-11-29 06:46:39.541	2025-11-29 06:46:39.541	\N	2025-11-29 13:25:29.499357	\N
328	CASE1764401292539	SCHEMATIC ENGINEERING PVT LTD	Kishore CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:52:11.544511				\N	2025-11-20	02:00	8686166714	50-100cr		\N	2025-11-29 06:56:58.343	2025-11-29 06:56:58.343	\N	2025-12-01 07:52:11.544511	\N
325	CASE1764401024408	MAchint Tech US 4M$	Pratap Director	Telecaller	Meeting Done	1	Private Credit (NCD, Secure Lending ) 50cr to 1000cr	\N	\N	Documentation	\N	2025-12-01 07:51:33.228346				\N	2025-11-13	01:30	9160065588			\N	2025-11-29 06:52:30.466	2025-11-29 06:52:30.466	50000000	2025-12-01 07:51:33.228346	\N
323	CASE1764399043290	shree ji jewellers	Madhu	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:20:22.508793				\N	2025-11-29	12:00	9948047899	180crs	hyderabad	\N	2025-11-29 06:50:57.768	2025-11-29 06:50:57.768	\N	2025-12-15 12:20:22.508793	\N
333	CASE1764401783731	Srinivasa farms and hatcheries private limited	Ramakanth tripathi	Telecaller	Done	1	WC	\N	\N	Documentation	\N	2025-12-29 10:00:18.865826				\N	2025-11-19	01:30	7993107600			\N	2025-11-29 07:05:09.777	2025-11-29 07:05:09.777	500000000	2025-12-29 10:00:18.865826	\N
339	CASE1764402510984	Singhania Printers Private Limited	Nithin Singhania	Telecaller	PD	1	WC	\N	\N	One Pager	\N	2025-12-29 09:59:56.219742				\N	2025-11-12	01:00	9849032215	50-100cr		\N	2025-11-29 07:17:16.971	2025-11-29 07:17:16.971	350000000	2025-12-29 09:59:56.219742	\N
326	CASE1764401080828	HR Square	Raju MD	Telecaller	Login	1	WC	\N	\N	Documentation	\N	2025-12-29 10:01:19.727494				\N	2025-11-17	01:00	9948022333	50-100cr		\N	2025-11-29 06:53:26.41	2025-11-29 06:53:26.41	600000000	2025-12-29 10:01:19.727494	\N
173	CASE1762842910656	Heemankshi Bakers pvt.ltd	Sravan kumar - MD	Telecaller	No Requirement	31	Small LAP upto 7cr	\N	\N	\N	\N	2025-12-15 14:24:05.614346				Mounika	2025-09-29	15:00	9848022871	25-50cr	Heemankshi Bakers Pvt. Ltd. Sy. No. 709, J.P. Darga Road Mekaguda, Kothur Mandal, Mahbubnagar, Telangana 509228  https://goo.gl/maps/kTSqPE9JBDp	\N	2025-11-11 06:35:04.197	2025-11-11 06:35:04.197	1	2025-12-15 14:24:05.614346	\N
341	CASE1764400707502	Esmario Exports enterprises pvt ltd	pavan	Telecaller	Underwriting	29	WC	\N	\N	Documentation	\N	2025-12-29 09:53:44.552172					2025-06-10	13:00	9030808767	25-50cr		\N	2025-11-29 07:18:28.394	2025-11-29 07:18:28.394	4000000	2025-12-29 09:53:44.552172	\N
332	CASE1764401671008	AGASTHYA FOODS	CFO garu	Telecaller	Documentation Initiated	1	WC	\N	\N	Documentation	\N	2025-12-01 08:04:58.693395				\N	2025-11-07	02:30	8712008652	100+ cr		\N	2025-11-29 07:03:17.054	2025-11-29 07:03:17.054	200000000	2025-12-01 08:04:58.693395	\N
330	CASE1764401456648	SHAM ROCK	Ramesh	Telecaller	One Pager	1	WC	\N	\N	Documentation	\N	2025-12-08 10:40:42.189513				\N	2025-11-07	02:30	9833352066			\N	2025-11-29 06:59:42.69	2025-11-29 06:59:42.69	800000000	2025-12-08 10:40:42.189513	\N
336	CASE1764402245387	Agarwal Industries	Amit agarwal	Telecaller	Documentation Initiated	1	WC	\N	\N	Documentation	\N	2025-12-01 08:04:50.417592				\N	2025-11-13	01:30	9849015651	25-50cr		\N	2025-11-29 07:12:51.49	2025-11-29 07:12:51.49	300000000	2025-12-01 08:04:50.417592	\N
327	CASE1764401244052	Laurven Flexopack	Nitish reddy	Telecaller	One Pager	1	UNSECURED & SECURED OD	\N	\N	One Pager	\N	2025-12-15 13:28:16.388				\N	2025-11-11	01:30	9885094071	50-100cr		\N	2025-11-29 06:56:10.098	2025-11-29 06:56:10.098	500000000	2025-12-08 10:40:58.349072	\N
320	CASE1764399019505	shree ji jewellers	Madhu	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:20:42.588357				\N	2025-11-29	12:00	9948047899	180crs	hyderabad	\N	2025-11-29 06:50:20.242	2025-11-29 06:50:20.242	\N	2025-12-15 12:20:42.588357	\N
321	CASE1764399054691	shree ji jewellers	Madhu	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:20:37.232479				\N	2025-11-29	12:00	9948047899	180crs	hyderabad	\N	2025-11-29 06:50:55.372	2025-11-29 06:50:55.372	\N	2025-12-15 12:20:37.232479	\N
317	CASE1764398908649	Vajram Constructions Private Limited	Balakrishna Kandula	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:20:52.020453					2025-11-19	12:00	8179007074		hyderabad	\N	2025-11-29 06:48:29.366	2025-11-29 06:48:29.366	\N	2025-12-15 12:20:52.020453	\N
313	CASE1764398702239	vn marine food 	anam ashok	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:21:12.267779				\N	2025-11-29	13:00	9381215563	25-50cr		\N	2025-11-29 06:45:02.98	2025-11-29 06:45:02.98	\N	2025-12-15 12:21:12.267779	\N
338	CASE1764400621134	Rank sillicon Industries pvt ltd	Koteshwar Rao	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:29:34.246893				\N	2025-11-29	12:00	8008572877	50-100cr	hyderabad	\N	2025-11-29 07:17:04.113	2025-11-29 07:17:04.113	\N	2025-12-15 12:29:34.246893	\N
337	CASE1764400464450	Rockeria engineering pvt ltd	bhaskar rao	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:29:44.993207				\N	2025-11-29	13:00	9100027667	25-50cr		\N	2025-11-29 07:14:25.392	2025-11-29 07:14:25.392	\N	2025-12-15 12:29:44.993207	\N
329	CASE1764399554188	sew infastructure	anantha narayana	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:29:51.837451				\N	2025-12-01	12:00	9000003211		begumpet hyderabad	\N	2025-11-29 06:59:15.165	2025-11-29 06:59:15.165	\N	2025-12-15 12:29:51.837451	\N
322	CASE1764399031890	shree ji jewellers	Madhu	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:30:01.864029				\N	2025-11-29	12:00	9948047899	180crs	hyderabad	\N	2025-11-29 06:50:56.756	2025-11-29 06:50:56.756	\N	2025-12-15 12:30:01.864029	\N
311	CASE1764398641321	clr facilities	shailesh manohar	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:30:11.008657				\N	2025-11-29	13:00	9763382441	525crs	hyderabad	\N	2025-11-29 06:44:02.155	2025-11-29 06:44:02.155	\N	2025-12-15 12:30:11.008657	\N
335	CASE1764402003625	Hemanthvardhan Enterprises	Jayraj	Telecaller	PD	1	WC	\N	\N	One Pager	\N	2025-12-29 10:00:08.658277				\N	2025-11-13	03:00	9533611113			\N	2025-11-29 07:08:49.735	2025-11-29 07:08:49.735	300000000	2025-12-29 10:00:08.658277	\N
334	CASE1764401841000	KEYSTONE Infra	Shiva 	Telecaller	PD	1	WC	\N	\N	Documentation	\N	2025-12-29 09:53:06.261661				\N	2025-11-20	01:30	9493920999	100+ cr		\N	2025-11-29 07:06:06.84	2025-11-29 07:06:06.84	12000000000	2025-12-29 09:53:06.261661	\N
354	CASE1764403325160	Elegant impex pvt ltd	Sanjay rao 	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:57:21.34478				\N	2025-11-13	03:00	9100979100			\N	2025-11-29 07:30:51.126	2025-11-29 07:30:51.126	\N	2025-12-01 07:57:21.34478	\N
371	CASE1764402044696	Bhagyanagar Chlorides	xyz	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:29:21.325318				\N	2025-11-29	12:30	9440803674	100+ cr		\N	2025-11-29 07:40:45.645	2025-11-29 07:40:45.645	\N	2025-12-15 12:29:21.325318	\N
358	CASE1764401619661	KV jewellers	Nitin agrawal	Telecaller	Login	29	WC	\N	\N	Documentation	\N	2025-12-29 09:45:30.584126				\N	2025-11-29	12:00	8106592222	350crs	hyderabad	\N	2025-11-29 07:33:40.302	2025-11-29 07:33:40.302	300000000	2025-12-29 09:45:30.584126	\N
343	CASE1764402752496	VAR Conventions	Rmachndra reddy	Telecaller	Meeting Done	1	WC	\N	\N	Documentation	\N	2025-12-01 07:56:14.181528				\N	2025-11-17	01:30	9440081182			\N	2025-11-29 07:21:18.495	2025-11-29 07:21:18.495	100000000	2025-12-01 07:56:14.181528	\N
357	CASE1764403476101	Apollo computing laboratories private limited	Jaipal reddy	Telecaller	Documentation Initiated	1	LAP	\N	\N	Documentation	\N	2025-12-01 08:04:15.343803				\N	2025-11-20	01:30	9848091553	100+ cr		\N	2025-11-29 07:33:22.147	2025-11-29 07:33:22.147	150000000	2025-12-01 08:04:15.343803	\N
355	CASE1764403404546	Glozo India pvt ltd	Sanjay rao maha 	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:57:23.581907				\N	2025-11-13	02:00	9100979100			\N	2025-11-29 07:32:10.506	2025-11-29 07:32:10.506	\N	2025-12-01 07:57:23.581907	\N
359	CASE1764403540104	Ashok kumar punjala	Ashok Kumar Punjala	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:58:20.884776				\N	2025-11-13	02:30	9000515568	1-5cr		\N	2025-11-29 07:34:26.142	2025-11-29 07:34:26.142	\N	2025-12-01 07:58:20.884776	\N
342	CASE1764402666075	Chem Veda Lifeciences	Pratyusha Director	Telecaller	Done	1	WC	\N	\N	One Pager	\N	2025-12-29 09:59:35.405589				\N	2025-11-06	01:30	7702552020			\N	2025-11-29 07:19:52.108	2025-11-29 07:19:52.108	100000000	2025-12-29 09:59:35.405589	\N
362	CASE1764403660876	Sri Harsha Concrete 	Devi Krishna CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:58:39.189042				\N	2025-11-11	02:30	9492701317			\N	2025-11-29 07:36:26.552	2025-11-29 07:36:26.552	\N	2025-12-01 07:58:39.189042	\N
351	CASE1764403113981	Akshara engineering innovations private limited	P adithya CFO	Telecaller	Documentation Initiated	1	small LAP - upto 7cr	\N	\N	Documentation	\N	2025-12-01 08:04:07.801373				\N	2025-11-19	02:30	9701346348			\N	2025-11-29 07:27:19.674	2025-11-29 07:27:19.674	40000000	2025-12-01 08:04:07.801373	\N
365	CASE1764403758015	Singu Solutions	Kishore Singu	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:59:24.923083				\N	2025-11-14	03:00	9989400300			\N	2025-11-29 07:38:03.689	2025-11-29 07:38:03.689	\N	2025-12-01 07:59:24.923083	\N
361	CASE1764403601606	Upkar Infra india private limited	Ravinder reddy MD	Telecaller	Documentation Initiated	1	LAP	\N	\N	Documentation	\N	2025-12-01 08:04:03.165897				\N	2025-11-14	02:30	9440622234	50-100cr		\N	2025-11-29 07:35:27.566	2025-11-29 07:35:27.566	150000000	2025-12-01 08:04:03.165897	\N
367	CASE1764403830668	Srinidhi Infra	Anish Pushkur MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:59:31.411436				\N	2025-11-12	01:30	9963731363	100+ cr		\N	2025-11-29 07:39:16.589	2025-11-29 07:39:16.589	\N	2025-12-01 07:59:31.411436	\N
370	CASE1764403884306	Genesis turbines	Vishal ravala MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:59:50.208331				\N	2025-11-13	01:00	9824651920	100+ cr		\N	2025-11-29 07:40:09.683	2025-11-29 07:40:09.683	\N	2025-12-01 07:59:50.208331	\N
372	CASE1764403925856	Orange travels	Sunil MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:59:54.438647				\N	2025-10-31	02:30	9666712345			\N	2025-11-29 07:40:52.11	2025-11-29 07:40:52.11	\N	2025-12-01 07:59:54.438647	\N
373	CASE1764403993876	Satya sai transporatation	SST MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:00.169339				\N	2025-11-06	01:30	9849047191	100+ cr		\N	2025-11-29 07:41:59.805	2025-11-29 07:41:59.805	\N	2025-12-01 08:00:00.169339	\N
374	CASE1764404074214	Awaze technologies/Avanthi warehouse	Babban CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:04.685086				\N	2025-11-19	01:30	9440485542	100+ cr		\N	2025-11-29 07:43:20.152	2025-11-29 07:43:20.152	\N	2025-12-01 08:00:04.685086	\N
377	CASE1764404174002	Ahalada, decomet, Innovative, sreelakshmi	Suresh Reddy	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:07.084711				\N	2025-11-18	02:00	9866616995	100+ cr		\N	2025-11-29 07:44:59.994	2025-11-29 07:44:59.994	\N	2025-12-01 08:00:07.084711	\N
347	CASE1764402879354	Flashgard technologies	Venkatrao 	Telecaller	Login	1	LAP UPTO 50CR.	\N	\N	Documentation	\N	2025-12-29 09:59:16.196229				\N	2025-12-03	01:30	9849033233	50-100cr		\N	2025-11-29 07:23:25.348	2025-11-29 07:23:25.348	3500000000	2025-12-29 09:59:16.196229	\N
376	CASE1764402288049	Sri Venkateshwara Watch & Mobiles	Prabhakar	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:06:23.667108				\N	2025-11-29	09:30	8686141516	10crs	hyderabad	\N	2025-11-29 07:44:48.926	2025-11-29 07:44:48.926	10000000	2025-12-15 12:06:23.667108	\N
353	CASE1764401308743	cyber city	srinivas	Telecaller	Login	29	LAP	\N	\N	Documentation	\N	2025-12-29 09:45:45.064105				\N	2025-11-29	13:00	9177477012	350crs	hyderabad	\N	2025-11-29 07:28:34.654	2025-11-29 07:28:34.654	1000000000	2025-12-29 09:45:45.064105	\N
360	CASE1764401687030	Hinduja Jewellers	Amit Agrawal	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:16:45.129097				\N	2025-11-29	10:00	9700001900	50crs	hyderabad	\N	2025-11-29 07:34:47.959	2025-11-29 07:34:47.959	100000000	2025-12-15 12:16:45.129097	\N
356	CASE1764401564061	sri sai leela industries	nikhil	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-15 12:17:00.138479				\N	2025-11-29	15:30	6281657621	120crs	hyderabad	\N	2025-11-29 07:32:44.963	2025-11-29 07:32:44.963	300000000	2025-12-15 12:17:00.138479	\N
349	CASE1764401143706	As Iron Industries Private Limited	sanjay agrawal	Telecaller	Done	29	LAP	\N	\N	Documentation	\N	2025-12-29 09:50:57.420147				\N	2025-11-29	12:30	9666101011	100+ cr	hyderabad	\N	2025-11-29 07:25:44.616	2025-11-29 07:25:44.616	70000000	2025-12-29 09:50:57.420147	\N
345	CASE1764400948936	katla Constructions	vidya Sagar	Telecaller	Login	29	OD	\N	\N	Documentation	\N	2025-12-29 09:52:52.351944				\N	2025-11-29	13:00	9866268007	25-50cr	hyderabad	\N	2025-11-29 07:22:29.842	2025-11-29 07:22:29.842	49000000	2025-12-29 09:52:52.351944	\N
348	CASE1764401064872	lohiya edibles oils	bala subramanyam	Telecaller	Done	29	BL	\N	\N	Documentation	\N	2025-12-29 09:51:15.159944				\N	2025-11-29	12:00	9912789891	5000crs	hyderabad	\N	2025-11-29 07:24:25.77	2025-11-29 07:24:25.77	100000000	2025-12-29 09:51:15.159944	\N
352	CASE1764401238989	Varma Steels	Varma 	Telecaller	Login	29	SECURED	\N	\N	Documentation	\N	2025-12-29 09:52:36.47594				\N	2025-11-29	12:00	9666566666	500crs		\N	2025-11-29 07:27:19.892	2025-11-29 07:27:19.892	50000000	2025-12-29 09:52:36.47594	\N
346	CASE1764400993387	upkar infra projects	ravinder reddy	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:19:29.307373				\N	2025-11-29	15:00	9440622234	100+ cr	hyderabad	\N	2025-11-29 07:23:14.016	2025-11-29 07:23:14.016	40000000	2025-12-15 12:19:29.307373	\N
363	CASE1764403718264	Pallavi constructions pvt ltd	Chandrasekhar reddy	Telecaller	Login	1	LAP	\N	\N	Documentation	\N	2025-12-29 09:58:53.51664				\N	2025-11-19	02:30	9000494123			\N	2025-11-29 07:37:24.235	2025-11-29 07:37:24.235	130000000	2025-12-29 09:58:53.51664	\N
375	CASE1764402218280	Opus Industries 	raghuram	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-15 12:25:52.240072				\N	2025-11-29	10:00	8008004477	5crs	hyderabad	\N	2025-11-29 07:43:39.202	2025-11-29 07:43:39.202	30000000	2025-12-15 12:25:52.240072	\N
366	CASE1764401953363	Variman Global pvt ltd	sirish	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:32:24.022462				\N	2025-11-29	11:00	9849726198	50-100cr		\N	2025-11-29 07:39:14.277	2025-11-29 07:39:14.277	\N	2025-12-15 12:32:24.022462	\N
364	CASE1764401868147	My seeds 	chalapathy	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:32:34.951933				\N	2025-11-29	13:00	6303901501	100crs		\N	2025-11-29 07:37:49.469	2025-11-29 07:37:49.469	\N	2025-12-15 12:32:34.951933	\N
368	CASE1764402001664	Nandi Cements	Sudhir Reddy	Telecaller	Documentation Initiated	29	LAP	\N	\N	Documentation	\N	2025-12-31 12:14:25.165292				\N	2025-11-29	10:30	9666255029	25-50cr	hyderabad	\N	2025-11-29 07:40:02.364	2025-11-29 07:40:02.364	10000000	2025-12-31 12:14:25.165292	\N
383	CASE1764404413398	JMC Constructions private limited	Director sir	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:35.961632				\N	2025-11-19	02:00	9849522555	100+ cr		\N	2025-11-29 07:48:59.106	2025-11-29 07:48:59.106	\N	2025-12-01 08:00:35.961632	\N
385	CASE1764404483701	Srico projects private limited	Machineni Srinivasa rao	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:38.624615				\N	2025-11-19	02:30	9849026294	50-100cr		\N	2025-11-29 07:50:09.321	2025-11-29 07:50:09.321	\N	2025-12-01 08:00:38.624615	\N
387	CASE1764404561455	Tera software	Gopichand tummula	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:41.426121				\N	2025-11-05	01:30	9949688883			\N	2025-11-29 07:51:27.068	2025-11-29 07:51:27.068	\N	2025-12-01 08:00:41.426121	\N
396	CASE1764405101400	Padma GAS Agencies	Prudhvi MD Son	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:45.591147				\N	2025-11-25	02:00	9959629715	100+ cr		\N	2025-11-29 08:00:27.265	2025-11-29 08:00:27.265	\N	2025-12-01 08:00:45.591147	\N
397	CASE1764405153656	Nandini Crafts	Trinadhraju shiv	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:50.776948				\N	2025-11-15	01:00	9866344666			\N	2025-11-29 08:01:19.295	2025-11-29 08:01:19.295	\N	2025-12-01 08:00:50.776948	\N
398	CASE1764405311977	Sian Infra	Vinay MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:55.734505				\N	2025-10-31	01:30	9885102250			\N	2025-11-29 08:03:57.854	2025-11-29 08:03:57.854	\N	2025-12-01 08:00:55.734505	\N
403	CASE1764405630877	AVI Additives	Ritesh Tibrewala	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:01:13.095273				\N	2025-11-05	02:30	9160170000	100+ cr		\N	2025-11-29 08:09:16.751	2025-11-29 08:09:16.751	\N	2025-12-01 08:01:13.095273	\N
401	CASE1764405423550	Ilios power private limited	Vunnam naveen 	Telecaller	Meeting Done	1	WC	\N	\N	Documentation	\N	2025-12-01 08:01:08.269395				\N	2025-10-30	01:30	9177777734			\N	2025-11-29 08:05:49.504	2025-11-29 08:05:49.504	1000000000	2025-12-01 08:01:08.269395	\N
408	CASE1764406031731	Incubate software	Incubate Kalyan	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:01:25.311798				\N	2025-11-18	02:00	9059028610	5-25cr		\N	2025-11-29 08:15:57.562	2025-11-29 08:15:57.562	\N	2025-12-01 08:01:25.311798	\N
405	CASE1764405764801	Landsky Engineers private limited	LANDSKY MD	Telecaller	Meeting Done	1	WC	\N	\N	Documentation	\N	2025-12-01 08:01:22.651664				\N	2025-11-20	02:30	9848017949			\N	2025-11-29 08:11:30.75	2025-11-29 08:11:30.75	200000000	2025-12-01 08:01:22.651664	\N
417	CASE1764420648439	Vishwasamudhara	Satish CFO Treasury	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:01:43.245423				\N	2025-11-19	07:00	9849622230	100+ cr		\N	2025-11-29 12:19:33.517	2025-11-29 12:19:33.517	\N	2025-12-01 08:01:43.245423	\N
391	CASE1764402966570	Concrete infra / VPR infra	anil kumar	Telecaller	Documentation In Progress	29	LAP	\N	\N	Documentation	\N	2025-12-04 04:47:59.93416					2025-11-29	11:00	9676223344		hyd	\N	2025-11-29 07:56:07.451	2025-11-29 07:56:07.451	300000000	2025-12-04 04:47:59.93416	\N
418	CASE1764420654423	Vishwasamudhara	Satish CFO Treasury	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:01:51.729133				\N	2025-11-19	07:00	9849622230	100+ cr		\N	2025-11-29 12:19:38.979	2025-11-29 12:19:38.979	\N	2025-12-01 08:01:51.729133	\N
410	CASE1764420111611	Sriven pharma	Surya Narayana 	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:03:28.165038				\N	2025-11-19	02:00	9502178888	100+ cr		\N	2025-11-29 12:10:36.826	2025-11-29 12:10:36.826	\N	2025-12-01 08:03:28.165038	\N
413	CASE1764418481981	BBG Group	Chandrashekhar	Telecaller	Meeting Done	29	Secured LAP	\N	\N	Documentation	\N	2025-12-03 06:01:32.44736				\N	2025-11-29	11:00	8374999955	300		\N	2025-11-29 12:14:42.909	2025-11-29 12:14:42.909	100000000	2025-12-03 06:01:32.44736	\N
386	CASE1764402607785	C5	Nishant	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:29:11.016878				\N	2025-11-29	11:30	9989555555		hyd	\N	2025-11-29 07:50:43.385	2025-11-29 07:50:43.385	\N	2025-12-15 12:29:11.016878	\N
395	CASE1764403219320	Devaki jems nd jewellers	Girish Kumar goel	Telecaller	Login	29	WC	\N	\N	Documentation	\N	2025-12-29 09:44:29.382631				\N	2025-11-29	12:00	9849100824		hyd	\N	2025-11-29 08:00:20.214	2025-11-29 08:00:20.214	450000000	2025-12-29 09:44:29.382631	\N
412	CASE1764418327230	Upkar Infra 1	Ravindar Reddy	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-11 13:17:45.15272				\N	2025-11-29	12:00	9440622234	120crs		\N	2025-11-29 12:12:08.134	2025-11-29 12:12:08.134	150000000	2025-12-11 13:17:45.15272	\N
406	CASE1764403929506	Arihant Agencies	Shreyansh	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-11 13:18:17.475918				\N	2025-11-29	10:00	9246157811		hyd	\N	2025-11-29 08:12:10.436	2025-11-29 08:12:10.436	50000000	2025-12-11 13:18:17.475918	\N
404	CASE1764403803238	Pv Ramaniah	sridhar naidu	Telecaller	Meeting Done	29	BL	\N	\N	Documentation	\N	2025-12-11 13:18:32.990238				\N	2025-11-29	13:00	7355459999	300	hyd	\N	2025-11-29 08:10:04.123	2025-11-29 08:10:04.123	100000000	2025-12-11 13:18:32.990238	\N
400	CASE1764403492004	Teena Labs	Anjaya	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-11 13:19:05.960299				\N	2025-11-29	09:30	9849999061	5crs	hyd	\N	2025-11-29 08:04:52.7	2025-11-29 08:04:52.7	300000000	2025-12-11 13:19:05.960299	\N
382	CASE1764402474550	Varsha Biosciences	John Peter	Telecaller	Disbursed	29	WC	\N	\N	Documentation	\N	2025-12-29 09:45:13.488642				\N	2025-11-29	11:30	8978244667	18crs	hyd	\N	2025-11-29 07:48:06.224	2025-11-29 07:48:06.224	85000000	2025-12-29 09:45:13.488642	\N
394	CASE1764403114252	Madhucon Projects ltd	Samba Shiva	Telecaller	Meeting Done	29	BL	\N	\N	Documentation	\N	2025-12-11 13:21:11.183133				\N	2025-11-29	11:30	9848018757	600crs	hyd	\N	2025-11-29 07:58:34.945	2025-11-29 07:58:34.945	1000000000	2025-12-11 13:21:11.183133	\N
390	CASE1764402887918	Sidhartha Jewellers 	Krishna Prasad	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-11 13:21:36.117249				\N	2025-11-29	13:00	9505695056	30crs	hyd	\N	2025-11-29 07:54:48.787	2025-11-29 07:54:48.787	300000000	2025-12-11 13:21:36.117249	\N
388	CASE1764402687733	Goel Drugs	ram prakash agrawal	Telecaller	Meeting Done	29	WC	\N	\N	Documentation	\N	2025-12-11 13:22:00.731922				\N	2025-11-29	14:30	9391014283	100crs	hyd	\N	2025-11-29 07:51:28.147	2025-11-29 07:51:28.147	80000000	2025-12-11 13:22:00.731922	\N
393	CASE1764403067551	Apex Infra	Aleem	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 11:59:12.411243				\N	2025-11-29	11:00	8686356628	5crs	hyd	\N	2025-11-29 07:57:48.52	2025-11-29 07:57:48.52	10000000	2025-12-15 11:59:12.411243	\N
384	CASE1764402574717	Magnum Enterprises/sv refineries	ravindar gupta	Telecaller	Meeting Done	29	CGTMSE	\N	\N	Documentation	\N	2025-12-15 12:05:41.205447				\N	2025-11-29	10:30	9393093003	5200	hyd	\N	2025-11-29 07:49:35.292	2025-11-29 07:49:35.292	50000000	2025-12-15 12:05:41.205447	\N
407	CASE1764404023674	yeshass constructions 	shantanu reddy	Telecaller	Meeting Done	29	PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)	\N	\N	Documentation	\N	2025-12-15 12:25:36.885259				\N	2025-11-29	11:00	9989836318	15crs	hyd	\N	2025-11-29 08:13:44.572	2025-11-29 08:13:44.572	150000000	2025-12-15 12:25:36.885259	\N
416	CASE1764418618914	Sm Square	Akhil	Telecaller	Meeting Done	29	Private Credit and Secure Lending (100cr to 1000cr)	\N	\N	Documentation	\N	2025-12-15 12:27:17.616857				\N	2025-11-29	10:30	9032442049	5crs		\N	2025-11-29 12:16:59.919	2025-11-29 12:16:59.919	500000000	2025-12-15 12:27:17.616857	\N
409	CASE1764404171475	Athirat Traders	ramesh	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:32:04.984899				\N	2025-11-29	10:00	9959152226	20crs		\N	2025-11-29 08:16:12.397	2025-11-29 08:16:12.397	\N	2025-12-15 12:32:04.984899	\N
389	CASE1764402789600	Vaishnavi Infracon Private Limited	xyz	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:48:44.828339				\N	2025-11-29	11:30	9000914915	100+ cr	hyd	\N	2025-11-29 07:53:10.496	2025-11-29 07:53:10.496	\N	2025-12-15 12:48:44.828339	\N
228	CASE1763704870223	SUPRIYA BUILDERS AND PROMOTERS PRIVATE LIMITED	Ranga rao (Director)	Telecaller	No Requirement	30	Secured LAP	\N	\N	Documentation	\N	2025-12-16 11:34:27.400269				Google	2025-11-24	10:30	 9849635312	50-100cr	https://maps.app.goo.gl/BFcGn2dJswwLJYuy7	\N	2025-11-21 06:01:10.169	2025-11-21 06:01:10.169	1	2025-12-16 11:34:27.400269	\N
402	CASE1764403715806	sri ram spinning mills pvt ltd/Viva Enterprises	Sushil Kumar	Telecaller	One Pager	29	WC	\N	\N	Documentation	\N	2025-12-29 09:44:08.793283				\N	2025-11-29	12:00	9848027697	100crs	hyd	\N	2025-11-29 08:08:36.708	2025-11-29 08:08:36.708	330000000	2025-12-29 09:44:08.793283	\N
415	CASE1764418550347	Ramky Infrastructure Limited	DL RAO	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-11-29 12:19:47.744875				MOUNIKA	2025-11-05	13:00	9849996484	100+ cr	HYD	\N	2025-11-29 12:15:51.314	2025-11-29 12:15:51.314	\N	2025-11-29 12:19:47.744875	\N
428	CASE1764419171180	MAHALAKSHMI JEWELLERS	PRASAD	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-01 04:59:49.302319				MOUNIKA	2025-11-29	11:30	9247195533	100+ cr	HYDERAAD	\N	2025-11-29 12:26:11.947	2025-11-29 12:26:11.947	50000000	2025-12-01 04:59:49.302319	\N
420	CASE1764418874859	ANIL RE-ROLLING MILLS	SANJEEV MISHRA	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-01 12:31:55.905037				MOUNIKA	2025-11-29	11:30	9849003619	100+ cr	HYDERABAD	\N	2025-11-29 12:21:15.635	2025-11-29 12:21:15.635	100000000	2025-12-01 12:31:55.905037	\N
447	CASE1764420182973	OM INDO AUTOMATION PVT.LTD	VENAKT KARTHIK	Telecaller	Documentation Initiated	30	LAP	\N	\N	Documentation	\N	2025-12-31 12:12:29.754652				\N	2025-11-29	11:00	9393938383	25-50cr	HYDERABAD	\N	2025-11-29 12:43:03.659	2025-11-29 12:43:03.659	50000000	2025-12-31 12:12:29.754652	\N
425	CASE1764418982578	Vishnu & Sons	KUSH GUPTA	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-01 12:31:18.538383				MOUNIKA	2025-11-07	13:30	9700325021	100+ cr	HYDERABAD	\N	2025-11-29 12:23:03.537	2025-11-29 12:23:03.537	150000000	2025-12-01 12:31:18.538383	\N
435	CASE1764419444510	SMR BUILDERS	GOVINDA REDDY	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-01 13:28:49.35405				MOUNIKA	2025-11-29	12:30	9951463329	100+ cr	HYDERABAD	\N	2025-11-29 12:30:45.199	2025-11-29 12:30:45.199	\N	2025-12-01 13:28:49.35405	\N
421	CASE1764418917559	Value Health Technologies Private Limited	Samba shiva rao	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-05 06:15:02.033527				MOUNIKA	2025-11-13	12:00	8885513366	100+ cr	HYDERABAD	\N	2025-11-29 12:21:58.511	2025-11-29 12:21:58.511	\N	2025-12-01 13:31:24.566051	\N
446	CASE1764420087778	TEAMTECH SOLUTIONS PVT.LTD	VENKAT	Telecaller	Sanctioned	30	WC	\N	\N	Documentation	\N	2025-12-29 09:57:21.231276				\N	2025-11-29	10:30	8686031333	25-50cr	HYDERABAD	\N	2025-11-29 12:41:28.532	2025-11-29 12:41:28.532	10000000	2025-12-29 09:57:21.231276	\N
437	CASE1764419541526	NUZIVEEDU SEEDS	NIRANJAN	Telecaller	Meeting Done	30	SECURED	\N	\N	Documentation	\N	2025-12-01 04:53:43.175251				MOUNIKA	2025-11-29	11:30	8125335335	100+ cr	HYDERABAD	\N	2025-11-29 12:32:22.214	2025-11-29 12:32:22.214	350000000	2025-12-01 04:53:43.175251	\N
448	CASE1764420250070	SREE SAI AGREEGATES	MADHUSUDHAN REDDY	Telecaller	Done	30	LAP	\N	\N	Documentation	\N	2025-12-29 09:56:58.722104				\N	2025-11-29	13:00	9440623916	25-50cr	HYDERABAD	\N	2025-11-29 12:44:10.834	2025-11-29 12:44:10.834	12500000	2025-12-29 09:56:58.722104	\N
426	CASE1764420879684	Pulse Pharma 	MVS Chray	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:01:46.169708				\N	2025-11-07	00:30	9989990244			\N	2025-11-29 12:23:24.769	2025-11-29 12:23:24.769	\N	2025-12-01 08:01:46.169708	\N
429	CASE1764419234382	AN Sanitation	AMEETH	Telecaller	Documentation Initiated	30	LAP	\N	\N	Documentation	\N	2025-12-08 10:21:59.527019				MOUNIKA	2025-11-12	14:00	7306738152	100+ cr	HYD	\N	2025-11-29 12:27:15.334	2025-11-29 12:27:15.334	10000000	2025-12-08 10:21:59.527019	\N
449	CASE1764420309445	Smart ship Logistics Private Limited	MAHANAND	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-01 04:48:13.536288				\N	2025-11-28	15:00	9246192845	50-100cr	HYD	\N	2025-11-29 12:45:10.331	2025-11-29 12:45:10.331	10000000	2025-12-01 04:48:13.536288	\N
442	CASE1764419800592	HES Infra	Krishnam Raju	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:32:49.651982				\N	2025-11-29	12:00	9949624399	1000	hyd	\N	2025-11-29 12:36:41.526	2025-11-29 12:36:41.526	\N	2025-12-18 10:32:49.651982	\N
427	CASE1764419024198	SAI PAVANI CONSTRUCTIONS	VEERANJANEYA REDDY	Telecaller	Documentation Initiated	30	BANK GURANTEE	\N	\N	Documentation	\N	2025-12-31 12:12:49.325109				MOUNIKA	2025-11-29	14:00	7702756836	100+ cr	HYDERABAD	\N	2025-11-29 12:23:44.926	2025-11-29 12:23:44.926	10000000	2025-12-31 12:12:49.325109	\N
432	CASE1764421233518	RR Engineering 	Srinivas MR	Telecaller	Login	1	WC	\N	\N	Documentation	\N	2025-12-29 09:57:47.111314				\N	2025-10-29	01:30	9440156466	25-50cr		\N	2025-11-29 12:29:18.62	2025-11-29 12:29:18.62	250000000	2025-12-29 09:57:47.111314	\N
441	CASE1764419755394	SLN INFRA	OBULESH	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 04:50:51.934239				\N	2025-11-21	13:30	9100243555	100+ cr		\N	2025-11-29 12:35:56.262	2025-11-29 12:35:56.262	200000000	2025-12-01 04:50:51.934239	\N
436	CASE1764419528742	JASPER INDUSTRIES PVT LTD	msn murthy-cfo	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 04:54:09.285365				\N	2025-11-27	14:30	9492980059	100+ cr	HYD	\N	2025-11-29 12:32:09.632	2025-11-29 12:32:09.632	100000000	2025-12-01 04:54:09.285365	\N
453	CASE1764420561995	MELUHA INTERNATIONAL SCHOOL	RAMBABU	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-01 05:05:47.150339				\N	2025-11-29	16:30	7729978377	5-25cr	HYDERABAD	\N	2025-11-29 12:49:22.181	2025-11-29 12:49:22.181	5000000	2025-12-01 05:05:47.150339	\N
422	CASE1764420806880	Seutic Pharma private limited	Mr. Prasad CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:01:59.556212				\N	2025-11-05	01:30	9849742546			\N	2025-11-29 12:22:12.037	2025-11-29 12:22:12.037	\N	2025-12-01 08:01:59.556212	\N
431	CASE1764421178349	Utkarsh incorp	MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:03.920454				\N	2025-11-12	03:00	9885239200	50-100cr		\N	2025-11-29 12:28:23.145	2025-11-29 12:28:23.145	\N	2025-12-01 08:02:03.920454	\N
430	CASE1764421139481	Sarswathi seeds 	Anil MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:06.324445				\N	2025-11-08	02:00	9948335057	50-100cr		\N	2025-11-29 12:27:44.533	2025-11-29 12:27:44.533	\N	2025-12-01 08:02:06.324445	\N
434	CASE1764421302673	Shilpe electricals	Sudhakar	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:21.505889	Subhramanayam		9949120606	\N	2025-11-06	01:00	9848012819	25-50cr		\N	2025-11-29 12:30:27.733	2025-11-29 12:30:27.733	\N	2025-12-01 08:02:21.505889	\N
443	CASE1764419924041	Lohiya Edibles 1	Bala Subramanyam	Telecaller	Login	29	BL	\N	\N	Documentation	\N	2025-12-29 09:43:17.397429					2025-11-29	12:30	9912789891	5000crs	hyderabad	\N	2025-11-29 12:38:45.029	2025-11-29 12:38:45.029	500000000	2025-12-29 09:43:17.397429	\N
439	CASE1764421595004	Priyanaka refinaries	PS Reddy	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:26.55672				\N	2025-11-13	11:30	9848012819	50-100cr		\N	2025-11-29 12:35:20.069	2025-11-29 12:35:20.069	\N	2025-12-01 08:02:26.55672	\N
454	CASE1764422440696	Shradha saboori	Jagan Mohan rao	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:28.887926				\N	2025-11-05	01:30	9440409865	100+ cr		\N	2025-11-29 12:49:25.694	2025-11-29 12:49:25.694	\N	2025-12-01 08:02:28.887926	\N
451	CASE1764420450010	VIJAYA DURGA AMALA WINERIES	VIJAYA BHASKAR	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 13:28:41.946014				\N	2025-11-29	12:30	9949470978	5-25cr	HYDERABAD	\N	2025-11-29 12:47:30.73	2025-11-29 12:47:30.73	100000000	2025-12-01 13:28:41.946014	\N
452	CASE1764420512032	JAGVIS KRUTHINGA RESTURANT	NARENDERA 	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-01 12:30:56.860197				\N	2025-11-29	13:00	9000633918	5-25cr	HYDERABAD	\N	2025-11-29 12:48:32.72	2025-11-29 12:48:32.72	15000000	2025-12-01 12:30:56.860197	\N
440	CASE1764419721175	Sai Traders	Santosh kumar	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 11:23:23.558607				\N	2025-11-29	16:30	9440379670	25crs	hyderabad	\N	2025-11-29 12:35:22.102	2025-11-29 12:35:22.102	10000000	2025-12-15 11:23:23.558607	\N
423	CASE1764418937576	Amukta Developers	Srinivas	Telecaller	Meeting Done	29	Secured LAP	\N	\N	Documentation	\N	2025-12-15 11:57:37.968641				\N	2025-11-29	12:30	9009136666	5-25cr	hyd	\N	2025-11-29 12:22:18.573	2025-11-29 12:22:18.573	100000000	2025-12-15 11:57:37.968641	\N
419	CASE1764418867359	Aadithri Developers	srinivas	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 11:57:54.204685				\N	2025-11-29	19:00	9840122377	200crs+	hyd	\N	2025-11-29 12:21:08.357	2025-11-29 12:21:08.357	400000000	2025-12-15 11:57:54.204685	\N
433	CASE1764419414576	Samira Agro	obul Reddy	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 12:25:10.294948				\N	2025-11-29	11:00	9618013283	80crs	hyd	\N	2025-11-29 12:30:15.565	2025-11-29 12:30:15.565	250000000	2025-12-15 12:25:10.294948	\N
460	CASE1764420808925	GSM PUBLISHERS	PRASAD	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 12:53:29.167954				\N	2025-11-29	15:00	9848131793	5-25cr	HYDERABAD	\N	2025-11-29 12:53:29.167	2025-11-29 12:53:29.167	\N	2025-11-29 12:53:29.167954	\N
465	CASE1764420963610	WINFOCUS TECHNOLOGIES PVT.LTD	PADMINI	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 12:56:04.356108				\N	2025-11-29	14:00	8008633177	5-25cr	HYDERABAD	\N	2025-11-29 12:56:04.326	2025-11-29 12:56:04.326	\N	2025-11-29 12:56:04.356108	\N
469	CASE1764421093546	bansilal & co	Gopal	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-01 05:22:02.705071					2025-11-04	18:00	9866466644	25-50cr	hyd	\N	2025-11-29 12:58:14.409	2025-11-29 12:58:14.409	100000000	2025-12-01 05:22:02.705071	\N
472	CASE1764421200261	ACE CARBIDE TOOLS PVT LTD	Srinivas rao	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:00:01.200613				\N	2025-11-10	20:00	9849018177	5-25cr		\N	2025-11-29 13:00:01.124	2025-11-29 13:00:01.124	\N	2025-11-29 13:00:01.200613	\N
476	CASE1764421403218	SHIMAC MACHINE TOOLS	RAM	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:03:24.013744				\N	2025-11-29	12:30	9849162487	5-25cr	HYDERABAD	\N	2025-11-29 13:03:23.982	2025-11-29 13:03:23.982	\N	2025-11-29 13:03:24.013744	\N
479	CASE1764421467023	DWARAKA INDUSTRIES	KALPESH	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:04:27.76863				\N	2025-11-29	16:00	9014555666	5-25cr	HYDERABAD	\N	2025-11-29 13:04:27.767	2025-11-29 13:04:27.767	\N	2025-11-29 13:04:27.76863	\N
480	CASE1764421534594	Hermes Chemicals company pvt ltd	kunaal	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:05:35.484494				\N	2025-11-13	17:00	9182504970	5-25cr	HYD	\N	2025-11-29 13:05:35.453	2025-11-29 13:05:35.453	\N	2025-11-29 13:05:35.484494	\N
482	CASE1764421583812	SUMHITHA POLYFABRICS PVT.LTD	RADHESHYAM	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:06:24.631711				\N	2025-11-29	13:30	8978637666	25-50cr	HYDERABAD	\N	2025-11-29 13:06:24.602	2025-11-29 13:06:24.602	\N	2025-11-29 13:06:24.631711	\N
484	CASE1764421630952	Spectrum wireless Technologies Pvt ltd	JEETH	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:07:11.815882				\N	2025-11-20	18:00	8143362634	5-25cr	HYD	\N	2025-11-29 13:07:11.814	2025-11-29 13:07:11.814	\N	2025-11-29 13:07:11.815882	\N
485	CASE1764421653947	LED CHIP	RAM	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:07:34.708647				\N	2025-11-29	14:30	9886001256	5-25cr	HYDERABAD	\N	2025-11-29 13:07:34.679	2025-11-29 13:07:34.679	\N	2025-11-29 13:07:34.708647	\N
488	CASE1764421801269	ANZ chemicals Ltd	ANZ chemicals Ltd	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:10:02.181182				\N	2025-11-12	14:30	9553125392			\N	2025-11-29 13:10:02.147	2025-11-29 13:10:02.147	\N	2025-11-29 13:10:02.181182	\N
490	CASE1764421862985	Budhan Engineers Private Limited	BUDHAN	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:11:03.890338				\N	2025-11-05	17:30	9533355111	25-50cr	HYD	\N	2025-11-29 13:11:03.86	2025-11-29 13:11:03.86	\N	2025-11-29 13:11:03.890338	\N
492	CASE1764421890082	KHAN PACKAGING INDUSTRIES	CHIRANJEEVI	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-11-29 13:11:30.82718				\N	2025-11-29	13:30	9121576783	5-25cr	HYDERABAD	\N	2025-11-29 13:11:30.826	2025-11-29 13:11:30.826	\N	2025-11-29 13:11:30.82718	\N
487	CASE1764423635874	Sri Lakshmi Triveni pipes	Srinivas MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:16:52.282083				\N	2025-10-30	06:30	9652636666	25-50cr		\N	2025-11-29 13:09:20.869	2025-11-29 13:09:20.869	\N	2025-11-29 13:16:52.282083	\N
473	CASE1764423096914	Pancom marketing private limited	Teja Guduru	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:17:07.909739				\N	2025-11-16	02:00	9158001191			\N	2025-11-29 13:00:21.893	2025-11-29 13:00:21.893	\N	2025-11-29 13:17:07.909739	\N
477	CASE1764423292157	FLoral Enterprises Private Limited	Shiv Shankar	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:17:09.523646				\N	2025-11-18	01:30	9848402313			\N	2025-11-29 13:03:37.133	2025-11-29 13:03:37.133	\N	2025-11-29 13:17:09.523646	\N
461	CASE1764422706393	KAsi reddy Ramakrishna 	Kasi reddy Ramkrishna	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:43.321579				\N	2025-11-07	01:30	8712377102			\N	2025-11-29 12:53:52.028	2025-11-29 12:53:52.028	\N	2025-12-01 08:02:43.321579	\N
456	CASE1764420646573	APPOSITE LEARNING SOLUTIONS PVT.LTD	RAMESH	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 05:05:16.808844				\N	2025-11-29	16:00	8790816780	5-25cr	HYDERABAD	\N	2025-11-29 12:50:47.352	2025-11-29 12:50:47.352	10000000	2025-12-01 05:05:16.808844	\N
468	CASE1764421035350	SANITECH ENGINEERS	AMITH	Telecaller	Meeting Done	30	BANK GURANTEE	\N	\N	Documentation	\N	2025-12-01 05:23:40.496494				\N	2025-11-29	14:30	8143617851	25-50cr	HYDERABAD	\N	2025-11-29 12:57:16.145	2025-11-29 12:57:16.145	10000000	2025-12-01 05:23:40.496494	\N
463	CASE1764422765346	Ardee engineering	Rajdeep MD Son	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:47.543134				\N	2025-11-01	02:00	8978280275	50-100cr		\N	2025-11-29 12:54:50.167	2025-11-29 12:54:50.167	\N	2025-12-01 08:02:47.543134	\N
467	CASE1764422899787	CPR constructions private limited	Viswanath reddy	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:54.446658				\N	2025-11-10	01:00	9492040502			\N	2025-11-29 12:57:04.733	2025-11-29 12:57:04.733	\N	2025-12-01 08:02:54.446658	\N
471	CASE1764423026960	Everest Organics	Dr Sirisha	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:56.879076				\N	2025-11-13	02:00	9959133343			\N	2025-11-29 12:59:11.911	2025-11-29 12:59:11.911	\N	2025-12-01 08:02:56.879076	\N
478	CASE1764423337859	Om Dhar engineering private limited	Rajesh MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:02:59.442796				\N	2025-11-19	00:30	9652125588	100+ cr		\N	2025-11-29 13:04:22.529	2025-11-29 13:04:22.529	\N	2025-12-01 08:02:59.442796	\N
491	CASE1764423749647	URBAN VINTAGE	MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:03:00.827284				\N	2025-11-12	11:30	9246246666	50-100cr		\N	2025-11-29 13:11:14.59	2025-11-29 13:11:14.59	\N	2025-12-01 08:03:00.827284	\N
483	CASE1764423491534	KLR Infrastructure 	Kalem Linga reddy	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:03:22.21215				\N	2025-11-12	02:00	9949193989			\N	2025-11-29 13:06:56.557	2025-11-29 13:06:56.557	\N	2025-12-01 08:03:22.21215	\N
481	CASE1764423412880	Katragadda Organics	Ramkrishna katragadda 	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:03:24.298379				\N	2025-11-18	01:30	9849130528			\N	2025-11-29 13:05:37.831	2025-11-29 13:05:37.831	\N	2025-12-01 08:03:24.298379	\N
466	CASE1764420999210	Siya Water World	Naveen	Telecaller	No Requirement	30	LAP	\N	\N	Documentation	\N	2025-12-08 05:18:27.477209				\N	2025-11-20	11:00	9985334157	1-5cr	HYD	\N	2025-11-29 12:56:40.113	2025-11-29 12:56:40.113	10000000	2025-12-08 05:18:27.477209	\N
455	CASE1764422503150	Riyom laminates	Ethendra sainsha	Telecaller	Documentation Initiated	1	WC	\N	\N	Documentation	\N	2025-12-20 09:56:44.50646				\N	2025-11-06	01:30	9866314901			\N	2025-11-29 12:50:28.133	2025-11-29 12:50:28.133	500000000	2025-12-20 09:56:44.50646	\N
474	CASE1764421309103	NRG FOODS PVT.LTD	BALA KRISHNA	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-01 13:27:47.65288				\N	2025-11-29	10:30	7337222856	25-50cr	HYDERABAD	\N	2025-11-29 13:01:49.823	2025-11-29 13:01:49.823	\N	2025-12-01 13:27:47.65288	\N
470	CASE1764421133007	RAMCHARAN OIL INDUSTRIES	SRIHARI AGARWAL	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-01 13:32:16.503044				\N	2025-11-29	14:00	9032734686	50-100cr	HYDERABAD	\N	2025-11-29 12:58:53.735	2025-11-29 12:58:53.735	\N	2025-12-01 13:32:16.503044	\N
458	CASE1764420696817	TECHNO PROJECTS	PRASAD	Telecaller	No Requirement	30	BL	\N	\N	Documentation	\N	2025-12-08 15:02:34.164857				\N	2025-11-29	13:00	9989155665	25-50cr	HYDERABAD	\N	2025-11-29 12:51:36.979	2025-11-29 12:51:36.979	5000000	2025-12-08 15:02:34.164857	\N
459	CASE1764420766374	VALUE MART SUPERMARKET PVT.LTD	RAMESH	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-01 13:31:52.921641				\N	2025-11-29	16:30	9848090661	25-50cr		\N	2025-11-29 12:52:47.155	2025-11-29 12:52:47.155	20000000	2025-12-01 13:31:52.921641	\N
462	CASE1764420876643	FUEL CART	KRISHNA CHAITHYA	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-01 13:32:12.537819				\N	2025-11-29	13:00	9494686143	25-50cr	HYDERABAD	\N	2025-11-29 12:54:37.35	2025-11-29 12:54:37.35	30000000	2025-12-01 13:32:12.537819	\N
486	CASE1764421707811	Godavari plasto containers pvt.ltd	PRAKASH	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-04 04:39:50.281579				\N	2025-11-05	12:00	9848043508	50-100cr	HYD	\N	2025-11-29 13:08:28.652	2025-11-29 13:08:28.652	\N	2025-12-04 04:39:50.281579	\N
475	CASE1764421380531	Sri jaladhari Infrastructure Pvt ltd	Rigved	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-04 08:34:50.711373					2025-11-11	15:30	8790345333	25-50cr	hyd	\N	2025-11-29 13:03:01.45	2025-11-29 13:03:01.45	\N	2025-12-01 13:27:44.125524	\N
495	CASE1764423885171	Roadworks Engineers & Consultants Pvt Ltd	Venkat reddy	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:16:48.457865				\N	2025-11-14	02:00	9014540547			\N	2025-11-29 13:13:30.099	2025-11-29 13:13:30.099	\N	2025-11-29 13:16:48.457865	\N
284	CASE1764398022989	KLSR INFRATECH SURAJ REDDY	Suraj reddy MD	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:22:13.924894	Suraj reddy MD			\N	2025-11-13	03:00	9966969669	100+ cr		\N	2025-11-29 06:02:29.249	2025-11-29 06:02:29.249	\N	2025-11-29 13:22:13.924894	\N
314	CASE1764400588436	Gopi Krishna Infra	Laitha CFO	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-11-29 13:23:14.7592				\N	2025-11-13	03:00	8886918888	100+ cr		\N	2025-11-29 06:45:13.985	2025-11-29 06:45:13.985	\N	2025-11-29 13:23:14.7592	\N
502	CASE1764667542283	PROPCARE DEVELOPERS PVT.LTD	SATHYAMURTHY	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2025-12-02 09:25:58.186827				SRILATHA	2025-12-02	14:00	9000008175	25-50cr	https://maps.app.goo.gl/RHx1SXGBDrs8ZEQA7	\N	2025-12-02 09:25:42.734	2025-12-02 09:25:42.734	\N	2025-12-02 09:25:42.73476	\N
450	CASE1764420443807	Rohini Poultry Chicken Market	SATHWIK	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 04:47:54.388298					2025-11-04	14:00	8978532553	5-25cr	HYD	\N	2025-11-29 12:47:24.683	2025-11-29 12:47:24.683	150000000	2025-12-01 04:47:54.388298	\N
457	CASE1764420658463	Vivo Biotech Limited	Srinivasa rao	Telecaller	Meeting Done	30	Machinery funding upto 7cr	\N	\N	Documentation	\N	2025-12-01 05:06:17.927743				\N	2025-11-05	13:30	9849022028	50-100cr	HYD	\N	2025-11-29 12:50:59.314	2025-11-29 12:50:59.314	50000000	2025-12-01 05:06:17.927743	\N
438	CASE1764419655103	Sri Balagopal enterprises private limited	Venkataramana	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 05:06:35.442226				\N	2025-11-27	12:30	9298651727	50-100cr	HYD	\N	2025-11-29 12:34:15.993	2025-11-29 12:34:15.993	100000000	2025-12-01 05:06:35.442226	\N
496	CASE1764565490802	mythri drugs	mythri drugs	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-01 06:13:29.534905					2025-12-01	11:00	9000885685		hyd	\N	2025-12-01 05:04:51.796	2025-12-01 05:04:51.796	\N	2025-12-01 06:13:29.534905	\N
497	CASE1764565550201	sri venkatesha packaging industry	vasanth kumar	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 11:55:10.534732				\N	2025-12-01	11:00	9866666565		hyd	\N	2025-12-01 05:05:50.912	2025-12-01 05:05:50.912	\N	2025-12-15 11:55:10.534732	\N
494	CASE1764421936753	Sai Spruthi Fibres pvt ltd	REDDY	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-01 07:25:45.069637					2025-11-12	13:00	9494752829	1-5cr	HYD	\N	2025-11-29 13:12:17.601	2025-11-29 13:12:17.601	\N	2025-11-29 13:12:17.632218	\N
369	CASE1764403879721	Genesis turbines	Vishal ravala 	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 07:59:38.427197				\N	2025-11-13	01:00	9824651920	100+ cr		\N	2025-11-29 07:40:05.433	2025-11-29 07:40:05.433	\N	2025-12-01 07:59:38.427197	\N
380	CASE1764404297259	SVS Nookambika	Raghava varma	Telecaller	No Requirement	1	\N	\N	\N	Documentation	\N	2025-12-01 08:00:22.582499	Chndrasekhar		9177711811	\N	2025-11-12	02:00	9652229292	100+ cr		\N	2025-11-29 07:47:03.192	2025-11-29 07:47:03.192	\N	2025-12-01 08:00:22.582499	\N
381	CASE1764404355328	Sumanjali paraboiled	Mahender MD	Telecaller	Documentation Initiated	1	WC	\N	\N	Documentation	\N	2025-12-01 08:03:48.647724				\N	2025-11-06	02:30	9848059922	50-100cr		\N	2025-11-29 07:48:01.001	2025-11-29 07:48:01.001	600000000	2025-12-01 08:03:48.647724	\N
344	CASE1764402810649	Vinayaka steels 	Vineeth Kedia	Telecaller	Sanctioned	1	WC	\N	\N	Documentation	\N	2025-12-29 09:59:21.387045				\N	2025-11-06	01:00	9848666189			\N	2025-11-29 07:22:16.369	2025-11-29 07:22:16.369	700000000	2025-12-29 09:59:21.387045	\N
498	CASE1764573615748	Inthes Biotech (OPC) Private Limited	Jagadeesh	Telecaller	One Pager	30	WC	\N	\N	Documentation	\N	2025-12-08 14:59:47.362519				Mounika	2025-12-02	13:30	9985533782	5-25cr	Nacharam-dammaiguda	\N	2025-12-01 07:20:13.666	2025-12-01 07:20:13.666	30000000	2025-12-08 14:59:47.362519	\N
499	CASE1764585167172	KHASPA ENTERPRISES	VISWANATHAM	Telecaller	Meeting Done	31	LAP	\N	\N	Documentation	\N	2025-12-01 12:01:43.172555				SRILATHA	2025-12-01	16:00	9701525252	1-5cr	HYDERABAD	\N	2025-12-01 10:32:45.167	2025-12-01 10:32:45.167	20000000	2025-12-01 12:01:43.172555	\N
501	CASE1764591754069	Abt Logistics 	venky	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-01 12:22:34.744281				\N	2025-12-02	12:00	9994488500	200crs	hyderabad	\N	2025-12-01 12:22:34.714	2025-12-01 12:22:34.714	\N	2025-12-01 12:22:34.744281	\N
500	CASE1764591677538	Venkatramana Polutry Products Private Limited	Ashok	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-01 12:22:47.054274					2025-12-02	11:00	9849421150	1-5cr	hyderabad	\N	2025-12-01 12:21:18.177	2025-12-01 12:21:18.177	\N	2025-12-01 12:21:18.207211	\N
424	CASE1764418950129	VARIETY INFO SOLUTIONS	SUSHIL KUMAR	Telecaller	Meeting Done	30	LAP	\N	\N	Documentation	\N	2025-12-01 12:31:38.335504				MOUNIKA	2025-11-29	14:00	9000746444	100+ cr	HYDERABAD	\N	2025-11-29 12:22:30.854	2025-11-29 12:22:30.854	100000000	2025-12-01 12:31:38.335504	\N
464	CASE1764420902424	Yedukondalu Contractor	YEDUKONDALU	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-01 12:36:55.878637				\N	2025-11-13	12:00	9441433336	1-5cr	HYD	\N	2025-11-29 12:55:03.35	2025-11-29 12:55:03.35	5000000	2025-12-01 12:36:55.878637	\N
304	CASE1764398153114	Shri sai ram enterprises	Vishnu agrawal	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-01 13:31:30.008437				\N	2025-11-29	12:00	9849151534	25-50cr	hyderabad	\N	2025-11-29 06:35:53.627	2025-11-29 06:35:53.627	\N	2025-12-01 13:31:30.008437	\N
331	CASE1764401583687	STEEL EXCHNAGE INDIA LIMITED	MOhit CFO	Telecaller	Done	1	WC	\N	\N	Documentation	\N	2025-12-29 09:53:28.473126				\N	2025-11-18	02:00	9848311311			\N	2025-11-29 07:01:49.782	2025-11-29 07:01:49.782	1000000000	2025-12-29 09:53:28.473126	\N
506	CASE1764758563126	Jodas expoim private limited 	Sravan	Telecaller	Documentation Initiated	30	NCD,BILL DISCOUNTING ,UNSECURED ,5CR IN 1 TRANCH	\N	\N	Documentation	\N	2025-12-17 12:09:18.055862				Srilatha	2025-12-04	11:30	8008616464	100+ cr	https://maps.app.goo.gl/pew3HaCF3pf1fkU19	\N	2025-12-03 10:42:41.888	2025-12-03 10:42:41.888	1500000000	2025-12-17 12:09:18.055862	\N
505	CASE1764758383466	ikya infra projects	Rajashekar	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-03 10:39:57.899941				Mounika	2025-12-04	11:00	9989998825	5-25cr		\N	2025-12-03 10:39:42.276	2025-12-03 10:39:42.276	\N	2025-12-03 10:39:42.333699	\N
411	CASE1764420194165	TSR Nirman	Suresh reddy	Telecaller	One Pager	1	WC	\N	\N	Documentation	\N	2025-12-29 09:57:59.056632				\N	2025-11-05	01:30	9900021999	50-100cr		\N	2025-11-29 12:11:59.309	2025-11-29 12:11:59.309	10000000	2025-12-29 09:57:59.056632	\N
324	CASE1764400962688	HARSHINI EPC PVT LTD	Harshini MD	Telecaller	Sanctioned	1	Private Credit (NCD, Secure Lending ) 50cr to 1000cr	\N	\N	Documentation	\N	2025-12-29 10:01:39.305748				\N	2025-11-13	01:30	9701346129	100+ cr		\N	2025-11-29 06:51:28.773	2025-11-29 06:51:28.773	50000000	2025-12-29 10:01:39.305748	\N
503	CASE1764670358929	NJR CONSTRUCTIONS PVT.LTD	KISHORE	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-03 11:41:36.484878				MOUNIKA	2025-12-03	15:30	9848861500	25-50cr	HYDERABAD	\N	2025-12-02 10:12:39.923	2025-12-02 10:12:39.923	\N	2025-12-03 11:41:36.484878	\N
489	CASE1764421818016	POOJA POLYPAST	KAILASH	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-04 04:39:41.426547					2025-11-29	14:00	9848948880	5-25cr	HYDERABAD	\N	2025-11-29 13:10:18.744	2025-11-29 13:10:18.744	5000000	2025-12-04 04:39:41.426547	\N
504	CASE1764758265597	IRF Infratech limited	Surya prakash	Telecaller	Login	30	Bill discoutning	\N	\N	One Pager	\N	2025-12-29 10:06:35.091125				Srilatha	2025-12-03	13:30	9908579349	100+ cr	Madhapur	\N	2025-12-03 10:37:44.419	2025-12-03 10:37:44.419	100000000	2025-12-29 10:06:35.091125	\N
444	CASE1764419986719	PIONEER INTERIOR PROJECTS PVT.LTD	VASUDEV	Telecaller	Sanctioned	30	LAP	\N	\N	One Pager	\N	2025-12-29 09:57:40.692606				MOUNIKA	2025-11-29	15:00	7680007864	50-100cr	HYDERABAD	\N	2025-11-29 12:39:47.482	2025-11-29 12:39:47.482	80000000	2025-12-29 09:57:40.692606	\N
350	CASE1764403066579	Innominds software 	Prasad Innominds	Telecaller	Done	1	UNSECURED & SECURED OD	\N	\N	Documentation	\N	2025-12-29 09:59:02.577257				\N	2025-11-06	01:30	9949357770	100+ cr		\N	2025-11-29 07:26:32.642	2025-11-29 07:26:32.642	200000000	2025-12-29 09:59:02.577257	\N
517	CASE1764925645970	APOLLO CONSTRUCTION EQUIPMENTS PRIVATE LIMITED	Sathish kumar	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-05 09:07:40.329631				Sriltha	2025-12-08	12:00	9848021170	50-100cr	Minister road secunderabad	\N	2025-12-05 09:07:25.826	2025-12-05 09:07:25.826	\N	2025-12-05 09:07:25.859833	\N
509	CASE1764759080426	Intergrated Clean Room Technologies Pvt Ltd	Srinivasa Murthy	Telecaller	Meeting Done	32	Machinery funding upto 7cr	\N	\N	Documentation	\N	2025-12-03 11:40:59.546319				Prema	2025-12-03	10:00	9959999860	100+ cr	Hyderabad	\N	2025-12-03 10:51:21.128	2025-12-03 10:51:21.128	150000000	2025-12-03 11:40:59.546319	\N
519	CASE1764925775028	NVAK BIOTECH INSTUMENTS PVT LTD	Vamshi krishna	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-05 09:09:51.061746				Srilatha	2025-12-06	12:00	8179114666	5-25cr	https://maps.app.goo.gl/CQ1D2zaGrXvsAv9Y9	\N	2025-12-05 09:09:34.869	2025-12-05 09:09:34.869	\N	2025-12-05 09:09:34.870095	\N
531	CASE1765369604671	SHILPA ELECTRICAL INFRATECH INDIA LIMITED	SUDHAKAR REDDY	Telecaller	No Requirement	31	WC	\N	\N	Documentation	\N	2025-12-16 11:28:55.832772				PREMA	2025-12-11	10:30	8309933108	100+ cr	https://maps.app.goo.gl/TYwMkdJqo6US7kbz7	\N	2025-12-10 12:26:45.031	2025-12-10 12:26:45.031	40	2025-12-16 11:28:55.832772	\N
510	CASE1764759245269	Fresco Outdoor Advertising Pvt Ltd	Farhan	Telecaller	Meeting Done	32	OD	\N	\N	Documentation	\N	2025-12-03 12:07:23.203194				Irfan Sir	2025-12-03	15:30	9849004128	50-100cr	Hyderabad	\N	2025-12-03 10:54:06.067	2025-12-03 10:54:06.067	1000000	2025-12-03 12:07:23.203194	\N
527	CASE1765273717401	GLOBAL STEEL	SANJEEV KUMAR(DIRECTOR)	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-15 14:11:30.127829				\N	2025-12-10	11:30	9849003619	100+ cr	HYDERABAD	\N	2025-12-09 09:48:36.66	2025-12-09 09:48:36.66	\N	2025-12-15 14:11:30.127829	\N
515	CASE1764847094848	SRIKRISHNA POLYMERS	LALITHKUMAR..DIRECTOR	Telecaller	Meeting Done	33	WC	\N	\N	Documentation	\N	2025-12-05 11:18:29.984454				PREMA	2025-12-05	12:00	9848492019	5-25cr	JEEDIMETLA	\N	2025-12-04 11:18:14.896	2025-12-04 11:18:14.896	20000000	2025-12-05 11:18:29.984454	\N
529	CASE1765285368534	BAKERS WORLD FOOD SPECALITIES	ASHOK	Telecaller	Meeting Done	31	WC	\N	\N	Documentation	\N	2025-12-10 11:04:11.935447				MOUNIKA	2025-12-10	10:00	9391023294	5-25cr	HYDERABAD	\N	2025-12-09 13:02:49.621	2025-12-09 13:02:49.621	30000000	2025-12-10 11:04:11.935447	\N
526	CASE1765273433703	STARKS STEEL DOOR	JOHN	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-10 11:04:18.346819				\N	2025-12-09	02:00	8977736783		GACHIBOWLI	\N	2025-12-09 09:43:52.948	2025-12-09 09:43:52.948	\N	2025-12-10 11:04:18.346819	\N
511	CASE1764765294809	SREE ASTHALAKSHMI SPINNING MILLS PVT.LTD	VIKRANTH	Telecaller	Meeting Done	31	LAP	\N	\N	Documentation	\N	2025-12-04 11:19:48.252408				MOUNIKA	2025-12-04	11:30	9848031632	50-100cr	HYDERABAD	\N	2025-12-03 12:34:54.456	2025-12-03 12:34:54.456	200000000	2025-12-04 11:19:48.252408	\N
508	CASE1764758921219	Delta Technology and Management Services Pvt Ltd	Aravind	Telecaller	No Requirement	32	BL	\N	\N	Documentation	\N	2025-12-15 14:20:42.380145				Srilatha	2025-12-03	11:30	9849521400	100+ cr	Hyderabad	\N	2025-12-03 10:48:42.064	2025-12-03 10:48:42.064	50	2025-12-15 14:20:42.380145	\N
513	CASE1764765465033	SPAN HEALTHCARE PVT.LTD	RAVIKUMAR	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-04 11:20:14.743978				MOUNIKA	2025-12-04	16:00	9739157999	100+ cr	BANGLORE	\N	2025-12-03 12:37:44.717	2025-12-03 12:37:44.717	\N	2025-12-04 11:20:14.743978	\N
514	CASE1764830414143	Navay Renewable Private Limited	Koushik rao	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-08 11:54:43.386758				Srilatha	2025-12-05	12:00	8142211266	25-50cr	Moulali and Banjara hills	\N	2025-12-04 06:40:14.766	2025-12-04 06:40:14.766	5000000	2025-12-08 11:54:43.386758	\N
522	CASE1765186854031	VISHAL PERIPHERALS	VIKAS	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-08 11:06:15.518193				SRILATHA	2025-12-08	11:00	9849914650	25-50cr	HYDERABAD	\N	2025-12-08 09:40:48.297	2025-12-08 09:40:48.297	\N	2025-12-08 11:06:15.518193	\N
196	CASE1763186683929	Adhya Studioz 	Raghavendra -MD	Telecaller	One Pager	32	WC	\N	\N	\N	\N	2025-12-08 15:08:37.266712	Raghavendra -MD		9515134659	Prema	2025-11-15	15:30	9515134659	1-5cr	https://www.google.com/maps/place/17%C2%B021'51.7%22N+78%C2%B033'30.7%22E/@17.36436,78.5559415,17z/data=!3m1!4b1!4m4!3m3!8m2!3d17.36436!4d78.5585164?hl=en&entry=ttu&g_ep=EgoyMDI1MTExMi4wIKXMDSoASAFQAw%3D%3D	\N	2025-11-15 06:04:44.755	2025-11-15 06:04:44.755	40000000	2025-12-08 15:08:37.266712	\N
516	CASE1764924175994	Timber Trading Company	JITENDER	Telecaller	Meeting Done	33	OD	\N	\N	Documentation	\N	2025-12-08 11:09:01.740391				GOOGLE	2025-12-05	11:30	9866117747		HYD	\N	2025-12-05 08:42:55.51	2025-12-05 08:42:55.51	20000000	2025-12-08 11:09:01.740391	\N
521	CASE1765172269352	ALAKNANDA HYDRO POWER COMPANY LIMITED	Balakrishna	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-10 07:02:31.781413	 8886966778			Srilatha	2025-12-09	10:30	9397966778	50-100cr	https://maps.app.goo.gl/byXUydV3oWjUm1k8A	\N	2025-12-08 05:37:47.392	2025-12-08 05:37:47.392	\N	2025-12-10 07:02:31.781413	\N
525	CASE1765195385335	ARVEX INFOTECH PVT LTD	SRIKUMAR MODANI	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-09 10:52:02.696531				\N	2025-12-09	02:00	7207310936	100+ cr	CHENOY TRADE CENTRE SECBAD	\N	2025-12-08 12:03:05.81	2025-12-08 12:03:05.81	\N	2025-12-09 10:52:02.696531	\N
524	CASE1765195048440	M/S BENTEC INDIA PVT LIMITED	AMIT BHARTIA	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-09 11:01:16.518091				\N	2025-12-09	11:00	9550897365	50-100cr	SECUNDERABAD	\N	2025-12-08 11:57:28.919	2025-12-08 11:57:28.919	\N	2025-12-09 11:01:16.518091	\N
528	CASE1765285300082	SRI KRISHNA STORES	KRISHNA	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-11 09:33:06.640991				IRFAN	2025-12-09	15:00	9885537171	1-5cr	HYDERABAD	\N	2025-12-09 13:01:41.221	2025-12-09 13:01:41.221	\N	2025-12-11 09:33:06.640991	\N
518	CASE1764925774102	DRN INFRASTUCTURE PRIVATE  LTD	SHASHIKUMAR	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-11 09:33:15.150863				\N	2025-12-08	11:00	9844339206	100+ cr	KHAMMAM	\N	2025-12-05 09:09:33.621	2025-12-05 09:09:33.621	\N	2025-12-11 09:33:15.150863	\N
530	CASE1765369465418	CMS IT SERVICES PVT.LTD	PRAKASH GORE	Telecaller	Meeting Done	31	OD	\N	\N	Documentation	\N	2025-12-11 09:32:59.531029				MOUNIKA	2025-12-10	14:00	7400482228	50-100cr	BANGLORE	\N	2025-12-10 12:24:25.794	2025-12-10 12:24:25.794	150000000	2025-12-11 09:32:59.531029	\N
523	CASE1765186938057	GSM MEGA INFRASTRUCTURES PVT.LTD	RAMESH	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-11 12:59:54.854029				MOUNIKA	2025-12-08	14:00	9985149515	50-100cr	HYDERABAD	\N	2025-12-08 09:42:11.518	2025-12-08 09:42:11.518	\N	2025-12-11 12:59:54.854029	\N
534	CASE1765517825133	BHAGAWATHI MACHINE AND TOOLS	PANKUL AGARWAL	Telecaller	Login	31	WC	\N	\N	Documentation	\N	2025-12-29 09:56:33.315092				MOUNIKA	2025-12-12	14:00	9866543131	5-25cr	HYDERABAD	\N	2025-12-12 05:37:03.492	2025-12-12 05:37:03.492	2500000	2025-12-29 09:56:33.315092	\N
399	CASE1764403446118	Priti Gas Agency	srinivas reddy	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-11 13:19:28.859329				\N	2025-11-29	15:30	9848072345	25-50cr	hyd	\N	2025-11-29 08:04:06.974	2025-11-29 08:04:06.974	80000000	2025-12-11 13:19:28.859329	\N
532	CASE1765452417328	BALAJI HOISERY	DEEPAK AGARWAL	Telecaller	Documentation Initiated	33	OD	\N	\N	Documentation	\N	2025-12-17 12:10:29.54386				\N	2025-12-11	12:00	9885094394	25-50cr	BASHEERBAGH	\N	2025-12-11 11:26:57.598	2025-12-11 11:26:57.598	100000000	2025-12-17 12:10:29.54386	\N
533	CASE1765452794978	DISHA COMMUNICATIONS PVT LTD	RATNA PRAKASH	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-12 12:52:17.689705				\N	2025-12-12	11:00	9945004975	25-50cr		\N	2025-12-11 11:33:15.155	2025-12-11 11:33:15.155	\N	2025-12-12 12:52:17.689705	\N
520	CASE1764931685625	SRINIDHI DEVELOPERS	ALLURAMANA REDDY	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-15 11:55:01.989063				\N	2025-12-08	11:00	9866194887	25-50cr	HYDERABAD	\N	2025-12-05 10:48:05.157	2025-12-05 10:48:05.157	\N	2025-12-15 11:55:01.989063	\N
512	CASE1764765397812	PREMIER PEOPLE LOGISTICS PVT.LTD	BHIMEESH	Telecaller	No Requirement	31	WC	\N	\N	Documentation	\N	2025-12-15 14:19:45.604259				MOUNIKA	2025-12-04	14:30	9154137695	100+ cr	https://maps.app.goo.gl/MeUaWD73XLvPDxR9A	\N	2025-12-03 12:36:37.478	2025-12-03 12:36:37.478	1	2025-12-15 14:19:45.604259	\N
536	CASE1765541373746	GEMINI EQUIPMENT AND RENTALS PVT.LTD	SATHISH	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2025-12-12 12:09:44.022013				PREMA	2025-12-12	17:30	9920325432	25-50cr	MUMBAI	\N	2025-12-12 12:09:34.462	2025-12-12 12:09:34.462	\N	2025-12-12 12:09:34.492401	\N
557	CASE1765797390222	elite ready mix	suresh	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-16 13:06:39.472775				\N	2025-12-16	14:30	8498077666	5-25cr	hyd	\N	2025-12-15 11:16:31.343	2025-12-15 11:16:31.343	\N	2025-12-16 13:06:39.472775	\N
546	CASE1765780742990	HALLMARK INFRACON INDIA PVT.LTD	SATYAMURTHY	Telecaller	Meeting Done	31	LAP	\N	\N	Documentation	\N	2025-12-18 04:34:37.873688				PREMA	2025-12-15	16:00	9849056529	50-100cr	https://maps.app.goo.gl/NxS3VpWGfHJcwhxu8	\N	2025-12-15 06:39:00.5	2025-12-15 06:39:00.5	30	2025-12-18 04:34:37.873688	\N
545	CASE1765780648376	GVN TECHNOLOGIES PVT.LTD	VAMSHI	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2025-12-15 06:44:15.884713				PREMA	2025-12-15	14:00	9542282747	50-100cr	HYDERABAD	\N	2025-12-15 06:37:26.187	2025-12-15 06:37:26.187	\N	2025-12-15 06:37:26.217482	\N
561	CASE1765798184893	Parekh Ecom & Ware Housing	Susanta Nayak	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-18 04:34:18.79976				Monika	2025-12-15	11:30	9748818971	50-100cr	Hyderabad	\N	2025-12-15 11:29:46.161	2025-12-15 11:29:46.161	\N	2025-12-18 04:34:18.79976	\N
539	CASE1765542741046	 Sundram fasteners limited	Venkata srinivasa rao	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-12 12:35:20.207744				Srilatha	2025-12-15	13:00	 9949093773	50-100cr	https://maps.app.goo.gl/WtUPFEBHWUHPGojBA	\N	2025-12-12 12:32:21.204	2025-12-12 12:32:21.204	\N	2025-12-12 12:32:21.234635	\N
541	CASE1765543026283	 m/s mycro health car	Prakash	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-12 12:37:27.368367				Prema	2025-12-15	10:00	9989550404	50-100cr	https://maps.app.goo.gl/ErnH3KV97Ftn6rtA9	\N	2025-12-12 12:37:06.421	2025-12-12 12:37:06.421	\N	2025-12-12 12:37:06.451443	\N
537	CASE1765542471523	Rci logistics private limited	GK Vijay	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-12 12:51:01.120542				Prema	2025-12-12	14:00	9640051066	100+ cr	https://maps.app.goo.gl/oLcB5x8KAfQs1mwv9	\N	2025-12-12 12:27:51.7	2025-12-12 12:27:51.7	50000000	2025-12-12 12:51:01.120542	\N
538	CASE1765542595738	sri venkateswara constructions	Venkateshwara reddy	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-12 12:51:08.830983				Srilatha	2025-12-12	15:30	 9394719414	5-25cr		\N	2025-12-12 12:29:56.051	2025-12-12 12:29:56.051	\N	2025-12-12 12:51:08.830983	\N
544	CASE1765776076188	Optomech Engineers Pvt Ltd	Alok 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-15 14:11:22.250504				Irfan Sir	2025-12-08	12:00	8977038340	1-5cr	Hyderabad	\N	2025-12-15 05:21:17.357	2025-12-15 05:21:17.357	\N	2025-12-15 14:11:22.250504	\N
535	CASE1765541147781	FUSION SOLAR FARMS PVT.LTD	RAMBABU	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-15 06:54:42.373511				PREMA	2025-12-12	16:00	7032992035	50-100cr	https://maps.app.goo.gl/NxS3VpWGfHJcwhxu8	\N	2025-12-12 12:05:48.366	2025-12-12 12:05:48.366	\N	2025-12-15 05:17:40.630714	\N
543	CASE1765544231068	J Rathnakar Railway Contractor	Srun Kumar	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-15 05:17:47.246123				Srilatha	2025-12-12	18:00	8106063839	50-100cr	Hyderabad	\N	2025-12-12 12:57:12.847	2025-12-12 12:57:12.847	\N	2025-12-15 05:17:47.246123	\N
553	CASE1765782445782	TARINI GEMS AND JEWELLERS	RAMAKRISHNA	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-16 11:52:25.584053				\N	2025-12-16	11:00	9848430051	25-50cr	HIMAYATHNAGAR	\N	2025-12-15 07:07:26.752	2025-12-15 07:07:26.752	\N	2025-12-16 11:52:25.584053	\N
548	CASE1765781004948	GT ALMAX DIES AND TOOLINGS INDIA PVT.LTD	PREMSAGAR	Telecaller	Meeting Done	31	Bill discoutning	\N	\N	Documentation	\N	2025-12-17 06:38:38.107563				PREMA	2025-12-16	15:00	9849022899	50-100cr	HYDERABAD	\N	2025-12-15 06:43:22.612	2025-12-15 06:43:22.612	100000000	2025-12-17 06:38:38.107563	\N
563	CASE1765798393919	Kreative Projects Pvt Ltd	Prakash	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-24 10:55:15.601862				Monika	2025-12-15	14:00	9849432819	50-100cr	Hyderabad	\N	2025-12-15 11:33:15.164	2025-12-15 11:33:15.164	\N	2025-12-24 10:55:15.601862	\N
564	CASE1765799504631	Emirates Logistics India Pvt Ltd	Krishna Mushaib	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-16 11:52:38.672697				Srilatha	2025-12-16	12:00	9920938319	100+ cr	Hyderabad	\N	2025-12-15 11:51:45.562	2025-12-15 11:51:45.562	\N	2025-12-16 11:52:38.672697	\N
555	CASE1765782821542	RUDHRA CONSTRUCTIONS	Praveen kumar	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-15 07:13:59.216005				Google	2025-12-16	10:00	9000100307	25-50cr	https://maps.app.goo.gl/AzHiFLaKzZayf6LG6	\N	2025-12-15 07:13:38.12	2025-12-15 07:13:38.12	\N	2025-12-15 07:13:38.15203	\N
556	CASE1765791842740	GIRIDHAARI AVIATION SERVICES & HOSPITALITY PRIVATE LIMITED	Sridhar Sharma	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-15 10:46:09.43545		sridhar.chilukuri@phenom.com		Google	2025-12-16	16:00	7331107436	100+ cr		\N	2025-12-15 09:44:03.8	2025-12-15 09:44:03.8	\N	2025-12-15 09:44:03.839769	\N
560	CASE1765797992997	M/s Pochampad Constructions co Pvt Ltd	Mahesh 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-12-15 11:27:09.043138				Srilatha	2025-12-15	13:30	9866072010	50-100cr	Hyderabad	\N	2025-12-15 11:26:34.325	2025-12-15 11:26:34.325	\N	2025-12-15 11:26:34.35516	\N
562	CASE1765798256021	Ram laxman paraboiled rice mill pvt ltd	Laxmaiah	Telecaller	One Pager	30	WC	\N	\N	Documentation	\N	2025-12-29 09:42:30.997739				Srilatha	2025-12-15	12:00	9848039579	50-100cr	Nalgonda	\N	2025-12-15 11:30:56.963	2025-12-15 11:30:56.963	250000000	2025-12-29 09:42:30.997739	\N
565	CASE1765799518213	DECCAN ELECTRICALS PVT.LTD	NARENDER KUMAR	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-16 11:52:49.487796				PREMA	2025-12-16	16:30	9849018181	25-50cr	HYDERABAD	\N	2025-12-15 11:51:58.994	2025-12-15 11:51:58.994	\N	2025-12-16 11:52:49.487796	\N
547	CASE1765780902354	STANDRAD ELECTRIC INC	MIRKHAN	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-16 11:53:07.873015				PREMA	2025-12-15	17:00	9885340440	5-25cr	HYDERABAD	\N	2025-12-15 06:41:39.951	2025-12-15 06:41:39.951	\N	2025-12-16 11:53:07.873015	\N
552	CASE1765781901195	SUNSHINE HOSPITALITY SERVICES	Kishore	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-15 13:22:23.449371				Google	2025-12-15	14:30	9246588196	5-25cr	Kondapur	\N	2025-12-15 06:58:17.756	2025-12-15 06:58:17.756	\N	2025-12-15 13:22:23.449371	\N
566	CASE1765799696432	Verity Knowledge Solutions Pvt Ltd	Shaik Abdul Muqueem	Telecaller	Meeting Done	32	BL	\N	\N	Documentation	\N	2025-12-17 06:36:28.295741				Monika	2025-12-16	14:00	9908530926	50-100cr	Hyderabad	\N	2025-12-15 11:54:57.366	2025-12-15 11:54:57.366	7000000000	2025-12-17 06:36:28.295741	\N
549	CASE1765781122565	Crescent Infra and Property 	KAYED JOHAR	Telecaller	Meeting Done	33	LAP	\N	\N	Documentation	\N	2025-12-15 11:56:34.408353					2025-12-15	02:00	9052511172	5-25cr	BOIGUDA	\N	2025-12-15 06:45:23.502	2025-12-15 06:45:23.502	20000000	2025-12-15 11:56:34.408353	\N
550	CASE1765781750961	SAISHAKTI INFRASTRUCTURE PRIVATE LIMITED	Kranthi kumar	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-30 05:05:36.254862				Nitheesh sir	2025-12-16	11:00	9052443965	1-5cr	https://maps.app.goo.gl/DpbUrRdwTHFAtKwk8	\N	2025-12-15 06:55:47.553	2025-12-15 06:55:47.553	\N	2025-12-30 05:05:36.254862	\N
551	CASE1765781880773	MAHALAKSHMI PARA BOILED RICE INDUSTRIES	SRIDHAR KUMAR	Telecaller	Meeting Done	33	BL	\N	\N	Documentation	\N	2025-12-15 12:16:56.694813				\N	2025-12-15	11:30	8885568855	25-50cr	IBRAHIMPATNAM	\N	2025-12-15 06:58:01.689	2025-12-15 06:58:01.689	30000000	2025-12-15 12:16:56.694813	\N
559	CASE1765797531654	Linear Constructions Private Limited	Palla Krishna	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-16 13:05:17.086861				\N	2025-12-16	10:30	9848422274	25-50cr	hyd	\N	2025-12-15 11:18:52.762	2025-12-15 11:18:52.762	50000000	2025-12-16 13:05:17.086861	\N
558	CASE1765797453989	sri sai ram seeds and fertilizers	reddy	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-16 13:06:56.811863				\N	2025-12-16	11:00	9440823347	5-25cr	hyd	\N	2025-12-15 11:17:34.801	2025-12-15 11:17:34.801	\N	2025-12-16 13:06:56.811863	\N
554	CASE1765782609925	SUNIL BUILDERS	SUNIL CHANDRA REDDY	Telecaller	Meeting Done	33	Bill discoutning	\N	\N	Documentation	\N	2025-12-17 06:38:06.239124				\N	2025-12-16	11:30	9246531624		SOMAJIGUDA	\N	2025-12-15 07:10:10.912	2025-12-15 07:10:10.912	10000000	2025-12-17 06:38:06.239124	\N
302	CASE1764398029125	Enmax Engineering India Private limited	Narayana Reddy	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 12:31:11.533776					2025-11-29	12:00	9949301237	50-100cr	hyderabad	\N	2025-11-29 06:33:49.899	2025-11-29 06:33:49.899	\N	2025-12-15 12:31:11.533776	\N
147	CASE1762840358280	Hiranandani Realtors Private Limited	Abhishikth Sattaluri	Telecaller	No Requirement	32	\N	\N	\N	\N	\N	2025-12-15 12:48:05.165801	Srinivasan Sattaluri		8886063448	Srilatha	2025-10-16	12:30	8185951358	5-25cr	Hyderabad	\N	2025-11-11 05:52:38.754	2025-11-11 05:52:38.754	\N	2025-12-15 12:48:05.165801	\N
576	CASE1765805600647	abt logistics	venky	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-15 13:33:21.830056				\N	2025-12-01	11:30	9994488500	5-25cr	hyd	\N	2025-12-15 13:33:21.8	2025-12-15 13:33:21.8	\N	2025-12-15 13:33:21.830056	\N
579	CASE1765805887695	mahesh fats and oils private limited	suraj bhan	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-15 13:38:08.881004				\N	2025-12-03	14:30	9848015851	100+ cr		\N	2025-12-15 13:38:08.85	2025-12-15 13:38:08.85	\N	2025-12-15 13:38:08.881004	\N
581	CASE1765806537439	INNOPARK (INDIA) PRIVATE LIMITED	Vijay saradhi	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-15 13:48:17.765107				Mounika	2025-12-12	13:30	9908730281	5-25cr	Hitech City	\N	2025-12-15 13:48:01.14	2025-12-15 13:48:01.14	\N	2025-12-15 13:48:01.172114	\N
582	CASE1765806706545	SVK Solar Tech Private Limited	Phani babu	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-15 13:51:01.779518				Mounika	2025-12-12	11:00	9000487622	5-25cr	ECIL	\N	2025-12-15 13:50:50.252	2025-12-15 13:50:50.252	\N	2025-12-15 13:50:50.282231	\N
588	CASE1765867795356	SHYAM TEXTILES LIMITED	PANKAJ	Telecaller	No Requirement	33	BL	\N	\N	Documentation	\N	2025-12-26 11:43:32.627802				\N	2025-12-17	12:30	9743175140	100+ cr	BANGLORE	\N	2025-12-16 06:49:55.418	2025-12-16 06:49:55.418	1	2025-12-26 11:43:32.627802	\N
542	CASE1765544103935	Associated Ceramics Limited	Rajaram Chanduptla	Telecaller	Meeting Done	32	LAP	\N	\N	Documentation	\N	2025-12-15 14:11:12.630143				Prema	2025-12-12	12:00	9849169153	50-100cr	Hyderabad	\N	2025-12-12 12:55:05.594	2025-12-12 12:55:05.594	25000000	2025-12-15 14:11:12.630143	\N
570	CASE1765805199116	nakoda gems nd jewellers	sandeep kumar jain	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 14:18:57.620067				\N	2025-12-15	13:00	9885377970	300crs	hyd	\N	2025-12-15 13:26:39.628	2025-12-15 13:26:39.628	\N	2025-12-15 14:18:57.620067	\N
578	CASE1765805708463	kanyaka parameshwari oils private limited	sreedhar	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 14:20:54.293945				\N	2025-12-02	11:30	9492583042	50-100cr	hyd	\N	2025-12-15 13:35:09.471	2025-12-15 13:35:09.471	7000000	2025-12-15 14:20:54.293945	\N
580	CASE1765805935611	brs refineries private limited	ashok	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-15 14:19:51.473201				\N	2025-12-09	11:00	9885415000	25-50cr	hyd	\N	2025-12-15 13:38:56.404	2025-12-15 13:38:56.404	50000000	2025-12-15 14:19:51.473201	\N
574	CASE1765805431246	sri sai enterprises	kotha vijay	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 14:21:05.596033				\N	2025-12-10	11:00	9010364677		hyd	\N	2025-12-15 13:30:32.12	2025-12-15 13:30:32.12	\N	2025-12-15 14:21:05.596033	\N
572	CASE1765805317066	virtue agencies	madhukar reddy	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 14:21:34.295112				\N	2025-12-11	11:30	8686126362	25-50cr	hyd	\N	2025-12-15 13:28:37.592	2025-12-15 13:28:37.592	\N	2025-12-15 14:21:34.295112	\N
571	CASE1765805264249	sri jagdamba pearls	avinash agrawal	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 14:22:02.970574				\N	2025-12-11	10:30	9885540000	50-100cr	hyd	\N	2025-12-15 13:27:45.099	2025-12-15 13:27:45.099	\N	2025-12-15 14:22:02.970574	\N
575	CASE1765805483081	rr high energetics limited	jayaram reddy	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-15 14:22:46.845882				\N	2025-12-10	10:30	9848050888	25-50cr		\N	2025-12-15 13:31:23.581	2025-12-15 13:31:23.581	\N	2025-12-15 14:22:46.845882	\N
589	CASE1765868100771	creative structures	Shoban babu	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-16 06:55:17.046525				Srilatha	2025-12-17	17:00	9392222079	25-50cr		\N	2025-12-16 06:55:01.131	2025-12-16 06:55:01.131	\N	2025-12-16 06:55:01.166877	\N
585	CASE1765809134711	KOP AGRO LIMITED	Pratul Kedia	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:29:29.445547				\N	2025-12-09	11:00	9848731031	50-100cr	Hyderabad	\N	2025-12-15 14:32:15.923	2025-12-15 14:32:15.923	\N	2025-12-18 10:29:29.445547	\N
590	CASE1765868332721	DELTA ENCLAVES PVT.LTD	PRAVEEN REDDY	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-18 04:34:50.909202				SRILATHA	2025-12-17	14:30	9945844555	5-25cr	BANGLORE	\N	2025-12-16 06:58:52.46	2025-12-16 06:58:52.46	\N	2025-12-18 04:34:50.909202	\N
414	CASE1764418541962	Vedadri Developers	Vedadri	Telecaller	One Pager	29	Real Estate Assest. Management Company	\N	\N	Documentation	\N	2025-12-29 09:43:44.508361				\N	2025-11-29	11:30	7032924223			\N	2025-11-29 12:15:42.634	2025-11-29 12:15:42.634	50000000	2025-12-29 09:43:44.508361	\N
591	CASE1765869207377	Sri Company	mukesh agarwal	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-16 13:06:29.986584					2025-12-16	11:00	9849014152	50-100cr	hyderabad	\N	2025-12-16 07:13:28.116	2025-12-16 07:13:28.116	\N	2025-12-16 13:06:29.986584	\N
586	CASE1765863217086	m/s ratna engineering corporation	Kalyan nallapati	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-16 07:32:48.930679					2025-12-17	11:00	9246345884	50-100cr	Hyderabad	\N	2025-12-16 05:33:38.211	2025-12-16 05:33:38.211	\N	2025-12-16 05:33:38.251027	\N
587	CASE1765867786766	T.V Today Network Limited	Rajesh 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-17 10:43:23.110642				Srilatha	2025-12-17	11:30	9810492512	100+ cr	Delhi	\N	2025-12-16 06:49:47.945	2025-12-16 06:49:47.945	\N	2025-12-17 10:43:23.110642	\N
567	CASE1765799895380	Hi Tech Insulation	Subramanian Pattabiraman	Telecaller	Meeting Done	32	OD	\N	\N	Documentation	\N	2025-12-17 06:36:00.7117				Irfan Sir	2025-12-16	14:30	9440066755	25-50cr	Hyderabad	\N	2025-12-15 11:58:16.362	2025-12-15 11:58:16.362	65000000	2025-12-17 06:36:00.7117	\N
593	CASE1765869821744	Pulse Pharmaceuticals Pvt Ltd	MVS Chary 	Telecaller	No Requirement	32	WC	\N	\N	Documentation	\N	2025-12-26 11:43:38.619397				Srilatha	2025-12-17	14:00	9989990244	100+ cr	Hyderabad	\N	2025-12-16 07:23:42.822	2025-12-16 07:23:42.822	60	2025-12-26 11:43:38.619397	\N
584	CASE1765808188316	Tabhitha constructions	shivaratri tabhitha	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:31:04.558601				\N	2025-12-08	17:30	9553514231	25-50cr	hyd	\N	2025-12-15 14:16:29.448	2025-12-15 14:16:29.448	\N	2025-12-18 10:31:04.558601	\N
568	CASE1765805103148	disha enterprises	manoj	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:32:40.005853				\N	2025-12-15	17:30	9391078130	25-50cr	hyd	\N	2025-12-15 13:25:03.677	2025-12-15 13:25:03.677	\N	2025-12-18 10:32:40.005853	\N
569	CASE1765805145831	rajdhani chemicals	anil	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:33:18.660072				\N	2025-12-15	11:00	9885724222	25-50cr	hyd	\N	2025-12-15 13:25:46.7	2025-12-15 13:25:46.7	\N	2025-12-18 10:33:18.660072	\N
573	CASE1765805365766	lalitha logistics	shyam agrawal	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:33:40.477492				\N	2025-12-11	11:30	9666669365	25-50cr	hyd	\N	2025-12-15 13:29:26.566	2025-12-15 13:29:26.566	\N	2025-12-18 10:33:40.477492	\N
577	CASE1765805652133	vama industries	rama raju	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:34:20.741277				\N	2025-12-02	11:00	9391026070	50-100cr	hyd	\N	2025-12-15 13:34:12.953	2025-12-15 13:34:12.953	\N	2025-12-18 10:34:20.741277	\N
392	CASE1764403012771	VSA Infra pvt ltd	kondal reddy	Telecaller	Login	29	PROMOTER FUNDING , Term Loan, Working Capital ( 20 cr - 250cr)	\N	\N	Documentation	\N	2025-12-29 09:44:51.893228				\N	2025-11-29	10:00	9866010800	350crs		\N	2025-11-29 07:56:53.471	2025-11-29 07:56:53.471	40000000	2025-12-29 09:44:51.893228	\N
507	CASE1764758733768	SPACENET ENTERPRISES INDIA LIMITED	Ganesh kumar - CFO	Telecaller	PD	30	LAP	\N	\N	One Pager	\N	2025-12-29 09:56:43.720158				Prema	2025-12-01	11:30	9000484951	100+ cr	https://maps.app.goo.gl/BysWzudUdeQYESUv6	\N	2025-12-03 10:45:32.513	2025-12-03 10:45:32.513	70000000	2025-12-29 09:56:43.720158	\N
445	CASE1764420063211	Cauvery Iron and steel India Limited	BHOOPESH GUPTA	Telecaller	PD	30	WC	\N	\N	One Pager	\N	2025-12-29 09:57:32.587341				\N	2025-11-10	13:30	9848025920	100+ cr	HYD	\N	2025-11-29 12:41:04.074	2025-11-29 12:41:04.074	1200000000	2025-12-29 09:57:32.587341	\N
592	CASE1765869773926	Sri Krishna Steels	Kolvi	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-16 07:32:30.302516					2025-12-17	11:00	9346751009	50-100cr	hyderabad	\N	2025-12-16 07:22:54.695	2025-12-16 07:22:54.695	\N	2025-12-16 07:22:54.72692	\N
606	CASE1765968009674	NEULAND LABORATORIES LIMITED	Srinibabu	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-17 10:42:00.269127				Srilatha	2025-12-18	16:00	8886867830	100+ cr	https://maps.app.goo.gl/ozFPxAL5tS5qLp4a8	\N	2025-12-17 10:40:10.244	2025-12-17 10:40:10.244	\N	2025-12-17 10:40:10.282852	\N
609	CASE1765973513849	SAZ CONSTRUCTIONS	AFZAL	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-18 11:22:59.839806				MOUNIKA	2025-12-18	10:30	9700145105	5-25cr	https://maps.app.goo.gl/ftew9s4kWy5pyHfp6	\N	2025-12-17 12:11:59.809	2025-12-17 12:11:59.809	\N	2025-12-18 11:22:59.839806	\N
596	CASE1765878383285	SRI COFORT AIR PRODUCTS AND SERVICES	ADANKI NAGESHWAR RAO99	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2025-12-16 09:50:35.270329				Srilatha	2025-12-17	11:00	9948090425	25-50cr	TARNAKA	\N	2025-12-16 09:46:23.329	2025-12-16 09:46:23.329	\N	2025-12-16 09:46:23.361671	\N
97	CASE1762837917691	Madhucon sugar and power industries pvt.ltd	Venkateswarulu -CFO	Telecaller	No Requirement	31	Small LAP upto 7cr	\N	\N	\N	\N	2025-12-16 11:38:43.62815				Mounika	2025-10-27	15:00	9676555544	25-50cr	https://maps.app.goo.gl/WYBdywjPkGCjVZGy5	\N	2025-11-11 05:11:51.241	2025-11-11 05:11:51.241	1	2025-12-16 11:38:43.62815	\N
608	CASE1765972205778	HSM Steels Private Limited	Harsh Agarwal	Telecaller	Meeting Done	29	Bill discoutning	\N	\N	Documentation	\N	2026-01-02 07:34:21.609258				Abhinandan	2025-12-18	10:30	8978224740	396crs		\N	2025-12-17 11:50:06.821	2025-12-17 11:50:06.821	500000000	2026-01-02 07:34:21.609258	2026-01-02
595	CASE1765877494508	ELITE DEMOLITION SERVICES PRIVATE LIMITED	MURALIDHAR	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-17 06:44:50.01497				SRILATHA	2025-12-17	12:30	9866362121	5-25cr	HYDERABAD	\N	2025-12-16 09:31:39.126	2025-12-16 09:31:39.126	\N	2025-12-17 06:44:50.01497	\N
605	CASE1765966770731	EVITAL HEAVY ENGINEERING PVT.LTD	VITTAL	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-22 10:27:51.789624				MOUNIKA	2025-12-22	12:00	9652958958	5-25cr	HYDERABAD	\N	2025-12-17 10:19:36.489	2025-12-17 10:19:36.489	\N	2025-12-22 10:27:51.789624	\N
602	CASE1765955746080	SUNRISE INFRA	Krishna reddy	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-17 07:16:00.635259				Srilatha	2025-12-18	11:30	9010446444	5-25cr	LB Nagar	\N	2025-12-17 07:15:46.936	2025-12-17 07:15:46.936	\N	2025-12-17 07:15:46.969944	\N
612	CASE1766040125206	P R Konda Constructions	Shailaja	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-19 05:32:16.244559				\N	2025-12-19	12:00	9246277696		hyderabad	\N	2025-12-18 06:42:06.264	2025-12-18 06:42:06.264	\N	2025-12-19 05:32:16.244559	\N
616	CASE1766058366830	SAI PRASSANA	SRINIVAS	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-24 10:54:37.673408				\N	2025-12-19	11:30	9989123423	25-50cr	KARIMNAGAR(ON CALL)	\N	2025-12-18 11:46:07.74	2025-12-18 11:46:07.74	\N	2025-12-24 10:54:37.673408	\N
599	CASE1765953930127	Heemankshi Bakers Private Limited	SHRAVAN KUMAR AGARWAL	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-18 10:28:30.883777				\N	2025-12-18	10:00	9848022871	100crs	Hyderabad	\N	2025-12-17 06:45:31.053	2025-12-17 06:45:31.053	\N	2025-12-18 10:28:30.883777	\N
598	CASE1765888796146	Jai Ambe Traders	rajesh sharma	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2025-12-31 09:50:53.026555					2025-12-17	11:00	9959935354	25-50cr	Hyderabad	\N	2025-12-16 12:39:56.782	2025-12-16 12:39:56.782	\N	2025-12-31 09:50:53.026555	\N
603	CASE1765960294090	Nimma Narayan Engineers & Contractors	Naresh	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-24 10:54:31.755488				Srilatha	2025-12-18	14:30	9912705678	25-50cr	Hyderabad	\N	2025-12-17 08:31:34.838	2025-12-17 08:31:34.838	\N	2025-12-24 10:54:31.755488	\N
620	CASE1766124912325	Ramanjaneyulu Chandrika reddy civil contractor	Mr.Reddy	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-19 06:15:13.224753				\N	2025-12-22	11:00	9849800625	90crs	hyderabad	\N	2025-12-19 06:15:13.223	2025-12-19 06:15:13.223	\N	2025-12-19 06:15:13.224753	\N
540	CASE1765542753297	 SRI SATYAM ISPAT INDUSTRIES INDIA PRIVATE LIMITED	Chiranjeevi (Director)	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2025-12-17 11:57:01.996099				Srilatha	2025-12-15	11:00	8885024015	100+ cr	https://maps.app.goo.gl/oJhd2mXqEdMraLob8	\N	2025-12-12 12:32:33.314	2025-12-12 12:32:33.314	\N	2025-12-17 11:57:01.996099	\N
594	CASE1765871860313	sree venkateshwara oil agencies	Ramanand Agrawal	Telecaller	Meeting Done	29	BANK GURANTEE	\N	\N	Documentation	\N	2025-12-18 10:29:07.063167					2025-12-17	17:00	9391072326	210crs	Hyderabad	\N	2025-12-16 07:57:40.934	2025-12-16 07:57:40.934	10000000	2025-12-18 10:29:07.063167	\N
611	CASE1766036300240	SURYODAYA INFRA PROJECTS (I) PRIVATE LIMITED	Rajendra prasad	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-18 05:38:36.90981				Srilatha	2025-12-19	12:30	9490793639	100+ cr	https://maps.app.goo.gl/hFjoxo1QzEdvY8M17	\N	2025-12-18 05:38:19.645	2025-12-18 05:38:19.645	\N	2025-12-18 05:38:19.675636	\N
610	CASE1765974676348	AAYKAY ELECTRICAL ENTERPRISES	Abdul kareem	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-18 06:54:13.977968				srilatha	2025-12-18	11:00	9866700400	50-100cr	https://maps.app.goo.gl/JfdaysHbcy2taAWW8	\N	2025-12-17 12:31:16.836	2025-12-17 12:31:16.836	\N	2025-12-17 12:31:16.865758	\N
613	CASE1766040156538	YNR CONSTRUCTIONS	NAGARAJU	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-24 10:54:11.626032				SRILATHA	2025-12-19	10:30	9000739398	5-25cr	HYDERABAD	\N	2025-12-18 06:42:43.225	2025-12-18 06:42:43.225	\N	2025-12-24 10:54:11.626032	\N
614	CASE1766042983358	CORRXPERTS PVT LTD	AGARWAL	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-22 04:31:27.720995					2025-12-19	14:00	9904748001	100+ cr	GUJARAT(ON CALL)	\N	2025-12-18 07:29:44.436	2025-12-18 07:29:44.436	\N	2025-12-22 04:31:27.720995	\N
600	CASE1765955160767	PRR INFRA PROJECTS	PRADEEP	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2025-12-18 11:11:01.744403				SRILATHA	2025-12-18	12:00	9666903335	25-50cr	https://maps.app.goo.gl/5nr1TSYbzbWuv9897	\N	2025-12-17 07:06:05.768	2025-12-17 07:06:05.768	\N	2025-12-18 11:11:01.744403	\N
604	CASE1765961054261	HIMANSHI BAKERS	SHRAVAN KUMAR AGARWAL	Telecaller	Meeting Done	33	BL	\N	\N	Documentation	\N	2025-12-18 10:28:24.298998					2025-12-18	10:00	9848022871	100+ cr	KOTHUR	\N	2025-12-17 08:44:14.247	2025-12-17 08:44:14.247	50000000	2025-12-18 10:28:24.298998	\N
607	CASE1765972147915	Entrix Projects	Kishore Pawar	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-18 11:11:10.457129				Monika	2025-12-18	14:30	8639856472	5-25cr	Hyderabad	\N	2025-12-17 11:49:08.959	2025-12-17 11:49:08.959	\N	2025-12-18 11:11:10.457129	\N
617	CASE1766123371530	Western Constructions	Allthaaf 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-12-19 05:52:15.006435				Prema	2025-12-22	12:30	9963995725	100+ cr	Hyderabad	\N	2025-12-19 05:49:32.484	2025-12-19 05:49:32.484	\N	2025-12-19 05:49:32.516568	\N
619	CASE1766124521620	GREENTIME PROJECTS PRIVATE LIMITED	Indra Kumar	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-19 06:11:50.526528				Sriltha	2025-12-22	12:00	9010138400	100+ cr	Madhapur	\N	2025-12-19 06:08:42.558	2025-12-19 06:08:42.558	\N	2025-12-19 06:08:42.590469	\N
597	CASE1765884689702	Blue aqua ras private limited 	Ram	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-19 06:15:05.835479				Srilatha	2025-12-17	11:00	9963998784	50-100cr	https://maps.app.goo.gl/QEHosKuMv4cesf1R9	\N	2025-12-16 11:31:29.408	2025-12-16 11:31:29.408	20000000	2025-12-17 11:56:37.481736	\N
615	CASE1766050517326	Ravali Cottage Industries	Harsha 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-22 04:31:12.368401				Irfan Sir	2025-12-19	11:30	9440370856	25-50cr	On Call	\N	2025-12-18 09:35:18.633	2025-12-18 09:35:18.633	\N	2025-12-22 04:31:12.368401	\N
622	CASE1766125172313	IMPACT METALS LTD	VENKATRAO	Telecaller	Documentation In Progress	33	WC - 20CR	\N	\N	Documentation	\N	2025-12-26 09:13:37.187287					2025-12-22	11:30	9989288725	25-50cr	LAKDIKAPOOL	\N	2025-12-19 06:19:32.318	2025-12-19 06:19:32.318	200000000	2025-12-26 09:13:37.187287	\N
618	CASE1766123866517	gamenexa studios private limited	srinivas reddy	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-22 12:57:51.073057				\N	2025-12-22	11:30	9642228800	38crs	hyderabad	\N	2025-12-19 05:57:46.932	2025-12-19 05:57:46.932	3000000	2025-12-22 12:57:51.073057	\N
624	CASE1766137474018	Mirza Steels	Mohammed amer	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-19 09:44:35.071986				\N	2025-12-22	11:00	8179086545	5-25cr	hyderabad	\N	2025-12-19 09:44:35.034	2025-12-19 09:44:35.034	\N	2025-12-19 09:44:35.071986	\N
637	CASE1766404672112	ZYWIE MEDICAL DEVICES PRIVATE LIMITED	Anantham 	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-22 12:09:54.962959				Srilatha	2025-12-23	11:30	9291362165	100+ cr		\N	2025-12-22 11:57:52.617	2025-12-22 11:57:52.617	\N	2025-12-22 11:57:52.657045	\N
630	CASE1766387768554	mobilution it systems private limited	srinivas gunturu	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-22 07:16:09.972736				\N	2025-12-23	11:00	9000611323	5-25cr	Hyderabad	\N	2025-12-22 07:16:09.93	2025-12-22 07:16:09.93	\N	2025-12-22 07:16:09.972736	\N
621	CASE1766125139154	GOLCONDA CORROSION CONTROL PVT.LTD	SUNDEEP	Telecaller	Meeting Done	31	MACHINERY FUNDING	\N	\N	Documentation	\N	2025-12-22 12:18:59.771427				SRILATHA	2025-12-22	16:00	8866998444	25-50cr	https://maps.app.goo.gl/QDTX9AZMagKSqUfA7	\N	2025-12-19 06:19:00.254	2025-12-19 06:19:00.254	250000000	2025-12-22 12:18:59.771427	\N
631	CASE1766394491531	Ingersoll Rand India Limited	Suhas G 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-12-22 09:09:57.683706				Srilatha	2025-12-23	15:00	9686601879	100+ cr	Hyderabad	\N	2025-12-22 09:08:12.449	2025-12-22 09:08:12.449	\N	2025-12-22 09:08:12.487979	\N
625	CASE1766142806610	padmavathi adds & enterprises	Chandrashekhar Reddy	Telecaller	Meeting Done	29	LAP	\N	\N	Documentation	\N	2025-12-22 12:56:58.906836				\N	2025-12-22	11:00	9849211249	5-25cr	hyderabad	\N	2025-12-19 11:13:27.629	2025-12-19 11:13:27.629	30000000	2025-12-22 12:56:58.906836	\N
626	CASE1766144009222	N Circle Exim LLP	Naveen 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-22 10:28:02.359652				Prema	2025-12-22	14:30	9347111335	25-50cr	Hyderabad	\N	2025-12-19 11:33:30.208	2025-12-19 11:33:30.208	\N	2025-12-22 10:28:02.359652	\N
623	CASE1766126514843	VET INDIA PHARMACEUTICALS LIMITED	VIVEK	Telecaller	Meeting Done	33	MACHINERY FUNDING	\N	\N	Documentation	\N	2025-12-22 10:28:29.449349				SRILATHA	2025-12-22	11:30	9885666692	25-50cr	HYDERABAD(ON CALL)	\N	2025-12-19 06:41:54.833	2025-12-19 06:41:54.833	10000000	2025-12-22 10:28:29.449349	\N
639	CASE1766406148156	CreativePro IT Services LLP	Sudesh Kumar	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-22 12:25:15.169005				Irfan Sir	2025-12-22	13:00	9885035971	5-25cr	Hyderabad	\N	2025-12-22 12:22:29.277	2025-12-22 12:22:29.277	\N	2025-12-22 12:25:15.169005	\N
635	CASE1766399969704	soluxy systems	soluxy systems	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2026-01-07 10:44:41.146207				\N	2025-12-23	11:00	8008001592	25-50cr	hyderabad	\N	2025-12-22 10:39:31.781	2025-12-22 10:39:31.781	\N	2026-01-07 10:44:41.146207	\N
644	CASE1766482376257	M/s Bhavani Marketing	Dheeraj Agarwal 	Telecaller	Documentation Initiated	32	LAP	\N	\N	Documentation	\N	2025-12-31 12:09:50.187632				Monika	2025-12-24	12:30	9989833336	5-25cr	Hyderabad	\N	2025-12-23 09:32:57.883	2025-12-23 09:32:57.883	30000000	2025-12-31 12:09:50.187632	\N
629	CASE1766385005023	GDR infratech	Gowtham	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2025-12-22 12:34:58.286134				Srilatha	2025-12-22	14:30	9908499033	100+ cr	HITEC City	\N	2025-12-22 06:30:06.629	2025-12-22 06:30:06.629	50000000	2025-12-22 12:34:58.286134	\N
641	CASE1766473725578	COGENT TECHNOCOM SERVICE AND SOLUTIONS LLP	PRAMODH JAIN	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2025-12-23 07:14:14.826288				SRILATHA	2025-12-24	13:30	9177780160	25-50cr	HYDERABAD	\N	2025-12-23 07:08:48.397	2025-12-23 07:08:48.397	\N	2025-12-23 07:08:48.435672	\N
627	CASE1766144563918	KNR INFRA PROJECTS	Aditya	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-22 12:35:17.408941	Nageshwara rao		8374001406	Mounika	2025-12-22	11:30	9010099188	5-25cr	https://maps.app.goo.gl/tXQyiMRb6qWKieJx5	\N	2025-12-19 11:42:44.657	2025-12-19 11:42:44.657	20000000	2025-12-22 12:35:17.408941	\N
583	CASE1765806937224	OPTUM GLOBAL SOLUTIONS (INDIA) PRIVATE LIMITED	Naga krishan	Telecaller	Meeting Done	30	WC	\N	\N	Documentation	\N	2025-12-22 12:37:22.037111				Prema	2025-12-12	16:30	9849070179	100+ cr	https://maps.app.goo.gl/6WF1mCovJXMAE2By7	\N	2025-12-15 13:54:40.954	2025-12-15 13:54:40.954	10000000	2025-12-22 12:37:22.037111	\N
648	CASE1766574714586	Chaitanya cold storage private limited	Chaitanya Srinivasan	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-05 12:03:00.906364				Srilatha	2025-12-26	14:00	9845001900	50-100cr	Bangalore	\N	2025-12-24 11:11:55.224	2025-12-24 11:11:55.224	\N	2026-01-05 12:03:00.906364	\N
640	CASE1766407652250	KAPIL GROUP MARKETING SERVICES	VINOD	Telecaller	Documentation Initiated	33	LAP	\N	\N	Documentation	\N	2025-12-29 09:40:43.914815					2025-12-22	11:30	9000550901	25-50cr	HYDERABAD	\N	2025-12-22 12:47:34.043	2025-12-22 12:47:34.043	500000000	2025-12-29 09:40:43.914815	\N
632	CASE1766395058186	SRI SAI SRINIVAS AGROTECH	SHASHIKUMAR	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-23 10:04:16.487704					2025-12-23	11:00	9676151406	25-50cr	KARIMNAGAR	\N	2025-12-22 09:17:39.967	2025-12-22 09:17:39.967	\N	2025-12-23 10:04:16.487704	\N
633	CASE1766398846008	Santhosh and Company 	Narsimloo Mahajan	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-30 04:41:58.651277				Monika	2025-12-23	11:30	9440070605	5-25cr	on call 	\N	2025-12-22 10:20:46.969	2025-12-22 10:20:46.969	\N	2025-12-30 04:41:58.651277	\N
642	CASE1766473798208	AARUSH POYMERS PVT.LTD	ANKITH AGARWAL	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2025-12-24 07:04:37.644622				NITHEESH	2025-12-26	10:30	9701015000	25-50cr	HYDERABAD	\N	2025-12-23 07:10:07.997	2025-12-23 07:10:07.997	\N	2025-12-23 07:10:08.037725	\N
646	CASE1766565547307	 Cornext agri products pvt ltd	Sai	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-24 08:39:25.393422				Srilatha	2025-12-24	12:30	 9703764347	50-100cr	Madhapur	\N	2025-12-24 08:39:06.42	2025-12-24 08:39:06.42	\N	2025-12-24 08:39:06.458987	\N
647	CASE1766569075779	BAC INFRATECH PRIVATE LIMITED	Vijay reddy	Telecaller	Meeting Done	30	BANK GURANTEE	\N	\N	Documentation	\N	2025-12-30 04:55:32.768634				Srilatha	2025-12-26	11:30	9000400865	100+ cr	https://maps.app.goo.gl/kAB6T7d4R9YVDnXVA	\N	2025-12-24 09:37:56.479	2025-12-24 09:37:56.479	50000000	2025-12-30 04:55:32.768634	\N
634	CASE1766399937938	soluxy systems	soluxy systems	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2026-01-07 10:44:47.665442				\N	2025-12-23	11:00	8008001592	25-50cr	hyderabad	\N	2025-12-22 10:38:58.869	2025-12-22 10:38:58.869	\N	2026-01-07 10:44:47.665442	\N
638	CASE1766405380422	Ecloled illuminations pvt.ltd	Raghu kiran	Telecaller	Documentation Initiated	30	CGTMSE	\N	\N	Documentation	\N	2025-12-31 12:10:04.524545				Srilatha	2025-12-23	11:00	9391384448	100+ cr		\N	2025-12-22 12:09:40.973	2025-12-22 12:09:40.973	10000000	2025-12-31 12:10:04.524545	\N
636	CASE1766402098739	Abhima Projects	Kishore Attada	Telecaller	Meeting Done	32	OD	\N	\N	Documentation	\N	2025-12-24 10:51:19.283412				Monika	2025-12-23	11:00	9000267044	100+ cr	Hyderabad	\N	2025-12-22 11:14:59.746	2025-12-22 11:14:59.746	30000000	2025-12-24 10:51:19.283412	\N
650	CASE1766731483043	INCEDO TECHNOLOGY SOLUTIONS LTD	AVINASH DUDEJA	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2025-12-26 06:44:42.977927				\N	2025-12-29	11:30	9711221960	100+ cr	HYDERABAD	\N	2025-12-26 06:44:42.947	2025-12-26 06:44:42.947	\N	2025-12-26 06:44:42.977927	\N
651	CASE1766732829433	TA INFRA PROJECTS LIMITED	MOHD MAQBOOL	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2025-12-26 07:07:21.496058				SRILATHA	2025-12-29	14:00	9701807530	5-25cr	HYDERABAD	\N	2025-12-26 07:07:10.442	2025-12-26 07:07:10.442	\N	2025-12-26 07:07:10.480071	\N
645	CASE1766558929074	YANACOSTRUCTIONS	PAVAN	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-30 04:41:43.907184				GOOGLE	2025-12-26	11:30	8106160884	1-5cr	CHEVELLA	\N	2025-12-24 06:48:50.009	2025-12-24 06:48:50.009	\N	2025-12-30 04:41:43.907184	\N
628	CASE1766146196651	geographics interiors llp	balraj singh	Telecaller	No Requirement	29	\N	\N	\N	Documentation	\N	2026-01-07 11:14:15.24016				\N	2025-12-22	14:00	9818148799	50-100cr	hyderabad	\N	2025-12-19 12:09:58.24	2025-12-19 12:09:58.24	\N	2026-01-07 11:14:15.24016	\N
654	CASE1766746602117	KERNEX MICRO SYSTEMS INDIA LTD	NARAYANA RAJU	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2025-12-26 10:56:42.170443				\N	2025-12-29	11:30	9848155788	100+ cr	HYDERABAD	\N	2025-12-26 10:56:42.132	2025-12-26 10:56:42.132	\N	2025-12-26 10:56:42.170443	\N
653	CASE1766746452094	AKSHARA ENTERPRISES INDIA PRIVATE LIMITED	Ravi kumar	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-26 10:56:53.120673				Srilatha	2025-12-29	11:30	8499969924	100+ cr	https://maps.app.goo.gl/TwVsVNR2UX71UevK6	\N	2025-12-26 10:54:12.937	2025-12-26 10:54:12.937	\N	2025-12-26 10:54:12.966888	\N
665	CASE1767090169643	Venus trading company	Rakesh 	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-30 10:23:32.469178				Srilatha	2025-12-31	12:00	9849397780	50-100cr	https://maps.app.goo.gl/nTG63PuVBdKKy5Ks6	\N	2025-12-30 10:22:51.322	2025-12-30 10:22:51.322	\N	2025-12-30 10:22:51.352464	\N
669	CASE1767172063807	VIDARBHA STORES PACKINGCOMPANY PVT LTD	ABHISHEK	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2026-01-05 04:40:54.973277					2026-01-01	04:00	9011126204	25-50cr	JABALPUR	\N	2025-12-31 09:07:44.386	2025-12-31 09:07:44.386	\N	2026-01-05 04:40:54.973277	\N
658	CASE1766989499319	Konda Alu Crafts Industries	Bangar Raju	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-29 06:24:59.460779				\N	2025-12-30	14:30	8686877788	50-100cr	hyderabad	\N	2025-12-29 06:24:59.431	2025-12-29 06:24:59.431	\N	2025-12-29 06:24:59.460779	\N
659	CASE1766992073748	Inviro bio systems pvt ldt	Pranav akula	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2025-12-29 07:21:05.299847				Srilatha	2025-12-30	12:00	7799182283	25-50cr	Nallakunta shivam road ND Balnagar	\N	2025-12-29 07:07:50.231	2025-12-29 07:07:50.231	\N	2025-12-29 07:07:50.269253	\N
660	CASE1766993107450	Supreme Chemicals Ventures Private Limited	RAMAKATH GUPTA	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2025-12-29 07:25:08.541287				\N	2025-12-29	05:00	9346588032	25-50cr	Hyderabad	\N	2025-12-29 07:25:08.51	2025-12-29 07:25:08.51	\N	2025-12-29 07:25:08.541287	\N
601	CASE1765955469368	SWASTIK STEEL AND TUBES LLP	ASHISH KEDIA	Telecaller	Documentation Initiated	33	WC,LAP,NCD(ABOVE 8CR),UNSECURED FUNDING UPTO 75CR,CHANNEL FINANCE,AIF,PMS	\N	\N	Documentation	\N	2025-12-29 09:40:58.245865					2025-12-18	11:30	9700216028	100+ cr	SHIVARAMPALLY	\N	2025-12-17 07:11:09.159	2025-12-17 07:11:09.159	150000000	2025-12-29 09:40:58.245865	\N
194	CASE1763185986592	Suvarna Technosoft Private Limited	Samba Siva Suresh  - MD	Telecaller	One Pager	32	BL	\N	\N	\N	\N	2025-12-29 09:54:29.184139	Samba Siva Suresh  - MD			Srilatha	2025-11-13	15:00	9246533522	50-100cr	Hyderabad	\N	2025-11-15 05:53:06.557	2025-11-15 05:53:06.557	50000000	2025-12-29 09:54:29.184139	\N
652	CASE1766744912321	FLYBERRY INTERTRADE PVT.LTD	AKARASH MAKHIJA	Telecaller	Meeting Done	31	Bill discoutning	\N	\N	Documentation	\N	2025-12-30 04:54:46.73569				SRILATHA	2025-12-29	10:30	9848036000	5-25cr	https://maps.app.goo.gl/rxchxQDofRHadxZo6?g_st=ic	\N	2025-12-26 10:28:33.86	2025-12-26 10:28:33.86	15000000	2025-12-30 04:54:46.73569	\N
656	CASE1766988143114	AGS IMPEX INDIA PVT.LTD	GAJINDHER SINGH	Telecaller	Meeting Done	31	OD	\N	\N	Documentation	\N	2025-12-30 09:03:01.867614				SRILATHA	2025-12-30	11:00	8008095123	25-50cr	https://maps.app.goo.gl/YMuUtMz41feg6YtA9	\N	2025-12-29 06:02:26.416	2025-12-29 06:02:26.416	1000000	2025-12-30 09:03:01.867614	\N
662	CASE1767087723662	VEEJAY POLY PLAST	MAHESH PITTI	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2025-12-30 09:42:04.154121				\N	2025-12-31	03:00	9849032885	100+ cr	KATTEDAN	\N	2025-12-30 09:42:04.116	2025-12-30 09:42:04.116	\N	2025-12-30 09:42:04.154121	\N
663	CASE1767087968707	Smartgen Infra Private Limited	Ravindra Reddy 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2025-12-30 09:47:56.127131				Srilatha	2025-12-31	14:00	9963472111	50-100cr	Hyderabad	\N	2025-12-30 09:46:10.432	2025-12-30 09:46:10.432	\N	2025-12-30 09:46:10.464464	\N
681	CASE1767343930542	M/S.BUDDING LEAF INFRATECH PVT LTD	THOTA PRASAD	Telecaller	Meeting Done	33	BL	\N	\N	Documentation	\N	2026-01-07 04:57:26.293537				IRFAN	2026-12-05	11:30	9866812277	5-25cr	HYDERABAD	\N	2026-01-02 08:52:13.05	2026-01-02 08:52:13.05	15000000	2026-01-07 04:57:26.293537	2026-01-07
675	CASE1767331552281	Akshara Polymers	VIKRAM MYADAM	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2026-01-02 05:25:53.336797					2026-01-03	10:30	9885185581	50-100cr	hyderabad	\N	2026-01-02 05:25:53.335	2026-01-02 05:25:53.335	\N	2026-01-02 05:25:53.336797	\N
667	CASE1767163774422	VIPANY FINANCE	SANDEEP	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2025-12-31 08:33:16.03847					2025-12-31	11:30	8341137693	25-50cr	HYDERABAD	\N	2025-12-31 06:49:35.173	2025-12-31 06:49:35.173	\N	2025-12-31 08:33:16.03847	\N
666	CASE1767163083911	Bhaskara Traders	Srinivas Thatikonda	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2025-12-31 09:07:52.321529				Monika	2025-12-31	12:00	9866182611	25-50cr	Karimnagar	\N	2025-12-31 06:38:05.628	2025-12-31 06:38:05.628	\N	2025-12-31 09:07:52.321529	\N
670	CASE1767177477882	JMD Steel Corporation 	Abhii Galeti 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-05 11:48:29.236891				Prema	2026-01-01	12:00	9985831677	25-50cr	Hyderabad	\N	2025-12-31 10:37:59.194	2025-12-31 10:37:59.194	\N	2026-01-05 11:48:29.236891	\N
674	CASE1767331550849	Shaikchand and Co 	Mohammad Arfath	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2026-01-02 05:26:58.745319				Srilatha	2026-01-03	12:00	9701836786	25-50cr	Hyderabad	\N	2026-01-02 05:25:52.15	2026-01-02 05:25:52.15	\N	2026-01-02 05:25:52.18997	\N
678	CASE1767337052202	Mana Pharma Private Limited	Manisha 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-06 04:27:36.913136				Srilatha	2026-01-05	14:00	9030196611	25-50cr	Hyderabad	\N	2026-01-02 06:57:33.711	2026-01-02 06:57:33.711	\N	2026-01-06 04:27:36.913136	\N
661	CASE1767077662539	ETICO LIFESCIENCES PRIVATE LIMITED	Venkat rao	Telecaller	Meeting Done	30	NCD,PRIVATE EQUITY,STOCKS,MUTUAL FUND	\N	\N	Documentation	\N	2026-01-02 04:54:46.096115				Nitheesh sir	2025-12-31	11:00	9100999610	5-25cr	https://maps.app.goo.gl/8wBxz75A93DhYMhd7?g_st=iwb	\N	2025-12-30 06:54:22.558	2025-12-30 06:54:22.558	200000000	2026-01-02 04:54:46.096115	2026-01-02
649	CASE1766730842551	HAMTEK INFRA PROJECTS INDIA PRIVATE LIMITED	Srinivasa rao	Telecaller	Meeting Done	30	SME	\N	\N	Documentation	\N	2026-01-02 04:57:46.831454	Ramalingam sethu		7680888820	Srilatha	2025-12-29	11:00	7569958810	100+ cr	https://maps.app.goo.gl/iM8cvxfevMYAjCba6	\N	2025-12-26 06:34:01.173	2025-12-26 06:34:01.173	50000000	2026-01-02 04:57:46.831454	2026-01-02
668	CASE1767165539198	VIJAYAVANI LTD	VENUGOPAL	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2026-01-02 05:04:54.387129				SRILATHA	2026-01-02	11:00	9848005020	5-25cr	https://maps.app.goo.gl/AMWdzEfDRzv1knDR9	\N	2025-12-31 07:19:02.628	2025-12-31 07:19:02.628	\N	2026-01-02 05:04:54.387129	\N
671	CASE1767179852377	sri ballabh nathmal bang	Govid prasad	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-02 06:00:50.399631				Srilatha	2026-01-02	15:00	9440048251	50-100cr		\N	2025-12-31 11:17:34.649	2025-12-31 11:17:34.649	\N	2025-12-31 11:17:34.695065	\N
677	CASE1767335407691	UNIQUE AVENUES PVT.LTD	SATHEESH KUMAR	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-02 06:30:10.745651				SRILATHA	2026-01-05	09:30	9848237177	5-25cr	https://maps.app.goo.gl/MxX8hCJiRtJRTQXV7	\N	2026-01-02 06:30:10.706	2026-01-02 06:30:10.706	\N	2026-01-02 06:30:10.745651	\N
664	CASE1767088588360	ADEPTUS SERVO MECHATRONICS PVT.LTD	MURALIDHAR	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-06 07:14:51.735461				SRILATHA	2025-12-31	11:00	9848112176	5-25cr	https://maps.app.goo.gl/TEmrSCvHe534m1um8?g_st=aw	\N	2025-12-30 09:56:30.006	2025-12-30 09:56:30.006	\N	2025-12-30 09:56:30.042397	\N
679	CASE1767338345580	M/S TATA LOCKHEED MARTIN AREO STRUCTURES LTD	HARISH REDDY 	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2026-01-02 07:19:07.529167				SRILATHA	2026-01-05	11:00	8142566866	100+ cr	ADIBATLA	\N	2026-01-02 07:19:07.49	2026-01-02 07:19:07.49	\N	2026-01-02 07:19:07.529167	\N
655	CASE1766747403449	Suguna TMT	Ravi	Telecaller	Meeting Done	1	Bill discoutning	\N	\N	Documentation	\N	2026-01-02 07:34:38.757819				\N	2025-12-24	15:00	8977164372	100+ cr		\N	2025-12-26 11:10:03.913	2025-12-26 11:10:03.913	100000000	2026-01-02 07:34:38.757819	2026-01-02
680	CASE1767341860182	Sukhdevraj Sharma Engineers & Contractors	Naresh Kumar	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2026-01-02 08:17:40.506743					2026-01-05	12:30	9391362686	90crs	hyderabad	\N	2026-01-02 08:17:40.476	2026-01-02 08:17:40.476	\N	2026-01-02 08:17:40.506743	\N
682	CASE1767344756304	ENVIRO INFRAPROJECT PRIVATE LIMITED	Sai kiran	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-02 09:05:55.226804				Srilatha	2026-01-05	11:00	8143348108	50-100cr	Narsingh	\N	2026-01-02 09:05:55.196	2026-01-02 09:05:55.196	\N	2026-01-02 09:05:55.226804	\N
683	CASE1767348297611	M/S SRI BHAGWATHI DRUGS	Rohith agarwal	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-02 10:04:59.840873				Prema	2026-01-05	10:30	9247177766	5-25cr		\N	2026-01-02 10:04:59.798	2026-01-02 10:04:59.798	\N	2026-01-02 10:04:59.840873	\N
684	CASE1767349903214	M/S SRI BHAGWATHI DRUGS	Rohith agarwal	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-02 10:31:45.3057				Prema	2026-01-05	10:30	9247177766	5-25cr		\N	2026-01-02 10:31:45.267	2026-01-02 10:31:45.267	\N	2026-01-02 10:31:45.3057	\N
657	CASE1766988598289	Risinia Builders	G Ravi Kumar	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-02 11:30:10.53194				Srilatha	2025-12-30	14:30	9052231117	25-50cr	Hyderabad	\N	2025-12-29 06:09:59.624	2025-12-29 06:09:59.624	\N	2026-01-02 11:30:10.53194	\N
687	CASE1767591651178	m/s krushi infras india pvt ltd	Shiva koteshwara rao	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-05 05:40:52.891987				Srilatha	2026-01-05	14:00	7673920180	100+ cr	https://maps.app.goo.gl/r5DZhPP4zBc8bw9P6	\N	2026-01-05 05:40:52.854	2026-01-05 05:40:52.854	\N	2026-01-05 05:40:52.891987	\N
702	CASE1767679468216	INCEDO TECHNOLOGY SOLUTIONS LIMITED	AVINASH DUDEJA	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2026-01-06 06:10:23.915571				SRILATHA	2025-01-06	11:30	9711221960	100+ cr	GOURGAON	\N	2026-01-06 06:04:29.128	2026-01-06 06:04:29.128	\N	2026-01-06 06:04:29.159139	\N
686	CASE1767590002853	E to e transportation infrastructure limited	Chaithanya	Telecaller	Meeting Done	30	BL	\N	\N	Documentation	\N	2026-01-06 12:43:45.931033				Srilatha	2026-01-06	15:30	9480887052	100+ cr	Bengaluru	\N	2026-01-05 05:13:25.084	2026-01-05 05:13:25.084	100000000	2026-01-06 12:43:45.931033	2026-01-06
701	CASE1767675073745	VULCAN SOLAR	VAMSHI	Telecaller	No Requirement	31	\N	\N	\N	Documentation	\N	2026-01-06 12:42:41.416392				SRILATHA	2026-01-06	11:30	9030033425	5-25cr	https://maps.app.goo.gl/SVzeSwnLmCjH6CzCA	\N	2026-01-06 04:51:17.082	2026-01-06 04:51:17.082	\N	2026-01-06 12:42:41.416392	\N
685	CASE1767355224663	ROCKERIA ENGINEERING PVT.LTD	JAVEEDH	Telecaller	Meeting Done	31	BILL DISCOUNTING,UNSECURED FUNDING	\N	\N	Documentation	\N	2026-01-05 12:29:36.357418				SRILATHA	2026-01-05	12:00	9866201040	25-50cr	https://maps.app.goo.gl/hfDM2qTrUhivLgyb8	\N	2026-01-02 12:00:26.881	2026-01-02 12:00:26.881	100000000	2026-01-05 12:29:36.357418	2026-01-05
694	CASE1767597155155	pess protection force private limited	Madhu Sharanya	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2026-01-05 07:12:36.305809					2026-01-05	15:00	9849027286	50-100cr	hyderabad	\N	2026-01-05 07:12:36.269	2026-01-05 07:12:36.269	\N	2026-01-05 07:12:36.305809	\N
696	CASE1767607175381	UNITEL ENTERPRISE PVT.LTD	BALAJI	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-05 09:59:38.019787				SRILATHA	2026-01-06	11:00	8977720099	5-25cr	HYDERABAD	\N	2026-01-05 09:59:37.984	2026-01-05 09:59:37.984	\N	2026-01-05 09:59:38.019787	\N
695	CASE1767601998038	Sri sreenivasa infra	Eshwar	Telecaller	Meeting Done	30	Construction Finance	\N	\N	Documentation	\N	2026-01-06 12:43:09.16723	Ramesh		9701606333	Srilatha	2026-01-06	11:00	 9052995523	50-100cr	https://maps.app.goo.gl/oNbVxobBUBPijrgS8	\N	2026-01-05 08:33:20.353	2026-01-05 08:33:20.353	1000000000	2026-01-06 12:43:09.16723	2026-01-06
698	CASE1767610395573	Csr Developers	Sudhakar reddy	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2026-01-05 10:53:16.746607					2026-01-06	11:00	9848012210	50-100cr	hyderabad. madhapur	\N	2026-01-05 10:53:16.709	2026-01-05 10:53:16.709	\N	2026-01-05 10:53:16.746607	\N
700	CASE1767613865308	OSK PRECISION MACHINERY PVT.LTD	SRIKANTH	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-05 11:51:08.475023				SRILATHA	2026-01-06	17:30	8008077755	5-25cr	HYDERABAD	\N	2026-01-05 11:51:08.441	2026-01-05 11:51:08.441	\N	2026-01-05 11:51:08.475023	\N
676	CASE1767333621957	Vasantha rice industries	-	Telecaller	No Requirement	30	\N	\N	\N	Documentation	\N	2026-01-05 12:30:08.439349				Srilatha	2026-01-03	14:00	7032703555	100+ cr	https://maps.app.goo.gl/N2vjaKDZspL6GA1n7	\N	2026-01-02 06:00:24.091	2026-01-02 06:00:24.091	\N	2026-01-05 12:30:08.439349	\N
704	CASE1767680648362	NADEEMS HEALTH VAULT PRIVATE LIMITED	NADEEMUDDIN SYED	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-06 06:24:12.031712				SRILATHA	2026-01-07	10:30	9849345798	5-25cr	https://maps.app.goo.gl/F74KTt5U6bMumsho8	\N	2026-01-06 06:24:11.993	2026-01-06 06:24:11.993	\N	2026-01-06 06:24:12.031712	\N
690	CASE1767593762406	M/S SOLAR BULL ENERGY LLP	SRINIVAS	Telecaller	Meeting Done	33	UNSECURED & SECURED OD	\N	\N	Documentation	\N	2026-01-05 12:04:40.736593				IRFAN	2026-01-05	12:30	9618074400	5-25cr	FILMNAGAR	\N	2026-01-05 06:16:02.555	2026-01-05 06:16:02.555	150000000	2026-01-05 12:04:40.736593	2026-01-05
705	CASE1767682841450	Splendid Metal Product Limited	B Y Raju 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2026-01-06 07:01:54.543267				Srilatha	2026-01-07	11:00	8008512828	5-25cr	Hyderabad	\N	2026-01-06 07:00:43.242	2026-01-06 07:00:43.242	\N	2026-01-06 07:00:43.280174	\N
699	CASE1767612203387	Shri Raghavendra Constructions Developers 	Janardhan Reddy	Telecaller	Meeting Done	29	Real Estate Assest. Management Company	\N	\N	Documentation	\N	2026-01-06 04:29:27.509746				Nikita 	2026-01-05	05:00	9399924519	100+ cr	Hyderabad	\N	2026-01-05 11:23:24.658	2026-01-05 11:23:24.658	3	2026-01-06 04:29:27.509746	2026-01-06
703	CASE1767679706045	M/s srico projects pvt limited	Srinivasa rao	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-06 06:08:27.927269				Srilatha	2026-01-07	11:30	9849026294	100+ cr	https://maps.app.goo.gl/HSgyiCmcvL1WAZGp7	\N	2026-01-06 06:08:27.897	2026-01-06 06:08:27.897	\N	2026-01-06 06:08:27.927269	\N
706	CASE1767684274406	YVR PROJECTS	NITIN	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2026-01-06 07:26:48.246123				NIKITA MAM	2026-12-07	11:30	9666682009	5-25cr	SHAIKPET	\N	2026-01-06 07:24:36.307	2026-01-06 07:24:36.307	\N	2026-01-06 07:24:36.338572	\N
693	CASE1767595807476	M/S.UNISCAN POWER SYSTEMS	ASHOK	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2026-01-07 08:23:41.826558				MOUNIKA	2026-01-06	10:30	9396974949		HYDERABAD	\N	2026-01-05 06:50:08.494	2026-01-05 06:50:08.494	\N	2026-01-07 08:23:41.826558	\N
708	CASE1767689524137	DIVIS INFRA DEVELOPERS	SREEKANTH	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-06 08:52:08.006061				SRILATHA	2026-01-07	11:00	9901243331	5-25cr	HYDERABAD	\N	2026-01-06 08:52:07.971	2026-01-06 08:52:07.971	\N	2026-01-06 08:52:08.006061	\N
709	CASE1767690557871	Ki agribusiness private limited	Sriram balakrishnan	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-06 09:09:19.29077				Srilatha	2026-01-07	14:00	8886171712	100+ cr		\N	2026-01-06 09:09:19.253	2026-01-06 09:09:19.253	\N	2026-01-06 09:09:19.29077	\N
688	CASE1767593152349	Driplex Water Engineering Private Limited	Manoranjan Rath 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-06 09:33:17.079254				Srilatha	2026-01-06	14:00	9350522869	50-100cr	Gurgoan	\N	2026-01-05 06:05:53.707	2026-01-05 06:05:53.707	\N	2026-01-06 09:33:17.079254	\N
711	CASE1767692365690	Navitej Infrastructure Private Limited	Pavan	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2026-01-06 09:39:26.808635				Nikita	2026-01-07	11:00	9652744966	70crs	Hyderabad	\N	2026-01-06 09:39:26.779	2026-01-06 09:39:26.779	\N	2026-01-06 09:39:26.808635	\N
713	CASE1767693823173	M Lakshmikantha	M Lakshmikantha	Telecaller	Open	29	\N	\N	\N	Documentation	\N	2026-01-06 10:03:44.356705				Nikita	2026-01-06	16:30	9849150141	15crs	Hyderabad	\N	2026-01-06 10:03:44.324	2026-01-06 10:03:44.324	\N	2026-01-06 10:03:44.356705	\N
691	CASE1767593949748	KARTHIKEYAN NIRMANS AND CRUSHERS PRIVATE LIMITED	Murthy	Telecaller	Meeting Done	30	Construction Finance	\N	\N	Documentation	\N	2026-01-06 12:43:29.035769				Srilatha	2026-01-06	16:00	9849056529	50-100cr	https://maps.app.goo.gl/sUuiSfj8tGw5SnEc6	\N	2026-01-05 06:19:11.069	2026-01-05 06:19:11.069	1500000000	2026-01-06 12:43:29.035769	2026-01-06
724	CASE1767780407690	SSV Spinners Private Limited	Ratna Nakka 	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-07 10:21:31.329653				Monika	2026-01-07	14:30	9110793994	100+ cr	Hyderabad	\N	2026-01-07 10:06:49.402	2026-01-07 10:06:49.402	\N	2026-01-07 10:21:31.329653	\N
697	CASE1767609628698	SAMRAJ INDUSTRIES	PRASAD	Telecaller	Meeting Done	33	BL	\N	\N	Documentation	\N	2026-01-06 10:08:21.21065				PREMA	2026-01-06	11:00	8977749791	5-25cr	MOULALI	\N	2026-01-05 10:40:29.747	2026-01-05 10:40:29.747	15000000	2026-01-06 10:08:21.21065	2026-01-06
731	CASE1767870273043	SRI LAKSHMI KARTHIKEYA INFRA PVT LTD	SUNIL KUMAR	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2026-01-08 11:05:47.548949				IRFAN	2026-01-09	11:30	9059234969		HYD	\N	2026-01-08 11:04:34.601	2026-01-08 11:04:34.601	\N	2026-01-08 11:04:34.63906	\N
692	CASE1767594702214	Gilbarco Veeder Root India Private Limited	ShaktiVelan	Telecaller	Meeting Done	32	OD	\N	\N	Documentation	\N	2026-01-06 11:05:16.384718				Srilatha	2026-01-06	11:00	9865599555	100+ cr	Chennai 	\N	2026-01-05 06:31:43.608	2026-01-05 06:31:43.608	10000000	2026-01-06 11:05:16.384718	2026-01-06
721	CASE1767767426172	ELITE ENGENEERING AND CONSTRUCTION PVT LTD	MOHAN	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2026-01-08 12:18:46.064116				NIKITHA MAM	2026-01-08	11:00	9908645801	100+ cr	GACHIBOWLI	\N	2026-01-07 06:30:27.439	2026-01-07 06:30:27.439	\N	2026-01-08 12:18:46.064116	\N
715	CASE1767697827356	Malaxmi Projects Pvt Ltd	Sandeep Madhava	Telecaller	Meeting Done	29	Real Estate Assest. Management Company	\N	\N	Documentation	\N	2026-01-07 04:58:37.977852				Nikita	2026-01-06	17:00	9985808888	20Crs	Hyderabad Gachibowli	\N	2026-01-06 11:10:28.425	2026-01-06 11:10:28.425	40	2026-01-07 04:58:12.335552	2026-01-07
717	CASE1767764174464	Sunil chandra builders	Sunil	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-07 05:36:13.958686				Nikhitha mam	2026-01-08	11:30	9246531624	25-50cr		\N	2026-01-07 05:36:13.926	2026-01-07 05:36:13.926	\N	2026-01-07 05:36:13.958686	\N
719	CASE1767765524344	Unique india constructions private limited	Murthy teegela	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-07 05:58:44.613833				Srilatha	2026-01-08	14:00	7382473027	100+ cr	Ranigunj secunderabad	\N	2026-01-07 05:58:44.584	2026-01-07 05:58:44.584	\N	2026-01-07 05:58:44.613833	\N
720	CASE1767766580242	Overseas Health Care Private Limited	Nirmala	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2026-01-07 06:17:28.328203				Srilatha	2026-01-08	11:00	9390198771	100+ cr	Hyderabad	\N	2026-01-07 06:16:21.419	2026-01-07 06:16:21.419	\N	2026-01-07 06:16:21.458583	\N
732	CASE1767938577183	Devi Beverages	Ravikanth Kasala 	Telecaller	Open	32	\N	\N	\N	Documentation	\N	2026-01-09 06:04:11.468192				Srilatha	2026-01-12	12:00	9030034342	25-50cr	Hyderabad	\N	2026-01-09 06:02:58.153	2026-01-09 06:02:58.153	\N	2026-01-09 06:02:58.203094	\N
726	CASE1767849871347	BONDIT CONSTRUCTION CHEMICALS PRIVATE LIMITED	Rajendar reddy	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-08 05:24:34.705691	Ramohan		9848051034	Prema	2026-01-09	11:00	9848380005	5-25cr	https://maps.app.goo.gl/wEDLchBDKZ4BJ3YF7	\N	2026-01-08 05:24:34.675	2026-01-08 05:24:34.675	\N	2026-01-08 05:24:34.705691	\N
723	CASE1767777447471	VASU SRI INFRA PROJECTS	KIRAN	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-07 09:17:29.22605				SRILATHA	2026-01-08	12:30	9703393939	5-25cr	HYDERABAD	\N	2026-01-07 09:17:29.188	2026-01-07 09:17:29.188	\N	2026-01-07 09:17:29.22605	\N
707	CASE1767689044969	SATYASAI INFRASTRUCTURE PVT LTD	SATYAMURTHY	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2026-01-10 15:12:39.836744				NIKITHA MAM	2025-12-06	03:00	9676275763	25-50cr	SOMAJIGUDA	\N	2026-01-06 08:44:06.447	2026-01-06 08:44:06.447	\N	2026-01-10 15:12:39.836744	\N
714	CASE1767696138044	Sunkari Sathyanarayana Goud	sathayanarayana	Telecaller	Meeting Scheduled	29	\N	\N	\N	Documentation	\N	2026-01-10 15:16:14.904943				Nikita	2026-01-07	10:00	9951719972	5-25cr	hyderabad	\N	2026-01-06 10:42:19.184	2026-01-06 10:42:19.184	\N	2026-01-10 15:16:14.904943	\N
712	CASE1767692739556	Engineering Projects Limited	R M	Telecaller	Meeting Done	29	\N	\N	\N	Documentation	\N	2026-01-10 15:21:04.892567				Nikita	2026-01-07	13:00	9490363647	500crs	hyderabad	\N	2026-01-06 09:45:40.597	2026-01-06 09:45:40.597	\N	2026-01-10 15:21:04.892567	2026-01-10
710	CASE1767692309351	SKANDAYA INFRASTUCTURES	ABINASH REDDY	Telecaller	Meeting Done	33	Real Estate Assest. Management Company	\N	\N	Documentation	\N	2026-01-07 09:28:21.059557				NIKITHA MAM	2026-01-07	00:30	9347776267	5-25cr	SECBAD	\N	2026-01-06 09:38:30.839	2026-01-06 09:38:30.839	70	2026-01-07 09:28:21.059557	2026-01-07
733	CASE1767950089584	Sivanssh infrastructure development private limited	Adhi narayana	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-09 09:14:52.298588				Srilatha	2026-01-12	12:30	9391013575	100+ cr		\N	2026-01-09 09:14:52.259	2026-01-09 09:14:52.259	\N	2026-01-09 09:14:52.298588	\N
727	CASE1767851581547	B NEW MOBLIES PVT.LTD	PRASANTH	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-08 06:25:22.116723				NITHEESH	2026-01-09	17:00	7337338024	100+ cr	https://maps.app.goo.gl/12Bkhb7mXNvGFPndA	\N	2026-01-08 05:53:04.608	2026-01-08 05:53:04.608	\N	2026-01-08 05:53:04.640899	\N
728	CASE1767853363206	MARUTHI CORPORATION LIMITED	RAMREDDY	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-08 07:26:24.892168				SRILATHA	2026-01-09	11:00	9490799259	25-50cr	https://maps.app.goo.gl/3t1cuUrKWoGaVeZu9	\N	2026-01-08 06:22:45.688	2026-01-08 06:22:45.688	\N	2026-01-08 06:22:45.718598	\N
730	CASE1767863067753	Value Health Technologies Private Limited	Samba shiva rao	Telecaller	Open	30	\N	\N	\N	Documentation	\N	2026-01-08 09:04:32.760962				Srilatha	2026-01-09	17:00	8885513366	50-100cr	Manikonda	\N	2026-01-08 09:04:32.721	2026-01-08 09:04:32.721	\N	2026-01-08 09:04:32.760962	\N
718	CASE1767765282525	VIJETHA SOLAR MARKETING SERVICES	RAO	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2026-01-08 10:13:02.933867				IRFAN	2026-01-08	11:00	9908907147	5-25cr	VIJAYWADA	\N	2026-01-07 05:54:42.835	2026-01-07 05:54:42.835	\N	2026-01-08 10:13:02.933867	\N
725	CASE1767783712290	Sai Srinivasa Parboiled Modern Rice Mill	Lakshmi Narasimha Rao Poilishetty	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-08 10:13:08.760389				Monika	2026-01-08	11:30	9949352633	5-25cr	Hyderabad	\N	2026-01-07 11:01:54.501	2026-01-07 11:01:54.501	\N	2026-01-08 10:13:08.760389	\N
734	CASE1767950333036	VAYHAN COFFEE LIMITED	AJAY KUMAR	Telecaller	Open	31	\N	\N	\N	Documentation	\N	2026-01-09 09:18:55.919686				SRILATHA	2026-01-12	11:30	9963938444	100+ cr	https://goo.gl/maps/vgyRoz4Rb3KDgySk7?g_st=aw	\N	2026-01-09 09:18:55.889	2026-01-09 09:18:55.889	\N	2026-01-09 09:18:55.919686	\N
729	CASE1767854708605	Mahalaxmi Infracontract Limited	Prahallabhai Parekh	Telecaller	No Requirement	32	\N	\N	\N	Documentation	\N	2026-01-09 11:41:31.879917				Srilatha	2026-01-09	11:30	9924494591	100+ cr	Ahmedabad	\N	2026-01-08 06:45:10.263	2026-01-08 06:45:10.263	\N	2026-01-09 11:41:31.879917	\N
735	CASE1767954139374	VIHAN SOLAR PVT LTD	PRAVEEN	Telecaller	Open	33	\N	\N	\N	Documentation	\N	2026-01-09 13:02:43.064646				IRFAN	2026-01-12	11:30	9642979741	25-50cr	BADANGPET	\N	2026-01-09 10:22:20.647	2026-01-09 10:22:20.647	\N	2026-01-09 10:22:20.686374	\N
722	CASE1767776191203	SAIRAM HARIJANA CONTRACT COOPERATIVE SOICIETY LTD	BHASKHAR	Telecaller	No Requirement	33	\N	\N	\N	Documentation	\N	2026-01-10 05:23:35.178647				NIKITHA	2026-12-07	16:30	9963272867	1-5cr	KOTHAGUDEM	\N	2026-01-07 08:56:32.468	2026-01-07 08:56:32.468	\N	2026-01-10 05:23:35.178647	\N
716	CASE1767702881195	Arathi Engineering Coach Builders	Rama Mohan	Telecaller	Meeting Done	29	Machinery funding upto 7cr	\N	\N	Documentation	\N	2026-01-23 13:39:35.500419	Rama Mohan	aarathi@engineering.com	8562856285	Nikita	2026-01-07	10:30	9866124486	1-5cr	Hyderabad	\N	2026-01-06 12:34:42.291	2026-01-06 12:34:42.291	100001	2026-01-23 13:39:35.500419	2026-01-23
689	CASE1767593432693	dachepalli publishers limited	Vinod Kumar	Telecaller	Meeting Scheduled	29	\N	\N	\N	Documentation	\N	2026-01-10 15:15:56.850007					2026-01-06	11:00	9866041234	65crs	hyderabad	\N	2026-01-05 06:10:32.972	2026-01-05 06:10:32.972	\N	2026-01-10 15:15:56.850007	\N
643	CASE1766482276572	M/s Bhavani Marketing	Dheeraj Agarwal 	Telecaller	Login	32	\N	\N	\N	Documentation	\N	2026-01-23 15:50:07.646819				Monika	2025-12-24	12:30	9989833336	5-25cr	Hyderabad	\N	2025-12-23 09:31:28.534	2025-12-23 09:31:28.534	\N	2026-01-23 15:50:07.646819	\N
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, caseid, comment, role, created_at, commentby) FROM stdin;
1	CASE1761904567946	LAP Requirenment,Client will share docs by 10th of Oct	Unknown	2025-10-31 09:57:35.890989	\N
2	CASE1761904567946	Client will share docs by 10th of oct LAP Requirenment	Telecaller	2025-10-31 09:58:23.485828	Nikitha
3	CASE1761904567946	Client will share docs by 10th of oct LAP Requirenment	Telecaller	2025-10-31 09:58:24.018901	Nikitha
4	CASE1761904567946	xyz	Telecaller	2025-10-31 10:11:20.097713	Nikitha
5	CASE1761904567946	ABC	Telecaller	2025-10-31 10:11:31.312187	Nikitha
6	CASE1761904567946	ABC	Telecaller	2025-10-31 10:11:31.51836	Nikitha
7	CASE1761990784698	 Call before going	Unknown	2025-11-01 09:54:01.370217	\N
8	CASE1762145698483	Rescheduled	Telecaller	2025-11-03 04:57:50.407141	Marie
9	CASE1762145457677	Rescheduled	Telecaller	2025-11-03 04:58:14.249282	Marie
10	CASE1761977530872	rescheduled	Telecaller	2025-11-04 06:06:40.120916	Srilakshmi U
11	CASE1761990784698	Meeting  reschedule nov12th	Telecaller	2025-11-04 06:06:57.617503	Gouthami S
12	CASE1762410652316	Google meet	Telecaller	2025-11-06 07:16:52.022011	Gouthami S
13	CASE1762588856050	On call	Telecaller	2025-11-10 04:44:06.173136	Marie
14	CASE1763187103363	On call meeting	Telecaller	2025-11-15 06:12:57.848373	Marie
15	CASE1764052492961	Test	KAM	2025-11-25 09:19:50.186284	Chandrasekhar D
16	CASE1762166837309	test	KAM	2025-11-25 09:37:25.63734	Chandrasekhar D
17	CASE1763973948471	No Requirement	KAM	2025-11-26 12:03:55.683136	Fayaz H
18	CASE1764235668458	on call	Telecaller	2025-11-27 09:28:13.384565	Marie
19	CASE1763542082443	Newly Assign	KAM	2025-11-29 04:59:19.012478	Irfan M
20	CASE1763708523280	Updated	KAM	2025-11-29 05:49:41.505518	Fayaz H
21	CASE1764322859980	Updated	KAM	2025-11-29 06:19:52.43038	Irfan M
22	CASE1763542475926	Updated	KAM	2025-11-29 06:20:46.864546	Fayaz H
23	CASE1764147995254	Updated	KAM	2025-11-29 06:21:30.020753	Irfan M
24	CASE1764140926286	Updated	KAM	2025-11-29 06:23:18.000719	Irfan M
25	CASE1764398029125	Client has not lifted call need to arrange fresh meeting	KAM	2025-11-29 06:58:10.517658	Chandrasekhar D
26	CASE1764398908649	Meeting done - requirement is for vedhadri developers	KAM	2025-11-29 07:20:43.939277	Chandrasekhar D
27	CASE1763717344445	project funding	KAM	2025-11-29 12:05:38.251792	Nitheesh
28	CASE1763704870223	Shared product details to client	KAM	2025-11-29 12:06:10.153556	Nitheesh
29	CASE1763618459035	no requirement	KAM	2025-11-29 12:06:26.909736	Nitheesh
30	CASE1762249044960	no requirement	KAM	2025-11-29 12:08:59.335701	Nitheesh
31	CASE1764419924041	50crs unsecured BL	Admin	2025-11-29 12:39:17.134472	Nikitha
32	CASE1764565490802	Requirment after 2-3 months. To follow up in Feb-26	KAM	2025-12-01 06:13:19.776697	Chandrasekhar D
33	CASE1764924175994	Edited	KAM	2025-12-08 11:08:32.002309	Fayaz H
34	CASE1765285368534	Updated	KAM	2025-12-10 11:03:45.165843	Fayaz H
35	CASE1765781122565	Updated	KAM	2025-12-15 11:55:52.918243	Fayaz H
36	CASE1765871860313	Looking for Unsecured Funding	Telecaller	2025-12-16 08:04:05.336176	Nikitha
37	CASE1765888796146	Will discuss tommorow	Telecaller	2025-12-16 12:43:41.733276	Nikitha
38	CASE1765966770731	meeting rescheduled	Telecaller	2025-12-18 07:18:53.324404	Srilakshmi U
39	CASE1765798393919	Fayaz sir	KAM	2025-12-18 11:42:27.159145	Irfan M
40	CASE1765798393919	Sir	KAM	2025-12-18 11:43:01.292467	Irfan M
41	CASE1767776191203	time	KAM	2026-01-07 09:23:33.12145	Fayaz H
42	CASE1767954139374	Date Updated	KAM	2026-01-09 11:52:32.536636	Irfan M
43	CASE1767702881195	Comment One	Unknown	2026-01-21 05:49:19.912028	\N
44	CASE1767702881195	comment 2	Unknown	2026-01-23 13:38:53.740615	\N
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, caseid, doctype, filename, uploadedat, docname) FROM stdin;
3	CASE1762753606380	partA	1762755880862_TLL_BALANCE_SHEET(2024-25)_(1)_(1).pdf	2025-11-10 06:24:42.609387	Latest year provisionals
5	CASE1762753606380	partA	1762755903961_TLL_Balance_Sheet_21-22_(5).pdf	2025-11-10 06:25:06.574443	Debt sheet
6	CASE1762753606380	partA	1762755872773_TLL_Balance_Sheet_21-22_(5).pdf	2025-11-10 06:25:10.000374	Last 3 years financials Along with ITR’s
8	CASE1762753606380	partA	1762755914551_TEENA_LABS_BALANCE_SHEET_2022-23.pdf	2025-11-10 06:25:44.354687	Work order - if applicable
9	CASE1762753606380	partA	1762755948753_TLL_BALANCE_SHEET(2024-25)_(1)_(1).pdf	2025-11-10 06:25:50.495092	Company profile
11	CASE1762753606380	partA	1762755971970_29-08-25,_819â¯PM_Microsoft_Lens.pdf	2025-11-10 06:27:14.503256	Sanction Letters
19	CASE1763973948471	partA	1764054137489_ITR-_ACKNOWLEDGEMENT-24-25.pdf	2025-11-25 07:02:18.151146	Last 3 years financials Along with ITR's
20	CASE1763973948471	partA	1764054144510_ITR-_ACKNOWLEDGEMENT-24-25.pdf	2025-11-25 07:02:25.079367	Debt sheet
21	CASE1763973948471	partA	1764054153243_ITR-23-24.pdf	2025-11-25 07:02:43.790433	Latest year provisionals
22	CASE1763973948471	partA	1764054166169_Udyam_Registration_Certificate_(3).pdf	2025-11-25 07:02:46.174141	Work order - if applicable
23	CASE1763973948471	partA	1764054170912_MSME_(1).pdf	2025-11-25 07:02:51.196776	Company profile
24	CASE1763973948471	partA	1764054177618_company_profie.pdf	2025-11-25 07:03:00.867948	Sanction Letters
25	CASE1763973948471	partB	1764054185321_LIST_OF_DIRECTORS-1_(1).pdf	2025-11-25 07:03:05.390115	Company and promoters KYC
26	CASE1763973948471	partB	1764054189520_MSME_(1).pdf	2025-11-25 07:03:09.538224	Collateral full set
54	CASE1763973948471	onePager	1764054956743_MYRWOT_Akshara_co..pdf	2025-11-25 07:15:57.19763	OnePager
62	CASE1761910111749	partA	1764312515500_FINANCIALS.zip	2025-11-28 06:49:07.101798	Last 3 years financials Along with ITR's
63	CASE1761910111749	partA	1764312561662_COMPANY_KYC.zip	2025-11-28 06:49:23.869344	Company profile
64	CASE1761910111749	partA	1764312585749_TLL_BALANCE_SHEET(2024-25)_(1).pdf	2025-11-28 06:49:58.605055	Latest year provisionals
65	CASE1761910111749	partA	1764312625486_SANCTION_LETTERS.zip	2025-11-28 06:50:37.233644	Sanction Letters
66	CASE1761910111749	partB	1764312660619_PROPERTY.zip	2025-11-28 06:51:05.500668	Collateral full set
67	CASE1761910111749	partA	1764312949699_RWOT_LOAN_SHEET_FORMAT_(3)_(1).xlsx	2025-11-28 06:55:49.731988	Debt sheet
68	CASE1761910111749	partA	1764312955003_TLL@_(1).xlsx	2025-11-28 06:55:55.006867	Work order - if applicable
72	CASE1762834354822	partA	1764330440978_Debt_details_as_of_31st_Jul'25.xlsx	2025-11-28 11:47:21.70913	Debt sheet
73	CASE1762834354822	partA	1764330465137_SBI_Sanction_Letter_5cr.pdf	2025-11-28 11:47:50.820431	Sanction Letters
74	CASE1762834354822	partA	1764330928502_Ongoing_project_details_30th_Sep'25.xlsx	2025-11-28 11:55:30.274291	Work order - if applicable
75	CASE1762834354822	partA	1764331100743_Aakriti_Company_Profile.pdf	2025-11-28 11:58:35.889638	Company profile
76	CASE1762834354822	partA	1764331391506_FY_2021-2022.zip	2025-11-28 12:03:24.346591	Last 3 years financials Along with ITR's
77	CASE1762834354822	partA	1764331943363_ACDPL_ITR_FY2023-24.pdf	2025-11-28 12:12:38.989416	Latest year provisionals
79	CASE1762842917468	partA	1764386913394_RWOT_SINGHANIA_PRINTERS-2.pdf	2025-11-29 03:28:34.958857	Last 3 years financials Along with ITR's
80	CASE1762842917468	partA	1764386924201_RWOT_SINGHANIA_PRINTERS.pdf	2025-11-29 03:28:45.80441	Latest year provisionals
81	CASE1762842917468	partA	1764386933361_RWOT_SINGHANIA_PRINTERS-3.pdf	2025-11-29 03:28:54.895069	Debt sheet
82	CASE1762842917468	partA	1764386941750_RWOT_SINGHANIA_PRINTERS-3.pdf	2025-11-29 03:29:03.234549	Work order - if applicable
83	CASE1762842917468	partA	1764386950661_RWOT_SINGHANIA_PRINTERS-4.pdf	2025-11-29 03:29:12.08942	Company profile
84	CASE1762842917468	partA	1764386958041_RWOT_SINGHANIA_PRINTERS-4.pdf	2025-11-29 03:29:19.46368	Sanction Letters
85	CASE1762842917468	onePager	1764387025061_RWOT_SINGHANIA_PRINTERS-4.pdf	2025-11-29 03:30:26.569405	OnePager
86	CASE1762846378686	partA	1764400032169_Haneesh_constructions_BS_FY.2023-24_(Signed_copy).zip	2025-11-29 07:07:44.537589	Last 3 years financials Along with ITR's
87	CASE1762846378686	partA	1764400086948_Balance_sheet_FY_2024-25_signed_copy.zip	2025-11-29 07:09:09.551408	Latest year provisionals
88	CASE1763370566141	partA	1764400402920_Financial_&_ITR's.zip	2025-11-29 07:14:04.063705	Last 3 years financials Along with ITR's
89	CASE1763370566141	partA	1764400773758_Company_&_Directors_Profile.pdf	2025-11-29 07:19:36.325078	Company profile
90	CASE1763370566141	partA	1764401009272_Loan_Outstanding.xlsx	2025-11-29 07:23:29.542936	Debt sheet
91	CASE1763370566141	partA	1764401758799_SANCTION.zip	2025-11-29 07:36:03.554223	Sanction Letters
92	CASE1763370566141	partB	1764401773220_COMPANY_KYC'.zip	2025-11-29 07:36:15.747081	Company and promoters KYC
93	CASE1763370566141	partB	1764401804837_Bank_Statement.zip	2025-11-29 07:36:46.837853	Bank statements
94	CASE1763370566141	partB	1764401814822_GSTR3B_Challan.zip	2025-11-29 07:36:56.97019	GSTR3B
95	CASE1762249679995	partA	1764403243847_Spacenet_Standalone_Financials_FY-2023-24.pdf	2025-11-29 08:01:49.73017	Last 3 years financials Along with ITR's
96	CASE1762249679995	partA	1764403333200_Signed_financials_Standalone_2024-25_C.pdf	2025-11-29 08:02:20.936215	Latest year provisionals
97	CASE1762249679995	partA	1764403456710_Business_profile_of_SEIL.pdf	2025-11-29 08:04:20.676618	Company profile
98	CASE1762753606380	onePager	1764422960919_RWOT_SINGHANIA_PRINTERS-3.pdf	2025-11-29 13:29:22.281763	OnePager
100	CASE1764758733768	partA	1765191440947_Provisional_Spacenet_upto_Sep25.pdf	2025-12-08 10:57:26.408735	Latest year provisionals
101	CASE1764758733768	partA	1765191461521_Document_(2).zip	2025-12-08 11:01:06.837649	Last 3 years financials Along with ITR's
102	CASE1764758733768	partA	1765191979124_RWOT_SPACENET_ENTERPRISES_INDIA_LTD_(1)_(1).pdf	2025-12-08 11:06:20.695172	Debt sheet
103	CASE1764758733768	partA	1765191997636_RWOT_SPACENET_ENTERPRISES_INDIA_LTD_(1)_(1).pdf	2025-12-08 11:06:38.934638	Sanction Letters
104	CASE1764758733768	partA	1765192089855_Work_orders.pdf	2025-12-08 11:08:18.210425	Work order - if applicable
105	CASE1764758733768	partA	1765192139297_profile.pdf	2025-12-08 11:09:20.623325	Company profile
106	CASE1764573615748	partA	1765197210430_Financials_23-24.pdf	2025-12-08 12:36:04.657749	Last 3 years financials Along with ITR's
107	CASE1764573615748	partA	1765197393083_ITR_V_AY_2025-26_Inthes_Biotech(OPC)_Pvt_Ltd.pdf	2025-12-08 12:36:33.751735	Latest year provisionals
108	CASE1764573615748	partA	1765197439295_Inthes_Sanction_Letter.pdf	2025-12-08 12:38:53.424731	Sanction Letters
109	CASE1764420063211	partA	1765197698151_ABS_-_FY_2023_-_24_compressed.pdf	2025-12-08 12:42:47.319228	Last 3 years financials Along with ITR's
110	CASE1764420063211	partA	1765198375738_pbs_31.03.2025.pdf	2025-12-08 12:54:02.249202	Latest year provisionals
111	CASE1764420063211	partA	1765198511123_Company_and_promoters_Profile.docx	2025-12-08 12:55:20.775672	Company profile
112	CASE1764420063211	partA	1765198554143_Kotak_Sanction_letter_dt._19.8.2025_signed.pdf	2025-12-08 12:56:33.728191	Sanction Letters
113	CASE1764758265597	partA	1765351958918_IRP_ABS_2022-23_Final_compressed_(1).pdf	2025-12-10 07:34:22.016519	Last 3 years financials Along with ITR's
114	CASE1764758265597	partA	1765358919500_ABS_FY_2024-25_compressed.pdf	2025-12-10 09:29:51.150991	Latest year provisionals
115	CASE1764400962688	partA	1765358849533_HARSHINI_EPC.zip	2025-12-10 09:29:54.760081	Last 3 years financials Along with ITR's
116	CASE1764758265597	partA	1765359029625_Works_on_hand_as_on_31.10.25_(R1).pdf	2025-12-10 09:30:31.814742	Work order - if applicable
117	CASE1764758265597	partA	1765359047403_27.11.25_Brief_profile_of_the_Company_-_IRP.pdf.pdf	2025-12-10 09:30:49.190457	Company profile
118	CASE1764758265597	partA	1765359078149_PNB_Renewal_Sanction_dt_22.11.24_compressed_(2).pdf	2025-12-10 09:31:22.486461	Sanction Letters
119	CASE1764758265597	partA	1765359092712_26._Debt_Profile_as_on_31.10.25.xlsx	2025-12-10 09:31:32.716629	Debt sheet
120	CASE1764400962688	partA	1765359242775_HARSHINI_EPC.zip	2025-12-10 09:35:53.864825	Latest year provisionals
121	CASE1764758265597	onePager	1765804964947_RWOT_IRP_INFRA_TECH_LTD(1).pdf	2025-12-15 13:22:50.657554	OnePager
122	CASE1761910111749	onePager	1765805005989_RWOT_TEENA_LABS.pdf	2025-12-15 13:23:28.804632	OnePager
123	CASE1764758733768	onePager	1765805078390_RWOT_SPACENET_ENTERPRISES_INDIA_LTD.pdf	2025-12-15 13:24:40.031582	OnePager
124	CASE1764420063211	onePager	1765805130530_RWOT_Cauvery_iron_&_steel_India_Ltd_LLAP.pdf	2025-12-15 13:25:35.143125	OnePager
125	CASE1764419986719	onePager	1765805170283_RWOT_Pioneer_interior_projects_ltd.pdf	2025-12-15 13:26:11.70106	OnePager
126	CASE1764402666075	onePager	1765805211750_RWOT_Chemveda_Unsecured_.pdf	2025-12-15 13:26:58.350468	OnePager
127	CASE1764402510984	onePager	1765805238627_RWOT_SINGHANIA_PRINTERS.pdf	2025-12-15 13:27:20.130017	OnePager
128	CASE1764402003625	onePager	1765805265738_RWOT_HEMAVANTHVARDHAN_ENTERPRISES_PVT_LTD_BILLS_DISCOUNTING.pdf	2025-12-15 13:27:47.241682	OnePager
129	CASE1764401244052	onePager	1765805293195_RWOT_LORVEN_FLEX_&_SACK_INDIA_PVT_LTD.pdf	2025-12-15 13:28:15.707027	OnePager
130	CASE1766125172313	partA	1766740380343_Signed_Financials_with_Notes.pdf	2025-12-26 09:13:34.916156	Last 3 years financials Along with ITR's
131	CASE1766125172313	partA	1767865754381_Debt_profile_format_RWOT_(3).xlsx	2026-01-08 09:49:14.417192	Debt sheet
\.


--
-- Data for Name: provisional_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provisional_documents (id, caseid, document_name, created_at, requested_by) FROM stdin;
1	CASE1761910111749	Financials	2025-11-28 08:03:21.331794	50
\.


--
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
-- Data for Name: status_matrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_matrix (id, roleid, key, value, "subStatus") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, phone, company, roleid, pocname, pocphone) FROM stdin;
30	Gouthami S	gouthami@myrwot.com	1111111111	8886028369	\N	2	\N	\N
32	Marie	marier@myrwot.com	1111111111	8886013369	\N	2	\N	\N
31	Srilakshmi U	srilakshmi@myrwot.com	1111111111	8886061369	\N	2	\N	\N
33	Kiranmaie J	kiranmaie@myrwot.com	1111111111	8886063369	\N	2	\N	\N
34	Chandrasekhar D	chandrashekar@myrwot.com	1111111111	8886081369	\N	3	\N	\N
36	Irfan M	irfan@myrwot.com	1111111111	8886031369	\N	3	\N	\N
37	Fayaz H	fayaz@myrwot.com	1111111111	8886334369	\N	3	\N	\N
38	Srikanth Jv	srikanth@myrwot.com	1111111111	8886475369	\N	3	\N	\N
39	Sai Prakash	msmeoperations@myrwot.com	1111111111	8886330369	\N	5	\N	\N
41	Abdul A	documents@myrwot.com	1111111111	8886545369	\N	5	\N	\N
42	Soumya T	underwriter@myrwot.com	1111111111	8886903369	\N	4	\N	\N
48	Varun	varun.dharanikota@orixindia.com	1111111111	8977253463	\N	7	\N	\N
40	Suraj Jaiswal	suraj@myrwot.com	1111111111	9966366855	RWOT	5	\N	\N
49	Chaitanya V	chaitanya@myrwot.com	1111111111	8886329369	\N	5	\N	\N
35	Nitheesh	nitheesh@myrwot.com	1111111111	8886029369	Sita Ratnam world of technologies private limited 	3	\N	\N
50	Narender K	narender.kedika@aubank.in	1111111111	9912352347	\N	7	\N	\N
1	Admin User	info@myrwot.com	1111111111	9999999991	RWOT HQ	6	\N	\N
46	Prasanna	operations@myrwot.com	1111111111	9063451369	RWOT HQ	5		
47	Surya	ceosurya.besetti@myrwot.com	1111111111	9565369369	RWOT HQ	3		
51	Arjun B	bommagouniarjun@kvbmail.com	1111111111	70755 08084	\N	7	\N	\N
29	Nikitha	midcorporate@myrwot.com	1111111111	9063452369	\N	2	\N	\N
\.


--
-- Data for Name: workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow (id, caseid, stage, "timestamp") FROM stdin;
1	CASE1762753606380	Underwriting	2025-11-10 06:26:56.649374
2	CASE1762753606380	Underwriting	2025-11-10 06:27:15.494241
3	CASE1762753606380	One Pager	2025-11-10 06:31:25.993367
4	CASE1762753606380	One Pager	2025-11-10 06:31:26.046837
5	CASE1762753606380	One Pager	2025-11-10 06:31:26.675494
6	CASE1762753606380	One Pager	2025-11-10 06:31:27.564661
7	CASE1763973948471	Underwriting	2025-11-25 07:03:02.117618
8	CASE1763973948471	Underwriting	2025-11-25 07:03:06.255968
9	CASE1763973948471	Underwriting	2025-11-25 07:03:11.056785
10	CASE1763442514766	Underwriting	2025-11-25 07:05:38.717112
11	CASE1763973948471	One Pager	2025-11-25 07:15:51.846624
12	CASE1763973948471	One Pager	2025-11-25 07:15:52.089465
13	CASE1763973948471	One Pager	2025-11-25 07:15:52.102399
14	CASE1763973948471	One Pager	2025-11-25 07:15:52.107532
15	CASE1763973948471	One Pager	2025-11-25 07:15:52.113334
16	CASE1763973948471	One Pager	2025-11-25 07:15:52.133527
17	CASE1763973948471	One Pager	2025-11-25 07:15:52.405591
18	CASE1763973948471	One Pager	2025-11-25 07:15:52.406797
19	CASE1763973948471	One Pager	2025-11-25 07:15:52.42153
20	CASE1763973948471	One Pager	2025-11-25 07:15:52.437119
21	CASE1763973948471	One Pager	2025-11-25 07:15:52.437749
22	CASE1763973948471	One Pager	2025-11-25 07:15:52.712753
23	CASE1763973948471	One Pager	2025-11-25 07:15:52.714208
24	CASE1763973948471	One Pager	2025-11-25 07:15:52.715556
25	CASE1763973948471	One Pager	2025-11-25 07:15:52.71687
26	CASE1763973948471	One Pager	2025-11-25 07:15:52.747295
27	CASE1763973948471	One Pager	2025-11-25 07:15:53.022039
28	CASE1763973948471	One Pager	2025-11-25 07:15:53.023288
29	CASE1763973948471	One Pager	2025-11-25 07:15:57.841421
30	CASE1763973948471	One Pager	2025-11-25 07:16:01.295071
31	CASE1763442514766	Underwriting	2025-11-25 07:19:37.807223
32	CASE1763442514766	One Pager	2025-11-28 04:33:23.066165
33	CASE1763442514766	One Pager	2025-11-28 04:33:23.550714
34	CASE1763442514766	One Pager	2025-11-28 04:33:24.838052
35	CASE1763442514766	One Pager	2025-11-28 04:33:26.618628
36	CASE1761910111749	Underwriting	2025-11-28 06:55:56.106935
37	CASE1761910111749	One Pager	2025-11-28 06:58:35.585506
38	CASE1762834354822	Underwriting	2025-11-28 12:12:40.631298
39	CASE1762834354822	One Pager	2025-11-29 02:50:05.167367
40	CASE1762842917468	Underwriting	2025-11-29 03:29:21.004496
41	CASE1762842917468	One Pager	2025-11-29 03:30:27.15286
42	CASE1762834354822	Underwriting	2025-11-29 05:33:15.857837
43	CASE1761910111749	Underwriting	2025-11-29 05:40:50.048858
44	CASE1763973948471	Underwriting	2025-11-29 05:42:29.846467
45	CASE1762753606380	Underwriting	2025-11-29 13:29:02.686048
46	CASE1762753606380	One Pager	2025-11-29 13:29:22.828669
47	CASE1764758733768	Underwriting	2025-12-08 11:09:22.355341
48	CASE1764758265597	Underwriting	2025-12-10 09:31:34.229587
49	CASE1764758265597	One Pager	2025-12-15 13:22:51.702239
50	CASE1761910111749	One Pager	2025-12-15 13:23:29.601509
51	CASE1764758733768	One Pager	2025-12-15 13:24:40.835291
52	CASE1764420063211	One Pager	2025-12-15 13:25:35.929287
53	CASE1764419986719	One Pager	2025-12-15 13:26:12.490785
54	CASE1764402666075	One Pager	2025-12-15 13:26:59.389263
55	CASE1764402510984	One Pager	2025-12-15 13:27:20.891171
56	CASE1764402003625	One Pager	2025-12-15 13:27:49.048625
57	CASE1764401244052	One Pager	2025-12-15 13:28:16.38954
58	CASE1763442514766	Underwriting	2025-12-15 13:28:30.116664
\.


--
-- Data for Name: workflow_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_logs (id, caseid, stage, updatedby, updatedat) FROM stdin;
\.


--
-- Name: banks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banks_id_seq', 87, true);


--
-- Name: case_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.case_assignments_id_seq', 2977, true);


--
-- Name: case_product_requirements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.case_product_requirements_id_seq', 387, true);


--
-- Name: case_stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.case_stages_id_seq', 1, false);


--
-- Name: cases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cases_id_seq', 735, true);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 44, true);


--
-- Name: document_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_configurations_id_seq', 13, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 131, true);


--
-- Name: provisional_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.provisional_documents_id_seq', 1, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- Name: status_matrix_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_matrix_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 51, true);


--
-- Name: workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_id_seq', 58, true);


--
-- Name: workflow_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_logs_id_seq', 1, false);


--
-- Name: banks banks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (id);


--
-- Name: case_assignments case_assignments_caseid_role_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_caseid_role_unique UNIQUE (caseid, role);


--
-- Name: case_assignments case_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_pkey PRIMARY KEY (id);


--
-- Name: case_product_requirements case_product_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_product_requirements
    ADD CONSTRAINT case_product_requirements_pkey PRIMARY KEY (id);


--
-- Name: case_stages case_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages
    ADD CONSTRAINT case_stages_pkey PRIMARY KEY (id);


--
-- Name: cases cases_caseid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_caseid_key UNIQUE (caseid);


--
-- Name: cases cases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: bank_assignments document_configurations_caseid_bankid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_assignments
    ADD CONSTRAINT document_configurations_caseid_bankid_key UNIQUE (caseid, bankid);


--
-- Name: bank_assignments document_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_assignments
    ADD CONSTRAINT document_configurations_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: provisional_documents provisional_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provisional_documents
    ADD CONSTRAINT provisional_documents_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles roles_rolename_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_rolename_key UNIQUE (rolename);


--
-- Name: status_matrix status_matrix_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_matrix
    ADD CONSTRAINT status_matrix_pkey PRIMARY KEY (id);


--
-- Name: cases unique_caseid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT unique_caseid UNIQUE (caseid);


--
-- Name: case_assignments unique_caseid_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT unique_caseid_role UNIQUE (caseid, role);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workflow_logs workflow_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_logs
    ADD CONSTRAINT workflow_logs_pkey PRIMARY KEY (id);


--
-- Name: workflow workflow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow
    ADD CONSTRAINT workflow_pkey PRIMARY KEY (id);


--
-- Name: idx_case_product_requirements_caseid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_case_product_requirements_caseid ON public.case_product_requirements USING btree (caseid);


--
-- Name: idx_case_stages_caseid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_case_stages_caseid ON public.case_stages USING btree (caseid);


--
-- Name: case_assignments case_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: case_assignments case_assignments_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_assignments
    ADD CONSTRAINT case_assignments_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: case_stages case_stages_caseid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages
    ADD CONSTRAINT case_stages_caseid_fkey FOREIGN KEY (caseid) REFERENCES public.cases(caseid) ON DELETE CASCADE;


--
-- Name: case_stages case_stages_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_stages
    ADD CONSTRAINT case_stages_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: cases cases_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_createdby_fkey FOREIGN KEY (createdby) REFERENCES public.users(id);


--
-- Name: case_product_requirements fk_case_product_requirements_case; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.case_product_requirements
    ADD CONSTRAINT fk_case_product_requirements_case FOREIGN KEY (caseid) REFERENCES public.cases(caseid) ON DELETE CASCADE;


--
-- Name: users users_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_roleid_fkey FOREIGN KEY (roleid) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

