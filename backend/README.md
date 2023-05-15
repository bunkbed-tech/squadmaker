# Backend

## Testing

Here are some basic tests of the user service using `curl`:

### List users

```bash
curl 127.0.0.1:8080/users
```

### Create user

```bash
curl 127.0.0.1:8080/users -H "Content-Type: application/json" \
     -d '{"name": "Joe", "email": "joe@schmoe.com", "username": "joeschmoe", "password_hash": "asdf", "avatar": "..."}'
```

### Jumping into the docker container

```bash
docker compose run --entrypoint bash tests
```
