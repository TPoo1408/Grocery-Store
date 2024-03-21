import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_user/bloc/orders/orders_bloc.dart';
import 'package:store_user/data/models/order.dart';

// TODO: Implement OrdersPage

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    context.read<OrdersBloc>().add(FetchOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading){
          return const Scaffold(backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is OrdersLoaded){
          return Scaffold(
          appBar: AppBar(
            title: const Text('Orders'),
          ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: state.myOrdersData.length,
            itemBuilder: (context,index){
              return OrderItem(order: state.myOrdersData[index]);
            },
          )
        );
        } else {
          return const Center(
            child: Text('Error', style: TextStyle(color: Colors.black),),
          );
        }
      },
    );
  }
}

class OrderItem extends StatelessWidget {
  final Order order;
  const OrderItem({required this.order,super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Order #${order.id}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${order.createdAt}'),
          Text('Total: \$${order.total}'),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // show bottom sheet
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                       Text(
                        'Date: ${order.createdAt}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: \$${order.total}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      const Text(
                        'Items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.products.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.network(
                              order.products[index].product.images![0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(order.products[index].product.name),
                            subtitle:  Text('Price: \$${order.products[index].product.price}'),
                            trailing:  Text('Quantity: ${order.products[index].quantity}'),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Text('View Details'),
      ),
    );
  }
}


  // Widget _buildOrderItem({
  //   required BuildContext context,
  //   required String orderNumber,
  //   required String date,
  //   required double total,
  //   required String status,
  // }) {
  //   return ListTile(
  //     title: Text('Order #$orderNumber'),
  //     subtitle: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Date: $date'),
  //         Text('Total: \$$total'),
  //         Text('Status: $status'),
  //       ],
  //     ),
  //     trailing: ElevatedButton(
  //       onPressed: () {
  //         // show bottom sheet
  //         showModalBottomSheet(
  //           context: context,
  //           builder: (context) {
  //             return Container(
  //               padding: const EdgeInsets.all(16),
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     const Text(
  //                       'Order Details',
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     const Text(
  //                       'Order #123456',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Text(
  //                       'Date: 2021-08-01',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Text(
  //                       'Total: \$100',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Text(
  //                       'Status: Delivered',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     const Text(
  //                       'Items',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     ListView.separated(
  //                       shrinkWrap: true,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemCount: 3,
  //                       itemBuilder: (context, index) {
  //                         return ListTile(
  //                           leading: Image.network(
  //                             'https://healthiersteps.com/wp-content/uploads/2021/12/green-apple-benefits.jpeg',
  //                             width: 50,
  //                             height: 50,
  //                             fit: BoxFit.cover,
  //                           ),
  //                           title: const Text('Organic Bananas'),
  //                           subtitle: const Text('Price: \$4.99'),
  //                           trailing: const Text('Quantity: 1'),
  //                         );
  //                       },
  //                       separatorBuilder: (context, index) {
  //                         return const Divider();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //       child: const Text('View Details'),
  //     ),
  //   );
  // }