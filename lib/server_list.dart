import 'package:flutter/material.dart';

class ServerList extends StatelessWidget {
  final List<Map<String, dynamic>> servers = [
    {'name': 'USA', 'flag': '🇺🇸', 'latency': 156},
    {'name': 'Japan', 'flag': '🇯🇵', 'latency': 156},
    {'name': 'Germany', 'flag': '🇩🇪', 'latency': 156},
    {'name': 'UK', 'flag': '🇬🇧', 'latency': 156},
    {'name': 'Netherlands', 'flag': '🇳🇱', 'latency': 156},
    {'name': 'South Africa', 'flag': '🇿🇦', 'latency': 156},
    {'name': 'India', 'flag': '🇮🇳', 'latency': 156},
    {'name': 'South Korea', 'flag': '🇰🇷', 'latency': 156},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 786,
      color: Color(0xFF181818),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Server',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];
                return GestureDetector(
                  onTap: () => Navigator.pop(context, '${server['flag']} ${server['name']}'),
                  child: Container(
                    width: 410,
                    height: 78,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF242425),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          server['flag'],
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                server['name'],
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                'Latency ${server['latency']}m',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Fast',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                        Icon(Icons.lock, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}