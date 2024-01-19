import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_palyer/albums.dart';
import 'package:music_palyer/artists.dart';
import 'package:music_palyer/controller.dart';
import 'package:music_palyer/playlist.dart';
import 'package:music_palyer/songs.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:text_scroll/text_scroll.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Widget> tab = [songs(), artists(), albums(), playlist()];

   List tab_name = ['songs', 'artists', 'albums', 'playlist'];

  @override
  Widget build(BuildContext context) {
    double full_size = MediaQuery.of(context).size.height;
    double top_bar = MediaQuery.of(context).padding.top;
    double high = full_size - top_bar;
    print(full_size);
    print(top_bar);
    controller c = Get.put(controller());
    // print(c.duration.value);
    return DefaultTabController(
      length: tab_name.length,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 5, 5, 5),
        appBar: AppBar(
          toolbarHeight: 100,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                ],
              ),
              Text(
                "MUSIC",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: List.generate(
              tab_name.length,
              (index) {
                return Tab(
                  child: Text("${tab_name[index]}",
                      style: TextStyle(fontSize: 15)),
                );
              },
            ),
          ),
        ),
        body: TabBarView(children: tab),
        bottomNavigationBar: InkWell(
          onTap: () {
            c.get_check();
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
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/1024px-Apple_Music_icon.svg.png"),
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
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      activeTickMarkColor: Color.fromARGB(255, 231, 61, 77),
                      inactiveTrackColor: Color.fromARGB(255, 94, 93, 93),
                      activeTrackColor: Color.fromARGB(255, 231, 61, 77),
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
                ListTile(
                  title: Obx(() => c.song_list.value.isNotEmpty
                      ? TextScroll(
                          "${c.song_list.value[c.cur_ind.value].title}",
                          mode: TextScrollMode.endless,
                          velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                          delayBefore: Duration(milliseconds: 500),
                          pauseBetween: Duration(seconds: 2),
                          selectable: true,
                          style: TextStyle(color: Colors.white),
                        )
                      // Text(
                      //         "${c.song_list.value[c.cur_ind.value].title}",
                      //         style: TextStyle(color: Colors.white),
                      //         maxLines: 1,
                      //       )
                      : Text("")),
                  leading: Obx(
                    () => c.isplay.value
                        ? Image.
                    network(
                            "https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",
                            height: 50, width: 50,)
                        : Text(""),
                  ),
                  trailing: Obx(
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
                              controller.player.play(DeviceFileSource(
                                  c.song_list.value[c.cur_ind.value].data));
                              c.isplay.value = !c.isplay.value;
                              c.get_duration();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
