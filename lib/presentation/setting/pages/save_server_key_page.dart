import 'package:flutter/material.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';

class SaveServerKeyPage extends StatefulWidget {
  const SaveServerKeyPage({super.key});

  @override
  State<SaveServerKeyPage> createState() => _SaveServerKeyPageState();
}

class _SaveServerKeyPageState extends State<SaveServerKeyPage> {
  TextEditingController? serverKeyController;

  Future<void> getSerVerKey() async {
    serverKeyController!.text =
        await AuthLocalDatasource().getMidtransServerKey();
  }

  @override
  void initState() {
    super.initState();
    serverKeyController = TextEditingController();
    getSerVerKey();
  }

  @override
  void dispose() {
    serverKeyController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Save Server Key',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: serverKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server Key',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              AuthLocalDatasource()
                  .saveMidtransServerKey(serverKeyController?.text ?? '');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Server Key saved',
                  ),
                ),
              );
              context.pop();
            },
            child: const Text(
              'Save',
            ),
          ),
        ],
      ),
    );
  }
}
