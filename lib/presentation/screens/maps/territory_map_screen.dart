// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/optimized_auth_provider.dart';

class TerritoryMapScreen extends StatefulWidget {
  const TerritoryMapScreen({super.key});

  @override
  State<TerritoryMapScreen> createState() => _TerritoryMapScreenState();
}

class _TerritoryMapScreenState extends State<TerritoryMapScreen> {
  String _selectedTerritory = 'North District';
  bool _showHeatMap = false;
  String _mapView = 'satellite'; // satellite, terrain, standard

  final List<Map<String, dynamic>> _territories = [
    {
      'name': 'North District',
      'area': '125 km²',
      'clients': 48,
      'prospects': 23,
      'coverage': 0.78,
      'color': Colors.blue,
    },
    {
      'name': 'South District',
      'area': '98 km²',
      'clients': 36,
      'prospects': 31,
      'coverage': 0.65,
      'color': Colors.green,
    },
    {
      'name': 'East District',
      'area': '156 km²',
      'clients': 52,
      'prospects': 19,
      'coverage': 0.82,
      'color': Colors.orange,
    },
    {
      'name': 'West District',
      'area': '112 km²',
      'clients': 41,
      'prospects': 28,
      'coverage': 0.71,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _clients = [
    {
      'name': 'TechCorp Solutions',
      'type': 'High Value',
      'status': 'Active',
      'lat': 40.7128,
      'lng': -74.0060,
      'lastVisit': '2 days ago',
    },
    {
      'name': 'Global Industries',
      'type': 'Enterprise',
      'status': 'Active',
      'lat': 40.7589,
      'lng': -73.9851,
      'lastVisit': '1 week ago',
    },
    {
      'name': 'StartUp Inc',
      'type': 'Growing',
      'status': 'Prospect',
      'lat': 40.7505,
      'lng': -73.9934,
      'lastVisit': 'Never',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Territory Map'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: () => _showMapLayers(context),
          ),
        ],
      ),
      body: Consumer<OptimizedAuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildTerritorySelector(theme),
              Expanded(
                child: _buildMapView(theme),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomControls(theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTerritory(),
        child: const Icon(Icons.add_location),
      ),
    );
  }

  Widget _buildTerritorySelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: theme.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Select Territory',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _territories.map((territory) {
                final isSelected = territory['name'] == _selectedTerritory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(territory['name']),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTerritory = territory['name'];
                      });
                    },
                    avatar: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: territory['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(ThemeData theme) {
    final selectedTerritoryData = _territories.firstWhere(
      (t) => t['name'] == _selectedTerritory,
    );

    return Stack(
      children: [
        // Map placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Interactive Territory Map',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Full map integration coming soon',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        // Territory info overlay
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: selectedTerritoryData['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedTerritory,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatChip(
                          'Area', selectedTerritoryData['area'], Icons.map),
                      _buildStatChip(
                          'Clients',
                          '${selectedTerritoryData['clients']}',
                          Icons.business),
                      _buildStatChip(
                          'Prospects',
                          '${selectedTerritoryData['prospects']}',
                          Icons.person_add),
                      _buildStatChip(
                          'Coverage',
                          '${(selectedTerritoryData['coverage'] * 100).toInt()}%',
                          Icons.trending_up),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Client markers overlay
        Positioned(
          bottom: 100,
          left: 16,
          right: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Clients in Territory',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: _showHeatMap,
                        onChanged: (value) {
                          setState(() {
                            _showHeatMap = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _clients.length,
                      itemBuilder: (context, index) {
                        final client = _clients[index];
                        return _buildClientMarkerInfo(client, theme);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildClientMarkerInfo(Map<String, dynamic> client, ThemeData theme) {
    Color statusColor;
    IconData statusIcon;

    switch (client['status']) {
      case 'Active':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Prospect':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client['name'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${client['type']} • ${client['lastVisit']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            'Route Plan',
            Icons.route,
            () => _planRoute(),
            theme,
          ),
          _buildControlButton(
            'Optimize',
            Icons.auto_fix_high,
            () => _optimizeTerritory(),
            theme,
          ),
          _buildControlButton(
            'Analytics',
            Icons.analytics,
            () => _viewAnalytics(),
            theme,
          ),
          _buildControlButton(
            'Export',
            Icons.download,
            () => _exportData(),
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      String label, IconData icon, VoidCallback onPressed, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            foregroundColor: theme.primaryColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          CheckboxListTile(
            title: const Text('High Value Clients'),
            value: true,
            onChanged: (value) {},
          ),
          CheckboxListTile(
            title: const Text('Prospects'),
            value: true,
            onChanged: (value) {},
          ),
          CheckboxListTile(
            title: const Text('Recent Visits'),
            value: false,
            onChanged: (value) {},
          ),
          CheckboxListTile(
            title: const Text('Opportunities'),
            value: false,
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showMapLayers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Map Layers',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          RadioListTile<String>(
            title: const Text('Standard'),
            value: 'standard',
            groupValue: _mapView,
            onChanged: (value) {
              setState(() {
                _mapView = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Satellite'),
            value: 'satellite',
            groupValue: _mapView,
            onChanged: (value) {
              setState(() {
                _mapView = value!;
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Terrain'),
            value: 'terrain',
            groupValue: _mapView,
            onChanged: (value) {
              setState(() {
                _mapView = value!;
              });
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _addNewTerritory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new territory feature coming soon')),
    );
  }

  void _planRoute() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Planning optimal route...')),
    );
  }

  void _optimizeTerritory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analyzing territory optimization...')),
    );
  }

  void _viewAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening territory analytics...')),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting territory data...')),
    );
  }
}
