import 'package:flutter/material.dart';
import 'package:delcommerce/core/common/view_models/rounded_image_view_model.dart';
import 'package:delcommerce/core/common/view_models/section_heading_view_model.dart';
import 'package:delcommerce/core/common/widgets/rounded_image.dart';
import 'package:delcommerce/core/common/widgets/section_heading.dart';
import 'package:delcommerce/core/utils/constants/image_strings.dart';
import 'package:delcommerce/core/utils/constants/sizes.dart';
import 'package:delcommerce/features/personalization/presentation/view_models/profile_entity_tile_model.dart';
import 'package:delcommerce/features/personalization/presentation/views/profile_view.dart';
import 'package:delcommerce/features/personalization/presentation/widgets/profile_entity_tile_list.dart';

class ProfileInformationSection extends StatelessWidget {
  const ProfileInformationSection({
    super.key,
    required this.profileInformation,
  });
  final List<ProfileEntityTileModel> profileInformation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              RoundedImage(
                roundedImageModel: RoundedImageModel(
                  image: DelImages.user,
                  width: 80,
                  height: 80,
                  onTap: () {},
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Change Profile Picture"),
              ),
            ],
          ),
        ),
        const SpaceBetweenSectionsWithDivider(),
        SectionHeading(
            sectionHeadingModel: SectionHeadingModel(
                title: "Profile Information", showActionButton: false)),
        const SizedBox(
          height: DelSizes.spaceBtwItems / 1.5,
        ),
        ProfileEntityTileList(profileEntityTileModelList: profileInformation),
      ],
    );
  }
}
