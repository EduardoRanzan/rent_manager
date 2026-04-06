import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/profile/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static String routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ProfileModel profile = ProfileModel();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 15,
            children: [
              Center(
                child: Column(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profile.image != null
                          ? NetworkImage(profile.image!)
                          : null,
                      child: profile.image == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Text(
                      profile.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      profile.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: Icons.edit,
                    label: 'Editar Perfil',
                    onTap: () {},
                    color: theme.colorScheme.primary,
                  ),
                  _actionButton(
                    icon: Icons.lock,
                    label: 'Senha',
                    onTap: () {},
                    color: theme.colorScheme.tertiary,
                  ),
                  _actionButton(
                    icon: Icons.logout,
                    label: 'Sair',
                    onTap: () {},
                    color: Colors.redAccent,
                  ),
                ],
              ),
              _infoCard(
                title: 'Telefone',
                subtitle: profile.fone,
                icon: Icons.phone,
                color: theme.colorScheme.primary,
              ),
              _infoCard(
                title: 'Endereço',
                subtitle: profile.address,
                icon: Icons.location_on,
                color: theme.colorScheme.secondary,
              ),
              _infoCard(
                title: 'Data de Nascimento',
                subtitle: DateFormat('dd/MM/yyyy').format(profile.birthDate),
                icon: Icons.cake,
                color: theme.colorScheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
