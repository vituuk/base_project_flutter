import 'package:get/get.dart';

import '../../../core/constants/contacts/contact_item.dart';
export '../../../core/constants/contacts/contact_item.dart' show ContactItem;

// ── Controller ────────────────────────────────────────────────────────────────
class ContactController extends GetxController {
  final searchQuery = ''.obs;
  final sortByLastSeen = false.obs;

  final _contacts = <ContactItem>[...kContactItems].obs;

  /// Sorted + filtered list of contacts.
  List<ContactItem> get filteredContacts {
    final q = searchQuery.value.toLowerCase();
    final list = q.isEmpty
        ? List<ContactItem>.from(_contacts)
        : _contacts
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.status.toLowerCase().contains(q))
            .toList();

    if (sortByLastSeen.value) {
      list.sort((a, b) {
        final weightA = _getLastSeenWeight(a);
        final weightB = _getLastSeenWeight(b);
        if (weightA != weightB) {
          return weightA.compareTo(weightB);
        }
        return a.name.compareTo(b.name);
      });
    } else {
      list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  /// Calculates a weight for sorting by last seen/activity status (lower = more recent/online).
  int _getLastSeenWeight(ContactItem contact) {
    if (contact.isOnline || contact.status == 'Active now') {
      return 0;
    }
    final status = contact.status.toLowerCase();
    if (status.contains('min') || status.contains('m ago')) {
      final match = RegExp(r'\d+').firstMatch(status);
      final mins = match != null ? int.parse(match.group(0)!) : 1;
      return mins;
    }
    if (status.contains('h ago') || status.contains('hour')) {
      final match = RegExp(r'\d+').firstMatch(status);
      final hours = match != null ? int.parse(match.group(0)!) : 1;
      return hours * 60;
    }
    if (status.contains('yesterday')) {
      return 24 * 60;
    }
    if (status.contains('week')) {
      return 7 * 24 * 60;
    }
    return 30 * 24 * 60; // Fallback
  }

  /// Returns the distinct group letters for the filtered list.
  List<String> get groupKeys {
    final keys = filteredContacts.map((c) => c.groupKey).toSet().toList();
    keys.sort();
    return keys;
  }

  /// Returns all contacts under a specific group letter.
  List<ContactItem> contactsForGroup(String key) =>
      filteredContacts.where((c) => c.groupKey == key).toList();

  void onSearchChanged(String value) => searchQuery.value = value;

  void toggleSortType() {
    sortByLastSeen.value = !sortByLastSeen.value;
  }
}
