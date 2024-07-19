FROM ghcr.io/oracle/oraclelinux8-instantclient:19

RUN yum install dos2unix traceroute \
&& yum clean all

# copy the rest of the backend files:
COPY ./src /usr/src

# convert the shell script to unix line endings
RUN dos2unix /usr/src/scripts/*.sh \
&& dos2unix /usr/src/scripts/sh_script_config/*.sh

# change directory to the SQL source directory
WORKDIR /usr/src/SQL

CMD ["bash", "../scripts/run_query_metrics.sh"]