import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendaTab extends StatefulWidget {
  const AgendaTab({super.key});

  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  late Future<List<dynamic>> _agendaList;

  @override
  void initState() {
    super.initState();
    _agendaList = fetchAgenda();
  }

  Future<List<dynamic>> fetchAgenda() async {
    final response = await http.get(
        Uri.parse('https://ujikom2024pplg.smkn4bogor.sch.id/0075698474/agenda.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load agenda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _agendaList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No agenda available'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final agendaItem = snapshot.data![index];
              return AgendaCard(agendaItem: agendaItem);
            },
          );
        }
      },
    );
  }
}

class AgendaCard extends StatefulWidget {
  final dynamic agendaItem;

  const AgendaCard({Key? key, required this.agendaItem}) : super(key: key);

  @override
  _AgendaCardState createState() => _AgendaCardState();
}

class _AgendaCardState extends State<AgendaCard> {
  bool _isExpanded = false;
  final int _maxLength = 100; // Batas panjang karakter

  @override
  Widget build(BuildContext context) {
    final String isiAgenda = widget.agendaItem['isi_agenda'];
    final bool shouldTruncate = isiAgenda.length > _maxLength;
    final String displayText = shouldTruncate && !_isExpanded
        ? isiAgenda.substring(0, _maxLength) + '...'
        : isiAgenda;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4, // Tambahkan bayangan lembut pada kartu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Beri sudut bulat
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Beri lebih banyak padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.agendaItem['judul_agenda'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              displayText,
              style: const TextStyle(fontSize: 14.0, height: 1.4), // Tinggi garis agar lebih nyaman dibaca
            ),
            if (shouldTruncate)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Baca Lebih Sedikit' : 'Baca Selengkapnya',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            const SizedBox(height: 10),
            _buildInfoRow('Agenda Date:', widget.agendaItem['tgl_agenda']),
            _buildInfoRow('Status:', widget.agendaItem['status_agenda']),
            _buildInfoRow('Agenda ID:', widget.agendaItem['kd_agenda']),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Posted on: ${widget.agendaItem['tgl_post_agenda']}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Membuat row untuk informasi
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
