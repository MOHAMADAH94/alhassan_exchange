import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/branch.dart';
import '../services/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  late Future<List<Branch>> futureBranches;
  final ApiService apiService = ApiService();
  static const goldenColor = Color(0xFFFFD700);
  static const cardColor = Color(0xFF1E1E1E);
  final String companyWhatsapp = "+905343100252"; // استبدل برقم استعلامات الشركة الحقيقي

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      futureBranches = apiService.fetchBranches();
    });
  }

  Future<void> _launchWhatsApp() async {
    final url = 'https://wa.me/$companyWhatsapp?text=${Uri.encodeFull('مرحباً، أريد الاستفسار عن خدمات شركة الحسان')}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح تطبيق واتساب'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Branch>>(
              future: futureBranches,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildBranchesPage(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'حدث خطأ في تحميل البيانات',
                          style: TextStyle(
                            fontFamily: 'ithra',
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldenColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          onPressed: _loadData,
                          child: const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: 'ithra',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: goldenColor,
                    strokeWidth: 3,
                  ),
                );
              },
            ),
          ),
          // زر التواصل مع الاستعلامات في الأسفل

        ],
      ),
    );
  }

  Widget _buildBranchesPage(List<Branch> branches) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: goldenColor,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        itemCount: branches.length,
        itemBuilder: (context, index) => _buildBranchCard(branches[index]),
      ),
    );
  }

  Widget _buildBranchCard(Branch branch) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!, width: 1),
          ),
          child: ExpansionTile(
            leading: const Icon(Icons.store, color: goldenColor, size: 28),
            title: Text(
              branch.name,
              style: const TextStyle(
                fontFamily: 'ithra',
                fontWeight: FontWeight.bold,
                color: goldenColor,
                fontSize: 18,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoRow(Icons.location_on, branch.city),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.add_home_work_outlined, branch.address),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'ithra',
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}