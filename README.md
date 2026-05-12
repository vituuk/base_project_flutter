# demo_2

Flutter base project using GetX with a small clean architecture structure.

## Structure

```text
lib/
  main.dart
  app/
    app.dart
    bindings/
    core/
      constants/
      network/
      theme/
    data/
      datasources/
      models/
      repositories/
    domain/
      entities/
      repositories/
      usecases/
    modules/
      home/
        bindings/
        controllers/
        views/
    routes/
```

## Layer Rules

- `core`: shared constants, themes, helpers, and app-wide utilities.
- `core/network`: Dio client setup, API endpoints, and API exception mapping.
- `routes`: route names and `GetPage` declarations.
- `bindings`: app-level dependency injection.
- `modules/<feature>`: feature UI, GetX controller, and feature binding.
- `domain`: entities, repository contracts, and use cases.
- `data`: concrete implementations of domain repository contracts.

## API Flow

The sample todo request shows the intended reusable flow:

```text
HomePage
  -> HomeController
  -> GetTodo use case
  -> TodoRepository contract
  -> TodoRepositoryImpl
  -> TodoRemoteDataSource
  -> DioClient
```

Change `AppConstants.baseUrl` or run with a Dart define when pointing to a real API:

```sh
flutter run --dart-define=BASE_URL=https://your-api.example.com
```

## Commands

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```
