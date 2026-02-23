import 'package:flutter/widgets.dart';
import 'package:frappe_flutter_app/features/contacts_firebase/data/contacts_repository.dart';
import 'package:frappe_flutter_app/features/contacts_firebase/models/contact.dart';

class ContactsController extends ChangeNotifier {
  ContactsController(this._repository);

  final ContactsRepository _repository;

  bool _isLoading = false;
  bool _isSaving = false;
  List<Contact> _contacts = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  List<Contact> get contacts => _contacts;
  String get searchQuery => _searchQuery;

  List<Contact> get filteredContacts {
    if (_searchQuery.trim().isEmpty) return _contacts;
    final query = _searchQuery.toLowerCase();
    return _contacts
        .where(
          (c) =>
              c.name.toLowerCase().contains(query) ||
              c.phone.toLowerCase().contains(query) ||
              (c.email ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  List<Contact> get filteredFavoriteContacts {
    final favorites = _contacts.where((c) => c.isFavorite);
    if (_searchQuery.trim().isEmpty) return favorites.toList();
    final query = _searchQuery.toLowerCase();
    return favorites
        .where(
          (c) =>
              c.name.toLowerCase().contains(query) ||
              c.phone.toLowerCase().contains(query) ||
              (c.email ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> addContact(Contact contact) async {
    _setSaving(true);
    try {
      final id = await _repository.insert(contact);
      _contacts.add(contact.copyWith(id: id));
      _contacts.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      notifyListeners();
    } finally {
      _setSaving(false);
    }
  }

  Future<void> toggleFavorite(Contact contact) async {
    final updated = contact.copyWith(isFavorite: !contact.isFavorite);
    await _repository.update(updated);
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = updated;
      notifyListeners();
    }
  }

  Contact? getById(String id) {
    try {
      return _contacts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteContact(String id) async {
    await _repository.delete(id);
    _contacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> updateContact(Contact contact) async {
    _setSaving(true);
    try {
      await _repository.update(contact);
      final index = _contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _contacts[index] = contact;
        _contacts.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        notifyListeners();
      }
    } finally {
      _setSaving(false);
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  Future<void> loadContact() async {
    _setLoading(true);
    try {
      _contacts = List.of(await _repository.fetchAll());
    } finally {
      _setLoading(false);
    }
  }
}
