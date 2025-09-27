import 'package:app_store/consts/colors_manger.dart';
import 'package:app_store/screens/categories_screen.dart';
import 'package:app_store/screens/products_screen.dart';
import 'package:app_store/screens/users_screen.dart' show UsersScreen;
import 'package:app_store/widgets/appbar_icons.dart' show AppbarIcons;
import 'package:app_store/widgets/card_widget.dart';
import 'package:app_store/widgets/sale_widget.dart';
import 'package:app_store/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:app_store/providers/products_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _saleWidgets = const [
    SaleWidget(),
    SaleWidget(),
    SaleWidget(),
  ];

  final CardSwiperController _swiperController = CardSwiperController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductsProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsManager.scaffoldBackground,
        title: const Text('Home Screen'),
        leading: AppbarIcons(
          function: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const CategoriesScreen(),
              ),
            );
          },
          icon: IconlyBold.category,
          backgroundColor: ColorsManager.primary,
        ),
        actions: [
          AppbarIcons(
            function: () {
              Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const UsersScreen(),
              ),
            );
            },
            icon: IconlyBold.user3,
            backgroundColor: ColorsManager.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Textfield(),
            const SizedBox(height: 10),

            // ✅ CardSwiper
            SizedBox(
              height: 280,
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: _saleWidgets.length,
                onSwipe: (prev, next, direction) {
                  if (next != null) setState(() => _current = next);
                  return true;
                },
                cardBuilder: (context, index, percentX, percentY) {
                  return _saleWidgets[index];
                },
              ),
            ),
            const SizedBox(height: 8),

            // ✅ المؤشر
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_saleWidgets.length, (i) {
                final isActive = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isActive ? 20 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorsManager.primary
                        : ColorsManager.lightPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),

            // ✅ All Products header
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "All Products",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.darkPrimary,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppbarIcons(
                    function: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const ProductsScreen(),
                        ),
                      );
                    },
                    icon: IconlyBold.filter,
                    backgroundColor: ColorsManager.lightPrimary,
                  ),
                ),
              ],
            ),

            // ✅ Products section
            Builder(
              builder: (context) {
                if (prov.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (prov.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('خطأ: ${prov.error}'),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: prov.fetchAll,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }
                if (prov.items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('لا توجد منتجات')),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prov.items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) =>
                      CardWidget(product: prov.items[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
