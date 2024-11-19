import 'package:flutter/material.dart';

class ColorPaletteScreen extends StatefulWidget {
  const ColorPaletteScreen({super.key});

  @override
  State<ColorPaletteScreen> createState() => _ColorPaletteScreenState();
}

class _ColorPaletteScreenState extends State<ColorPaletteScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Color Palette",
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            ColorBox(color: colorScheme.primary, name: 'Primary'),
            ColorBox(color: colorScheme.onPrimary, name: 'On Primary'),
            ColorBox(
                color: colorScheme.primaryContainer, name: 'Primary Container'),
            ColorBox(
                color: colorScheme.onPrimaryContainer,
                name: 'On Primary Container'),
            ColorBox(color: colorScheme.secondary, name: 'Secondary'),
            ColorBox(color: colorScheme.onSecondary, name: 'On Secondary'),
            ColorBox(
                color: colorScheme.secondaryContainer,
                name: 'Secondary Container'),
            ColorBox(
                color: colorScheme.onSecondaryContainer,
                name: 'On Secondary Container'),
            ColorBox(color: colorScheme.tertiary, name: 'Tertiary'),
            ColorBox(color: colorScheme.onTertiary, name: 'On Tertiary'),
            ColorBox(
                color: colorScheme.tertiaryContainer,
                name: 'Tertiary Container'),
            ColorBox(
                color: colorScheme.onTertiaryContainer,
                name: 'On Tertiary Container'),
            ColorBox(color: colorScheme.error, name: 'Error'),
            ColorBox(color: colorScheme.onError, name: 'On Error'),
            ColorBox(
                color: colorScheme.errorContainer, name: 'Error Container'),
            ColorBox(
                color: colorScheme.onErrorContainer,
                name: 'On Error Container'),
            ColorBox(color: colorScheme.background, name: 'Background'),
            ColorBox(color: colorScheme.onBackground, name: 'On Background'),
            ColorBox(color: colorScheme.surface, name: 'Surface'),
            ColorBox(color: colorScheme.onSurface, name: 'On Surface'),
          ],
        ),
      )),
    );
  }
}

class ColorBox extends StatelessWidget {
  final Color color;
  final String name;

  const ColorBox({Key? key, required this.color, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ColoredBox(
            color: color,
            child: const SizedBox(width: 100, height: 100),
          ),
          const SizedBox(width: 16),
          Text(name),
        ],
      ),
    );
  }
}
