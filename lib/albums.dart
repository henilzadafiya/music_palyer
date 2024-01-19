import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_palyer/album_page.dart';
import 'package:music_palyer/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class albums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    controller c = Get.put(controller());
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: c.get_album(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<AlbumModel> l = snapshot.data as List<AlbumModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return album_page(l[index]);
                      },
                    ));
                  },
                  title: Text("${l[index].album}",
                      style: TextStyle(color: Colors.white), maxLines: 1),
                  subtitle: Text("${l[index].numOfSongs}",
                      style: TextStyle(color: Colors.white)),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
