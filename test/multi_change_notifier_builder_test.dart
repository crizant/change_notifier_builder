import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:change_notifier_builder/change_notifier_builder.dart';

class _TestModel extends ChangeNotifier {
  _TestModel(String value) : _text = value;

  String _text = '';

  void set(String value) {
    _text = value;
    notifyListeners();
  }

  String get text => _text;
}

// A widget which can change the parameters supplied to our builder from outside,
class _WidgetWrapper extends StatefulWidget {
  const _WidgetWrapper({
    Key? key,
    required this.models,
    required this.notifiers,
  }) : super(key: key);

  final List<_TestModel> models;
  final List<_TestModel> notifiers;

  @override
  __WidgetWrapperState createState() => __WidgetWrapperState();
}

class __WidgetWrapperState extends State<_WidgetWrapper> {
  List<_TestModel> _notifiers = [];

  @override
  void initState() {
    super.initState();
    _notifiers = widget.notifiers;
  }

  void changeNotifiers(List<_TestModel> notifiers) {
    setState(() {
      _notifiers = notifiers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiChangeNotifierBuilder(
      notifiers: _notifiers,
      builder: (BuildContext context, _) {
        return Column(
          children: widget.models.map((model) {
            return Text('${model.text}');
          }).toList(),
        );
      },
    );
  }
}

void main() {
  testWidgets(
    '`builder` gets invoked again on models in `notifiers` list change',
    (WidgetTester tester) async {
      final _TestModel model = _TestModel('1');
      final _TestModel model2 = _TestModel('A');
      final _TestModel model3 = _TestModel('I');
      await tester.pumpWidget(
        MaterialApp(
          home: _WidgetWrapper(
            models: [model, model2, model3],
            notifiers: [model, model2],
          ),
        ),
      );
      // test first render
      expect(find.text('1'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('I'), findsOneWidget);

      model.set('2');
      await tester.pump();
      // test if the widget is updated according to the models
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsOneWidget);

      model2.set('B');
      await tester.pump();
      // test if the widget is updated according to the models
      expect(find.text('A'), findsNothing);
      expect(find.text('B'), findsOneWidget);

      model3.set('II');
      await tester.pump();
      // test if the widget is not updated for models not in the `notifiers` list
      expect(find.text('II'), findsNothing);
    },
  );

  testWidgets(
    'addition and removal of listeners upon the change of `notifiers`',
    (WidgetTester tester) async {
      final _TestModel model = _TestModel('1');
      final _TestModel model2 = _TestModel('A');
      final _TestModel model3 = _TestModel('I');
      final GlobalKey<__WidgetWrapperState> wrapperKey =
          GlobalKey<__WidgetWrapperState>();
      await tester.pumpWidget(
        MaterialApp(
          home: _WidgetWrapper(
            key: wrapperKey,
            models: [model, model2, model3],
            notifiers: [model, model2],
          ),
        ),
      );
      // test first render
      expect(find.text('1'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('I'), findsOneWidget);

      wrapperKey.currentState?.changeNotifiers([model, model3]);
      await tester.pump();
      model2.set('B');
      await tester.pump();
      // test if the widget is not updated when being removed in the `notifiers` list
      expect(find.text('A'), findsOneWidget);

      model3.set('II');
      await tester.pump();
      // test if the widget is updated according to the models
      expect(find.text('II'), findsOneWidget);
    },
  );
}
