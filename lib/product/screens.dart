import 'package:flutter/material.dart';
import '../app/brand.dart';
import '../app/theme.dart';

class ChronotypeAssessmentScreen extends StatelessWidget {
  const ChronotypeAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Chronotype', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Assessment', style: AppTheme.text(cInk))),
    );
  }
}

class DreamJournalLogScreen extends StatelessWidget {
  const DreamJournalLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Dream Journal', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Journal', style: AppTheme.text(cInk))),
    );
  }
}

class CorrelationChartsScreen extends StatelessWidget {
  const CorrelationChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Correlation', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Charts', style: AppTheme.text(cInk))),
    );
  }
}

class WhiteNoiseScreen extends StatelessWidget {
  const WhiteNoiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('White Noise', style: AppTheme.display(cSurface)), backgroundColor: cInk),
      body: Center(child: Text('Sounds', style: AppTheme.text(cInk))),
    );
  }
}
