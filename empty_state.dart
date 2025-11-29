import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projects App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProjectsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});
  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: ProjectSearchDelegate()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'To do'),
            Tab(text: 'In progress'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('To do projects')),
          Center(child: Text('In progress projects')),
          EmptyState(
            title: 'Nothing here. For now.',
            subtitle: 'This is where you\'ll find your finished projects.',
            buttonText: 'Start a project',
            onButtonPressed: _startProject,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  static void _startProject() => debugPrint("Start project clicked");
}


enum SortOrder { none, lowToHigh, highToLow }

class ProjectSearchDelegate extends SearchDelegate {
  SortOrder _sortOrder = SortOrder.none;
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 100;


  final List<Map<String, dynamic>> products = [
    {'name': 'Amazing Shoes',    'price': '€12.00', 'category': 'Shoes'},
    {'name': 'Fabulous Shoes',   'price': '€15.00', 'category': 'Shoes'},
    {'name': 'Fantastic Shoes',  'price': '€15.00', 'category': 'Shoes'},
    {'name': 'Spectacular Shoes','price': '€12.00', 'category': 'Shoes'},
    {'name': 'Stunning Shoes',   'price': '€12.00', 'category': 'Shoes'},
    {'name': 'Wonderful Shoes',  'price': '€15.00', 'category': 'Shoes'},
  ];

  double _parsePrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[€\s]'), '')) ?? 0.0;
  }

  void _showFilterDialog(BuildContext context) {
    String tempCategory = _selectedCategory;
    double tempMin = _minPrice;
    double tempMax = _maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['All', 'Shoes', 'Boots', 'Sneakers'].map((cat) {
                    return FilterChip(
                      label: Text(cat),
                      selected: tempCategory == cat,
                      onSelected: (_) => setStateDialog(() => tempCategory = cat),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Price Range', style: TextStyle(fontWeight: FontWeight.w600)),
                RangeSlider(
                  values: RangeValues(tempMin, tempMax),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  labels: RangeLabels('€${tempMin.toInt()}', '€${tempMax.toInt()}'),
                  onChanged: (v) => setStateDialog(() {
                    tempMin = v.start;
                    tempMax = v.end;
                  }),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          tempCategory = 'All';
                          tempMin = 0;
                          tempMax = 100;
                          setStateDialog(() {});
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _selectedCategory = tempCategory;
                          _minPrice = tempMin;
                          _maxPrice = tempMax;
                          Navigator.pop(context);
                          showResults(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _headerBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Text('Sort by', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                PopupMenuButton<SortOrder>(
                  onSelected: (value) {
                    _sortOrder = value;
                    showResults(context);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: SortOrder.lowToHigh, child: Text('Low to High')),
                    PopupMenuItem(value: SortOrder.highToLow, child: Text('High to Low')),
                    PopupMenuItem(value: SortOrder.none, child: Text('Clear Sort')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _sortOrder != SortOrder.none
                          ? Theme.of(context).colorScheme.primary.withAlpha(30)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _sortOrder != SortOrder.none
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _sortOrder == SortOrder.lowToHigh
                              ? Icons.trending_up
                              : _sortOrder == SortOrder.highToLow
                              ? Icons.trending_down
                              : Icons.sort,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _sortOrder == SortOrder.lowToHigh
                              ? 'Low to High'
                              : _sortOrder == SortOrder.highToLow
                              ? 'High to Low'
                              : 'None',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showFilterDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  const Text('Filter', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    var results = products.where((p) {
      final nameMatch = p['name'].toString().toLowerCase().contains(query.toLowerCase());
      final price = _parsePrice(p['price']);
      final priceMatch = price >= _minPrice && price <= _maxPrice;
      final catMatch = _selectedCategory == 'All' || p['category'] == _selectedCategory;
      return nameMatch && priceMatch && catMatch;
    }).toList();

    if (_sortOrder == SortOrder.lowToHigh) {
      results.sort((a, b) => _parsePrice(a['price']).compareTo(_parsePrice(b['price'])));
    } else if (_sortOrder == SortOrder.highToLow) {
      results.sort((a, b) => _parsePrice(b['price']).compareTo(_parsePrice(a['price'])));
    }

    return Column(
      children: [
        _headerBar(context),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('No products found'))
              : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: results.length,
            itemBuilder: (context, i) {
              final item = results[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset('assets/images/data.png', height: 110, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(item['price'], style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(item['category'], style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: [
        _headerBar(context),
        const Expanded(child: Center(child: Text('Search for products...'))),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title, subtitle, buttonText;
  final VoidCallback onButtonPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/data.png', height: 140),
            const SizedBox(height: 32),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}