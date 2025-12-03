import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/layout/main_scaffold.dart';
import '../widgets/forms/custom_form_fields.dart';
import '../widgets/buttons/custom_buttons.dart';
import 'package:multisales_app/presentation/widgets/radio_choice_chip.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _meetingType = 'In-Person';
  DateTime _meetingDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _meetingTime = const TimeOfDay(hour: 10, minute: 0);
  int _duration = 60; // minutes
  final List<String> _attendees = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectMeetingDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _meetingDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _meetingDate) {
      setState(() {
        _meetingDate = picked;
      });
    }
  }

  Future<void> _selectMeetingTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _meetingTime,
    );
    if (picked != null && picked != _meetingTime) {
      setState(() {
        _meetingTime = picked;
      });
    }
  }

  Future<void> _scheduleMeeting() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate scheduling meeting
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meeting scheduled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Schedule Meeting',
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meeting Title
              CustomTextField(
                controller: _titleController,
                label: 'Meeting Title',
                hint: 'Enter meeting title',
                prefixIcon: const Icon(Icons.event),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meeting title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Meeting Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter meeting description/agenda',
                maxLines: 3,
                prefixIcon: const Icon(Icons.description),
              ),
              const SizedBox(height: 16),

              // Meeting Type
              Text(
                'Meeting Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioChoiceChip(
                      label: 'In-Person',
                      selected: _meetingType == 'In-Person',
                      onTap: () => _setMeetingType('In-Person'),
                    ),
                  ),
                  Expanded(
                    child: RadioChoiceChip(
                      label: 'Virtual',
                      selected: _meetingType == 'Virtual',
                      onTap: () => _setMeetingType('Virtual'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location/Link
              CustomTextField(
                controller: _locationController,
                label:
                    _meetingType == 'In-Person' ? 'Location' : 'Meeting Link',
                hint: _meetingType == 'In-Person'
                    ? 'Enter meeting location'
                    : 'Enter video call link',
                prefixIcon: Icon(_meetingType == 'In-Person'
                    ? Icons.location_on
                    : Icons.link),
              ),
              const SizedBox(height: 16),

              // Date and Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectMeetingDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  '${_meetingDate.day}/${_meetingDate.month}/${_meetingDate.year}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectMeetingTime,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(width: 8),
                                Text(
                                  _meetingTime.format(context),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Duration
              Text(
                'Duration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _duration,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                items: [30, 60, 90, 120, 180]
                    .map((duration) => DropdownMenuItem(
                          value: duration,
                          child: Text('$duration minutes'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _duration = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Attendees Section
              Text(
                'Attendees',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_attendees.isEmpty)
                      Text(
                        'No attendees added yet',
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    else
                      ..._attendees.map((attendee) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.person, size: 16),
                                const SizedBox(width: 8),
                                Expanded(child: Text(attendee)),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      _attendees.remove(attendee);
                                    });
                                  },
                                ),
                              ],
                            ),
                          )),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _showAddAttendeeDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Attendee'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Cancel',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Schedule Meeting',
                      onPressed: _scheduleMeeting,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAttendeeDialog() {
    final attendeeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attendee'),
        content: CustomTextField(
          controller: attendeeController,
          label: 'Email Address',
          hint: 'Enter attendee email',
          prefixIcon: const Icon(Icons.email),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email address';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (attendeeController.text.isNotEmpty &&
                  attendeeController.text.contains('@')) {
                setState(() {
                  _attendees.add(attendeeController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _setMeetingType(String value) {
    setState(() => _meetingType = value);
  }
}

// Replaced by generic RadioChoiceChip
