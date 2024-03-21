import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_user/bloc/cart/cart_bloc.dart' as cart_bloc;
import 'package:store_user/presentation/utils/extensions.dart';
import 'package:store_user/presentation/utils/helpers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:store_user/bloc/product/product_bloc.dart';
import 'package:store_user/data/models/order_product.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/repositories/product_repository.dart';
import 'package:store_user/presentation/utils/app_colors.dart';
import 'package:store_user/presentation/utils/assets.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  @override
  void initState() {
    super.initState();
    context.read<cart_bloc.CartBloc>().add(const cart_bloc.FetchCart());
  }

  final carouselController = CarouselController();
  int activeBannerIndex = 0;
  Color randomColor = generateRandomColor().darken();
  num quantity = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<cart_bloc.CartBloc, cart_bloc.CartState>(listener: (context,state){
      if (state is cart_bloc.CartLoaded){
        final currentProductIndex = state.cartProducts.indexWhere((element) => element.product == widget.product);
        OrderProduct? orderProduct = currentProductIndex > -1 ?state.cartProducts[currentProductIndex] : null;
        setState(() {
         quantity = orderProduct != null ? orderProduct.quantity : 0;
        });
      }
    },
    child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.product.images == null || widget.product.images!.isEmpty
                ? Stack(
                    children: [
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: randomColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.inventory,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      
                    ],
                  )
                : Stack(
                    children: [
                      CarouselSlider(
                        carouselController: carouselController,
                        items: widget.product.images!
                            .map(
                              (e) => Image.network(
                                e,
                                fit: BoxFit.cover,
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeBannerIndex = index;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                     
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AnimatedSmoothIndicator(
                            onDotClicked: (index) {
                              carouselController.animateToPage(index);
                            },
                            activeIndex: activeBannerIndex,
                            count: 3,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 5,
                              dotWidth: 8,
                              dotColor: Colors.grey,
                              activeDotColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          return IconButton(
                            onPressed: () {
                              context.read<ProductBloc>().add(
                                    UpdateFavorite(
                                      product: widget.product,
                                      isFavorite: !ProductRepository.isFavorite(
                                        widget.product,
                                      ),
                                    ),
                                  );
                            },
                            iconSize: 30,
                            icon: ProductRepository.isFavorite(widget.product)
                                ? const Icon(
                                    Icons.favorite,
                                    color: AppColors.primary,
                                  )
                                : SvgPicture.asset(SvgAssets.favorite),
                          );
                        },
                      ),
                    ],
                  ),
                  // unit kg, g, ml, l
                  Text(
                    '1 ${widget.product.unit.name}',
                    style: const TextStyle(
                      height: 0.5,
                      fontSize: 16,
                      color: AppColors.lightGray,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              OrderProduct orderProduct = OrderProduct(
                                product: widget.product,
                                quantity: 0
                              );

                              context.read<cart_bloc.CartBloc>().add(
                                    cart_bloc.UpdateCart(
                                      orderProduct: orderProduct,
                                      quantity: quantity - 1,
                                    ),
                                  );
                            },
                            iconSize: 30,
                            icon: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(
                                color: AppColors.lightBorderGray,
                              ),
                            ),
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            // child: BlocBuilder<cart_bloc.CartBloc, cart_bloc.CartState>(
                            //   builder: (context, state) {
                            //     if (state is cart_bloc.CartLoaded){
                            //       OrderProduct orderProduct = state.cartProducts.where(
                            //         (element) => element.product == widget.product).first;
                            //       return Text(orderProduct.quantity.toString(),
                            //       style: const TextStyle(fontSize: 18),);
                            //     } else {
                            //       return const Text(
                            //        '-1' ,
                            //       // ProductRepository.getQuantity(widget.product)
                            //       //     .toString(),
                            //       style: TextStyle(
                            //         fontSize: 18,
                            //       ),
                            //     );
                            //     }
                            //   },
                            // ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              OrderProduct orderProduct = OrderProduct(
                                product: widget.product,
                                quantity: 0
                                
                              );

                              context.read<cart_bloc.CartBloc>().add(
                                    cart_bloc.UpdateCart(
                                      orderProduct: orderProduct,
                                      quantity: quantity + 1,
                                    ),
                                  );
                            },
                            iconSize: 30,
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    title: const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    expandedAlignment:
                        Alignment.centerLeft, // default is centerRight
                    expandedCrossAxisAlignment:
                        CrossAxisAlignment.start, // default is center
                    children: List.generate(
                      1,
                      (index) => Text(
                        widget.product.description ?? "No description",
                      ),
                    ),
                  ),
                  const Divider(),
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    title: const Text(
                      'Nutrition',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    expandedAlignment:
                        Alignment.centerLeft, // default is centerRight
                    expandedCrossAxisAlignment:
                        CrossAxisAlignment.start, // default is center
                    children: widget.product.nutritions!.entries
                        .map(
                          (e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.key.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${e.value.toStringAsFixed(2)}g',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(),
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    title: const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    expandedAlignment:
                        Alignment.centerLeft, // default is centerRight
                    expandedCrossAxisAlignment:
                        CrossAxisAlignment.start, // default is center
                    children: List.generate(
                      3,
                      (index) => Text(
                        'Review $index',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
