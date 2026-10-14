import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

class OmrahSocket {
  final TokenManager _tokenManager;
  IO.Socket? _socket;

  OmrahSocket(this._tokenManager);

  final _locationUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get locationUpdates =>
      _locationUpdateController.stream;

  final _errorController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get errors => _errorController.stream;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;

    final token = await _tokenManager.token;
    final accessToken = token?.accessToken ?? '';

    String url = 'https://api.moneeb.io/tracking';

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io')
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .build(),
    );

    _socket?.onConnect((_) {
      log('OmrahSocket connected');
    });

    _socket?.on('location-update', (data) {
      log('OmrahSocket location-update: $data');
      if (data is Map<String, dynamic>) {
        _locationUpdateController.add(data);
      }
    });

    _socket?.on('error', (error) {
      log('OmrahSocket error: $error');
      if (error is Map<String, dynamic>) {
        _errorController.add(error);
      }
    });

    _socket?.onDisconnect((_) {
      log('OmrahSocket disconnected');
    });

    _socket?.connect();
  }

  void subscribe(String orderId) {
    _socket?.emit('subscribe', {'orderId': orderId});
    log('OmrahSocket subscribed to order: $orderId');
  }
  //
  // void unsubscribe(String orderId) {
  //   _socket?.emit('unsubscribe', {'orderId': orderId});
  //   log('OmrahSocket unsubscribed from order: $orderId');
  // }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    log('OmrahSocket disconnected explicitly');
  }

  @disposeMethod
  void dispose() {
    disconnect();
    _locationUpdateController.close();
    _errorController.close();
  }
}

class LocationUpdatePayload {
  final String? orderId;
  final double? lat;
  final double? lng;
  final int? timestamp;
  final double? accuracyMeters;
  final double? altitudeM;
  final double? heading;
  final double? speedMps;
  final bool? isBackgroundUpdate;
  final int? batteryLevelPercent;
  final bool? isCharging;

  LocationUpdatePayload({
    this.orderId,
    this.lat,
    this.lng,
    this.timestamp,
    this.accuracyMeters,
    this.altitudeM,
    this.heading,
    this.speedMps,
    this.isBackgroundUpdate,
    this.batteryLevelPercent,
    this.isCharging,
  });

  factory LocationUpdatePayload.fromJson(Map<String, dynamic> json) {
    return LocationUpdatePayload(
      orderId: json['orderId'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as int?,
      accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
      altitudeM: (json['altitudeM'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speedMps: (json['speedMps'] as num?)?.toDouble(),
      isBackgroundUpdate: json['isBackgroundUpdate'] as bool?,
      batteryLevelPercent: json['batteryLevelPercent'] as int?,
      isCharging: json['isCharging'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (orderId != null) 'orderId': orderId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (timestamp != null) 'timestamp': timestamp,
      if (accuracyMeters != null) 'accuracyMeters': accuracyMeters,
      if (altitudeM != null) 'altitudeM': altitudeM,
      if (heading != null) 'heading': heading,
      if (speedMps != null) 'speedMps': speedMps,
      if (isBackgroundUpdate != null) 'isBackgroundUpdate': isBackgroundUpdate,
      if (batteryLevelPercent != null) 'batteryLevelPercent': batteryLevelPercent,
      if (isCharging != null) 'isCharging': isCharging,
    };
  }
}