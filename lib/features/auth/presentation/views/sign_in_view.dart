import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app_assistant/features/projects/presentation/cubit/assigned_project_cubit.dart';
import '../../../../core/functions/send_fcm_token.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/utils/show_err_dialog.dart';
import '../../../projects/presentation/views/project_dashboard_page.dart';
import '../../domain/repo/auth_repo.dart';
import '../cubits/sign_in/sign_in_cubit.dart';
import 'widgets/sign_in_view_body.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  static const routename = "signin";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(getIt.get<AuthRepo>()),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInFailure) {
            showerrorDialog(
              context: context,
              title: "فشل تسجيل الدخول",
              description: state.errMessage,
            );
          }
          if (state is SignInSuccess) {
            sendFCMToken();
            // Navigate to MainView directly (avoid relying on named routes)
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => getIt<AssignedProjectsCubit>()..loadDashboard('الكل'),
                  child: const AssistantDashboardPage(),
                ),
              ),
              (route) => false,
            );
          }
        },
        child: const Scaffold(body: SignInViewBody()),
      ),
    );
  }
}
