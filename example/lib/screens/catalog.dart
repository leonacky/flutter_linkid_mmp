import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';
import 'package:flutter_linkid_mmp/ad_media/widgets/ad_retail_media_widget.dart';
import 'package:flutter_linkid_mmp_example/common/tracking_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/catalog.dart';

class MyCatalog extends StatelessWidget {
  MyCatalog({super.key}) {
    TrackingHelper.setCurrentScreen(screenName: "MainScreen");
    TrackingHelper.createDeepLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          SliverList.list(
            children: const [
              Text('  Ad Banner'),
              AdRetailMediaWidget(
                adId: '93cc89ad-f1d9-4674-a8e1-6df6f55805a7',
                adType: AdType.banner,
              ),
              Text('  Ad Product'),
              AdRetailMediaWidget(
                adId: '00dd59d2-5fae-4b8a-999b-f65da21c438a',
                adType: AdType.product,
                placeholder: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MyListItem(index),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.
    var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.items.contains(item),
    );

    return TextButton(
      onPressed: isInCart
          ? null
          : () {
              // If the item is not in cart, we let the user add it.
              // We are using context.read() here because the callback
              // is executed whenever the user taps the button. In other
              // words, it is executed outside the build method.
              TrackingHelper.logEvent(event: "AddCart");
              var cart = context.read<CartModel>();
              cart.add(item);
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInCart ? const Icon(Icons.check, semanticLabel: 'Đã thêm') : const Text('Thêm'),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Danh mục', style: Theme.of(context).textTheme.displayLarge),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.chat_bubble),
          onPressed: () {
            TrackingHelper.logEvent(event: "OpenChat");
            context.go('/catalog/chat');
          },
        ),
        IconButton(
          icon: const Icon(Icons.email),
          onPressed: () {
            TrackingHelper.logEvent(event: "OpenContact");
            context.go('/catalog/contact');
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            TrackingHelper.logEvent(event: "OpenCart");
            context.go('/catalog/cart');
          },
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      // Here, we are only interested in the item at [index]. We don't care
      // about any other change.
      (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: item.color,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            const SizedBox(width: 24),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}
