drop database if exists operacion;
create database operacion;
\c operacion;

create table operando (
valor1 int not null,
valor2 int not null,
operacion int not null,
total int not null,
id int not null primary key
);

create table aud_operando (
valor1 int not null,
valor2 int not null,
operacion int not null,
total int not null,
fecha_registro timestamp not null,
usuario varchar(45) not null
);

insert into operando(valor1, valor2, operacion, total, id) values
(4, 3, 1, 7, 1),
(8, 9, 2, -1, 2),
(3, 6, 3, 18, 3);


-- IF

create or replace function pasar() returns Trigger as
$$
begin
	if new.operacion = 1 then
		new.total = new.valor1 + new.valor2;
	elsif new.operacion = 2 then
		new.total = new.valor1 - new.valor2;
	elsif new.operacion = 3 then
		new.total = new.valor1 * new.valor2;
	else
		new.total = new.valor1 / new.valor2;
	end if;
	insert into aud_operando values
	(new.valor1, new.valor2, new.operacion, new.total, current_timestamp, current_user);
	return new;
end
$$
Language plpgsql;

create trigger op_insert
	before insert on operando
	for each row
	execute procedure pasar();