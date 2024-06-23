import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  bool isConnected = false;
  VpnConfiguration? selectedServer;
  List<VpnConfiguration> servers = [];
  bool isLoading = true;
  String currentStage = "Disconnected";

  @override
  void initState() {
    super.initState();
    engine = OpenVPN(
      onVpnStatusChanged: _onVpnStatusChanged,
      onVpnStageChanged: _onVpnStageChanged,
    );
    engine.initialize(
      groupIdentifier: "group.com.example.vpnapp",
      providerBundleIdentifier: "com.example.vpnapp.VPNExtension",
      localizedDescription: "VPN App",
    );
    _loadServers();
  }

  Future<void> _loadServers() async {
    try {
      final loadedServers = await ApiService.getVpnConfigurations();
      setState(() {
        servers = loadedServers;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading servers: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onVpnStatusChanged(VpnStatus? vpnStatus) {
    if(vpnStatus == null) return;
    setState(() {
      status = vpnStatus;
      isConnected = vpnStatus.connectedOn != null;
    });
  }

  void _onVpnStageChanged(VPNStage? vpnStage, String? message) {
    String msg = "Disconnected";
    if( vpnStage == VPNStage.connecting){
        msg = "Connecting...";
    }else if( vpnStage == VPNStage.connected){
      msg ="Connected";
    }else if( vpnStage == VPNStage.disconnecting){
      msg = "Disconnecting";
    }else if( vpnStage == VPNStage.disconnected){
      msg = "Disconnected";
    }
    setState(() {
      stage = vpnStage;
      currentStage = msg;
    });
  }

  void _connectVPN() {
    if (selectedServer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a server first')),
      );
      return;
    }

    engine.connect(
      selectedServer!.openVpnConfigData,
      selectedServer!.hostName,
      // username: 'vpn_username',
      // password: 'vpn_password',
      bypassPackages: [],
      // certIsRequired: true,
    );
  }

  void _disconnectVPN() {
    engine.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    var status;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (isConnected) {
                  _disconnectVPN();
                } else {
                  _connectVPN();
                }
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected ? Color(0xFF17692D) : Color(0xFF006064),
                ),
                child: Center(
                  child: Text(
                    isConnected ? 'Stop' : 'Start',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              currentStage,
              style: TextStyle(
                color: isConnected ? Color(0xFF17692D) : Color(0xFFB22438),
                fontSize: 18,
              ),
            ),
            if (isConnected) ...[
              SizedBox(height: 10),
              Text(
                'VPN Status: ${status?.status.toString() ?? 'Unknown'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<VpnConfiguration>(
                  context: context,
                  builder: (context) => ServerList(servers: servers),
                  backgroundColor: Colors.transparent,
                );
                if (result != null) {
                  setState(() {
                    selectedServer = result;
                  });
                }
              },
              child: Container(
                width: 254,
                height: 43,
                decoration: BoxDecoration(
                  color: Color(0xFF242425),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        selectedServer?.countryLong ?? 'Select Server',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServerList extends StatelessWidget {
  final List<VpnConfiguration> servers;

  ServerList({required this.servers});

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
                  onTap: () => Navigator.pop(context, server),
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
                          server.countryLong,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                server.hostName,
                                style: TextStyle(color: Colors.white, fontSize: 16),
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