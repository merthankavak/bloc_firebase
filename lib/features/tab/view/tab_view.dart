import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/view/base_view.dart';
import '../../../product/cubits/tab/tab_cubit.dart';
import '../viewmodel/tab_view_model.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<TabViewModel>(
      viewModel: TabViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, TabViewModel viewModel) =>
          BlocBuilder<TabCubit, TabState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                onTap: (value) => context.read<TabCubit>().changeTabIndex(value),
                currentIndex: state.tabIndex,
                items: viewModel.tabList
                    .map((e) => BottomNavigationBarItem(icon: Icon(e.tabIcon), label: e.tabName))
                    .toList()),
            body: viewModel.pageList[state.tabIndex],
          );
        },
      ),
    );
  }
}
