import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// ═══════════════════════════════════════════
// FIREBASE CONFIG
// ═══════════════════════════════════════════
const _opts = FirebaseOptions(
  apiKey: 'AIzaSyDRCtfuYrEdnuKUsWu_79NC6G_xGLznBJc',
  appId: '1:975123752593:web:e591e930af3a3e29568130',
  messagingSenderId: '975123752593',
  projectId: 'tttrt-b8c5a',
  databaseURL: 'https://tttrt-b8c5a-default-rtdb.asia-southeast1.firebasedatabase.app',
  storageBucket: 'tttrt-b8c5a.firebasestorage.app',
);

// ═══════════════════════════════════════════
// DATABASE URL (Realtime Database REST API)
// ═══════════════════════════════════════════
const _db = 'https://tttrt-b8c5a-default-rtdb.asia-southeast1.firebasedatabase.app';

// ═══════════════════════════════════════════
// FIREBASE DATABASE — HTTP REST HELPER
// ═══════════════════════════════════════════
class DB {
  static Future<Map?> get(String path) async {
    try {
      final r = await http.get(Uri.parse('$_db/$path.json'));
      if (r.statusCode == 200 && r.body != 'null') {
        return json.decode(r.body) as Map?;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> set(String path, Map data) async {
    try {
      await http.put(Uri.parse('$_db/$path.json'), body: json.encode(data));
    } catch (_) {}
  }

  static Future<void> update(String path, Map data) async {
    try {
      await http.patch(Uri.parse('$_db/$path.json'), body: json.encode(data));
    } catch (_) {}
  }

  static Future<void> remove(String path) async {
    try {
      await http.delete(Uri.parse('$_db/$path.json'));
    } catch (_) {}
  }

  static Future<String> push(String path, Map data) async {
    try {
      final r = await http.post(Uri.parse('$_db/$path.json'), body: json.encode(data));
      final res = json.decode(r.body);
      return res['name'] ?? nid();
    } catch (_) {
      return nid();
    }
  }

  static Stream<Map?> stream(String path) async* {
    while (true) {
      yield await get(path);
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}

// ═══════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════
const kOwner = 'tsaxp';
const kBot = 'bot_dfgfd_official';
const kSup = 'support_official';

// ═══════════════════════════════════════════
// COLORS
// ═══════════════════════════════════════════
const cBg   = Color(0xFF17212B);
const cSb   = Color(0xFF0E1621);
const cCard = Color(0xFF182533);
const cAcc  = Color(0xFF2B5278);
const cBtn  = Color(0xFF5288C1);
const cTxt  = Color(0xFFE8F4FD);
const cDim  = Color(0xFF6B8CA4);
const cOut  = Color(0xFF2B5278);
const cIn   = Color(0xFF182533);
const cBrd  = Color(0xFF0D1822);
const cHov  = Color(0xFF1C2D3D);
const cGrn  = Color(0xFF4DD67A);
const cRed  = Color(0xFFE05C5C);
const cGld  = Color(0xFFF0A040);

// ═══════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════
String nid() => '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(9999)}';
String ntime() {
  final t = DateTime.now();
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
String nphone() => '+666${100000000 + Random().nextInt(899999999)}';
Color gc(String s) {
  const l = [Color(0xFFE57373), Color(0xFF4CAF50), Color(0xFF9C27B0), Color(0xFFFF9800), Color(0xFF00BCD4), Color(0xFF2196F3), Color(0xFFFF5722), Color(0xFF607D8B)];
  return s.isEmpty ? l[0] : l[s.codeUnitAt(0) % l.length];
}
String fs(dynamic n) {
  final v = (n ?? 0) as num;
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
  return '$v';
}
Map<String, dynamic> mp(dynamic v) => v != null ? Map<String, dynamic>.from(v as Map) : {};

// ═══════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: _opts);
  runApp(const TApp());
}

class TApp extends StatelessWidget {
  const TApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext ctx) => MaterialApp(
    title: 'تيرمين',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: cBg,
      primaryColor: cBtn,
      colorScheme: const ColorScheme.dark(primary: cBtn),
      appBarTheme: const AppBarTheme(
        backgroundColor: cSb, elevation: 0,
        iconTheme: IconThemeData(color: cTxt),
        titleTextStyle: TextStyle(color: cTxt, fontSize: 17, fontWeight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cBtn, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, s) => s.connectionState == ConnectionState.waiting
          ? const SplashScreen()
          : s.hasData ? const HomeScreen() : const AuthScreen(),
    ),
  );
}

// ═══════════════════════════════════════════
// SPLASH
// ═══════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _sc, _fa;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _sc = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _fa = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _c, curve: const Interval(0.4, 1.0)));
    _c.forward();
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    backgroundColor: const Color(0xFF090E18),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ScaleTransition(scale: _sc, child: Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(colors: [cAcc, cBtn], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: cBtn.withOpacity(0.4), blurRadius: 30, spreadRadius: 5)],
        ),
        child: const Center(child: Text('✈️', style: TextStyle(fontSize: 50))),
      )),
      const SizedBox(height: 20),
      FadeTransition(opacity: _fa, child: const Column(children: [
        Text('تيرمين', style: TextStyle(color: cTxt, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 3)),
        SizedBox(height: 6),
        Text('تواصل أسرع · أسهل · أكثر أماناً', style: TextStyle(color: cDim, fontSize: 13)),
        SizedBox(height: 28),
        SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: cBtn)),
      ])),
    ])),
  );
}

// ═══════════════════════════════════════════
// AUTH
// ═══════════════════════════════════════════
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  State<AuthScreen> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  bool _isLogin = true, _loading = false;
  String _err = '';
  final _dn = TextEditingController();
  final _un = TextEditingController();
  final _em = TextEditingController();
  final _pw = TextEditingController();

  @override
  void dispose() { _dn.dispose(); _un.dispose(); _em.dispose(); _pw.dispose(); super.dispose(); }

  Future<void> _go() async {
    setState(() { _err = ''; _loading = true; });
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _em.text.trim(), password: _pw.text);
      } else {
        if (_dn.text.trim().isEmpty) throw Exception('أدخل اسمك');
        if (_un.text.trim().length < 5) throw Exception('اسم المستخدم 5 أحرف على الأقل');
        final ul = _un.text.trim().toLowerCase();
        final exists = await DB.get('usernames/$ul');
        if (exists != null) throw Exception('@$ul مأخوذ');
        final cr = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _em.text.trim(), password: _pw.text);
        await cr.user!.updateDisplayName(_dn.text.trim());
        final id = cr.user!.uid;
        final ph = nphone();
        final now = DateTime.now().millisecondsSinceEpoch;
        await DB.set('users/$id', {
          'uid': id, 'displayName': _dn.text.trim(), 'username': ul,
          'email': _em.text.trim(), 'bio': '', 'photoURL': '',
          'verified': false, 'isBanned': false, 'phone': ph,
          'stars': 0, 'createdAt': now,
        });
        await DB.set('usernames/$ul', {'uid': id});
        // Saved messages
        await DB.set('chats/saved_$id', {'id': 'saved_$id', 'type': 'saved', 'name': 'الرسائل المحفوظة', 'members': [id]});
        await DB.set('userChats/$id/saved_$id', {'chatId': 'saved_$id', 'lastMessage': '', 'lastTime': '', 'unread': 0, 'order': 1, 'type': 'saved', 'name': 'الرسائل المحفوظة'});
        // DFGFD bot
        final bc = 'bot_$id';
        await DB.set('chats/$bc', {'id': bc, 'type': 'official_bot', 'name': 'DFGFD', 'username': 'dfgfd', 'isOfficial': true, 'verified': true, 'members': [id, kBot]});
        await DB.set('userChats/$id/$bc', {'chatId': bc, 'lastMessage': 'مرحباً بك ✈️', 'lastTime': ntime(), 'unread': 1, 'order': now, 'type': 'official_bot', 'name': 'DFGFD', 'verified': true});
        final wid = nid();
        await DB.set('messages/$bc/$wid', {'id': wid, 'chatId': bc, 'text': '✈️ مرحباً ${_dn.text.trim()}!\n\nأنا DFGFD المساعد الرسمي.\n🆔 معرّفك: @$ul\n📞 رقمك: $ph\n\nبياناتك آمنة 🔒', 'from': kBot, 'senderName': 'DFGFD', 'time': ntime(), 'type': 'text', 'isOfficialBot': true, 'createdAt': now});
        // Support
        await DB.set('chats/support_$id', {'id': 'support_$id', 'type': 'support', 'name': 'الدعم الفني', 'isOfficial': true, 'members': [id, kSup]});
        await DB.set('userChats/$id/support_$id', {'chatId': 'support_$id', 'lastMessage': '', 'lastTime': '', 'unread': 0, 'order': 0, 'type': 'support', 'name': 'الدعم الفني'});
      }
    } catch (e) {
      setState(() => _err = e.toString().replaceAll('Exception: ', '').replaceAll(RegExp(r'\[.*?\] '), ''));
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    backgroundColor: cBg,
    body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
      const SizedBox(height: 40),
      const Text('✈️', style: TextStyle(fontSize: 64)),
      const SizedBox(height: 12),
      const Text('تيرمين', style: TextStyle(color: cTxt, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
      const SizedBox(height: 6),
      const Text('تواصل أسرع · أسهل · أكثر أماناً', style: TextStyle(color: cDim, fontSize: 13)),
      const SizedBox(height: 32),
      Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: cCard, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          _tab('تسجيل الدخول', _isLogin, () => setState(() { _isLogin = true; _err = ''; })),
          _tab('إنشاء حساب', !_isLogin, () => setState(() { _isLogin = false; _err = ''; })),
        ])),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: cSb, borderRadius: BorderRadius.circular(18), border: Border.all(color: cBrd)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (!_isLogin) ...[_inp('الاسم الشخصي', _dn, 'اسمك الكامل', false, false), const SizedBox(height: 12), _inp('اسم المستخدم', _un, 'myusername', false, true), const SizedBox(height: 12)],
          _inp('البريد الإلكتروني', _em, 'example@email.com', false, true),
          const SizedBox(height: 12),
          _inp('كلمة المرور', _pw, '••••••••', true, false),
          if (_err.isNotEmpty) ...[const SizedBox(height: 12), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: cRed.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: cRed.withOpacity(0.3))), child: Text('⚠️ $_err', style: const TextStyle(color: cRed, fontSize: 13), textAlign: TextAlign.center))],
          const SizedBox(height: 16),
          SizedBox(height: 50, child: ElevatedButton(
            onPressed: _loading ? null : _go,
            child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(_isLogin ? '🔐 تسجيل الدخول' : '✨ إنشاء حساب', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          )),
        ])),
    ]))),
  );

  Widget _tab(String l, bool on, VoidCallback fn) => Expanded(child: GestureDetector(onTap: fn, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: on ? cBtn : Colors.transparent, borderRadius: BorderRadius.circular(11)), child: Text(l, textAlign: TextAlign.center, style: TextStyle(color: on ? Colors.white : cDim, fontWeight: FontWeight.w700, fontSize: 14)))));

  Widget _inp(String lbl, TextEditingController c, String h, bool pass, bool ltr) => Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Text(lbl, style: const TextStyle(color: cDim, fontSize: 12, fontWeight: FontWeight.w600)),
    const SizedBox(height: 5),
    TextField(controller: c, obscureText: pass, textDirection: ltr ? TextDirection.ltr : TextDirection.rtl, style: const TextStyle(color: cTxt, fontSize: 15),
      decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: cDim), filled: true, fillColor: cHov,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: cBrd)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: cBrd)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: cBtn)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))),
  ]);
}

// ═══════════════════════════════════════════
// HOME
// ═══════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int _tab = 0;
  Map<String, dynamic> _me = {};
  List<Map<String, dynamic>> _chats = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final user = await DB.get('users/$uid');
    if (user != null && mounted) setState(() => _me = mp(user));
    await _loadChats();
    // Refresh every 3 seconds
    Future.delayed(const Duration(seconds: 3), () { if (mounted) _load(); });
  }

  Future<void> _loadChats() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final raw = await DB.get('userChats/$uid');
    if (raw == null) { if (mounted) setState(() { _chats = []; _loading = false; }); return; }
    final list = <Map<String, dynamic>>[];
    for (final en in raw.entries) {
      final uc = mp(en.value);
      final cid = uc['chatId'] as String?;
      if (cid == null) continue;
      final cd = await DB.get('chats/$cid');
      if (cd != null) list.add({...mp(cd), ...uc, 'id': cid});
    }
    list.sort((a, b) => ((b['order'] ?? 0) as num).compareTo((a['order'] ?? 0) as num));
    if (mounted) setState(() { _chats = list; _loading = false; });
  }

  void _open(Map<String, dynamic> c) {
    final cid = (c['id'] ?? c['chatId'] ?? '') as String;
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chatId: cid, data: c))).then((_) => _load());
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    backgroundColor: cBg,
    body: IndexedStack(index: _tab, children: [
      ChatsTab(chats: _chats, loading: _loading, me: _me, onOpen: _open, onRefresh: _load),
      SettingsTab(me: _me, onRefresh: _load),
    ]),
    bottomNavigationBar: Container(color: const Color(0xFF1C2733), child: SafeArea(child: Row(children: [_nb(0, Icons.chat_bubble_outline, Icons.chat_bubble, 'المحادثات'), _nb(1, Icons.settings_outlined, Icons.settings, 'الإعدادات')]))),
  );

  Widget _nb(int i, IconData off, IconData on, String l) {
    final a = _tab == i;
    return Expanded(child: InkWell(onTap: () => setState(() => _tab = i), child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(a ? on : off, color: a ? cBtn : cDim, size: 24), const SizedBox(height: 2), Text(l, style: TextStyle(color: a ? cBtn : cDim, fontSize: 10, fontWeight: a ? FontWeight.w700 : FontWeight.w400))]))));
  }
}

// ═══════════════════════════════════════════
// CHATS TAB
// ═══════════════════════════════════════════
class ChatsTab extends StatefulWidget {
  final List<Map<String, dynamic>> chats;
  final bool loading;
  final Map<String, dynamic> me;
  final void Function(Map<String, dynamic>) onOpen;
  final Future<void> Function() onRefresh;
  const ChatsTab({required this.chats, required this.loading, required this.me, required this.onOpen, required this.onRefresh, Key? key}) : super(key: key);
  @override
  State<ChatsTab> createState() => _CTState();
}

class _CTState extends State<ChatsTab> {
  String _q = '';
  final _ctrl = TextEditingController();
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext ctx) {
    final fl = _q.isEmpty ? widget.chats : widget.chats.where((c) => (c['name'] ?? '').toString().toLowerCase().contains(_q.toLowerCase())).toList();
    return Column(children: [
      Container(color: cSb, child: SafeArea(bottom: false, child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(8, 8, 8, 0), child: Row(children: [
          IconButton(icon: const Icon(Icons.menu, color: cDim, size: 22), onPressed: () => _menu(ctx)),
          Expanded(child: Container(height: 40, decoration: BoxDecoration(color: cHov, borderRadius: BorderRadius.circular(22)),
            child: TextField(controller: _ctrl, onChanged: (v) => setState(() => _q = v), textDirection: TextDirection.rtl, style: const TextStyle(color: cTxt, fontSize: 14),
              decoration: InputDecoration(hintText: 'بحث...', hintStyle: const TextStyle(color: cDim, fontSize: 14), prefixIcon: _q.isNotEmpty ? IconButton(icon: const Icon(Icons.close, color: cDim, size: 18), onPressed: () { _ctrl.clear(); setState(() => _q = ''); }) : null, suffixIcon: const Icon(Icons.search, color: cDim, size: 18), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))))),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 8), child: Align(alignment: Alignment.centerRight, child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('✈️', style: TextStyle(fontSize: 14)), const SizedBox(width: 5),
          const Text('تيرمين', style: TextStyle(color: cBtn, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          if (widget.me['username'] == kOwner) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: cGld, borderRadius: BorderRadius.circular(4)), child: const Text('OWNER', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900)))],
        ]))),
      ]))),
      Expanded(child: RefreshIndicator(onRefresh: widget.onRefresh, child: widget.loading
        ? const Center(child: CircularProgressIndicator(color: cBtn))
        : fl.isEmpty
          ? ListView(children: [Center(child: Padding(padding: const EdgeInsets.only(top: 100), child: Column(children: [const Text('💬', style: TextStyle(fontSize: 48)), const SizedBox(height: 10), Text(_q.isEmpty ? 'لا توجد محادثات\nاضغط + للبدء' : 'لا نتائج', style: const TextStyle(color: cDim), textAlign: TextAlign.center)])))])
          : ListView.builder(itemCount: fl.length, itemBuilder: (_, i) => _ChatRow(chat: fl[i], onTap: () => widget.onOpen(fl[i]))))),
      Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.fromLTRB(16, 4, 0, 8), child: FloatingActionButton(backgroundColor: cBtn, onPressed: () => _newMenu(ctx), child: const Icon(Icons.add, color: Colors.white, size: 26)))),
    ]);
  }

  void _menu(BuildContext ctx) => _sheet(ctx, [_it(ctx, '💬', 'محادثة جديدة', () => _search(ctx)), _it(ctx, '👥', 'مجموعة جديدة', () => _convo(ctx, 'group')), _it(ctx, '📢', 'قناة جديدة', () => _convo(ctx, 'channel')), _it(ctx, '🔖', 'رسائل محفوظة', () => _openSaved(ctx)), _it(ctx, '🆘', 'الدعم الفني', () => _openSup(ctx))]);
  void _newMenu(BuildContext ctx) => _sheet(ctx, [const Padding(padding: EdgeInsets.all(12), child: Text('إنشاء', style: TextStyle(color: cTxt, fontSize: 16, fontWeight: FontWeight.w700))), _it(ctx, '💬', 'محادثة خاصة', () => _search(ctx)), _it(ctx, '👥', 'مجموعة جديدة', () => _convo(ctx, 'group')), _it(ctx, '📢', 'قناة جديدة', () => _convo(ctx, 'channel'))]);
  void _sheet(BuildContext ctx, List<Widget> items) => showModalBottomSheet(context: ctx, backgroundColor: const Color(0xFF1C2D3D), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [const SizedBox(height: 8), ...items, const SizedBox(height: 8)]));
  Widget _it(BuildContext ctx, String e, String l, VoidCallback fn) => ListTile(leading: Text(e, style: const TextStyle(fontSize: 22)), title: Text(l, style: const TextStyle(color: cTxt, fontSize: 15)), onTap: () { Navigator.pop(ctx); fn(); });
  void _search(BuildContext ctx) => showDialog(context: ctx, builder: (_) => _SearchDlg(onOpen: widget.onOpen));
  void _convo(BuildContext ctx, String t) => showDialog(context: ctx, builder: (_) => _ConvoDlg(type: t, onOpen: widget.onOpen));

  void _openSaved(BuildContext ctx) {
    final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return;
    widget.onOpen({'id': 'saved_$uid', 'type': 'saved', 'name': 'الرسائل المحفوظة'});
  }

  void _openSup(BuildContext ctx) async {
    final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return;
    final cid = 'support_$uid';
    final exists = await DB.get('chats/$cid');
    if (exists == null) {
      await DB.set('chats/$cid', {'id': cid, 'type': 'support', 'name': 'الدعم الفني', 'isOfficial': true, 'members': [uid, kSup]});
      await DB.set('userChats/$uid/$cid', {'chatId': cid, 'lastMessage': '', 'lastTime': '', 'unread': 0, 'order': 0, 'type': 'support', 'name': 'الدعم الفني'});
    }
    widget.onOpen({'id': cid, 'type': 'support', 'name': 'الدعم الفني'});
  }
}

// ═══════════════════════════════════════════
// CHAT ROW
// ═══════════════════════════════════════════
class _ChatRow extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;
  const _ChatRow({required this.chat, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final nm = (chat['name'] ?? 'محادثة') as String;
    final lm = (chat['lastMessage'] ?? '') as String;
    final lt = (chat['lastTime'] ?? '') as String;
    final ur = (chat['unread'] ?? 0) as int;
    final ph = (chat['photoURL'] ?? '') as String;
    final vr = chat['verified'] == true || chat['type'] == 'official_bot';
    String pfx = '';
    if (chat['type'] == 'official_bot') pfx = '✈️ ';
    if (chat['type'] == 'support')      pfx = '🆘 ';
    if (chat['type'] == 'saved')        pfx = '🔖 ';
    if (chat['type'] == 'channel')      pfx = '📢 ';
    if (chat['type'] == 'group')        pfx = '👥 ';

    return InkWell(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: cBrd.withOpacity(0.4)))),
      child: Row(children: [
        Stack(children: [
          CircleAvatar(radius: 26, backgroundColor: gc(nm), backgroundImage: ph.isNotEmpty ? NetworkImage(ph) : null, child: ph.isEmpty ? Text(nm.isEmpty ? '?' : nm[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)) : null),
          if (vr) Positioned(bottom: -1, left: -1, child: Container(width: 17, height: 17, decoration: BoxDecoration(color: cBtn, shape: BoxShape.circle, border: Border.all(color: cSb, width: 1.5)), child: const Icon(Icons.check, color: Colors.white, size: 10))),
        ]),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(lt, style: const TextStyle(color: cDim, fontSize: 11)),
            Flexible(child: Row(mainAxisSize: MainAxisSize.min, children: [Flexible(child: Text('$pfx$nm', style: const TextStyle(color: cTxt, fontSize: 15, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)), if (vr) ...[const SizedBox(width: 4), Container(width: 14, height: 14, decoration: const BoxDecoration(color: cBtn, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 9))]])),
          ]),
          const SizedBox(height: 2),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (ur > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: cBtn, borderRadius: BorderRadius.circular(10)), child: Text(ur > 99 ? '99+' : '$ur', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))) else const SizedBox(),
            Expanded(child: Text(lm, style: const TextStyle(color: cDim, fontSize: 13), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, maxLines: 1)),
          ]),
        ])),
      ]),
    ));
  }
}

// ═══════════════════════════════════════════
// CHAT SCREEN
// ═══════════════════════════════════════════
class ChatScreen extends StatefulWidget {
  final String chatId;
  final Map<String, dynamic> data;
  const ChatScreen({required this.chatId, required this.data, Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _CSState();
}

class _CSState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _msgs = [];
  Map<String, dynamic> _info = {};
  Map<String, dynamic> _me = {};
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _info = widget.data;
    _loadAll();
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _loadAll() async {
    final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return;
    final user = await DB.get('users/$uid');
    if (user != null && mounted) setState(() => _me = mp(user));
    await _loadMsgs();
    // Mark read
    await DB.update('userChats/$uid/${widget.chatId}', {'unread': 0});
    // Refresh
    Future.delayed(const Duration(seconds: 3), () { if (mounted) _loadMsgs(); });
  }

  Future<void> _loadMsgs() async {
    final raw = await DB.get('messages/${widget.chatId}');
    if (raw == null) { if (mounted) setState(() => _msgs = []); return; }
    final list = raw.values.map((v) => mp(v)).toList();
    list.sort((a, b) => ((a['createdAt'] ?? 0) as num).compareTo((b['createdAt'] ?? 0) as num));
    if (mounted) setState(() => _msgs = list);
  }

  Future<void> _send() async {
    final txt = _ctrl.text.trim(); if (txt.isEmpty || _sending) return;
    final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return;
    if (_info['type'] == 'channel' && _info['ownerId'] != uid) return;
    setState(() => _sending = true);
    _ctrl.clear();
    final mid = nid();
    final now = DateTime.now().millisecondsSinceEpoch;
    final msg = {'id': mid, 'chatId': widget.chatId, 'text': txt, 'from': uid, 'senderName': _me['displayName'] ?? 'مستخدم', 'time': ntime(), 'type': 'text', 'createdAt': now};
    await DB.set('messages/${widget.chatId}/$mid', msg);
    await DB.update('userChats/$uid/${widget.chatId}', {'lastMessage': txt, 'lastTime': ntime(), 'order': now});
    // Notify members
    final mems = (_info['members'] as List?)?.cast<String>() ?? [];
    for (final m in mems) {
      if (m == uid || m.startsWith('bot_') || m == kSup) continue;
      final uc = await DB.get('userChats/$m/${widget.chatId}');
      final unread = ((uc ?? {})['unread'] ?? 0) as int;
      await DB.update('userChats/$m/${widget.chatId}', {'lastMessage': txt, 'lastTime': ntime(), 'unread': unread + 1, 'order': now});
    }
    if (_info['type'] == 'support') {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        final rid = nid();
        await DB.set('messages/${widget.chatId}/$rid', {'id': rid, 'chatId': widget.chatId, 'text': 'شكراً لتواصلك! سيراجع فريق الدعم طلبك قريباً.', 'from': kSup, 'senderName': 'الدعم الفني', 'time': ntime(), 'type': 'text', 'isSupport': true, 'createdAt': DateTime.now().millisecondsSinceEpoch});
        if (mounted) _loadMsgs();
      });
    }
    await _loadMsgs();
    if (mounted) setState(() => _sending = false);
  }

  bool get _canSend {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (_info['type'] == 'channel') return _info['ownerId'] == uid;
    return true;
  }

  @override
  Widget build(BuildContext ctx) {
    final nm   = (_info['name'] ?? 'محادثة') as String;
    final ph   = (_info['photoURL'] ?? '') as String;
    final vr   = _info['verified'] == true || _info['type'] == 'official_bot';
    final isCh = _info['type'] == 'channel';
    final isGr = _info['type'] == 'group';
    final isOB = _info['type'] == 'official_bot';
    final isSup = _info['type'] == 'support';
    final isSv = _info['type'] == 'saved';
    final isPM = _info['type'] == 'private';
    String sub = '';
    if (isSv) sub = 'رسائلك المحفوظة';
    else if (isSup) sub = 'الدعم الفني';
    else if (isOB) sub = '🤖 خدمة العملاء';
    else if (isCh) sub = '${fs(_info['subscribers'])} مشترك';
    else if (isGr) sub = '${(_info['members'] as List?)?.length ?? 0} عضو';

    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(backgroundColor: cSb, leading: const BackButton(color: cTxt), titleSpacing: 0,
        title: Row(children: [
          CircleAvatar(radius: 20, backgroundColor: gc(nm), backgroundImage: ph.isNotEmpty ? NetworkImage(ph) : null, child: ph.isEmpty ? Text(nm.isEmpty ? '?' : nm[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)) : null),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text(nm, style: const TextStyle(color: cTxt, fontSize: 15, fontWeight: FontWeight.w700)), if (vr) ...[const SizedBox(width: 4), Container(width: 14, height: 14, decoration: const BoxDecoration(color: cBtn, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 9))]]),
            if (sub.isNotEmpty) Text(sub, style: const TextStyle(color: cDim, fontSize: 12)),
          ]),
        ]),
        actions: [
          if (isPM) IconButton(icon: const Icon(Icons.call_outlined, color: cDim), onPressed: () => showDialog(context: ctx, builder: (_) => _CallDlg(nm: nm, ph: ph))),
          IconButton(icon: const Icon(Icons.more_vert, color: cDim), onPressed: () => _opts(ctx)),
          IconButton(icon: const Icon(Icons.refresh, color: cDim, size: 20), onPressed: _loadMsgs),
        ],
      ),
      body: Column(children: [
        Expanded(child: _msgs.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(isSv ? '🔖' : isSup ? '🆘' : isOB ? '✈️' : '👋', style: const TextStyle(fontSize: 48)), const SizedBox(height: 10), Text(isSv ? 'رسائلك المحفوظة' : 'ابدأ المحادثة!', style: const TextStyle(color: cDim))]))
          : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), itemCount: _msgs.length, itemBuilder: (_, i) => _Bubble(msg: _msgs[i], isGrp: isGr))),
        if (isSup) Container(color: cCard, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: SizedBox(width: double.infinity, child: OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: cGrn, side: const BorderSide(color: cGrn)), onPressed: () async { final tid = 'TKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'; await DB.set('messages/${widget.chatId}/${nid()}', {'id': nid(), 'chatId': widget.chatId, 'text': '📋 تم إرسال طلبك للدعم.\n🎫 الطلب: $tid', 'from': kSup, 'senderName': 'الدعم الفني', 'time': ntime(), 'type': 'system_info', 'isSupport': true, 'createdAt': DateTime.now().millisecondsSinceEpoch}); _loadMsgs(); }, child: const Text('📞 التحويل للدعم البشري')))),
        if (_canSend) _InputBar(ctrl: _ctrl, onSend: _send, busy: _sending, isSv: isSv, isOB: isOB, isSup: isSup, isCh: isCh)
        else Container(color: cSb, padding: const EdgeInsets.all(12), child: const Center(child: Text('📢 فقط صاحب القناة يمكنه النشر', style: TextStyle(color: cDim, fontSize: 13)))),
      ]),
    );
  }

  void _opts(BuildContext ctx) => showModalBottomSheet(context: ctx, backgroundColor: const Color(0xFF1C2D3D), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
    const SizedBox(height: 8),
    ListTile(leading: const Icon(Icons.delete_outline, color: cRed), title: const Text('حذف المحادثة', style: TextStyle(color: cRed)), onTap: () async {
      Navigator.pop(ctx);
      final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return;
      await DB.remove('messages/${widget.chatId}');
      await DB.remove('userChats/$uid/${widget.chatId}');
      if (ctx.mounted) Navigator.pop(ctx);
    }),
    const SizedBox(height: 8),
  ]));
}

// ═══════════════════════════════════════════
// BUBBLE
// ═══════════════════════════════════════════
class _Bubble extends StatelessWidget {
  final Map<String, dynamic> msg;
  final bool isGrp;
  const _Bubble({required this.msg, this.isGrp = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final uid  = FirebaseAuth.instance.currentUser?.uid;
    final isMe = msg['from'] == uid;
    final isSys = msg['type'] == 'system' || msg['type'] == 'system_info';
    final isBot = msg['isOfficialBot'] == true;
    final isSup = msg['isSupport'] == true;
    final txt  = (msg['text'] ?? '') as String;
    final time = (msg['time'] ?? '') as String;
    final sNm  = (msg['senderName'] ?? '') as String;

    if (isSys) return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: cBtn.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text(txt, style: const TextStyle(color: cDim, fontSize: 12), textAlign: TextAlign.center))));

    return Padding(padding: const EdgeInsets.only(bottom: 2), child: Row(mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end, children: [
      ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.72),
        child: GestureDetector(onLongPress: () => _menu(ctx, uid), child: Container(
          padding: const EdgeInsets.fromLTRB(11, 8, 11, 6),
          decoration: BoxDecoration(
            color: isMe ? cOut : (isBot || isSup) ? const Color(0xFF1A3040) : cIn,
            borderRadius: BorderRadius.only(topLeft: const Radius.circular(16), topRight: const Radius.circular(16), bottomLeft: Radius.circular(isMe ? 4 : 16), bottomRight: Radius.circular(isMe ? 16 : 4)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3)],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
            if (!isMe && isGrp) Text(sNm, style: const TextStyle(color: cBtn, fontSize: 12, fontWeight: FontWeight.w700)),
            if (isBot || isSup) Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 13, height: 13, decoration: const BoxDecoration(color: cBtn, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 8)), const SizedBox(width: 4), Text('⭐ $sNm', style: const TextStyle(color: cGld, fontSize: 11, fontWeight: FontWeight.w700))]),
            Directionality(textDirection: TextDirection.rtl, child: Text(txt, style: const TextStyle(color: cTxt, fontSize: 14.5, height: 1.5))),
            const SizedBox(height: 3),
            Row(mainAxisSize: MainAxisSize.min, children: [Text(time, style: const TextStyle(color: cDim, fontSize: 10.5)), if (isMe) ...[const SizedBox(width: 3), const Icon(Icons.done_all, color: cBtn, size: 13)]]),
          ]),
        ))),
    ]));
  }

  void _menu(BuildContext ctx, String? uid) => showModalBottomSheet(context: ctx, backgroundColor: const Color(0xFF1C2D3D), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
    Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: ['❤️', '👍', '😂', '😮', '😢', '🔥'].map((e) => GestureDetector(onTap: () => Navigator.pop(ctx), child: Padding(padding: const EdgeInsets.all(6), child: Text(e, style: const TextStyle(fontSize: 26))))).toList())),
    const Divider(color: cBrd, height: 1),
    ListTile(leading: const Icon(Icons.copy, color: cDim), title: const Text('نسخ', style: TextStyle(color: cTxt)), onTap: () { Navigator.pop(ctx); ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم النسخ'), backgroundColor: cCard)); }),
    if (msg['from'] == uid) ListTile(leading: const Icon(Icons.delete_outline, color: cRed), title: const Text('حذف', style: TextStyle(color: cRed)), onTap: () async { Navigator.pop(ctx); await DB.remove('messages/${msg['chatId']}/${msg['id']}'); }),
    const SizedBox(height: 8),
  ]));
}

// ═══════════════════════════════════════════
// INPUT BAR
// ═══════════════════════════════════════════
class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onSend;
  final bool busy, isSv, isOB, isSup, isCh;
  const _InputBar({required this.ctrl, required this.onSend, this.busy = false, this.isSv = false, this.isOB = false, this.isSup = false, this.isCh = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) => Container(color: cSb, padding: const EdgeInsets.fromLTRB(8, 8, 8, 12), child: SafeArea(top: false, child: Row(children: [
    const Text('😊', style: TextStyle(fontSize: 22)),
    const SizedBox(width: 8),
    Expanded(child: Container(decoration: BoxDecoration(color: cHov, borderRadius: BorderRadius.circular(22)), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: TextField(controller: ctrl, textDirection: TextDirection.rtl, maxLines: null, style: const TextStyle(color: cTxt, fontSize: 14.5),
        decoration: InputDecoration(hintText: isSv ? 'احفظ ملاحظاتك...' : isCh ? 'نشر في القناة...' : isSup ? 'اكتب مشكلتك...' : isOB ? 'أرسل أمراً...' : 'اكتب رسالة...', hintStyle: const TextStyle(color: cDim, fontSize: 14), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 8))))),
    const SizedBox(width: 8),
    ValueListenableBuilder<TextEditingValue>(valueListenable: ctrl, builder: (_, val, __) => GestureDetector(onTap: val.text.trim().isNotEmpty ? onSend : null, child: Container(width: 42, height: 42, decoration: BoxDecoration(color: val.text.trim().isNotEmpty ? cBtn : cHov, shape: BoxShape.circle, boxShadow: val.text.trim().isNotEmpty ? [BoxShadow(color: cBtn.withOpacity(0.4), blurRadius: 8)] : null), child: busy ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))) : Icon(val.text.trim().isNotEmpty ? Icons.send : Icons.mic, color: val.text.trim().isNotEmpty ? Colors.white : cDim, size: 19)))),
  ])));
}

// ═══════════════════════════════════════════
// CALL DIALOG
// ═══════════════════════════════════════════
class _CallDlg extends StatelessWidget {
  final String nm, ph;
  const _CallDlg({required this.nm, required this.ph, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext ctx) => Dialog(backgroundColor: Colors.transparent, child: Container(height: 360, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1a3a2a), Color(0xFF0e1621)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(24)),
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      const Text('يتم الاتصال...', style: TextStyle(color: Colors.white60, fontSize: 14)),
      CircleAvatar(radius: 52, backgroundColor: gc(nm), backgroundImage: ph.isNotEmpty ? NetworkImage(ph) : null, child: ph.isEmpty ? Text(nm.isEmpty ? '?' : nm[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)) : null),
      Text(nm, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_cb(Icons.volume_up, Colors.blue, () {}), _cb(Icons.videocam_off, Colors.grey, () {}), _cb(Icons.mic_off, Colors.grey, () {}), _cb(Icons.call_end, Colors.red, () => Navigator.pop(ctx))]),
    ])));
  Widget _cb(IconData ic, Color c, VoidCallback fn) => GestureDetector(onTap: fn, child: CircleAvatar(radius: 26, backgroundColor: c, child: Icon(ic, color: Colors.white, size: 22)));
}

// ═══════════════════════════════════════════
// SETTINGS TAB
// ═══════════════════════════════════════════
class SettingsTab extends StatelessWidget {
  final Map<String, dynamic> me;
  final Future<void> Function() onRefresh;
  const SettingsTab({required this.me, required this.onRefresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final nm = (me['displayName'] ?? '') as String;
    final un = (me['username'] ?? '') as String;
    final bio = (me['bio'] ?? '') as String;
    final ph = (me['photoURL'] ?? '') as String;
    final st = me['stars'] ?? 0;
    final phone = (me['phone'] ?? '') as String;
    final vr = me['verified'] == true;
    final isOwner = un == kOwner;

    return SafeArea(child: SingleChildScrollView(child: Column(children: [
      Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [cAcc, const Color(0xFF12243A)], begin: Alignment.topLeft, end: Alignment.bottomRight)), padding: const EdgeInsets.fromLTRB(16, 24, 16, 20), child: Column(children: [
        CircleAvatar(radius: 44, backgroundColor: gc(nm), backgroundImage: ph.isNotEmpty ? NetworkImage(ph) : null, child: ph.isEmpty ? Text(nm.isEmpty ? '?' : nm[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)) : null),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(nm, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          if (vr) ...[const SizedBox(width: 6), Container(width: 18, height: 18, decoration: const BoxDecoration(color: cBtn, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 11))],
          if (isOwner) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: cGld, borderRadius: BorderRadius.circular(4)), child: const Text('OWNER', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900)))],
        ]),
        Text('@$un', style: const TextStyle(color: Colors.white60, fontSize: 13)),
        if (phone.isNotEmpty) Text(phone, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        if (bio.isNotEmpty) ...[const SizedBox(height: 4), Text(bio, style: const TextStyle(color: Colors.white54, fontSize: 13))],
        const SizedBox(height: 8),
        Text('⭐ $st نجمة', style: const TextStyle(color: cGld, fontSize: 13, fontWeight: FontWeight.w700)),
      ])),
      _sec('الحساب'),
      _it(ctx, Icons.person_outline, 'تعديل الملف الشخصي', () => showDialog(context: ctx, builder: (_) => _EditDlg(me: me)).then((_) => onRefresh())),
      _it(ctx, Icons.star_outline, 'شحن النجوم', () {}, extra: Text('$st ⭐', style: const TextStyle(color: cGld, fontSize: 13))),
      _sec('الأمان'),
      _it(ctx, Icons.security_outlined, 'الأمان والحماية', () {}),
      if (isOwner) ...[_sec('الإدارة'), _it(ctx, Icons.admin_panel_settings_outlined, 'لوحة تحكم المالك', () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AdminPage())), ic: cGld)],
      _sec(''),
      _it(ctx, Icons.logout, 'تسجيل الخروج', () => FirebaseAuth.instance.signOut(), ic: cRed, tc: cRed),
      const SizedBox(height: 16),
      const Text('✈️ تيرمين v4.4', style: TextStyle(color: cDim, fontSize: 11)),
      const SizedBox(height: 24),
    ])));
  }

  Widget _sec(String t) => Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 5), child: Align(alignment: Alignment.centerRight, child: Text(t, style: const TextStyle(color: cDim, fontSize: 12, fontWeight: FontWeight.w700))));
  Widget _it(BuildContext ctx, IconData i, String l, VoidCallback fn, {Color? ic, Color? tc, Widget? extra}) => InkWell(onTap: fn, child: Container(color: cSb, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), child: Row(children: [const Icon(Icons.arrow_back_ios, color: cDim, size: 14), if (extra != null) ...[const SizedBox(width: 6), extra], const Spacer(), Text(l, style: TextStyle(color: tc ?? cTxt, fontSize: 14.5)), const SizedBox(width: 14), Container(width: 38, height: 38, decoration: BoxDecoration(color: (ic ?? cBtn).withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(i, color: ic ?? cBtn, size: 18))])));
}

// ═══════════════════════════════════════════
// EDIT PROFILE
// ═══════════════════════════════════════════
class _EditDlg extends StatefulWidget {
  final Map<String, dynamic> me;
  const _EditDlg({required this.me, Key? key}) : super(key: key);
  @override State<_EditDlg> createState() => _EditState();
}

class _EditState extends State<_EditDlg> {
  late final _dn = TextEditingController(text: widget.me['displayName'] ?? '');
  late final _bio = TextEditingController(text: widget.me['bio'] ?? '');
  bool _busy = false;
  @override void dispose() { _dn.dispose(); _bio.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext ctx) => AlertDialog(backgroundColor: const Color(0xFF1A2A3A),
    title: const Text('تعديل الملف الشخصي', style: TextStyle(color: cTxt), textAlign: TextAlign.right),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: _dn, textDirection: TextDirection.rtl, style: const TextStyle(color: cTxt), decoration: const InputDecoration(labelText: 'الاسم', labelStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: _bio, maxLines: 3, textDirection: TextDirection.rtl, style: const TextStyle(color: cTxt), decoration: const InputDecoration(labelText: 'النبذة', labelStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder())),
    ]),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: cDim))),
      ElevatedButton(onPressed: _busy ? null : () async {
        setState(() => _busy = true);
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) await DB.update('users/$uid', {'displayName': _dn.text.trim(), 'bio': _bio.text.trim()});
        if (mounted) Navigator.pop(ctx);
      }, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ')),
    ]);
}

// ═══════════════════════════════════════════
// SEARCH DIALOG
// ═══════════════════════════════════════════
class _SearchDlg extends StatefulWidget {
  final void Function(Map<String, dynamic>) onOpen;
  const _SearchDlg({required this.onOpen, Key? key}) : super(key: key);
  @override State<_SearchDlg> createState() => _SearchState();
}

class _SearchState extends State<_SearchDlg> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _res = [];
  bool _busy = false;
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _search(String q) async {
    if (q.isEmpty) { setState(() => _res = []); return; }
    setState(() => _busy = true);
    final qv = q.toLowerCase().replaceAll('@', '');
    final raw = await DB.get('users');
    if (raw == null) { setState(() { _res = []; _busy = false; }); return; }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final res = raw.values.where((v) {
      final u = mp(v);
      return u['uid'] != uid && ((u['username'] ?? '').toString().contains(qv) || (u['displayName'] ?? '').toString().toLowerCase().contains(qv));
    }).map((v) => mp(v)).toList();
    if (mounted) setState(() { _res = res; _busy = false; });
  }

  @override
  Widget build(BuildContext ctx) => AlertDialog(backgroundColor: const Color(0xFF1A2A3A),
    title: const Text('محادثة جديدة', style: TextStyle(color: cTxt), textAlign: TextAlign.right),
    content: SizedBox(width: double.maxFinite, child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: _ctrl, onChanged: _search, textDirection: TextDirection.rtl, style: const TextStyle(color: cTxt), decoration: const InputDecoration(hintText: '@username أو الاسم', hintStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder())),
      const SizedBox(height: 10),
      SizedBox(height: 200, child: _busy ? const Center(child: CircularProgressIndicator(color: cBtn)) : ListView.builder(itemCount: _res.length, itemBuilder: (c, i) {
        final u = _res[i];
        return ListTile(
          leading: CircleAvatar(backgroundColor: gc(u['displayName'] ?? ''), child: Text((u['displayName'] ?? '?')[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
          title: Text(u['displayName'] ?? '', style: const TextStyle(color: cTxt)),
          subtitle: Text('@${u['username'] ?? ''}', style: const TextStyle(color: cDim, fontSize: 12)),
          onTap: () async {
            Navigator.pop(c);
            final uid = FirebaseAuth.instance.currentUser?.uid; final oid = u['uid'] as String?; if (uid == null || oid == null) return;
            final sorted = [uid, oid]..sort(); final cid = 'pm_${sorted.join('_')}';
            final exists = await DB.get('chats/$cid');
            if (exists == null) {
              await DB.set('chats/$cid', {'id': cid, 'type': 'private', 'name': u['displayName'], 'members': [uid, oid], 'photoURL': u['photoURL'] ?? ''});
              await DB.set('userChats/$uid/$cid', {'chatId': cid, 'lastMessage': '', 'lastTime': '', 'unread': 0, 'order': DateTime.now().millisecondsSinceEpoch, 'type': 'private', 'name': u['displayName'], 'photoURL': u['photoURL'] ?? ''});
            }
            widget.onOpen({'id': cid, 'type': 'private', 'name': u['displayName'], 'photoURL': u['photoURL'] ?? ''});
          });
      })),
    ])),
    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: cDim)))]);
}

// ═══════════════════════════════════════════
// NEW CONVO DIALOG
// ═══════════════════════════════════════════
class _ConvoDlg extends StatefulWidget {
  final String type;
  final void Function(Map<String, dynamic>) onOpen;
  const _ConvoDlg({required this.type, required this.onOpen, Key? key}) : super(key: key);
  @override State<_ConvoDlg> createState() => _ConvoState();
}

class _ConvoState extends State<_ConvoDlg> {
  final _name = TextEditingController(), _un = TextEditingController(), _bio = TextEditingController();
  bool _busy = false; String _err = '';
  @override void dispose() { _name.dispose(); _un.dispose(); _bio.dispose(); super.dispose(); }

  Future<void> _create() async {
    if (_name.text.trim().isEmpty) { setState(() => _err = 'أدخل الاسم'); return; }
    if (_un.text.trim().length < 5) { setState(() => _err = 'اسم المستخدم 5 أحرف'); return; }
    setState(() { _busy = true; _err = ''; });
    final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return;
    final ul = _un.text.trim().toLowerCase();
    if (await DB.get('usernames/$ul') != null || await DB.get('chatUsernames/$ul') != null) { setState(() { _err = '@$ul مأخوذ'; _busy = false; }); return; }
    final cid = nid(); final isCh = widget.type == 'channel';
    final now = DateTime.now().millisecondsSinceEpoch;
    final cd = <String, dynamic>{'id': cid, 'type': widget.type, 'name': _name.text.trim(), 'username': ul, 'bio': _bio.text.trim(), 'photoURL': '', 'ownerId': uid, 'members': [uid], 'admins': [uid], 'verified': false, 'createdAt': now};
    if (isCh) { cd['subscribers'] = 1; cd['subscribersList'] = [uid]; }
    await DB.set('chats/$cid', cd);
    await DB.set('chatUsernames/$ul', {'cid': cid});
    await DB.set('userChats/$uid/$cid', {'chatId': cid, 'lastMessage': 'تم الإنشاء', 'lastTime': ntime(), 'unread': 0, 'order': now, 'type': widget.type, 'name': _name.text.trim()});
    if (mounted) { Navigator.pop(context); widget.onOpen({...cd, 'id': cid}); }
  }

  @override
  Widget build(BuildContext ctx) => AlertDialog(backgroundColor: const Color(0xFF1A2A3A),
    title: Text(widget.type == 'channel' ? '📢 قناة جديدة' : '👥 مجموعة جديدة', style: const TextStyle(color: cTxt), textAlign: TextAlign.right),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: _name, textDirection: TextDirection.rtl, style: const TextStyle(color: cTxt), decoration: InputDecoration(labelText: widget.type == 'channel' ? 'اسم القناة' : 'اسم المجموعة', labelStyle: const TextStyle(color: cDim), filled: true, fillColor: cHov, border: const OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: _un, textDirection: TextDirection.ltr, style: const TextStyle(color: cTxt), decoration: const InputDecoration(labelText: 'اسم المستخدم *', labelStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: _bio, textDirection: TextDirection.rtl, style: const TextStyle(color: cTxt), decoration: const InputDecoration(labelText: 'النبذة', labelStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder())),
      if (_err.isNotEmpty) ...[const SizedBox(height: 8), Text(_err, style: const TextStyle(color: cRed, fontSize: 13))],
    ]),
    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: cDim))), ElevatedButton(onPressed: _busy ? null : _create, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('إنشاء'))]);
}

// ═══════════════════════════════════════════
// ADMIN PAGE
// ═══════════════════════════════════════════
class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);
  @override State<AdminPage> createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;
  final _ch = TextEditingController(), _count = TextEditingController();
  String _bMsg = '';
  bool _bBusy = false;

  @override void initState() { super.initState(); _load(); }
  @override void dispose() { _ch.dispose(); _count.dispose(); super.dispose(); }

  Future<void> _load() async {
    final raw = await DB.get('users');
    if (mounted) setState(() { _users = raw != null ? raw.values.map((v) => mp(v)).toList() : []; _loading = false; });
  }

  Future<void> _act(String action, String uid, String un) async {
    final m = <String, dynamic>{};
    if (action == 'ban') m['isBanned'] = true;
    if (action == 'unban') m['isBanned'] = false;
    if (action == 'verify') m['verified'] = true;
    if (action == 'unverf') m['verified'] = false;
    await DB.update('users/$uid', m);
    final lbl = {'ban': '⚠️ تم تعليق حسابك', 'unban': '✅ تم رفع التعليق', 'verify': '✅ تم توثيق حسابك', 'unverf': 'ℹ️ تم إزالة التوثيق'};
    final mid = nid();
    await DB.set('messages/bot_$uid/$mid', {'id': mid, 'chatId': 'bot_$uid', 'text': lbl[action] ?? '', 'from': kBot, 'senderName': 'DFGFD', 'time': ntime(), 'type': 'text', 'isOfficialBot': true, 'createdAt': DateTime.now().millisecondsSinceEpoch});
    _load();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ $action على @$un'), backgroundColor: cCard));
  }

  Future<void> _boost() async {
    if (_ch.text.trim().isEmpty || _count.text.trim().isEmpty) return;
    setState(() { _bBusy = true; _bMsg = ''; });
    final un = _ch.text.trim().toLowerCase().replaceAll('@', '');
    final entry = await DB.get('chatUsernames/$un');
    if (entry == null) { setState(() { _bMsg = '❌ لا توجد قناة @$un'; _bBusy = false; }); return; }
    final cid = (entry['cid'] ?? '') as String;
    final cs = await DB.get('chats/$cid');
    if (cs == null) { setState(() { _bMsg = '❌ القناة غير موجودة'; _bBusy = false; }); return; }
    final cur = ((cs['subscribers'] ?? 0)) as int;
    final add = int.tryParse(_count.text) ?? 0;
    await DB.update('chats/$cid', {'subscribers': cur + add});
    setState(() { _bMsg = '✅ تم رشق $add → الإجمالي: ${cur + add}'; _bBusy = false; });
  }

  @override
  Widget build(BuildContext ctx) => DefaultTabController(length: 2, child: Scaffold(backgroundColor: const Color(0xFF0A1628),
    appBar: AppBar(backgroundColor: const Color(0xFF0A1628), leading: const BackButton(color: cGld), title: const Text('👑 لوحة تحكم المالك', style: TextStyle(color: cGld, fontWeight: FontWeight.w800)),
      bottom: const TabBar(tabs: [Tab(text: '👥 المستخدمون'), Tab(text: '🚀 رشق')], labelColor: cGld, unselectedLabelColor: cDim, indicatorColor: cGld)),
    body: _loading ? const Center(child: CircularProgressIndicator(color: cGld)) : TabBarView(children: [
      ListView.builder(itemCount: _users.length, itemBuilder: (_, i) {
        final u = _users[i]; final uid = (u['uid'] ?? '') as String; final un = (u['username'] ?? '') as String;
        return Container(margin: const EdgeInsets.fromLTRB(12, 6, 12, 0), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF0E1E30), borderRadius: BorderRadius.circular(14), border: Border.all(color: cGld.withOpacity(0.08))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [if (u['isBanned'] == true) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: cRed.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: const Text('محظور', style: TextStyle(color: cRed, fontSize: 10))), if (u['verified'] == true) ...[const SizedBox(width: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: cBtn.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: const Text('موثق', style: TextStyle(color: cBtn, fontSize: 10)))]]), Text(u['displayName'] ?? '—', style: const TextStyle(color: cTxt, fontSize: 15, fontWeight: FontWeight.w700))]),
            Text('@$un · ${u['email'] ?? ''}', style: const TextStyle(color: cDim, fontSize: 11)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: [_ab('حظر', cRed, () => _act('ban', uid, un)), _ab('رفع الحظر', cGrn, () => _act('unban', uid, un)), _ab('توثيق', cBtn, () => _act('verify', uid, un)), _ab('إزالة التوثيق', cDim, () => _act('unverf', uid, un))]),
          ]));
      }),
      Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF0E1E30), borderRadius: BorderRadius.circular(16), border: Border.all(color: cGld.withOpacity(0.08))), child: Column(children: [
          const Text('🚀 رشق مشتركين قناة', style: TextStyle(color: cGld, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          TextField(controller: _ch, textDirection: TextDirection.ltr, style: const TextStyle(color: cTxt), decoration: const InputDecoration(hintText: '@channel_username', hintStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
          const SizedBox(height: 10),
          TextField(controller: _count, keyboardType: TextInputType.number, style: const TextStyle(color: cTxt), decoration: const InputDecoration(hintText: 'عدد المشتركين', hintStyle: TextStyle(color: cDim), filled: true, fillColor: cHov, border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _bBusy ? null : _boost, style: ElevatedButton.styleFrom(backgroundColor: cGld, foregroundColor: Colors.black), child: _bBusy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('🚀 رشق', style: TextStyle(fontWeight: FontWeight.w800)))),
          if (_bMsg.isNotEmpty) ...[const SizedBox(height: 10), Text(_bMsg, style: TextStyle(color: _bMsg.startsWith('✅') ? cGrn : cRed, fontSize: 13), textAlign: TextAlign.center)],
        ])),
      ])),
    ])));

  Widget _ab(String l, Color c, VoidCallback fn) => ElevatedButton(onPressed: fn, style: ElevatedButton.styleFrom(backgroundColor: c.withOpacity(0.15), foregroundColor: c, side: BorderSide(color: c.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), child: Text(l));
}
