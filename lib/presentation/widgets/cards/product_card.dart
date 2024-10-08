import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_user/bloc/product/product_bloc.dart';
import 'package:store_user/data/models/order_product.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/repositories/product_repository.dart';
import 'package:store_user/presentation/utils/app_colors.dart';
import 'package:store_user/presentation/utils/app_router.dart';
import 'package:store_user/presentation/widgets/buttons/round_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.productDetailsRoute,
          arguments: product,
        );
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
          bottom: 15,
        ),
        width: 170,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.lightBorderGray,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image or icon
            if (product.images != null && product.images!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: product.images!.first,
                height: 100,
                fit: BoxFit.cover,
              )
            else
              const Icon(
                Icons.inventory,
                size: 100,
                color: AppColors.primary,
              ),
            const SizedBox(height: 20),
            // title
            Text(
              product.name,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // unit
            Text(
              "1 ${product.unit.name}",
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // add to cart
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
