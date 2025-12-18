import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/food_entry.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? _userId;

  // Initialize and authenticate user anonymously
  Future<void> initialize() async {
    try {
      // Sign in anonymously if not already signed in
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
        print('Signed in anonymously');
      }
      _userId = _auth.currentUser?.uid;
      print('User ID: $_userId');
    } catch (e) {
      print('Error initializing Firestore: $e');
      rethrow;
    }
  }

  // Get reference to user's food entries collection
  CollectionReference get _entriesCollection {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(_userId).collection('foodEntries');
  }

  // Add a food entry
  Future<String> insertFoodEntry(FoodEntry entry) async {
    try {
      final docRef = await _entriesCollection.add({
        'name': entry.name,
        'calories': entry.calories,
        'dateTime': entry.dateTime.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Inserted food entry: ${entry.name}, ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error inserting food entry: $e');
      rethrow;
    }
  }

  // Get all food entries
  Future<List<FoodEntry>> getAllFoodEntries() async {
    try {
      final snapshot = await _entriesCollection
          .orderBy('dateTime', descending: true)
          .get();
      
      final entries = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FoodEntry(
          id: int.tryParse(doc.id.hashCode.toString()),
          name: data['name'],
          calories: data['calories'],
          dateTime: DateTime.parse(data['dateTime']),
        );
      }).toList();
      
      print('Retrieved ${entries.length} food entries from Firestore');
      return entries;
    } catch (e) {
      print('Error getting food entries: $e');
      return [];
    }
  }

  // Get food entries in real-time (for live sync)
  Stream<List<FoodEntry>> getFoodEntriesStream() {
    return _entriesCollection
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FoodEntry(
          id: int.tryParse(doc.id.hashCode.toString()),
          name: data['name'],
          calories: data['calories'],
          dateTime: DateTime.parse(data['dateTime']),
        );
      }).toList();
    });
  }

  // Delete a food entry
  Future<void> deleteFoodEntry(String docId) async {
    try {
      await _entriesCollection.doc(docId).delete();
      print('Deleted food entry with ID: $docId');
    } catch (e) {
      print('Error deleting food entry: $e');
      rethrow;
    }
  }

  // Delete old entries
  Future<void> deleteOldEntries(int daysToKeep) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      final snapshot = await _entriesCollection
          .where('dateTime', isLessThan: cutoffDate.toIso8601String())
          .get();
      
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Deleted entries older than $daysToKeep days');
    } catch (e) {
      print('Error deleting old entries: $e');
      rethrow;
    }
  }

  // Clear all entries (for testing)
  Future<void> clearAll() async {
    try {
      final snapshot = await _entriesCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Cleared all entries from Firestore');
    } catch (e) {
      print('Error clearing entries: $e');
      rethrow;
    }
  }
}
