import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crisis = data['crisis'];
    final actionPlan = data['action_plan'];
    final simulation = data['simulation'];
    final agentTrace = data['agent_trace'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Response Plan'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black87, // dark background for whole screen
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crisis Detection Card
              Card(
                elevation: 4,
                color: Colors.grey.shade900, // dark card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade400, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Detected Crisis',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _infoRow('Situation', crisis['situation'], Colors.white),
                      _infoRow('Severity', crisis['severity'], Colors.white),
                      _infoRow(
                          'Confidence', '${(crisis['confidence'] * 100).toStringAsFixed(0)}%', Colors.white),
                      _infoRow('Affected Area', crisis['affected_area'], Colors.white),
                      const SizedBox(height: 8),
                      Text('Impact:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(crisis['impact_description'], style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text('Reasoning:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(crisis['reasoning_summary'], style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recommended Actions Card
              Card(
                elevation: 4,
                color: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.playlist_add_check, color: Colors.blue.shade300, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Recommended Actions',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(actionPlan['actions'].length, (index) {
                        String action = actionPlan['actions'][index];
                        String detail = actionPlan['details'][action] ?? 'No reason provided.';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• $action',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(detail, style: TextStyle(fontSize: 14, color: Colors.white70)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Simulation Outcome Card
              Card(
                elevation: 4,
                color: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.computer, color: Colors.green.shade300, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Simulation Outcome',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _simulationRow('Route Updated', simulation['route_updated'], Colors.white),
                      _simulationRow('Alert Sent', simulation['alert_sent'], Colors.white),
                      _simulationRow('Emergency Ticket Created',
                          simulation['emergency_ticket_created'], Colors.white),
                      const Divider(color: Colors.grey),
                      _infoRow('Traffic Before', simulation['traffic_mock_before'], Colors.white),
                      _infoRow('Traffic After', simulation['traffic_mock_after'], Colors.white),
                      const Divider(color: Colors.grey),
                      Text('Outcome:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(simulation['outcome'], style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Agent Trace (Expandable)
              Card(
                elevation: 4,
                color: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Icon(Icons.analytics, color: Colors.purple.shade300),
                    title: Text(
                      'Agent Trace (Antigravity Logs)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                    subtitle: Text('Show reasoning steps, tool calls, and decisions', style: TextStyle(color: Colors.white70)),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: agentTrace.length,
                        itemBuilder: (context, index) {
                          final log = agentTrace[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            color: Colors.grey.shade800,
                            child: ListTile(
                              title: Text(
                                log['step'],
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(log['timestamp'], style: TextStyle(color: Colors.white54)),
                                  const SizedBox(height: 4),
                                  Text(
                                    log['data'].toString(),
                                    style: TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('New Crisis'),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  Widget _infoRow(String label, String? value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text('$label:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor))),
          Expanded(child: Text(value ?? 'N/A', style: TextStyle(color: textColor))),
        ],
      ),
    );
  }

  Widget _simulationRow(String label, bool success, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.cancel,
            color: success ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 16, color: textColor)),
          const Spacer(),
          Text(success ? 'Executed' : 'Not executed',
              style: TextStyle(color: success ? Colors.green : Colors.red)),
        ],
      ),
    );
  }
}