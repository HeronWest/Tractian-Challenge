import 'package:bloc/bloc.dart';
import '../../../data/models/asset.dart';
import '../../../data/models/location.dart';
import '../../../repositories/assets_repository.dart';
import '../../../repositories/locations_repository.dart';

part 'assets_state.dart';

class AssetsCubit extends Cubit<AssetsState> {
  final AssetsRepository repository;
  final LocationsRepository locationsRepository;

  AssetsCubit({
    required this.repository,
    required this.locationsRepository,
  }) : super(AssetsInitial());

  void getAssets(String companyId) async {
    emit(AssetsLoading());
    try {
      final assets = await repository.getAssets(companyId);
      final locations = await locationsRepository.getLocations(companyId);
      emit(AssetsSuccess(assets: assets, locations: locations));
    } catch (e) {
      emit(AssetsError(message: e.toString()));
    }
  }
}
