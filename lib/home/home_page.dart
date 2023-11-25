import '../core/data.dart';
import 'make_request.dart';
import '../journal/journal_editing_page.dart';
import 'video_page.dart';
import 'chat_page.dart';
import 'package:flutter/material.dart';
import '../core/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:device_apps/device_apps.dart';
import 'apps_page.dart';
import '../settings/apps_selection_page.dart';

class MentorPage extends StatefulWidget {
  const MentorPage({super.key});

  @override
  _MentorPageState createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  int _selectedIndex = 0;
  final interestController = TextEditingController();

  String interest = '';
  String result = '';
  bool isLoading = false;
  List<Messages> messages_data = [];
  List<Video> videos = [];
  Loader loader = Loader();
  List<Application> selected_apps_data = [];
  String serverurl = '';

  List<Application> loadedApps = [];

  //Gets user's usage data
  void _Makerequest(String interest) async {
    setState(() {
      isLoading = true;
      videos.clear(); // Clear previous videos
      Data.videoList.clear();
    });
    DataProcessor dataGetter = DataProcessor(context);
    try {
      await dataGetter.execute();
    } catch (e) {
      setState(() {
        isLoading = false;
        result = e.toString();
      });
    }

    setState(() {
      isLoading = false;
      result = Data.completion_message;
      videos = Data.videoList;
    });
  }

  @override
  void initState() {
    super.initState();
    loader.loadSelectedApps();
    check_permissions();

    loader.loadcompletion().then((completionMessage) {
      setState(() {
        Data.completion_message = completionMessage ?? "";
        result = Data.completion_message;
        selected_apps_data = Data.selected_apps;
      });
    });
  }

  void check_permissions() async {
    bool? isPermission = await UsageStats.checkUsagePermission();
    if (isPermission == false) {
      PhoneUsage.showPermissionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mentor')),
        body: SingleChildScrollView(
          // Wrap the body with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                    color: const Color.fromARGB(255, 19, 19, 19),
                    child: ListTile(
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppSelectionPage()),
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AppsPage()),
                        );
                      },
                      title: const Text(
                        "Apps",
                      ),
                      subtitle: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: selected_apps_data.length,
                          itemBuilder: (context, index) {
                            final Application app = selected_apps_data[index];
                            return ListTile(
                              onTap: () async {
                                bool isInstalled =
                                    await DeviceApps.isAppInstalled(
                                        app.packageName);
                                if (isInstalled) {
                                  DeviceApps.openApp(app.packageName);
                                }
                              },
                              title: Text(
                                app.appName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                    )),
                const SizedBox(height: 16.0),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(Data.userId)
                      .collection("journal")
                      .orderBy('title', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final journalDocs = snapshot.data?.docs;

                    if (journalDocs == null || journalDocs.isEmpty) {
                      return const Text(
                          'Not wrote a journal yet? Go to journal page');
                    }

                    final lastJournalData =
                        journalDocs[0].data() as Map<String, dynamic>;
                    final timestamp = lastJournalData['title'] as Timestamp;
                    var format = new DateFormat('H:m d-M-y');

                    final lastJournalTitle = format.format(timestamp.toDate());
                    final lastJournalContent =
                        lastJournalData['content'] as String;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: ListTile(
                            title: Text(
                              lastJournalTitle,
                            ),
                            subtitle: Text(
                              lastJournalContent,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JournalEditingPage(
                                    journalTitle: lastJournalTitle,
                                    journalContent: lastJournalContent,
                                    documentId: journalDocs[0].id,
                                    userId: Data.userId.toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                if (isLoading)
                  const Column(children: [
                    SizedBox(height: 16),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "YOLO",
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Please be patient",
                    )
                  ])
                else
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(response: result)),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Mentor"),
                              IconButton(
                                  tooltip: "Reload",
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      _Makerequest(interest);
                                    });
                                  },
                                  icon: const Icon(Icons.refresh)),
                            ],
                          ),
                          subtitle: Text(
                            "${result} \n Click to chat with mentor",
                          ),
                        ),
                      )),
                const SizedBox(height: 16.0),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];

                    return Card(
                        color: const Color.fromARGB(255, 19, 19, 19),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPage(
                                    videoId: video.videoId,
                                    description: video.videoDescription),
                              ),
                            );
                          },
                          title: Text(
                            video.title,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 50, 204, 102),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/mentor');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/journal');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/settings');
                  break;
              }
            });
          },
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.book),
              label: 'Journal',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}
