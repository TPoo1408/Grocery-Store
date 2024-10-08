import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_user/bloc/favorites/favorites_bloc.dart';
import 'package:store_user/bloc/product/product_bloc.dart';
import 'package:store_user/bloc/store_details/store_details_bloc.dart';
import 'package:store_user/bloc/store_favorite/store_favorite_bloc.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/models/store.dart';
import 'package:store_user/presentation/utils/app_colors.dart';
import 'package:store_user/presentation/utils/app_router.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              TabBar(
                  controller: tabController,
                  unselectedLabelColor: Colors.black12,
                  labelColor: Colors.black,
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Products',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Stores',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]
               ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    const FavoriteProductTab(),
                    const FavoriteStoreTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Product product;

  const FavoriteItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.productDetailsRoute,
          arguments: product,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Row(
          children: [
            // image
            product.images == null || product.images!.isEmpty
                ? Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.gray,
                    ),
                    child: const Icon(
                      Icons.inventory,
                      color: AppColors.primary,
                    ))
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          product.images!.first,
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
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // unit
                  Text(
                    '1 ${product.unit.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightGray,
                    ),
                  ),
                ],
              ),
            ),
            // price
            Text(
              '\$${product.price}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // open product
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.lightGray,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteProductTab extends StatefulWidget {
  const FavoriteProductTab({super.key});

  @override
  State<FavoriteProductTab> createState() => _FavoriteProductTabState();
}

class _FavoriteProductTabState extends State<FavoriteProductTab> {
  final favorites = <Product>[];

  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(const FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesLoaded) {
          favorites.clear();
          favorites.addAll(state.products);
        }
      },
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFavoriteUpdated) {
            context.read<FavoritesBloc>().add(const FetchFavorites());
          }
        },
        child:  SingleChildScrollView(
            child: Column(
              children: [
                
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is FavoritesError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Text(state.message),
                        ),
                      );
                    }

                    if (favorites.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 30,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              size: 80,
                              color: AppColors.lightGray,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No Favorites',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'You have not added any favorites yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.lightGray,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return FavoriteItem(
                          product: favorites[index],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        
      ),
    );
  }
}

class FavoriteStoreTab extends StatefulWidget {
  const FavoriteStoreTab({super.key});

  @override
  State<FavoriteStoreTab> createState() => _FavoriteStoreTabState();
}

class _FavoriteStoreTabState extends State<FavoriteStoreTab> {
  final favorites = <Store>[];

  @override
  void initState() {
    super.initState();
    context.read<StoreFavoriteBloc>().add(FetchStoreFavorite());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreFavoriteBloc, StoreFavoriteState>(
      listener: (context, state) {
        if (state is StoreFavoriteLoaded) {
          favorites.clear();
          favorites.addAll(state.stores);
        }
      },
      child: BlocListener<StoreDetailsBloc, StoreDetailsState>(
        listener: (context, state) {
          if (state is StoreDetailsFavoriteUpdated) {
            context.read<StoreFavoriteBloc>().add(FetchStoreFavorite());
          }
        },
        child:  SingleChildScrollView(
            child: Column(
              children: [
                
                BlocBuilder<StoreFavoriteBloc, StoreFavoriteState>(
                  builder: (context, state) {
                    if (state is StoreFavoriteLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is StoreFavoriteError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Text(state.message),
                        ),
                      );
                    }

                    if (favorites.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 30,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              size: 80,
                              color: AppColors.lightGray,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No Favorites',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'You have not added any favorites yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.lightGray,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return StoreFavoriteItem(
                          store: favorites[index],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        
      ),
    );
  }
}

class StoreFavoriteItem extends StatelessWidget {
  final Store store;

  const StoreFavoriteItem({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.storeDetailsRoute,
          arguments: store,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Row(
          children: [
            // image
            store.image == null 
                ? Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.gray,
                    ),
                    child: const Icon(
                      Icons.inventory,
                      color: AppColors.primary,
                    ))
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          store.image!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // title
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // unit
                  
                ],
              ),
            ),
            // price
          
            // open product
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.lightGray,
            ),
          ],
        ),
      ),
    );
  }
}