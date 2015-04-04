Ubuntu based container with Oracle Java

## Pull Images

Actually this Docker container supports:

- Cassandra 2.1.4
- Cassandra 2.1.3

Pull the image.

Cassandra 2.1.4:

```
docker pull oscerd/cassandra
```

Cassandra 2.1.3:

```
docker pull oscerd/cassandra:cassandra-2.1.3
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
