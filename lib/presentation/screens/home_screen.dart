import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dashboard/user_profile_widget.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/training_provider.dart';
import '../widgets/layout/main_scaffold.dart';
import '../widgets/display/custom_widgets.dart' as custom;
// ignore_for_file: deprecated_member_use

// Animated Quick Action Button with micro-interaction
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
  final _formKey = GlobalKey<FormState>();
  bool _showQuickActions = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return MainScaffold(
      title: loc.appTitle,
      body: Consumer2<AuthProvider, TrainingProvider>(
        builder: (context, authProvider, trainingProvider, child) {
          final user = authProvider.firebaseUser;
          return RefreshIndicator(
            onRefresh: () async {},
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileWidget(
                      name: user?.displayName,
                      email: user?.email,
                      avatarUrl: user?.photoURL,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.trainingProgress,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/training'),
                          child: Text(loc.viewAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: trainingProvider.isLoading,
                      child: custom.LoadingWidget(
                        message: loc.loadingTrainingData,
                      ),
                    ),
                    Visibility(
                      visible: trainingProvider.errorMessage != null,
                      child: custom.ErrorWidget(
                        message: trainingProvider.errorMessage ?? '',
                        onRetry: () {},
                      ),
                    ),
                    if (!trainingProvider.isLoading &&
                        trainingProvider.errorMessage == null)
                      Column(
                        children: [
                          custom.ProgressCard(
                            title: loc.salesFundamentals,
                            progress: 0.75,
                            subtitle: loc.completeSalesTraining,
                          ),
                          custom.ProgressCard(
                            title: loc.productKnowledge,
                            progress: 0.45,
                            subtitle: loc.learnAboutProducts,
                          ),
                          custom.ProgressCard(
                            title: loc.customerService,
                            progress: 0.90,
                            subtitle: loc.masterCustomerInteractions,
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.quickActions,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(_showQuickActions
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () => setState(
                              () => _showQuickActions = !_showQuickActions),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _showQuickActions,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedQuickAction(
                              icon: Icons.add_task,
                              label: loc.addTask,
                              onPressed: () => context.push('/task'),
                            ),
                            AnimatedQuickAction(
                              icon: Icons.message,
                              label: loc.sendMessage,
                              onPressed: () => context.push('/messages'),
                            ),
                            AnimatedQuickAction(
                              icon: Icons.schedule,
                              label: loc.scheduleMeeting,
                              onPressed: () => context.push('/meeting'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
