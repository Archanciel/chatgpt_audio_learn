import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class Alarm {
  final String time;

  Alarm(this.time);
}

class AlarmViewModel extends ChangeNotifier {
  final String alarmWork = 'alarmWork';
  
  setAlarm(Alarm alarm) {
    Workmanager().registerOneOffTask(
      '1', 
      alarmWork, 
      inputData: {'time': alarm.time}
    );
  }
}

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Alarm'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            String time = '16:14';
            Provider.of<AlarmViewModel>(context, listen: false)
              .setAlarm(Alarm(time));
              print('Alarm set at $time');
          },
          child: const Text('Set Alarm'),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AlarmViewModel(),
      child: MaterialApp(
        title: 'Alarm App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AlarmPage(),
      ),
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print('Alarm fired at ${inputData!['time']}');
    return Future.value(true);
  });
}

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // set it to false when in production mode.
  );

  runApp(const MyApp());
}


