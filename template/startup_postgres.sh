#!/usr/bin/bash
pg_ctl start
psql -d postgres -c "select statsinfo.snapshot('manual')"
psql -d postgres -c "select statsinfo.snapshot('manual')"
nohup /usr/local/src/prometheus/postgres_exporter/postgres_exporter &
