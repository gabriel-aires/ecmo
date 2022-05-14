PRAGMA journal_mode=WAL;

create table host (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
 	name text,
 	os text,
 	uptime integer,
 	arch text
);

create table boot (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  seconds integer,
  uptime integer
);

create table load (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	load1 real,
	load5 real,
	load15 real
);

create table memory (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
 	seconds integer,
 	ram_size_mb real,
 	ram_used_mb real,
 	ram_free_mb real,
 	swp_size_mb real,
 	swp_used_mb real,
 	swp_free_mb real
);

create table net (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	received_mb real,
	sent_mb real,
	received_packets integer,
	sent_packets integer
);

create table command (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name text,
	line text
);

create table process (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	pid integer,
	memory real,
	threads text,
	state text,
	parent text,
	command_id integer,
	FOREIGN KEY(command_id) references command(id)
);

create table service (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	running integer,
	enabled integer,
	name text
);

create table partition (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
 	mountpoint text,
 	fs_type text,
 	device text
);

create table disk (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	size_mb real,
	used_mb real,
	free_mb real,
	usage real,
	partition_id integer,	
	FOREIGN KEY(partition_id) references partition(id)	
);

create table job (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
 	path text,
 	name text,
 	cron text,
 	rev integer,
 	log text
);

create table run (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	duration integer,
	output text,
	error text,
	success integer,
	job_id integer,	
	FOREIGN KEY(job_id) references job(id)	
);

create index command_id_idx ON process (command_id);
create index partition_id_idx ON disk (partition_id);
create index job_id_idx ON run (job_id)
