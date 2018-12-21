# My_Page
----데이터베이스----

create database mpage;
use mpage;

create table User(
ID varchar(10) not null,
PW varchar(15) not null,
Find_PW int(1) not null,
Answer varchar(15) not null,
primary key(ID)
);

create table Plan(
P_No int(10) not null,
U_ID varchar(10) not null,
P_Text varchar(40) not null,
primary key(P_No)
);

create table Mon(
M_No int(10) not null,
M_ID varchar(10) not null,
M_Date varchar(10) not null,
M_Money int(10) not null,
M_Text varchar(40),
primary key(M_No)
);
