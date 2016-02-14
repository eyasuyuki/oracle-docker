FROM oraclelinux:6
MAINTAINER tsubasa1173@gmail.com
### setup
RUN groupadd -g 200 oinstall
RUN groupadd -g 201 dba
RUN groupadd -g 202 oper
RUN useradd -m -g oinstall -G oinstall -u 440 oracle
RUN echo oracle:oracle | /usr/sbin/chpasswd
RUN gpasswd -a oracle dba
RUN gpasswd -a oracle oper
RUN mkdir -p /u01/app/oraInventory
RUN mkdir -p /u01/app/oracle/product/11.2.0/dbhome_1
RUN mkdir -p /u01/app/oradata
COPY db_create.dbt /u01/app/oracle/product/11.2.0/dbhome_1/assistants/dbca/templates/
RUN chown -R oracle:oinstall /u01
RUN yum -y install oracle-rdbms-server-11gR2-preinstall
COPY sysctl.conf /etc/
COPY database /usr/local/src/database
RUN chown -R oracle:oinstall /usr/local/src/database
RUN chmod -R 775 /usr/local/src/database
### install oracle
USER oracle
WORKDIR /usr/local/src/database
RUN ./runInstaller -silent -waitforcompletion -ignoreSysPrereqs \
  -responseFile /usr/local/src/database/response/db_install.rsp \
  -invPtrLoc /u01/app/oracle/product/11.2.0/dbhome_1/oraInst.loc
USER root
RUN /u01/app/oracle/product/11.2.0/dbhome_1/root.sh
### init oracle
COPY .bash_profile /home/oracle/
COPY oracle.sh /home/oracle/
RUN chown -R oracle:oinstall /home/oracle/
### net listener port
EXPOSE 1521
USER oracle
WORKDIR /home/oracle
CMD sh /home/oracle/oracle.sh
