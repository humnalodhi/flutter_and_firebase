import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_and_firebase/screens/firebase_auth/login_screen.dart';
import 'package:flutter_and_firebase/screens/firestore_db_list_manipulation/add_firestore_data.dart';
import 'package:flutter_and_firebase/utils/utils.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final auth = FirebaseAuth.instance;
  final TextEditingController editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Firestore List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then(
                (value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ).onError(
                (error, stackTrace) {
                  Utils().toastMessage(
                    error.toString(),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No data available',
              ),
            );
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final data = documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text(data['id'] ?? 'No ID'),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        onTap: () {
                          showMyDialog(
                            data['title'],
                            data['id'],
                          );
                        },
                        title: const Text('Edit'),
                        leading: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          ref.doc(data['id']).delete().then(
                            (value) {
                              Utils().toastMessage('Deleted');
                            },
                          ).onError(
                            (error, stackTrace) {
                              Utils().toastMessage(
                                error.toString(),
                              );
                            },
                          );
                        },
                        title: const Text('Delete'),
                        leading: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFirestoreData(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: editController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.doc(id).update({
                  'title': editController.text.toLowerCase(),
                }).then((value) {
                  Utils().toastMessage('Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(
                    error.toString(),
                  );
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
