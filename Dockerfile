FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe src/infrastructure/api/main.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

EXPOSE $SERVER_PORT

CMD /app/bin/server \
  --define=SERVER_PORT="$SERVER_PORT" \
  --define=DB_HOST="$DB_HOST" \
  --define=DB_PORT="$DB_PORT" \
  --define=DB_USER="$DB_USER" \
  --define=DB_PASSWORD="$DB_PASSWORD" \
  --define=DB_DATABASE="$DB_DATABASE"
