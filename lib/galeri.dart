import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class GalleryTab extends StatefulWidget {
  const GalleryTab({super.key});

  @override
  _GalleryTabState createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  late Future<List<dynamic>> _galleryList;

  @override
  void initState() {
    super.initState();
    _galleryList = fetchGallery();
  }

  Future<List<dynamic>> fetchGallery() async {
    final response = await http.get(
        Uri.parse('https://ujikom2024pplg.smkn4bogor.sch.id/0075698474/galery.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load gallery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _galleryList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No gallery available'));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of cards per row
              crossAxisSpacing: 12.0, // Space between columns
              mainAxisSpacing: 12.0, // Space between rows
              childAspectRatio: 0.8, // Adjust the height-to-width ratio
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final galleryItem = snapshot.data![index];
              return Card(
                margin: EdgeInsets.zero, // No extra margin for cleaner alignment
                elevation: 2, // Slight shadow for card separation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Smooth border radius
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0), // Neat padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        galleryItem['judul_galery'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0, // Subtle title font size
                        ),
                        maxLines: 1, // One-line title for neatness
                        overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                      ),
                      const SizedBox(height: 8),
                      _buildGalleryContent(galleryItem['isi_galery']),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${galleryItem['status_galery']}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0, // Smaller italic font for status
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Posted by: ${galleryItem['kd_petugas']}',
                        style: const TextStyle(
                          fontSize: 10.0, // Subtle detail font size
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          galleryItem['tgl_post_galery'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0, // Small font for date
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Method to handle the content rendering (SVG or image)
  Widget _buildGalleryContent(String content) {
    if (content.endsWith('.svg')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Reduced padding
        child: Center(
          child: SizedBox(
            height: 80.0, // SVG size reduced for compactness
            child: SvgPicture.network(
              content,
              placeholderBuilder: (context) => const CircularProgressIndicator(),
            ),
          ),
        ),
      );
    } else if (content.endsWith('.jpg') || content.endsWith('.jpeg') || content.endsWith('.png')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Reduced padding
        child: Center(
          child: SizedBox(
            height: 85.0, // Compact size for images
            width: 85.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                content,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Reduced padding
        child: Text(content),
      );
    }
  }
}
