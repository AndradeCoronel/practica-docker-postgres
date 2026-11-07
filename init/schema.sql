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

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE public.administrador (
    id_administrador integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    cedula character varying(20) NOT NULL,
    telefono character varying(20),
    email character varying(150) NOT NULL,
    usuario character varying(50) NOT NULL,
    contrasena character varying(255) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE public.administrador_id_administrador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.administrador_id_administrador_seq OWNED BY public.administrador.id_administrador;

CREATE TABLE public.caja_turno (
    id_turno integer NOT NULL,
    id_empleado integer NOT NULL,
    fecha_apertura timestamp without time zone NOT NULL,
    monto_inicial numeric(12,2) NOT NULL,
    fecha_cierre timestamp without time zone,
    monto_esperado numeric(12,2),
    monto_contado numeric(12,2),
    diferencia numeric(12,2),
    estado character varying(30),
    observacion_apertura character varying(255),
    observacion_cierre character varying(255)
);

CREATE SEQUENCE public.caja_turno_id_turno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.caja_turno_id_turno_seq OWNED BY public.caja_turno.id_turno;

CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre character varying(80) NOT NULL,
    descripcion character varying(255)
);

CREATE SEQUENCE public.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categoria.id_categoria;

CREATE TABLE public.cliente (
    id_cliente integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100),
    cedula_nit character varying(20) NOT NULL,
    telefono character varying(20),
    email character varying(150),
    direccion character varying(255),
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.cliente_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.cliente_id_cliente_seq OWNED BY public.cliente.id_cliente;

CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_administrador integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(10,2) DEFAULT 0 NOT NULL,
    iva numeric(10,2) DEFAULT 0 NOT NULL,
    total numeric(10,2) DEFAULT 0 NOT NULL,
    estado character varying(20) DEFAULT 'COMPLETADA'::character varying NOT NULL
);

CREATE SEQUENCE public.compra_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.compra_id_compra_seq OWNED BY public.compra.id_compra;

CREATE TABLE public.detalle_compra (
    id_detalle_compra integer NOT NULL,
    id_compra integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    descuento numeric(10,2) DEFAULT 0 NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    lote character varying(50),
    fecha_vencimiento date,
    CONSTRAINT detalle_compra_cantidad_check CHECK ((cantidad > 0))
);

CREATE SEQUENCE public.detalle_compra_id_detalle_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.detalle_compra_id_detalle_compra_seq OWNED BY public.detalle_compra.id_detalle_compra;

CREATE TABLE public.detalle_venta (
    id_detalle_venta integer NOT NULL,
    id_venta integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    descuento numeric(10,2) DEFAULT 0 NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    CONSTRAINT detalle_venta_cantidad_check CHECK ((cantidad > 0))
);

CREATE SEQUENCE public.detalle_venta_id_detalle_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.detalle_venta_id_detalle_venta_seq OWNED BY public.detalle_venta.id_detalle_venta;

CREATE TABLE public.empleado (
    id_empleado integer NOT NULL,
    id_administrador integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    cedula character varying(20) NOT NULL,
    cargo character varying(50) NOT NULL,
    telefono character varying(20),
    email character varying(150),
    usuario character varying(50) NOT NULL,
    contrasena character varying(255) NOT NULL,
    fecha_ingreso date DEFAULT CURRENT_DATE NOT NULL,
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.empleado_id_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.empleado_id_empleado_seq OWNED BY public.empleado.id_empleado;

CREATE TABLE public.inventario (
    id_inventario integer NOT NULL,
    id_producto integer NOT NULL,
    id_administrador integer NOT NULL,
    stock_actual integer DEFAULT 0 NOT NULL,
    stock_minimo integer DEFAULT 5 NOT NULL,
    ubicacion character varying(50),
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE public.inventario_id_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.inventario_id_inventario_seq OWNED BY public.inventario.id_inventario;

CREATE TABLE public.lote_producto (
    id_lote integer NOT NULL,
    id_producto integer NOT NULL,
    id_detalle_compra integer,
    codigo_lote character varying(100) NOT NULL,
    fecha_ingreso date DEFAULT CURRENT_DATE NOT NULL,
    fecha_vencimiento date,
    cantidad_inicial integer NOT NULL,
    cantidad_disponible integer NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE public.lote_producto_id_lote_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.lote_producto_id_lote_seq OWNED BY public.lote_producto.id_lote;

CREATE TABLE public.movimiento_caja (
    id_movimiento integer NOT NULL,
    id_turno integer NOT NULL,
    id_pago integer,
    tipo character varying(30) NOT NULL,
    concepto character varying(255),
    monto numeric(12,2) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE public.movimiento_caja_id_movimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.movimiento_caja_id_movimiento_seq OWNED BY public.movimiento_caja.id_movimiento;

CREATE TABLE public.movimiento_inventario (
    id_movimiento integer NOT NULL,
    id_producto integer NOT NULL,
    id_lote integer,
    tipo character varying(25) NOT NULL,
    cantidad integer NOT NULL,
    stock_anterior integer NOT NULL,
    stock_nuevo integer NOT NULL,
    motivo character varying(255) NOT NULL,
    referencia_tipo character varying(20),
    referencia_id integer,
    usuario character varying(50) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE public.movimiento_inventario_id_movimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.movimiento_inventario_id_movimiento_seq OWNED BY public.movimiento_inventario.id_movimiento;

CREATE TABLE public.pago (
    id_pago integer NOT NULL,
    id_venta integer NOT NULL,
    metodo character varying(30) NOT NULL,
    monto numeric(10,2) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_pago_metodo CHECK (((metodo)::text = ANY ((ARRAY['EFECTIVO'::character varying, 'TARJETA'::character varying, 'TRANSFERENCIA'::character varying, 'MIXTO'::character varying])::text[]))),
    CONSTRAINT pago_monto_check CHECK ((monto > (0)::numeric))
);

CREATE SEQUENCE public.pago_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.pago_id_pago_seq OWNED BY public.pago.id_pago;

CREATE TABLE public.producto (
    id_producto integer NOT NULL,
    id_categoria integer NOT NULL,
    id_administrador integer NOT NULL,
    codigo_barras character varying(50) NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(255),
    unidad_medida character varying(20) DEFAULT 'UNIDAD'::character varying NOT NULL,
    precio_compra numeric(10,2) DEFAULT 0 NOT NULL,
    precio_venta numeric(10,2) DEFAULT 0 NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    imagen_url character varying(500)
);

CREATE SEQUENCE public.producto_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.producto_id_producto_seq OWNED BY public.producto.id_producto;

CREATE TABLE public.proveedor (
    id_proveedor integer NOT NULL,
    razon_social character varying(150) NOT NULL,
    nit character varying(20) NOT NULL,
    contacto character varying(100),
    telefono character varying(20),
    email character varying(150),
    direccion character varying(255),
    estado boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE public.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNED BY public.proveedor.id_proveedor;

CREATE TABLE public.venta (
    id_venta integer NOT NULL,
    id_cliente integer NOT NULL,
    id_empleado integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(10,2) DEFAULT 0 NOT NULL,
    iva numeric(10,2) DEFAULT 0 NOT NULL,
    descuento numeric(10,2) DEFAULT 0 NOT NULL,
    total numeric(10,2) DEFAULT 0 NOT NULL,
    estado character varying(20) DEFAULT 'COMPLETADA'::character varying NOT NULL
);

CREATE SEQUENCE public.venta_id_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.venta_id_venta_seq OWNED BY public.venta.id_venta;

ALTER TABLE ONLY public.administrador ALTER COLUMN id_administrador SET DEFAULT nextval('public.administrador_id_administrador_seq'::regclass);

ALTER TABLE ONLY public.caja_turno ALTER COLUMN id_turno SET DEFAULT nextval('public.caja_turno_id_turno_seq'::regclass);

ALTER TABLE ONLY public.categoria ALTER COLUMN id_categoria SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);

ALTER TABLE ONLY public.cliente ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_id_cliente_seq'::regclass);

ALTER TABLE ONLY public.compra ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_id_compra_seq'::regclass);

ALTER TABLE ONLY public.detalle_compra ALTER COLUMN id_detalle_compra SET DEFAULT nextval('public.detalle_compra_id_detalle_compra_seq'::regclass);

ALTER TABLE ONLY public.detalle_venta ALTER COLUMN id_detalle_venta SET DEFAULT nextval('public.detalle_venta_id_detalle_venta_seq'::regclass);

ALTER TABLE ONLY public.empleado ALTER COLUMN id_empleado SET DEFAULT nextval('public.empleado_id_empleado_seq'::regclass);

ALTER TABLE ONLY public.inventario ALTER COLUMN id_inventario SET DEFAULT nextval('public.inventario_id_inventario_seq'::regclass);

ALTER TABLE ONLY public.lote_producto ALTER COLUMN id_lote SET DEFAULT nextval('public.lote_producto_id_lote_seq'::regclass);

ALTER TABLE ONLY public.movimiento_caja ALTER COLUMN id_movimiento SET DEFAULT nextval('public.movimiento_caja_id_movimiento_seq'::regclass);

ALTER TABLE ONLY public.movimiento_inventario ALTER COLUMN id_movimiento SET DEFAULT nextval('public.movimiento_inventario_id_movimiento_seq'::regclass);

ALTER TABLE ONLY public.pago ALTER COLUMN id_pago SET DEFAULT nextval('public.pago_id_pago_seq'::regclass);

ALTER TABLE ONLY public.producto ALTER COLUMN id_producto SET DEFAULT nextval('public.producto_id_producto_seq'::regclass);

ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);

ALTER TABLE ONLY public.venta ALTER COLUMN id_venta SET DEFAULT nextval('public.venta_id_venta_seq'::regclass);

COPY public.administrador (id_administrador, nombre, apellido, cedula, telefono, email, usuario, contrasena, estado, fecha_creacion) FROM stdin;
1	Admin	Principal	12345678	70000000	admin@ferreteria.com	admin	$2a$10$d2zeGGK0j0jebptyYrkF0.GL0LLcwB0II0j5A51WTxlAFEKprsejG	t	2026-09-19 08:57:43.088838
\.

COPY public.caja_turno (id_turno, id_empleado, fecha_apertura, monto_inicial, fecha_cierre, monto_esperado, monto_contado, diferencia, estado, observacion_apertura, observacion_cierre) FROM stdin;
\.

COPY public.categoria (id_categoria, nombre, descripcion) FROM stdin;
1	Herramientas	Herramientas manuales de uso general
2	Herramientas Eléctricas	Herramientas eléctricas y de potencia
3	Construcción	Materiales y herramientas para construcción
4	Tornillería	Tornillos, pernos, tuercas y fijaciones
6	Plomería	Tuberías, conexiones y accesorios de agua
7	Electricidad	Cables, breakers y accesorios eléctricos
8	Jardinería	Herramientas y accesorios para jardín
9	Seguridad Industrial	Equipos de protección personal
10	Adhesivos y Selladores	Pegamentos, siliconas y selladores
11	Accesorios y Consumibles	Discos, lijas, brochas y consumibles
12	Ferretería para el Hogar	Cerraduras, bisagras y artículos del hogar
5	Pinturas artesanales	Pinturas, esmaltes y accesorios de pintura
\.

COPY public.cliente (id_cliente, nombre, apellido, cedula_nit, telefono, email, direccion, fecha_registro, estado) FROM stdin;
2	Juan	Gomez	12345678	1168446	juan@test.com	Calle 5 #10-15	2026-10-02 22:30:43.615284	t
4	ALVARO	MAGNE	64864861	78484851	magnesanchezalvaro08@gmail.com	Av. Bolivia	2026-10-20 12:07:35.036929	t
\.

COPY public.compra (id_compra, id_proveedor, id_administrador, fecha, subtotal, iva, total, estado) FROM stdin;
\.

COPY public.detalle_compra (id_detalle_compra, id_compra, id_producto, cantidad, precio_unitario, descuento, subtotal, lote, fecha_vencimiento) FROM stdin;
\.

COPY public.detalle_venta (id_detalle_venta, id_venta, id_producto, cantidad, precio_unitario, descuento, subtotal) FROM stdin;
\.

COPY public.empleado (id_empleado, id_administrador, nombre, apellido, cedula, cargo, telefono, email, usuario, contrasena, fecha_ingreso, estado) FROM stdin;
2	1	María Fernanda	Vargas Choque	8901234	Cajera	72345678	mvargas@ferreteriacopacabana.bo	mvargas	bolivia2026	2026-10-02	t
29	1	Tomas Gabriel	Torrez Callisaya	18668161	Cajero	67849562	tomatoca@gmail.com	Tomas	Tomas123	2026-10-17	t
31	1	Angelo	Andrade	13436511	Limosnero	62313886	lpze.julioangel.andrade.co@unifranz.edu.bo	Julioangel	julio123	2026-10-20	t
33	1	Valery	Ponce Arcos	73947193	EX-empleada	77732532	valery@amor.com	ELAMORDEMIVIDA	123456789	2026-10-28	t
34	1	Mary	SCZ	646151756	el futuro amor de mi vida	4891891	mary@elamordemividascz.com	MARY	1234567	2026-10-28	t
32	1	Luz Belen	Suker	35643152	Futura esposa del dueño de la empreza	12345678	luzsuker@gmail.com	Lucesita123	Angheloteamo	2026-10-28	t
\.

COPY public.inventario (id_inventario, id_producto, id_administrador, stock_actual, stock_minimo, ubicacion, fecha_actualizacion) FROM stdin;
7	11	1	18	3	Bodega principal	2026-10-03 08:47:54.91551
6	10	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
8	12	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
9	13	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
10	14	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
11	15	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
12	16	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
13	17	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
14	18	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
15	19	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
16	20	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
17	21	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
18	22	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
19	23	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
20	24	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
21	25	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
22	26	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
23	27	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
24	28	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
25	29	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
26	30	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
27	31	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
28	32	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
29	33	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
30	34	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
31	35	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
32	36	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
33	37	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
34	38	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
35	39	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
36	40	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
37	41	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
38	42	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
39	43	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
40	44	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
41	45	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
42	46	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
43	47	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
44	48	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
45	49	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
46	50	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
47	51	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
48	52	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
49	53	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
50	54	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
51	55	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
52	56	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
53	57	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
54	58	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
55	59	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
56	60	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
57	61	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
58	62	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
59	63	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
60	64	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
61	65	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
62	66	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
63	67	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
64	68	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
65	69	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
66	70	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
67	71	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
68	72	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
69	73	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
70	74	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
71	75	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
72	76	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
73	77	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
74	78	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
75	79	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
76	80	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
77	81	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
78	82	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
79	83	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
80	84	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
81	85	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
82	86	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
83	87	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
84	88	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
85	89	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
86	90	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
87	91	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
88	92	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
89	93	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
90	94	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
91	95	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
92	96	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
93	97	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
94	98	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
95	99	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
96	100	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
97	101	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
98	102	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
99	103	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
100	104	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
101	105	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
102	106	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
103	107	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
104	108	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
105	109	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
106	110	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
107	111	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
108	112	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
109	113	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
110	114	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
111	115	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
112	116	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
113	117	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
114	118	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
115	119	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
116	120	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
117	121	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
118	122	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
119	123	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
120	124	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
121	125	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
122	126	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
123	127	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
124	128	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
125	129	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
126	130	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
127	131	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
128	132	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
129	133	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
130	134	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
131	135	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
132	136	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
133	137	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
134	138	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
135	139	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
136	140	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
137	141	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
138	142	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
139	143	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
140	144	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
141	145	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
142	146	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
143	147	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
144	148	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
145	149	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
146	150	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
147	151	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
148	152	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
149	153	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
150	154	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
151	155	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
152	156	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
153	157	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
154	158	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
155	159	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
156	160	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
157	161	1	10	3	Bodega principal	2026-10-03 08:47:54.91551
\.

COPY public.lote_producto (id_lote, id_producto, id_detalle_compra, codigo_lote, fecha_ingreso, fecha_vencimiento, cantidad_inicial, cantidad_disponible, fecha_registro) FROM stdin;
\.

COPY public.movimiento_caja (id_movimiento, id_turno, id_pago, tipo, concepto, monto, fecha) FROM stdin;
\.

COPY public.movimiento_inventario (id_movimiento, id_producto, id_lote, tipo, cantidad, stock_anterior, stock_nuevo, motivo, referencia_tipo, referencia_id, usuario, fecha) FROM stdin;
\.

COPY public.pago (id_pago, id_venta, metodo, monto, fecha) FROM stdin;
\.

COPY public.producto (id_producto, id_categoria, id_administrador, codigo_barras, nombre, descripcion, unidad_medida, precio_compra, precio_venta, estado, fecha_creacion, imagen_url) FROM stdin;
11	1	1	HERR-002	Martillo de goma	\N	UNIDAD	18000.00	30000.00	t	2026-10-03 08:45:16.957828	\N
12	1	1	HERR-003	Alicate universal 8 pulgadas	\N	UNIDAD	22000.00	35000.00	t	2026-10-03 08:45:16.957828	\N
13	1	1	HERR-004	Alicate de corte diagonal	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:45:16.957828	\N
14	1	1	HERR-005	Alicate de punta fina	\N	UNIDAD	20000.00	32000.00	t	2026-10-03 08:45:16.957828	\N
15	1	1	HERR-006	Pinza de presión	\N	UNIDAD	24000.00	38000.00	t	2026-10-03 08:45:16.957828	\N
16	1	1	HERR-007	Llave ajustable 10 pulgadas	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:45:16.957828	\N
17	1	1	HERR-008	Juego de llaves combinadas de 8 a 19 mm	\N	JUEGO	85000.00	130000.00	t	2026-10-03 08:45:16.957828	\N
18	1	1	HERR-009	Juego de llaves Allen	\N	JUEGO	35000.00	55000.00	t	2026-10-03 08:45:16.957828	\N
19	1	1	HERR-010	Destornillador de pala 1/4x4	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:45:16.957828	\N
20	1	1	HERR-011	Destornillador de estrella PH2	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:45:16.957828	\N
21	1	1	HERR-012	Flexómetro 5 metros	\N	UNIDAD	15000.00	25000.00	t	2026-10-03 08:45:16.957828	\N
22	1	1	HERR-013	Flexómetro 8 metros	\N	UNIDAD	22000.00	35000.00	t	2026-10-03 08:45:16.957828	\N
23	1	1	HERR-014	Nivel de burbuja 24 pulgadas	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:45:16.957828	\N
24	1	1	HERR-015	Escuadra de carpintero	\N	UNIDAD	12000.00	20000.00	t	2026-10-03 08:45:16.957828	\N
25	1	1	HERR-016	Serrucho para madera 20 pulgadas	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:45:16.957828	\N
26	1	1	HERR-017	Arco de sierra para metal	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:45:16.957828	\N
27	1	1	HERR-018	Cúter reforzado	\N	UNIDAD	10000.00	18000.00	t	2026-10-03 08:45:16.957828	\N
28	2	1	HELE-001	Taladro percutor 1/2 pulgada 650W	\N	UNIDAD	380000.00	550000.00	t	2026-10-03 08:45:30.194707	\N
29	2	1	HELE-002	Atornillador inalámbrico 20V	\N	UNIDAD	350000.00	500000.00	t	2026-10-03 08:45:30.194707	\N
30	2	1	HELE-003	Rotomartillo SDS Plus	\N	UNIDAD	750000.00	1050000.00	t	2026-10-03 08:45:30.194707	\N
31	2	1	HELE-004	Amoladora angular 4 y media pulgadas	\N	UNIDAD	250000.00	380000.00	t	2026-10-03 08:45:30.194707	\N
32	2	1	HELE-005	Sierra circular 7 y un cuarto pulgadas	\N	UNIDAD	550000.00	800000.00	t	2026-10-03 08:45:30.194707	\N
33	2	1	HELE-006	Sierra caladora	\N	UNIDAD	380000.00	550000.00	t	2026-10-03 08:45:30.194707	\N
34	2	1	HELE-007	Compresor de aire 24 litros	\N	UNIDAD	1200000.00	1700000.00	t	2026-10-03 08:45:30.194707	\N
35	2	1	HELE-008	Soldadora inversora 160 amperios	\N	UNIDAD	950000.00	1350000.00	t	2026-10-03 08:45:30.194707	\N
36	2	1	HELE-009	Pistola de calor	\N	UNIDAD	280000.00	420000.00	t	2026-10-03 08:45:30.194707	\N
37	3	1	CONS-001	Paleta de albañil	\N	UNIDAD	20000.00	32000.00	t	2026-10-03 08:45:39.688376	\N
38	3	1	CONS-002	Cuchara de albañil 8 pulgadas	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:45:39.688376	\N
39	3	1	CONS-003	Llana lisa de acero	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:45:39.688376	\N
40	3	1	CONS-004	Llana dentada para cerámica	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:45:39.688376	\N
41	3	1	CONS-005	Espátula de 3 pulgadas	\N	UNIDAD	10000.00	18000.00	t	2026-10-03 08:45:39.688376	\N
42	3	1	CONS-006	Espátula de 5 pulgadas	\N	UNIDAD	14000.00	24000.00	t	2026-10-03 08:45:39.688376	\N
43	3	1	CONS-007	Balde de obra reforzado	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:45:39.688376	\N
44	3	1	CONS-008	Plomada de bronce con hilo	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:45:39.688376	\N
45	3	1	CONS-009	Mezcladora de concreto 130 litros	\N	UNIDAD	3500000.00	4800000.00	t	2026-10-03 08:45:39.688376	\N
46	3	1	CONS-010	Cemento gris 50 kg	\N	BOLSA	45000.00	58000.00	t	2026-10-03 08:45:39.688376	\N
47	3	1	CONS-011	Yeso de obra	\N	BOLSA	25000.00	35000.00	t	2026-10-03 08:45:39.688376	\N
48	3	1	CONS-012	Cal	\N	BOLSA	18000.00	26000.00	t	2026-10-03 08:45:39.688376	\N
49	3	1	CONS-013	Varilla de hierro corrugado 12 mm	\N	UNIDAD	75000.00	105000.00	t	2026-10-03 08:45:39.688376	\N
50	3	1	CONS-014	Varilla de hierro corrugado 10 mm	\N	UNIDAD	55000.00	78000.00	t	2026-10-03 08:45:39.688376	\N
51	3	1	CONS-015	Malla electrosoldada	\N	PLIEGO	130000.00	180000.00	t	2026-10-03 08:45:39.688376	\N
52	4	1	TORN-001	Tornillo drywall punta fina 6x1	\N	UNIDAD	200.00	400.00	t	2026-10-03 08:45:50.125051	\N
53	4	1	TORN-002	Tornillo drywall punta broca 6x1	\N	UNIDAD	250.00	500.00	t	2026-10-03 08:45:50.125051	\N
54	4	1	TORN-003	Tornillo para madera 4x40 mm	\N	UNIDAD	300.00	600.00	t	2026-10-03 08:45:50.125051	\N
55	4	1	TORN-004	Tornillo autorroscante para metal	\N	UNIDAD	350.00	700.00	t	2026-10-03 08:45:50.125051	\N
56	4	1	TORN-005	Perno hexagonal grado 5 de 3/8x2	\N	UNIDAD	2500.00	4500.00	t	2026-10-03 08:45:50.125051	\N
57	4	1	TORN-006	Perno hexagonal grado 2 de 1/4x1 y medio	\N	UNIDAD	1500.00	2800.00	t	2026-10-03 08:45:50.125051	\N
58	4	1	TORN-007	Tuerca corriente 3/8	\N	UNIDAD	500.00	1000.00	t	2026-10-03 08:45:50.125051	\N
59	4	1	TORN-008	Tuerca de seguridad nylon 3/8	\N	UNIDAD	800.00	1500.00	t	2026-10-03 08:45:50.125051	\N
60	4	1	TORN-009	Arandela plana 3/8	\N	UNIDAD	200.00	400.00	t	2026-10-03 08:45:50.125051	\N
61	4	1	TORN-010	Arandela de presión 3/8	\N	UNIDAD	250.00	500.00	t	2026-10-03 08:45:50.125051	\N
62	4	1	TORN-011	Ramplug plástico 6 mm	\N	UNIDAD	300.00	600.00	t	2026-10-03 08:45:50.125051	\N
63	4	1	TORN-012	Ramplug plástico 8 mm	\N	UNIDAD	400.00	800.00	t	2026-10-03 08:45:50.125051	\N
64	4	1	TORN-013	Ramplug plástico 10 mm	\N	UNIDAD	500.00	1000.00	t	2026-10-03 08:45:50.125051	\N
65	4	1	TORN-014	Chazo metálico de expansión 3/8	\N	UNIDAD	1200.00	2200.00	t	2026-10-03 08:45:50.125051	\N
66	5	1	PINT-001	Pintura látex blanco mate 4 litros	\N	UNIDAD	85000.00	130000.00	t	2026-10-03 08:46:14.35059	\N
67	5	1	PINT-002	Pintura látex blanco mate 20 litros	\N	UNIDAD	380000.00	550000.00	t	2026-10-03 08:46:14.35059	\N
68	5	1	PINT-003	Esmalte sintético negro	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:46:14.35059	\N
69	5	1	PINT-004	Esmalte sintético blanco	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:46:14.35059	\N
70	5	1	PINT-005	Pintura anticorrosiva gris	\N	UNIDAD	55000.00	85000.00	t	2026-10-03 08:46:14.35059	\N
71	5	1	PINT-006	Impermeabilizante para techos	\N	UNIDAD	120000.00	180000.00	t	2026-10-03 08:46:14.35059	\N
72	5	1	PINT-007	Thinner estándar	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:46:14.35059	\N
73	5	1	PINT-008	Aguarrás mineral	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:46:14.35059	\N
74	5	1	PINT-009	Pasta muro interior	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:46:14.35059	\N
10	1	1	HERR-001	Martillo de galpón 16 oz	\N	UNIDAD	250.00	400.00	t	2026-10-03 08:45:16.957828	\N
75	5	1	PINT-010	Masilla elástica para grietas	\N	UNIDAD	28000.00	45000.00	t	2026-10-03 08:46:14.35059	\N
76	6	1	PLOM-001	Tubo PVC agua fría 1/2 pulgada	\N	METRO	3500.00	6000.00	t	2026-10-03 08:46:23.965958	\N
77	6	1	PLOM-002	Tubo PVC agua fría 3/4 pulgada	\N	METRO	5000.00	8500.00	t	2026-10-03 08:46:23.965958	\N
78	6	1	PLOM-003	Tubo CPVC agua caliente 1/2 pulgada	\N	METRO	8000.00	14000.00	t	2026-10-03 08:46:23.965958	\N
79	6	1	PLOM-004	Tubo PVC desagüe 2 pulgadas	\N	METRO	12000.00	20000.00	t	2026-10-03 08:46:23.965958	\N
80	6	1	PLOM-005	Tubo PVC desagüe 4 pulgadas	\N	METRO	25000.00	42000.00	t	2026-10-03 08:46:23.965958	\N
81	6	1	PLOM-006	Codo PVC 1/2 a 90 grados	\N	UNIDAD	1500.00	3000.00	t	2026-10-03 08:46:23.965958	\N
82	6	1	PLOM-007	Tee PVC 1/2 pulgada	\N	UNIDAD	2000.00	3500.00	t	2026-10-03 08:46:23.965958	\N
83	6	1	PLOM-008	Llave de paso esférica 1/2 pulgada	\N	UNIDAD	18000.00	30000.00	t	2026-10-03 08:46:23.965958	\N
84	6	1	PLOM-009	Sifón flexible para lavamanos	\N	UNIDAD	25000.00	42000.00	t	2026-10-03 08:46:23.965958	\N
85	6	1	PLOM-010	Sifón para fregadero de cocina	\N	UNIDAD	35000.00	58000.00	t	2026-10-03 08:46:23.965958	\N
86	6	1	PLOM-011	Grifo para lavamanos	\N	UNIDAD	85000.00	140000.00	t	2026-10-03 08:46:23.965958	\N
87	6	1	PLOM-012	Grifo para lavadero	\N	UNIDAD	95000.00	150000.00	t	2026-10-03 08:46:23.965958	\N
88	6	1	PLOM-013	Válvula check 1/2 pulgada	\N	UNIDAD	22000.00	35000.00	t	2026-10-03 08:46:23.965958	\N
89	6	1	PLOM-014	Acople flexible para agua 1/2 pulgada	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:46:23.965958	\N
90	7	1	ELEC-001	Cable eléctrico THHN calibre 12 AWG	\N	METRO	3000.00	5500.00	t	2026-10-03 08:46:31.900614	\N
91	7	1	ELEC-002	Cable eléctrico THHN calibre 14 AWG	\N	METRO	2000.00	3500.00	t	2026-10-03 08:46:31.900614	\N
92	7	1	ELEC-003	Cable dúplex 2x16	\N	METRO	2500.00	4500.00	t	2026-10-03 08:46:31.900614	\N
93	7	1	ELEC-004	Breaker termomagnético 15 amperios	\N	UNIDAD	35000.00	58000.00	t	2026-10-03 08:46:31.900614	\N
94	7	1	ELEC-005	Breaker termomagnético 20 amperios	\N	UNIDAD	38000.00	62000.00	t	2026-10-03 08:46:31.900614	\N
95	7	1	ELEC-006	Tablero de distribución 4 circuitos	\N	UNIDAD	95000.00	150000.00	t	2026-10-03 08:46:31.900614	\N
96	7	1	ELEC-007	Interruptor sencillo	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:46:31.900614	\N
97	7	1	ELEC-008	Interruptor doble	\N	UNIDAD	12000.00	20000.00	t	2026-10-03 08:46:31.900614	\N
98	7	1	ELEC-009	Tomacorriente doble con polo a tierra	\N	UNIDAD	15000.00	25000.00	t	2026-10-03 08:46:31.900614	\N
99	7	1	ELEC-010	Caja rectangular de PVC	\N	UNIDAD	3000.00	5500.00	t	2026-10-03 08:46:31.900614	\N
100	7	1	ELEC-011	Caja octagonal de PVC	\N	UNIDAD	4000.00	7000.00	t	2026-10-03 08:46:31.900614	\N
101	7	1	ELEC-012	Bombillo LED 9W rosca E27	\N	UNIDAD	10000.00	18000.00	t	2026-10-03 08:46:31.900614	\N
102	7	1	ELEC-013	Bombillo LED 12W rosca E27	\N	UNIDAD	13000.00	22000.00	t	2026-10-03 08:46:31.900614	\N
103	7	1	ELEC-014	Panel LED de incrustar 18W	\N	UNIDAD	35000.00	58000.00	t	2026-10-03 08:46:31.900614	\N
104	7	1	ELEC-015	Reflector LED exterior 50W	\N	UNIDAD	65000.00	105000.00	t	2026-10-03 08:46:31.900614	\N
105	8	1	JARD-001	Pala recta con mango	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:46:40.059558	\N
106	8	1	JARD-002	Pala redonda con mango	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:46:40.059558	\N
107	8	1	JARD-003	Pico con mango	\N	UNIDAD	55000.00	85000.00	t	2026-10-03 08:46:40.059558	\N
108	8	1	JARD-004	Rastrillo metálico	\N	UNIDAD	40000.00	62000.00	t	2026-10-03 08:46:40.059558	\N
109	8	1	JARD-005	Azadón con mango	\N	UNIDAD	50000.00	78000.00	t	2026-10-03 08:46:40.059558	\N
110	8	1	JARD-006	Tijera de podar manual	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:46:40.059558	\N
111	8	1	JARD-007	Manguera reforzada 1/2 pulgada 15 metros	\N	UNIDAD	85000.00	135000.00	t	2026-10-03 08:46:40.059558	\N
112	8	1	JARD-008	Pistola de riego multichorro	\N	UNIDAD	25000.00	42000.00	t	2026-10-03 08:46:40.059558	\N
113	8	1	JARD-009	Conector rápido para manguera	\N	UNIDAD	10000.00	18000.00	t	2026-10-03 08:46:40.059558	\N
114	8	1	JARD-010	Aspersor giratorio	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:46:40.059558	\N
115	8	1	JARD-011	Desbrozadora a gasolina	\N	UNIDAD	1650000.00	2200000.00	t	2026-10-03 08:46:40.059558	\N
116	9	1	SEGI-001	Casco de seguridad tipo jockey	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:46:48.66147	\N
117	9	1	SEGI-002	Gafas de seguridad transparentes	\N	UNIDAD	15000.00	25000.00	t	2026-10-03 08:46:48.66147	\N
118	9	1	SEGI-003	Gafas de seguridad oscuras	\N	UNIDAD	18000.00	30000.00	t	2026-10-03 08:46:48.66147	\N
119	9	1	SEGI-004	Tapones auditivos de silicona	\N	PAR	8000.00	14000.00	t	2026-10-03 08:46:48.66147	\N
120	9	1	SEGI-005	Mascarilla antipolvo N95	\N	UNIDAD	12000.00	20000.00	t	2026-10-03 08:46:48.66147	\N
121	9	1	SEGI-006	Guantes de carnaza para construcción	\N	PAR	20000.00	32000.00	t	2026-10-03 08:46:48.66147	\N
122	9	1	SEGI-007	Guantes de nitrilo	\N	PAR	15000.00	25000.00	t	2026-10-03 08:46:48.66147	\N
123	9	1	SEGI-008	Guantes con recubrimiento de poliuretano	\N	PAR	18000.00	30000.00	t	2026-10-03 08:46:48.66147	\N
124	9	1	SEGI-009	Chaleco reflectivo	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:46:48.66147	\N
125	9	1	SEGI-010	Botas de seguridad con puntera de acero	\N	PAR	180000.00	260000.00	t	2026-10-03 08:46:48.66147	\N
126	10	1	ADHE-001	Silicona transparente uso general	\N	UNIDAD	20000.00	32000.00	t	2026-10-03 08:46:57.473633	\N
127	10	1	ADHE-002	Silicona blanca para baño y cocina	\N	UNIDAD	22000.00	35000.00	t	2026-10-03 08:46:57.473633	\N
128	10	1	ADHE-003	Sellador acrílico blanco	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:46:57.473633	\N
129	10	1	ADHE-004	Espuma de poliuretano expansiva	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:46:57.473633	\N
130	10	1	ADHE-005	Cola fría para madera 500g	\N	UNIDAD	25000.00	40000.00	t	2026-10-03 08:46:57.473633	\N
131	10	1	ADHE-006	Cemento de contacto 1/4 galón	\N	UNIDAD	55000.00	85000.00	t	2026-10-03 08:46:57.473633	\N
132	10	1	ADHE-007	Pegamento instantáneo cianocrilato	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:46:57.473633	\N
133	10	1	ADHE-008	Pegamento epóxico de dos componentes	\N	UNIDAD	30000.00	48000.00	t	2026-10-03 08:46:57.473633	\N
134	10	1	ADHE-009	Pegamento para PVC con limpiador	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:46:57.473633	\N
135	11	1	ACCE-001	Disco de corte para metal 4 y media pulgadas	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:47:05.873101	\N
136	11	1	ACCE-002	Disco de desbaste para metal 4 y media pulgadas	\N	UNIDAD	12000.00	20000.00	t	2026-10-03 08:47:05.873101	\N
137	11	1	ACCE-003	Disco diamantado para concreto 4 y media pulgadas	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:47:05.873101	\N
138	11	1	ACCE-004	Lija al agua grano 80	\N	PLIEGO	2000.00	3500.00	t	2026-10-03 08:47:05.873101	\N
139	11	1	ACCE-005	Lija al agua grano 120	\N	PLIEGO	2000.00	3500.00	t	2026-10-03 08:47:05.873101	\N
140	11	1	ACCE-006	Lija para madera grano 60	\N	PLIEGO	2500.00	4500.00	t	2026-10-03 08:47:05.873101	\N
141	11	1	ACCE-007	Brocha para pintura 2 pulgadas	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:47:05.873101	\N
142	11	1	ACCE-008	Brocha para pintura 3 pulgadas	\N	UNIDAD	12000.00	20000.00	t	2026-10-03 08:47:05.873101	\N
143	11	1	ACCE-009	Rodillo de felpa 9 pulgadas	\N	UNIDAD	18000.00	30000.00	t	2026-10-03 08:47:05.873101	\N
144	11	1	ACCE-010	Bandeja para pintura	\N	UNIDAD	10000.00	18000.00	t	2026-10-03 08:47:05.873101	\N
145	11	1	ACCE-011	Cinta de enmascarar 1 pulgada	\N	UNIDAD	5000.00	8500.00	t	2026-10-03 08:47:05.873101	\N
146	11	1	ACCE-012	Broca para concreto 6 mm	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:47:05.873101	\N
147	11	1	ACCE-013	Broca para concreto 8 mm	\N	UNIDAD	10000.00	18000.00	t	2026-10-03 08:47:05.873101	\N
148	11	1	ACCE-014	Broca para metal HSS 1/4	\N	UNIDAD	12000.00	20000.00	t	2026-10-03 08:47:05.873101	\N
149	11	1	ACCE-015	Punta de destornillador PH2	\N	UNIDAD	3000.00	5500.00	t	2026-10-03 08:47:05.873101	\N
150	12	1	FERR-001	Cerradura de pomo para dormitorio	\N	UNIDAD	55000.00	85000.00	t	2026-10-03 08:47:18.434269	\N
151	12	1	FERR-002	Cerradura de pomo para baño	\N	UNIDAD	55000.00	85000.00	t	2026-10-03 08:47:18.434269	\N
152	12	1	FERR-003	Cerrojo de seguridad de sobreponer	\N	UNIDAD	35000.00	55000.00	t	2026-10-03 08:47:18.434269	\N
153	12	1	FERR-004	Candado de bronce 40 mm	\N	UNIDAD	45000.00	70000.00	t	2026-10-03 08:47:18.434269	\N
154	12	1	FERR-005	Candado de bronce 50 mm	\N	UNIDAD	65000.00	100000.00	t	2026-10-03 08:47:18.434269	\N
155	12	1	FERR-006	Bisagra de fierro 3x3 pulgadas	\N	PAR	12000.00	20000.00	t	2026-10-03 08:47:18.434269	\N
156	12	1	FERR-007	Escuadra de soporte para repisa 8x10	\N	UNIDAD	8000.00	14000.00	t	2026-10-03 08:47:18.434269	\N
157	12	1	FERR-008	Rueda giratoria 2 pulgadas	\N	UNIDAD	15000.00	25000.00	t	2026-10-03 08:47:18.434269	\N
158	12	1	FERR-009	Cinta aislante negra	\N	UNIDAD	5000.00	8500.00	t	2026-10-03 08:47:18.434269	\N
159	12	1	FERR-010	Cinta teflón para agua	\N	UNIDAD	2000.00	3500.00	t	2026-10-03 08:47:18.434269	\N
160	12	1	FERR-011	Cinta de embalaje transparente	\N	UNIDAD	6000.00	10000.00	t	2026-10-03 08:47:18.434269	\N
161	12	1	FERR-012	Amarras plásticas de 20 cm	\N	PAQUETE	8000.00	14000.00	t	2026-10-03 08:47:18.434269	\N
\.

COPY public.proveedor (id_proveedor, razon_social, nit, contacto, telefono, email, direccion, estado) FROM stdin;
2	Ferretería Mayorista S.A.	900999888-7	Carlos Ramírez	77788899	ventas@mayorista.com	Av. Central #50-30	t
1	Distribuidora El Tornillo S.A.	900183456-1	Juan Perez	3100000000	ventas@eltornillo.com	Calle 10 #20-30	t
3	Distribuidora Juan Mayta	9001528416-9	Juan Mayta	69938067	JMproductos@gmail.com	San pedro	t
\.

COPY public.venta (id_venta, id_cliente, id_empleado, fecha, subtotal, iva, descuento, total, estado) FROM stdin;
\.

SELECT pg_catalog.setval('public.administrador_id_administrador_seq', 1, true);

SELECT pg_catalog.setval('public.caja_turno_id_turno_seq', 1, false);

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 13, true);

SELECT pg_catalog.setval('public.cliente_id_cliente_seq', 4, true);

SELECT pg_catalog.setval('public.compra_id_compra_seq', 5, true);

SELECT pg_catalog.setval('public.detalle_compra_id_detalle_compra_seq', 2, true);

SELECT pg_catalog.setval('public.detalle_venta_id_detalle_venta_seq', 2, true);

SELECT pg_catalog.setval('public.empleado_id_empleado_seq', 34, true);

SELECT pg_catalog.setval('public.inventario_id_inventario_seq', 157, true);

SELECT pg_catalog.setval('public.lote_producto_id_lote_seq', 1, false);

SELECT pg_catalog.setval('public.movimiento_caja_id_movimiento_seq', 1, false);

SELECT pg_catalog.setval('public.movimiento_inventario_id_movimiento_seq', 1, false);

SELECT pg_catalog.setval('public.pago_id_pago_seq', 2, true);

SELECT pg_catalog.setval('public.producto_id_producto_seq', 162, true);

SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 3, true);

SELECT pg_catalog.setval('public.venta_id_venta_seq', 3, true);

ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_cedula_key UNIQUE (cedula);

ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_email_key UNIQUE (email);

ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_pkey PRIMARY KEY (id_administrador);

ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_usuario_key UNIQUE (usuario);

ALTER TABLE ONLY public.caja_turno
    ADD CONSTRAINT caja_turno_pkey PRIMARY KEY (id_turno);

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_key UNIQUE (nombre);

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_cedula_nit_key UNIQUE (cedula_nit);

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detalle_compra);

ALTER TABLE ONLY public.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (id_detalle_venta);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_cedula_key UNIQUE (cedula);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id_empleado);

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_usuario_key UNIQUE (usuario);

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_producto_key UNIQUE (id_producto);

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);

ALTER TABLE ONLY public.lote_producto
    ADD CONSTRAINT lote_producto_id_detalle_compra_key UNIQUE (id_detalle_compra);

ALTER TABLE ONLY public.lote_producto
    ADD CONSTRAINT lote_producto_pkey PRIMARY KEY (id_lote);

ALTER TABLE ONLY public.movimiento_caja
    ADD CONSTRAINT movimiento_caja_pkey PRIMARY KEY (id_movimiento);

ALTER TABLE ONLY public.movimiento_inventario
    ADD CONSTRAINT movimiento_inventario_pkey PRIMARY KEY (id_movimiento);

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (id_pago);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_codigo_barras_key UNIQUE (codigo_barras);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_nit_key UNIQUE (nit);

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (id_venta);

CREATE INDEX idx_compra_fecha ON public.compra USING btree (fecha);

CREATE INDEX idx_compra_proveedor ON public.compra USING btree (id_proveedor);

CREATE INDEX idx_pago_fecha ON public.pago USING btree (fecha);

CREATE INDEX idx_pago_venta ON public.pago USING btree (id_venta);

CREATE INDEX idx_producto_categoria ON public.producto USING btree (id_categoria);

CREATE INDEX idx_producto_codigo ON public.producto USING btree (codigo_barras);

CREATE INDEX idx_venta_cliente ON public.venta USING btree (id_cliente);

CREATE INDEX idx_venta_fecha ON public.venta USING btree (fecha);

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_admin FOREIGN KEY (id_administrador) REFERENCES public.administrador(id_administrador);

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detalle_compra_compra FOREIGN KEY (id_compra) REFERENCES public.compra(id_compra) ON DELETE CASCADE;

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT fk_detalle_compra_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);

ALTER TABLE ONLY public.detalle_venta
    ADD CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);

ALTER TABLE ONLY public.detalle_venta
    ADD CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) REFERENCES public.venta(id_venta) ON DELETE CASCADE;

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT fk_empleado_admin FOREIGN KEY (id_administrador) REFERENCES public.administrador(id_administrador);

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT fk_inventario_admin FOREIGN KEY (id_administrador) REFERENCES public.administrador(id_administrador);

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta) REFERENCES public.venta(id_venta) ON DELETE CASCADE;

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT fk_producto_admin FOREIGN KEY (id_administrador) REFERENCES public.administrador(id_administrador);

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria);

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);

ALTER TABLE ONLY public.lote_producto
    ADD CONSTRAINT lote_producto_id_detalle_compra_fkey FOREIGN KEY (id_detalle_compra) REFERENCES public.detalle_compra(id_detalle_compra);

ALTER TABLE ONLY public.lote_producto
    ADD CONSTRAINT lote_producto_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);

ALTER TABLE ONLY public.movimiento_inventario
    ADD CONSTRAINT movimiento_inventario_id_lote_fkey FOREIGN KEY (id_lote) REFERENCES public.lote_producto(id_lote);

ALTER TABLE ONLY public.movimiento_inventario
    ADD CONSTRAINT movimiento_inventario_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);

\unrestrict Vt1Ne5VeIcd7Vp0G2B19xbH6LTtpLic6pc31Hr6MfkyNa44HqhC6uLdRhatQNJ9