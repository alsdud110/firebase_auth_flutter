1. flutter CLI 를 설치 -> terminal : curl -sL https://firebase.tools | bash
2. terminal :
    - firebase login
    - dart pub global activate flutterfire_cli
    - flutterfire configure
    - (SELECT Project AND PlatForm)
    - flutter pub add firebase_auth

3. main.dart 에
    - void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
        );
        runApp(const MyApp());
    }

4. Auth를 관리하는 dart파일 하나 만들어서 인증관리
    - Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 인증 성공  
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );

5. 로그인(signIn), 로그아웃(signOut), 회원가입(createUser)
    - signIn : 
        - showDialog(
            context: context,
            builder: (context) => const Center(
                child: CircularProgressIndicator(),
                ),
            );
        - await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailTextController.text,
            password: passwordTextController.text,
            );
        - if (context.mounted) Navigator.pop(context);

    - signOut : 
        await FirebaseAuth.instance.signOut();

    - createUser : 
        - showDialog(
            context: context,
            builder: (context) => const Center(
                child: CircularProgressIndicator(),
            ),
        );
        - if (passwordTextController.text != confirmPasswordTextController.text) {
            Navigator.pop(context);
            return;
        }
        - await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailTextController.text,
                password: passwordTextController.text);
        - if (context.mounted) Navigator.pop(context);