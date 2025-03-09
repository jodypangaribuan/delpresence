import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/choice_chip_view_model.dart';
import 'package:delcommerce/core/common/view_models/circular_container_view_model.dart';
import 'package:delcommerce/core/common/widgets/circular_container.dart';
import 'package:delcommerce/core/utils/constants/colors.dart';
import 'package:delcommerce/core/utils/helpers/helper_functions.dart';

class CustomChoiceChip extends StatelessWidget {
  //CustomChoiceChip >>
  const CustomChoiceChip({
    super.key,
    required this.choiceChipModel,
  });
  final ChoiceChipModel choiceChipModel;
  @override
  Widget build(BuildContext context) {
    final isColor = DelHelperFunctions.getColor(choiceChipModel.label) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        avatar: isColor
            ? CircularContainer(
                circularContainerModel: CircularContainerModel(
                    width: 50,
                    height: 50,
                    color: DelHelperFunctions.getColor(choiceChipModel.label)),
              )
            : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
        padding: isColor ? const EdgeInsets.all(0) : null,
        shape: isColor ? const CircleBorder() : null,
        label: isColor ? const SizedBox() : Text(choiceChipModel.label),
        selected: choiceChipModel.selected,
        onSelected: choiceChipModel.onSelected,
        backgroundColor:
            isColor ? DelHelperFunctions.getColor(choiceChipModel.label) : null,
        labelStyle: TextStyle(
          color: choiceChipModel.selected ? TColors.white : null,
        ),
      ),
    );
  }
}
