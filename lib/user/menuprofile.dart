import 'package:cproject/user/support.dart';
import 'package:cproject/user/userlogin.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../pages/login.dart';
import 'editprofile.dart';

class Profile05Widget extends StatefulWidget {
  const Profile05Widget({super.key});

  static String routeName = 'Profile05';
  static String routePath = '/profile05';

  @override
  State<Profile05Widget> createState() => _Profile05WidgetState();
}

class _Profile05WidgetState extends State<Profile05Widget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _moveAnimation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Set up the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _moveAnimation = Tween<Offset>(begin: Offset(0.0, 20.0), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor:Colors.white  ,
        appBar: AppBar(
          backgroundColor:  Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color:  Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1481819613568-3701cbc70156?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxOHx8bmlnaHQlMjBza3l8ZW58MHx8fHwxNzQxNjkxMjcwfDA&ixlib=rb-4.0.3&q=80&w=1080',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _moveAnimation,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Text(
                    'user',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                child: Text(
                  'user1@gmail.com',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color:  Colors.grey,
                  ),
                ),
              ),
              Divider(
                height: 44,
                thickness: 1,
                indent: 24,
                endIndent: 24,
                color: Theme.of(context).dividerColor,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCopyWidget()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Edit Profile',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuppWidget()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Help and Support',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_sharp,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Register as agency',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login2Widget()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_sharp,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Register as User',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    child: Text('Log Out'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor, backgroundColor:  Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
