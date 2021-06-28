import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:take_a_breath/model/channel_model.dart';
import 'package:take_a_breath/model/video_model.dart';
import 'package:take_a_breath/utilities/keys.dart';

class APIService {
  //in order to keep track of our nextPageToken throughtout lifetime of our app
  //turning APIService class into a singleton
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  //stores first part of URL
  final String _baseUrl = 'www.googleapis.com';
  //stores next batch of videos
  String _nextPageToken = '';

  //takes channelId and return Future Channel as its async
  Future<Channel> fetchChannel({String channelId}) async {
    //parameters specifies data we want to receive
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      //key to identifiy our API request
      'key': API_KEY,
    };

    //consits of base url which we created above and specifing the url end point
    //which we want to have
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    //content of headers ensures that the get requests return a JSON object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    //to get response we're passing uri and header
    var response = await http.get(uri, headers: headers);
    //status code 200 = succesfuly retrieved data
    if (response.statusCode == 200) {
      //decode body of our response and store the first value of the items list
      //json which contains the channel information in a map
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      //using factory methond to convert Map to a channel object
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      //store the list of JSON vidoes located in data items
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
