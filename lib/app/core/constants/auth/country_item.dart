/// Data model for a single country entry in the phone-number picker.
class CountryItem {
  const CountryItem({
    required this.name,
    required this.flag,
    required this.dialCode,
  });

  /// Full country name, e.g. "Cambodia".
  final String name;

  /// Unicode flag emoji, e.g. "🇰🇭".
  final String flag;

  /// International dial code, e.g. "+855".
  final String dialCode;
}

/// Seed list of countries shown in the country picker bottom sheet.
/// Sorted alphabetically by name.
const List<CountryItem> kCountries = [
  CountryItem(name: 'Australia',             flag: '🇦🇺', dialCode: '+61'),
  CountryItem(name: 'Brazil',                flag: '🇧🇷', dialCode: '+55'),
  CountryItem(name: 'Cambodia',              flag: '🇰🇭', dialCode: '+855'),
  CountryItem(name: 'Canada',                flag: '🇨🇦', dialCode: '+1'),
  CountryItem(name: 'China',                 flag: '🇨🇳', dialCode: '+86'),
  CountryItem(name: 'France',                flag: '🇫🇷', dialCode: '+33'),
  CountryItem(name: 'Germany',               flag: '🇩🇪', dialCode: '+49'),
  CountryItem(name: 'India',                 flag: '🇮🇳', dialCode: '+91'),
  CountryItem(name: 'Indonesia',             flag: '🇮🇩', dialCode: '+62'),
  CountryItem(name: 'Japan',                 flag: '🇯🇵', dialCode: '+81'),
  CountryItem(name: 'Laos',                  flag: '🇱🇦', dialCode: '+856'),
  CountryItem(name: 'Malaysia',              flag: '🇲🇾', dialCode: '+60'),
  CountryItem(name: 'Myanmar',               flag: '🇲🇲', dialCode: '+95'),
  CountryItem(name: 'Netherlands',           flag: '🇳🇱', dialCode: '+31'),
  CountryItem(name: 'New Zealand',           flag: '🇳🇿', dialCode: '+64'),
  CountryItem(name: 'Philippines',           flag: '🇵🇭', dialCode: '+63'),
  CountryItem(name: 'Russia',                flag: '🇷🇺', dialCode: '+7'),
  CountryItem(name: 'Singapore',             flag: '🇸🇬', dialCode: '+65'),
  CountryItem(name: 'South Korea',           flag: '🇰🇷', dialCode: '+82'),
  CountryItem(name: 'Spain',                 flag: '🇪🇸', dialCode: '+34'),
  CountryItem(name: 'United Arab Emirates',  flag: '🇦🇪', dialCode: '+971'),
  CountryItem(name: 'United Kingdom',        flag: '🇬🇧', dialCode: '+44'),
  CountryItem(name: 'United States',         flag: '🇺🇸', dialCode: '+1'),
  CountryItem(name: 'Vietnam',               flag: '🇻🇳', dialCode: '+84'),
];
