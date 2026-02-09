# Étape 1 : Utilisez l'image officielle Flutter pour construire
FROM ghcr.io/cirruslabs/flutter:3.22.4 AS build

WORKDIR /app
COPY . .

# Configurez et construisez
RUN flutter config --enable-web && \
    flutter clean && \
    flutter pub get && \
    flutter build web --release

# Étape 2 : Servez avec Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]