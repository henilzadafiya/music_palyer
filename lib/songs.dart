import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_palyer/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:text_scroll/text_scroll.dart';

class songs extends StatefulWidget {
  const songs({super.key});

  @override
  State<songs> createState() => _songsState();
}

class _songsState extends State<songs> {
  @override
  Widget build(BuildContext context) {
    double full_size = MediaQuery.of(context).size.height;
    double top_bar = MediaQuery.of(context).padding.top;
    double high = full_size - top_bar;
    controller c = Get.put(controller());
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 5, 5),
      body: FutureBuilder(
        future: c.get_song(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> l = snapshot.data as List<SongModel>;
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    c.get_duration();
                    c.isplay.value = true;
                    if (c.cur_ind.value == index) {
                    } else {
                      c.cur_ind.value = index;
                      controller.player.play(DeviceFileSource(
                          c.song_list.value[c.cur_ind.value].data));

                    }
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Container(
                          color: Colors.black,
                          height: high,
                          child: Column(children: [
                            Container(
                              margin: EdgeInsets.only(top: 30, left: 30),
                              alignment: Alignment.topLeft,
                              child: ListTile(
                                title: Obx(() => TextScroll(
                                  "${c.song_list.value[c.cur_ind.value].title}",
                                  mode: TextScrollMode.endless,
                                  velocity:
                                  Velocity(pixelsPerSecond: Offset(50, 0)),
                                  delayBefore: Duration(milliseconds: 500),
                                  pauseBetween: Duration(seconds: 2),
                                  selectable: true,
                                  style: TextStyle(color: Colors.white),
                                )
                                  // Text(
                                  // "${c.song_list.value[c.cur_ind.value].title}",
                                  // style: TextStyle(
                                  //     color: Colors.white, fontSize: 20),
                                  // maxLines: 1),
                                ),
                                subtitle: Obx(
                                      () => Text(
                                    "${c.song_list.value[c.cur_ind.value].artist}",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 300,
                                width: 300,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/1024px-Apple_Music_icon.svg.png"
                                      ),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 30, right: 30),
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      activeTickMarkColor:
                                      Color.fromARGB(255, 231, 61, 77),
                                      inactiveTrackColor:
                                      Color.fromARGB(255, 94, 93, 93),
                                      activeTrackColor:
                                      Color.fromARGB(255, 231, 61, 77),
                                      thumbShape: SliderComponentShape.noThumb,
                                      thumbColor: Colors.transparent,
                                      trackHeight: 2),
                                  child: Obx(
                                        () => Slider(
                                      min: 0,
                                      max: c.song_list.value.length > 0
                                          ? c.song_list.value[c.cur_ind.value].duration!
                                          .toDouble()
                                          : 0,
                                      value: c.duration.value,
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Obx(
                                          () => c.fav.value
                                          ? IconButton(
                                        onPressed: () async {
                                          bool deleteFromResult =
                                          await OnAudioRoom().deleteFrom(
                                            RoomType.FAVORITES,
                                            c.song_list.value[c.cur_ind.value].id,
                                            //playlistKey,
                                          );
                                          c.get_check();
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      )
                                          : IconButton(
                                        onPressed: () async {
                                          int? addToResult =
                                          await OnAudioRoom().addTo(
                                            RoomType.FAVORITES,
                                            c.song_list.value[c.cur_ind.value]
                                                .getMap
                                                .toFavoritesEntity(),
                                          );
                                          c.get_check();
                                        },
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Obx(() =>
                                      IconButton(
                                        onPressed: () {
                                          if (c.cur_ind > 0) {
                                            c.cur_ind--;
                                            print(c.isplay);
                                            c.isplay.value = true;
                                            controller.player.play(DeviceFileSource(
                                                c.song_list.value[c.cur_ind.value].data));
                                            // c.get_duration();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.skip_previous,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // ),
                                      Obx(
                                            () => c.isplay.value
                                            ? IconButton(
                                          onPressed: () {
                                            controller.player.pause();
                                            c.isplay.value = !c.isplay.value;
                                            c.get_duration();
                                          },
                                          icon: Icon(
                                            Icons.pause,
                                            color: Colors.white,
                                          ),
                                        )
                                            : IconButton(
                                            onPressed: () {
                                              c.isplay.value = !c.isplay.value;
                                              controller.player.play(DeviceFileSource(c
                                                  .song_list
                                                  .value[c.cur_ind.value]
                                                  .data));
                                              // c.get_duration();
                                            },
                                            icon: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            )),
                                      ),
                                      // Obx(() =>
                                      IconButton(
                                        onPressed: () {
                                          if (c.cur_ind < c.song_list.length - 1) {
                                            c.cur_ind++;
                                            print(c.isplay);
                                            c.isplay.value = true;

                                            controller.player.play(DeviceFileSource(
                                                c.song_list.value[c.cur_ind.value].data));
                                            c.get_duration();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.skip_next,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // ),
                                    ],
                                  ),
                                )),
                          ]),
                        );
                      },
                    );
                  },


                  title: Obx(
                    () => c.isplay.value && c.cur_ind == index
                        ? Text("${l[index].title}",
                            style: TextStyle(color: Colors.red), maxLines: 1)
                        : Text("${l[index].title}",
                            style: TextStyle(color: Colors.white), maxLines: 1),
                  ),
                  subtitle: Obx(
                    () => c.isplay.value && c.cur_ind == index
                        ? Text(
                            "${l[index].artist}",
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            "${l[index].artist}",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  // selectedColor: Colors.red,
                  trailing: Wrap(
                    children: [
                      Obx(
                        () => c.cur_ind == index && c.isplay.value
                            ? Icon(
                                Icons.pause,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                      )
                    ],
                  ),
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
