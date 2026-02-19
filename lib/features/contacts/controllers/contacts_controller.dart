import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../repositories/contacts_repository.dart';

class ContactsController extends ChangeNotifier {
  ContactsController(this._repository) {
    loadContacts();
  }

  final ContactsRepository _repository;

  final List<Contact> _contacts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Contact> get contacts => List.unmodifiable(_contacts);
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<Contact> get filteredContacts {
    if (_searchQuery.trim().isEmpty) return contacts;
    final query = _searchQuery.toLowerCase();
    return _contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query) ||
              contact.phone.toLowerCase().contains(query) ||
              (contact.email ?? '').toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  List<Contact> get favoriteContacts =>
      _contacts.where((contact) => contact.isFavorite).toList(growable: false);

  List<Contact> get filteredFavoriteContacts {
    final favorites = _contacts.where((contact) => contact.isFavorite);
    if (_searchQuery.trim().isEmpty) {
      return favorites.toList(growable: false);
    }
    final query = _searchQuery.toLowerCase();
    return favorites
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query) ||
              contact.phone.toLowerCase().contains(query) ||
              (contact.email ?? '').toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  Future<void> loadContacts() async {
    _setLoading(true);
    try {
      final items = await _repository.fetchAll();
      _contacts
        ..clear()
        ..addAll(items);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addContact(Contact contact) async {
    final id = await _repository.insert(contact);
    _contacts.add(contact.copyWith(id: id));
    _sortContacts();
    notifyListeners();
  }

  Future<void> updateContact(Contact contact) async {
    await _repository.update(contact);
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      _sortContacts();
      notifyListeners();
    }
  }

  Future<void> deleteContact(int id) async {
    await _repository.delete(id);
    _contacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> toggleFavorite(Contact contact) async {
    final updated = contact.copyWith(isFavorite: !contact.isFavorite);
    await updateContact(updated);
  }

  Contact? getById(int id) {
    try {
      return _contacts.firstWhere((contact) => contact.id == id);
    } catch (_) {
      return null;
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

  void _sortContacts() {
    _contacts.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
  }
}
