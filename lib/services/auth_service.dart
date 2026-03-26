// lib/services/auth_service.dart
// Serviço de autenticação mockado (sem banco de dados)
// Os dados ficam apenas na memória da sessão atual

class AuthUser {
  final String name;
  final String email;

  AuthUser({required this.name, required this.email});
}

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // "Banco de dados" em memória
  final Map<String, Map<String, String>> _users = {};

  // Usuário logado atualmente
  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Cadastrar novo usuário
  /// Retorna null se tudo OK, ou uma mensagem de erro
  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));

    final emailLower = email.toLowerCase().trim();

    if (_users.containsKey(emailLower)) {
      return 'Este e-mail já está cadastrado.';
    }

    _users[emailLower] = {
      'name': name.trim(),
      'password': password,
    };

    _currentUser = AuthUser(name: name.trim(), email: emailLower);
    return null; // sucesso
  }

  /// Fazer login
  /// Retorna null se tudo OK, ou uma mensagem de erro
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final emailLower = email.toLowerCase().trim();
    final user = _users[emailLower];

    if (user == null) {
      return 'E-mail não encontrado.';
    }

    if (user['password'] != password) {
      return 'Senha incorreta.';
    }

    _currentUser = AuthUser(name: user['name']!, email: emailLower);
    return null; // sucesso
  }

  /// Login com Google (mockado)
  Future<String?> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock: sempre "loga" com uma conta Google de demonstração
    const mockEmail = 'usuario.google@gmail.com';
    if (!_users.containsKey(mockEmail)) {
      _users[mockEmail] = {
        'name': 'Usuário Google',
        'password': '',
      };
    }

    _currentUser = AuthUser(name: 'Usuário Google', email: mockEmail);
    return null;
  }

  void logout() {
    _currentUser = null;
  }
}