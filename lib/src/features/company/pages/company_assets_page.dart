import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tractian_challenge/src/features/company/cubit/assets_cubit.dart';

import '../../../widgets/tractian_tree_view.dart';

enum AssetsFilter { energySensors, critics }

class CompanyAssetsPage extends StatefulWidget {
  final String? companyId;

  const CompanyAssetsPage({super.key, this.companyId});

  @override
  State<CompanyAssetsPage> createState() => _CompanyAssetsPageState();
}

class _CompanyAssetsPageState extends State<CompanyAssetsPage> {
  Set<AssetsFilter> filters = <AssetsFilter>{
    // AssetsFilter.energySensors,
    // AssetsFilter.critics,
  };

  String searchQuery = '';

  late TreeNode root;

  String _appBarText = 'Assets';

  @override
  void initState() {
    super.initState();
    context.get<AssetsCubit>().getAssets(widget.companyId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _appBarText,
          style: GoogleFonts.nunito(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FractionallySizedBox(
              widthFactor: 0.96,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a place or local',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FractionallySizedBox(
              widthFactor: 0.96,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(
                      'Energy Sensors',
                      style: GoogleFonts.nunito(
                        color: filters.contains(AssetsFilter.energySensors)
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: filters.contains(AssetsFilter.energySensors)
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    showCheckmark: false,
                    selected: filters.contains(AssetsFilter.energySensors),
                    selectedColor: Theme.of(context).colorScheme.tertiary,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          filters.add(AssetsFilter.energySensors);
                        } else {
                          filters.remove(AssetsFilter.energySensors);
                        }
                      });
                    },
                    avatar: Icon(
                      Icons.electrical_services,
                      color: filters.contains(AssetsFilter.energySensors)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(
                      'Critical',
                      style: GoogleFonts.nunito(
                        color: filters.contains(AssetsFilter.critics)
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: filters.contains(AssetsFilter.critics)
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    showCheckmark: false,
                    selected: filters.contains(AssetsFilter.critics),
                    selectedColor: Theme.of(context).colorScheme.tertiary,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          filters.add(AssetsFilter.critics);
                        } else {
                          filters.remove(AssetsFilter.critics);
                        }
                      });
                    },
                    avatar: Icon(
                      Icons.warning_amber,
                      color: filters.contains(AssetsFilter.critics)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<AssetsCubit, AssetsState>(
            bloc: context.get<AssetsCubit>(),
            builder: (context, state) {
              if (state is AssetsLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is AssetsSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _appBarText = 'Assets (${state.assets.length})';
                  });
                });

                return Expanded(
                  child: TractianTreeView(
                    root: buildTree(
                      state.locations,
                      state.assets,
                      filters,
                      searchQuery,
                    ),
                  ),
                );
              } else if (state is AssetsError) {
                return Center(
                  child: Text('Failed to load assets: ${state.message}'),
                );
              } else {
                return const Center(child: Text('Unknown state.'));
              }
            },
          ),
        ],
      ),
    );
  }
}
