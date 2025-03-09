import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/grid_layout_view_model.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.gridLayoutModel,
  });
  final GridLayoutModel gridLayoutModel;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: gridLayoutModel.itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: DelSizes.gridViewSpacing,
            crossAxisSpacing: DelSizes.gridViewSpacing,
            mainAxisExtent: gridLayoutModel.mainAxisExtent,
            crossAxisCount: 2),
        itemBuilder: gridLayoutModel.itemBuilder);
  }
}
