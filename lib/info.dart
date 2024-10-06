import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InfoTab extends StatefulWidget {
  const InfoTab({Key? key}) : super(key: key);

  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  late Future<List<dynamic>> _infoList;

  @override
  void initState() {
    super.initState();
    _infoList = fetchInfo();
  }

  Future<List<dynamic>> fetchInfo() async {
    final response = await http.get(
        Uri.parse('https://ujikom2024pplg.smkn4bogor.sch.id/0075698474/info.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _infoList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No information available'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final infoItem = snapshot.data![index];
              return InfoCard(infoItem: infoItem);
            },
          );
        }
      },
    );
  }
}

class InfoCard extends StatefulWidget {
  final dynamic infoItem;

  const InfoCard({Key? key, required this.infoItem}) : super(key: key);

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String shortDescription = widget.infoItem['isi_info'];
    bool isLongText = shortDescription.length > 100;

    // Limit the description to 100 characters if not expanded
    if (!_isExpanded && isLongText) {
      shortDescription = shortDescription.substring(0, 100) + '...';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.infoItem['judul_info'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              shortDescription,
              style: const TextStyle(fontSize: 14.0, height: 1.5),
            ),
            if (isLongText)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded; // Toggle the text expansion
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Baca Lebih Sedikit' : 'Baca Selengkapnya',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            _buildInfoRow('Status:', widget.infoItem['status_info']),
            _buildInfoRow('Posted by (Petugas):', widget.infoItem['kd_petugas']),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Date Posted: ${widget.infoItem['tgl_post_info']}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
