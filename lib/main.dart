import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_address_app/cubit/location_cubit.dart';
import 'package:location_address_app/cubit/location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => LocationCubit(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Location and Address App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: LocationScreen()),
    );
  }
}
