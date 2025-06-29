import 'package:flutter/material.dart';

class SelfCareScreen extends StatefulWidget {
  const SelfCareScreen({Key? key}) : super(key: key);

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  List<String> quotes = [
    "You are enough just as you are.",
    "Self-care is not selfish.",
    "Progress, not perfection.",
    "Be patient with yourself."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Care'),
        backgroundColor: Color(0xFF809694), // Matching the color scheme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expanded list of quotes with updated styling
            Expanded(
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        quotes[index],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Add Quote button with improved styling
            ElevatedButton(
              onPressed: () {
                // Add a motivational quote
                setState(() {
                  quotes.add("Believe in yourself and all that you are.");
                });
              },
              child: const Text('Add Quote'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF809694), // Matching the color scheme
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
