import 'dart:convert';
import 'package:http/http.dart' as http;

// class VpnConfiguration {
//   final String name;
//   final String country;
//   final String config;

//   VpnConfiguration({required this.name, required this.country, required this.config});

//   factory VpnConfiguration.fromJson(Map<String, dynamic> json) {
//     return VpnConfiguration(
//       name: json['name'],
//       country: json['country'],
//       config: json['config'],
//     );
//   }
// }

class VpnConfiguration {
  final String hostName;
  final String ip;
  // final int score;
  // final int ping;
  final int speed;
  final String countryLong;
  final String countryShort;
  // final int numVpnSessions;
  // final int uptime;
  // final int totalUsers;
  // final int totalTraffic;
  // final int logType;
  // final String operator;
  // final String message;
  final String openVpnConfigData;

  VpnConfiguration({
    required this.hostName,
    required this.ip,
    // required this.score,
    // required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    // required this.numVpnSessions,
    // required this.uptime,
    // required this.totalUsers,
    // required this.totalTraffic,
    // required this.logType,
    // required this.operator,
    // required this.message,
    required this.openVpnConfigData,
  });

  @override
  String toString(){
    return "${hostName}, $ip, \n$openVpnConfigData\n";
  }

  factory VpnConfiguration.fromCsv(String csv) {
    final fields = csv.split(',');

    print(fields[14]);
    final decodedStr = utf8.decode(base64Decode(fields[14].trim()));

    return VpnConfiguration(
      hostName: fields[0],
      ip: fields[1],
      // score: int.parse(fields[2]),
      // ping: int.parse(fields[3]),
      speed: int.parse(fields[4]),
      countryLong: fields[5],
      countryShort: fields[6],
      // numVpnSessions: int.parse(fields[7]),
      // uptime: int.parse(fields[8]),
      // totalUsers: int.parse(fields[9]),
      // totalTraffic: int.parse(fields[10]),
      // logType: int.parse(fields[11]),
      // operator: fields[12],
      // message: fields[13],
      openVpnConfigData: decodedStr,
    );
  }
}

List<VpnConfiguration> parseVpnConfigurations(String csvData) {
  // print("Data: $csvData");
  final lines = csvData.split('\n');
  final configs = <VpnConfiguration>[];
  for (int i = 0; i < lines.length; i++) {
    // print(line);
    // print("\n\n");
    if (lines[i].trim().isEmpty) {
      continue; // Skip empty lines
    }
    try {
      final config = VpnConfiguration.fromCsv(lines[i]);
      configs.add(config);
    } catch (e,st) {
      print('Error parsing line: $i \nError: $e');
    }
  }

  print("Configs: $configs");

  return configs;
}

class ApiService {
  static const String baseUrl = 'https://www.vpngate.net/api/iphone/'; // Replace with your actual API endpoint

  static Future<List<VpnConfiguration>> getVpnConfigurations() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
        // print(response.body);
        return parseVpnConfigurations(response.body);
    } else {
      throw Exception('Failed to load VPN configurations');
    }
  }
}