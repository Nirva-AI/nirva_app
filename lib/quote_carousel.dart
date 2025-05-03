import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

// 修改 QuoteCarousel 组件
class QuoteCarousel extends StatefulWidget {
  final List<QuoteData> quotes;

  const QuoteCarousel({super.key, required this.quotes});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150, // 设置卡片高度
          child: PageView.builder(
            itemCount: widget.quotes.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final quote = widget.quotes[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: quote.gradient,
                ),
                child: Center(
                  child: Text(
                    quote.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // 分页指示器
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.quotes.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentPage == index ? 12.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.purple : Colors.grey,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
