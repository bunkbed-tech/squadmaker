# Squadmaker
A sports-themed app that helps team captains build and organize their squad roster on a mobile device for common intramural sports.

## Testing

Run `docker-compose up --build backend_tests` from `./backend` to run all of the tests in development.

## Run frontend locally

``` sh
# Run the database and backend server
docker-compose up --build backend

# Port forward services on local computer to Android device
adb reverse tcp:8080 tcp:8080
```
