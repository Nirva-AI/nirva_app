import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/journal_details_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/daily_reflection_page.dart';
import 'package:nirva_app/providers/events_provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:nirva_app/mini_call_bar.dart'; // No longer needed

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> with AutomaticKeepAliveClientMixin {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _reflectionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final EasyInfiniteDateTimelineController _dateTimelineController = EasyInfiniteDateTimelineController();
  int _currentQuestionIndex = 1;
  
  // Cache for events to check which dates have events
  Map<String, List<EventAnalysis>> _eventsCache = {};
  bool _isLoadingEvents = false;
  bool _isRefreshing = false;  // Track refresh state
  
  // Store the future to prevent rebuilding
  Future<List<EventAnalysis>>? _eventsFuture;
  String? _currentDateKey;
  
  @override
  bool get wantKeepAlive => true;

  // Sample questions for the picker wheel - matching Lounge slideshow content
  final List<Map<String, String>> _reflectionQuestions = [
    {
      'title': 'Evening Meditation',
      'subtitle': '15 Minute Guided Session',
    },
    {
      'title': 'Heart-to-heart',
      'subtitle': 'Want to share more about your frustration after date night?',
    },
    {
      'title': 'Today, in Moments',
      'subtitle': 'A gentle reflection on where your energy went.',
    },
    {
      'title': 'Mindful Walking',
      'subtitle': 'Outdoor Mindfulness Practice',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set initial date to a date that has data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }
  
  Future<void> _initializeData() async {
    await _initializeSelectedDate();
    await _loadEventsForVisibleDates();
    _loadEventsForSelectedDate();
    
    // Initialize scroll position if available
    if (_scrollController.hasClients) {
      // Can add scroll restoration here if needed in the future
    }
  }
  
  void _loadEventsForSelectedDate() {
    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    if (_currentDateKey != dateKey) {
      _currentDateKey = dateKey;
      final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
      _eventsFuture = eventsProvider.getEventsForDate(dateKey);
    }
  }
  
  /// Refresh events for current date ±7 days (15 days total)
  Future<void> _refreshEvents() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    try {
      final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
      final dates = <String>[];
      
      // Clear cache and collect dates for ±7 days from selected date
      for (int i = -7; i <= 7; i++) {
        final date = _selectedDate.add(Duration(days: i));
        final dateKey = DateFormat('yyyy-MM-dd').format(date);
        eventsProvider.clearCache(dateKey);
        dates.add(dateKey);
      }
      
      debugPrint('Refreshing events for ${dates.length} days around ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');
      
      // Fetch fresh data for all dates
      final eventsMap = await eventsProvider.getEventsForDates(dates);
      
      setState(() {
        _eventsCache = eventsMap;
        _isRefreshing = false;
      });
      
      // Reload the current selected date as well
      _currentDateKey = null;  // Force reload
      _loadEventsForSelectedDate();
      
    } catch (e) {
      debugPrint('Error refreshing events: $e');
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeSelectedDate() async {
    final journalProvider = Provider.of<JournalFilesProvider>(context, listen: false);
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final availableFiles = journalProvider.journalFiles;
    
    // Find the most recent date with data from local files
    DateTime? mostRecentLocalDate;
    for (var file in availableFiles) {
      try {
        final fileDate = DateTime.parse(file.time_stamp);
        if (mostRecentLocalDate == null || fileDate.isAfter(mostRecentLocalDate)) {
          mostRecentLocalDate = fileDate;
        }
      } catch (e) {
        debugPrint('Error parsing date: ${file.time_stamp}');
      }
    }
    
    // Check recent dates for server events (last 30 days)
    DateTime? mostRecentEventDate;
    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));
    
    try {
      // Get events for the past 30 days
      final eventsMap = await eventsProvider.getEventsForDateRange(thirtyDaysAgo, today);
      
      // Find the most recent date with events
      for (var entry in eventsMap.entries) {
        if (entry.value.isNotEmpty) {
          final date = DateTime.parse(entry.key);
          if (mostRecentEventDate == null || date.isAfter(mostRecentEventDate)) {
            mostRecentEventDate = date;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading events for date selection: $e');
    }
    
    // Choose the most recent date between local and server data
    DateTime selectedDate = DateTime.now();
    if (mostRecentLocalDate != null && mostRecentEventDate != null) {
      selectedDate = mostRecentLocalDate.isAfter(mostRecentEventDate) 
        ? mostRecentLocalDate 
        : mostRecentEventDate;
    } else if (mostRecentLocalDate != null) {
      selectedDate = mostRecentLocalDate;
    } else if (mostRecentEventDate != null) {
      selectedDate = mostRecentEventDate;
    }
    
    setState(() {
      _selectedDate = selectedDate;
    });
    
    debugPrint('Selected date initialized to: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
    debugPrint('Most recent local date: ${mostRecentLocalDate != null ? DateFormat('yyyy-MM-dd').format(mostRecentLocalDate) : 'none'}');
    debugPrint('Most recent event date: ${mostRecentEventDate != null ? DateFormat('yyyy-MM-dd').format(mostRecentEventDate) : 'none'}');
  }
  
  // Load events for the visible dates in the date picker
  Future<void> _loadEventsForVisibleDates() async {
    if (_isLoadingEvents) return;
    
    setState(() {
      _isLoadingEvents = true;
    });
    
    try {
      final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
      final dates = <String>[];
      
      // Get the 7 visible dates in the picker
      for (int i = -3; i <= 3; i++) {
        final date = _selectedDate.add(Duration(days: i));
        dates.add(DateFormat('yyyy-MM-dd').format(date));
      }
      
      // Fetch events for all dates
      final eventsMap = await eventsProvider.getEventsForDates(dates);
      
      setState(() {
        _eventsCache = eventsMap;
        _isLoadingEvents = false;
      });
    } catch (e) {
      debugPrint('Error loading events for dates: $e');
      setState(() {
        _isLoadingEvents = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Get providers without listening to prevent automatic rebuilds
    final journalProvider = context.read<JournalFilesProvider>();
    final eventsProvider = context.read<EventsProvider>();
    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      body: Builder(
        builder: (context) {
          
          // Initialize the future if needed (but don't recreate on every build)
          if (_eventsFuture == null || _currentDateKey != dateKey) {
            _loadEventsForSelectedDate();
          }
          
          // Use FutureBuilder to get merged events from backend and local sources
          return FutureBuilder<List<EventAnalysis>>(
            future: _eventsFuture ?? eventsProvider.getEventsForDate(dateKey),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading events',
                        style: TextStyle(fontSize: 18, color: Colors.red.shade300),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              final events = snapshot.data ?? [];
              final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return Stack(
            children: [
              SingleChildScrollView(
                key: const PageStorageKey('journals_scroll'),
                controller: _scrollController,
                child: Column(
                  children: [
                    // Daily Reflection Section - extends to top of screen
                    _buildDailyReflectionSection(),
                    

                    
                    const SizedBox(height: 20),
                    
                    // Journals section title with action buttons
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            'Journals',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E3C26),
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const Spacer(),
                          // Refresh button
                          IconButton(
                              onPressed: _isRefreshing ? null : () async {
                                await _refreshEvents();
                              },
                              icon: _isRefreshing
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.grey.shade600,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.refresh,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                          ),
                          // Create new event button
                          IconButton(
                            onPressed: () {
                              // TODO: Add create new event functionality
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                          // Search button
                          IconButton(
                            onPressed: () {
                              // TODO: Add search functionality
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date selector with padding
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildDateSelector(journalProvider),
                    ),
                
                    const SizedBox(height: 24),
                    
                    // Timeline with events
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: isLoading 
                        ? const Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Loading events...'),
                              ],
                            ),
                          )
                        : _buildTimeline(events),
                    ),
                    
                    // Add bottom padding for safe area
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // MiniCallBar removed since this is now a root page with HomePage handling navigation
            ],
          );
            },
          );
        },
      ),
    );
  }

  Widget _buildDailyReflectionSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF3E6DE), // Updated background color
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with icons
              Row(
                children: [
                  const Spacer(),
                  // Notification icon in top right
                  Container(
                    width: 42,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDDBD2), // Reverted to original background color
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey.shade600, // Keep grey color for icon
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Spacing after top row
              
              // Greeting row with profile picture
              Row(
                children: [
                  const Text(
                    'Hi, Jason',
                    style: TextStyle(
                      fontSize: 36, // Much bigger text size
                      fontWeight: FontWeight.normal, // Removed bold
                      color: Color(0xFF0E3C26), // Keep dark green color for main text
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Question picker wheel card
              _buildQuestionPickerCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionPickerCard() {
    return Container(
      height: 200,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.85,
          initialPage: 1,
        ),
        onPageChanged: (index) {
          setState(() {
            _currentQuestionIndex = index;
          });
        },
        itemCount: _reflectionQuestions.length,
        itemBuilder: (context, index) {
          final question = _reflectionQuestions[index];
          final isActive = index == _currentQuestionIndex;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEDDBD2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isActive ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title row
                      Text(
                        question['title']!,
                        style: TextStyle(
                          fontSize: isActive ? 22 : 20,
                          color: const Color(0xFF0E3C26),
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question['subtitle']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow outward button at bottom right
                Positioned(
                  bottom: 16,
                  right: 21,
                  child: GestureDetector(
                    onTap: () {
                      // Open daily reflection page for "Today, in Moments" card
                      if (index == 2) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const DailyReflectionPage(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFe7bf57),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_outward,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }



  Widget _buildDateSelector(JournalFilesProvider journalProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month/year selector and Today button row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Month and year selector (clickable)
            GestureDetector(
              onTap: () => _showMonthYearPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E3C26),
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0E3C26), size: 20),
                  ],
                ),
              ),
            ),
            // Today button
            IconButton(
              onPressed: () {
                final today = DateTime.now();
                setState(() {
                  _selectedDate = today;
                });
                // Animate the date picker to today
                _dateTimelineController.animateToDate(today);
                // Reload events for today
                _loadEventsForVisibleDates();
                _loadEventsForSelectedDate();
              },
              icon: Icon(
                Icons.today,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Infinite scrolling day selector
        SizedBox(
          height: 70,
          child: EasyInfiniteDateTimeLine(
            controller: _dateTimelineController,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)), // 2 years back
            focusDate: _selectedDate,
            lastDate: DateTime.now().add(const Duration(days: 365)), // 1 year forward
            onDateChange: (newDate) {
              setState(() {
                _selectedDate = newDate;
              });
              
              // Reload events for new visible dates
              _loadEventsForVisibleDates();
              _loadEventsForSelectedDate();
            },
            showTimelineHeader: false,
            dayProps: EasyDayProps(
              width: 52,  // Reduced from 58
              height: 60,
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3C26),
                  borderRadius: BorderRadius.circular(12),
                ),
                dayNumStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
                dayStrStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontFamily: 'Georgia',
                ),
              ),
              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                dayNumStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
                dayStrStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontFamily: 'Georgia',
                ),
              ),
              todayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade400,  // Slightly darker for visibility
                    width: 2,  // Bold border for today
                  ),
                ),
                dayNumStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,  // Normal weight like other days
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
                dayStrStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,  // Same as other days
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            itemBuilder: (context, date, isSelected, onDateTap) {
              final hasEntries = _hasJournalEntries(date, journalProvider);
              final isToday = _isSameDay(date, DateTime.now());
              
              return GestureDetector(
                onTap: onDateTap,
                child: Container(
                  width: 52,  // Reduced from 58
                  margin: const EdgeInsets.symmetric(horizontal: 2),  // Reduced from 4
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0E3C26) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? const Color(0xFF0E3C26) 
                        : (isToday ? Colors.grey.shade400 : Colors.grey.shade300),
                      width: isToday && !isSelected ? 2 : 1,  // Bold border for today
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,  // Same weight for all days
                          color: isSelected ? Colors.white : const Color(0xFF0E3C26),
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        DateFormat('E').format(date).substring(0, 3),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Colors.grey.shade600,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      // Show indicator for dates with journal entries
                      if (hasEntries)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFF0E3C26),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 6), // Placeholder to maintain consistent height
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
            fontFamily: 'Georgia',
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

    return Column(
      children: sortedEvents.asMap().entries.map((entry) {
        final index = entry.key;
        final event = entry.value;
        final timeRange = _parseTimeRange(event.time_range);
        
        return _buildTimelineEvent(event, timeRange, index == sortedEvents.length - 1);
      }).toList(),
    );
  }

  Widget _buildTimelineEvent(EventAnalysis event, TimeOfDay time, bool isLast) {
    // Parse end time and check if it exists
    final endTime = _parseEndTime(event.time_range);
    final hasEndTime = _hasEndTime(event.time_range);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        SizedBox(
          width: 50,
          child: Column(
            children: [
              // End time (only show if there's actually an end time)
              if (hasEndTime)
                Text(
                  '${endTime.hour.toString().padLeft(2, '0')}.${endTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontFamily: 'Georgia',
                  ),
                )
              else
                Text(
                  '•', // Show a dot for single timestamp events
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                    fontFamily: 'Georgia',
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
                  fontFamily: 'Georgia',
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
              // Use CupertinoPageRoute for iOS-style swipe back gesture
              Navigator.push(
                context,
                CupertinoPageRoute(
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
                            fontFamily: 'Georgia',
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
                        fontFamily: 'Georgia',
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: event.topic_labels.map((tag) {
                      // Special handling for upward/downward arrows
                      if (tag.toLowerCase() == 'upward') {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_upward_outlined,
                                size: 16,
                                color: const Color(0xFF4CAF50),
                              ),
                            ],
                          ),
                        );
                      } else if (tag.toLowerCase() == 'downward') {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF44336).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_downward_outlined,
                                size: 16,
                                color: const Color(0xFFF44336),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Regular tags with circle and text
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTagColor(tag).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _getTagColor(tag),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }).toList(),
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
                                fontFamily: 'Georgia',
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
                                        fontFamily: 'Georgia',
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
    try {
      // Handle multiple formats
      if (timeRange.contains(' - ')) {
        // Format: "2:30 PM - 4:15 PM"
        final parts = timeRange.split(' - ');
        if (parts.isNotEmpty) {
          return _parseTimeString(parts[0].trim());
        }
      } else if (timeRange.contains('-')) {
        // Format: "08:00-08:30" or "8:00-8:30"
        final parts = timeRange.split('-');
        if (parts.isNotEmpty) {
          return _parseTimeString(parts[0].trim());
        }
      } else {
        // Single time format
        return _parseTimeString(timeRange.trim());
      }
    } catch (e) {
      // Silent failure, return default
    }
    
    return const TimeOfDay(hour: 0, minute: 0);
  }

  TimeOfDay _parseEndTime(String timeRange) {
    try {
      // Handle multiple formats
      if (timeRange.contains(' - ')) {
        // Format: "2:30 PM - 4:15 PM"
        final parts = timeRange.split(' - ');
        if (parts.length > 1) {
          return _parseTimeString(parts[1].trim());
        }
      } else if (timeRange.contains('-')) {
        // Format: "08:00-08:30" or "8:00-8:30"
        final parts = timeRange.split('-');
        if (parts.length > 1) {
          return _parseTimeString(parts[1].trim());
        }
      }
    } catch (e) {
      // Silent failure, return default
    }
    
    return const TimeOfDay(hour: 0, minute: 0);
  }

  /// Check if a time range has an end time
  bool _hasEndTime(String timeRange) {
    return timeRange.contains(' - ') || timeRange.contains('-');
  }

  /// Parse individual time string handling multiple formats and timezone conversion
  TimeOfDay _parseTimeString(String timeStr) {
    try {
      // Remove extra whitespace
      timeStr = timeStr.trim();
      
      // Handle AM/PM format (12-hour)
      if (timeStr.toUpperCase().contains('AM') || timeStr.toUpperCase().contains('PM')) {
        final isPM = timeStr.toUpperCase().contains('PM');
        
        // Remove AM/PM and parse the time part
        final timePart = timeStr.replaceAll(RegExp(r'\s*(AM|PM)', caseSensitive: false), '');
        final timeParts = timePart.split(':');
        
        if (timeParts.length == 2) {
          int hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          
          // Convert 12-hour to 24-hour format
          if (isPM && hour != 12) {
            hour += 12;
          } else if (!isPM && hour == 12) {
            hour = 0;
          }
          
          // Apply timezone conversion (assuming server times are in a different timezone)
          return _convertToUserTimezone(TimeOfDay(hour: hour, minute: minute));
        }
      } else {
        // Handle 24-hour format or simple format without AM/PM
        final timeParts = timeStr.split(':');
        if (timeParts.length == 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          
          // Apply timezone conversion
          return _convertToUserTimezone(TimeOfDay(hour: hour, minute: minute));
        }
      }
    } catch (e) {
      // Silent failure, return default
    }
    
    return const TimeOfDay(hour: 0, minute: 0);
  }

  /// Convert server time to user's local timezone
  /// This is a simplified conversion - in a real app you'd want to know the server's timezone
  TimeOfDay _convertToUserTimezone(TimeOfDay serverTime) {
    try {
      // Create a DateTime for today with the server time
      final now = DateTime.now();
      
      // For now, we'll assume server times are in UTC and convert to local time
      // In a production app, you'd want to know the server's actual timezone
      final utcDateTime = DateTime.utc(
        now.year,
        now.month,
        now.day,
        serverTime.hour,
        serverTime.minute,
      );
      
      final localDateTime = utcDateTime.toLocal();
      
      return TimeOfDay.fromDateTime(localDateTime);
      
    } catch (e) {
      return serverTime; // Return original time if conversion fails
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _hasJournalEntries(DateTime date, JournalFilesProvider provider) {
    // Check if there's a local journal file
    if (provider.getJournalFileByDate(date) != null) {
      return true;
    }
    
    // Check if there are events from backend
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final events = _eventsCache[dateKey];
    return events != null && events.isNotEmpty;
  }
  
  Future<void> _showMonthYearPicker(BuildContext context) async {
    final now = DateTime.now();
    
    // Controllers for the picker wheels
    final monthController = FixedExtentScrollController(
      initialItem: _selectedDate.month - 1,
    );
    final yearController = FixedExtentScrollController(
      initialItem: _selectedDate.year - (now.year - 2),
    );
    
    int selectedMonth = _selectedDate.month;
    int selectedYear = _selectedDate.year;
    
    // Show month/year picker dialog with dual wheels
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: const BoxDecoration(
            color: Color(0xFFfaf9f5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title and Done button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E3C26),
                        fontFamily: 'Georgia',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to 1st of selected month
                        final newDate = DateTime(selectedYear, selectedMonth, 1);
                        setState(() {
                          _selectedDate = newDate;
                        });
                        
                        // Animate the date picker to the new date
                        _dateTimelineController.animateToDate(newDate);
                        
                        // Close the modal
                        Navigator.pop(context);
                        
                        // Reload events
                        _loadEventsForVisibleDates();
                        _loadEventsForSelectedDate();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Color(0xFFe7bf57),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Dual picker wheels
              Expanded(
                child: Row(
                  children: [
                    // Month wheel
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Month',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: monthController,
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                selectedMonth = index + 1;
                              },
                              selectionOverlay: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                ),
                              ),
                              children: List<Widget>.generate(12, (index) {
                                final monthName = DateFormat('MMMM').format(DateTime(2024, index + 1));
                                return Center(
                                  child: Text(
                                    monthName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF0E3C26),
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Year wheel
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Year',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: yearController,
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                selectedYear = now.year - 2 + index;
                              },
                              selectionOverlay: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                ),
                              ),
                              children: List<Widget>.generate(4, (index) {
                                final year = now.year - 2 + index;
                                return Center(
                                  child: Text(
                                    year.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF0E3C26),
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    
    // Dispose controllers
    monthController.dispose();
    yearController.dispose();
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

  Color _getTagColor(String tag) {
    // Map tags to specific colors based on the images
    switch (tag.toLowerCase()) {
      case 'peaceful':
      case 'calm':
      case 'reflective':
        return const Color(0xFF5B7BD6); // More vibrant blue for mood tags
      case 'engaged':
        return const Color(0xFF4CAF50); // Green for engaged
      case 'disengaged':
        return const Color(0xFFF44336); // Red for disengaged
      case 'outdoor':
        return const Color(0xFF4CAF50); // More vibrant green for outdoor
      case 'conversation':
      case 'transportation':
      case 'meal':
      case 'entertainment':
        return const Color(0xFF2196F3); // More vibrant blue for activity tags
      default:
        return const Color(0xFF5B7BD6); // Default vibrant blue
    }
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