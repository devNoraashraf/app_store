import 'package:app_store/consts/colors_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchField({super.key, this.onChanged, this.onClear});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    setState(() {}); // refresh suffix icon
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Material(
        elevation: 2, // subtle shadow = modern feel
        color: cs.surface,
        surfaceTintColor: cs.primary, // Material 3 tint on elevation
        borderRadius: BorderRadius.circular(24),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.text,
          onChanged: (v) {
            widget.onChanged?.call(v);
            // UI only: rebuild to toggle clear icon
            setState(() {});
          },
          style: text.bodyMedium,
          cursorColor: cs.primary,
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: Icon(IconlyLight.search, color: cs.onSurfaceVariant),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            suffixIcon:
                _controller.text.isNotEmpty
                    ? IconButton(
                      tooltip: 'Clear',
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: cs.onSurfaceVariant,
                      onPressed: _clear,
                    )
                    : null,
            // Modern fill with soft contrast
            filled: true,
            fillColor: ColorsManager.lightGrey.withOpacity(0.35),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            // Pill outline with subtle variant color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: cs.outlineVariant, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: cs.primary, width: 1.6),
            ),
          ),
        ),
      ),
    );
  }
}
