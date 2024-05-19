#!/bin/sh

# Konfiguriere Postfix mit Umgebungsvariablen
postconf -e "relayhost=${RELAY_HOST}"
postconf -e "smtp_sasl_auth_enable=${SMTP_SASL_AUTH_ENABLE}"
postconf -e "smtp_sasl_security_options=${SMTP_SASL_SECURITY_OPTIONS}"
postconf -e "smtp_sasl_password_maps=${SMTP_SASL_PASSWORD_MAPS}"
postconf -e 'smtpd_sasl_local_domain=$myhostname'
postconf -e "smtpd_recipient_restrictions=${SMTPD_RECIPIENT_RESTRICTIONS}"
postconf -e "smtp_tls_security_level=${SMTP_TLS_SECURITY_LEVEL}"
postconf -e "smtp_tls_CAfile=${SMTP_TLS_CAFILE}"
postconf -e "maillog_file = /dev/stdout"

# Erstelle smtpd.conf für Cyrus-SASL
mkdir -p /etc/sasl2
echo "pwcheck_method: ${PW_CHECK_METHOD}" > /etc/sasl2/smtpd.conf
echo "mech_list: ${MECH_LIST}" >> /etc/sasl2/smtpd.conf
mkdir -p /var/spool/postfix/var/run/saslauthd
saslauthd -a shadow -c -m /var/spool/postfix/var/run/saslauthd

adduser -D ${SMTP_USER} -s /bin/false && echo "${SMTP_USER}:${SMTP_PASSWORD}" | chpasswd

# Überprüfe, ob die sasl_passwd-Datei vorhanden ist
if [ -f "/etc/postfix/sasl_passwd" ]; then
    # Erstelle die sasl_passwd.db-Datei
    postmap hash:/etc/postfix/sasl_passwd
    chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
fi

# Starte Postfix im Vordergrund
postfix -v start-fg
# tail -f /var/log/mail.log