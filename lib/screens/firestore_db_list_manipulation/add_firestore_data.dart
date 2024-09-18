import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/utils/utils.dart';
import 'package:flutter_and_firebase/widgets/round_button.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final TextEditingController controller = TextEditingController();
  bool loading = false;
  ///Creating a collection(table) in firebase firestore database.
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add firestore data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "What's in your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              loading: loading,
              title: 'Add',
              onTap: () {
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': controller.text.toString(),
                  'id': id,
                }).then((value) {
                  Utils().toastMessage('Post Added');
                  setState(() {
                    loading = false;
                  });
                  controller.clear();
                }).onError((error, stackTrace) {
                  Utils().toastMessage(
                    error.toString(),
                  );
                  setState(() {
                    loading = false;
                  });
                });

              },
            ),
          ],
        ),
      ),
    );
  }
}
