import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/auth/bloc/logout/logout_bloc.dart';

import '../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../auth/pages/login_page.dart';

class AppBarWidget extends StatelessWidget {
  final String title;

  const AppBarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Button.outlined(
            onPressed: () {},
            label: 'Clock In',
            icon: Assets.icons.clockIn.svg(),
            color: AppColors.background,
            textColor: AppColors.primary,
            fontSize: 14.0,
            width: 170.0,
          ),
          Button.outlined(
            onPressed: () {
              // context.push(const DashboardPosPage());
            },
            label: 'POS',
            icon: Assets.icons.pos.svg(),
            color: AppColors.background,
            textColor: AppColors.primary,
            fontSize: 14.0,
            width: 170.0,
          ),
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loaded: () {
                  AuthLocalDatasource().removeAuthData();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return Button.outlined(
                  onPressed: () {
                    context.read<LogoutBloc>().add(const LogoutEvent.logout());
                  },
                  label: 'Logout',
                  icon: Assets.icons.logout.svg(),
                  color: AppColors.background,
                  textColor: AppColors.primary,
                  fontSize: 14.0,
                  width: 170.0,
                );
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              });
            },
          ),
        ],
      ),
    );
  }
}
