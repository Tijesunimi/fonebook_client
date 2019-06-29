import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fonebook/config.dart';
import 'package:fonebook/models/user.dart';
import 'package:fonebook/models/contact.dart';

import 'package:fonebook/api/auth.dart';
import 'package:fonebook/api/contacts.dart';

import 'package:fonebook/screens/particles/contacts_list.dart';

class Homepage extends StatefulWidget {
  final bool isNewLogin;
  Homepage(this.isNewLogin);

  @override
  State<StatefulWidget> createState() => HomepageState(this.isNewLogin);
}

class HomepageState extends State<Homepage> {
  bool isNewLogin;

  HomepageState(this.isNewLogin);

  FlutterLocalNotificationsPlugin notificationsPlugin;

  ContactsApi contactsApi;
  AuthApi authApi;
  User loggedInUser;

  Future contacts;

  @override
  void initState() {
    initializeNotifications();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Config config = Config.of(context);
    loggedInUser = config.loggedInUser;
    contactsApi = ContactsApi(config.apiBaseUrl, config.loggedInUser);
    authApi = AuthApi(config.apiBaseUrl);

    contacts = contactsApi.fetchContactsAndCategories();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Fonebook'),
            bottom: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              tabs: <Widget>[Tab(text: 'Categories'), Tab(text: 'Contacts')],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: Text(loggedInUser.email),
                  accountName: Text(
                      "${loggedInUser.firstName} ${loggedInUser.lastName}"),
                ),
                Expanded(
                  child: Container(),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 0.5))),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () => doLogout(context),
                          child: Icon(Icons.exit_to_app)),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              FutureBuilder<Map<Object, dynamic>>(
                future: contacts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var categories = snapshot.data['categories'];
                    var contacts = snapshot.data['contacts'];
                    return getCategoriesListView(categories, contacts);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Could not fetch categories. Please connect to the internet and try again"),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder<Map<Object, dynamic>>(
                future: contacts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var contacts = snapshot.data['contacts'];
                    return ContactsList(contacts);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Could not fetch contact. Please connect to the internet and try again"),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              )
            ],
          )),
    );
  }

  Widget getCategoriesListView(List<String> categories, List<MainContact> contacts) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        var category = categories[index];

        return ListTile(
          title: Text(category),
          leading: Icon(Icons.category),
          onTap: () {
            Navigator.of(context).pushNamed(
                'category',
                arguments: {
                  'category': category,
                  'contacts': category == 'Uncategorized' ? contacts : contacts.where((c) => c.category == category).toList()
                }
            );
          },
        );
      },
    );
  }
  void doLogout(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Confirm Logout'),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                await authApi.logoutUser();
                Navigator.of(context).pop();
                Navigator.of(context).popAndPushNamed('intro');
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('No'),
            )
          ],
        ));
  }

  void doServerSync(List<MainContact> contacts) async {
    _showNotificationWithDefaultSound('Syncing', 'Currently syncing contacts');
    contactsApi.syncContactsToServer(contacts);
  }

  void initializeNotifications() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    notificationsPlugin = new FlutterLocalNotificationsPlugin();
    notificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    debugPrint('Notification selected');
  }

  Future _showNotificationWithDefaultSound(String title, String notification) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'dev.tijesunimi.fonebook', 'Fonebook', 'Phonebook application',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.show(
      0,
      title,
      notification,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
