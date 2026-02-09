# Étape 1 : Construire l'application Flutter
FROM debian:stable-slim AS build
RUN apt-get update && apt-get install -y curl git unzip xz-utils
RUN curl -sSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.0-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz
ENV PATH="/flutter/bin:${PATH}"
WORKDIR /app
COPY . .
RUN flutter config --enable-web && flutter build web --release

# Étape 2 : Servir avec Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]