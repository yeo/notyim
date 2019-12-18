# Mariadb

This is a single instance deployment of mariadb on kubernetes.

# Deployment

## Bootstrap

In this we create namespace and its secret.

```
make ns secret deploy
```

Give it some moment and get the random password

```
make password
```

This way we get a random password of root instead of setting password via env,
which I consider a good practice
