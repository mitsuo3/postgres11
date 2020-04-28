### Docker Desktopを導入すること
https://www.docker.com/products/docker-desktop
Windows or Macを選択してインストールすること

### Docker Desktopインストール後に実施すること
`./docker_build`
PostgreSQL on CentOS 7.6 が導入されている環境のイメージが作成される
`./docker_run`
作成したimageからコンテナを作成する

### run 実行後に実施すること
# コンテナ内へ接続する
`docker ps | grep postgres11`
コンテナのID（Container ID）を確認する
`docker exec -it [Container ID] /bin/bash`
コンテナ内にログインする

# データベースクラスタ作成
```
su - postgres -c initdb
su - postgres -c cp -p /db/work/postgresql.conf /db/pgdata/
su - postgres -c pg_ctl start
su - postgres -c psql -d postgres -c "CREATE EXTENSION pg_stat_statements"
```

# snapshot作成
```
su - postgres -c psql -d postgres -c "select statsinfo.snapshot('manual')"
su - postgres -c psql -d postgres -c "select statsinfo.snapshot('manual')"
```

# pg_stats_reporter設定
```
cp -p /db/work/pg_stats_reporter.ini /etc/
systemctl daemon-reload
systemctl enable httpd
systemctl start httpd
```

### pg_stat_reporterのURL
```
http://localhost:8080/pg_stats_reporter/pg_stats_reporter.php
```