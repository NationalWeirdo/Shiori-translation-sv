import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiori/application/bloc.dart';
import 'package:shiori/presentation/shared/sliver_loading.dart';
import 'package:shiori/presentation/today_materials/widgets/sliver_character_ascension_materials.dart';

class SliverTodayCharAscensionMaterials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => const SliverLoading(),
          loaded: (state) => SliverCharacterAscensionMaterials(charAscMaterials: state.charAscMaterials),
        );
      },
    );
  }
}
