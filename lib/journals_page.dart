import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/journal_details_page.dart';
import 'package:intl/intl.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Set initial date to a date that has data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSelectedDate();
    });
  }

  void _initializeSelectedDate() {
    final journalProvider = Provider.of<JournalFilesProvider>(context, listen: false);
    final availableFiles = journalProvider.journalFiles;
    
    if (availableFiles.isNotEmpty) {
      // Find the most recent date with data
      DateTime? mostRecentDate;
      for (var file in availableFiles) {
        try {
          final fileDate = DateTime.parse(file.time_stamp);
          if (mostRecentDate == null || fileDate.isAfter(mostRecentDate)) {
            mostRecentDate = fileDate;
          }
        } catch (e) {
          debugPrint('Error parsing date: ${file.time_stamp}');
        }
      }
      
      setState(() {
        _selectedDate = mostRecentDate ?? DateTime.now();
      });
      if (mostRecentDate == null) {
        debugPrint('No journal files found, using current date');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfaf9f5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0E3C26)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Journals',
          style: TextStyle(
            color: Color(0xFF0E3C26),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFe7bf57),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: Consumer<JournalFilesProvider>(
        builder: (context, journalProvider, child) {
          final journalFile = journalProvider.getJournalFileByDate(_selectedDate);
          final events = journalFile?.events ?? [];

          return Column(
            children: [
              // Date selector
              _buildDateSelector(journalProvider),
              
              const SizedBox(height: 24),
              
              // Timeline with events
              Expanded(
                child: _buildTimeline(events),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateSelector(JournalFilesProvider journalProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month and year selector
          Row(
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0E3C26)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Day selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = _selectedDate.subtract(Duration(days: 3 - index));
                final isSelected = _isSameDay(date, _selectedDate);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFe7bf57) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFe7bf57) : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF0E3C26),
                          ),
                        ),
                        Text(
                          DateFormat('E').format(date).substring(0, 3),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                        // Show indicator for dates with journal entries
                        if (_hasJournalEntries(date, journalProvider))
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : const Color(0xFFe7bf57),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTimeline(List<EventAnalysis> events) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No journal entries for this date',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    // Sort events by time in reverse order (latest first)
    final sortedEvents = List<EventAnalysis>.from(events);
    sortedEvents.sort((a, b) {
      final timeA = _parseTimeRange(a.time_range);
      final timeB = _parseTimeRange(b.time_range);
      return timeB.compareTo(timeA); // Reverse order: latest first
    });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final timeRange = _parseTimeRange(event.time_range);
        
        return _buildTimelineEvent(event, timeRange, index == sortedEvents.length - 1);
      },
    );
  }

  Widget _buildTimelineEvent(EventAnalysis event, TimeOfDay time, bool isLast) {
    // Parse end time
    final endTime = _parseEndTime(event.time_range);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        SizedBox(
          width: 50,
          child: Column(
            children: [
              // End time
              Text(
                '${endTime.hour.toString().padLeft(2, '0')}.${endTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              // Dashed line with fixed height
              SizedBox(
                width: 2,
                height: 155, // Fixed height for the dashed line
                child: CustomPaint(
                  painter: DashedLinePainter(),
                ),
              ),
              const SizedBox(height: 4),
              // Start time
              Text(
                '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Event card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalDetailsPage(eventData: event),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and favorite icon row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.event_title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E3C26),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 24, // Same width as profile circles
                        child: IconButton(
                          icon: const Icon(
                            Icons.star_border,
                            color: Color(0xFF0E3C26),
                            size: 20,
                          ),
                          onPressed: () {
                            // TODO: Add favorite functionality
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Subtitle
                  Container(
                    height: 40, // Fixed height for 2 lines
                    child: Text(
                      event.one_sentence_summary,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtle horizontal divider
                  Container(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tags row
                  Row(
                    children: [
                      // Category tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(event.activity_type).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(event.activity_type),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              event.activity_type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Bottom row with location and participants
                  Row(
                    children: [
                      // Location (bottom left)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Participants (bottom right) - stacked with overlap
                      if (event.people_involved.isNotEmpty)
                        SizedBox(
                          width: 24 + (event.people_involved.take(5).length - 1) * 16.0, // Calculate total width needed with 16px spacing
                          height: 24, // Fixed height for the stack
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: event.people_involved.take(5).toList().asMap().entries.map((entry) {
                              final index = entry.key;
                              final person = entry.value;
                              return Positioned(
                                right: index * 16.0, // Stack with 16px spacing from right (reduced overlap)
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _getPersonColor(person),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      person.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TimeOfDay _parseTimeRange(String timeRange) {
    // Parse time range like "08:00-08:30" and return start time
    final parts = timeRange.split('-');
    if (parts.isNotEmpty) {
      final timeParts = parts[0].split(':');
      if (timeParts.length == 2) {
        return TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  TimeOfDay _parseEndTime(String timeRange) {
    // Parse time range like "08:00-08:30" and return end time
    final parts = timeRange.split('-');
    if (parts.length > 1) {
      final timeParts = parts[1].split(':');
      if (timeParts.length == 2) {
        return TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _hasJournalEntries(DateTime date, JournalFilesProvider provider) {
    return provider.getJournalFileByDate(date) != null;
  }

  Color _getCategoryColor(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'work':
        return const Color(0xFFB8C4D4); // Light blue/grey (from Explore)
      case 'personal':
        return const Color(0xFFD4C4A8); // Light beige/brown (from Explore)
      case 'social':
        return const Color(0xFFC8D4B8); // Light green (from Explore)
      case 'exercise':
        return const Color(0xFFD0B8D4); // Light purple/pink (from Explore)
      case 'learning':
        return const Color(0xFFC8B8D4); // Light purple (from Explore)
      case 'self-care':
        return const Color(0xFFD4C8B8); // Light beige/yellow (from Explore)
      default:
        return const Color(0xFFB8C4D4); // Light blue/grey as default
    }
  }

  Color _getPersonColor(String personName) {
    // Generate consistent color based on person name using muted Explore colors
    final hash = personName.hashCode;
    final colors = [
      const Color(0xFFB8C4D4), // Light blue/grey
      const Color(0xFFD4C4A8), // Light beige/brown
      const Color(0xFFC8D4B8), // Light green
      const Color(0xFFD0B8D4), // Light purple/pink
      const Color(0xFFC8B8D4), // Light purple
      const Color(0xFFD4C8B8), // Light beige/yellow
    ];
    return colors[hash.abs() % colors.length];
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 4;
    const dashSpace = 4;
    double startY = 0;

    // Draw the dashed line
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }

    // Draw dots at both ends
    final dotPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;

    // Top dot
    canvas.drawCircle(
      Offset(size.width / 2, 0),
      2,
      dotPaint,
    );

    // Bottom dot
    canvas.drawCircle(
      Offset(size.width / 2, size.height),
      2,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 