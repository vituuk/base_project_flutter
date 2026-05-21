import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/aa_controller.dart';

class AaView extends GetView<AaController> {
  const AaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
