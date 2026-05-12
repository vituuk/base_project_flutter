class AppConstants {
  const AppConstants._();

  static const appName = 'Demo 2';
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );
}
