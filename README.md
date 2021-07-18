# change_notifier_builder

A widget whose content stays synced with a `ChangeNotifier`.

## What is this?

Many of us flutter developers use `ChangeNotifier` for state management, but there is no such thing as `ChangeNotifierBuilder`.

This is basically an `AnimatedBuilder` provided by flutter sdk, with a few minor modifitcations. Actually you might use `AnimatedBuilder` instead.

## Why you created this?

I created this package for 3 reasons.

1. For the purpose of state management, `ChangeNotifierBuilder` is a more reasonable and readable name than `AnimatedBuilder`, for a builder widget.

2. Sometimes our model is not yet ready (i.e. equals `null`). In this case if you use `AnimatedBuilder` it throws "animation cannot be null" exception. However if you use `ChangeNotifierBuilder`, the runtime value of `notifier` can be `null`.

3. The `builder` method provides you the `T notifier` object as a parameter, which is a bit more user-friendly.