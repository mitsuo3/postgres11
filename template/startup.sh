#!/usr/bin/bash

## PostgreSQL Start 
su - postgres -c /home/postgres/startup_postgres.sh

## httpd(pg_stats_reporter用)
systemctl daemon-reload
systemctl enable httpd
systemctl start httpd

## grafana start
systemctl enable grafana-server
systemctl start grafana-server

## Prometheus Start
nohup /usr/local/src/prometheus/prometheus-server/prometheus --config.file=/usr/local/src/prometheus/prometheus-server/prometheus.yml &

## exporter start
nohup /usr/local/src/prometheus/node_exporter/node_exporter &
