import 'package:flutter/material.dart';
import 'package:take_a_breath/api/youTube_api.dart';
import 'package:take_a_breath/model/channel_model.dart';
import 'package:take_a_breath/model/video_model.dart';
import 'package:take_a_breath/screens/videoScreen.dart';

class YouTubeHome extends StatefulWidget {
  @override
  _YouTubeHomeState createState() => _YouTubeHomeState();
}

class _YouTubeHomeState extends State<YouTubeHome> {
  Channel _channel;
  bool _isLoading = false;

  Channel _headspaceChannel;
  Channel _calmChannel;

  List<Channel> listOfChannels = [];
  List<String> listOfChannelsIDs = [];

  String _headspaceChannelID = 'UC3JhfsgFPLSLNEROQCdj-GQ';
  String _calmID = 'UChSpME3QaSFAWK8Hpmg-Dyw';

  @override
  void initState() {
    _initLists();
    _initChannel();
  }

  _initLists() {
    listOfChannels = [_headspaceChannel, _calmChannel];
    listOfChannelsIDs = [_headspaceChannelID, _calmID];
  }

  //assigning to every channel a proper ID
  _initChannel() async {
    for (int i = 0; i < 2; i++) {
      listOfChannels[i] = await YouToubeAPIService.instance
          .fetchChannel(channelId: listOfChannelsIDs[i]);
    }
  }

  _buildProfileInfo(int i) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(listOfChannels[i].profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  listOfChannels[i].title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${listOfChannels[i].subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Channel'),
      ),
      body: listOfChannels != null
          //scroll notification checks if user is scrolling
          ? NotificationListener<ScrollNotification>(
              //load more videos if:
              //not loading and number of presented videos is smaller than videos on a channel
              //and we are at the bottom of the list view
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel.videos.length != int.parse(_channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {}
                return false;
              },
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return _buildProfileInfo(index);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
