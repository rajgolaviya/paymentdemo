import 'package:flutter/material.dart';
import 'package:lec_9/playsong.dart';
import 'package:on_audio_query/on_audio_query.dart';

class song extends StatefulWidget {

  @override
  State<song> createState() => _songState();
}

class _songState extends State<song> {
  OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getmusic() async
  {
    List<SongModel> listsong = await _audioQuery.querySongs();
    return listsong;
  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";

    if (twoDigits(duration.inHours) == "00")
    {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    else
    {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }
  List<bool> playcheck=[];

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
          List<SongModel> list=snapshot.data as List<SongModel>;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              SongModel currentsong=list[index];
              return ListTile(
                onTap: () {
                  setState(() {

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return play(list,index);
                    },));
                  });
                },
                title: Text("${currentsong.title}",style: TextStyle(color: Colors.black),),
                trailing: Text(_printDuration(Duration(milliseconds: currentsong.duration!)),
                  style: TextStyle(color: Colors.white),),
              );
            },);
        }
    },
      future: getmusic(),

    );

  }
}
