import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:delcommerce/core/enums/status.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';
import 'package:delcommerce/core/utils/helpers/logger_helper.dart';

class LocationHelper {
  static LocationSettings getPlatformSpecificSettings() {
    if (Platform.isAndroid) {
      LoggerHelper.info("Using Android-specific location settings");
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
      );
    } else if (Platform.isIOS) {
      LoggerHelper.info("Using iOS-specific location settings");
      return AppleSettings(
        accuracy: LocationAccuracy.best,
      );
    } else {
      LoggerHelper.info("Using default location settings");
      return const LocationSettings(
        accuracy: LocationAccuracy.best,
      );
    }
  }

  static Future<String?> getAddressFromCurrentLocation(
      BuildContext context) async {
    try {
      LoggerHelper.info("Starting location permissions check...");

      var status = await Permission.location.status;
      if (!status.isGranted) {
        LoggerHelper.warning(
            "Location permission not granted. Requesting permission...");

        bool shouldRequestPermission =
            await DelHelperFunctions.showPermissionDialog(context);

        if (shouldRequestPermission) {
          status = await Permission.location.request();
          if (!status.isGranted) {
            LoggerHelper.error("Location permission denied.");

            if (status.isPermanentlyDenied) {
              bool shouldOpenSettings = await showGeneralDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ScaleTransition(
                        scale: animation,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Row(
                            children: [
                              Icon(Icons.location_disabled,
                                  color: primaryRed, size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Location Permission Required',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'You have permanently denied location permission. Please enable it from the app settings to proceed.',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: secondaryPurple,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.security_update_warning,
                                  size: 48,
                                  color: primaryRed,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: accentRedText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.settings,
                                            color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'Open Settings',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      openAppSettings();
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                          actionsPadding:
                              const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        ),
                      );
                    },
                  ) ??
                  false;

              if (shouldOpenSettings) {
                return null;
              }
            }
            return null;
          }
        } else {
          return null;
        }
      }

      LoggerHelper.info("Checking if location services are enabled...");

      if (!await Geolocator.isLocationServiceEnabled()) {
        LoggerHelper.error("Location services are disabled.");
        bool shouldOpenSettings =
            await DelHelperFunctions.showLocationServiceDialog(context);
        if (!shouldOpenSettings ||
            !await Geolocator.isLocationServiceEnabled()) {
          return null;
        }
      }

      LoggerHelper.info("Determining current location...");

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: primaryBlue,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Determining your location...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: secondaryPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      );

      try {
        // Get platform-specific location settings
        final locationSettings = getPlatformSpecificSettings();

        // Get current position with platform-specific settings
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        // Close loading dialog
        Navigator.of(context).pop();

        LoggerHelper.debug(
            "Location determined: Latitude ${position.latitude}, Longitude ${position.longitude}");

        LoggerHelper.info("Converting coordinates to address...");

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          // Create a more detailed address string
          List<String?> addressComponents = [
            place.locality,
            place.administrativeArea,
          ]
              .where((component) => component != null && component.isNotEmpty)
              .toList();

          String address = addressComponents
              .join(', ')
              .replaceAll(RegExp(r',\s*,'), ',')
              .replaceAll(RegExp(r'^\s*,\s*|\s*,\s*$'), '');

          // Show success snackbar
          DelHelperFunctions.showSnackBar(
            type: SnackBarType.success,
            context: context,
            message: 'Your location has been successfully determined',
          );
          LoggerHelper.info("Address found: $address");
          return address;
        }

        return null;
      } catch (e) {
        // Close loading dialog if it's still showing
        if (context.mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // Show error snackbar
        if (context.mounted) {
          DelHelperFunctions.showSnackBar(
            type: SnackBarType.error,
            context: context,
            message:
                'An error occurred while determining the location. Please try again.',
          );
        }

        LoggerHelper.error("An unexpected error occurred", e);
        return null;
      }
    } on PlatformException catch (e) {
      LoggerHelper.error("System error occurred", e.message);
      DelHelperFunctions.showSnackBar(
        type: SnackBarType.error,
        context: context,
        message: e.message ??
            'An error occurred while determining the location. Please try again.',
      );
      return null;
    }
  }
}
