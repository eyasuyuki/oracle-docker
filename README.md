### Deploy the Install Files
Both disk 1 and disk 2 should have been unzipped into the same database directory. It stores the directory to ./ .

### Run this oracle image with:
`$ docker run -p 1521:1521 --ipc=host --name oracle-docker --hostname oracle-docker tsubauaaa/oracle-docker`

### Connect this oracle with:
`$ sqlplus system/Oracle11g@192.168.0.10/orcl`
