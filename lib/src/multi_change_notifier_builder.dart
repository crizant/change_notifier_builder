import 'package:flutter/material.dart';

/// Creates a widget that rebuilds when one of the given list of listenables changes.
class MultiChangeNotifierBuilder extends StatefulWidget {
  const MultiChangeNotifierBuilder({
    Key? key,
    required this.notifiers,
    required this.builder,
    this.child,
  }) : super(key: key);

  final List<Listenable?> notifiers;

  final Widget Function(
    BuildContext context,
    Widget? child,
  ) builder;

  final Widget? child;

  @override
  _MultiChangeNotifierBuilderState createState() =>
      _MultiChangeNotifierBuilderState();
}

class _MultiChangeNotifierBuilderState
    extends State<MultiChangeNotifierBuilder> {
  Set<Listenable> _listenedNotifiers = {};

  @override
  void initState() {
    super.initState();
    widget.notifiers.forEach((notifier) {
      if (notifier != null) {
        notifier.addListener(_handleChange);
        _listenedNotifiers.add(notifier);
      }
    });
  }

  @override
  void didUpdateWidget(MultiChangeNotifierBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // store outdated items temporarily,
    // to avoid `Concurrent modification during iteration` error
    final Set<Listenable> itemsToRemove = {};
    _listenedNotifiers.forEach((notifier) {
      // remove old notifiers
      if (!widget.notifiers.contains(notifier)) {
        notifier.removeListener(_handleChange);
        itemsToRemove.add(notifier);
      }
    });
    // remove all outdated items
    _listenedNotifiers.removeAll(itemsToRemove);
    widget.notifiers.forEach((notifier) {
      if (notifier != null && !_listenedNotifiers.contains(notifier)) {
        notifier.addListener(_handleChange);
        _listenedNotifiers.add(notifier);
      }
    });
  }

  @override
  void dispose() {
    _listenedNotifiers.forEach((notifier) {
      notifier.removeListener(_handleChange);
    });
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}
