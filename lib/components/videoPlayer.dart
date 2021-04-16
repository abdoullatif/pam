
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pam/components/custom_control_widget.dart';
import 'package:pam/components/video_controller_widget.dart';
import 'package:pam/components/video_progress_indicator.dart';
import 'package:pam/database/database.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoPlayerScreen();
  }
}

class VideoPlayerScreen extends StatefulWidget {

  final List<Duration> timestamps;

  const VideoPlayerScreen({
    @required this.timestamps,
    Key key,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {

    // Use the controller to loop the video.
    //_controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context).settings.arguments;

    Future<List<Map<String, dynamic>>> Media() async{
      List<Map<String, dynamic>> queryRows = await DB.queryMedia(id);
      //print(queryRows);
      return queryRows;
    }
    final _Media = FutureBuilder(
        future: Media(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //si il ya une eurreur lor du chargement
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement"),
            );
          }

          //print(snap[0]['media_file']);

          _controller = VideoPlayerController.file(
            File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}"),
          );

          // Initialize the controller and store the Future for later use.
          _initializeVideoPlayerFuture = _controller.initialize();

          //_controller.setLooping(true);
          _controller.addListener(() {
            //setState(() {});
          });
          _controller.setLooping(true);
          _controller.initialize();

          return Center(
            child: Container(
              //margin: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Card(
                elevation: 5,
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.done) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              // Use the VideoPlayer widget to display the video.
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  VideoPlayer(_controller),
                                  VideoControlsWidget(controller: _controller),
                                  CustomVideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    timestamps: widget.timestamps,
                                  ),
                                  SizedBox(height: 12),
                                  CustomControlsWidget(
                                    controller: _controller,
                                    timestamps: widget.timestamps,
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            //CustomControlsWidget(),
                          ],
                        ),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          );
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: _Media,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}


/*
  floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),

*
* */