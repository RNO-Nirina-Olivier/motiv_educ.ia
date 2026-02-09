# Étape 1 : Construire l'application Flutter
FROM debian:stable-slim AS build
RUN apt-get update && apt-get install -y curl git unzip xz-utils lsb-release

# Installe Flutter
RUN curl -sSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.5-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz \
    && rm flutter.tar.xz

ENV PATH="/flutter/bin:${PATH}"

# Vérifie l'installation
RUN flutter --version
RUN flutter doctor -v

WORKDIR /app
COPY . .

# Exécute les commandes avec diagnostic
RUN echo "=== Activation du web ===" && flutter config --enable-web
RUN echo "=== Nettoyage ===" && flutter clean
RUN echo "=== Récupération des dépendances ===" && flutter pub get
RUN echo "=== Build web ===" && flutter build web --release --verbose