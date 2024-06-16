part of 'assets_cubit.dart';

sealed class AssetsState {}

final class AssetsInitial extends AssetsState {}

final class AssetsLoading extends AssetsState {}

final class AssetsSuccess extends AssetsState {
  final List<Asset> assets;
  final List<Location> locations;

  AssetsSuccess({required this.assets, required this.locations});
}

final class AssetsError extends AssetsState {
  final String message;

  AssetsError({required this.message});
}


