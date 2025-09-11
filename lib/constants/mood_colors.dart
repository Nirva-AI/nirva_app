import 'package:flutter/material.dart';

/// Mood color mapping for the mood trend chart
/// Each mood gets its own unique, distinguishable color while maintaining
/// the same soft, muted aesthetic as the app's design system
class MoodColors {
  static const Map<String, Color> _colorMap = {
    // ===== CORE LIBRARY COLORS (6 base colors) =====
    'calm': Color(0xFFB8C4D4), // Cool blue
    'happy': Color(0xFFfdd78c), // Warm golden
    'focused': Color(0xFFC8D4B8), // Fresh sage green
    'stressed': Color(0xFF616a7f), // Deep blue-grey
    'creative': Color(0xFFdad5fd), // Soft purple
    'grounded': Color(0xFFD4C4A8), // Warm beige
    
    // ===== EMOTION FAMILIES WITH DISTINCT HUE SHIFTS =====
    
    // BLUE FAMILY - Cool, calming emotions (clearly blue-toned)
    'peaceful': Color(0xFF9BB4CC), // Medium blue
    'relaxed': Color(0xFFD0DCE8), // Light blue
    'sad': Color(0xFF8FA4C0), // Deeper blue
    'melancholy': Color(0xFF7A94B8), // Rich blue
    'lonely': Color(0xFFBCC8DC), // Pale blue
    
    // GREEN FAMILY - Growth, nature emotions (clearly green-toned)
    'content': Color(0xFFA8D0B8), // Fresh green
    'satisfied': Color(0xFFB8E0C8), // Bright green
    'grateful': Color(0xFF90C0A0), // Deep green
    'energized': Color(0xFFC0E8D0), // Light green
    'engaged': Color(0xFF98C8A8), // Medium green
    
    // YELLOW/ORANGE FAMILY - Warm, energetic emotions (clearly warm-toned)
    'joyful': Color(0xFFFFD070), // Bright yellow
    'excited': Color(0xFFFFB85C), // Orange-yellow
    'optimistic': Color(0xFFF0D860), // Golden yellow
    'confident': Color(0xFFE0C060), // Deep gold
    'hopeful': Color(0xFFE8D078), // Warm gold
    
    // PURPLE FAMILY - Introspective, mystical emotions (clearly purple-toned)
    'inspired': Color(0xFFD0C0F0), // Light purple
    'thoughtful': Color(0xFFC0A8E8), // Medium purple
    'curious': Color(0xFFE0D0F8), // Pale purple
    'wondering': Color(0xFFB898D8), // Deep purple
    'mystical': Color(0xFFD8C8F0), // Soft purple
    
    // PINK/ROSE FAMILY - Loving, warm emotions (clearly pink-toned)
    'love': Color(0xFFE8B8D0), // Warm rose
    'affection': Color(0xFFF0C8E0), // Light pink
    'warmth': Color(0xFFE0A8C0), // Deep rose
    'compassion': Color(0xFFF8D0E8), // Pale pink
    'tender': Color(0xFFE8C0D8), // Soft rose
    
    // GREY FAMILY - Neutral, tired emotions (clearly grey-toned)
    'tired': Color(0xFF8090A0), // Cool grey
    'exhausted': Color(0xFF687888), // Dark grey
    'drained': Color(0xFF98A8B8), // Light grey
    'bored': Color(0xFFA0A0A0), // Neutral grey
    'indifferent': Color(0xFF888898), // Blue-grey
    
    // CORAL/PEACH FAMILY - Playful, social emotions (clearly coral-toned)
    'playful': Color(0xFFFFB898), // Bright coral
    'amused': Color(0xFFF0A880), // Deep coral
    'cheerful': Color(0xFFFFD0B0), // Light peach
    'social': Color(0xFFE8A070), // Rich coral
    'friendly': Color(0xFFF8C0A0), // Soft peach
    
    // BROWN/TAN FAMILY - Grounding, stable emotions (clearly brown-toned)
    'centered': Color(0xFFD0B890), // Warm brown
    'stable': Color(0xFFC0A070), // Deep brown
    'accomplished': Color(0xFFE0C8A0), // Light tan
    'pride': Color(0xFFD8B888), // Golden brown
    'secure': Color(0xFFC8B080), // Medium brown
    
    // RED FAMILY - Intense emotions (clearly red-toned)
    'anger': Color(0xFFE09080), // Muted red
    'frustrated': Color(0xFFD08070), // Deep red
    'irritated': Color(0xFFF0A890), // Light red
    'passionate': Color(0xFFE08888), // Warm red
    'intense': Color(0xFFD07878), // Rich red
    
    // LAVENDER FAMILY - Anxious, uncertain emotions (clearly lavender-toned)
    'anxious': Color(0xFFC8B8E0), // Light lavender
    'worried': Color(0xFFB8A8D0), // Medium lavender
    'nervous': Color(0xFFD0C0E8), // Pale lavender
    'fear': Color(0xFFA898C0), // Deep lavender
    'uncertain': Color(0xFFD8C8F0), // Soft lavender
    
    // TEAL FAMILY - Balanced, healing emotions (clearly teal-toned)
    'balanced': Color(0xFF98C8C0), // Fresh teal
    'healing': Color(0xFFA8D8D0), // Light teal
    'renewal': Color(0xFF88B8B0), // Deep teal
    'harmony': Color(0xFFB8E8E0), // Pale teal
    'flow': Color(0xFF78A8A0), // Rich teal
    
    // LIME FAMILY - Competitive, envious emotions (clearly lime-toned)
    'jealous': Color(0xFFB0D088), // Bright lime
    'envious': Color(0xFFC0E098), // Light lime
    'competitive': Color(0xFFA0C078), // Deep lime
    'ambitious': Color(0xFFD0F0A8), // Pale lime
    'driven': Color(0xFF90B068), // Rich lime
    
    // CREAM FAMILY - Surprised, amazed emotions (clearly cream-toned)
    'surprised': Color(0xFFF0E0C0), // Warm cream
    'shocked': Color(0xFFF8F0D8), // Light cream
    'amazed': Color(0xFFE8D8B0), // Deep cream
    'astonished': Color(0xFFF0E8D0), // Pale cream
    'wonder': Color(0xFFE0D0A0), // Rich cream
    
    // MAUVE FAMILY - Guilt, shame emotions (clearly mauve-toned)
    'guilt': Color(0xFFD8B8C0), // Warm mauve
    'shame': Color(0xFFE8C8D0), // Light mauve
    'regret': Color(0xFFC8A8B0), // Deep mauve
    'remorse': Color(0xFFE0C0C8), // Soft mauve
    'disappointment': Color(0xFFD0B0B8), // Medium mauve
    
    // MINT FAMILY - Fresh, new emotions (clearly mint-toned)
    'refreshed': Color(0xFFB0E0C8), // Fresh mint
    'renewed': Color(0xFFC0F0D8), // Light mint
    'invigorated': Color(0xFFA0D0B8), // Deep mint
    'revitalized': Color(0xFFD0F8E0), // Pale mint
    'alive': Color(0xFF90C0A8), // Rich mint
    
    // Default for any unknown moods
    'neutral': Color(0xFFD0D0D0), // Neutral grey
  };

  /// Get color for a specific mood, returns neutral grey for unknown moods
  static Color getMoodColor(String mood) {
    return _colorMap[mood.toLowerCase()] ?? _colorMap['neutral']!;
  }

  /// Get all available mood colors
  static Map<String, Color> get allColors => Map.unmodifiable(_colorMap);

  /// Get list of all supported moods
  static List<String> get supportedMoods => _colorMap.keys.toList();
}