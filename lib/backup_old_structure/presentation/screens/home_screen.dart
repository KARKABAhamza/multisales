import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// ignore_for_file: deprecated_member_use

// Animated Quick Action Button with micro-interaction

// Theme mode provider for toggling dark/light mode
class ThemeModeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
class AnimatedQuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const AnimatedQuickAction(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  State<AnimatedQuickAction> createState() => _AnimatedQuickActionState();
}

class _AnimatedQuickActionState extends State<AnimatedQuickAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: 28, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Responsive breakpoints
  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
  bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final bool tablet = isTablet(context);
  final bool desktop = isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('MultiSales'),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/expertise');
            },
            child: Text("Nos Métiers", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                onPressed: () {
                  // Use Provider to toggle theme
                  try {
                    final provider = Provider.of<ThemeModeProvider>(context, listen: false);
                    provider.toggleTheme();
                  } catch (_) {
                    // If Provider not found, do nothing
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: desktop ? 64 : tablet ? 48 : 32,
                horizontal: desktop ? 80 : tablet ? 32 : 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.blueGrey.shade900, Colors.black]
                      : [Colors.blue.shade100, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to MultiSales',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your all-in-one platform for sales, documents, appointments, and more.',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      AnimatedQuickAction(
                        icon: Icons.dashboard,
                        label: 'Dashboard',
                        onPressed: () {},
                      ),
                      AnimatedQuickAction(
                        icon: Icons.description,
                        label: 'Documents',
                        onPressed: () {},
                      ),
                      AnimatedQuickAction(
                        icon: Icons.calendar_today,
                        label: 'Appointments',
                        onPressed: () {},
                      ),
                      AnimatedQuickAction(
                        icon: Icons.person,
                        label: 'Profile',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Features Section
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: desktop ? 48 : tablet ? 32 : 24,
                horizontal: desktop ? 80 : tablet ? 32 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Choose MultiSales?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: [
                      _FeatureCard(
                        icon: Icons.security,
                        title: 'Secure & Reliable',
                        description: 'Your data is protected with enterprise-grade security.',
                      ),
                      _FeatureCard(
                        icon: Icons.language,
                        title: 'Multi-language',
                        description: 'Available in English, French, Arabic, Spanish, and German.',
                      ),
                      _FeatureCard(
                        icon: Icons.analytics,
                        title: 'Analytics',
                        description: 'Track your sales and performance in real time.',
                      ),
                      _FeatureCard(
                        icon: Icons.accessibility,
                        title: 'Accessibility',
                        description: 'Designed for everyone, everywhere.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Expertise Section
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: desktop ? 48 : tablet ? 32 : 24,
                horizontal: desktop ? 80 : tablet ? 32 : 16,
              ),
              child: ExpertiseSection(),
            ),
            // Newsletter Section
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: desktop ? 32 : tablet ? 24 : 16,
                horizontal: desktop ? 80 : tablet ? 32 : 16,
              ),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stay Updated!',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Subscribe to our newsletter for the latest updates.'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Subscribe'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expertise Section
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: desktop ? 48 : tablet ? 32 : 24,
                horizontal: desktop ? 80 : tablet ? 32 : 16,
              ),
              child: ExpertiseSection(),
            ),
            // Footer
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: desktop ? 80 : tablet ? 32 : 16,
              ),
              child: Center(
                child: Text(
                  '© 2025 MultiSales. All rights reserved.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Feature Card Widget
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Expertise Section Widget
class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "INTEGRATEUR DE SOLUTIONS\nRESEAUX & TELECOMS,\nAUTOMATISME ET SERVICE INDUSTRIEL",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ExpertiseCard(
              title: "VOIX",
              points: [
                "Téléphonie TDM & IP",
                "Communication Unifiée et Mobilité",
              ],
            ),
            ExpertiseCard(
              title: "AUTOMATISME",
              points: [
                "Automate programmable SIEMENS",
                "SIMATIC S7",
                "LOGO",
                "TIA PORTAL",
              ],
            ),
            ExpertiseCard(
              title: "DATA",
              points: [
                "Réseaux filaire et solutions WIFI",
                "Switchs et Routeurs",
              ],
            ),
            ExpertiseCard(
              title: "COURANT FORT",
              points: [
                "Postes de transformation",
                "Armoires de distribution",
                "Armoires de TGBT",
              ],
            ),
            ExpertiseCard(
              title: "VIDEO",
              points: [
                "Visioconférence",
                "Affichage dynamique et Mur d’images",
                "Vidéosurveillance et contrôle d’accès",
                "Collaboration",
              ],
            ),
            ExpertiseCard(
              title: "DOMOTIQUE",
              points: [
                "Capteurs (lumière, température, mouvement)",
                "Contrôleurs",
                "Actionneurs (interrupteurs d'éclairage, moteurs, vannes motorisées)",
              ],
            ),
          ],
        ),
        SizedBox(height: 32),
        ContactCard(
          address: "49 boulevard CHEFCHAOUNI II Ain Sébaâ Casablanca Maroc",
          phones: ["+212 661 29 74 42", "+212 661 08 98 59"],
          email: "commercial@skyconnect.ma",
          hours: "08:30 – 18:00",
        ),
      ],
    );
  }
}

class ExpertiseCard extends StatelessWidget {
  final String title;
  final List<String> points;
  const ExpertiseCard({required this.title, required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...points.map((p) => Row(
                  children: [
                    Icon(Icons.check, size: 16, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Expanded(child: Text(p)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String address;
  final List<String> phones;
  final String email;
  final String hours;
  const ContactCard({required this.address, required this.phones, required this.email, required this.hours, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(address),
            SizedBox(height: 8),
            ...phones.map((phone) => Text(phone)),
            SizedBox(height: 8),
            Text(email),
            SizedBox(height: 8),
            Text("Horaires: $hours"),
          ],
        ),
      ),
    );
  }
}

