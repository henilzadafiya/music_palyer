import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';
import 'package:on_audio_room/on_audio_room.dart';

class controller extends GetxController {
  RxList<SongModel> song_list = RxList();
  RxList<AlbumModel> album_list = RxList();
  RxList<FavoritesEntity> fav_list = RxList();
  RxList<AlbumModel> get_arti = RxList();
  RxList<SongModel> getall_album = RxList();
  RxBool isplay = false.obs;
  RxBool fav = false.obs;
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static AudioPlayer player = AudioPlayer();
  RxDouble duration = 0.0.obs;

  RxInt cur_ind = 0.obs;

  get_song() async {
    song_list.value = await _audioQuery.querySongs();
    return song_list;
  }

  get_album() async {
    album_list.value = await _audioQuery.queryAlbums();
    return album_list;
  }

  get_artis() async {
    get_arti.value = await _audioQuery.queryAlbums();
    return get_arti;
  }

  get_album_list(int albumid) async {
    getall_album.value =
    await _audioQuery.queryAudiosFrom(AudiosFromType.ALBUM_ID, albumid);
    return getall_album;
  }

  get_duration() {
    player.onPositionChanged.listen((Duration d) {
      duration.value = d.inMilliseconds.toDouble();
    });
  }

  get_fav() async {
    fav_list.value = await OnAudioRoom().queryFavorites();
    return fav_list;
  }
  get_check() async {
    fav.value = await OnAudioRoom().checkIn(RoomType.FAVORITES, song_list.value[cur_ind.value].id);
  }
}
