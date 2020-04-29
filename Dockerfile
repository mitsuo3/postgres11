## -------------- ##
#FROM centos:latest
FROM centos:7.6.1810
#FROM centos:6.9
## -------------- ##

# PostgreSQL Setting
RUN sed -ie 's@^gpgcheck=1@#gpgcheck=1\ngpgcheck=0@g' /etc/yum.conf \
 && yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
 && yum -y install postgresql11-server postgresql11-contrib \
 && yum -y install postgresql11-server postgresql11-contrib \
 && userdel postgres \
 && useradd -d /home/postgres postgres \
 && echo export PATH=/usr/pgsql-11/bin:$PATH >> /home/postgres/.bash_profile \
 && echo export PGDATA=/db/pgdata >> /home/postgres/.bash_profile \
 && mkdir -p /db/pgdata \
 && chown postgres. /db/pgdata \
 && su - postgres -c initdb
COPY --chown=postgres:postgres template/postgresql.conf /db/pgdata/postgresql.conf

# PostgreSQL ADD Setting
# (pg_statsinfo)
COPY --chown=postgres:postgres template/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm /home/postgres/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm
RUN rpm -ivh /home/postgres/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm
COPY --chown=postgres:postgres template/pg_stats_reporter-11.0-1.el7.noarch.rpm /home/postgres/pg_stats_reporter-11.0-1.el7.noarch.rpm
# (pg_stats_reporter)
RUN yum -y install php php-pgsql php-common httpd \
 && rpm -ivh /home/postgres/pg_stats_reporter-11.0-1.el7.noarch.rpm \
 && mv /etc/pg_stats_reporter.ini /etc/pg_stats_reporter.ini.org
COPY --chown=postgres:postgres template/pg_stats_reporter.ini /tmp/pg_stats_reporter.ini
# (pspg)
RUN yum -y install pspg
COPY --chown=postgres:postgres template/psqlrc /home/postgres/.psqlrc

# PostgreSQL Start
RUN chown postgres. /var/run/postgresql
RUN su - postgres -c 'pg_ctl -D /db/pgdata start' \
 && su - postgres -c 'psql -d postgres -c "CREATE EXTENSION pg_stat_statements"'

# Grafana install
COPY --chown=root:root template/grafana.repo /etc/yum.repos.d/grafana.repo
RUN yum clean all \
 && yum repolist all \
 && yum -y install grafana

# Prometheus install
RUN yum -y install wget \
 && mkdir /usr/local/src/prometheus \
 && cd /usr/local/src/prometheus \
 && wget https://github.com/prometheus/prometheus/releases/download/v2.3.2/prometheus-2.3.2.linux-amd64.tar.gz \
 && tar zxvf prometheus-2.3.2.linux-amd64.tar.gz \
 && rm -f prometheus-2.3.2.linux-amd64.tar.gz \
 && mv prometheus-2.3.2.linux-amd64 prometheus-server
COPY --chown=root:root template/prometheus.yml /usr/local/src/prometheus/prometheus-server/prometheus.yml

# node_exporter install
RUN cd /usr/local/src/prometheus \
 && wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz \
 && tar zxvf node_exporter-0.16.0.linux-amd64.tar.gz \
 && rm -f node_exporter-0.16.0.linux-amd64.tar.gz \
 && mv node_exporter-0.16.0.linux-amd64 node_exporter

# postgres_exporter install
RUN cd /usr/local/src/prometheus \
 && wget https://github.com/wrouesnel/postgres_exporter/releases/download/v0.8.0/postgres_exporter_v0.8.0_linux-amd64.tar.gz \
 && tar zxvf postgres_exporter_v0.8.0_linux-amd64.tar.gz \
 && rm -f postgres_exporter_v0.8.0_linux-amd64.tar.gz \
 && mv node_exporter-0.16.0.linux-amd64 node_exporter



