import 'package:flutter/material.dart';

class SearchCustom extends StatelessWidget {
  const SearchCustom({
    super.key,
    this.searchController,
    this.performSearch,
    this.onTap,
    required this.autofocus,
    this.focusNode,
  });

  final TextEditingController? searchController;
  final void Function()? performSearch;
  final void Function()? onTap;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onTap: onTap,
      controller: searchController,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: 'Search...',
        suffixIcon: IconButton(
          onPressed: performSearch,
          icon: const Icon(Icons.search),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        isDense: true,
      ),
    );
  }
}
