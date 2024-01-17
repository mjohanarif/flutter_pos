import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/assets/assets.gen.dart';
import 'package:flutter_pos/core/components/menu_button.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos/presentation/home/bloc/logout/logout_bloc.dart';
import 'package:flutter_pos/presentation/setting/pages/manage_product_page.dart';
import 'package:flutter_pos/presentation/setting/pages/save_server_key_page.dart';
import 'package:flutter_pos/presentation/setting/pages/sync_data_page.dart';

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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                MenuButton(
                  iconPath: Assets.images.manageProduct.path,
                  label: 'Kelola Produk',
                  onPressed: () => context.push(
                    const ManageProductPage(),
                  ),
                  isImage: true,
                ),
                const SpaceWidth(15),
                MenuButton(
                  iconPath: Assets.images.managePrinter.path,
                  label: 'Kelola Printer',
                  onPressed: () {},
                  isImage: true,
                ),
              ],
            ),
          ),
          const SpaceHeight(20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                MenuButton(
                  iconPath: Assets.images.manageProduct.path,
                  label: 'QRIS Server Key',
                  onPressed: () => context.push(
                    const SaveServerKeyPage(),
                  ),
                  isImage: true,
                ),
                const SpaceWidth(15),
                MenuButton(
                  iconPath: Assets.images.managePrinter.path,
                  label: 'Sinkronisasi Data',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SyncDataPage();
                        },
                      ),
                    );
                  },
                  isImage: true,
                ),
              ],
            ),
          ),
          const SpaceHeight(60),
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
