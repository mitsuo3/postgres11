# postgres11

### run 実行後に実施すること
# データベースクラスタ作成
su - postgres -c initdb
su - postgres -c cp -p /db/work/postgresql.conf /db/pgdata/
su - postgres -c pg_ctl start
su - postgres -c psql -d postgres -c "CREATE EXTENSION pg_stat_statements"

# snapshot作成
su - postgres -c psql -d postgres -c "select statsinfo.snapshot('manual')"
su - postgres -c psql -d postgres -c "select statsinfo.snapshot('manual')"

# pg_stats_reporter設定
cp -p /db/work/pg_stats_reporter.ini /etc/
systemctl daemon-reload
systemctl enable httpd
systemctl start httpd

### pg_stat_reporterのURL
http://localhost:8080/pg_stats_reporter/pg_stats_reporter.php