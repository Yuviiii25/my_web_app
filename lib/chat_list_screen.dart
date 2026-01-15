import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WhatsAppScreen extends StatelessWidget {
  const WhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black,
      elevation: 0,

      // Drawer icon
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),

  title: const Text(
    "WhatsApp",
    style: TextStyle(
      color: Colors.green,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),

  actions: [

    //New chat Icon
    Tooltip(
      message: "New Chat",
      waitDuration: const Duration(microseconds: 300),
      child: IconButton(
        icon: const Icon(Icons.chat, color: Colors.white),
      onPressed: () {
        // later: start new chat
      },
    ),
    ),
    

    // Menu icon
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      color: Colors.grey[900],
      onSelected: (value) {
        if (value == "settings") {
          // navigate to settings
        }
        if (value == "logout") {
          // logout logic
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: "settings",
          child: Text("Settings", style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: "logout",
          child: Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  ],
),

      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
      
            // Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "My Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "online",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
      
            _drawerItem(
              icon: Icons.chat,
              title: "Chats",
              onTap: () {
                Navigator.pop(context);
              },
            ),
      
            _drawerItem(
              icon: Icons.person,
              title: "Profile",
              onTap: () {
                // later
              },
            ),
      
            _drawerItem(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {
                // later
              },
            ),
      
            const Spacer(),
      
            const Divider(color: Colors.grey),
      
            _drawerItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/signin");
              },
            ),
      
            const SizedBox(height: 16),
          ],
        ),
      ),

      body: Row(
        children: [

          // Chat List
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            color: Colors.black,
            child: ListView(
              children: [
                chatTile("Neeraj", "Hello", "12:30")
              ],
            ),
          ),

          // Current Chat
          Expanded(
            child: Container(
              color: Colors.grey[900],
              child: const Center(
                child: Text(
                  "Open a chat",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }


  Widget chatTile(String name, String message, String time) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () {
          print("Open $name chat");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [

              const CircleAvatar(radius: 22),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Oxygen",
                            fontWeight: FontWeight.bold)),
                    Text(message,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              Text(time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }


  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}