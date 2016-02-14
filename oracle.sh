#!/bin/bash
source /home/oracle/.bash_profile
HOSTNAME=$(hostname)
ORACLE_PASSWD="Oracle11g"
### create listener.ora
echo -e "LISTENER=(DESCRIPTION_LIST=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${HOSTNAME})(PORT=1521))(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC))))\n" > ${ORACLE_HOME}/network/admin/listener.ora
### listener start
${ORACLE_HOME}/bin/lsnrctl start
### run dbca
${ORACLE_HOME}/bin/dbca -silent -createDatabase -templateName db_create.dbt -gdbname ${ORACLE_SID} -sid ${ORACLE_SID} -sysPassword ${ORACLE_PASSWD} -systemPassword ${ORACLE_PASSWD}
### tail alertlog
tail -f ${ORACLE_BASE}/diag/rdbms/${ORACLE_SID}/${ORACLE_SID}/trace/alert_${ORACLE_SID}.log &
wait
