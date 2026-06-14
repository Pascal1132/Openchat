import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'presentation/providers/core_providers.dart';
import 'presentation/screens/chat_screen.dart';
import 'presentation/screens/models_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final navigatorKey = GlobalKey<NavigatorState>();

  // Re-run redirects whenever the API key is set or cleared.
  final refresh = _ApiKeyRefreshListenable(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final apiKeyAsync = ref.read(apiKeyProvider);
      // While the key is still loading from secure storage, don't redirect.
      if (apiKeyAsync.isLoading) return null;

      final apiKey = apiKeyAsync.valueOrNull;
      final hasKey = apiKey != null && apiKey.isNotEmpty;
      final isOnOnboarding = state.matchedLocation == '/onboarding';

      if (!hasKey && !isOnOnboarding) return '/onboarding';
      if (hasKey && isOnOnboarding) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return ChatScreen(conversationId: id);
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/models',
        builder: (context, state) => const ModelsScreen(),
      ),
    ],
  );
});

/// Notifies GoRouter whenever the API key state changes so guarded routes
/// (onboarding vs app) are re-evaluated.
class _ApiKeyRefreshListenable extends ChangeNotifier {
  _ApiKeyRefreshListenable(Ref ref) {
    _sub = ref.listen<AsyncValue<String?>>(
      apiKeyProvider,
      (_, __) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AsyncValue<String?>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
