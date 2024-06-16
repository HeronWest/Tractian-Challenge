import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../data/models/asset.dart';
import '../data/models/location.dart';
import '../features/company/pages/company_assets_page.dart';

class TractianTreeView extends StatelessWidget {
  final TreeNode root;

  const TractianTreeView({super.key, required this.root});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: SuperListView(
        children: _buildTreeNodes(root, 0, context),
      ),
    );
  }

  List<Widget> _buildTreeNodes(TreeNode node, int depth, context) {
    List<Widget> children = [];
    for (var child in node.children) {
      children.add(_buildTreeNode(child, depth + 1, context));
    }
    return children;
  }

  Widget getLeadingIcon(String type) {
    switch (type) {
      case 'Location':
        return Image.asset(
          'assets/images/location.png',
          height: 24,
        );
      case 'Asset':
        return Image.asset(
          'assets/images/asset.png',
          height: 24,
        );
      default:
        return Image.asset(
          'assets/images/component.png',
          height: 24,
        );
    }
  }

  Widget _buildTreeNode(TreeNode node, int depth, context) {
    Widget content;
    if (node.children.isEmpty) {
      content = ListTile(
        title: Text(node.name),
        leading: getLeadingIcon(node.type),
        trailing: node.data is Asset && (node.data as Asset).status == 'alert'
            ? const Icon(
          Icons.error,
          color: Colors.red,
        )
            : node.data is Asset && (node.data as Asset).sensorType != null
            ? const Icon(
          Icons.bolt,
          color: Colors.blue,
        )
            : null,
        onTap: () {
          if (node.data is Asset) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      (node.data as Asset).name,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Theme(
                      data: ThemeData().copyWith(
                          textTheme: TextTheme(
                            bodyLarge: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Asset ID: ${(node.data as Asset).id}'),
                          if ((node.data as Asset).sensorType != null)
                            Text(
                              'Sensor Type: ${(node.data as Asset).sensorType}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          if ((node.data as Asset).status != null)
                            Text(
                              'Status: ${(node.data as Asset).status}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          if ((node.data as Asset).gatewayId != null)
                            Text(
                              'Gateway ID: ${(node.data as Asset).gatewayId}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          if ((node.data as Asset).locationId != null)
                            Text(
                              'Location ID: ${(node.data as Asset).locationId}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          if ((node.data as Asset).parentId != null)
                            Text(
                              'Parent ID: ${(node.data as Asset).parentId}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          if ((node.data as Asset).sensorId != null)
                            Text(
                              'Sensor ID: ${(node.data as Asset).sensorId}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                });
          } else if (node.data is Location) {
          }
        },
      );
    } else {
      content = ExpansionTile(
        controlAffinity: ListTileControlAffinity.trailing,
        key: PageStorageKey(node.id),
        title: Text(node.name),
        leading: getLeadingIcon(node.type),
        children: _buildTreeNodes(node, depth, context),
      );
    }

    double paddingValue = depth == 1 ? 0.0 : 48.0 - (depth * 2);
    // Ensure minimum padding is 2.0 for deeper nodes
    paddingValue = paddingValue < 2.0 ? 2.0 : paddingValue;

    return depth == 0
        ? content
        : Padding(
      padding: EdgeInsets.only(left: paddingValue),
      child: content,
    );
  }
}

class TreeNode {
  String id;
  String name;
  String type;
  Object? data;
  List<TreeNode> children = [];

  TreeNode(this.id, this.name, this.type, this.data);

  void addChild(TreeNode child) {
    children.add(child);
  }
}

TreeNode buildTree(List<Location> locations, List<Asset> assets, Set<AssetsFilter> filters, String searchQuery) {
  Map<String, TreeNode> nodeMap = {};

  for (var loc in locations) {
    nodeMap[loc.id] = TreeNode(loc.id, loc.name, 'Location', loc);
  }

  for (var asset in assets) {
    String type =
    asset.sensorType != null ? 'Component - ${asset.sensorType}' : 'Asset';
    nodeMap[asset.id] = TreeNode(asset.id, asset.name, type, asset);
  }

  TreeNode root = TreeNode('ROOT', 'ROOT', 'Root', null);

  for (var loc in locations) {
    if (loc.parentId == null) {
      root.addChild(nodeMap[loc.id]!);
    } else {
      nodeMap[loc.parentId]?.addChild(nodeMap[loc.id]!);
    }
  }

  for (var asset in assets) {
    if (asset.locationId != null) {
      nodeMap[asset.locationId]?.addChild(nodeMap[asset.id]!);
    } else if (asset.parentId != null) {
      nodeMap[asset.parentId]?.addChild(nodeMap[asset.id]!);
    } else {
      root.addChild(nodeMap[asset.id]!);
    }
  }

  return _filterTree(root, filters, searchQuery);
}

TreeNode _filterTree(TreeNode node, Set<AssetsFilter> filters, String searchQuery) {
  bool matchesFilters(TreeNode node) {
    if (node.data is Asset) {
      Asset asset = node.data as Asset;

      if (filters.contains(AssetsFilter.energySensors) && !filters.contains(AssetsFilter.critics)) {
        bool isEnergySensor = asset.sensorType != null && asset.sensorType != null && asset.status != null && asset.status != 'alert';
        return isEnergySensor;
      } else if (!filters.contains(AssetsFilter.energySensors) && filters.contains(AssetsFilter.critics)) {
        bool isCritical = asset.status != null && asset.status == 'alert';
        return isCritical;
      } else if (filters.contains(AssetsFilter.energySensors) && filters.contains(AssetsFilter.critics)) {
        bool isEnergySensorAndCritical = asset.sensorType != null && asset.sensorType != null && asset.status != null && asset.status == 'alert';
        return isEnergySensorAndCritical;
      } else {
        // Nenhum filtro ativado (não deve ocorrer com a lógica de UI correta)
        return true;
      }
    }
    return false;
  }



  List<TreeNode> filteredChildren = node.children
      .map((child) => _filterTree(child, filters, searchQuery))
      .where((child) => child.children.isNotEmpty || matchesFilters(child) && child.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  if (filteredChildren.isNotEmpty || matchesFilters(node)) {
    node.children = filteredChildren;
    return node;
  } else {
    return TreeNode('', '', '', null); // Return an empty TreeNode if it doesn't match filters
  }
}