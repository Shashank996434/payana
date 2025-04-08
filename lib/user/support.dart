import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuppWidget extends StatefulWidget {
  const SuppWidget({super.key});

  static String routeName = 'supp';
  static String routePath = '/supp';

  @override
  State<SuppWidget> createState() => _SuppWidgetState();
}

class _SuppWidgetState extends State<SuppWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Help and Support',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help you?',
                  style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _supportOption(
                        icon: Icons.local_phone,
                        label: 'Call Us',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _supportOption(
                        icon: Icons.email_outlined,
                        label: 'Email Us',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Review FAQs below',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                _faqItem('How to solve vehicle issue?',
                    'There is an issue with the vehicle.'),
                _faqItem('Vehicle was not received',
                    'I booked a vehicle but did not receive it.'),
                _faqItem('Payment issue', 'I had a payment issue.'),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.receipt_long),
                  label: Text('Create Ticket'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _supportOption({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 36),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _faqItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
