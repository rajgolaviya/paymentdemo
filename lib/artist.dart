import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class artist extends StatefulWidget {

  @override
  State<artist> createState() => _artistState();
}

class _artistState extends State<artist> {

  OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<ArtistModel>> getmusic() async
  {
    List<ArtistModel> artistsong = await _audioQuery.queryArtists();
    return artistsong;
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
          List<ArtistModel> list=snapshot.data as List<ArtistModel>;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index)
            {
              ArtistModel currentartist=list[index];
              print(_printDuration(Duration(milliseconds: currentartist.id)));

              return ListTile(
                title: Text("${currentartist.artist}"),
                trailing: Text("${currentartist.numberOfTracks}"),
              );
            },);
        }
      },
          future: getmusic());
  }
}
