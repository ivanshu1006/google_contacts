// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frappe_flutter_app/constants/routes_constant.dart';
import 'package:frappe_flutter_app/features/contacts_firebase/controllers/contacts_controller.dart';
import 'package:frappe_flutter_app/features/contacts_firebase/widgets/contact_list.dart';
import 'package:frappe_flutter_app/widgets/k_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ContactsController>().loadContact();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ContactsController>().setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        title: _currentIndex == 0 ? 'Contacts' : 'Favourites',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Consumer<ContactsController>(
              builder: (context, controller, _) {
                return TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search contacts',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _searchController.clear(),
                          ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.15),
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withValues(alpha: 0.7),
                    ),
                    prefixIconColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteConstants.contactAddName);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ContactsController>(
        builder: (context, controller, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _currentIndex == 0
                ? ContactList(
                    key: const ValueKey('contacts'),
                    contacts: controller.filteredContacts,
                    isLoading: controller.isLoading,
                  )
                : ContactList(
                    key: const ValueKey('favourites'),
                    contacts: controller.filteredFavoriteContacts,
                    isLoading: controller.isLoading,
                  ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
