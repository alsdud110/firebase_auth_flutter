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

6. terminal : 
    - flutter pub add cloud_firestore

7. 데이터 가져오기
    - StreamBuilder(
        stream: FirebaseFirestore.instance.collection("테이블명").snapshot(),
        builder: (context, snapshot) {
            if(snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length;
                    itemBuilder: (context, index) {
                        final 객체 = snapshot.data.docs[index];
                        ex-> 객체 = post
                            - user = post["UserEmail"]; <-- 컬럼명
                            - post = post["Post"]; <-- 컬럼명
                            - date = post["Timestamp]; <-- 컬럼명
                        return 위젯;
                    }
                );
            } else if(snapshot.hasError) {
                return Center(child: Text("Error : ${snapshot.error}"));
            }
            return Center(child: CircularProgressIndicator());
        }
    )

8. 데이터 저장하기
    - FirebaseFirestore.instance.collection("테이블명").add({
        컬럼명 <-- "UserEmail" : FirebaseAuth.instance.currentUser.email,
        컬럼명 <-- "Post" : controller.text
        컬럼명 <-- "Timestamp" : Timestamp.now()
    });

9. Timestamp(FirebaseFirestore) -> DateTime -> String 변환하는 방법
    - add intl
    - Timestamp -> DateTime : 
        DateTime dateTime = (Timestamp)date.toDate();
    - DateTime -> String :
        String dateString = DateFormat("YYYY/MM/dd HH:MM").format(dateTime);