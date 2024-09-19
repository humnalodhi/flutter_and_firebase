import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/screens/firebase_auth/login_screen.dart';
import 'package:flutter_and_firebase/screens/realtime_db_list_manipulations/add_posts_screen.dart';
import 'package:flutter_and_firebase/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Posts');
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(
                  error.toString(),
                );
              });
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: [
            const Text(
              '** Fetched data using stream builder **',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  Map<dynamic, dynamic> map =
                      snapshot.data?.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(list[index]['title'] ?? 'null'),
                        );
                      },
                    );
                  }
                },
                stream: ref.onValue,
              ),
            ),
            const Text(
              '** Fetched data using firebase animated list **',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text('loading...'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(
                        snapshot.child('title').value.toString(),
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                showMyDialog(
                                  snapshot.child('title').value.toString(),
                                  snapshot.child('id').value.toString(),
                                );
                              },
                              title: const Text('Edit'),
                              leading: const Icon(Icons.edit),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                ref
                                    .child(
                                      snapshot.child('id').value.toString(),
                                    )
                                    .remove()
                                    .then(
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
                          )
                        ],
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    );
                  } else if (title.toLowerCase().contains(
                      searchController.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(
                        snapshot.child('title').value.toString(),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostsScreen(),
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
                ref.child(id).update({
                  'title': editController.text.toLowerCase(),
                }).then((value) {
                  Utils().toastMessage('Post Updated');
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
