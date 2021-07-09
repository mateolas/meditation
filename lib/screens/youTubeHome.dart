import 'package:flutter/material.dart';
import 'package:take_a_breath/api/youTube_api.dart';
import 'package:take_a_breath/model/channel_model.dart';
import 'package:take_a_breath/model/video_model.dart';
import 'package:take_a_breath/screens/videoScreen.dart';
import 'package:take_a_breath/screens/youTubeChannel.dart';

//class to present list of channels
//by clicking on channel you're redirected to YouTubeChannel class
//which present videos from particular channel
class YouTubeHome extends StatefulWidget {
  @override
  _YouTubeHomeState createState() => _YouTubeHomeState();
}

class _YouTubeHomeState extends State<YouTubeHome> {
  Channel _headSpaceChannel;
  Channel _calmChannel;
  Channel _goodfulChannel;
  Channel _theMindfulMovementChannel;
  Channel _sriSriChannel;
  Channel _buddhistSocietyOfWAChannel;
  Channel _wisdomChannel;
  Channel _mindfulMusicChannel;
  String _headspaceChannelID = 'UC3JhfsgFPLSLNEROQCdj-GQ';
  String _calmID = 'UChSpME3QaSFAWK8Hpmg-Dyw';
  String _goodfulID = 'UCEMArgthHuEtX-04qL_8puQ';
  String _theMindfulMovementID = 'UCu_mPlZbomAgNzfAUElRL7w';
  String _sriSriID = 'UC4qz5w2M-Xmju7WC9ynqRtw';
  String _buddhistSocietyOfWAID = 'UC6M_EhnSSdTG_SXUp6IAWmQ';
  String _wisdomID = 'UCEhl4Grr46IolhzGhZ3agNw';
  String _mindfulMusicID = 'UCK7X0kE4vCbOXPi1VPVQYFw';
  bool _channelsAreLoaded = false;
  List<Channel> listOfChannels = [];
  List<String> listOfChannelsID = [];

  @override
  void initState() {
    listOfChannelsID = [
      _calmID,
      _buddhistSocietyOfWAID,
      _headspaceChannelID,
      _sriSriID,
      _goodfulID,
      _theMindfulMovementID,
      _wisdomID,
      _mindfulMusicID
    ];

    _channelsAreLoaded = false;

    _initChannels();

    super.initState();
  }

  _initChannels() async {
    Channel channel = await YouToubeAPIService.instance
        .fetchChannel(channelId: _headspaceChannelID);
    setState(() {
      _headSpaceChannel = channel;
    });

    Channel channel2 =
        await YouToubeAPIService.instance.fetchChannel(channelId: _calmID);
    setState(() {
      _calmChannel = channel2;
    });

    Channel channel3 =
        await YouToubeAPIService.instance.fetchChannel(channelId: _goodfulID);
    setState(() {
      _goodfulChannel = channel3;
    });

    Channel channel4 = await YouToubeAPIService.instance
        .fetchChannel(channelId: _theMindfulMovementID);
    setState(() {
      _theMindfulMovementChannel = channel4;
    });

    Channel channel5 =
        await YouToubeAPIService.instance.fetchChannel(channelId: _sriSriID);
    setState(() {
      _sriSriChannel = channel5;
    });

    Channel channel6 = await YouToubeAPIService.instance
        .fetchChannel(channelId: _buddhistSocietyOfWAID);
    setState(() {
      _buddhistSocietyOfWAChannel = channel6;
    });

    Channel channel7 =
        await YouToubeAPIService.instance.fetchChannel(channelId: _wisdomID);
    setState(() {
      _wisdomChannel = channel7;
    });

    Channel channel8 = await YouToubeAPIService.instance
        .fetchChannel(channelId: _mindfulMusicID);
    setState(() {
      _mindfulMusicChannel = channel8;
    });

    _channelsAreLoaded = true;
  }

  Widget _buildProfileInfo(int i) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
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
    listOfChannels = [
      _calmChannel,
      _buddhistSocietyOfWAChannel,
      _headSpaceChannel,
      _sriSriChannel,
      _goodfulChannel,
      _theMindfulMovementChannel,
      _wisdomChannel,
      _mindfulMusicChannel
    ];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffe65c00),
                  Color(0xffFFE000),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height / 9,
            width: MediaQuery.of(context).size.width,
          ),
          Expanded(
            flex: 4,
            child: _channelsAreLoaded == true
                //scroll notification checks if user is scrolling
                ? ListView.builder(
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
                        return GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        YouTubeChannel(listOfChannelsID[index]),
                                  ),
                                ),
                            child: _buildProfileInfo(index));
                      }
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor, // Red
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
