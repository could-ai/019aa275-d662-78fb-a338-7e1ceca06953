import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ali Poster Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFE2C55), // TikTok Red/Pink
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const PosterCreatorScreen(),
    );
  }
}

class PosterCreatorScreen extends StatefulWidget {
  const PosterCreatorScreen({super.key});

  @override
  State<PosterCreatorScreen> createState() => _PosterCreatorScreenState();
}

class _PosterCreatorScreenState extends State<PosterCreatorScreen> {
  // State Variables
  int _selectedTemplateIndex = 0;
  Uint8List? _imageBytes1;
  Uint8List? _imageBytes2;
  
  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  final TextEditingController _time1Controller = TextEditingController();
  final TextEditingController _country1Controller = TextEditingController();
  final TextEditingController _time2Controller = TextEditingController();
  final TextEditingController _country2Controller = TextEditingController();

  // TikTok Brand Colors
  final Color _tiktokCyan = const Color(0xFF25F4EE);
  final Color _tiktokPink = const Color(0xFFFE2C55);
  final Color _tiktokBlack = const Color(0xFF000000);
  final Color _tiktokWhite = const Color(0xFFFFFFFF);

  late List<Gradient> _templates;

  @override
  void initState() {
    super.initState();
    _generateTemplates();
    // Set default date
    // Date is automatic in the widget, but we can store it if needed.
  }

  void _generateTemplates() {
    _templates = [
      // 1. Classic Dark
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_tiktokBlack, const Color(0xFF1A1A1A)],
      ),
      // 2. Cyan to Pink (TikTok Gradient)
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_tiktokCyan.withOpacity(0.2), _tiktokPink.withOpacity(0.2)],
      ),
      // 3. Deep Blue
      const LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)]),
      // 4. Purple Haze
      const LinearGradient(colors: [Color(0xFF2E1437), Color(0xFF948E99)]),
      // 5. Red Accent
      LinearGradient(colors: [Colors.black, _tiktokPink.withOpacity(0.4)]),
      // 6. Cyan Accent
      LinearGradient(colors: [Colors.black, _tiktokCyan.withOpacity(0.4)]),
      // 7. Midnight
      const LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)]),
      // 8. Royal Gold
      const LinearGradient(colors: [Color(0xFF141E30), Color(0xFF243B55)]),
      // 9. Clean Grey
      const LinearGradient(colors: [Color(0xFF304352), Color(0xFFd7d2cc)]),
      // 10. Neon Vibes
      LinearGradient(colors: [Colors.black, Colors.purple.shade900]),
      // 11. Intense Red
      LinearGradient(colors: [Color(0xFF870000), Color(0xFF190A05)]),
      // 12. Ocean
      LinearGradient(colors: [Color(0xFF000046), Color(0xFF1CB5E0)]),
      // 13. Forest
      LinearGradient(colors: [Color(0xFF134E5E), Color(0xFF71B280)]),
      // 14. Sunset
      LinearGradient(colors: [Color(0xFF0B486B), Color(0xFFF56217)]),
      // 15. Pure Black
      const LinearGradient(colors: [Colors.black, Colors.black]),
    ];
  }

  Future<void> _pickImage(int slot) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        if (slot == 1) {
          _imageBytes1 = bytes;
        } else {
          _imageBytes2 = bytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ali Poster Creator"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 1. The Poster Preview Area
          Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _buildPoster(),
              ),
            ),
          ),
          
          // 2. Controls Area
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[900],
              child: Column(
                children: [
                  // Template Selector
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _templates.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTemplateIndex = index),
                          child: Container(
                            width: 44,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              gradient: _templates[index],
                              border: _selectedTemplateIndex == index 
                                ? Border.all(color: _tiktokCyan, width: 2) 
                                : Border.all(color: Colors.white24),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Input Fields
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text("بيانات المتنافسين", style: TextStyle(color: Colors.white70), textAlign: TextAlign.right),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(_name2Controller, "اسم المتنافس 2 (يسار)")),
                            const SizedBox(width: 10),
                            Expanded(child: _buildTextField(_name1Controller, "اسم المتنافس 1 (يمين)")),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text("التوقيت والدولة", style: TextStyle(color: Colors.white70), textAlign: TextAlign.right),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(_country1Controller, "الدولة 1")),
                            const SizedBox(width: 5),
                            Expanded(child: _buildTextField(_time1Controller, "التوقيت 1")),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(_country2Controller, "الدولة 2")),
                            const SizedBox(width: 5),
                            Expanded(child: _buildTextField(_time2Controller, "التوقيت 2")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
        filled: true,
        fillColor: Colors.white10,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (val) => setState(() {}), // Rebuild poster on type
    );
  }

  Widget _buildPoster() {
    // Aspect ratio for a poster (e.g., 4:5 or similar)
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: _templates[_selectedTemplateIndex],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: Stack(
          children: [
            // Signature (Top Left)
            Positioned(
              top: 12,
              left: 12,
              child: Text(
                "ali poster creator",
                style: GoogleFonts.dancingScript(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                
                // Header: جولة رسمية
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "جولة",
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [const Shadow(color: Colors.black, blurRadius: 10)],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // TikTok Logo Placeholder
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: _tiktokCyan, width: 1),
                            boxShadow: [BoxShadow(color: _tiktokPink, blurRadius: 5)],
                          ),
                          child: const Icon(Icons.music_note, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "رسمية",
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [const Shadow(color: Colors.black, blurRadius: 10)],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 2,
                      width: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [_tiktokCyan, _tiktokPink]),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // Competitors Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Competitor 2 (Left)
                      Expanded(child: _buildCompetitorColumn(2, _imageBytes2, _name2Controller.text)),
                      
                      // VS
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Text(
                              "VS",
                              style: GoogleFonts.russoOne(
                                fontSize: 36,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                shadows: [
                                  Shadow(color: _tiktokPink, blurRadius: 15),
                                  Shadow(color: _tiktokCyan, blurRadius: 15, offset: const Offset(-2, -2)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Competitor 1 (Right)
                      Expanded(child: _buildCompetitorColumn(1, _imageBytes1, _name1Controller.text)),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Date and Time Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      // Date
                      Text(
                        DateFormat('dd / MM / yyyy').format(DateTime.now()),
                        style: GoogleFonts.robotoMono(
                          color: _tiktokCyan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const Divider(color: Colors.white12, height: 16),
                      // Times
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTimeBlock(_time2Controller.text, _country2Controller.text),
                          Container(width: 1, height: 30, color: Colors.white24),
                          _buildTimeBlock(_time1Controller.text, _country1Controller.text),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Footer: Sponsor
                Column(
                  children: [
                    Text(
                      "YOUR DREAM AGENCY",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28, // Same visual weight as header
                        letterSpacing: 3,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: _tiktokPink, blurRadius: 8, offset: const Offset(1, 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "OFFICIAL SPONSOR",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitorColumn(int slot, Uint8List? imageBytes, String name) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(slot),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: slot == 1 ? _tiktokCyan : _tiktokPink,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (slot == 1 ? _tiktokCyan : _tiktokPink).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ],
              color: Colors.black26,
            ),
            child: ClipOval(
              child: imageBytes != null
                  ? Image.memory(imageBytes, fit: BoxFit.cover)
                  : Icon(Icons.add_a_photo, color: Colors.white54, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                (slot == 1 ? _tiktokCyan : _tiktokPink).withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: Text(
            name.isEmpty ? "الاسم" : name,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBlock(String time, String country) {
    return Column(
      children: [
        Text(
          time.isEmpty ? "--:--" : time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          country.isEmpty ? "الدولة" : country,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
