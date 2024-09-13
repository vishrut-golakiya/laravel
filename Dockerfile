FROM ubuntu:20.04

RUN apt-get update -y

#Installing apache in non-interactive mode
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install apache2 -y

#Installing PHP v 8.2
RUN apt-get -y install software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install php8.2


RUN apt-get install -y php8.2-bcmath php8.2-fpm php8.2-mysql php8.2-xml php8.2-zip php8.2-intl php8.2-ldap php8.2-gd php8.2-cli php8.2-bz2 php8.2-curl php8.2-mbstring php8.2-pgsql php8.2-opcache php8.2-soap php8.2-cgi


RUN apt-get update && apt-get -y install php-cli unzip && \
    cd ~ && apt-get -y install curl && \
    curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
    HASH=`curl -sS https://composer.github.io/installer.sig` && \
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer



COPY ./myApp /var/www/html/myApp

RUN chown -R www-data:www-data /var/www/html/myApp

RUN chmod -R 775 /var/www/html/myApp/storage

RUN chown -R www-data:www-data /var/www/html/myApp/storage


COPY ./000-default.conf  /etc/apache2/sites-available 

WORKDIR /var/www/html/myApp

# RUN service mysql start && \
#     php artisan key:generate && \
#     php artisan migrate --force

EXPOSE 80 3306

# CMD ["sh", "-c", "service mysql start && apachectl -D FOREGROUND"]
CMD ["apachectl", "-D", "FOREGROUND"]





# FROM ubuntu:latest

# RUN apt-get update -y

# #Installing apache in non-interactive mode
# ARG DEBIAN_FRONTEND=noninteractive

# RUN apt-get install apache2 -y

# #Installing PHP v 8.2
# RUN apt-get -y install software-properties-common && \
#     add-apt-repository ppa:ondrej/php && \
#     apt-get update && \
#     apt-get -y install php8.3

# #Install required PHP extensions
# RUN apt-get install -y php8.3-bcmath php8.3-fpm php8.3-xml php8.3-mysql php8.3-zip php8.3-intl php8.3-ldap php8.3-gd php8.3-cli php8.3-bz2 php8.3-curl php8.3-mbstring php8.3-pgsql php8.3-opcache php8.3-soap php8.3-cgi

# #Install Composer
# RUN apt-get update && apt-get -y install php-cli unzip && \
#     cd ~ && apt-get -y install curl && \
#     # apt-get install -y mysql-server && \
#     curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
#     HASH=`curl -sS https://composer.github.io/installer.sig` && \
#     php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
#     php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# # RUN service mysql start && \
# #     mysql -u root -ppassword -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"



# COPY ./myApp /var/www/html/myApp

# RUN chown -R www-data:www-data /var/www/html/myApp

# RUN chmod -R 775 /var/www/html/myApp/storage

# EXPOSE 80 

# WORKDIR /var/www/html/myApp

# # RUN service mysql start && \
# #     php artisan key:generate && \
# #     php artisan migrate --force

# CMD ["apachectl", "-D", "FOREGROUND"]


# FROM ubuntu:latest

# RUN apt-get update -y

# # Installing apache in non-interactive mode
# ARG DEBIAN_FRONTEND=noninteractive

# RUN apt-get install -y apache2 php8.3 php8.3-cli php8.3-fpm php8.3-xml php8.3-mbstring php8.3-mysql

# # Install Composer
# RUN apt-get update && apt-get -y install curl unzip && \
#     apt-get install -y mysql-server && \
#     curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
#     HASH=`curl -sS https://composer.github.io/installer.sig` && \
#     php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
#     php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# RUN service mysql start && \
#     mysql -u root -ppassword -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"    
# # Copy application files
# COPY ./myApp /var/www/html/myApp

# COPY ./000-default.conf  /etc/apache2/sites-available 

# RUN chown -R www-data:www-data /var/www/html/myApp

# RUN chmod -R 775 /var/www/html/myApp/storage

# WORKDIR /var/www/html/myApp

# RUN php artisan key:generate && \
#     php artisan migrate

# EXPOSE 80

# # Ensure Apache runs in the foreground
# CMD ["apachectl", "-D", "FOREGROUND"]




















