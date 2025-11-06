// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/optimized_auth_provider.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({super.key});

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  bool _isTrackingEnabled = false;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _recentLocations = [
    {
      'name': 'Client Office - ABC Corp',
      'address': '123 Business St, Downtown',
      'time': '10:30 AM',
      'type': 'client_visit',
    },
    {
      'name': 'Sales Meeting - XYZ Inc',
      'address': '456 Commerce Ave, Midtown',
      'time': '2:15 PM',
      'type': 'meeting',
    },
    {
      'name': 'Product Demo - Tech Solutions',
      'address': '789 Innovation Dr, Tech Park',
      'time': '4:45 PM',
      'type': 'demo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showLocationSettings(context),
          ),
        ],
      ),
      body: Consumer<OptimizedAuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrackingCard(theme),
                const SizedBox(height: 20),
                _buildCurrentLocationCard(theme),
                const SizedBox(height: 20),
                _buildRecentLocationsSection(theme),
                const SizedBox(height: 20),
                _buildLocationInsights(theme),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _toggleLocationTracking(),
        backgroundColor: _isTrackingEnabled ? Colors.red : theme.primaryColor,
        icon: Icon(_isTrackingEnabled ? Icons.stop : Icons.play_arrow),
        label: Text(_isTrackingEnabled ? 'Stop Tracking' : 'Start Tracking'),
      ),
    );
  }

  Widget _buildTrackingCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isTrackingEnabled ? Icons.location_on : Icons.location_off,
                  color: _isTrackingEnabled ? Colors.green : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Tracking',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isTrackingEnabled
                            ? 'Currently tracking your location'
                            : 'Location tracking is disabled',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _isTrackingEnabled ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isTrackingEnabled,
                  onChanged: (value) => _toggleLocationTracking(),
                ),
              ],
            ),
            if (_isTrackingEnabled) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location updates every 5 minutes during business hours',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.my_location, color: theme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Current Location',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Map View Coming Soon'),
                    Text('123 Main St, Business District',
                         style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareLocation(),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share Location'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToLocation(),
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Get Directions'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLocationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Locations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _viewAllLocations(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...(_recentLocations.map((location) => _buildLocationItem(location, theme))),
      ],
    );
  }

  Widget _buildLocationItem(Map<String, dynamic> location, ThemeData theme) {
    IconData icon;
    Color iconColor;

    switch (location['type']) {
      case 'client_visit':
        icon = Icons.business;
        iconColor = Colors.blue;
        break;
      case 'meeting':
        icon = Icons.people;
        iconColor = Colors.green;
        break;
      case 'demo':
        icon = Icons.computer;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.location_on;
        iconColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          location['name'],
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location['address']),
            Text(
              location['time'],
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showLocationOptions(location),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildLocationInsights(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: theme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Location Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInsightCard(
                    'Today\'s Visits',
                    '3',
                    Icons.today,
                    Colors.blue,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInsightCard(
                    'Distance Traveled',
                    '24.5 km',
                    Icons.directions_car,
                    Colors.green,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInsightCard(
                    'Time in Field',
                    '6h 20m',
                    Icons.schedule,
                    Colors.orange,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInsightCard(
                    'Efficiency Score',
                    '87%',
                    Icons.trending_up,
                    Colors.purple,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _toggleLocationTracking() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTrackingEnabled = !_isTrackingEnabled;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isTrackingEnabled
                  ? 'Location tracking enabled'
                  : 'Location tracking disabled',
            ),
            backgroundColor: _isTrackingEnabled ? Colors.green : Colors.orange,
          ),
        );
      }
    });
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location shared with team')),
    );
  }

  void _navigateToLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening navigation app...')),
    );
  }

  void _viewAllLocations() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Viewing all locations...')),
    );
  }

  void _showLocationOptions(Map<String, dynamic> location) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.directions),
            title: const Text('Get Directions'),
            onTap: () {
              Navigator.pop(context);
              _navigateToLocation();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Location'),
            onTap: () {
              Navigator.pop(context);
              _shareLocation();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('View Details'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showLocationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Update Frequency'),
              subtitle: Text('Every 5 minutes'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              leading: Icon(Icons.battery_saver),
              title: Text('Battery Optimization'),
              subtitle: Text('Enabled'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Location Visibility'),
              subtitle: Text('Team Only'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
