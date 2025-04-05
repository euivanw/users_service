FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe src/infrastructure/api/main.dart -o user-service

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/user-service /app/

EXPOSE $SERVER_PORT

CMD ["/app/user-service"]
