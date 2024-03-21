import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_user/bloc/cart/cart_bloc.dart';
import 'package:store_user/bloc/create_order/create_order_bloc.dart';
import 'package:store_user/data/models/order.dart';
import 'package:store_user/data/models/order_product.dart';
import 'package:store_user/data/repositories/product_repository.dart';
import 'package:store_user/presentation/utils/app_colors.dart';
import 'package:store_user/presentation/widgets/buttons/default_button.dart';
import 'package:store_user/presentation/widgets/buttons/round_button.dart';
import 'package:uuid/uuid.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderBloc, CreateOrderState>(
      listener: (ctx, state) {
        if (state is CreateOrderLoaded){
          CherryToast.success(
            title: const Text('Checkout success', style: TextStyle(color: Colors.black),),
            toastDuration: const Duration(milliseconds: 2600),
            toastPosition: Position.bottom,
          ).show(ctx);
          ctx.read<CartBloc>().add(const FetchCart());
        }
      },
      child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
              child:
                  Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator())));
        } else if (state is CartLoaded) {
          double totalPrice = 0;
          for (var orderProduct in state.cartProducts) {
            totalPrice += orderProduct.quantity * orderProduct.product.price;
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
                'My Cart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 30,
              ),
              child: DefaultButton(
                text: 'Checkout',
                backgroundColor: state.cartProducts.isEmpty ? AppColors.lightGray : AppColors.primary,
                onTap: () {
                  if (state.cartProducts.isNotEmpty){
                  final Order myOrder = Order(
                      id: const Uuid().v4(),
                      total: totalPrice,
                      products: state.cartProducts,
                      createdAt: DateTime.now());
                  context
                      .read<CreateOrderBloc>()
                      .add(CreateOrder(order: myOrder));
                  } else {
                    CherryToast.error(
                        title: const Text('Please add product to cart', style: TextStyle(color: Colors.black),),
                        toastDuration: const Duration(milliseconds: 2600),
                        toastPosition: Position.bottom,
                      ).show(context);
                  }
                },
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  color:  AppColors.primaryDark,
                  child: Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(
                    color: AppColors.lightBorderGray,
                  ),
                  if (state.cartProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: AppColors.lightGray,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Looks like you haven\'t added\nanything to your cart yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.lightGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.cartProducts.length,
                    itemBuilder: (context, index) {
                      return CartItem(
                        orderProduct: state.cartProducts[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
              child: Text('Error....', style: TextStyle(color: Colors.black)));
        }
      }),
    );
  }
}

class CartItem extends StatelessWidget {
  final OrderProduct orderProduct;

  const CartItem({super.key, required this.orderProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          if (orderProduct.product.images == null ||
              orderProduct.product.images!.isEmpty)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.inventory,
                size: 40,
                color: AppColors.primary,
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    orderProduct.product.images!.first,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Text(
                  orderProduct.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // unit
                Text(
                  '1 ${orderProduct.product.unit.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightGray,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RoundButton(
                      icon: Icons.remove,
                      onTap: () {
                        // remove 1 item from cart
                        context.read<CartBloc>().add(
                              UpdateCart(
                                orderProduct: orderProduct,
                                quantity: orderProduct.quantity - 1,
                              ),
                            );
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: AppColors.gray,
                      borderColor: AppColors.darkBorderGray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${orderProduct.quantity} ${orderProduct.product.unit.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    RoundButton(
                      icon: Icons.add,
                      onTap: () {
                        // add 1 item to cart
                        context.read<CartBloc>().add(
                              UpdateCart(
                                orderProduct: orderProduct,
                                quantity: orderProduct.quantity + 1,
                              ),
                            );
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: AppColors.primary,
                      borderColor: AppColors.darkBorderGray,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // close icon button
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Close',
                  onPressed: () {
                    // remove item from cart
                    context.read<CartBloc>().add(
                          UpdateCart(
                            orderProduct: orderProduct,
                            quantity: 0,
                          ),
                        );
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.lightGray,
                  ),
                ),
                // price
                Text(
                  '\$${(orderProduct.product.price * orderProduct.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
