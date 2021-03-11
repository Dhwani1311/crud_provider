
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_provider/Provider/provider_page.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<SampleProvider>(context);

    return new Scaffold(
      appBar: new AppBar(
        title: Center(child: Text("Provider Crud")),
      ),
      body: Consumer<SampleProvider>(
        builder: (context,provider,_){
        return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshots){
          if(snapshots.data == null)
            return Center(
                child: Text("No notes", style: TextStyle(color: Colors.grey),));

          //SampleModel sampleApiData = snapshots.data.documentReference;
          return  ListView.builder(
              itemCount: snapshots.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshots.data.docs[index];

                return Dismissible(
                  onDismissed: (direction){
                    provider.deleteItems(documentSnapshot);
                  },
                  key: Key(documentSnapshot["title"]),
                  child: GestureDetector(
                    child: Card(
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(documentSnapshot["title"],style: TextStyle(fontSize: 22.0),),
                        trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red,),
                          onPressed: (){
                            provider.deleteItems(documentSnapshot);
                            final snackBar = SnackBar(
                              content: Text(' Note Deleted'),);
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                        ),
                      ),
                    ),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              title: Text("Edit Note",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              content: TextField(
                                onChanged: (String value) {
                                 provider.title = value;
                                },
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    provider.editItems(documentSnapshot);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Save" ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                ),
                                FlatButton(
                                  onPressed:(){
                                    Navigator.of(context).pop();
                                  },
                                  child:  Text("Cancel",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),)
                              ],
                            );
                          });
                    },

                  ),
                );
              });
        },);
      },),
      floatingActionButton: FloatingActionButton (
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  title: Text("Add New Note",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  content: TextField(
                    onChanged: (String value) {
                      provider.title = value;
                    },
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        provider.createItems();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add" ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    FlatButton(
                      onPressed:(){
                        Navigator.of(context).pop();
                      },
                      child:  Text("Cancel",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),)
                  ],
                );
              });
        },
        child: Icon(Icons.add, color: Colors.black),
      ),

    );
  }
}
