import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/constants/colors.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                    child: const Text('Sync Data'),
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
          const Divider(),
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: () {
                  AuthLocalDatasource().remoteAuthData();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<LogoutBloc>().add(
                        const LogoutEvent.logout(),
                      );
                },
                child: const Text('Logout'),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
