CREATE TABLE "clients" (
  "id" serial PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "email" varchar,
  "telephone" integer
);

CREATE TABLE "accounts" (
  "id" serial PRIMARY KEY,
  "account_no" integer UNIQUE,
  "client_id" integer,
  "balance" money,
  "type" integer
);

CREATE TABLE "account_types" (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "description" varchar
);

CREATE TABLE "transactions" (
  "id" serial PRIMARY KEY,
  "account_ori" integer,
  "account_des" integer,
  "amount" money,
  "transaction_type" integer,
  "trans_date" timestamp
);

CREATE TABLE "transactions_types" (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "description" varchar
);

ALTER TABLE "transactions" ADD FOREIGN KEY ("account_ori") REFERENCES "accounts" ("id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("account_des") REFERENCES "accounts" ("id");

ALTER TABLE "accounts" ADD FOREIGN KEY ("client_id") REFERENCES "clients" ("id");

ALTER TABLE "accounts" ADD FOREIGN KEY ("type") REFERENCES "account_types" ("id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("transaction_type") REFERENCES "transactions_types" ("id");

-- Agregar clientes sobre la DB
insert into clients(id, first_name, last_name, email) values(default, 'Hector', 'Hernandez', 'hector1990@gmail.com');
insert into clients(id, first_name, last_name, email) values(default, 'Diana', 'Hernandez', 'diana90@gmail.com');
insert into clients(id, first_name, last_name, email) values(default, 'Sandra', 'Rodriguez', 'sandra12@gmail.com');
insert into clients(id, first_name, last_name, email) values(default, 'Rodrigo', 'Torres', 'rtorres01@gmail.com');
insert into clients(id, first_name, last_name, email) values(default, 'Andrea', 'Salinas', 'andrea1992@gmail.com');

-- Agregar un tipo de cuenta
insert into account_types (id, name, description) values(default, 'ahorro', 'Cuenta de Ahorro para el banco Academlo, destinada para jovenes universitarios');
insert into account_types (id, name, description) values(default, 'credito basico', 'Cuenta de credito para personas sin historial crediticio');
insert into account_types (id, name, description) values(default, 'credito plus', 'Cuenta de credito para personas con buen historial crediticio');
insert into account_types (id, name, description) values(default, 'debito basico', 'Cuenta de debito con pocos beneficios');

-- Agregar una cuenta y asignarla sobre un cliente (existente)
insert into accounts (id, account_no, client_id, balance, type) values(default, 197996785, 1, 500.00, 2);
insert into accounts (id, account_no, client_id, balance, type) values(default, 187996786, 2, 0.00, 1);
insert into accounts (id, account_no, client_id, balance, type) values(default, 187996795, 2, 10000.00, 3);
insert into accounts (id, account_no, client_id, balance, type) values(default, 197996925, 2, 5000.00, 4);
insert into accounts (id, account_no, client_id, balance, type) values(default, 187996815, 3, 500.00, 2);
insert into accounts (id, account_no, client_id, balance, type) values(default, 197996805, 3, 0.00, 1);
insert into accounts (id, account_no, client_id, balance, type) values(default, 187996895, null, 0.00, 1);
insert into accounts (id, account_no, client_id, balance, type) values(default, 197996905, null, 0.00, 1);

-- Tipos de transacciones
insert into transactions_types(id, name, description) values(default, 'Pago de credito', 'Pago de credito para los clientes (basico y plus)');
insert into transactions_types(id, name, description) values(default, 'Ahorro', 'Deposito a cuenta de ahorro');
insert into transactions_types(id, name, description) values(default, 'Transferencia', 'Transferencia interbancaria');
insert into transactions_types(id, name, description) values(default, 'Pago de servicios', 'Pago de servicio desde una cuenta de ahorro o debito');

-- Transacciones hacía cuentas
insert into transactions (id, account_ori, account_des, amount, transaction_type, trans_date) values(default, 5, 2, 500, 2, NOW());
insert into transactions (id, account_ori, account_des, amount, transaction_type, trans_date) values(default, 5, 2, 700, 2, NOW());
insert into transactions (id, account_ori, account_des, amount, transaction_type, trans_date) values(default, 5, 6, 1000, 3, NOW());
insert into transactions (id, account_ori, account_des, amount, transaction_type, trans_date) values(default, 5, 6, 500, 3, NOW());

select * from clients;
select * from accounts;

-- Respuesta a la pregunta 1
select a.id as id_cliente, a.first_name as nombre, a.last_name as apellido, a.email as email, b.account_no as cuenta, b.balance as saldo from clients as a left join accounts as b on a.id = b.client_id;

-- Respuesta a la pregunta 2
select * from account_types;
select a.account_no as cuenta, a.id as id_cliente, b."name"  from accounts as a left join account_types as b on a."type" = b.id;

-- Respuesta a la pregunta 3
select * from transactions;
select * from transactions_types;

select a.id as transaccion, a.amount as monto, b."name" as tipo_de_transaccion from transactions as a left join transactions_types as b on a.transaction_type = b.id;

-- Respuesta a la pregunta 4
select b.id as transaccion, b.amount as monto, a."name" as tipo_de_transaccion from transactions_types as a left join transactions as b on a.id = b.transaction_type;


-- Creamos las vistas
create view v_clients_accounts as select a.id as id_cliente, a.first_name as nombre, a.last_name as apellido, a.email as email, b.account_no as cuenta, b.balance as saldo from clients as a left join accounts as b on a.id = b.client_id;
select * from v_clients_accounts;

create view v_accounts_types as select a.account_no as cuenta, a.id as id_cliente, b."name"  from accounts as a left join account_types as b on a."type" = b.id;
select * from v_accounts_types;

create view v_transactions_detail as select a.id as transaccion, a.amount as monto, b."name" as tipo_de_transaccion from transactions as a left join transactions_types as b on a.transaction_type = b.id;
select * from v_transactions_detail;

create view v_transations_types_detail as select b.id as transaccion, b.amount as monto, a."name" as tipo_de_transaccion from transactions_types as a left join transactions as b on a.id = b.transaction_type;
select * from v_transations_types_detail;

