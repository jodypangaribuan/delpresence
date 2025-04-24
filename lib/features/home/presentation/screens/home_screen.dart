import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/global_bottom_nav.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Halaman yang akan ditampilkan berdasarkan index bottom navbar
  final List<Widget> _pages = [
    const _HomePage(),
    const _DummyPage(title: 'Jadwal', color: Colors.green),
    const _DummyPage(title: 'Scan Absensi', color: Colors.purple),
    const _DummyPage(title: 'Riwayat', color: Colors.orange),
    const _DummyPage(title: 'Profil', color: Colors.teal),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Navigate to login screen when logout is successful
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        // Hapus AppBar untuk menggunakan HomeHeader sepenuhnya
        body: _pages[_currentIndex],
        bottomNavigationBar: GlobalBottomNav(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  void _handleLogout() {
    // Dispatch logout event to AuthBloc
    context.read<AuthBloc>().add(LogoutEvent());
    // Navigation will be handled by BlocListener
  }
}

// Halaman beranda baru dengan header dan konten kosong
class _HomePage extends StatelessWidget {
  const _HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent with light icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Calculate screen width to determine icon size
    final screenWidth = MediaQuery.of(context).size.width;
    // Size for icons to fit approximately 4 across with spacing, but slightly smaller
    final iconSize =
        ((screenWidth - 80) / 4) * 0.85; // 85% of the size needed for exactly 4

    return Scaffold(
      // Remove AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          // Header dengan informasi pengguna dan statistik
          const HomeHeader(),

          // Menu container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu items - first row (5 items)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Absensi menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Absensi',
                        iconPath: 'assets/images/menu-absensi.png',
                        iconSize:
                            iconSize * 0.9, // Slightly smaller for 5 items
                        onTap: () {
                          _showAbsensiBottomSheet(context);
                        },
                      ),

                      // Mata Kuliah menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Mata Kuliah',
                        iconPath: 'assets/images/menu-matakuliah.png',
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Menu Mata Kuliah tapped')),
                          );
                        },
                      ),

                      // Riwayat menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Riwayat',
                        iconPath: 'assets/images/menu-riwayat.png',
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Menu Riwayat tapped')),
                          );
                        },
                      ),

                      // Izin menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Izin',
                        iconPath: 'assets/images/menu-izin.png',
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menu Izin tapped')),
                          );
                        },
                      ),

                      // Jadwal menu item (placeholder)
                      _buildSimpleMenuItem(
                        context,
                        title: 'Jadwal',
                        iconPath:
                            'assets/images/menu-riwayat.png', // Using existing icon as placeholder
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menu Jadwal tapped')),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20), // Spacing between rows

                  // Menu items - second row (5 items)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profil menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Profil',
                        iconPath:
                            'assets/images/menu-absensi.png', // Using existing icon as placeholder
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menu Profil tapped')),
                          );
                        },
                      ),

                      // Nilai menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Nilai',
                        iconPath:
                            'assets/images/menu-matakuliah.png', // Using existing icon as placeholder
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menu Nilai tapped')),
                          );
                        },
                      ),

                      // Pengaturan menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Pengaturan',
                        iconPath:
                            'assets/images/menu-izin.png', // Using existing icon as placeholder
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Menu Pengaturan tapped')),
                          );
                        },
                      ),

                      // Notifikasi menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Notifikasi',
                        iconPath:
                            'assets/images/menu-riwayat.png', // Using existing icon as placeholder
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Menu Notifikasi tapped')),
                          );
                        },
                      ),

                      // Bantuan menu item
                      _buildSimpleMenuItem(
                        context,
                        title: 'Bantuan',
                        iconPath:
                            'assets/images/menu-absensi.png', // Using existing icon as placeholder
                        iconSize: iconSize * 0.9,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Menu Bantuan tapped')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build simple menu items with just the icon and text
  Widget _buildSimpleMenuItem(
    BuildContext context, {
    required String title,
    required String iconPath,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return _PressableMenuItem(
      title: title,
      iconPath: iconPath,
      iconSize: iconSize,
      onTap: onTap,
    );
  }

  // Method to show the Absensi bottom sheet
  void _showAbsensiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Title
            const Text(
              'Pilih Metode Absensi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 24),

            // Content - two options
            Column(
              children: [
                // QR Code Option
                _buildMinimalistAbsensiOption(
                  context,
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Scan QR',
                  description: 'Pindai kode QR untuk melakukan absensi',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scan QR dipilih'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Face Recognition Option
                _buildMinimalistAbsensiOption(
                  context,
                  icon: Icons.face_rounded,
                  title: 'Face Recognition',
                  description: 'Gunakan pengenalan wajah untuk absensi',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Face Recognition dipilih'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build minimalist absensi option items
  Widget _buildMinimalistAbsensiOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful wrapper for menu item with press effect
class _PressableMenuItem extends StatefulWidget {
  final String title;
  final String iconPath;
  final double iconSize;
  final VoidCallback onTap;

  const _PressableMenuItem({
    required this.title,
    required this.iconPath,
    required this.iconSize,
    required this.onTap,
  });

  @override
  State<_PressableMenuItem> createState() => _PressableMenuItemState();
}

class _PressableMenuItemState extends State<_PressableMenuItem>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(_) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Column(
        children: [
          // Animated builder for more complex animations
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.iconSize,
                  height: widget.iconSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      // Bottom shadow - reduces when pressed
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.25 * _shadowAnimation.value),
                        offset: Offset(0, 8 * _shadowAnimation.value),
                        blurRadius: 12 * _shadowAnimation.value,
                        spreadRadius: -4,
                      ),
                      // Side shadow - reduces when pressed
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1 * _shadowAnimation.value),
                        offset: Offset(5 * _shadowAnimation.value, 0),
                        blurRadius: 8 * _shadowAnimation.value,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 2),

          // Menu title text
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget halaman dummy untuk demo
class _DummyPage extends StatelessWidget {
  final String title;
  final Color color;

  const _DummyPage({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          // Logout button in AppBar
          IconButton(
            icon: const Icon(Iconsax.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForTitle(title),
              size: 80,
              color: color.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ini adalah halaman $title',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Beranda':
        return Iconsax.home;
      case 'Jadwal':
        return Iconsax.calendar;
      case 'Scan Absensi':
        return Iconsax.scan;
      case 'Riwayat':
        return Iconsax.clock;
      case 'Profil':
        return Iconsax.profile_circle;
      default:
        return Iconsax.info_circle;
    }
  }
}
