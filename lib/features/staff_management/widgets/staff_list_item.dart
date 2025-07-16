// lib/features/staff_management/widgets/staff_list_item.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/widgets/custom_card.dart';
import 'package:project_beauty_admin/data/models/staff_member.dart';


class StaffListItem extends StatelessWidget {
  final StaffMember staffMember;
  final VoidCallback onTap;

  const StaffListItem({
    Key? key,
    required this.staffMember,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard.small(
      onTap: onTap,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profil Fotoğrafı (CircleAvatar)
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.lightGrey,
            backgroundImage: staffMember.imageUrl != null
                ? NetworkImage(staffMember.imageUrl!)
                : null,
            child: staffMember.imageUrl == null
                ? Icon(Icons.person, color: AppColors.darkGrey, size: 30)
                : null,
          ),
          const SizedBox(width: 16.0),

          // Personel Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staffMember.name,
                  style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  staffMember.title,
                  style: AppTextStyles.bodyText2.copyWith(color: AppColors.darkGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (staffMember.specialization != null && staffMember.specialization!.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    'Uzmanlık: ${staffMember.specialization!}',
                    style: AppTextStyles.labelText.copyWith(color: AppColors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16.0),

          // Sağda Ok İkonu
          Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 18),
        ],
      ),
    );
  }
}