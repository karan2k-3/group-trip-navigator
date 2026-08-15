import 'package:flutter/material.dart';

void main() {
  runApp(const TripSyncApp());
}

class TripSyncApp extends StatelessWidget {
  const TripSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2557D6)),
        useMaterial3: true,
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
  final _pages = const [OverviewPage(), ItineraryPage(), BudgetPage(), ChatPage()];

  @override
  Widget build(BuildContext context) {
    final labels = ['TripSync', 'Itinerary', 'Budget', 'Chat'];
    return Scaffold(
      appBar: AppBar(
        title: Text(labels[_index]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Text('K'),
            ),
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Plan'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Budget'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
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
      padding: const EdgeInsets.all(20),
      children: [
        Text('Melbourne Weekend', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('18–20 October • 4 travellers', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF2557D6), Color(0xFF6C3FD1)]),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next up', style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 8),
                Text('Yarra Valley day tour', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Saturday, 8:30 AM', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Your group', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MemberChip(name: 'Karan', initial: 'K', color: Color(0xFF2557D6)),
            MemberChip(name: 'Mia', initial: 'M', color: Color(0xFFE05A47)),
            MemberChip(name: 'Alex', initial: 'A', color: Color(0xFF1D9A6C)),
            MemberChip(name: 'Sam', initial: 'S', color: Color(0xFFF0A43A)),
          ],
        ),
        const SizedBox(height: 24),
        Text('Quick actions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const ListTile(leading: Icon(Icons.add_location_alt_outlined), title: Text('Add a place'), subtitle: Text('Save a café, attraction, or hotel')),
        const ListTile(leading: Icon(Icons.person_add_alt_1_outlined), title: Text('Invite traveller'), subtitle: Text('Share your trip link with friends')),
      ],
    );
  }
}

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Saturday, 19 October', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const PlanItem(time: '8:30 AM', title: 'Yarra Valley day tour', detail: 'Meet at Federation Square', icon: Icons.directions_bus),
        const PlanItem(time: '12:30 PM', title: 'Lunch at Oakridge', detail: 'Table booked for 4', icon: Icons.restaurant),
        const PlanItem(time: '4:00 PM', title: 'Chocolate & ice cream stop', detail: 'Yarra Valley Chocolaterie', icon: Icons.icecream),
        const PlanItem(time: '7:30 PM', title: 'Dinner in Fitzroy', detail: 'Vote on restaurants in chat', icon: Icons.dinner_dining),
      ],
    );
  }
}

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trip budget', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(r'$1,240 spent of $1,600', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                const LinearProgressIndicator(value: .775),
                const SizedBox(height: 8),
                const Text(r'$360 remaining'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Recent expenses', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const ExpenseItem(title: 'Apartment deposit', payer: 'Paid by Karan', amount: r'$680'),
        const ExpenseItem(title: 'Yarra Valley tour', payer: 'Paid by Mia', amount: r'$420'),
        const ExpenseItem(title: 'Airport transfer', payer: 'Paid by Alex', amount: r'$140'),
      ],
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              ChatBubble(sender: 'Mia', message: 'I booked the Yarra Valley tour! 🍷', mine: false),
              ChatBubble(sender: 'You', message: 'Amazing — I added it to the itinerary.', mine: true),
              ChatBubble(sender: 'Alex', message: 'Should we choose dinner in Fitzroy?', mine: false),
              ChatBubble(sender: 'Sam', message: 'Yes! I vote for Italian.', mine: false),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Message group', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: () {}, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MemberChip extends StatelessWidget {
  final String name;
  final String initial;
  final Color color;
  const MemberChip({super.key, required this.name, required this.initial, required this.color});
  @override
  Widget build(BuildContext context) {
    return Chip(avatar: CircleAvatar(backgroundColor: color, child: Text(initial, style: const TextStyle(color: Colors.white))), label: Text(name));
  }
}

class PlanItem extends StatelessWidget {
  final String time;
  final String title;
  final String detail;
  final IconData icon;
  const PlanItem({super.key, required this.time, required this.title, required this.detail, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(leading: CircleAvatar(child: Icon(icon)), title: Text(title), subtitle: Text('$time • $detail')));
  }
}

class ExpenseItem extends StatelessWidget {
  final String title;
  final String payer;
  final String amount;
  const ExpenseItem({super.key, required this.title, required this.payer, required this.amount});
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.receipt_long)), title: Text(title), subtitle: Text(payer), trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold))));
  }
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool mine;
  const ChatBubble({super.key, required this.sender, required this.message, required this.mine});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(color: mine ? const Color(0xFF2557D6) : const Color(0xFFE9ECF3), borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(sender, style: TextStyle(fontWeight: FontWeight.bold, color: mine ? Colors.white70 : Colors.black54)), const SizedBox(height: 4), Text(message, style: TextStyle(color: mine ? Colors.white : Colors.black87))]),
      ),
    );
  }
}
