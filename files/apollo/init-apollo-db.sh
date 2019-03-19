#!/bin/sh
apolloconfigdb_count=$(mysql -uroot ApolloConfigDB -e "show tables" | wc -l)
if [ $apolloconfigdb_count -eq 0 ]
then
	curl https://gitee.com/xhua/OpenshiftOneClick/raw/3.11/files/apollo/apolloconfigdb.sql -O
	curl https://gitee.com/xhua/OpenshiftOneClick/raw/3.11/files/apollo/apolloportaldb.sql -O
	mysql $mysql_flags < apolloconfigdb.sql
	mysql $mysql_flags < apolloportaldb.sql
fi