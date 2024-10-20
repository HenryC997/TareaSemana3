import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    title: 'Nueva Rectificadora',
    home: const HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.red,
      fontFamily: 'Montserrat',
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 230, end: 270).animate(_controller);
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('usuario') ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName.isEmpty
            ? 'Nueva Rectificadora'
            : 'Bienvenido, $_userName'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Tooltip(
              message: 'Registrar',
              child: IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroPage()),
                  ).then((_) => _loadUserName());
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(150, 26, 206, 131),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SizedBox(
                    width: _animation.value,
                    height: _animation.value,
                    child: Image.asset(
                      'assets/images/logo.gif',
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'NUEVA RECTIFICADORA',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _userName.isEmpty
                    ? '¡Bienvenido a nuestra empresa!\nOfrecemos los mejores servicios de rectificación de motores.'
                    : '¡Hola $_userName, estás logueado!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 55, 5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Nosotros'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NosotrosPage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Servicios'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ServiciosPage()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 55, 5),
                    foregroundColor: Colors.white),
                child: const Text('Contacto'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactoPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de registro
class RegistroPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  RegistroPage({super.key});

  Future<void> _saveCredentials(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', _userController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Bienvenido, ${_userController.text}!'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                  _userController, 'Usuario', 'Por favor ingrese un usuario'),
              _buildTextField(_emailController, 'Email',
                  'Por favor ingrese un correo electrónico'),
              _buildTextField(_passwordController, 'Contraseña',
                  'Por favor ingrese una contraseña',
                  isPassword: true),
              _buildTextField(_phoneController, 'Teléfono',
                  'Por favor ingrese un teléfono'),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Registrar'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveCredentials(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorText,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}

// Otras páginas (NosotrosPage, ServiciosPage, ContactoPage) siguen igual...

// Página "Nosotros"
class NosotrosPage extends StatelessWidget {
  const NosotrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nosotros'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Somos una empresa al servicio de la comunidad\n'
            'con aproximadamente 20 años de experiencia, brindando eficiencia y calidad\n'
            '\nOfrecemos los mejores servicios de rectificación de motores.',
            style: TextStyle(fontSize: 26),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Página "Servicios"
class ServiciosPage extends StatelessWidget {
  const ServiciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Proveemos las mejores soluciones en reparación integral'
                  ' de motores al sector automotriz ecuatoriano,'
                  ' a través de procedimientos industriales de alta'
                  ' tecnología, técnicos comprometidos con la'
                  ' excelencia y una sólida estructura organizacional.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nuestros servicios constan de:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                _buildServiceBox('• Rectificación de cigueñales'),
                _buildServiceBox('• Rectificación de cabezotes'),
                _buildServiceBox('• Rectificación de bloques'),
                _buildServiceBox('• Rectificación de brazo de biela'),
                _buildServiceBox('• Armado de motores'),
                _buildServiceBox('• Soluciones personalizadas'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBox(String service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        service,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

// Página de contacto
class ContactoPage extends StatelessWidget {
  const ContactoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '         Agencia Matriz:'
                '\n Calle Chanchagua y Pilaló '
                '\n     (SECTOR LA GATAZO)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildContactInfo(
                icon: Icons.phone,
                text: 'Teléfonos: 02-3063 / 0983245830 ',
              ),
              const SizedBox(height: 10),
              _buildContactInfo(
                icon: Icons.access_time,
                text: 'Horarios de Atención:'
                    '\n Lunes a Viernes:'
                    ' 08:00 - 17:00'
                    '\n Sabados:'
                    ' 08:00 - 12:00',
              ),
              const SizedBox(height: 10),
              _buildContactInfo(
                icon: Icons.email,
                text: 'e-mail: info@nrectificadora.com',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
