import 'package:flutter/material.dart';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  const ShoeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REXX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 43, 1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 3, 36, 11),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 103, 150, 122),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class Shoe {
  final String brand;
  final String model;
  final String type;
  final String color;
  final int size;
  final String gender;
  final double price;
  final String imageUrl;

  Shoe({
    required this.brand,
    required this.model,
    required this.type,
    required this.color,
    required this.size,
    required this.gender,
    required this.price,
    required this.imageUrl,
  });

  String get name => '$brand $model';
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Shoe> allShoes = [];
  final Set<String> selectedBrands = {};
  final Set<String> selectedTypes = {};
  final Set<String> selectedColors = {};
  final Set<int> selectedSizes = {};
  final Set<String> selectedGenders = {};
  RangeValues priceRange = const RangeValues(50, 500);

  int cartCount = 0;
  bool showFavorites = false;
  List<Shoe> favoriteShoes = [];

  final List<String> brands = [
    'Nike',
    'Adidas',
    'New Balance',
    'Puma',
    'Reebok',
    'Vans',
    'Converse',
    'Asics',
    'Under Armour',
  ];
  final List<String> types = ['Sneaker', 'Basketbol', 'Koşu', 'Krampon', 'Tenis', 'Bot'];
  final List<String> colors = ['Siyah', 'Beyaz', 'Gri', 'Mavi', 'Kırmızı', 'Yeşil'];
  final List<String> genders = ['Erkek', 'Kadın', 'Unisex'];

  final Map<String, List<String>> models = {
    'Nike': ['Air Jordan 1', 'Air Max 90', 'Air Force 1', 'Pegasus 38'],
    'Adidas': ['Ultraboost', 'NMD R1', 'Superstar'],
    'New Balance': ['327', '574', '990v5'],
    'Puma': ['Suede Classic', 'RS-X'],
    'Reebok': ['Club C 85', 'Classic Leather'],
    'Vans': ['Old Skool', 'Authentic'],
    'Converse': ['Chuck Taylor'],
    'Asics': ['Gel-Lyte III'],
    'Under Armour': ['HOVR Phantom'],
  };

  @override
  void initState() {
    super.initState();
    generateShoes(40);
  }

  void generateShoes(int count) {
    final random = Random();
    for (int i = 0; i < count; i++) {
      final brand = brands[random.nextInt(brands.length)];
      final modelList = models[brand]!;
      final model = modelList[random.nextInt(modelList.length)];
      final type = types[random.nextInt(types.length)];
      final color = colors[random.nextInt(colors.length)];
      final gender = genders[random.nextInt(genders.length)];
      final size = 38 + random.nextInt(9);
      final price = 50 + random.nextInt(450);
      final query = "$brand+$model+$type+$color+$gender".replaceAll(' ', '+');

      allShoes.add(Shoe(
        brand: brand,
        model: model,
        type: type,
        color: color,
        gender: gender,
        size: size,
        price: price.toDouble(),
        imageUrl: 'https://source.unsplash.com/400x300/?$query&sig=$i',
      ));
    }
  }

  List<Shoe> get filteredShoes {
    return allShoes.where((shoe) {
      final matchesBrand = selectedBrands.isEmpty || selectedBrands.contains(shoe.brand);
      final matchesType = selectedTypes.isEmpty || selectedTypes.contains(shoe.type);
      final matchesColor = selectedColors.isEmpty || selectedColors.contains(shoe.color);
      final matchesSize = selectedSizes.isEmpty || selectedSizes.contains(shoe.size);
      final matchesGender = selectedGenders.isEmpty || selectedGenders.contains(shoe.gender);
      final matchesPrice = shoe.price >= priceRange.start && shoe.price <= priceRange.end;
      return matchesBrand && matchesType && matchesColor && matchesSize && matchesGender && matchesPrice;
    }).toList();
  }

  void toggle<T>(T value, Set<T> set) {
    if (set.contains(value)) {
      set.remove(value);
    } else {
      set.add(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/rexx_logo.png', height: 90),
            const SizedBox(width: 15),
            const Text('REXX', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(width: 40),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final label in ['Erkek', 'Kadın', 'Çocuk', 'En Çok Satanlar', 'İndirim'])
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        label,
                        style: TextStyle(
                          color: label == 'İndirim' ? Colors.red : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white),
                const SizedBox(width: 5),
                Text('$cartCount',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 15),
                MouseRegion(
                  onEnter: (_) => setState(() => showFavorites = true),
                  onExit: (_) => setState(() => showFavorites = false),
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 230,
                padding: const EdgeInsets.all(12),
                color: const Color.fromARGB(255, 103, 150, 122),
                child: FilterPanel(
                  brands: brands,
                  types: types,
                  colors: colors,
                  sizes: List.generate(9, (index) => 38 + index),
                  genders: genders,
                  selectedBrands: selectedBrands,
                  selectedTypes: selectedTypes,
                  selectedColors: selectedColors,
                  selectedSizes: selectedSizes,
                  selectedGenders: selectedGenders,
                  priceRange: priceRange,
                  onBrandChange: (v) => setState(() => toggle(v, selectedBrands)),
                  onTypeChange: (v) => setState(() => toggle(v, selectedTypes)),
                  onColorChange: (v) => setState(() => toggle(v, selectedColors)),
                  onSizeChange: (v) => setState(() => toggle(v, selectedSizes)),
                  onGenderChange: (v) => setState(() => toggle(v, selectedGenders)),
                  onPriceChange: (v) => setState(() => priceRange = v),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                  children: filteredShoes.map((shoe) {
                    return ShoeCard(
                      shoe: shoe,
                      onAddToCart: () => setState(() => cartCount++),
                      onAddFavorite: () => setState(() {
                        if (!favoriteShoes.contains(shoe)) favoriteShoes.add(shoe);
                      }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (showFavorites)
            Positioned(
              top: 100,
              right: 30,
              child: MouseRegion(
                onExit: (_) => setState(() => showFavorites = false),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: favoriteShoes.isEmpty
                      ? const Text('Henüz favori yok!')
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: favoriteShoes
                              .map((shoe) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(shoe.name), 
                                  ))
                              .toList(),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// FilterPanel & ShoeCard aynen kalsın!

class FilterPanel extends StatelessWidget {
  final List<String> brands;
  final List<String> types;
  final List<String> colors;
  final List<int> sizes;
  final List<String> genders;
  final Set<String> selectedBrands;
  final Set<String> selectedTypes;
  final Set<String> selectedColors;
  final Set<int> selectedSizes;
  final Set<String> selectedGenders;
  final RangeValues priceRange;
  final Function(String) onBrandChange;
  final Function(String) onTypeChange;
  final Function(String) onColorChange;
  final Function(int) onSizeChange;
  final Function(String) onGenderChange;
  final ValueChanged<RangeValues> onPriceChange;

  const FilterPanel({
    super.key,
    required this.brands,
    required this.types,
    required this.colors,
    required this.sizes,
    required this.genders,
    required this.selectedBrands,
    required this.selectedTypes,
    required this.selectedColors,
    required this.selectedSizes,
    required this.selectedGenders,
    required this.priceRange,
    required this.onBrandChange,
    required this.onTypeChange,
    required this.onColorChange,
    required this.onSizeChange,
    required this.onGenderChange,
    required this.onPriceChange,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtreler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Marka'),
          Wrap(
            spacing: 8,
            children: brands.map((b) => FilterChip(
              label: Text(b),
              selected: selectedBrands.contains(b),
              onSelected: (_) => onBrandChange(b),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Tür'),
          Wrap(
            spacing: 8,
            children: types.map((t) => FilterChip(
              label: Text(t),
              selected: selectedTypes.contains(t),
              onSelected: (_) => onTypeChange(t),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Renk'),
          Wrap(
            spacing: 8,
            children: colors.map((c) => FilterChip(
              label: Text(c),
              selected: selectedColors.contains(c),
              onSelected: (_) => onColorChange(c),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Beden'),
          Wrap(
            spacing: 8,
            children: sizes.map((s) => FilterChip(
              label: Text('$s'),
              selected: selectedSizes.contains(s),
              onSelected: (_) => onSizeChange(s),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Cinsiyet'),
          Wrap(
            spacing: 8,
            children: genders.map((g) => FilterChip(
              label: Text(g),
              selected: selectedGenders.contains(g),
              onSelected: (_) => onGenderChange(g),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Fiyat Aralığı'),
          RangeSlider(
            values: priceRange,
            min: 50,
            max: 500,
            divisions: 45,
            labels: RangeLabels(
              '\$${priceRange.start.round()}',
              '\$${priceRange.end.round()}',
            ),
            onChanged: onPriceChange,
          ),
        ],
      ),
    );
  }
}

class ShoeCard extends StatelessWidget {
  final Shoe shoe;
  final VoidCallback onAddToCart;
  final VoidCallback onAddFavorite; // ✅

  const ShoeCard({
    super.key,
    required this.shoe,
    required this.onAddToCart,
    required this.onAddFavorite, // ✅
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            shoe.imageUrl,
            height: 80,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shoe.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${shoe.type} | ${shoe.color} | ${shoe.gender}'),
                Text('\$${shoe.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onAddToCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${shoe.name} sepete eklendi!')),
                          );
                        },
                        child: const Text('Sepete Ekle'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                        onPressed: () {
                          onAddFavorite(); // ✅ parametreyi kullan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${shoe.name} favorilere eklendi!')),
                          );
                        },
                        child: const Text('Favorilere Ekle'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

