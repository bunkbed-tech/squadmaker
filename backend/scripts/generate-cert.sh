#!/usr/bin/env bash
#
# This will create a self-signed certificate for testing TLS capabilities on localhost

openssl req -x509 -newkey rsa:4096 -nodes -keyout key.pem -out cert.pem -days 365 -subj '/CN=localhost'
