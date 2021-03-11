import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SampleProvider with ChangeNotifier {

   final String uid ;
   String title  = '';

  SampleProvider(this.uid,);

  createItems() {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(uid);
    Map<String, String> items = {"title": title,"uid":uid};

    documentReference.set(items).whenComplete(() => print('Item created'));

  }

  deleteItems(DocumentSnapshot item) {
    FirebaseFirestore.instance.collection('users').doc(item.id).delete().then((value) => print('Item Deleted'));

  }

  editItems(DocumentSnapshot documentSnapshot) async {

    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(documentSnapshot.id);
    Map<String, String> items = {"title": title,"uid":uid};
    await documentReference.update(
    items).then((documentReference) {
      // Navigator.pop(context);
      print("Note Edited");
    }).catchError((e) {
      print(e);
    });

  }

  notifyListeners();

  }
