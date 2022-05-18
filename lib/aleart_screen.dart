import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertScreen extends ConsumerStatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends ConsumerState<AlertScreen> {
  
  @override
  Widget build(BuildContext context) {
    
    var currentSpeed = ref.watch(speedProvider);
    DirectionObject directionsObject = ref.watch(directionsProvider);
    var _long = ref.read(longtitudeProvider);
    var _late = ref.read(latetitudeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Starting point: ${directionsObject.waypoints[0].name}'),
            Text('Destinations: ${directionsObject.waypoints[1].name}'),
            Text('Your current speed: $currentSpeed'),
          const Divider(),
          Text('Long distance: ${directionsObject.routes[0].distance}m'),
          Text('Estimate time: ${directionsObject.routes[0].duration}s'),
            Text('Abroad: ${directionsObject.routes[0].countryCrossed}',),
            Text('Current Acceptable Speed in road:')
          ],
        ),
      ),
    );
  }

}
