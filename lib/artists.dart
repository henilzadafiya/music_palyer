import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_palyer/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class artists extends StatefulWidget {
  const artists({super.key});

  @override
  State<artists> createState() => _artistsState();
}

class _artistsState extends State<artists> {
  @override
  Widget build(BuildContext context) {
    controller c = Get.put(controller());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: FutureBuilder(
        future: c.get_artis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<AlbumModel> l = snapshot.data as List<AlbumModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${l[index].artist}",
                      style: TextStyle(color: Colors.white), maxLines: 1),
                  subtitle: Text("${l[index].numOfSongs}",
                      style: TextStyle(color: Colors.white)),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
