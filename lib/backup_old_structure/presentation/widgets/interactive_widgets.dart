import 'package:flutter/material.dart';
import 'package:multisales_app/presentation/widgets/radio_choice_chip.dart';
import '../../core/utils/responsive_layout.dart';

/// Interactive data table with sorting, filtering, and selection
class ResponsiveDataTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int, bool)? onSort;
  final bool showCheckboxColumn;
  final Function(bool?)? onSelectAll;
  final bool showActions;
  final List<Widget>? actions;

  const ResponsiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.showCheckboxColumn = false,
    this.onSelectAll,
    this.showActions = false,
    this.actions,
  });

  @override
  State<ResponsiveDataTable> createState() => _ResponsiveDataTableState();
}

class _ResponsiveDataTableState extends State<ResponsiveDataTable> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileTable(context),
      tablet: _buildTabletTable(context),
      desktop: _buildDesktopTable(context),
      largeDesktop: _buildDesktopTable(context),
    );
  }

  Widget _buildMobileTable(BuildContext context) {
    return Column(
      children: [
        if (widget.showActions && widget.actions != null) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions!,
            ),
          ),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: widget.rows.length,
            itemBuilder: (context, index) {
              final row = widget.rows[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading:
                      widget.showCheckboxColumn ? row.cells.first.child : null,
                  title: row.cells[widget.showCheckboxColumn ? 1 : 0].child,
                  subtitle: widget.columns.length > 2
                      ? row.cells[widget.showCheckboxColumn ? 2 : 1].child
                      : null,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: List.generate(
                          widget.columns.length,
                          (cellIndex) {
                            if (widget.showCheckboxColumn && cellIndex == 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      widget.columns[cellIndex].label
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Expanded(child: row.cells[cellIndex].child),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletTable(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.showActions && widget.actions != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: widget.actions!,
              ),
            ),
            const Divider(),
          ],
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: widget.sortColumnIndex,
                sortAscending: widget.sortAscending,
                onSelectAll: widget.onSelectAll,
                showCheckboxColumn: widget.showCheckboxColumn,
                columns: widget.columns.map((column) {
                  return DataColumn(
                    label: column.label,
                    onSort: column.onSort,
                    numeric: column.numeric,
                  );
                }).toList(),
                rows: widget.rows,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        children: [
          if (widget.showActions && widget.actions != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions!,
            ),
            const SizedBox(height: 16),
            const Divider(),
          ],
          Expanded(
            child: DataTable(
              sortColumnIndex: widget.sortColumnIndex,
              sortAscending: widget.sortAscending,
              onSelectAll: widget.onSelectAll,
              showCheckboxColumn: widget.showCheckboxColumn,
              columns: widget.columns,
              rows: widget.rows,
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive form builder with validation
class ResponsiveFormBuilder extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final Function(Map<String, dynamic>)? onSubmit;
  final String? submitButtonText;
  final bool isLoading;

  const ResponsiveFormBuilder({
    super.key,
    required this.fields,
    this.onSubmit,
    this.submitButtonText,
    this.isLoading = false,
  });

  @override
  State<ResponsiveFormBuilder> createState() => _ResponsiveFormBuilderState();
}

class _ResponsiveFormBuilderState extends State<ResponsiveFormBuilder> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...widget.fields.map((field) => _buildFormField(context, field)),
            const SizedBox(height: 24),
            ResponsiveButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              isExpanded: true,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.submitButtonText ?? 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(BuildContext context, FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.label != null) ...[
            Text(
              field.label!,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
          ],
          _buildFieldWidget(context, field),
        ],
      ),
    );
  }

  Widget _buildFieldWidget(BuildContext context, FormFieldConfig field) {
    switch (field.type) {
      case FormFieldType.text:
        return ResponsiveFormField(
          hintText: field.hintText,
          controller: field.controller,
          validator: field.validator,
          onChanged: (value) => _formData[field.key] = value,
          prefixIcon: field.prefixIcon,
          suffixIcon: field.suffixIcon,
        );

      case FormFieldType.email:
        return ResponsiveFormField(
          hintText: field.hintText,
          controller: field.controller,
          keyboardType: TextInputType.emailAddress,
          validator: field.validator ?? _emailValidator,
          onChanged: (value) => _formData[field.key] = value,
          prefixIcon: field.prefixIcon ?? const Icon(Icons.email),
        );

      case FormFieldType.password:
        return ResponsiveFormField(
          hintText: field.hintText,
          controller: field.controller,
          obscureText: true,
          validator: field.validator ?? _passwordValidator,
          onChanged: (value) => _formData[field.key] = value,
          prefixIcon: field.prefixIcon ?? const Icon(Icons.lock),
        );

      case FormFieldType.multiline:
        return ResponsiveFormField(
          hintText: field.hintText,
          controller: field.controller,
          validator: field.validator,
          onChanged: (value) => _formData[field.key] = value,
          maxLines: 4,
        );

      case FormFieldType.dropdown:
        return DropdownButtonFormField<String>(
          value: field.initialValue,
          decoration: InputDecoration(
            hintText: field.hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: field.options?.map((option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: (value) => _formData[field.key] = value,
          validator: field.validator,
        );

      case FormFieldType.checkbox:
        return CheckboxListTile(
          title: Text(field.hintText ?? ''),
          value: _formData[field.key] ?? false,
          onChanged: (value) => setState(() => _formData[field.key] = value),
          controlAffinity: ListTileControlAffinity.leading,
        );

      case FormFieldType.radio:
        final selected = _formData[field.key] as String?;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: field.options?.map((option) {
                final isSelected = option.value == selected;
                return RadioChoiceChip(
                  label: option.label,
                  selected: isSelected,
                  onTap: () => setState(() => _formData[field.key] = option.value),
                );
              }).toList() ??
              [],
        );

      case FormFieldType.date:
        return TextFormField(
          controller: field.controller,
          decoration: InputDecoration(
            hintText: field.hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () => _selectDate(context, field),
          validator: field.validator,
        );

      case FormFieldType.time:
        return TextFormField(
          controller: field.controller,
          decoration: InputDecoration(
            hintText: field.hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.access_time),
          ),
          readOnly: true,
          onTap: () => _selectTime(context, field),
          validator: field.validator,
        );
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(_formData);
    }
  }

  Future<void> _selectDate(BuildContext context, FormFieldConfig field) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final formattedDate = '${date.day}/${date.month}/${date.year}';
      field.controller?.text = formattedDate;
      _formData[field.key] = date;
    }
  }

  Future<void> _selectTime(BuildContext context, FormFieldConfig field) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted) {
      final formattedTime = time.format(this.context);
      field.controller?.text = formattedTime;
      _formData[field.key] = time;
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

// Replaced by generic RadioChoiceChip

/// Form field configuration
class FormFieldConfig {
  final String key;
  final String? label;
  final String? hintText;
  final FormFieldType type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<DropdownOption>? options;
  final String? initialValue;
  final VoidCallback? onTap;

  FormFieldConfig({
    required this.key,
    this.label,
    this.hintText,
    required this.type,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.options,
    this.initialValue,
    this.onTap,
  });
}

/// Dropdown option
class DropdownOption {
  final String label;
  final String value;

  DropdownOption({required this.label, required this.value});
}

/// Form field types
enum FormFieldType {
  text,
  email,
  password,
  multiline,
  dropdown,
  checkbox,
  radio,
  date,
  time,
}

/// Interactive chart widget
class ResponsiveChart extends StatelessWidget {
  final String title;
  final List<ChartData> data;
  final ChartType type;
  final Color? primaryColor;
  final bool showLegend;
  final bool showGrid;

  const ResponsiveChart({
    super.key,
    required this.title,
    required this.data,
    required this.type,
    this.primaryColor,
    this.showLegend = true,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildChart(context),
          ),
          if (showLegend) ...[
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    switch (type) {
      case ChartType.bar:
        return _buildBarChart(context);
      case ChartType.line:
        return _buildLineChart(context);
      case ChartType.pie:
        return _buildPieChart(context);
      case ChartType.area:
        return _buildAreaChart(context);
    }
  }

  Widget _buildBarChart(BuildContext context) {
    return CustomPaint(
      painter: BarChartPainter(
        data: data,
        color: primaryColor ?? Theme.of(context).colorScheme.primary,
        showGrid: showGrid,
      ),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        data: data,
        color: primaryColor ?? Theme.of(context).colorScheme.primary,
        showGrid: showGrid,
      ),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return CustomPaint(
      painter: PieChartPainter(
        data: data,
        colors: _generateColors(context),
      ),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildAreaChart(BuildContext context) {
    return CustomPaint(
      painter: AreaChartPainter(
        data: data,
        color: primaryColor ?? Theme.of(context).colorScheme.primary,
        showGrid: showGrid,
      ),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: item.color ??
                    primaryColor ??
                    Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Color> _generateColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.error,
      colorScheme.surface,
    ];
  }
}

/// Chart data model
class ChartData {
  final String label;
  final double value;
  final Color? color;

  ChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

/// Chart types
enum ChartType { bar, line, pie, area }

/// Bar chart painter
class BarChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Color color;
  final bool showGrid;

  BarChartPainter({
    required this.data,
    required this.color,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / data.length * 0.8;
    final barSpacing = size.width / data.length * 0.2;

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i].value / maxValue) * size.height * 0.8;
      final x = i * (barWidth + barSpacing) + barSpacing / 2;
      final y = size.height - barHeight;

      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Line chart painter
class LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Color color;
  final bool showGrid;

  LineChartPainter({
    required this.data,
    required this.color,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].value / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Pie chart painter
class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final List<Color> colors;

  PieChartPainter({
    required this.data,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;
    final total = data.map((e) => e.value).reduce((a, b) => a + b);

    double startAngle = 0;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * 3.14159;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Area chart painter
class AreaChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Color color;
  final bool showGrid;

  AreaChartPainter({
    required this.data,
    required this.color,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    path.moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].value / maxValue) * size.height;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Interactive tabbed container
class ResponsiveTabs extends StatelessWidget {
  final List<TabData> tabs;
  final int initialIndex;
  final Function(int)? onTabChanged;

  const ResponsiveTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: ResponsiveLayout(
        mobile: _buildMobileTabs(context),
        tablet: _buildDesktopTabs(context),
        desktop: _buildDesktopTabs(context),
        largeDesktop: _buildDesktopTabs(context),
      ),
    );
  }

  Widget _buildMobileTabs(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 1,
          child: TabBar(
            isScrollable: true,
            tabs: tabs
                .map((tab) => Tab(
                      icon: tab.icon,
                      text: tab.title,
                    ))
                .toList(),
            onTap: onTabChanged,
          ),
        ),
        Expanded(
          child: TabBarView(
            children: tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTabs(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(
              tabs: tabs
                  .map((tab) => Tab(
                        icon: tab.icon,
                        text: tab.title,
                      ))
                  .toList(),
              onTap: onTabChanged,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: tabs.map((tab) => tab.content).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab data model
class TabData {
  final String title;
  final Widget? icon;
  final Widget content;

  TabData({
    required this.title,
    this.icon,
    required this.content,
  });
}
