import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'dart:math';

class CustomFruchtermanReingoldAlgorithm extends FruchtermanReingoldAlgorithm {
  late double myWidth; // 用来存储宽度
  late double myHeight; // 用来存储高度
  late double nodeWidth; // 用来存储节点宽度
  late double nodeHeight; // 用来存储节点高度

  // 构造函数，用于初始化成员变量
  CustomFruchtermanReingoldAlgorithm({
    required this.myWidth,
    required this.myHeight,
    required this.nodeWidth,
    required this.nodeHeight,
  }) {
    repulsionRate = 1.0; // 增大排斥力
    attractionRate = 0.05; // 减小吸引力
    repulsionPercentage = 0.5; // 增大排斥力作用范围
    attractionPercentage = 0.1; // 减小吸引力作用范围
  }

  @override
  void step(Graph? graph) {
    if (focusedNode != null) {
      return;
    }

    super.step(graph);
    // 使用 shiftCoordinates 方法将整个图形平移到中心区域
    // if (graph != null) {
    //   final offsetToCenter = getOffsetToCenter(graph);
    //   shiftCoordinates(graph, offsetToCenter.dx, offsetToCenter.dy);
    // }
  }

  @override
  void init(Graph? graph) {
    // 这里可以使用 graphWidth 和 graphHeight 来控制区域
    // 例如，你可以在这里设置节点的初始位
    setDimensions(myWidth / 2, myHeight / 2);
    super.init(graph);

    final offsetToCenter = getOffsetToCenter(graph!);
    shiftCoordinates(graph, offsetToCenter.dx, offsetToCenter.dy);
  }

  Offset getGraphCenter(Graph graph) {
    double left = double.infinity;
    double top = double.infinity;
    double right = double.negativeInfinity;
    double bottom = double.negativeInfinity;

    // 遍历所有节点，计算边界
    for (var node in graph.nodes) {
      left = min(left, node.x);
      top = min(top, node.y);
      right = max(right, node.x + node.width);
      bottom = max(bottom, node.y + node.height);
    }

    // 计算中心点
    double centerX = (left + right) / 2;
    double centerY = (top + bottom) / 2;

    return Offset(centerX, centerY);
  }

  Offset getOffsetToCenter(Graph graph) {
    // 计算目标中心位置（例如屏幕中心）
    final targetCenter = Offset(
      myWidth / 2 - nodeWidth,
      myHeight / 2 - nodeHeight,
    );

    // 计算当前节点与目标中心的偏移量
    return targetCenter - getGraphCenter(graph);
  }

  @override
  void setFocusedNode(Node? node) {
    // 这里可以设置当前聚焦的节点
    focusedNode = node;
  }
}
