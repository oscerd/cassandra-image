Ubuntu based container with Apache Cassandra for development purpose

## Pull Images

Actually this Docker container supports:

- Apache Cassandra 2.1.4
- Apache Cassandra 2.1.3
- Apache Cassandra 2.1.2
- Apache Cassandra 2.1.1
- Apache Cassandra 2.1.0
- Apache Cassandra 2.0.14
- Apache Cassandra 2.0.13
- Apache Cassandra 2.0.12
- Apache Cassandra 2.0.11
- Apache Cassandra 2.0.10

Pull the image.

Apache Cassandra 2.1.4:

```
docker pull oscerd/cassandra
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

## Run containers

Run containers

Apache Cassandra 2.1.4:

```
docker run --name container_cassandra2.1.4 -dt oscerd/cassandra
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

## Connect to a running container

Suppose your running container is named cass_test you can execute:

```
docker exec -ti cass_test /bin/bash
```
