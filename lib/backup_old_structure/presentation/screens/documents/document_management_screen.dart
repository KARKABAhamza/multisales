// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/optimized_auth_provider.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFolder = 'All Documents';
  String _searchQuery = '';
  String _selectedSortBy = 'Recent';
  bool _isGridView = false;

  final List<String> _folders = [
    'All Documents',
    'Contracts',
    'Proposals',
    'Presentations',
    'Templates',
    'Marketing Materials',
    'Customer Files',
    'Internal'
  ];

  final List<String> _sortOptions = [
    'Recent',
    'Name A-Z',
    'Name Z-A',
    'Size',
    'Type',
    'Modified'
  ];

  final List<Map<String, dynamic>> _documents = [
    {
      'id': 'DOC001',
      'name': 'Q1 Sales Proposal - TechCorp',
      'type': 'PDF',
      'size': '2.4 MB',
      'folder': 'Proposals',
      'createdBy': 'Sarah Johnson',
      'createdAt': '2024-03-15T10:30:00Z',
      'modifiedAt': '2024-03-16T14:20:00Z',
      'shared': true,
      'sharedWith': ['Mike Chen', 'Lisa Rodriguez'],
      'version': '1.2',
      'status': 'Published',
      'tags': ['sales', 'proposal', 'Q1'],
      'description':
          'Comprehensive sales proposal for TechCorp\'s Q1 requirements',
      'thumbnail': '📄',
      'permissions': ['read', 'write', 'share'],
    },
    {
      'id': 'DOC002',
      'name': 'Product Demo Presentation',
      'type': 'PPTX',
      'size': '15.8 MB',
      'folder': 'Presentations',
      'createdBy': 'David Kim',
      'createdAt': '2024-03-14T09:15:00Z',
      'modifiedAt': '2024-03-15T16:45:00Z',
      'shared': false,
      'sharedWith': [],
      'version': '2.1',
      'status': 'Draft',
      'tags': ['demo', 'presentation', 'product'],
      'description': 'Interactive product demonstration for client meetings',
      'thumbnail': '📊',
      'permissions': ['read', 'write'],
    },
    {
      'id': 'DOC003',
      'name': 'Master Service Agreement Template',
      'type': 'DOCX',
      'size': '890 KB',
      'folder': 'Templates',
      'createdBy': 'Legal Team',
      'createdAt': '2024-02-28T11:45:00Z',
      'modifiedAt': '2024-03-10T09:30:00Z',
      'shared': true,
      'sharedWith': ['All Sales Team'],
      'version': '3.0',
      'status': 'Approved',
      'tags': ['template', 'legal', 'contract'],
      'description': 'Standard MSA template for enterprise clients',
      'thumbnail': '📝',
      'permissions': ['read'],
    },
    {
      'id': 'DOC004',
      'name': 'Brand Guidelines 2024',
      'type': 'PDF',
      'size': '8.2 MB',
      'folder': 'Marketing Materials',
      'createdBy': 'Marketing Team',
      'createdAt': '2024-01-15T14:22:00Z',
      'modifiedAt': '2024-01-15T14:22:00Z',
      'shared': true,
      'sharedWith': ['All Teams'],
      'version': '1.0',
      'status': 'Published',
      'tags': ['brand', 'guidelines', 'marketing'],
      'description': 'Complete brand guidelines for 2024',
      'thumbnail': '🎨',
      'permissions': ['read'],
    },
    {
      'id': 'DOC005',
      'name': 'Client Onboarding Checklist',
      'type': 'XLSX',
      'size': '456 KB',
      'folder': 'Templates',
      'createdBy': 'Amy Wilson',
      'createdAt': '2024-03-01T16:20:00Z',
      'modifiedAt': '2024-03-12T10:15:00Z',
      'shared': true,
      'sharedWith': ['Sarah Johnson', 'Mike Chen'],
      'version': '1.1',
      'status': 'Published',
      'tags': ['onboarding', 'checklist', 'process'],
      'description': 'Step-by-step client onboarding process',
      'thumbnail': '📋',
      'permissions': ['read', 'write'],
    },
    {
      'id': 'DOC006',
      'name': 'Confidential - Enterprise Deal Strategy',
      'type': 'DOCX',
      'size': '1.2 MB',
      'folder': 'Internal',
      'createdBy': 'Alex Smith',
      'createdAt': '2024-03-13T12:00:00Z',
      'modifiedAt': '2024-03-14T15:30:00Z',
      'shared': false,
      'sharedWith': [],
      'version': '1.0',
      'status': 'Confidential',
      'tags': ['strategy', 'enterprise', 'confidential'],
      'description': 'Strategic approach for large enterprise deals',
      'thumbnail': '🔒',
      'permissions': ['read'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Management'),
        backgroundColor: theme.colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Documents', icon: Icon(Icons.folder)),
            Tab(text: 'Shared', icon: Icon(Icons.people)),
            Tab(text: 'Recent', icon: Icon(Icons.access_time)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: Consumer<OptimizedAuthProvider>(
        builder: (context, authProvider, child) {
          // Public-only provider: no loading logic
          return Column(
            children: [
              _buildFilterBar(theme),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDocumentsList(_getFilteredDocuments(), theme),
                    _buildDocumentsList(_getSharedDocuments(), theme),
                    _buildDocumentsList(_getRecentDocuments(), theme),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _uploadDocument(),
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload'),
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
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
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFolder,
              decoration: const InputDecoration(
                labelText: 'Folder',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: _folders.map((folder) {
                return DropdownMenuItem(value: folder, child: Text(folder));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFolder = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () => _createNewFolder(),
            tooltip: 'Create Folder',
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredDocuments() {
    var filtered = _documents.where((doc) {
      final matchesFolder = _selectedFolder == 'All Documents' ||
          doc['folder'] == _selectedFolder;
      final matchesSearch = _searchQuery.isEmpty ||
          doc['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (doc['tags'] as List<String>).any(
              (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesFolder && matchesSearch;
    }).toList();

    _applySorting(filtered);
    return filtered;
  }

  List<Map<String, dynamic>> _getSharedDocuments() {
    return _documents.where((doc) => doc['shared'] == true).toList();
  }

  List<Map<String, dynamic>> _getRecentDocuments() {
    var recent = List<Map<String, dynamic>>.from(_documents);
    recent.sort((a, b) => DateTime.parse(b['modifiedAt'])
        .compareTo(DateTime.parse(a['modifiedAt'])));
    return recent.take(10).toList();
  }

  void _applySorting(List<Map<String, dynamic>> documents) {
    switch (_selectedSortBy) {
      case 'Recent':
        documents.sort((a, b) => DateTime.parse(b['modifiedAt'])
            .compareTo(DateTime.parse(a['modifiedAt'])));
        break;
      case 'Name A-Z':
        documents.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Name Z-A':
        documents.sort((a, b) => b['name'].compareTo(a['name']));
        break;
      case 'Size':
        documents.sort(
            (a, b) => _parseSize(b['size']).compareTo(_parseSize(a['size'])));
        break;
      case 'Type':
        documents.sort((a, b) => a['type'].compareTo(b['type']));
        break;
      case 'Modified':
        documents.sort((a, b) => DateTime.parse(b['modifiedAt'])
            .compareTo(DateTime.parse(a['modifiedAt'])));
        break;
    }
  }

  double _parseSize(String sizeStr) {
    final parts = sizeStr.split(' ');
    final value = double.parse(parts[0]);
    final unit = parts[1];

    switch (unit) {
      case 'KB':
        return value;
      case 'MB':
        return value * 1024;
      case 'GB':
        return value * 1024 * 1024;
      default:
        return value;
    }
  }

  Widget _buildDocumentsList(
      List<Map<String, dynamic>> documents, ThemeData theme) {
    if (documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No documents found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or upload a new document',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return _buildDocumentGridItem(documents[index], theme);
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return _buildDocumentListItem(documents[index], theme);
        },
      );
    }
  }

  Widget _buildDocumentListItem(
      Map<String, dynamic> document, ThemeData theme) {
    final status = document['status'] as String;
    final permissions = document['permissions'] as List<String>;
    final modifiedAt = DateTime.parse(document['modifiedAt']);
    final timeAgo = _getTimeAgo(modifiedAt);

    Color statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getTypeColor(document['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              document['thumbnail'],
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                document['name'],
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (document['shared'])
              Icon(Icons.people, size: 16, color: Colors.blue.shade600),
            const SizedBox(width: 4),
            if (status == 'Confidential')
              Icon(Icons.lock, size: 16, color: Colors.red.shade600),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              document['description'],
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${document['type']} • ${document['size']} • ${document['createdBy']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'v${document['version']} • Modified $timeAgo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                ...permissions.take(2).map((perm) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        _getPermissionIcon(perm),
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                    )),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleDocumentAction(document, value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View')),
            const PopupMenuItem(value: 'download', child: Text('Download')),
            const PopupMenuItem(value: 'share', child: Text('Share')),
            const PopupMenuItem(value: 'rename', child: Text('Rename')),
            const PopupMenuItem(value: 'move', child: Text('Move')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        isThreeLine: true,
        onTap: () => _viewDocument(document),
      ),
    );
  }

  Widget _buildDocumentGridItem(
      Map<String, dynamic> document, ThemeData theme) {
    final status = document['status'] as String;
    Color statusColor = _getStatusColor(status);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _viewDocument(document),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTypeColor(document['type']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        document['thumbnail'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) =>
                        _handleDocumentAction(document, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'view', child: Text('View')),
                      const PopupMenuItem(
                          value: 'download', child: Text('Download')),
                      const PopupMenuItem(value: 'share', child: Text('Share')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                document['name'],
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                document['description'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (document['shared'])
                    Icon(Icons.people, size: 14, color: Colors.blue.shade600),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${document['type']} • ${document['size']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'docx':
      case 'doc':
        return Colors.blue;
      case 'xlsx':
      case 'xls':
        return Colors.green;
      case 'pptx':
      case 'ppt':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Published':
        return Colors.green;
      case 'Draft':
        return Colors.orange;
      case 'Approved':
        return Colors.blue;
      case 'Confidential':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPermissionIcon(String permission) {
    switch (permission) {
      case 'read':
        return Icons.visibility;
      case 'write':
        return Icons.edit;
      case 'share':
        return Icons.share;
      default:
        return Icons.help;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Documents'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter document name, description, or tags...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
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

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedSortBy,
              onChanged: (value) {
                setState(() {
                  _selectedSortBy = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _createNewFolder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Folder'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter folder name...',
            prefixIcon: Icon(Icons.folder),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder created successfully')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _uploadDocument() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Upload Document',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('Choose File'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('File upload feature coming soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Scan Document'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Document scanning feature coming soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create New'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Document creation feature coming soon')),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _viewDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${document['name']}...')),
    );
  }

  void _handleDocumentAction(Map<String, dynamic> document, String action) {
    switch (action) {
      case 'view':
        _viewDocument(document);
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading ${document['name']}...')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing ${document['name']}...')),
        );
        break;
      case 'rename':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Renaming ${document['name']}...')),
        );
        break;
      case 'move':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Moving ${document['name']}...')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(document);
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${document['name']} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
