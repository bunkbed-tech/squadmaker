#!/usr/bin/env bash

# set -x

delete_db=false

while getopts ":h-:" opt; do
  case ${opt} in
    h )
      # Display help message
      echo "Usage: $(basename $0) [OPTIONS]"
      echo "Options:"
      echo "  --delete-db   Deletes the database"
      echo "  -h            Displays this help message"
      exit 0
      ;;
    - )
      case "${OPTARG}" in
        delete-db )
          # Delete the database
          echo "--delete-db set: Will delete database"
          delete_db=true
          ;;
        * )
          # Invalid option
          echo "Invalid option: --${OPTARG}" 1>&2
          exit 1
          ;;
      esac
      ;;
    \? )
      # Invalid option
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

if $delete_db; then
    echo -n "Deleting database ... "
    rm -f ~/Library/Containers/com.example.squadmaker/Data/Documents/squadmaker.db
    echo "done"
fi

echo "Running flutter application ... "
flutter run
