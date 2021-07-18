import 'package:flutter/material.dart';
import 'package:change_notifier_builder/change_notifier_builder.dart';

void main() {
  runApp(MyApp());
}

class CounterModel extends ChangeNotifier {
  int _count = 0;

  void increment() {
    _count++;
    notifyListeners();
  }

  int get count => _count;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // create model
  final CounterModel _counterModel = CounterModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            ChangeNotifierBuilder(
              // supply the `ChangeNotifier` model,
              // whether you get it from the build context or anywhere
              notifier: _counterModel,
              // this builder function will be executed,
              // once the `ChangeNotifier` model is updated
              builder: (BuildContext context, CounterModel? counter, _) {
                return Text(
                  '${counter?.count ?? ''}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _counterModel.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
