import 'package:flutter/material.dart';

void main() {
  runApp(const UScreenerApp());
}

final class AppRoutes {
  static const String home = '/';
  static const String screener = '/screener';

  const AppRoutes._();
}

class UScreenerApp extends StatelessWidget {
  const UScreenerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'US Screener',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute<void>(
              builder: (_) => const LandingScreen(),
              settings: settings,
            );
          case AppRoutes.screener:
            return MaterialPageRoute<void>(
              builder: (_) => const ScreenerScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute<void>(
              builder: (_) => const LandingScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

enum MainMenuAction { screener }

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('US Screener'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<MainMenuAction>(
              tooltip: 'Menu Utama',
              onSelected: (value) {
                switch (value) {
                  case MainMenuAction.screener:
                    Navigator.of(context).pushNamed(AppRoutes.screener);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<MainMenuAction>(
                  value: MainMenuAction.screener,
                  child: Text('Screener'),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Menu Utama',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.space_dashboard_outlined, size: 56),
                SizedBox(height: 16),
                Text(
                  'Pilih menu untuk membuka modul aplikasi.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenerScreen extends StatelessWidget {
  const ScreenerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      const _SurfaceCard(
        title: 'Daftar notes saham US',
        child: Column(
          children: [
            _WatchlistTile(
              ticker: 'AAPL',
              title: 'Apple watchlist',
              subtitle: 'Catatan valuasi dan momentum harga.',
            ),
            Divider(height: 1),
            _WatchlistTile(
              ticker: 'MSFT',
              title: 'Microsoft follow-up',
              subtitle: 'Pantau cloud growth dan margin operasional.',
            ),
            Divider(height: 1),
            _WatchlistTile(
              ticker: 'NVDA',
              title: 'NVIDIA setup',
              subtitle: 'Rangkuman AI demand dan level entry.',
            ),
          ],
        ),
      ),
      const _SurfaceCard(
        title: 'Editor note',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Judul note',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              minLines: 8,
              maxLines: 12,
              decoration: InputDecoration(
                labelText: 'Isi analisis',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                hintText:
                    'Tulis ide, risiko, level harga, atau checklist analisis di sini.',
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screener'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wideLayout = constraints.maxWidth >= 900;
            final content = wideLayout
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: sections[0]),
                      const SizedBox(width: 16),
                      Expanded(child: sections[1]),
                    ],
                  )
                : Column(
                    children: [
                      sections[0],
                      const SizedBox(height: 16),
                      sections[1],
                    ],
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: content,
            );
          },
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _WatchlistTile extends StatelessWidget {
  const _WatchlistTile({
    required this.ticker,
    required this.title,
    required this.subtitle,
  });

  final String ticker;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Text(ticker),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
