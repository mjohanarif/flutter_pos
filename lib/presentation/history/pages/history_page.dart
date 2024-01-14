import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/history/bloc/history/history_bloc.dart';
import 'package:flutter_pos/presentation/history/widgets/history_transaction_card.dart';

import '../../../core/components/spaces.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context.read<HistoryBloc>().add(
          const HistoryEvent.fetch(),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);

    return Scaffold(
        appBar: AppBar(
          title: const Text('History Orders',
              style: TextStyle(fontWeight: FontWeight.bold)),
          // backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return const Center(
                  child: Text('No data'),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              success: (histories) {
                if (histories.isEmpty) {
                  return const Center(
                    child: Text('No data'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  itemCount: histories.length,
                  separatorBuilder: (context, index) => const SpaceHeight(8.0),
                  itemBuilder: (context, index) => HistoryTransactionCard(
                    padding: paddingHorizontal,
                    data: histories[index],
                  ),
                );
              },
            );
          },
        ));
  }
}
