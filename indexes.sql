
create index id_1 on consultation (VAT_doctor) using hash;

create index id_score on supervision_report (evaluation) using BTREE;

create fulltext index idx on supervision_report(description);
