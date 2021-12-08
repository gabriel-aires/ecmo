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
   	seconds integer
);

create table cpu (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
   	seconds integer,
   	usage real
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
   	total_mb real,
   	used_mb real,
   	free_mb real
);

create table net (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	received_mb real,
	sent_mb real,
	received_packets integer,
	sent_packets integer
);

create table process (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	pid integer,
	name text,
	cmd text,
	cpu real,
	memory text,
	threads text,
	state text,
	parent text
);

create table disk (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	seconds integer,
	size_mb real,
	used_mb real,
	free_mb real,
	usage real
);

create table partition (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
   	mountpoint text,
   	fs_type text,
   	device text
);

create table mount (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	disk_id integer,
	partition_id integer,
	FOREIGN KEY(disk_id) references disk(id),
	FOREIGN KEY(partition_id) references partition(id)
);

create index disk_id_idx ON mount (disk_id);
create index partition_id_idx ON mount (partition_id)
