import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:store_user/bloc/search/search_bloc.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/presentation/widgets/cards/product_card.dart';

class SearchPage extends StatefulWidget {
  final String query;
  const SearchPage({super.key, required this.query});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    context.read<SearchBloc>().add(SearchProducts(query: widget.query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products',
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () {
                context
                    .read<SearchBloc>()
                    .add(SearchProducts(query: _searchController.text));
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
          ),
          onSubmitted: (query) {
            context.read<SearchBloc>().add(SearchProducts(query: query));
          },
        ),
      ),
      // ? note: search query should exactly match the product name, otherwise no results will be shown. This is because we are using Firestore's where() method to query the products collection. If you want to learn more about Firestore's querying capabilities, check out the documentation here: https://firebase.google.com/docs/firestore/query-data/queries
      bottomNavigationBar:const BottomAppBar(
        height: 200,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: 
            Center(
              child: Text('Note: search query should exactly match the product name, otherwise no results will be shown. This is because we are using Firestore\'s ',
                style: TextStyle(
                  color: Colors.black,
                )
              ),
            ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is SearchLoaded) {
            final List<Product> products = state.products;
            if (products.isEmpty) {
              return const Center(
                child: Text('No products found'),
              );
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
