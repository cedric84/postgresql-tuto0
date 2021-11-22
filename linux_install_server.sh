#! /bin/bash

# Installe les packages
# https://www.postgresql.org/download/linux/debian/
sudo apt-get -qqy update
sudo apt-get -qqy install postgresql

# Crée le rôle 'cedric' en utilisant le nouvel utilisateur 'postgres'.
# https://www.postgresql.org/docs/12/role-attributes.html
sudo -u postgres psql -c "CREATE ROLE cedric PASSWORD 'password' LOGIN CREATEDB;"

# Crée une database 'mydb' avec le rôle 'cedric'
# https://www.postgresql.org/docs/12/tutorial-createdb.html
PGPASSWORD=password createdb -U cedric mydb

# Récupère la version majeure installée
MY_POSTGRES_VERSION_MAJOR=($(pg_config --version | egrep -o '[0-9]{1,}'))
MY_POSTGRES_VERSION_MAJOR=${MY_POSTGRES_VERSION_MAJOR[0]}

# Indique au serveur d'écouter sur toutes ses adresses IPv4
# https://www.postgresql.org/docs/12/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SETTINGS
sudo sed -i -e "/#listen_addresses/alisten_addresses\ =\ \'0\.0\.0\.0\'" /etc/postgresql/${MY_POSTGRES_VERSION_MAJOR}/main/postgresql.conf

# Indique au serveur que les connexions entrantes non sécurisées vers toutes les databases avec le rôle cedric
# sont autorisées quelle que soit l'adresse du client.
#
# ATTENTION: Par mesure de sécurité, ceci ne doit JAMAIS être fait dans la réalité.
# https://www.postgresql.org/docs/12/auth-pg-hba-conf.html
echo -e "\nhostnossl all cedric all password" | sudo tee -a /etc/postgresql/${MY_POSTGRES_VERSION_MAJOR}/main/pg_hba.conf > /dev/null

# Redémarre le serveur
sudo systemctl restart postgresql.service
