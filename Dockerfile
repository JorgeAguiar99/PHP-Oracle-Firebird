# Utilizar a imagem oficial do PHP com Apache.
FROM php:8.2.25-apache-bookworm

# Definir o diretório de trabalho.
WORKDIR /var/www/html

# Copiar o código do projeto para o diretório padrão (Mencionado acima).
COPY . .

# Ativar o mod_rewrite do Apache.
RUN a2enmod rewrite

# Instala dependências
RUN apt-get update && \
    apt-get install -y alien unzip wget nano firebird-dev libaio1 curl && \
    rm -rf /var/lib/apt/lists/*

RUN php /var/www/html/.docker/composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN alien -i ./.docker/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
    alien -i ./.docker/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm && \
    alien -i ./.docker/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm

# Configura o caminho das bibliotecas Oracle
RUN echo "/usr/lib/oracle/12.2/client64/lib" > /etc/ld.so.conf.d/oracle.conf && ldconfig

# Configura variáveis de ambiente
ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH

# Baixa, compila e instala o OCI8
RUN pecl download OCI8 && \
    tar -zxvf oci8*.tgz && \
    cd oci8-* && \
    phpize && \
    ./configure --with-oci8=instantclient,$ORACLE_HOME/lib && \
    make install

# Configura o PDO_OCI e o OCI8
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/12.2/client64/lib/ && \
    docker-php-ext-install oci8 && \
    docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/lib/oracle/12.2/client64/lib/ && \
    docker-php-ext-install pdo_oci && \
    docker-php-ext-install pdo_firebird

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Define as permissões adequadas
RUN chown -R www-data:www-data /var/www/html

# Reinicia o Apache
CMD ["apache2-foreground"]

EXPOSE 80
