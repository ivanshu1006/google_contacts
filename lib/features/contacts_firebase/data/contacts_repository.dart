import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';

class ContactsRepository {
  final _collection = FirebaseFirestore.instance.collection('contacts');

  Future<List<Contact>> fetchAll() async {
    final response = await _collection.orderBy('name').get();
    return response.docs
        .map((doc) => Contact.fromMap(doc.data(), id: doc.id))
        .toList(growable: false);
  }

  Future<String> insert(Contact contact) async {
    final docRef = await _collection.add(contact.toMap());
    return docRef.id;
  }

  Future<void> update(Contact contact) async {
    await _collection.doc(contact.id).update(contact.toMap());
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
