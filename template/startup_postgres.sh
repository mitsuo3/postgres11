#!/usr/bin/bash
@echo off

# PostgreSQL Start
pg_ctl start

# Create Snapshot
psql -d postgres -c "select statsinfo.snapshot('manual')"
psql -d postgres -c "select statsinfo.snapshot('manual')"

# Postgres exporter Start
nohup /usr/local/src/prometheus/postgres_exporter/postgres_exporter &
