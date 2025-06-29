import 'package:flutter/material.dart';
import 'appointments_page.dart';
import 'therapist_list.dart';
import 'self_care_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HarmoniCare'),
        backgroundColor: Color(0xFF809694),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.white,
            height: 1.0, // Thin line height
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dramatic header with curves
            Stack(
              children: [
                ClipPath(
                  clipper: WavyClipper(),
                  child: Container(
                    height: 250,
                    color: Color(0xFF809694),
                  ),
                ),
                Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: Text(
                    'Therapy helps you grow,\nfind balance and heal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Larger containers for main options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCardOption(
                    title: 'Therapist list',
                    icon: Icons.person_search,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TherapistList()),
                    ),
                  ),
                  _buildCardOption(
                    title: 'Book Appointment',
                    icon: Icons.calendar_today,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppointmentsPage()),
                    ),
                  ),
                  _buildCardOption(
                    title: 'Self Care',
                    icon: Icons.self_improvement,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelfCareScreen()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Stay Up To Date section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stay Up To Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'There is always something new! Check out the latest news and stay updated with our updates.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Function to build each card option
  Widget _buildCardOption({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120, // Increased size
        height: 150, // Increased size
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Slightly more rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF809694)), // Larger icon
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, // Slightly larger text
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom WavyClipper for the header
class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
