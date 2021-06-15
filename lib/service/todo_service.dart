import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrumproject/models/users.dart';
import 'package:scrumproject/service/firebase_service.dart';

class TodoService extends FirebaseService {
  TodoService();

  @override
  CollectionReference getCollectionReference() {
    return FirebaseService.db
        .collection("users")
        .doc(Users().getID())
        .collection("todo");
  }

  @override
  String getID() {
    return getCollectionReference().doc().id;
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUser() {
    return getCollectionReference().snapshots();
  }
}
