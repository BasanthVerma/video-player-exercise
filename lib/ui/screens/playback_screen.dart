import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_exercise/data/network/constants/endpoints.dart';
import 'package:video_player_exercise/model/resource.dart';
import 'package:video_player_exercise/model/transcript.dart';

import 'package:video_player_exercise/data/network/apis/transcription.dart';

import '../playback/player_lifecycle.dart';
import '../playback/aspect_ratio_video.dart';
import 'package:video_player_exercise/utils/constants.dart';

class PlayBackScreen extends StatefulWidget {
  static const String routeName = "/playback";

  @override
  _PlayBackScreenState createState() => _PlayBackScreenState();
}

class _PlayBackScreenState extends State<PlayBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backgroundGrey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.14,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.68,
                  width: MediaQuery.of(context).size.width * 0.84,
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.045,
                        child: const Text(
                          'Moment from meeting with Two Pillars',
                          style: TextStyle(
                              fontFamily: Constants.primaryFont,
                              fontSize: 16,
                              color: Constants.textPrimaryBlack),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.08,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: MediaQuery.of(context).size.height * 0.2269,
                          width: MediaQuery.of(context).size.width * 0.68,
                          child: Consumer<ResourceModel>(
                              builder: (context, resourceModel, child) {
                            return NetworkPlayerLifeCycle(
                              '${Endpoints.baseUrl}${resourceModel.id}.mp4',
                              (BuildContext context,
                                      VideoPlayerController controller) =>
                                  AspectRatioVideo(controller),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.33,
                        left: MediaQuery.of(context).size.width * 0.10,
                        right: MediaQuery.of(context).size.width * 0.10,
                        child: Text(
                          'Jana Ally',
                          style: TextStyle(
                              fontFamily: Constants.primaryFont,
                              fontSize: 12,
                              color: Constants.textPrimaryBlack),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.37,
                          width: MediaQuery.of(context).size.width * 0.7,
                          left: MediaQuery.of(context).size.width * 0.105,
                          child: Container(
                              color: Constants.backgroundGrey,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Right about or video',
                                  style: TextStyle(
                                      fontFamily: Constants.primaryFont,
                                      fontSize: 12,
                                      color: Constants.textPrimaryBlack,
                                      backgroundColor:
                                          Constants.backgroundGrey),
                                  textAlign: TextAlign.left,
                                ),
                              ))),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.62,
                        left: 20,
                        width: MediaQuery.of(context).size.width * 0.05,
                        child:  Container(
                         child: CustomPaint(painter: Circle(),),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.44,
                        left: MediaQuery.of(context).size.width * 0.105,
                        child: Center(
                          child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.195,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Consumer<ResourceModel>(
                                  builder: (context, resourceModel, child) {
                                return buildTranscriptionView(resourceModel.id);
                              })),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 63,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: SvgPicture.asset("assets/logo/chorus-logo.svg")),
                onTap: showResourceChangeDialog,
              ),
              Container(
                height: 10,
              ),
              Container(
                color: Constants.chorusBlue,
                height: 5,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
        ));
  }

  Widget buildTranscriptionView(resourceId) {
    return FutureBuilder(
      future: TranscriptionApi().getTranscriptionFor(resourceId),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null ||
            projectSnap.data == null) {
          return Container(
            padding: EdgeInsets.all(5),
            color: Constants.backgroundGrey,
            child: Center(
              child: Text(
                  "Failed to fetch resource. Please verify if resource ID is correct."),
            ),
          );
        }

        return Container(
          color: Constants.backgroundGrey,
          child: ListView.builder(
            itemCount: projectSnap.data != null ? projectSnap.data.length : 0,
            itemBuilder: (context, index) {
              Transcript snippetModel = projectSnap.data[index];
              return Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                          "[${formatTime(snippetModel.time)}] \"${snippetModel.snippet ?? "..."}\"",
                          style: TextStyle(
                              fontFamily: Constants.primaryFont,
                              fontSize: 12,
                              color: snippetModel.speaker == Speaker.customer
                                  ? Color(0xffee6eff)
                                  : Color(0xff00A7D1),
                              backgroundColor: Constants.backgroundGrey),
                          textAlign: TextAlign.left),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  formatTime(double time) {
    if (time <= 60) {
      String seconds = "${time.round()}".padLeft(2, "0");
      return "00:$seconds";
    } else {
      int min = (time / 60).floor();
      String seconds = "${(time - (min * 60)).round()}".padLeft(2, "0");
      return "${min.toString().padLeft(2, "0")}:$seconds";
    }
  }

  showResourceChangeDialog() {
    final resourceModel = Provider.of<ResourceModel>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit ID to change Video and transcription.'),
            content: TextField(
              controller: TextEditingController(text: resourceModel.id),
              decoration: InputDecoration(hintText: "Resource ID"),
              onSubmitted: (value) {
                resourceModel.changeId(value);
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class Circle extends CustomPainter {
  Paint _circle, _border;

  Circle() {
    _circle = Paint()
      ..color = Color.fromRGBO(238, 110, 255, 0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    _border = Paint()
      ..color = Color.fromRGBO(238, 110, 255, 1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 12.0, _circle);
    canvas.drawCircle(Offset(0.0, 0.0), 12.0, _border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
