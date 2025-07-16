// lib/features/staff_management/screens/staff_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:project_beauty_admin/design_system/app_colors.dart';
import 'package:project_beauty_admin/design_system/app_text_styles.dart';
import 'package:project_beauty_admin/design_system/extensions/context_extensions.dart';
import 'package:project_beauty_admin/features/shared_admin_components/admin_app_bar.dart';
import 'package:project_beauty_admin/data/models/staff_member.dart';

class StaffDetailScreen extends StatelessWidget {
  final StaffMember staffMember;

  const StaffDetailScreen({Key? key, required this.staffMember}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AdminAppBar(
        title: staffMember.name,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.lightGrey,
                backgroundImage: staffMember.imageUrl != null
                    ? NetworkImage(staffMember.imageUrl!)
                    : null,
                child: staffMember.imageUrl == null
                    ? Icon(Icons.person, color: AppColors.darkGrey, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              staffMember.name,
              style: AppTextStyles.headline1.copyWith(color: AppColors.black),
            ),
            Text(
              staffMember.title,
              style: AppTextStyles.headline3.copyWith(color: AppColors.darkGrey),
            ),
            if (staffMember.specialization != null && staffMember.specialization!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                'Uzmanlık Alanı: ${staffMember.specialization!}',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.black),
              ),
            ],
            const SizedBox(height: 16.0),
            Divider(color: AppColors.lightGrey),
            const SizedBox(height: 16.0),
            Text(
              'İletişim Bilgileri:',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Telefon: ${staffMember.phoneNumber}',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
            ),
            Text(
              'E-posta: ${staffMember.email}',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
            ),
            const SizedBox(height: 16.0),
            Divider(color: AppColors.lightGrey),
            const SizedBox(height: 16.0),
            Text(
              'Çalışma Günleri:',
              style: AppTextStyles.headline3.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              staffMember.workingDays.join(', '),
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
            ),
            if (staffMember.bio != null && staffMember.bio!.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Divider(color: AppColors.lightGrey),
              const SizedBox(height: 16.0),
              Text(
                'Biyografi:',
                style: AppTextStyles.headline3.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 8.0),
              Text(
                staffMember.bio!,
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.darkGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}