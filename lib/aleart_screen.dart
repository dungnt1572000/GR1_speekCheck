import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Starting point: ${directionsObject.waypoints[0].name}'),
              Text('Destinations: ${directionsObject.waypoints[1].name}'),
              Text('Your current speed: $currentSpeed'),
            Divider(),
            Text('Long distance: ${directionsObject.routes[0].distance}m'),
            Text('Estimate time: ${directionsObject.routes[0].duration}s'),
              Text('Abroad: ${directionsObject.routes[0].countryCrossed}',)
            ],
          ),
        ),
      ),
    );
  }

}
