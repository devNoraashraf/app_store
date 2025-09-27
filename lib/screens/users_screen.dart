import 'package:app_store/models/user_model.dart';
import 'package:app_store/services/api_handler.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<UserModel>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = ApiHandler().getAllUsers();
  }

  Future<void> _reload() async {
    setState(() {
      _future = ApiHandler().getAllUsers();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by name or email',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _SkeletonList();
                }
                if (snapshot.hasError) {
                  return _ErrorState(
                    message: 'Something went wrong',
                    details: '${snapshot.error}',
                    onRetry: _reload,
                  );
                }

                final all = snapshot.data ?? const <UserModel>[];
                final users = _query.isEmpty
                    ? all
                    : all.where((u) {
                        final name = (u.name ?? '').toLowerCase();
                        final email = (u.email ?? '').toLowerCase();
                        return name.contains(_query) || email.contains(_query);
                      }).toList();

                if (users.isEmpty) {
                  return _EmptyState(
                    title: _query.isEmpty ? 'No users yet' : 'No matches',
                    subtitle: _query.isEmpty
                        ? 'Users you add will appear here.'
                        : 'Try a different name or email.',
                    onRefresh: _reload,
                  );
                }

                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final u = users[index];
                      return _UserCard(user: u, cs: cs, text: text);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.cs, required this.text});

  final UserModel user;
  final ColorScheme cs;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final role = (user.role ?? '').trim();
    final email = user.email ?? '';
    final name = user.name?.trim().isNotEmpty == true ? user.name!.trim() : 'Unknown';
    final avatarUrl = (user.avatar ?? '').trim();

    return Card(
      elevation: 0,
      color: cs.surface,
      surfaceTintColor: cs.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _Avatar(avatarUrl: avatarUrl, fallbackText: _initials(name)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      email.isEmpty ? '—' : email,
                      style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    if (role.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: Text(role),
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(color: cs.outlineVariant),
                          backgroundColor: cs.surfaceContainerHighest,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                tooltip: 'More',
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'details', child: Text('View details')),
                  PopupMenuItem(value: 'message', child: Text('Send message')),
                ],
                onSelected: (v) {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarUrl, required this.fallbackText});

  final String avatarUrl;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final hasUrl = Uri.tryParse(avatarUrl)?.hasAbsolutePath == true;
    return CircleAvatar(
      radius: 26,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundImage: hasUrl ? NetworkImage(avatarUrl) : null,
      onForegroundImageError: (_, __) {},
      child: !hasUrl
          ? Text(
              fallbackText,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.onRefresh,
  });

  final String title;
  final String subtitle;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_outlined, size: 56, color: cs.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(subtitle, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.details, required this.onRetry});
  final String message;
  final String details;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: cs.error),
            const SizedBox(height: 12),
            Text(message, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(details, style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lightweight skeleton while loading (no extra packages)
class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 84,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
