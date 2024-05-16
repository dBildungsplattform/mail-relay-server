FROM alpine:3
# Installiere Postfix und notwendige Pakete
RUN apk add --no-cache postfix cyrus-sasl cyrus-sasl-login ca-certificates

# Kopiere das Startskript ins Image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Umgebungsvariablen für die Postfix Konfiguration (mit Standardwerten)
ENV RELAY_HOST="[smtp.example.com]:587" \
    SMTP_SASL_AUTH_ENABLE="yes" \
    SMTP_SASL_SECURITY_OPTIONS="noanonymous" \
    SMTP_SASL_PASSWORD_MAPS="hash:/etc/postfix/sasl_passwd" \
    SMTPD_RECIPIENT_RESTRICTIONS="permit_sasl_authenticated,reject" \
    SMTP_TLS_SECURITY_LEVEL="may" \
    SMTP_TLS_CAFILE="/etc/ssl/certs/ca-certificates.crt" \
    MECH_LIST="plain login" \
    PW_CHECK_METHOD="saslauthd"

# Expose SMTP port
EXPOSE 25 587

# Startskript als Einstiegspunkt
CMD ["/entrypoint.sh"]