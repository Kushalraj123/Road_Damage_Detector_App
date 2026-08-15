import 'package:flutter/material.dart';
import 'package:routefixer/constants.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          _buildFAQHeader("Frequently Asked Questions"),
          const SizedBox(height: 10),
          
          _buildFAQItem(
            "How do I report road damage?",
            "Navigate to the 'Reports' tab and click the '+' button at the bottom right. Snap a picture of the damage, add a description, and tap Submit. The app automatically fetches your GPS coordinates.",
          ),
          _buildFAQItem(
            "What do the colored segment lines mean?",
            "The colored lines on the map display verified road damage severity:\n"
                "• Red: High Severity (Dangerous potholes/deep cracks)\n"
                "• Orange: Medium Severity (Moderate surface damage/rutting)\n"
                "• Yellow: Low Severity (Minor cracking/raveling)",
          ),
          _buildFAQItem(
            "How long does verification take?",
            "Once reported, submissions undergo verification by our AI model and the local administrative team. Verification typically takes 24 to 48 hours.",
          ),
          _buildFAQItem(
            "How do I sign up as an administrator?",
            "Click on the 'Administrative login?' link on the welcome intro page, select 'Register here', enter your details, and provide the Admin Security Key.",
          ),
          
          const Divider(height: 40),
          _buildFAQHeader("Contact Support"),
          const SizedBox(height: 12),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: AppColors.primary),
                      SizedBox(width: 10),
                      Text("Email Support", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text("kushalrajm856@gmail.com", style: TextStyle(color: Colors.blue, fontSize: 15)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: AppColors.primary),
                      SizedBox(width: 10),
                      Text("Helpline", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text("+91 7019946142", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(height: 1.3, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
