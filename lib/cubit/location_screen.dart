import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_address_app/cubit/location_cubit.dart';
import 'package:location_address_app/cubit/location_state.dart';

class LocationScreen extends StatelessWidget {
  final TextEditingController googleMapController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();

  LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location and Address App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return const CircularProgressIndicator();
                } else if (state is LocationError) {
                  return Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is LocationLoaded) {
                  return Text(
                    'Address: ${state.address}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  );
                }
                return const Text('Address: ');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<LocationCubit>().getCurrentLocation();
              },
              child: const Text('Get Current Location'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: googleMapController,
              decoration: const InputDecoration(
                labelText: 'Enter Google Maps Link',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<LocationCubit>()
                    .getAddressFromGoogleMapsLink(googleMapController.text);
              },
              child: const Text('Get Address from Link'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: latController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Latitude',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: lonController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Longitude',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double lat = double.parse(latController.text);
                double lon = double.parse(lonController.text);
                context
                    .read<LocationCubit>()
                    .getAddressFromCoordinates(lat, lon);
              },
              child: const Text('Get Address from Coordinates'),
            ),
          ],
        ),
      ),
    );
  }
}
