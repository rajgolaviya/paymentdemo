import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class play extends StatefulWidget {

  List<SongModel>? list;
  int? pos;

  play(this.list,this.pos);

  @override
  State<play> createState() => _playState();
}

class _playState extends State<play> {

  SongModel? currentsong;
  bool play=false;
  double max=0;
  double current=0;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentsong=widget.list![widget.pos!];
    audioPlayer.onAudioPositionChanged.listen((event) {
      print("===>$event");
      setState(() {
        current=event.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onDurationChanged.listen((event) {
      print(event);
      setState(() {
        current=event.inMilliseconds.toDouble();
      });
    });

  }


  @override
  void dispose() {
    super.dispose();
    audioPlayer.pause().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(onWillPop: () async {
       await audioPlayer.pause();
       return true;
      },
          child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              child: Text("${currentsong!.title}"),
              alignment: Alignment.center,
            ),
            Container(
              child: Text("${currentsong!.artist}"),
              alignment: Alignment.center,
            ),
            Spacer(),
            Slider(
              onChanged: (value) async {
                await audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
              min: 0,
              max: max,
              value: current,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () async {
                  setState(() {
                    widget.pos=widget.pos!-1;
                    currentsong=widget.list![widget.pos!];
                  });
                  await audioPlayer.pause();
                  await audioPlayer.play(currentsong!.data,isLocal: true);
                  audioPlayer.getDuration().then((value) {
                    setState(() {
                      max=value.toDouble();
                    });
                  });
                }, icon: Icon(Icons.skip_previous)),
                play?IconButton(onPressed: () async {
                  setState(() {
                    play=!play;
                  });
                  await audioPlayer.pause();
                }, icon: Icon(Icons.pause)):
                IconButton(onPressed: () async {
                  setState(() {
                    play=!play;
                  });
                  await audioPlayer.play(currentsong!.data, isLocal: true);
                }, icon: Icon(Icons.play_arrow_rounded)),
                IconButton(onPressed: () async {
                  setState(() {
                    widget.pos=widget.pos!+1;
                    currentsong=widget.list![widget.pos!];
                  });
                  await audioPlayer.pause();
                  await audioPlayer.play(currentsong!.data,isLocal: true);
                }, icon: Icon(Icons.skip_next)),
              ],
            )
          ],
        ),
      )
      );
  }
}