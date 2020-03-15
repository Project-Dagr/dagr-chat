import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import './BluetoothDeviceListEntry.dart';

class BLEDevicePage extends StatefulWidget {
  /// If true, on page start there is performed discovery upon the bonded devices.
  /// Then, if they are not avaliable, they would be disabled from the selection.
  final bool checkAvailability;

  const BLEDevicePage({this.checkAvailability = true});

  @override
  _BLEDevicePage createState() => new _BLEDevicePage();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _BLEDevicePage extends State<BLEDevicePage> {
  List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

  StreamSubscription<List<ScanResult>> _discoveryStreamSubscription;
  bool _isDiscovering;

  _BLEDevicePage();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    setState(() {
      devices = List<_DeviceWithAvailability>();
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));

    _discoveryStreamSubscription =
        FlutterBlue.instance.scanResults.listen((scanResults) {
      setState(() {
        devices = scanResults
            .where((result) => result.device.name.startsWith("Dagr"))
            .toList()
            .map((result) => _DeviceWithAvailability(
                result.device, _DeviceAvailability.yes, result.rssi))
            .toList();
      });
      // scanResults.forEach((result) => {
      //       // {print('${result.device.name} found! rssi: ${result.rssi}')});
      //       setState(() {
      //         if(devices.length > 0){
      //         Iterator i = devices.iterator;
      //         while (i.moveNext()) {
      //           var _device = i.current;
      //           if (_device.device == result.device) {
      //             _device.availability = _DeviceAvailability.yes;
      //             _device.rssi = result.rssi;
      //           }
      //         }
      //         }else {
      //           devices.add(_DeviceWithAvailability(result.device, _DeviceAvailability.yes, result.rssi));
      //         }

      //       })
      //     });

      _discoveryStreamSubscription.onDone(() {
        setState(() {
          _isDiscovering = false;
        });
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();
    FlutterBlue.instance.stopScan();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                Navigator.of(context).pop(_device.device);
              },
            ))
        .toList();
    return Scaffold(
        appBar: AppBar(
          title: Text('Select device'),
          actions: <Widget>[
            (_isDiscovering
                ? FittedBox(
                    child: Container(
                        margin: new EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))))
                : IconButton(
                    icon: Icon(Icons.replay), onPressed: _restartDiscovery))
          ],
        ),
        body: ListView(children: list));
  }
}
