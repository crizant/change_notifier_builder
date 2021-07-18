import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:change_notifier_builder/change_notifier_builder.dart';

class _TestModel extends ChangeNotifier {
  int _count = 0;

  void increment() {
    _count++;
    notifyListeners();
  }

  int get count => _count;
}

void main() {
  testWidgets(
    '`builder` gets invoked again on model change',
    (WidgetTester tester) async {
      final _TestModel model = _TestModel();
      await tester.pumpWidget(
        ChangeNotifierBuilder(
          notifier: model,
          builder: (BuildContext context, _TestModel? model, _) {
            return MaterialApp(
              home: Text('${model?.count ?? ''}'),
            );
          },
        ),
      );
      // test first render
      expect(find.text('0'), findsOneWidget);

      model.increment();
      await tester.pump();
      // test if the widget is updated according to the model
      expect(find.text('1'), findsOneWidget);
    },
  );
}
