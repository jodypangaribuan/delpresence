import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';

class GlobalBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlobalBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<GlobalBottomNav> createState() => _GlobalBottomNavState();
}

class _GlobalBottomNavState extends State<GlobalBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GlobalBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final navItemWidth = (size.width - 32 - (size.width * 0.16)) / 4;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Navigation Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                    0, 'assets/icons/home-navbar.svg', 'Beranda', navItemWidth),
                _buildNavItem(1, 'assets/icons/schedule-navbar.svg', 'Jadwal',
                    navItemWidth),
                // Empty space for center button
                SizedBox(width: MediaQuery.of(context).size.width * 0.16),
                _buildNavItem(3, 'assets/icons/history-navbar.svg', 'Riwayat',
                    navItemWidth),
                _buildNavItem(4, 'assets/icons/profile-navbar.svg', 'Profil',
                    navItemWidth),
              ],
            ),
          ),

          // Center floating button - positioned to overlay the navbar
          Positioned(
            top: -30,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onTap(2);
                },
                child: Container(
                  width: 70,
                  height: widget.currentIndex == 2 ? 74 : 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0577B5), Color(0xFF0568A0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.2, 0.9],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0577B5).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: const Color(0xFF0577B5).withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: widget.currentIndex == 2
                              ? _controller.value * 0.1
                              : 0,
                          child: child,
                        );
                      },
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 1.05),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: widget.currentIndex == 2 ? value : 1.0,
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Image.asset(
                            'assets/images/qr_code.png',
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String svgPath, String label, double width) {
    final isSelected = widget.currentIndex == index;
    final Color color =
        isSelected ? const Color(0xFF0577B5) : Colors.grey[600]!;

    return GestureDetector(
      onTap: () {
        if (widget.currentIndex != index) {
          HapticFeedback.selectionClick();
          widget.onTap(index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Item menu
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? 1.0 + (_controller.value * 0.15) : 1.0,
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    curve: Curves.easeIn,
                    height: 30,
                    child: SvgPicture.asset(
                      svgPath,
                      width: isSelected ? 26 : 24,
                      height: isSelected ? 26 : 24,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 50),
                    curve: Curves.easeIn,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      shadows: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0577B5).withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Garis indikator sebagai bagian dari item menu
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    width: isSelected ? 32 : 0,
                    height: 2,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF0577B5), Color(0xFF0568A0)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF0577B5),
                      borderRadius: BorderRadius.circular(1.5),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0577B5).withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
