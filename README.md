# change_notifier_builder

A widget whose content stays synced with a [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html).

## What is this?

Many of us flutter developers use [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) for state management, but there is no such thing as `ChangeNotifierBuilder`.

This is basically an [`AnimatedBuilder`](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html) provided by flutter sdk, with a few minor modifitcations. Actually you might use [`AnimatedBuilder`](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html) instead.

## Why you created this?

I created this package for 3 reasons.

1. For the purpose of state management, `ChangeNotifierBuilder` is a more reasonable and readable name than `AnimatedBuilder`, for a builder widget.

2. Sometimes our model is not yet ready (i.e. equals `null`). In this case if you use `AnimatedBuilder` it throws "animation cannot be null" exception. However if you use `ChangeNotifierBuilder`, the runtime value of `notifier` can be `null`.

3. The `builder` method provides you the `T notifier` object as a parameter, which is a bit more user-friendly.

## Example

Let's say you have a model of `ChangeNotifier` like this:

```dart
class CounterModel extends ChangeNotifier {
  int _count = 0;

  void increment() {
    _count++;
    notifyListeners();
  }

  int get count => _count;
}
```

Then in the build method of your widget:

```dart
ChangeNotifierBuilder(
  // supply the instance of `ChangeNotifier` model,
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
)
```

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/crizant/change_notifier_builder/issues).
If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/crizant/change_notifier_builder/pulls).
