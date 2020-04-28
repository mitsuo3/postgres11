## -------------- ##
#FROM centos:latest
FROM centos:7.6.1810
#FROM centos:6.9
## -------------- ##

# PostgreSQL Setting
RUN sed -ie 's@^gpgcheck=1@#gpgcheck=1\ngpgcheck=0@g' /etc/yum.conf
RUN yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN yum -y install postgresql11-server postgresql11-contrib
RUN userdel postgres
RUN useradd -d /home/postgres postgres
RUN echo export PATH=/usr/pgsql-11/bin:$PATH >> /home/postgres/.bash_profile
RUN echo export PGDATA=/db/pgdata >> /home/postgres/.bash_profile
RUN mkdir -p /db/pgdata
RUN chown postgres. /db/pgdata
COPY --chown=postgres:postgres template/postgresql.conf /db/pgdata/postgresql.conf

# PostgreSQL ADD Setting
RUN yum -y install pspg
RUN yum -y install php php-pgsql php-common httpd
COPY --chown=postgres:postgres template/pg_stats_reporter-11.0-1.el7.noarch.rpm /home/postgres/pg_stats_reporter-11.0-1.el7.noarch.rpm
COPY --chown=postgres:postgres template/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm /home/postgres/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm
RUN rpm -ivh /home/postgres/pg_stats_reporter-11.0-1.el7.noarch.rpm
RUN rpm -ivh /home/postgres/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm
COPY --chown=postgres:postgres template/psqlrc /home/postgres/.psqlrc
COPY --chown=postgres:postgres template/pg_stats_reporter.ini /tmp/pg_stats_reporter.ini

# Grafana install
COPY --chown=root:root template/grafana.repo /etc/yum.repos.d/grafana.repo
RUN yum clean all
RUN yum repolist all
RUN yum -y install grafana

# Prometheus install
RUN yum -y install wget
RUN mkdir /usr/local/src/prometheus
RUN cd /usr/local/src/prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.3.2/prometheus-2.3.2.linux-amd64.tar.gz
RUN tar zxvf prometheus-2.3.2.linux-amd64.tar.gz
RUN mv prometheus-2.3.2.linux-amd64 prometheus-server
RUN cd prometheus-server
COPY --chown=root:root template/prometheus.yml /usr/local/src/prometheus/prometheus-server/prometheus.yml

# node_exporter install
RUN cd /usr/local/src/prometheus
RUN wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz
RUN tar zxvf node_exporter-0.16.0.linux-amd64.tar.gz
RUN mv node_exporter-0.16.0.linux-amd64 node_exporter


## -----------------------------------##
### centos 7
## RUN systemctl daemon-reload
## RUN systemctl start httpd.service
## RUN systemctl enable httpd.service

### centos 6.9
#RUN service httpd start
#RUN chkconfig --level 345 httpd on
## -----------------------------------##
