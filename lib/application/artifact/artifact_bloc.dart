import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shiori/application/common/pop_bloc.dart';
import 'package:shiori/domain/models/models.dart';
import 'package:shiori/domain/services/genshin_service.dart';
import 'package:shiori/domain/services/telemetry_service.dart';

part 'artifact_bloc.freezed.dart';
part 'artifact_event.dart';
part 'artifact_state.dart';

class ArtifactBloc extends PopBloc<ArtifactEvent, ArtifactState> {
  final GenshinService _genshinService;
  final TelemetryService _telemetryService;

  ArtifactBloc(this._genshinService, this._telemetryService) : super(const ArtifactState.loading());

  @override
  ArtifactEvent getEventForPop(String? key) => ArtifactEvent.loadFromKey(key: key!, addToQueue: false);

  @override
  Stream<ArtifactState> mapEventToState(ArtifactEvent event) async* {
    yield const ArtifactState.loading();

    final s = await event.map(
      loadFromKey: (e) async {
        final artifact = _genshinService.getArtifact(e.key);
        final translation = _genshinService.getArtifactTranslation(e.key);
        final charImgs = _genshinService.getCharacterForItemsUsingArtifact(e.key);
        final droppedBy = _genshinService.getRelatedMonsterToArtifactForItems(e.key);
        final images = _genshinService.getArtifactRelatedParts(artifact.fullImagePath, artifact.image, translation.bonus.length);
        final bonus = _genshinService.getArtifactBonus(translation);

        if (e.addToQueue) {
          await _telemetryService.trackArtifactLoaded(e.key);
          currentItemsInStack.add(artifact.key);
        }

        return ArtifactState.loaded(
          name: translation.name,
          image: artifact.fullImagePath,
          minRarity: artifact.minRarity,
          maxRarity: artifact.maxRarity,
          bonus: bonus,
          images: images,
          charImages: charImgs,
          droppedBy: droppedBy,
        );
      },
    );

    yield s;
  }
}
