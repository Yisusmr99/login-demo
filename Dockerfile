FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar dependencias básicas del sistema
RUN apt-get update && apt-get install -y \
    software-properties-common \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    wget \
    curl

# 2. Agregar repositorio de PHP 8.2 (PPA oficial)
RUN add-apt-repository ppa:ondrej/php -y && apt-get update

# 3. Instalar PHP 8.2 y extensiones necesarias para Laravel
RUN apt-get install -y \
    php8.2 \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-curl \
    php8.2-zip \
    php-pear \
    php8.2-dev \
    php8.2-common \
    php8.2-gd \
    php8.2-mysql \
    php8.2-bcmath \
    php8.2-tokenizer \
    php8.2-ctype \
    unzip \
    git \
    make \
    gcc \
    g++ \
    libaio1 \
    libssl-dev \
    supervisor \
    && apt-get clean

# 4. Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 5. Instalar Node.js 18 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# 6. Instalar ODBC y drivers de SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 unixodbc-dev

# 7. Instalar extensiones sqlsrv y pdo_sqlsrv vía PECL
RUN pecl channel-update pecl.php.net && \
    pecl install sqlsrv pdo_sqlsrv && \
    echo "extension=sqlsrv.so" > /etc/php/8.2/cli/conf.d/20-sqlsrv.ini && \
    echo "extension=pdo_sqlsrv.so" > /etc/php/8.2/cli/conf.d/20-pdo_sqlsrv.ini

# 8. Descargar e instalar Oracle Instant Client (basic + sdk)
RUN mkdir -p /opt/oracle && cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/219000/instantclient-basic-linux.x64-21.9.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/219000/instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-21.9.0.0.0dbru.zip && \
    unzip instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient

# 9. Instalar extensión oci8 (forzar versión correcta para PHP 8.2)
RUN echo "instantclient,/opt/oracle/instantclient" | pecl install oci8-3.2.1 && \
    echo "extension=oci8.so" > /etc/php/8.2/cli/conf.d/20-oci8.ini

# 10. Directorio de trabajo
WORKDIR /var/www/html

# 11. Exponer puerto
EXPOSE 8000

# 12. Comando por defecto
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]