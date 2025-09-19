// import 'package:first_app/views/pages/expended_flexible_page.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  bool? isChenked = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? menuItem = 'e1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Add this line
            children: [
              DropdownButton(
                value: menuItem,
                items: [
                  DropdownMenuItem(value: 'e1', child: Text('ELement 1')),
                  DropdownMenuItem(value: 'e2', child: Text('ELement 2')),
                  DropdownMenuItem(value: 'e3', child: Text('ELement 3')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    menuItem = value;
                  });
                },
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your name',
                ),
                onEditingComplete: () {
                  setState(() {});
                },
              ),
              Text(controller.text),
              Checkbox.adaptive(
                tristate: true,
                value: isChenked,
                onChanged: (bool? value) {
                  setState(() {
                    isChenked = value;
                  });
                },
              ),
              CheckboxListTile.adaptive(
                tristate: true,
                title: Text('Click me'),
                value: isChenked,
                onChanged: (bool? value) {
                  setState(() {
                    isChenked = value;
                  });
                },
              ),
              Switch.adaptive(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SwitchListTile.adaptive(
                title: Text('Switch me'),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              Slider.adaptive(
                min: 0,
                max: 100,
                divisions: 10,
                value: sliderValue,
                onChanged: (double value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),
              sliderValue == 0
                  ? Text('Slider is at minimum')
                  : sliderValue == 100
                  ? Text('Slider is at maximum')
                  : Text('Slider value: $sliderValue'),
              Container(
                margin: EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    developer.log('Image tapped');
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.white12,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text('Hello from snackbar'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Open snackbar'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AboutDialog(
                          applicationName: 'First app',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(Icons.account_tree),
                          children: [Text('This is a simple app')],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Open AboutDialog'),
                ),
              ),
              Divider(color: Colors.teal, thickness: 5.0, endIndent: 200.0),
              Container(height: 50.0, child: VerticalDivider()),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Alert Dialog'),
                        content: Text('This is an alert dialog'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Open AlertDialog'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return ExtendedFlexiblePage();
              //         },
              //       ),
              //     );
              //   },
              //   child: Text('Show Flexible and Expanded'),
              // ),
              FilledButton(onPressed: () {}, child: Text('Submit')),
              TextButton(onPressed: () {}, child: Text('Submit')),
              OutlinedButton(onPressed: () {}, child: Text('Submit')),
              CloseButton(),
              BackButton(),
            ],
          ),
        ),
      ),
    );
  }
}
