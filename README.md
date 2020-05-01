# 下準備
## Docker Desktopを導入すること
* `https://www.docker.com/products/docker-desktop`  
Windows or Macを選択してインストールすること

## gitからソースダウンロードすること
* `git clone xxxxxxx`  

## Docker Desktopインストール後に実施すること
* `./docker_build`  
PostgreSQL on CentOS 7.6 が導入されている環境のイメージが作成される  
* `./docker_run`  
作成したimageからコンテナを作成する  

# run 実行後に実施すること
## コンテナ内へ接続する
`docker ps | grep postgres11`  
コンテナのID（Container ID）を確認する  
`docker exec -it postgres11 /bin/bash`  
コンテナ内にログインする  

## 初期設定様のコマンドを実行する
`./startup.sh`

## pg_stat_reporterのURL
`http://localhost:10080/pg_stats_reporter/pg_stats_reporter.php`  
pg_stat_reporterが確認できるはず

## GrafaraのDatasourceとしてPrometheusを追加

## Grafanaのダッシュボードで、11376をインポートする
