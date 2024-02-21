import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/tracking_helper.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gửi yêu cầu"),
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 5.0, left: 15.0, right: 15.0),
                  child: Card(
                    elevation: 6,
                    child: Form(
                        // key: _formKey,
                        // autovalidate: _autoValidate,
                        child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      children: <Widget>[
                        //===> Student Number Text Input starts from here <===
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            autofocus: false,
                            // focusNode: myFocusNodeEmail,
                            // controller: studentNumberController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Code',
                            ),
                            onChanged: (value) {},
                            // validator: validateStudentNumber,
                            // onSaved: (String val) {
                            //   _stNumber = val;
                            // },
                          ),
                        ),

                        //===> Email Address Text Input starts from here <===
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 1.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            // validator: validateStudentEmailAddress,
                            // onSaved: (String val) {
                            //   _stEmail = val;
                            // },
                            // controller: studentEmailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                        //===> Phone Number Text Input starts from here <===
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 1.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            // validator: validateStudentPhoneNumber,
                            // onSaved: (String val) {
                            //   _stPhone = val;
                            // },
                            // controller: studentPhoneNumberController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[()\d -]{1,15}$')),
                            ],
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ),

                        //===> Query Text Input starts from here <===
                        TextFormField(
                          // validator: validateStudentQuery,
                          // onSaved: (String val) {
                          //   _query = val;
                          // },
                          // controller: queryController,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Your Query',
                          ),
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          maxLines: 3,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 6.0, bottom: 5),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xFF008ECC),
                                  offset: Offset(0.0, 0.0),
                                  //blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: Color(0xFF008ECC),
                                  offset: Offset(0.0, 0.0),
                                  //blurRadius: 20.0,
                                ),
                              ],
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF008ECC),
                                    //Colors is Olympic blue
                                    Color(0xFF008ECC),
                                  ],
                                  begin: FractionalOffset(0.2, 0.2),
                                  end: FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Đã gửi thành công')));
                                TrackingHelper.logEvent(event: "SendContact");
                                Navigator.of(context).pop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 65.0),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
