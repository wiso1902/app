import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class build_stream_top extends StatelessWidget {
  const build_stream_top({
    Key? key,
    required this.trViewTop,
  }) : super(key: key);

  final Stream<QuerySnapshot<Object?>> trViewTop;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: trViewTop,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Nått gick snett');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Datan hämtas');
        }
        final data = snapshot.requireData;
        return AnimationLimiter(
          child: ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot user = snapshot.data!.docs[index];
                String imagePath = user['imagePath'];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(seconds: 1),
                  child: SlideAnimation(
                    verticalOffset: 44,
                    child: FadeInAnimation(
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(imagePath)),
                          title: Text('${data.docs[index]['name']}'),
                          subtitle:
                          Text('Träningar ${data.docs[index]['totalTr']}'),
                          trailing: Text(
                            ' + ${data.docs[index]['totalTr'] * 20} Kr',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}