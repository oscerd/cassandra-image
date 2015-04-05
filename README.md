Ubuntu based container with Apache Cassandra for development purpose

## Pull Images

Actually this Docker container supports:

- Apache Cassandra 2.1.4
- Apache Cassandra 2.1.3
- Apache Cassandra 2.1.2
- Apache Cassandra 2.1.1

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

## Run containers

Run containers

Cassandra 2.1.4:

```
docker run --name container_cassandra2.1.4 -dt oscerd/cassandra
```

Cassandra 2.1.3:

```
docker run --name container_cassandra2.1.3 -dt oscerd/cassandra:cassandra-2.1.3
```

Cassandra 2.1.2:

```
docker run --name container_cassandra2.1.2 -dt oscerd/cassandra:cassandra-2.1.2
```

Cassandra 2.1.1:

```
docker run --name container_cassandra2.1.1 -dt oscerd/cassandra:cassandra-2.1.1
```
