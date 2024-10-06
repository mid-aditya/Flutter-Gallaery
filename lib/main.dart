import 'package:flutter/material.dart';
import 'login.dart';
import 'info.dart';
import 'agenda.dart';
import 'galeri.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4 Gallery App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF121212),  // Dark background color
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
        ).copyWith(
          secondary: const Color(0xFF1E88E5),  // Bright blue for accents
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),  // Dark background
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFF1E88E5),  // Bright blue for selected tab
          unselectedLabelColor: Color(0xFFBBE1FA),  // Light blue for unselected tabs
          indicatorColor: Color(0xFF1E88E5),  // Bright blue indicator
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Center(
          child: Text(
            '4 Gallery App',
            style: TextStyle(color: Color(0xFF1E88E5)),  // Light blue text color
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E88E5)),  // Bright blue icon color
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: const Color(0xFF121212),  // Dark background color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1E88E5),  // Bright blue background color for drawer header
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Color(0xFFBBE1FA)),  // Light blue text color
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF1E88E5)),  // Bright blue icon color
              title: const Text('Logout', style: TextStyle(color: Color(0xFFBBE1FA))),  // Light blue text color
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.info),
                  text: 'Info',
                ),
                Tab(
                  icon: Icon(Icons.photo_library),
                  text: 'Gallery',
                ),
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: 'Agenda',
                ),
              ],
              labelColor: const Color(0xFF1E88E5),  // Bright blue for selected tab
              unselectedLabelColor: const Color(0xFFBBE1FA),  // Light blue for unselected tabs
              indicator: BoxDecoration(
                color: Colors.transparent,  // Remove underline
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    color: const Color(0xFF121212),  // Dark background color
                    child: const HomeTab(),
                  ),
                  Container(
                    color: const Color(0xFF121212),  // Dark background color
                    child: const InfoTab(),
                  ),
                  Container(
                    color: const Color(0xFF121212),  // Dark background color
                    child: const GalleryTab(),
                  ),
                  Container(
                    color: const Color(0xFF121212),  // Dark background color
                    child: const AgendaTab(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF121212), Color(0xFF333333)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome Text
                Text(
                  'Welcome to 4 Gallery App!',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Description Text
                Text(
                  'Discover, Create, and Share',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Button with hover animation
                HoverButton(
                  text: 'Get Started',
                  onPressed: () {
                    // Navigate to other page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NextPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const HoverButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isHovered ? 200 : 180,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: _isHovered ? Colors.white : Colors.blueAccent.shade700,
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.shade700.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: _isHovered ? Colors.white
              : Colors.blueAccent.shade700,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


// Placeholder page for navigation
class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
      ),
      body: const Center(
        child: Text("Welcome to the next page!"),
      ),
    );
  }
}
