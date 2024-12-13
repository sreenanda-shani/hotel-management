import 'package:flutter/material.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  String query = "";
  final List<Map<String, String>> users = [
    {'userName': 'Alice', 'userImage': 'assets/images/alice.png'},
    {'userName': 'Bob', 'userImage': 'assets/images/bob.png'},
    {'userName': 'Charlie', 'userImage': 'assets/images/charlie.png'},
    {'userName': 'Diana', 'userImage': 'assets/images/diana.png'},
    {'userName': 'Eve', 'userImage': 'assets/images/eve.png'},
  ];

  List<Map<String, String>> getFilteredUsers() {
    return users
        .where((user) => user['userName']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredUsers = getFilteredUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by username...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(user['userImage']!),
                      ),
                      title: Text(
                        user['userName']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 70, endIndent: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
