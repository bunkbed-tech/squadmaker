# Squadmaker

A sports-themed app that helps team captains build and organize their squad roster on a mobile device for common intramural sports.

This project has been abandoned for the time being as we focus on getting our other ideas off the ground.

## Tools

- Rust: backend
- Kotlin MPM: frontend logic
- Jetpack Compose: Android UI
- SwiftUI: iOS UI

## Features to Implement

- Create leagues for a given sport
- Add friends to participate in the league with you
- Log games and scores
- Generate trading cards for members of a league, summarizing their stats
- Add photos to the league
- Let multiple users log into the league and view data / edit the database concurrently

Currently, we have a basic data model and database. The UI is only implemented for Android and it doesn't hoook into the database just yet.

## Testing

Run `docker-compose up --build` from `./backend` to run all of the tests in development.
