import 'package:sqflite/sqflite.dart';

import '../data/contacts_database.dart';
import '../models/contact.dart';

class ContactsRepository {
  ContactsRepository(this._database);

  final ContactsDatabase _database;

  Future<List<Contact>> fetchAll() async {
    final db = await _database.database;
    final rows = await db.query(
      'contacts',
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Contact.fromMap).toList(growable: false);
  }

  Future<int> insert(Contact contact) async {
    final db = await _database.database;
    return db.insert('contacts', contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(Contact contact) async {
    final db = await _database.database;
    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _database.database;
    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<Contact?> fetchById(int id) async {
    final db = await _database.database;
    final rows = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Contact.fromMap(rows.first);
  }
}
