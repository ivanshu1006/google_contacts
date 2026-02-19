import 'package:go_router/go_router.dart';

import 'constants/routes_constant.dart';
import 'features/contacts/views/contact_detail_view.dart';
import 'features/contacts/views/contact_form_view.dart';
import 'features/contacts/views/home_view.dart';
import 'features/splash/views/splash_view.dart';
import 'widgets/k_dialog.dart';

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteConstants.splash,
  routes: <GoRoute>[
    GoRoute(
      name: RouteConstants.splashName,
      path: RouteConstants.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      name: RouteConstants.homeName,
      path: RouteConstants.home,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          name: RouteConstants.contactAddName,
          path: RouteConstants.contactAdd,
          builder: (context, state) => const ContactFormView(),
        ),
        GoRoute(
          name: RouteConstants.contactDetailName,
          path: RouteConstants.contactDetail,
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            return ContactDetailView(contactId: id);
          },
          routes: [
            GoRoute(
              name: RouteConstants.contactEditName,
              path: RouteConstants.contactEdit,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return ContactFormView(contactId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
