/// Constants for mood chart bubble positioning and sizing
class MoodChartConstants {
  // Chart dimensions
  static const double chartWidth = 320.0;
  static const double chartHeight = 200.0;
  
  // Bubble positions for up to 7 mood bubbles
  // Positioned to prevent clipping regardless of bubble size
  static const List<Map<String, double>> bubblePositions = [
    {'left': 100.0, 'top': 25.0},   // Position 1 - top center-left
    {'left': 200.0, 'top': 15.0},   // Position 2 - top center-right  
    {'left': 35.0, 'top': 80.0},    // Position 3 - middle left
    {'left': 250.0, 'top': 70.0},   // Position 4 - middle right
    {'left': 140.0, 'top': 100.0},  // Position 5 - center
    {'left': 65.0, 'top': 145.0},   // Position 6 - bottom left
    {'left': 220.0, 'top': 140.0},  // Position 7 - bottom right
  ];
  
  // Base sizes for top 7 positions with some variation
  static const List<double> baseBubbleSizes = [
    120.0, // Position 1 - largest
    100.0, // Position 2
    85.0,  // Position 3
    75.0,  // Position 4
    65.0,  // Position 5
    55.0,  // Position 6
    50.0,  // Position 7 - smallest
  ];
  
  // Scaling factor for percentage-based size adjustment
  static const double sizingScalingFactor = 0.3;
  
  // Default size for positions beyond top 7
  static const double defaultBubbleSize = 45.0;
  
  // Font size breakpoints based on bubble size
  static const Map<double, double> fontSizeBreakpoints = {
    100.0: 14.0, // Large bubbles
    80.0: 12.0,  // Medium bubbles
    60.0: 11.0,  // Small bubbles
    0.0: 10.0,   // Tiny bubbles (default)
  };
  
  // Text color luminance threshold
  static const double textColorLuminanceThreshold = 0.5;
}