import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:my_travaly_task/services/prefs.dart';

import '../../constants/app_strings.dart';
import '../../models/device_register_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthGoogleSignIn>(_onAuthGoogleSignIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthCheckStatus>(_onAuthCheckStatus);
    add(AuthCheckStatus());
  }

  Future<void> _onAuthCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    try {
      final token = await Prefs.getVisitorToken();
      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess(''));
      }
    } catch (e) {
      debugPrint('Auth check status error: $e');
    }
  }

  void _onAuthGoogleSignIn(AuthGoogleSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      _googleSignIn.initialize(
        serverClientId: "256074459797-r2q00ul6umjdas6ks3hnd53e83up2qhi.apps.googleusercontent.com",
      );
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(scopeHint: ['email', 'profile']);
      final deviceInfo = DeviceInfoPlugin();
      DeviceRegister deviceRegister;
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;

        deviceRegister = DeviceRegister(
          deviceModel: info.model,
          deviceFingerprint: info.fingerprint,
          deviceBrand: info.brand,
          deviceId: info.id,
          deviceName: info.device,
          deviceManufacturer: info.manufacturer,
          deviceProduct: info.product,
          deviceSerialNumber: "UNKNOWN",
        );
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;

        deviceRegister = DeviceRegister(
          deviceModel: info.utsname.machine,
          deviceFingerprint: info.identifierForVendor ?? 'unknown',
          deviceBrand: 'Apple',
          deviceId: info.name,
          deviceName: info.systemName,
          deviceManufacturer: 'Apple',
          deviceProduct: info.model,
          deviceSerialNumber: 'unknown',
        );
      } else {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;

        deviceRegister = DeviceRegister(
          deviceModel: webBrowserInfo.userAgent ?? 'unknown',
          deviceFingerprint: webBrowserInfo.vendor ?? 'unknown',
          deviceBrand: 'Web',
          deviceId: webBrowserInfo.appVersion ?? 'unknown',
          deviceName: webBrowserInfo.platform ?? 'unknown',
          deviceManufacturer: 'Web',
          deviceProduct: webBrowserInfo.product ?? 'unknown',
          deviceSerialNumber: 'unknown',
        );
      }

      final response = await http.post(
        Uri.parse(AppStrings.baseUrl),
        headers: {'Content-Type': 'application/json', 'authtoken': AppStrings.authToken},
        body: jsonEncode({'deviceRegister': deviceRegister.toJson(), "action": "deviceRegister"}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await Prefs.setVisitorToken(data['data']['visitorToken']);
        emit(AuthSuccess(googleUser.displayName ?? ''));
      } else {
        emit(AuthFailure('Failed to login: ${response.body}'));
      }
    } on GoogleSignInException catch (e) {
      emit(AuthFailure(e.description ?? "Google Sign-In failed"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Prefs.setVisitorToken('');
      await Prefs.setAuthToken('');
      await _googleSignIn.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
