// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import 'handler.dart';
import 'config.dart';

RedisService? SERVICE;

void main() async {
  final conf = Config();

  final service = RedisService();
  await service.connect(
      conf.redisHost, conf.redisPort, conf.redisUser, conf.redisPassword);

  SERVICE = service;

  runApp(const MyApp());
}

class SpeedSlider extends StatefulWidget {
  const SpeedSlider({super.key});

  @override
  State<SpeedSlider> createState() => _SpeedSliderState();
}

class _SpeedSliderState extends State<SpeedSlider> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return (Slider(
        onChanged: (value) {
          var data = {'action': 'speed', 'speed': value};
          SERVICE!.sendPayload(data);
          setState(() {
            _sliderValue = value;
          });
        },
        value: _sliderValue));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rover ixv1',
      color: const Color.fromRGBO(44, 44, 44, 1),
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rover ixv1'),
          backgroundColor: const Color.fromRGBO(64, 60, 60, 1),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Rover ixv1',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const Image(
                image: NetworkImage(
                    'https://media.discordapp.net/attachments/822902690010103818/1018480151257960478/ori-robot-trilobot-pim598-34806-removebg-preview.png'),
                width: 125,
                height: 112),
            Center(child: Joystick(listener: (details) {
              var data = {
                'action': 'direction',
                'direction': [details.x, details.y]
              };
              SERVICE!.sendPayload(data);
            })),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  iconSize: 55,
                  onPressed: () {
                    var data = {'action': 'speed', 'speed': 'toggle'};
                    SERVICE!.sendPayload(data);
                  },
                  icon: const Icon(Icons.power)),
              IconButton(
                  icon: const Icon(Icons.wb_twilight),
                  iconSize: 55,
                  onPressed: () {
                    var data = {'action': 'lights', 'lights': 'toggle'};
                    SERVICE!.sendPayload(data);
                  }),
              IconButton(
                  icon: const Icon(Icons.electric_car),
                  iconSize: 55,
                  onPressed: () {
                    var data = {'action': 'sweep'};
                    SERVICE!.sendPayload(data);
                  })
            ]),
            const SpeedSlider()
          ],
        ),
      ),
    );
  }
}
