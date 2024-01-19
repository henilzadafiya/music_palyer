import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_palyer/controller.dart';
import 'package:music_palyer/fav_page.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';

class playlist extends StatefulWidget {
  const playlist({super.key});

  @override
  State<playlist> createState() => _playlistState();
}

class _playlistState extends State<playlist> {
  @override
  Widget build(BuildContext context) {

    controller c = Get.put(controller());
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(future: c.get_fav(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<FavoritesEntity> l = snapshot.data as List<FavoritesEntity>;
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return fav_page();
                },));
              },
              title: Text("Songs",style: TextStyle(color: Colors.white)),
              subtitle: Text("${l.length}",style: TextStyle(color: Colors.white)),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
