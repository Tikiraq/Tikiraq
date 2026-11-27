import 'package:flutter/material.dart';

void main() => runApp(const TookIraqApp());

const green = Color(0xFF159447);
const dark = Color(0xFF101510);
const panel = Color(0xFF1D2A20);
const red = Color(0xFFD71920);

class TookIraqApp extends StatelessWidget {
  const TookIraqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'توك عراق',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green, brightness: Brightness.dark,
          primary: green, surface: panel,
        ),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Product {
  final String title, price, seller, category;
  final IconData icon;
  const Product(this.title, this.price, this.seller, this.category, this.icon);
}

const products = [
  Product('سماعة لاسلكية', '18,000 د.ع', 'متجر النخبة', 'إلكترونيات', Icons.headphones),
  Product('ساعة ذكية', '32,000 د.ع', 'عالم التقنية', 'إلكترونيات', Icons.watch),
  Product('حقيبة نسائية', '22,000 د.ع', 'لمسة أناقة', 'ملابس', Icons.shopping_bag),
  Product('عطر يومي', '15,000 د.ع', 'ركن الجمال', 'كوزمتك', Icons.spa),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  String category = 'الكل';

  @override
  Widget build(BuildContext context) {
    final filtered = category == 'الكل'
        ? products
        : products.where((p) => p.category == category).toList();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: dark,
          title: const Text('توك عراق', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
          titleTextStyle: const TextStyle(color: Colors.white),
          actions: [
            IconButton(onPressed: () => _message('البحث سيُفعّل عند ربط قاعدة البيانات'), icon: const Icon(Icons.search)),
            IconButton(onPressed: () => _message('الإشعارات ستظهر هنا'), icon: const Icon(Icons.notifications_none)),
          ],
        ),
        body: IndexedStack(index: tab, children: [
          _home(filtered),
          _market(),
          _live(),
          _profile(),
        ]),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF18221A),
          indicatorColor: green.withOpacity(.22),
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.store), label: 'السوق'),
            NavigationDestination(icon: Icon(Icons.sensors), selectedIcon: Icon(Icons.sensors), label: 'لايف'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: red, foregroundColor: Colors.white,
          onPressed: () => _message('فتح البث المباشر يحتاج ربط خدمة بث وخادم'),
          icon: const Icon(Icons.wifi_tethering),
          label: const Text('ابدأ لايف'),
        ),
      ),
    );
  }

  Widget _home(List<Product> list) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [Color(0xFF176B35), Color(0xFF102317)]),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('أهلاً بك في توك عراق 🇮🇶', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          SizedBox(height: 7),
          Text('اكتشف المنتجات وتابع البثوث المباشرة'),
          SizedBox(height: 14),
          Row(children: [
            Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text('تسوّق وشاهد البث بمكان واحد', style: TextStyle(fontWeight: FontWeight.w600)),
          ]),
        ]),
      ),
      const SizedBox(height: 18),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('البث المباشر', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () => setState(() => tab = 2), child: const Text('عرض الكل')),
      ]),
      SizedBox(height: 105, child: ListView(scrollDirection: Axis.horizontal, children: [
        _liveTile('متجر النخبة'), _liveTile('عالم التقنية'), _liveTile('ركن الجمال'),
      ])),
      const SizedBox(height: 14),
      const Text('تصفح الأقسام', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: ['الكل','إلكترونيات','ملابس','كوزمتك'].map((c) =>
        ChoiceChip(label: Text(c), selected: category == c,
          selectedColor: green, onSelected: (_) => setState(() => category = c))).toList()),
      const SizedBox(height: 18),
      const Text('منتجات جديدة', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      ...list.map(_productCard),
    ],
  );

  Widget _liveTile(String name) => Container(
    width: 145, margin: const EdgeInsets.only(left: 10), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: red.withOpacity(.7))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      const Row(children: [Icon(Icons.circle, color: red, size: 9), SizedBox(width: 5), Text('مباشر', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))]),
      const SizedBox(height: 8), Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );

  Widget _productCard(Product p) => Card(
    color: panel, margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: CircleAvatar(backgroundColor: green.withOpacity(.2), child: Icon(p.icon, color: Colors.white)),
      title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${p.seller} • ${p.category}'),
      trailing: Text(p.price, style: const TextStyle(color: Color(0xFF65D68C), fontWeight: FontWeight.bold)),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: p))),
    ),
  );

  Widget _market() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('السوق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('تصفح منتجات البائعين حسب القسم.'),
    const SizedBox(height: 12),
    ...products.map(_productCard),
  ]);

  Widget _live() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.sensors, size: 70, color: red),
      const SizedBox(height: 12),
      const Text('البث المباشر', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('واجهة البث جاهزة مبدئياً. تشغيل بث حقيقي يحتاج ربط خادم بث وحسابات المستخدمين.', textAlign: TextAlign.center),
      const SizedBox(height: 16),
      FilledButton.icon(onPressed: () => _message('ميزة البث قيد الربط'), icon: const Icon(Icons.add), label: const Text('ابدأ البث')),
    ]),
  ));

  Widget _profile() => ListView(padding: const EdgeInsets.all(18), children: [
    const CircleAvatar(radius: 42, backgroundColor: green, child: Icon(Icons.person, size: 48, color: Colors.white)),
    const SizedBox(height: 12),
    const Center(child: Text('حسابي', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
    const SizedBox(height: 18),
    FilledButton.icon(onPressed: () => _message('إنشاء الحساب وربطه بالخادم خطوة لاحقة'), icon: const Icon(Icons.login), label: const Text('تسجيل الدخول / إنشاء حساب')),
    const SizedBox(height: 10),
    OutlinedButton.icon(onPressed: () => _message('إضافة المنتجات ستعمل بعد ربط قاعدة البيانات'), icon: const Icon(Icons.add_box_outlined), label: const Text('أضف منتجك')),
    const ListTile(leading: Icon(Icons.star_outline), title: Text('تقييماتي')),
    const ListTile(leading: Icon(Icons.chat_outlined), title: Text('رقم واتساب البائع')),
  ]);

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class ProductScreen extends StatelessWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: Container(
          decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22)),
          child: Icon(product.icon, size: 100, color: Colors.white70),
        )),
        const SizedBox(height: 20),
        Text(product.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(product.price, style: const TextStyle(color: Color(0xFF65D68C), fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('البائع: ${product.seller}'),
        const SizedBox(height: 20),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: green, padding: const EdgeInsets.all(15)),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم تفعيل واتساب البائع بعد إضافة رقمه وربط النظام.'))),
          icon: const Icon(Icons.chat),
          label: const Text('تواصل عبر واتساب'),
        ),
      ])),
    ),
  );
}
