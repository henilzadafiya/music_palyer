import 'package:flutter/material.dart';
import 'package:music_palyer/home.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await OnAudioRoom().initRoom(RoomType.FAVORITES);
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false,
      home: f_home(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
      ),
    ),
  );
}

class f_home extends StatefulWidget {
  const f_home({super.key});

  @override
  State<f_home> createState() => _f_homeState();
}

class _f_homeState extends State<f_home> {
  @override
  void initState() {
    // TODO: implement initState
    permission();

    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return home();
          },
        ));
      },
    );
  }

  permission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: Text("MUSIC",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
