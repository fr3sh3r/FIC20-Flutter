import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/department_remote_datasource.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/auth/pages/splash_page.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/bloc/department/create_department/create_department_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/bloc/department/get_department/get_department_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';
import 'data/datasources/basic_salary_remote_datasource.dart';
import 'data/datasources/designation_remote_datasource.dart';
import 'data/datasources/holiday_remote_datasource.dart';
import 'data/datasources/leave_type_remote_datasource.dart';
import 'data/datasources/role_remote_datasource.dart';
import 'data/datasources/shift_remote_datasource.dart';
import 'presentation/home/bloc/basic_salary/create_basic_salary/create_basic_salary_bloc.dart';
import 'presentation/home/bloc/basic_salary/delete_basic_salary/delete_basic_salary_bloc.dart';
import 'presentation/home/bloc/basic_salary/get_basic_salary/get_basic_salary_bloc.dart';
import 'presentation/home/bloc/basic_salary/update_basic_salary/update_basic_salary_bloc.dart';
import 'presentation/home/bloc/department/delete_department/delete_department_bloc.dart';
import 'presentation/home/bloc/designation/create_designation/create_designation_bloc.dart';
import 'presentation/home/bloc/designation/delete_designation/delete_designation_bloc.dart';
import 'presentation/home/bloc/designation/get_designation/get_designation_bloc.dart';
import 'presentation/home/bloc/designation/update_designation/update_designation_bloc.dart';
import 'presentation/home/bloc/holiday/create_holiday/create_holiday_bloc.dart';
import 'presentation/home/bloc/holiday/delete_holiday/delete_holiday_bloc.dart';
import 'presentation/home/bloc/holiday/get_holiday/get_holiday_bloc.dart';
import 'presentation/home/bloc/holiday/update_holiday/update_holiday_bloc.dart';
import 'presentation/home/bloc/department/update_department/update_department_bloc.dart';
import 'presentation/home/bloc/leave_types/create_leave_types/create_leave_types_bloc.dart';
import 'presentation/home/bloc/leave_types/delete_leave_types/delete_leave_types_bloc.dart';
import 'presentation/home/bloc/leave_types/get_leave_types/get_leave_types_bloc.dart';
import 'presentation/home/bloc/leave_types/update_leave_types/update_leave_types_bloc.dart';
import 'presentation/home/bloc/role/create_role/create_role_bloc.dart';
import 'presentation/home/bloc/role/delete_role/delete_role_bloc.dart';
import 'presentation/home/bloc/role/get_role/get_role_bloc.dart';
import 'presentation/home/bloc/role/update_role/update_role_bloc.dart';
import 'presentation/home/bloc/shift/create_shift/create_shift_bloc.dart';
import 'presentation/home/bloc/shift/delete_shift/delete_shift_bloc.dart';
import 'presentation/home/bloc/shift/get_shift/get_shift_bloc.dart';
import 'presentation/home/bloc/shift/update_shift/update_shift_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetDepartmentBloc(DepartmentRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              CreateDepartmentBloc(DepartmentRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              UpdateDepartmentBloc(DepartmentRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              DeleteDepartmentBloc(DepartmentRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              GetDesignationBloc(DesignationRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              UpdateDesignationBloc(DesignationRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              CreateDesignationBloc(DesignationRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              DeleteDesignationBloc(DesignationRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetHolidayBloc(HolidayRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateHolidayBloc(HolidayRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateHolidayBloc(HolidayRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DeleteHolidayBloc(HolidayRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              GetBasicSalaryBloc(BasicSalaryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              UpdateBasicSalaryBloc(BasicSalaryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              CreateBasicSalaryBloc(BasicSalaryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              DeleteBasicSalaryBloc(BasicSalaryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetLeaveTypesBloc(LeaveTypeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              UpdateLeaveTypesBloc(LeaveTypeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              CreateLeaveTypesBloc(LeaveTypeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              DeleteLeaveTypesBloc(LeaveTypeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetRoleBloc(RoleRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateRoleBloc(RoleRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateRoleBloc(RoleRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DeleteRoleBloc(RoleRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetShiftBloc(ShiftRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateShiftBloc(ShiftRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateShiftBloc(ShiftRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DeleteShiftBloc(ShiftRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        title: 'EDIM HRM Inventory POS App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          dialogBackgroundColor: AppColors.white,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
          ),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: AppColors.white),
          dividerTheme: const DividerThemeData(color: AppColors.stroke),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.black,
            ),
            centerTitle: true,
          ),
          listTileTheme: const ListTileThemeData(
            titleTextStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ), //themedata
        home: const SplashPage(),
      ),
    );
  }
}
