import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class album extends StatefulWidget {

  @override
  State<album> createState() => _albumState();
}

class _albumState extends State<album> {

  OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<AlbumModel>> getmusic() async
  {
    List<AlbumModel> albumsong = await _audioQuery.queryAlbums();
    return albumsong;
  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";

    if (twoDigits(duration.inHours) == "00") {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

    @override
  Widget build(BuildContext context) {

    return
      FutureBuilder(builder: (context, snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting)
        {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else
        {
          List<AlbumModel> list=snapshot.data as List<AlbumModel>;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index)
            {
              AlbumModel currentalbum=list[index];
              print(_printDuration(Duration(milliseconds: currentalbum.id)));

              return ListTile(
                title: Text("${currentalbum.album}"),
                trailing: Text("${currentalbum.numOfSongs}"),
              );
            },);
        }
      },
          future: getmusic());
    }
}
