import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width to make responsive calculations
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize =
        screenWidth * 0.16; // Reduced from 18% to 15% of screen width
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width

    return Container(
      height: 170,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // Background container with decoration and direct color
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/background/background-header.png'),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
            ),
          ),

          // User avatar on the left - positioned proportionally
          Positioned(
            top: 200 * 0.33, // Decreased from 0.45 to 0.4 to move it higher
            left: horizontalPadding,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://xsgames.co/randomusers/assets/avatars/male/74.jpg',
                  fit: BoxFit.cover,
                  width: avatarSize,
                  height: avatarSize,
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        'JP',
                        style: TextStyle(
                          fontSize: avatarSize * 0.375, // 37.5% of avatar size
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Welcome text and user information - positioned to align with avatar
          Positioned(
            top: 200 * 0.28, // Reduced from 0.32 to 0.28 to move it higher
            left: horizontalPadding +
                avatarSize +
                (screenWidth * 0.03), // Add 3% of screen width spacing
            right: horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Name with overflow handling
                Text(
                  'Jody Edriano Pangaribuan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Teknologi Informasi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Text(
                  '11323025',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Notification bell icon - proportionally positioned
          Positioned(
            top: 200 * 0.23, // ~23% from the top
            right: horizontalPadding,
            child: GestureDetector(
              onTap: () {
                // Handle notification tap
              },
              child: SvgPicture.asset(
                'assets/icons/bell.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
