import 'package:conavigator/map.dart';
import 'package:conavigator/store/app.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class App extends StatelessWidget {
  final Store<AppState> store;

  // ignore: prefer_const_constructors_in_immutables
  App({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: const Main(title: 'Conavigator'),
        ));
  }
}

class LeftNav extends StatelessWidget {
  const LeftNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
        ),
        ListTile(
          leading: Icon(Icons.accessible_forward),
          title: Text('Find route'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
    );
  }
}

class Main extends StatelessWidget {
  final String title;
  const Main({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Widget body = media.size.aspectRatio >= 1
        ? Row(children: const [
            SizedBox(width: 250, child: LeftNav()),
            Expanded(child: UberMapContainer())
          ])
        : const Center(child: UberMapContainer());

    return Scaffold(
      body: body,
      bottomNavigationBar: media.size.aspectRatio < 1
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.accessible_forward),
                  label: 'Find route',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: 1,
            )
          : null,
    );
  }
}
