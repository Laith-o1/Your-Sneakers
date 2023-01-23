import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'Data_model/product_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Productlist> _cartItems = [];

  void _addToCart(Productlist item) {
    if (!_cartItems.any((element) => element.id == item.id)) {
      setState(() {
        _cartItems.add(item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Cart(cartItems: _cartItems),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.shopping_cart),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: readjson(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          } else if (snapshot.hasData) {
            var items = snapshot.data as List<Productlist>;

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(items[index].imageUrl!),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(items[index].name!),
                              Text(items[index].category!),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                items[index]
                                    .oldPrice!
                                    .toString()
                                    .replaceAll('null', ''),
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Color.fromARGB(255, 255, 0, 0)),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(items[index].price!,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 9, 255, 0))),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              _addToCart(items[index]);
                            },
                            child: const Text('Add to cart'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('hi data');
          }
        },
      ),
    );
  }

  Future<List<Productlist>> readjson() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('Data/products.json');
    final list = jsonDecode(jsondata) as List<dynamic>;
    return list.map((e) => Productlist.fromjson(e)).toList();
  }
}

// the cart page
class Cart extends StatefulWidget {
  final List<Productlist> cartItems;

  const Cart({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading:
                  Image.network(widget.cartItems[index].imageUrl.toString()),
              title: Text(widget.cartItems[index].name.toString()),
              subtitle: Text("${widget.cartItems[index].price}"),
              // add button to remove item from cart
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    widget.cartItems.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// add login page
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(
              width: 300,
              height: 250,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Enter your email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: 'Enter your password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('welcome to the sneakers app'),
                            duration: Duration(seconds: 3)),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: 'Your Sneakers')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    fixedSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        //  Alignment the button to the center
                        side: const BorderSide(color: Colors.grey)),
                  ),
                  child: const Text('Submit')),
            ),
          ],
        ),
      ),
    );
  }
}

// add register page
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Processing Data'),
                          duration: Duration(seconds: 3)),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
