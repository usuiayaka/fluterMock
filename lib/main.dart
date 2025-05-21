import 'package:flutter/material.dart';
import 'package:flutter_application_1/Welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // これはアプリケーションのテーマです。
        //
        // 【試してみよう】: アプリケーションを "flutter run" で実行してみてください。
        // パープルのツールバーが表示されるはずです。その後、アプリを終了せずに、
        // 下の colorScheme にある seedColor を Colors.green に変更してみてください。
        // 変更を保存するか、Flutter 対応 IDE の「ホットリロード」ボタンを押すか、
        // コマンドラインで起動した場合は「r」キーを押すことで、ホットリロードが実行されます。
        //
        // カウンターが 0 にリセットされなかったことに注目してください。
        // ホットリロード中はアプリケーションの状態は失われません。
        // 状態をリセットしたい場合は、「ホットリスタート」を使用してください。
        //
        // これは値だけでなくコードの変更にも有効です。
        // ほとんどのコード変更はホットリロードだけで確認できます。

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Welcome(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // このウィジェットは、アプリケーションのホームページです。これは「ステートフル」であり、
  // 見た目に影響を与えるフィールドを含む State オブジェクト（下で定義）が存在することを意味します。

  // このクラスは、その State の設定情報を持ちます。親（この場合は App ウィジェット）から
  // 渡された値（この例ではタイトル）を保持し、State の build メソッドで使用されます。
  // Widget を継承するクラス内のフィールドは常に「final」としてマークされます。

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
// この setState の呼び出しは、Flutter フレームワークに「この State に何らかの変更があった」ことを伝えます。
// その結果、下の build メソッドが再実行され、表示が更新された値を反映するようになります。
// もし setState() を使わずに _counter を変更した場合、build メソッドは再度呼び出されないため、
// 表示上は何も変化がないように見えてしまいます。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // このメソッド（build メソッド）は、たとえば上記の _incrementCounter メソッドによって
    // setState が呼び出されるたびに再実行されます。
    //
    // Flutter フレームワークは build メソッドの再実行が高速に行えるよう最適化されているため、
    // 更新が必要な部分を個別に変更する代わりに、必要なウィジェットをまるごと再構築することができます。

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // ここでは、App.build メソッドによって作成された MyHomePage オブジェクトから
        // 値を取得し、それを使って AppBar のタイトルを設定しています。

        title: Text(widget.title),
      ),
      body: Center(
        // Center はレイアウトウィジェットです。1つの子ウィジェットを取り、
        // 親ウィジェットの中央に配置します。

        child: Column(
          // Column もレイアウトウィジェットです。複数の子ウィジェットを受け取り、
          // 垂直方向に並べます。デフォルトでは、子ウィジェットの横幅に合わせてサイズを決定し、
          // 高さは可能な限り親の高さに合わせようとします。
          //
          // Column には、自身のサイズや子ウィジェットの配置方法を制御する
          // さまざまなプロパティがあります。ここでは mainAxisAlignment を使って、
          // 子ウィジェットを縦方向（メイン軸）に中央配置しています。
          // Column は縦方向のウィジェットなので、メイン軸は縦軸で、
          // クロス軸は横軸になります。
          //
          // 【試してみよう】: 「デバッグペイント」を使ってみましょう
          // （IDE の「Toggle Debug Paint」アクションを選ぶか、
          // コンソールで「p」キーを押します）、
          // 各ウィジェットのワイヤーフレーム（枠線）が表示されます。

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // この末尾のカンマは、build メソッドの自動フォーマットをより見やすくしてくれます。
    );
  }
}
