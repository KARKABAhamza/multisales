// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/appointment_provider.dart';
import '../../../core/localization/app_localizations.dart';
/// Calendar view for appointments
class AppointmentCalendarScreen extends StatefulWidget {
  const AppointmentCalendarScreen({super.key});

  @override
  State<AppointmentCalendarScreen> createState() => _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppointments();
    });
  }

  Future<void> _initializeAppointments() async {
    final appointmentProvider = context.read<AppointmentProvider>();
    // Public-only app: initialize appointments with default/public logic
  await appointmentProvider.initialize('public');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.appointments ?? 'Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _showCalendarSettings();
                  break;
                case 'sync':
                  _syncCalendar();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(localizations?.calendarSettings ?? 'Calendar Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'sync',
                child: ListTile(
                  leading: const Icon(Icons.sync),
                  title: Text(localizations?.syncCalendar ?? 'Sync Calendar'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Month'),
            Tab(icon: Icon(Icons.list), text: 'List'),
            Tab(icon: Icon(Icons.upcoming), text: 'Upcoming'),
          ],
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeAppointments,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTodayView(provider),
              _buildMonthView(provider),
              _buildListView(provider),
              _buildUpcomingView(provider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewAppointment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayView(AppointmentProvider provider) {
    final todayAppointments = provider.todayAppointments;

    if (todayAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No appointments today',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your free day!',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: todayAppointments.length,
        itemBuilder: (context, index) {
          final appointment = todayAppointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildMonthView(AppointmentProvider provider) {
    return Column(
      children: [
        _buildMonthHeader(),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + index);
              });
            },
            itemBuilder: (context, index) {
              final month =
                  DateTime(_currentMonth.year, _currentMonth.month + index);
              return _buildCalendarGrid(month, provider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListView(AppointmentProvider provider) {
    final appointments = provider.appointments;

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No appointments scheduled',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createNewAppointment,
              icon: const Icon(Icons.add),
              label: const Text('Schedule Appointment'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildUpcomingView(AppointmentProvider provider) {
    final upcomingAppointments = provider.upcomingAppointments;

    if (upcomingAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No upcoming appointments',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createNewAppointment,
              icon: const Icon(Icons.add),
              label: const Text('Schedule Appointment'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: upcomingAppointments.length,
        itemBuilder: (context, index) {
          final appointment = upcomingAppointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime month, AppointmentProvider provider) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekday + 2;

        if (dayNumber <= 0 || dayNumber > daysInMonth) {
          return Container(); // Empty cell
        }

        final date = DateTime(month.year, month.month, dayNumber);
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final dayAppointments = provider.appointmentsByDate[dateKey] ?? [];
        final isToday = _isToday(date);
        final isSelected = _isSameDate(date, provider.selectedDate);

        return GestureDetector(
          onTap: () {
            provider.setSelectedDate(date);
            _showDayAppointments(date, dayAppointments);
          },
          child: Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isToday
                      ? Theme.of(context).primaryColor.withOpacity(0.3)
                      : null,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNumber.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? Theme.of(context).primaryColor
                            : null,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (dayAppointments.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final statusColor = _getStatusColor(appointment.status);
    final priorityColor = _getPriorityColor(appointment.priority);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                appointment.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                appointment.priority
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: priorityColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (appointment.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  appointment.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    appointment.isVirtual ? Icons.videocam : Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      appointment.isVirtual
                          ? 'Virtual Meeting'
                          : appointment.locationName ?? 'No location',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _buildStatusChip(appointment.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo['color'].withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusInfo['text'],
        style: TextStyle(
          color: statusInfo['color'],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _createNewAppointment() {
    // Appointment creation screen navigation pending
    // Will navigate to appointment form when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create appointment feature coming soon')),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appointment.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Date: ${_formatDate(appointment.scheduledDate)}'),
              Text(
                  'Time: ${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}'),
              Text('Type: ${_getTypeDisplayName(appointment.type)}'),
              Text('Status: ${_getStatusDisplayName(appointment.status)}'),
              Text(
                  'Priority: ${_getPriorityDisplayName(appointment.priority)}'),
              if (appointment.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Description:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(appointment.description),
              ],
              if (appointment.locationName != null) ...[
                const SizedBox(height: 8),
                Text('Location: ${appointment.locationName}'),
              ],
              if (appointment.isVirtual && appointment.meetingLink != null) ...[
                const SizedBox(height: 8),
                Text('Meeting Link: ${appointment.meetingLink}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (appointment.status == AppointmentStatus.scheduled) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startAppointment(appointment);
              },
              child: const Text('Start'),
            ),
          ],
          if (appointment.status == AppointmentStatus.inProgress) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _completeAppointment(appointment);
              },
              child: const Text('Complete'),
            ),
          ],
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAppointmentActions(appointment);
            },
            child: const Text('Actions'),
          ),
        ],
      ),
    );
  }

  void _showDayAppointments(DateTime date, List<Appointment> appointments) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointments for ${_formatDate(date)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (appointments.isEmpty)
              const Text('No appointments scheduled for this day')
            else
              ...appointments.map((appointment) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(appointment.status),
                      child: Icon(
                        _getTypeIcon(appointment.type),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(appointment.title),
                    subtitle: Text(
                        '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAppointmentDetails(appointment);
                    },
                  )),
          ],
        ),
      ),
    );
  }

  void _showAppointmentActions(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Appointment'),
              onTap: () {
                Navigator.pop(context);
                // Edit appointment screen navigation pending
                // Will navigate to appointment edit form when implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Edit appointment feature coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Reschedule'),
              onTap: () {
                Navigator.pop(context);
                _rescheduleAppointment(appointment);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Cancel Appointment',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _cancelAppointment(appointment);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters() {
    // Filters dialog implementation pending
    // Will show comprehensive filtering options when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filters feature coming soon')),
    );
  }

  void _showSearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Appointments'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by title, description, or location...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (query) {
            Navigator.pop(context);
            context.read<AppointmentProvider>().setSearchQuery(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCalendarSettings() {
    // Calendar settings screen navigation pending
    // Will navigate to settings when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calendar settings feature coming soon')),
    );
  }

  void _syncCalendar() async {
    await _initializeAppointments();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calendar synced successfully')),
      );
    }
  }

  void _startAppointment(Appointment appointment) async {
    final provider = context.read<AppointmentProvider>();
    final success = await provider.startAppointment(appointment.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment started')),
      );
    }
  }

  void _completeAppointment(Appointment appointment) async {
    final provider = context.read<AppointmentProvider>();
    final success = await provider.completeAppointment(appointment.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment completed')),
      );
    }
  }

  void _rescheduleAppointment(Appointment appointment) {
    // Reschedule dialog implementation pending
    // Will show date/time picker when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reschedule feature coming soon')),
    );
  }

  void _cancelAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to cancel "${appointment.title}"?'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cancellation Reason',
                hintText: 'Enter reason for cancellation...',
              ),
              onSubmitted: (reason) async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                if (reason.trim().isNotEmpty) {
                  if (!mounted) return;
                  final provider = context.read<AppointmentProvider>();
                  final success =
                      await provider.cancelAppointment(appointment.id, reason);

                  if (success && mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Appointment cancelled')),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Appointment'),
          ),
          TextButton(
            onPressed: () {
              final provider = context.read<AppointmentProvider>();
              Navigator.pop(context);
              // Cancel with default reason
              if (mounted) {
                provider.cancelAppointment(
                  appointment.id,
                  'Cancelled by user',
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.inProgress:
        return Colors.orange;
      case AppointmentStatus.completed:
        return Colors.purple;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return Colors.grey;
      case AppointmentStatus.rescheduled:
        return Colors.amber;
    }
  }

  Color _getPriorityColor(AppointmentPriority priority) {
    switch (priority) {
      case AppointmentPriority.low:
        return Colors.green;
      case AppointmentPriority.medium:
        return Colors.orange;
      case AppointmentPriority.high:
        return Colors.red;
      case AppointmentPriority.urgent:
        return Colors.purple;
    }
  }

  Map<String, dynamic> _getStatusInfo(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return {'text': 'SCHEDULED', 'color': Colors.blue};
      case AppointmentStatus.confirmed:
        return {'text': 'CONFIRMED', 'color': Colors.green};
      case AppointmentStatus.inProgress:
        return {'text': 'IN PROGRESS', 'color': Colors.orange};
      case AppointmentStatus.completed:
        return {'text': 'COMPLETED', 'color': Colors.purple};
      case AppointmentStatus.cancelled:
        return {'text': 'CANCELLED', 'color': Colors.red};
      case AppointmentStatus.noShow:
        return {'text': 'NO SHOW', 'color': Colors.grey};
      case AppointmentStatus.rescheduled:
        return {'text': 'RESCHEDULED', 'color': Colors.amber};
    }
  }

  IconData _getTypeIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.consultation:
        return Icons.person;
      case AppointmentType.demonstration:
        return Icons.play_circle;
      case AppointmentType.meeting:
        return Icons.meeting_room;
      case AppointmentType.training:
        return Icons.school;
      case AppointmentType.support:
        return Icons.support;
      case AppointmentType.followUp:
        return Icons.follow_the_signs;
      case AppointmentType.onboarding:
        return Icons.start;
      case AppointmentType.review:
        return Icons.rate_review;
    }
  }

  String _getTypeDisplayName(AppointmentType type) {
    switch (type) {
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.demonstration:
        return 'Demonstration';
      case AppointmentType.meeting:
        return 'Meeting';
      case AppointmentType.training:
        return 'Training';
      case AppointmentType.support:
        return 'Support';
      case AppointmentType.followUp:
        return 'Follow-up';
      case AppointmentType.onboarding:
        return 'Onboarding';
      case AppointmentType.review:
        return 'Review';
    }
  }

  String _getStatusDisplayName(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  String _getPriorityDisplayName(AppointmentPriority priority) {
    switch (priority) {
      case AppointmentPriority.low:
        return 'Low';
      case AppointmentPriority.medium:
        return 'Medium';
      case AppointmentPriority.high:
        return 'High';
      case AppointmentPriority.urgent:
        return 'Urgent';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
