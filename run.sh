#!/bin/bash
mysql_ready() {
mysqladmin ping --host=127.0.0.1 --user=root --password=mypassword > /dev/null 2>&1;
}

docker-compose -f stack.yml up -d;
CID=$(docker-compose -f stack.yml ps -q db);
while !(mysql_ready)
do
   sleep 3;
   echo "waiting for mysql ...";
done

echo "starting the main script";

docker exec $CID /bin/bash -c 'cd /tmp && mysql -u root -pmypassword -e "CREATE DATABASE first_db;
                                              				 CREATE DATABASE second_db;";
	        			  mysql -u root -pmypassword "first_db" < "first_db_dump.sql";
               				  mysql -u root -pmypassword "second_db" < "second_db_dump.sql";';


