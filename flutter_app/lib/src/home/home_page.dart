import 'package:flutter/material.dart';
import 'package:flutter_app/src/meeting/meeting_page.dart';
import 'package:flutter_app/src/meeting/services/meeting_api_service.dart';
import 'package:flutter_app/src/settings/settings_view.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // Row(children: [
            MyForm(),
            //   ElevatedButton(
            //     onPressed: () {
            //       debugPrint("Start a call");
            //     },
            //     child: const Text("Start a call"),
            //   ),
            // ]),
            // const History(),
          ],
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  static final globalKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  void _startMeeting() async {
    var response = await MeetingApiService.createMeeting();
    if (response != null) {
      Navigator.pushNamed(context, MeetingPage.routeName + "/${response.id}");
    }
  }

  void _joinMeeting() {
    String text = _textController.text;
    // Perform the submission action with the entered text
    print('Submitted: $text');

    Navigator.pushNamed(context, MeetingPage.routeName + "/$text");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: globalKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Meeting ID',
                      prefixIcon: Icon(Icons.video_call),
                    ),
                  )),
                  const SizedBox(width: 20.0),
                  // const SizedBox(height: 20.0),
                  SizedBox(
                    height: 56, // Set the desired height here
                    child: ElevatedButton(
                      onPressed: _joinMeeting,
                      child: Text('Join Meeting'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: 56, // Set the desired height here
                  child: ElevatedButton(
                    onPressed: _startMeeting,
                    child: Text('Start a Meeting'),
                  ))
            ],
          ),
        ));
  }
}
