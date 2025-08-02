import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/assistant_chat_page.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:nirva_app/utils.dart';
import 'package:intl/intl.dart';

class JournalDetailsPage extends StatefulWidget {
  final EventAnalysis eventData;

  const JournalDetailsPage({super.key, required this.eventData});

  @override
  State<JournalDetailsPage> createState() => _JournalDetailsPageState();
}

class _JournalDetailsPageState extends State<JournalDetailsPage> {
  final TextEditingController _notesController = TextEditingController();
  bool _isExpanded = false;

  bool get isFavorite {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    return favoritesProvider.checkFavorite(widget.eventData);
  }

  void _toggleFavorite() {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    setState(() {
      favoritesProvider.switchEventFavoriteStatus(widget.eventData);
      debugPrint(
        'Star button pressed: ${isFavorite ? "Added to favorites" : "Removed from favorites"}',
      );
    });

    HiveHelper.saveFavoriteIds(favoritesProvider.favoriteIds).catchError((
      error,
    ) {
      debugPrint('保存收藏夹数据失败: $error');
    });
  }

  void _initializeNotes() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final existingNote = notesProvider.getNoteById(widget.eventData.event_id);
    _notesController.text = existingNote?.content ?? '';
  }

  void _saveNotes() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final note = Note(
      id: widget.eventData.event_id,
      content: _notesController.text.trim(),
    );
    notesProvider.addNote(note);
  }

  void _chatWithNirva() {
    final textController = TextEditingController();
    // Pre-populate with context about this event
    textController.text = "I'd like to discuss this event: ${widget.eventData.event_title}. ${widget.eventData.first_person_narrative}";
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssistantChatPage(textController: textController),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: const Color(0xFFfaf9f5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0E3C26)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? const Color(0xFFe7bf57) : const Color(0xFF0E3C26),
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header Card
            _buildEventHeaderCard(),
            
            const SizedBox(height: 24),
            
            // Event Analysis Section
            _buildEventAnalysisSection(),
            
            const SizedBox(height: 24),
            
            // Action Items Section
            _buildActionItemsSection(),
            
            const SizedBox(height: 24),
            
            // Summary Section
            _buildSummarySection(),
            
            const SizedBox(height: 24),
            
            // Personal Notes Section
            _buildPersonalNotesSection(),
            
            const SizedBox(height: 24),
            
            // Nirva's Narrative Section
            _buildNirvaNarrativeSection(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),

    );
  }

  Widget _buildEventHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Chat Button Row
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.eventData.event_title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E3C26),
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFe7bf57),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _chatWithNirva,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Chat with Nirva',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Time and Location Row
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                widget.eventData.time_range,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.eventData.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Georgia',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Duration
          Row(
            children: [
              Icon(
                Icons.timer,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.eventData.duration_minutes} minutes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Mood and Activity Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Mood Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFfdd78c).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sentiment_satisfied,
                      size: 16,
                      color: const Color(0xFF0E3C26),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Mood: ${widget.eventData.mood_score}/10',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0E3C26),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Activity Type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFdad5fd).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.eventData.activity_type,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E3C26),
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFdad5fd).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.summarize,
                  size: 18,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Summary Text
          Text(
            widget.eventData.one_sentence_summary,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF0E3C26),
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNirvaNarrativeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFe7bf57).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  size: 18,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Nirva's Story",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Narrative Text
          Text(
            widget.eventData.first_person_narrative,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF0E3C26),
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventAnalysisSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFdad5fd).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.analytics,
                  size: 18,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Event Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Metrics Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Stress Level',
                  '${widget.eventData.stress_level}/10',
                  Icons.psychology,
                  const Color(0xFF616a7f),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Energy Level',
                  '${widget.eventData.energy_level}/10',
                  Icons.flash_on,
                  const Color(0xFFfdd78c),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // People Involved
          if (widget.eventData.people_involved.isNotEmpty) ...[
            _buildAnalysisItem(
              'People Involved',
              widget.eventData.people_involved.join(', '),
              Icons.people,
            ),
            const SizedBox(height: 12),
          ],
          
          // Interaction Dynamic
          if (widget.eventData.interaction_dynamic.isNotEmpty) ...[
            _buildAnalysisItem(
              'Interaction Style',
              widget.eventData.interaction_dynamic,
              Icons.handshake,
            ),
            const SizedBox(height: 12),
          ],
          
          // Impact
          if (widget.eventData.inferred_impact_on_user_name.isNotEmpty) ...[
            _buildAnalysisItem(
              'Impact on You',
              widget.eventData.inferred_impact_on_user_name,
              Icons.trending_up,
            ),
            const SizedBox(height: 12),
          ],
          
          // Topics
          if (widget.eventData.topic_labels.isNotEmpty) ...[
            _buildAnalysisItem(
              'Topics Discussed',
              widget.eventData.topic_labels.join(', '),
              Icons.topic,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String content, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalNotesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8D4B8).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.edit_note,
                  size: 18,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Your Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Notes Content
          Consumer<NotesProvider>(
            builder: (context, notesProvider, child) {
              // Initialize notes on first build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_notesController.text.isEmpty) {
                  _initializeNotes();
                }
              });
              
              return Column(
                children: [
                  TextField(
                    controller: _notesController,
                    maxLines: 6,
                    onChanged: (value) {
                      // Auto-save as user types
                      _saveNotes();
                    },
                    decoration: InputDecoration(
                      hintText: 'Add your thoughts, reflections, or memories about this event...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Georgia',
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: const Color(0xFFe7bf57).withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFe7bf57),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFfaf9f5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItemsSection() {
    if (widget.eventData.action_item.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8C4D4).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.task_alt,
                  size: 18,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Action Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action Item Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB8C4D4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFB8C4D4).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: const Color(0xFFB8C4D4),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.eventData.action_item,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF0E3C26),
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 