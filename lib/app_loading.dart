import 'package:doan1/constant/all_of_enum.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final Widget child;
  final LoadingStatus status;

  const AppLoading({
    Key? key,
    required this.child,
    required this.status,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: status == LoadingStatus.inProcess,
          child: child,
        ),
        Visibility(
          child: const CircularProgressIndicator(),
          visible: status == LoadingStatus.inProcess,
        ),
      ],
    );
  }
}
