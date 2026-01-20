import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WhatsAppScreen extends StatefulWidget {
  const WhatsAppScreen({super.key});

  @override
  State<WhatsAppScreen> createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen> {

  List<Map<String, String>> chats = [];
  String? selectedChat;
  final messageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  String getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0
        ? "${uid1}_$uid2"
        : "${uid2}_$uid1";
  }



  Future<void> loadChats() async {

  final myUid = _auth.currentUser!.uid;

  final snapshot = await _firestore
      .collection("chats")
      .where("users", arrayContains: myUid)
      .get();

  List<Map<String, String>> temp = [];

  for (var doc in snapshot.docs) {

    final users = List<String>.from(doc["users"]);

    final otherUid = users.firstWhere((u) => u != myUid);

    final userDoc = await _firestore
        .collection("users")
        .doc(otherUid)
        .get();

    temp.add({
      "chatId": doc.id,
      "email": userDoc["email"],
    });
  }

  setState(() {
    chats = temp;
  });
}


  @override
  void initState() {
    super.initState();
    loadChats();
  }



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
                onPressed: () async {
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

                    final myUid = _auth.currentUser!.uid;

                    final userSnap = await _firestore
                        .collection("users")
                        .where("email", isEqualTo: email)
                        .get();

                    if (userSnap.docs.isEmpty) {
                      setDialogState(() {
                        errorText = "User not found";
                      });
                      return;
                    }

                    final otherUid = userSnap.docs.first.id;

                    final chatId = getChatId(myUid, otherUid);

                    await _firestore
                        .collection("chats")
                        .doc(chatId)
                        .set({
                          "users": [myUid, otherUid],
                          "createdAt": FieldValue.serverTimestamp(),
                        });

                    loadChats();

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
                      return chatTile(chats[index]["email"]!, "Tap to open", "Now");
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
                        child: StreamBuilder(
                          stream: _firestore
                              .collection("chats")
                              .doc(selectedChat)
                              .collection("messages")
                              .orderBy("timestamp")
                              .snapshots(),

                          builder: (context, snapshot) {

                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final docs = snapshot.data!.docs;

                            return ListView(
                              padding: const EdgeInsets.all(12),
                              children: docs.map((doc) {
                                return Align(
                                  alignment: doc["sender"] == _auth.currentUser!.uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: doc["sender"] == _auth.currentUser!.uid
                                          ? Colors.green[700]
                                          : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      doc["text"],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
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
                                onPressed: () async {
                                final text = messageController.text.trim();

                                if (text.isNotEmpty && selectedChat != null) {

                                  final uid = _auth.currentUser!.uid;

                                  await _firestore
                                      .collection("chats")
                                      .doc(selectedChat)
                                      .collection("messages")
                                      .add({
                                        "text": text,
                                        "sender": uid,
                                        "timestamp": FieldValue.serverTimestamp(),
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
            selectedChat = chats.firstWhere((e) => e["email"] == name)["chatId"];
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
