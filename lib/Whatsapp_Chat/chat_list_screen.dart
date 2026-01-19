import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WhatsAppScreen extends StatefulWidget {
  const WhatsAppScreen({super.key});

  @override
  State<WhatsAppScreen> createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen> {

  List<String> chats = [];
  String? selectedChat;
  Map<String, List<String>> messages = {};
  final messageController = TextEditingController();


  void showNewChatDialog(){
  final emailController = TextEditingController();
  String? errorText;

  showDialog(
    context: context,
    builder:(context){
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Start a New Chat",
              style: TextStyle(color: Colors.black),
            ),
            content: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                hintStyle: const TextStyle(color: Colors.grey),
                errorText: errorText,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  final email = emailController.text.trim();

                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (email.isEmpty) {
                    setDialogState(() {
                      errorText = "Email cannot be empty";
                    });
                  }
                  else if (!emailRegex.hasMatch(email)) {
                    setDialogState(() {
                      errorText = "Enter a valid email address";
                    });
                  }
                  else {
                    setState(() {
                      chats.insert(0, email);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Start"),
              ),

              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              )
            ],
          );
        },
      );
    });
}



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
        showNewChatDialog();
      },
    ),
    ),
    

    // Menu icon
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      color: Colors.grey[900],
      onSelected: (value) async {
        if (value == "logout") {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/signin");
        }
      },
      itemBuilder: (context) => const [
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
      
          ],
        ),
      ),

      body: Row(
        children: [

          // Chat List
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            color: Colors.black,
            child: chats.isEmpty
                ? const Center(
                    child: Text("No chats",
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return chatTile(chats[index],"Tap to open", "Now");
                    },
                  ),
          ),

          // Current Chat
          Expanded(
            child: Container(
        decoration: selectedChat == null
          ? null
          : const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("background_chat/chat.jpg"),
                fit: BoxFit.cover,
              ),
            ),
      child: selectedChat == null
          ? const Center(
              child: Text(
                "Open a chat",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
          )
                  : Column(
                      children: [

                       Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(12),
                          children: messages[selectedChat]?.map((msg) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  msg,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }).toList() ?? [],
                        ),
                      ),


                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          color: Colors.black,
                          child: Row(
                            children: [

                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: "Type a message",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.send, color: Colors.green),
                                onPressed: () {
                                final text = messageController.text.trim();

                                if (text.isNotEmpty && selectedChat != null) {
                                  setState(() {
                                    messages.putIfAbsent(selectedChat!, () => []);
                                    messages[selectedChat!]!.add(text);
                                  });

                                  messageController.clear();
                                }
                              },

                              )

                            ],
                          ),
                        )

                      ],
                    ),
            ),
          ),
        ],
      )
    );
  }

  Widget chatTile(String name, String message, String time) {
    return Material(
      color: selectedChat == name ? Colors.grey[900] : Colors.black,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedChat = name;
          });
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
