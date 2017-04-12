Ubuntu based container with Apache Cassandra for development purpose

## Run a Cassandra cluster

Suppose you'd like to spin up a Cassandra cluster with 4 nodes. You can do this by executing the following commands (tested with Cassandra 3.6 and Cassandra 3.7).


```shell
docker run --name master_node -dt oscerd/cassandra
```

This way you'll have a single node in the cluster. Now we have to add the others. Let's add the node 1.


```shell
docker run --name node1 -d -e SEED="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' master_node)" oscerd/cassandra
```

The environment variable SEED, when defined, will add the seeds information into cassandra.yaml configuration file. We will need to do the same for the node 2 and node 3.

```shell
docker run --name node2 -d -e SEED="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' master_node)" oscerd/cassandra
docker run --name node3 -d -e SEED="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' master_node)" oscerd/cassandra
```

After a while you should be able to see the cluster up and running. You can check the status with the following command.

```shell
docker exec -ti master_node /opt/cassandra/bin/nodetool status
```

and get the following output (if everything is up and running):

```shell
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens       Owns (effective)  Host ID                               Rack
UN  172.17.0.3  97.53 KiB  256          52.0%             c125152e-d155-4826-92a2-fca2d33ec2c5  rack1
UN  172.17.0.2  107.59 KiB  256          48.4%             bd2cb8c1-9995-4669-9eb7-15f029ca654f  rack1
UN  172.17.0.5  245.41 KiB  256          49.9%             97de78c6-f9db-4154-b7d8-588dd4f275ac  rack1
UN  172.17.0.4  88.39 KiB  256          49.7%             e9d049db-ad52-42e0-b38a-79e4ad400ef3  rack1
```

We have our cluster running now. Let's try to write something. 

I suppose you have a local copy of Apache Cassandra 3.6. Run the following command:

```shell
<LOCAL_CASSANDRA_HOME>/bin/cqlsh $(docker inspect --format='{{ .NetworkSettings.IPAddress }}' master_node)
```

Now we should be able to create a keyspace and a table.

```shell
Connected to Test Cluster at 172.17.0.2:9042.
[cqlsh 5.0.1 | Cassandra 3.6 | CQL spec 3.4.2 | Native protocol v4]
Use HELP for help.
cqlsh> 
```

Copy the following instructions in your cqlsh prompt:

```shell
create keyspace test with replication = {'class':'SimpleStrategy', 'replication_factor':3};
use test;
create table users ( id int primary key, name text );
insert into users (id,name) values (1, 'oscerd');
quit;
```

and run a simple query:

```shell
cqlsh> use test;
cqlsh:test> select * from users;

 id | name
----+--------
  1 | oscerd

(1 rows)
cqlsh:test> 
```

Now we have to check the other nodes:

```shell
<LOCAL_CASSANDRA_HOME>/bin/cqlsh $(docker inspect --format='{{ .NetworkSettings.IPAddress }}' node1)
Connected to Test Cluster at 172.17.0.3:9042.
[cqlsh 5.0.1 | Cassandra 3.6 | CQL spec 3.4.2 | Native protocol v4]
Use HELP for help.
cqlsh> use test;
cqlsh:test> select * from users;

 id | name
----+--------
  1 | oscerd

(1 rows)
cqlsh:test> insert into users (id,name) values (2, 'anotheruser');
cqlsh:test> select * from users;

 id | name
----+-------------
  1 |      oscerd
  2 | anotheruser

(2 rows)
cqlsh:test> 
```

let's take a look at node3 now, for example:

```shell
<LOCAL_CASSANDRA_HOME>/bin/cqlsh $(docker inspect --format='{{ .NetworkSettings.IPAddress }}' node3)
Connected to Test Cluster at 172.17.0.5:9042.
[cqlsh 5.0.1 | Cassandra 3.6 | CQL spec 3.4.2 | Native protocol v4]
Use HELP for help.
cqlsh> use test;
cqlsh:test> select * from users;

 id | name
----+-------------
  1 |      oscerd
  2 | anotheruser

(2 rows)
cqlsh:test> 
```

We can check the status of our cluster once again:

```shell
docker exec -ti master_node /opt/cassandra/bin/nodetool status 
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens       Owns (effective)  Host ID                               Rack
UN  172.17.0.3  104.14 KiB  256          52.0%             c125152e-d155-4826-92a2-fca2d33ec2c5  rack1
UN  172.17.0.2  79.17 KiB  256          48.4%             bd2cb8c1-9995-4669-9eb7-15f029ca654f  rack1
UN  172.17.0.5  146.83 KiB  256          49.9%             97de78c6-f9db-4154-b7d8-588dd4f275ac  rack1
UN  172.17.0.4  110.09 KiB  256          49.7%             e9d049db-ad52-42e0-b38a-79e4ad400ef3  rack1
```

## Pull Images

Actually this Docker container supports:

- Apache Cassandra 3.10
- Apache Cassandra 3.9
- Apache Cassandra 3.7
- Apache Cassandra 3.6
- Apache Cassandra 3.5
- Apache Cassandra 3.4
- Apache Cassandra 3.3
- Apache Cassandra 3.2.1
- Apache Cassandra 3.2
- Apache Cassandra 3.1.1
- Apache Cassandra 3.1
- Apache Cassandra 3.0.12
- Apache Cassandra 3.0.10
- Apache Cassandra 3.0.9
- Apache Cassandra 3.0.8
- Apache Cassandra 3.0.7
- Apache Cassandra 3.0.6
- Apache Cassandra 3.0.5
- Apache Cassandra 3.0.4
- Apache Cassandra 3.0.3
- Apache Cassandra 3.0.2
- Apache Cassandra 3.0.1
- Apache Cassandra 3.0.0
- Apache Cassandra 2.2.9
- Apache Cassandra 2.2.8
- Apache Cassandra 2.2.7
- Apache Cassandra 2.2.6
- Apache Cassandra 2.2.5
- Apache Cassandra 2.2.4
- Apache Cassandra 2.2.3
- Apache Cassandra 2.2.2
- Apache Cassandra 2.2.1
- Apache Cassandra 2.2.0
- Apache Cassandra 2.1.17
- Apache Cassandra 2.1.16
- Apache Cassandra 2.1.15
- Apache Cassandra 2.1.14
- Apache Cassandra 2.1.13
- Apache Cassandra 2.1.12
- Apache Cassandra 2.1.11
- Apache Cassandra 2.1.10
- Apache Cassandra 2.1.9
- Apache Cassandra 2.1.8
- Apache Cassandra 2.1.7
- Apache Cassandra 2.1.6
- Apache Cassandra 2.1.5
- Apache Cassandra 2.1.4
- Apache Cassandra 2.1.3
- Apache Cassandra 2.1.2
- Apache Cassandra 2.1.1
- Apache Cassandra 2.1.0
- Apache Cassandra 2.0.17
- Apache Cassandra 2.0.16
- Apache Cassandra 2.0.15
- Apache Cassandra 2.0.14
- Apache Cassandra 2.0.13
- Apache Cassandra 2.0.12
- Apache Cassandra 2.0.11
- Apache Cassandra 2.0.10
- Apache Cassandra 2.0.9
- Apache Cassandra 2.0.8
- Apache Cassandra 2.0.7
- Apache Cassandra 2.0.6
- Apache Cassandra 2.0.5
- Apache Cassandra 2.0.4
- Apache Cassandra 2.0.3
- Apache Cassandra 2.0.2
- Apache Cassandra 2.0.1
- Apache Cassandra 2.0.0

Pull the image.

Apache Cassandra 3.10

```
docker pull oscerd/cassandra
```

Apache Cassandra 3.9

```
docker pull oscerd/cassandra:cassandra-3.9
```

Apache Cassandra 3.7

```
docker pull oscerd/cassandra:cassandra-3.7
```

Apache Cassandra 3.6

```
docker pull oscerd/cassandra:cassandra-3.6
```

Apache Cassandra 3.5

```
docker pull oscerd/cassandra:cassandra-3.5
```

Apache Cassandra 3.4

```
docker pull oscerd/cassandra:cassandra-3.4
```

Apache Cassandra 3.3

```
docker pull oscerd/cassandra:cassandra-3.3
```

Apache Cassandra 3.2.1

```
docker pull oscerd/cassandra:cassandra-3.2.1
```

Apache Cassandra 3.2

```
docker pull oscerd/cassandra:cassandra-3.2
```

Apache Cassandra 3.1.1

```
docker pull oscerd/cassandra:cassandra-3.1.1
```

Apache Cassandra 3.1

```
docker pull oscerd/cassandra:cassandra-3.1
```

Apache Cassandra 3.0.12

```
docker pull oscerd/cassandra:cassandra-3.0.12
```

Apache Cassandra 3.0.10

```
docker pull oscerd/cassandra:cassandra-3.0.10
```

Apache Cassandra 3.0.9

```
docker pull oscerd/cassandra:cassandra-3.0.9
```

Apache Cassandra 3.0.8

```
docker pull oscerd/cassandra:cassandra-3.0.8
```

Apache Cassandra 3.0.7

```
docker pull oscerd/cassandra:cassandra-3.0.7
```

Apache Cassandra 3.0.6

```
docker pull oscerd/cassandra:cassandra-3.0.6
```

Apache Cassandra 3.0.5

```
docker pull oscerd/cassandra:cassandra-3.0.5
```

Apache Cassandra 3.0.4

```
docker pull oscerd/cassandra:cassandra-3.0.4
```

Apache Cassandra 3.0.3

```
docker pull oscerd/cassandra:cassandra-3.0.3
```

Apache Cassandra 3.0.2

```
docker pull oscerd/cassandra:cassandra-3.0.2
```

Apache Cassandra 3.0.1

```
docker pull oscerd/cassandra:cassandra-3.0.1
```

Apache Cassandra 3.0.0

```
docker pull oscerd/cassandra:cassandra-3.0.0
```

Apache Cassandra 2.2.9

```
docker pull oscerd/cassandra:cassandra-2.2.9
```

Apache Cassandra 2.2.8

```
docker pull oscerd/cassandra:cassandra-2.2.8
```

Apache Cassandra 2.2.7

```
docker pull oscerd/cassandra:cassandra-2.2.7
```

Apache Cassandra 2.2.6

```
docker pull oscerd/cassandra:cassandra-2.2.6
```

Apache Cassandra 2.2.5

```
docker pull oscerd/cassandra:cassandra-2.2.5
```

Apache Cassandra 2.2.4

```
docker pull oscerd/cassandra:cassandra-2.2.4
```

Apache Cassandra 2.2.3

```
docker pull oscerd/cassandra:cassandra-2.2.3
```

Apache Cassandra 2.2.2

```
docker pull oscerd/cassandra:cassandra-2.2.2
```

Apache Cassandra 2.2.1

```
docker pull oscerd/cassandra:cassandra-2.2.1
```

Apache Cassandra 2.2.0:

```
docker pull oscerd/cassandra:cassandra-2.2.0
```

Apache Cassandra 2.1.17:

```
docker pull oscerd/cassandra:cassandra-2.1.17
```

Apache Cassandra 2.1.16:

```
docker pull oscerd/cassandra:cassandra-2.1.16
```

Apache Cassandra 2.1.15:

```
docker pull oscerd/cassandra:cassandra-2.1.15
```

Apache Cassandra 2.1.14:

```
docker pull oscerd/cassandra:cassandra-2.1.14
```

Apache Cassandra 2.1.13:

```
docker pull oscerd/cassandra:cassandra-2.1.13
```

Apache Cassandra 2.1.12:

```
docker pull oscerd/cassandra:cassandra-2.1.12
```

Apache Cassandra 2.1.11:

```
docker pull oscerd/cassandra:cassandra-2.1.11
```

Apache Cassandra 2.1.10:

```
docker pull oscerd/cassandra:cassandra-2.1.10
```

Apache Cassandra 2.1.9:

```
docker pull oscerd/cassandra:cassandra-2.1.9
```

Apache Cassandra 2.1.8:

```
docker pull oscerd/cassandra:cassandra-2.1.8
```

Apache Cassandra 2.1.7:

```
docker pull oscerd/cassandra:cassandra-2.1.7
```

Apache Cassandra 2.1.6:

```
docker pull oscerd/cassandra:cassandra-2.1.6
```

Apache Cassandra 2.1.5:

```
docker pull oscerd/cassandra:cassandra-2.1.5
```

Apache Cassandra 2.1.4:

```
docker pull oscerd/cassandra:cassandra-2.1.4
```

Apache Cassandra 2.1.3:

```
docker pull oscerd/cassandra:cassandra-2.1.3
```

Apache Cassandra 2.1.2:

```
docker pull oscerd/cassandra:cassandra-2.1.2
```

Apache Cassandra 2.1.1:

```
docker pull oscerd/cassandra:cassandra-2.1.1
```

Apache Cassandra 2.1.0:

```
docker pull oscerd/cassandra:cassandra-2.1.0
```

Apache Cassandra 2.0.17:

```
docker pull oscerd/cassandra:cassandra-2.0.17
```

Apache Cassandra 2.0.16:

```
docker pull oscerd/cassandra:cassandra-2.0.16
```

Apache Cassandra 2.0.15:

```
docker pull oscerd/cassandra:cassandra-2.0.15
```

Apache Cassandra 2.0.14:

```
docker pull oscerd/cassandra:cassandra-2.0.14
```

Apache Cassandra 2.0.13:

```
docker pull oscerd/cassandra:cassandra-2.0.13
```

Apache Cassandra 2.0.12:

```
docker pull oscerd/cassandra:cassandra-2.0.12
```

Apache Cassandra 2.0.11:

```
docker pull oscerd/cassandra:cassandra-2.0.11
```

Apache Cassandra 2.0.10:

```
docker pull oscerd/cassandra:cassandra-2.0.10
```

Apache Cassandra 2.0.9:

```
docker pull oscerd/cassandra:cassandra-2.0.9
```

Apache Cassandra 2.0.8:

```
docker pull oscerd/cassandra:cassandra-2.0.8
```

Apache Cassandra 2.0.7:

```
docker pull oscerd/cassandra:cassandra-2.0.7
```

Apache Cassandra 2.0.6:

```
docker pull oscerd/cassandra:cassandra-2.0.6
```

Apache Cassandra 2.0.5:

```
docker pull oscerd/cassandra:cassandra-2.0.5
```

Apache Cassandra 2.0.4:

```
docker pull oscerd/cassandra:cassandra-2.0.4
```

Apache Cassandra 2.0.3:

```
docker pull oscerd/cassandra:cassandra-2.0.3
```

Apache Cassandra 2.0.2:

```
docker pull oscerd/cassandra:cassandra-2.0.2
```

Apache Cassandra 2.0.1:

```
docker pull oscerd/cassandra:cassandra-2.0.1
```

Apache Cassandra 2.0.0:

```
docker pull oscerd/cassandra:cassandra-2.0.0
```

## Run containers

Run containers

Apache Cassandra 3.10:

```
docker run --name container_cassandra3.10 -dt oscerd/cassandra
```

Apache Cassandra 3.9:

```
docker run --name container_cassandra3.9 -dt oscerd/cassandra:cassandra-3.9
```

Apache Cassandra 3.7:

```
docker run --name container_cassandra3.7 -dt oscerd/cassandra:cassandra-3.7
```

Apache Cassandra 3.6:

```
docker run --name container_cassandra3.6 -dt oscerd/cassandra:cassandra-3.6
```

Apache Cassandra 3.5:

```
docker run --name container_cassandra3.5 -dt oscerd/cassandra:cassandra-3.5
```

Apache Cassandra 3.4:

```
docker run --name container_cassandra3.4 -dt oscerd/cassandra:cassandra-3.4
```

Apache Cassandra 3.3:

```
docker run --name container_cassandra3.3 -dt oscerd/cassandra:cassandra-3.3
```

Apache Cassandra 3.2.1:

```
docker run --name container_cassandra3.2.1 -dt oscerd/cassandra:cassandra-3.2.1
```

Apache Cassandra 3.2:

```
docker run --name container_cassandra3.2 -dt oscerd/cassandra:cassandra-3.2
```

Apache Cassandra 3.1.1:

```
docker run --name container_cassandra3.1.1 -dt oscerd/cassandra:cassandra-3.1.1
```

Apache Cassandra 3.1:

```
docker run --name container_cassandra3.1 -dt oscerd/cassandra:cassandra-3.1
```

Apache Cassandra 3.0.12:

```
docker run --name container_cassandra3.0.12 -dt oscerd/cassandra:cassandra-3.0.12
```

Apache Cassandra 3.0.10:

```
docker run --name container_cassandra3.0.10 -dt oscerd/cassandra:cassandra-3.0.10
```

Apache Cassandra 3.0.9:

```
docker run --name container_cassandra3.0.9 -dt oscerd/cassandra:cassandra-3.0.9
```

Apache Cassandra 3.0.8:

```
docker run --name container_cassandra3.0.8 -dt oscerd/cassandra:cassandra-3.0.8
```

Apache Cassandra 3.0.7:

```
docker run --name container_cassandra3.0.7 -dt oscerd/cassandra:cassandra-3.0.7
```

Apache Cassandra 3.0.6:

```
docker run --name container_cassandra3.0.6 -dt oscerd/cassandra:cassandra-3.0.6
```

Apache Cassandra 3.0.5:

```
docker run --name container_cassandra3.0.5 -dt oscerd/cassandra:cassandra-3.0.5
```

Apache Cassandra 3.0.4:

```
docker run --name container_cassandra3.0.4 -dt oscerd/cassandra:cassandra-3.0.4
```

Apache Cassandra 3.0.3:

```
docker run --name container_cassandra3.0.3 -dt oscerd/cassandra:cassandra-3.0.3
```

Apache Cassandra 3.0.2:

```
docker run --name container_cassandra3.0.2 -dt oscerd/cassandra:cassandra-3.0.2
```

Apache Cassandra 3.0.1:

```
docker run --name container_cassandra3.0.1 -dt oscerd/cassandra:cassandra-3.0.1
```

Apache Cassandra 3.0.0:

```
docker run --name container_cassandra3.0.0 -dt oscerd/cassandra:cassandra-3.0.0
```

Apache Cassandra 2.2.9:

```
docker run --name container_cassandra2.2.9 -dt oscerd/cassandra:cassandra-2.2.9
```

Apache Cassandra 2.2.8:

```
docker run --name container_cassandra2.2.8 -dt oscerd/cassandra:cassandra-2.2.8
```

Apache Cassandra 2.2.7:

```
docker run --name container_cassandra2.2.7 -dt oscerd/cassandra:cassandra-2.2.7
```

Apache Cassandra 2.2.6:

```
docker run --name container_cassandra2.2.6 -dt oscerd/cassandra:cassandra-2.2.6
```

Apache Cassandra 2.2.5:

```
docker run --name container_cassandra2.2.5 -dt oscerd/cassandra:cassandra-2.2.5
```

Apache Cassandra 2.2.4:

```
docker run --name container_cassandra2.2.4 -dt oscerd/cassandra:cassandra-2.2.4
```

Apache Cassandra 2.2.3:

```
docker run --name container_cassandra2.2.3 -dt oscerd/cassandra:cassandra-2.2.3
```

Apache Cassandra 2.2.2:

```
docker run --name container_cassandra2.2.2 -dt oscerd/cassandra:cassandra-2.2.2
```

Apache Cassandra 2.2.1:

```
docker run --name container_cassandra2.2.1 -dt oscerd/cassandra:cassandra-2.2.1
```

Apache Cassandra 2.2.0:

```
docker run --name container_cassandra2.2.0 -dt oscerd/cassandra:cassandra-2.2.0
```

Apache Cassandra 2.1.17:

```
docker run --name container_cassandra2.1.17 -dt oscerd/cassandra:cassandra-2.1.17
```

Apache Cassandra 2.1.16:

```
docker run --name container_cassandra2.1.16 -dt oscerd/cassandra:cassandra-2.1.16
```

Apache Cassandra 2.1.15:

```
docker run --name container_cassandra2.1.15 -dt oscerd/cassandra:cassandra-2.1.15
```

Apache Cassandra 2.1.14:

```
docker run --name container_cassandra2.1.14 -dt oscerd/cassandra:cassandra-2.1.14
```

Apache Cassandra 2.1.13:

```
docker run --name container_cassandra2.1.13 -dt oscerd/cassandra:cassandra-2.1.13
```

Apache Cassandra 2.1.12:

```
docker run --name container_cassandra2.1.12 -dt oscerd/cassandra:cassandra-2.1.12
```

Apache Cassandra 2.1.11:

```
docker run --name container_cassandra2.1.11 -dt oscerd/cassandra:cassandra-2.1.11
```

Apache Cassandra 2.1.10:

```
docker run --name container_cassandra2.1.10 -dt oscerd/cassandra:cassandra-2.1.10
```

Apache Cassandra 2.1.9:

```
docker run --name container_cassandra2.1.9 -dt oscerd/cassandra:cassandra-2.1.9
```

Apache Cassandra 2.1.8:

```
docker run --name container_cassandra2.1.8 -dt oscerd/cassandra:cassandra-2.1.8
```

Apache Cassandra 2.1.7:

```
docker run --name container_cassandra2.1.7 -dt oscerd/cassandra:cassandra-2.1.7
```

Apache Cassandra 2.1.6:

```
docker run --name container_cassandra2.1.6 -dt oscerd/cassandra:cassandra-2.1.6
```

Apache Cassandra 2.1.5:

```
docker run --name container_cassandra2.1.5 -dt oscerd/cassandra:cassandra-2.1.5
```

Apache Cassandra 2.1.4:

```
docker run --name container_cassandra2.1.4 -dt oscerd/cassandra:cassandra-2.1.4
```

Apache Cassandra 2.1.3:

```
docker run --name container_cassandra2.1.3 -dt oscerd/cassandra:cassandra-2.1.3
```

Apache Cassandra 2.1.2:

```
docker run --name container_cassandra2.1.2 -dt oscerd/cassandra:cassandra-2.1.2
```

Apache Cassandra 2.1.1:

```
docker run --name container_cassandra2.1.1 -dt oscerd/cassandra:cassandra-2.1.1
```

Apache Cassandra 2.1.0:

```
docker run --name container_cassandra2.1.0 -dt oscerd/cassandra:cassandra-2.1.0
```

Apache Cassandra 2.0.17:

```
docker run --name container_cassandra2.0.17 -dt oscerd/cassandra:cassandra-2.0.17
```

Apache Cassandra 2.0.16:

```
docker run --name container_cassandra2.0.16 -dt oscerd/cassandra:cassandra-2.0.16
```

Apache Cassandra 2.0.15:

```
docker run --name container_cassandra2.0.15 -dt oscerd/cassandra:cassandra-2.0.15
```

Apache Cassandra 2.0.14:

```
docker run --name container_cassandra2.0.14 -dt oscerd/cassandra:cassandra-2.0.14
```

Apache Cassandra 2.0.13:

```
docker run --name container_cassandra2.0.13 -dt oscerd/cassandra:cassandra-2.0.13
```

Apache Cassandra 2.0.12:

```
docker run --name container_cassandra2.0.12 -dt oscerd/cassandra:cassandra-2.0.12
```

Apache Cassandra 2.0.11:

```
docker run --name container_cassandra2.0.11 -dt oscerd/cassandra:cassandra-2.0.11
```

Apache Cassandra 2.0.10:

```
docker run --name container_cassandra2.0.10 -dt oscerd/cassandra:cassandra-2.0.10
```

Apache Cassandra 2.0.9:

```
docker run --name container_cassandra2.0.9 -dt oscerd/cassandra:cassandra-2.0.9
```

Apache Cassandra 2.0.8:

```
docker run --name container_cassandra2.0.8 -dt oscerd/cassandra:cassandra-2.0.8
```

Apache Cassandra 2.0.7:

```
docker run --name container_cassandra2.0.7 -dt oscerd/cassandra:cassandra-2.0.7
```

Apache Cassandra 2.0.6:

```
docker run --name container_cassandra2.0.6 -dt oscerd/cassandra:cassandra-2.0.6
```

Apache Cassandra 2.0.5:

```
docker run --name container_cassandra2.0.5 -dt oscerd/cassandra:cassandra-2.0.5
```

Apache Cassandra 2.0.4:

```
docker run --name container_cassandra2.0.4 -dt oscerd/cassandra:cassandra-2.0.4
```

Apache Cassandra 2.0.3:

```
docker run --name container_cassandra2.0.3 -dt oscerd/cassandra:cassandra-2.0.3
```

Apache Cassandra 2.0.2:

```
docker run --name container_cassandra2.0.2 -dt oscerd/cassandra:cassandra-2.0.2
```

Apache Cassandra 2.0.1:

```
docker run --name container_cassandra2.0.1 -dt oscerd/cassandra:cassandra-2.0.1
```

Apache Cassandra 2.0.0:

```
docker run --name container_cassandra2.0.0 -dt oscerd/cassandra:cassandra-2.0.0
```

## Connect to a running container

Suppose your running container is named cass_test you can execute:

```
docker exec -ti cass_test /bin/bash
```
