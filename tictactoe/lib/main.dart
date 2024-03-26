import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/theme/theme_provider.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
           appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
          drawer: Drawer(
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle navigation to home page
                      Navigator.pop(context); // Close the drawer
                      // You can add navigation logic here
                    },
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height:
                          20), // Add spacing between "Home" and CupertinoSwitch
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      "TIC TAC TOE",
                      style: GoogleFonts.pressStart2p(
                          textStyle:
                              TextStyle(
                                fontSize: 30.0,
                                color: Theme.of(context).colorScheme.inversePrimary, letterSpacing: 3)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: AvatarGlow(
                      duration: Duration(seconds: 2),
                      glowColor: Colors.white,
                      repeat: true,
                      startDelay: Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              style: BorderStyle.none,
                            ),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[900],
                          // ignore: sort_child_properties_last
                          radius: 80.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Container(
                      child: Text(
                        "@TWEAKERS",
                        style: GoogleFonts.pressStart2p(
                            textStyle: TextStyle(
                              fontSize: 20.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                letterSpacing: 3)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: Text(
                            'PLAY GAME',
                            style: GoogleFonts.pressStart2p(
                                textStyle: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    letterSpacing: 2)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
