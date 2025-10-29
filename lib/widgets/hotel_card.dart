import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

import '../constants/app_strings.dart';
import '../models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Builder(
              builder: (context) {
                return hotel.propertyImage.isNotEmpty
                    ? Image.network(
                        hotel.propertyImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          width: double.infinity,
                          child: const Icon(Icons.hotel, color: Colors.black54),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        width: double.infinity,
                        child: const Icon(Icons.hotel, color: Colors.black54),
                      );
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            title: Text(
              hotel.propertyName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, color: Color(0xffff6f62), size: 16),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        [
                          hotel.propertyAddress.city,
                          hotel.propertyAddress.state,
                          hotel.propertyAddress.country,
                        ].where((e) => e.trim().isNotEmpty).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                StarRating(
                  rating: hotel.propertyStar.toDouble(),
                  allowHalfRating: true,
                  mainAxisAlignment: MainAxisAlignment.start,
                  size: 18,
                ),
                SizedBox(height: 4),
                Text(
                  '${hotel.markedPrice.displayAmount}${AppStrings.perNightSuffix}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffff6f62),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(AppStrings.bookNow, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
