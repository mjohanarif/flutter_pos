import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/constants/colors.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_order/sync_order_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => SyncDataPageState();
}

class SyncDataPageState extends State<SyncDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sync Data',
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (response) async {
                  await ProductLocalDatasource.instance.removeAllProduct();
                  await ProductLocalDatasource.instance.insertAllProduct(
                    response.response.toList(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sync Data Succeed'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                            const ProductEvent.fetch(),
                          );
                    },
                    child: const Text('Sync Data Product'),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
          const SpaceHeight(
            20,
          ),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (response) async {
                  // await ProductLocalDatasource.instance.removeAllProduct();
                  // await ProductLocalDatasource.instance.insertAllProduct(
                  //   response.response.toList(),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sync Data Order Success'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<SyncOrderBloc>().add(
                            const SyncOrderEvent.sendOrder(),
                          );
                    },
                    child: const Text('Sync Data Orders'),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
