import 'package:flutter/material.dart';
import 'package:youtube_downloader/downloader.dart';
import 'package:youtube_downloader/getSharedData.dart';

class PasteLinkPage extends StatefulWidget {
  const PasteLinkPage({Key? key}) : super(key: key);

  @override
  State<PasteLinkPage> createState() => _PasteLinkPageState();
}

class _PasteLinkPageState extends State<PasteLinkPage>
    with WidgetsBindingObserver {
  TextEditingController _textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    DataClass().sharedData().then((value) {
      setState(() {
        _textEditingController.text = value;
      });
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('appLifeCycleState resumed');
      DataClass().sharedData().then((value) {
        print('----- RECEIVED DATA -----');
        print(value);
        setState(() {
          _textEditingController.text = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Text form field
              TextFormField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    labelText: "Paste here the Youtube video link"),
              ),
              //button to download
              GestureDetector(
                onTap: (() {
                  if (_textEditingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("no link has been pasted")));
                  } else {
                    //download video
                    Download().downloadVideo(
                        _textEditingController.text.trim(), 'Youtube');
                  }
                }),
                child: DownloadButton(
                  isLoading: isLoading,
                  buttonColor: Colors.red,
                  buttonText: "Download Video",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //download Audio only
              GestureDetector(
                onTap: (() async {
                  if (_textEditingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("no link has been pasted")));
                  } else {
                    //download video
                    if (isLoading) return;
                    setState(() => isLoading = true);
                    String path = await Download()
                        .downloadAudio(_textEditingController.text.trim());
                    setState(() => isLoading = false);
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              Text('Download completed and saved to: ${path}'),
                        );
                      },
                    );
                  }
                }),
                child: DownloadButton(
                  isLoading: isLoading,
                  buttonColor: Colors.orange,
                  buttonText: "Download Audio Only",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton(
      {Key? key,
      required this.isLoading,
      required this.buttonText,
      required this.buttonColor})
      : super(key: key);

  final bool isLoading;
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: buttonColor,
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
      padding: const EdgeInsets.all(20),
    );
  }
}
