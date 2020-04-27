## -------------- ##
#FROM centos:latest
FROM centos:7.6.1810
#FROM centos:6.9
## -------------- ##

RUN sed -ie 's@^gpgcheck=1@#gpgcheck=1\ngpgcheck=0@g' /etc/yum.conf
RUN yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN yum -y install postgresql11-server postgresql11-contrib
RUN yum -y install pspg
RUN yum -y install php php-pgsql php-common httpd
RUN userdel postgres
RUN useradd -d /home/postgres postgres
RUN echo export PATH=/usr/pgsql-11/bin:$PATH >> /home/postgres/.bash_profile
RUN echo export PGDATA=/db/pgdata >> /home/postgres/.bash_profile
RUN mkdir -p /db/pgdata
RUN chown postgres. /db/pgdata
## RUN su - postgres -c initdb
COPY --chown=postgres:postgres template/postgresql.conf /db/pgdata/postgresql.conf
COPY --chown=postgres:postgres template/psqlrc /home/postgres/.psqlrc
COPY --chown=postgres:postgres template/pg_stats_reporter-11.0-1.el7.noarch.rpm /home/postgres/pg_stats_reporter-11.0-1.el7.noarch.rpm
COPY --chown=postgres:postgres template/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm /home/postgres/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm
COPY --chown=postgres:postgres template/pg_stats_reporter.ini /tmp/pg_stats_reporter.ini
RUN rpm -ivh /home/postgres/pg_stats_reporter-11.0-1.el7.noarch.rpm
RUN rpm -ivh /home/postgres/pg_statsinfo-11.0-1.pg11.rhel7.x86_64.rpm
## RUN su - postgres -c pg_ctl start 
## RUN psql -d postgres -c "CREATE EXTENSION pg_stat_statements"
## RUN psql -d postgres -c "select statsinfo.snapshot('manual')"
## RUN psql -d postgres -c "select statsinfo.snapshot('manual')"

## -----------------------------------##
### centos 7
## RUN systemctl daemon-reload
## RUN systemctl start httpd.service
## RUN systemctl enable httpd.service

### centos 6.9
#RUN service httpd start
#RUN chkconfig --level 345 httpd on
## -----------------------------------##
