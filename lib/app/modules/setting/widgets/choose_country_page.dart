import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

const List<CountryModel> allCountries = [
  CountryModel(name: 'Afghanistan', code: '+93', flag: '🇦🇫'),
  CountryModel(name: 'Åland Islands', code: '+358', flag: '🇦🇽'),
  CountryModel(name: 'Albania', code: '+355', flag: '🇦🇱'),
  CountryModel(name: 'Algeria', code: '+213', flag: '🇩🇿'),
  CountryModel(name: 'American Samoa', code: '+1-684', flag: '🇦🇸'),
  CountryModel(name: 'Andorra', code: '+376', flag: '🇦🇩'),
  CountryModel(name: 'Angola', code: '+244', flag: '🇦🇴'),
  CountryModel(name: 'Anguilla', code: '+1-264', flag: '🇦🇮'),
  CountryModel(name: 'Antarctica', code: '+672', flag: '🇦🇶'),
  CountryModel(name: 'Antigua and Barbuda', code: '+1-268', flag: '🇦🇬'),
  CountryModel(name: 'Argentina', code: '+54', flag: '🇦🇷'),
  CountryModel(name: 'Armenia', code: '+374', flag: '🇦🇲'),
  CountryModel(name: 'Aruba', code: '+297', flag: '🇦🇼'),
  CountryModel(name: 'Australia', code: '+61', flag: '🇦🇺'),
  CountryModel(name: 'Cambodia', code: '+855', flag: '🇰🇭'),
  CountryModel(name: 'United States', code: '+1', flag: '🇺🇸'),
  CountryModel(name: 'Vietnam', code: '+84', flag: '🇻🇳'),
  CountryModel(name: 'Singapore', code: '+65', flag: '🇸🇬'),
  CountryModel(name: 'Laos', code: '+856', flag: '🇱🇦'),
];

class ChooseCountryPage extends StatefulWidget {
  const ChooseCountryPage({super.key});

  @override
  State<ChooseCountryPage> createState() => _ChooseCountryPageState();
}

class _ChooseCountryPageState extends State<ChooseCountryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryModel> _filteredCountries = List.from(allCountries);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = List.from(allCountries);
      } else {
        _filteredCountries = allCountries.where((country) {
          return country.name.toLowerCase().contains(query) ||
                 country.code.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDarkMode ? Colors.white : AppColors.primary,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Text(
          'Choose a country',
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Container
            Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Color(0xFF94A3B8),
                            size: 18,
                          ),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable Country List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredCountries.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.divider,
                  indent: 36,
                ),
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    leading: Text(
                      country.flag,
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Emoji',
                      ),
                    ),
                    title: Text(
                      country.name,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      country.code,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Get.back(result: country),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
