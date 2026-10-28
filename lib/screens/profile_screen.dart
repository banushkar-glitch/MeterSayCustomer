import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3C65A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔝 TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, size: 28),
                    const Text(
                      "My Profile",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.notifications_none, size: 28),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 👤 PROFILE IMAGE
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),

              const SizedBox(height: 15),

              // 👤 NAME (Backend replace)
              const Text(
                "Driver Name",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              // ⭐ RATING (Backend replace)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 5),
                  Text("Rating", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 25),

              // 📄 DETAILS CARD
              _buildInfoCard(),

              const SizedBox(height: 20),

              // ⚙️ SETTINGS CARD
              _buildSettingsCard(context),

              const SizedBox(height: 25),

              // 🔴 LOGOUT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // 🔴 LOGOUT LOGIC (backend)
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 📄 INFO CARD
  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [

            _infoRow(Icons.credit_card, "DL Number", "MH 12 XXXX XXXXXX"),
            const Divider(),

            _infoRow(Icons.directions_car, "Vehicle Number", "MH XXXXXX"),
            const Divider(),

            _infoRow(Icons.phone, "Phone", "+91XXXXXXXXXX"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          Text(
            value, // 🔗 backend replace
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ⚙️ SETTINGS CARD
  Widget _buildSettingsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [

            _settingItem(
              context,
              Icons.person_outline,
              "Edit Profile",
              onTap: () {
                // 👉 Navigate to Edit Profile
              },
            ),

            const Divider(),

            _settingItem(
              context,
              Icons.language,
              "Language",
              onTap: () {
                // 👉 Open Language Screen
              },
            ),

            const Divider(),

            _settingItem(
              context,
              Icons.help_outline,
              "Help",
              onTap: () {
                // 👉 Help screen
              },
            ),

            const Divider(),

            _settingItem(
              context,
              Icons.description_outlined,
              "Terms & Conditions",
              onTap: () {
                // 👉 Terms screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(
      BuildContext context,
      IconData icon,
      String title, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap, // ✅ clickable
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}