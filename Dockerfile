# sistema base
FROM nginx:alpine
# instala java 8
RUN apk -U add openjdk8 \
    # remueve todo lo que esta en esa carpeta
    && rm -rf /var/cache/apk/*;
RUN apk add ttf-dejavu

#Instala el microservicio de java
ENV JAVA_OPTS=""
ARG JAR_FILE
ADD ${JAR_FILE} app.jar

# se usa el volumen temporal
VOLUME /tmp
RUN rm -rf /usr/share/nginx/html/*
COPY billingApp/billingApp/nginx.conf /etc/nginx/nginx.conf
# copia la app local y la pega dentro del contenedor
COPY billingApp/billingApp/dist/billingApp /usr/share/nginx/html
COPY billingApp/billingApp/appshell.sh appshell.sh

# exponer puerto de salida 8080 y puerto de javaswagger 80
EXPOSE 80 8080

# el appshell instala las dependencia y despues levanta el servidor nginx
ENTRYPOINT ["sh", "/appshell.sh"]

