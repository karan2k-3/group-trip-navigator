import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripAiService {
  static const _baseUrl = 'http://127.0.0.1:8000';
  static const _sessionId = 'melbourne-weekend';

  static Future<String> getTripSuggestion() async {
    const message = '''
You are TripSync's group travel planning assistant.

Our trip:
- Destination: Melbourne
- Dates: 18–20 October
- Travellers: 4
- Total budget: AUD 1,600
- Preferences: food, wine, art, relaxed pace

Recommend one specific next activity or planning decision for the group.
Give a short title on the first line, followed by no more than two practical sentences.
''';

    final response = await http.post(
      Uri.parse('$_baseUrl/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'session_id': _sessionId,
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['reply'] as String;
  }
}

void main() {
  runApp(const TripSyncApp());
}

class AppColors {
  static const ink = Color(0xFF18241F);
  static const cream = Color(0xFFF8F5ED);
  static const paper = Color(0xFFFFFDF8);
  static const lime = Color(0xFFD7F04E);
  static const muted = Color(0xFF68746D);
  static const line = Color(0xFFDCDed6);
  static const paleLime = Color(0xFFE8EECE);
  static const darkCard = Color(0xFF202D27);
}

class TripSyncApp extends StatelessWidget {
  const TripSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.ink,
        onPrimary: Colors.white,
        secondary: AppColors.lime,
        onSecondary: AppColors.ink,
        surface: AppColors.paper,
        onSurface: AppColors.ink,
        outline: AppColors.line,
      ),
    );

    return MaterialApp(
      title: 'TripSync',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.paper,
          foregroundColor: AppColors.ink,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: AppColors.paper,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.line),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.line,
          thickness: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: AppColors.muted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF7B9630),
              width: 1.5,
            ),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppColors.paper,
          indicatorColor: AppColors.lime,
          height: 76,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: AppColors.ink),
          ),
        ),
      ),
      home: const TripHome(),
    );
  }
}

class TripHome extends StatefulWidget {
  const TripHome({super.key});

  @override
  State<TripHome> createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  int _index = 0;

  final _pages = const [
    OverviewPage(),
    ItineraryPage(),
    BudgetPage(),
    ChatPage(),
  ];

  final _titles = ['TripSync', 'Itinerary', 'Budget', 'Group chat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              _titles[_index],
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            if (_index == 0) ...[
              const SizedBox(width: 8),
              const Text(
                '• PLAN TOGETHER',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.muted,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.lime,
              child: Text(
                'K',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 32),
      children: [
        const Text(
          '18–20 OCTOBER • 4 TRAVELLERS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: Color(0xFF62702B),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Melbourne\nWeekend',
          style: TextStyle(
            fontSize: 42,
            height: 0.98,
            letterSpacing: -1.8,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'A relaxed long weekend of food, wine, art and good company.',
          style: TextStyle(
            fontSize: 16,
            height: 1.45,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 24),
        const AiTripBanner(),
        const SizedBox(height: 26),
        const SectionLabel('YOUR GROUP'),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                GroupMemberRow(
                  name: 'Karan',
                  subtitle: 'Organiser',
                  initial: 'K',
                  color: AppColors.lime,
                  isYou: true,
                ),
                Divider(),
                GroupMemberRow(
                  name: 'Mia',
                  subtitle: 'Joined the trip',
                  initial: 'M',
                  color: Color(0xFFF4C1B6),
                ),
                Divider(),
                GroupMemberRow(
                  name: 'Alex',
                  subtitle: 'Joined the trip',
                  initial: 'A',
                  color: Color(0xFFCFE8D7),
                ),
                Divider(),
                GroupMemberRow(
                  name: 'Sam',
                  subtitle: 'Joined the trip',
                  initial: 'S',
                  color: Color(0xFFF8DCA1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        const SectionLabel('QUICK ACTIONS'),
        const SizedBox(height: 12),
        const ActionCard(
          icon: Icons.add_location_alt_outlined,
          title: 'Add a place',
          subtitle: 'Save a café, attraction, or hotel',
        ),
        const SizedBox(height: 10),
        const ActionCard(
          icon: Icons.person_add_alt_1_outlined,
          title: 'Invite traveller',
          subtitle: 'Share your trip link with friends',
        ),
      ],
    );
  }
}

class AiTripBanner extends StatefulWidget {
  const AiTripBanner({super.key});

  @override
  State<AiTripBanner> createState() => _AiTripBannerState();
}

class _AiTripBannerState extends State<AiTripBanner> {
  late Future<String> _suggestion;

  @override
  void initState() {
    super.initState();
    _suggestion = TripAiService.getTripSuggestion();
  }

  void _refresh() {
    setState(() {
      _suggestion = TripAiService.getTripSuggestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _suggestion,
      builder: (context, snapshot) {
        final isLoading =
            snapshot.connectionState == ConnectionState.waiting;

        final text = isLoading
            ? 'TripSync is checking your group’s preferences…'
            : snapshot.hasError
                ? 'Could not reach the AI planner. Make sure the backend is running.'
                : snapshot.data ??
                    'No suggestion was returned. Please try again.';

        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AiIcon(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI TRIP SUGGESTION',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: AppColors.lime,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: isLoading ? null : _refresh,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.lime,
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text(
                        'Ask again',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AiIcon extends StatelessWidget {
  const AiIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: AppColors.ink,
        size: 20,
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w800,
        color: AppColors.muted,
      ),
    );
  }
}

class GroupMemberRow extends StatelessWidget {
  final String name;
  final String subtitle;
  final String initial;
  final Color color;
  final bool isYou;

  const GroupMemberRow({
    super.key,
    required this.name,
    required this.subtitle,
    required this.initial,
    required this.color,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Text(
              initial,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isYou ? '$name (you)' : name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            size: 18,
            color: Color(0xFF71872D),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.paleLime,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.ink),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      ),
    );
  }
}

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const plans = [
      PlanItem(
        time: '8:30 AM',
        title: 'Yarra Valley day tour',
        detail: 'Meet at Federation Square',
        icon: Icons.directions_bus,
      ),
      PlanItem(
        time: '12:30 PM',
        title: 'Lunch at Oakridge',
        detail: 'Table booked for 4',
        icon: Icons.restaurant,
      ),
      PlanItem(
        time: '4:00 PM',
        title: 'Chocolate & ice cream stop',
        detail: 'Yarra Valley Chocolaterie',
        icon: Icons.icecream,
      ),
      PlanItem(
        time: '7:30 PM',
        title: 'Dinner in Fitzroy',
        detail: 'Vote on restaurants in chat',
        icon: Icons.dinner_dining,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 32),
      children: [
        const Text(
          'SATURDAY • 19 OCTOBER',
          style: TextStyle(
            color: Color(0xFF62702B),
            fontSize: 11,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your day,\ntogether.',
          style: TextStyle(
            fontSize: 39,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 24),
        ...plans,
      ],
    );
  }
}

class PlanItem extends StatelessWidget {
  final String time;
  final String title;
  final String detail;
  final IconData icon;

  const PlanItem({
    super.key,
    required this.time,
    required this.title,
    required this.detail,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 62,
                child: Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF718328),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.paleLime,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: AppColors.ink, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 32),
      children: [
        const Text(
          'SHARED SPENDING',
          style: TextStyle(
            color: Color(0xFF62702B),
            fontSize: 11,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Keep it\nbalanced.',
          style: TextStyle(
            fontSize: 39,
            height: 1,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.paleLime,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRIP BUDGET',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppColors.muted,
                ),
              ),
              SizedBox(height: 10),
              Text(
                r'$1,240',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                ),
              ),
              Text(
                r'spent of $1,600 planned',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(99)),
                child: LinearProgressIndicator(
                  value: .775,
                  minHeight: 10,
                  backgroundColor: Color(0xFFEFF1E8),
                  valueColor: AlwaysStoppedAnimation(AppColors.ink),
                ),
              ),
              SizedBox(height: 10),
              Text(
                r'$360 remaining',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionLabel('RECENT EXPENSES'),
        const SizedBox(height: 12),
        const ExpenseItem(
          title: 'Apartment deposit',
          payer: 'Paid by Karan',
          amount: r'$680',
        ),
        const SizedBox(height: 10),
        const ExpenseItem(
          title: 'Yarra Valley tour',
          payer: 'Paid by Mia',
          amount: r'$420',
        ),
        const SizedBox(height: 10),
        const ExpenseItem(
          title: 'Airport transfer',
          payer: 'Paid by Alex',
          amount: r'$140',
        ),
      ],
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final String title;
  final String payer;
  final String amount;

  const ExpenseItem({
    super.key,
    required this.title,
    required this.payer,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F1E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_long, color: AppColors.ink),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(payer),
        trailing: Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 22, 20, 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'MELBOURNE WEEKEND • 4 MEMBERS',
              style: TextStyle(
                color: Color(0xFF62702B),
                fontSize: 11,
                letterSpacing: 1.05,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: const [
              ChatBubble(
                sender: 'Mia',
                message: 'I booked the Yarra Valley tour! 🍷',
                mine: false,
              ),
              ChatBubble(
                sender: 'You',
                message: 'Amazing — I added it to the itinerary.',
                mine: true,
              ),
              ChatBubble(
                sender: 'Alex',
                message: 'Should we choose dinner in Fitzroy?',
                mine: false,
              ),
              ChatBubble(
                sender: 'Sam',
                message: 'Yes! I vote for Italian.',
                mine: false,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              color: AppColors.paper,
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Message group',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool mine;

  const ChatBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.mine,
  });

  @override
  Widget build(BuildContext context) {
    final color = mine ? AppColors.ink : AppColors.paper;
    final textColor = mine ? Colors.white : AppColors.ink;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: mine ? null : Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: mine ? AppColors.lime : AppColors.muted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(color: textColor, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}