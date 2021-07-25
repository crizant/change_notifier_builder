// Flutter imports:
import 'package:flutter/material.dart';

/// A widget whose content stays synced with a ChangeNotifier.
/// Given a `notifier` of a subclass of ChangeNotifier
/// and a `builder` which builds widgets from properties of `notifier`,
/// this class will automatically register itself as a listener of the ChangeNotifier
/// and calls the `builder` method when the ChangeNotifier updates.
class ChangeNotifierBuilder<T extends ChangeNotifier> extends AnimatedWidget {
  ChangeNotifierBuilder({
    Key? key,
    required this.notifier,
    required this.builder,
    this.child,
  }) : super(key: key, listenable: notifier ?? ChangeNotifier());

  final T? notifier;
  final Widget Function(
    BuildContext context,
    T? notifier,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, notifier, child);
  }
}
