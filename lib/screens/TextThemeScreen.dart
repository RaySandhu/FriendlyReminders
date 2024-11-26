import 'package:flutter/material.dart';

class TextThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter Text Theme'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildTextStyle(textTheme.displayLarge!, 'Display Large'),
            _buildTextStyle(textTheme.displayMedium!, 'Display Medium'),
            _buildTextStyle(textTheme.displaySmall!, 'Display Small'),
            _buildTextStyle(textTheme.headlineLarge!, 'Headline Large'),
            _buildTextStyle(textTheme.headlineMedium!, 'Headline Medium'),
            _buildTextStyle(textTheme.headlineSmall!, 'Headline Small'),
            _buildTextStyle(textTheme.titleLarge!, 'Title Large'),
            _buildTextStyle(textTheme.titleMedium!, 'Title Medium'),
            _buildTextStyle(textTheme.titleSmall!, 'Title Small'),
            _buildTextStyle(textTheme.bodyLarge!, 'Body Large'),
            _buildTextStyle(textTheme.bodyMedium!, 'Body Medium'),
            _buildTextStyle(textTheme.bodySmall!, 'Body Small'),
            _buildTextStyle(textTheme.labelLarge!, 'Label Large'),
            _buildTextStyle(textTheme.labelMedium!, 'Label Medium'),
            _buildTextStyle(textTheme.labelSmall!, 'Label Small'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextStyle(TextStyle style, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: style),
        ],
      ),
    );
  }
}
