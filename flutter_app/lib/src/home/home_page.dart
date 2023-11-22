import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/meeting/meeting_page.dart';
import 'package:flutter_app/src/meeting/services/meeting_api_service.dart';

@RoutePage()
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                MyApp.of(context).authProvider.logout();
                context.router.pushNamed('/login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _textController = TextEditingController();

  void _startMeeting() async {
    var response = await MeetingApiService.createMeeting();
    if (response != null) {
      context.router.pushNamed("${MeetingPage.routeName}/${response.id}");
    }
  }

  void _joinMeeting() {
    String text = _textController.text;
    // Perform the submission action with the entered text
    print('Submitted: $text');

    context.router.pushNamed("${MeetingPage.routeName}/$text");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _joinMeeting,
                    child: const Text('Join Meeting'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _startMeeting,
                  child: const Text('Start a Meeting'),
                ))
          ],
        ),
      ),
    );
  }
}
