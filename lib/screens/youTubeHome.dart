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
  Channel _channel1;
  Channel _channel2;
  bool _isLoading = false;
  List<Channel> listOfChannels = [];
  List<Channel> listOfChannelsID = [];
  String _headspaceChannelID = 'UC3JhfsgFPLSLNEROQCdj-GQ';
  String _calmID = 'UChSpME3QaSFAWK8Hpmg-Dyw';

  @override
  void initState() {
    _initChannel1();
    _initChannel2();
    //listOfChannels = [_channel1, _channel2];
    // TODO: implement initState
    listOfChannels = [_channel1, _channel2];
    List<String> listOfChannelsIDs = [];

    super.initState();
  }

  _initChannel1() async {
    Channel channel = await YouToubeAPIService.instance
        .fetchChannel(channelId: 'UC3JhfsgFPLSLNEROQCdj-GQ');
    setState(() {
      _channel1 = channel;
    });
  }

  _initChannel2() async {
    Channel channel = await YouToubeAPIService.instance
        .fetchChannel(channelId: 'UChSpME3QaSFAWK8Hpmg-Dyw');
    setState(() {
      _channel2 = channel;
    });
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
    listOfChannels = [_channel1, _channel2];
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Channels'),
      ),
      body: listOfChannels[0] != null
          //scroll notification checks if user is scrolling
          ? NotificationListener<ScrollNotification>(
              //load more videos if:
              //not loading and number of presented videos is smaller than videos on a channel
              //and we are at the bottom of the list view
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel1.videos.length !=
                        int.parse(_channel1.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {}
                return false;
              },
              child: ListView.builder(
                itemCount: listOfChannels.length,
                itemBuilder: (BuildContext context, int index) {
                  if (listOfChannels[index].profilePictureUrl == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor, // Red
                        ),
                      ),
                    );
                  } else {
                    return _buildProfileInfo(index);
                  }
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
