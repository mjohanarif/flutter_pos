import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/components/buttons.dart';
import 'package:flutter_pos/core/components/custom_dropdown.dart';
import 'package:flutter_pos/core/components/custom_text_field.dart';
import 'package:flutter_pos/core/components/image_picker_widget.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/extensions/string_ext.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_pos/presentation/setting/models/category_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController? nameController;
  TextEditingController? priceController;
  TextEditingController? stockController;

  String category = 'food';

  File? imageFile;

  bool isBestSeller = false;

  final List<CategoryModel> categories = [
    CategoryModel(value: 'drink', name: 'Minuman'),
    CategoryModel(value: 'food', name: 'Makanan'),
    CategoryModel(value: 'snack', name: 'Snack'),
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    stockController = TextEditingController();
  }

  @override
  void dispose() {
    nameController?.dispose();
    priceController?.dispose();
    stockController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          24,
        ),
        children: [
          CustomTextField(controller: nameController!, label: 'Nama Produk'),
          const SpaceHeight(
            20,
          ),
          CustomTextField(
            controller: priceController!,
            label: 'Harga Produk',
            keyboardType: TextInputType.number,
            onChanged: (value) {},
          ),
          const SpaceHeight(
            20,
          ),
          ImagePickerWidget(
            label: 'Foto Produk',
            onChanged: (file) {
              if (file == null) {
                return;
              }
              imageFile = file;
            },
          ),
          const SpaceHeight(
            20,
          ),
          CustomTextField(
            controller: stockController!,
            label: 'Stock Produk',
            keyboardType: TextInputType.number,
          ),
          const SpaceHeight(
            20,
          ),
          Row(
            children: [
              Checkbox(
                value: isBestSeller,
                onChanged: (value) {
                  setState(() {
                    isBestSeller = value!;
                  });
                },
              ),
              const Text(
                'Produk Terlaris',
              ),
            ],
          ),
          const SpaceHeight(
            20,
          ),
          CustomDropdown<CategoryModel>(
            value: categories.first,
            items: categories,
            label: 'Kategori',
            onChanged: (value) {
              category = value!.value;
            },
          ),
          const SpaceHeight(
            24,
          ),
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (_) {
                  Navigator.pop(
                    context,
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                success: (response) {
                  return Button.filled(
                    onPressed: () {
                      final Product product = Product(
                        name: nameController!.text,
                        price: priceController!.text.toIntegerFromText,
                        stock: stockController!.text.toIntegerFromText,
                        category: category,
                        isBestSeller: isBestSeller,
                        image: imageFile!.absolute.path,
                        isSync: false,
                      );

                      context.read<ProductBloc>().add(
                            ProductEvent.addProduct(product),
                          );
                    },
                    label: "Simpan",
                  );
                },
              );
            },
          ),
          const SpaceHeight(
            24,
          ),
          Button.outlined(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            label: "Batal",
          ),
          const SpaceHeight(
            30,
          ),
        ],
      ),
    );
  }
}
