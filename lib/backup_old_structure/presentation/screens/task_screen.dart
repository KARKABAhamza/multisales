import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/layout/main_scaffold.dart';
import '../widgets/forms/custom_form_fields.dart';
import '../widgets/buttons/custom_buttons.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'Medium';
  String _category = 'Sales';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate saving task
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!'),
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
      title: 'Add New Task',
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              CustomTextField(
                controller: _titleController,
                label: 'Task Title',
                hint: 'Enter task title',
                prefixIcon: const Icon(Icons.task),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Task Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter task description',
                maxLines: 4,
                prefixIcon: const Icon(Icons.description),
              ),
              const SizedBox(height: 16),

              // Priority Selection
              Text(
                'Priority',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _PriorityOption(label: 'Low', value: 'Low', selected: _priority, onChanged: _setPriority)),
                  Expanded(child: _PriorityOption(label: 'Medium', value: 'Medium', selected: _priority, onChanged: _setPriority)),
                  Expanded(child: _PriorityOption(label: 'High', value: 'High', selected: _priority, onChanged: _setPriority)),
                ],
              ),
              const SizedBox(height: 16),

              // Category Selection
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Sales', 'Marketing', 'Support', 'Training', 'Admin']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Due Date
              Text(
                'Due Date',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDueDate,
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
                      const SizedBox(width: 12),
                      Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
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
                      text: 'Create Task',
                      onPressed: _saveTask,
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

  void _setPriority(String value) {
    setState(() => _priority = value);
  }
}

class _PriorityOption extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onChanged;
  const _PriorityOption({required this.label, required this.value, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == selected;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Theme.of(context).colorScheme.primary : null)),
          ],
        ),
      ),
    );
  }
}

