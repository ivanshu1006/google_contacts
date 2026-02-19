import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/routes_constant.dart';
import '../controllers/contacts_controller.dart';
import '../widgets/contact_list.dart';

class HomeView extends HookWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContactsController>();
    final currentIndex = useState(0);
    final searchController = useTextEditingController(
      text: controller.searchQuery,
    );

    useEffect(() {
      void listener() => controller.setSearchQuery(searchController.text);
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController, controller]);

    final isContactsTab = currentIndex.value == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: isContactsTab
            ? ContactList(
                key: const ValueKey('contacts'),
                contacts: controller.filteredContacts,
                isLoading: controller.isLoading,
              )
            : ContactList(
                key: const ValueKey('favorites'),
                contacts: controller.filteredFavoriteContacts,
                isLoading: controller.isLoading,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteConstants.contactAddName),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.value,
        onDestinationSelected: (index) => currentIndex.value = index,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
