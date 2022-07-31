import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class Download {
  Future<void> downloadVideo(String youTube_link, String title) async {
    final result =
        await FlutterYoutubeDownloader.downloadVideo(youTube_link, title, 18);
    print(result);
  }

  Future<String> downloadAudio(String url) async {
    var yt = YoutubeExplode();
    var id = VideoId(url.trim());
    var video = await yt.videos.get(id);
    var title = video.title;
    var duration = video.duration;

    var correctedTitle = title.replaceAll('[', '').replaceAll(']', '');

    print('Download $title . Duration is $duration');

    await Permission.storage.request();

    // Get the streams manifest and the audio track.
    var manifest = await yt.videos.streamsClient.getManifest(id);
    var audio = manifest.audioOnly.last;

    // Build the directory.
    var dir = await DownloadsPathProvider.downloadsDirectory;
    var filePath = path.join(dir.uri.toFilePath(), '${title}.mp3');

    print(filePath);

    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    print('Start download');
    await yt.videos.streamsClient.get(audio).pipe(fileStream);
    /*
    If you want to show a % of download, you should listen
    to the stream instead of using `pipe` and compare
    the current downloaded streams to the totalBytes,
    see an example ii example/video_download.dart
      */
    print('END DOWNLOAD');

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    // Close the YoutubeExplode's http client.
    yt.close();

    return dir.uri.toFilePath() + '${title}.mp3';
  }
}
