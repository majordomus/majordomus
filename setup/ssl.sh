#!/bin/bash

# Create a self-signed SSL certificate if one has not yet been created.
#
# The certificate is for PRIMARY_HOSTNAME specifically and is used for:
#
#  * IMAP
#  * SMTP submission (port 587) and opportunistic TLS (when on the receiving end)
#  * the DNSSEC DANE TLSA record for SMTP
#  * HTTPS (for PRIMARY_HOSTNAME only)
#
# When other domains besides PRIMARY_HOSTNAME are served over HTTPS,
# we generate a domain-specific self-signed certificate in the management
# daemon (web_update.py) as needed.

echo "***"
echo "*** majordomus: creating a first SSL certificate"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

apt_install openssl

sudo mkdir -p $MAJORDOMUS_DATA/ssl

# Generate a new private key.
# Set the umask so the key file is not world-readable.
if [ ! -f $MAJORDOMUS_DATA/ssl/ssl_private_key.pem ]; then
	(umask 077; hide_output openssl genrsa -out $MAJORDOMUS_DATA/ssl/ssl_private_key.pem 2048)
fi

# Generate a certificate signing request.
if [ ! -f $MAJORDOMUS_DATA/ssl/ssl_cert_sign_req.csr ]; then
	hide_output openssl req -new -key $MAJORDOMUS_DATA/ssl/ssl_private_key.pem -out $MAJORDOMUS_DATA/ssl/ssl_cert_sign_req.csr \
	  -sha256 -subj "/C=$CSR_COUNTRY/ST=/L=/O=/CN=$PRIMARY_HOSTNAME"
fi

# Generate a SSL certificate by self-signing.
if [ ! -f $MAJORDOMUS_DATA/ssl/ssl_certificate.pem ]; then
	hide_output openssl x509 -req -days 365 \
	  -in $MAJORDOMUS_DATA/ssl/ssl_cert_sign_req.csr -signkey $MAJORDOMUS_DATA/ssl/ssl_private_key.pem -out $MAJORDOMUS_DATA/ssl/ssl_certificate.pem
fi

# For nginx and postfix, pre-generate some Diffie-Hellman cipher bits which is
# used when a Diffie-Hellman cipher is selected during TLS negotiation. Diffie-Hellman
# provides Perfect Forward Security. openssl's default is 1024 bits, but we'll
# create 2048.
if [ ! -f $MAJORDOMUS_DATA/ssl/dh2048.pem ]; then
	openssl dhparam -out $MAJORDOMUS_DATA/ssl/dh2048.pem 2048
fi
