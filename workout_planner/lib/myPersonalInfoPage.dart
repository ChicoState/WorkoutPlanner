import 'package:flutter/material.dart';
import 'main.dart';

// page to add and update personal weight
class MyPersonalInfoPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("Personal Information")
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Personal Information Page"),
            Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: MyCustomForm(),
              ),
                  ],
              )
            ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed:() {},
          child: Icon(Icons.add)
      ),

    );
  }
}

/*
 name: MyCustomForm
 type: class
 desc: Initiate MyCustomForm to a Stateful Widget and create the State.
 */
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() => MyCustomFormState();
}

/*
 name: MyCustomFormState
 type: class
 desc: Initiate the state of the
 */
class MyCustomFormState extends State<MyCustomForm> {

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    //Build a Form widget using the global key (_formKey) created above
    return Form(
        key: _formKey,
        //BUG: in the Container's EdgeInsets.all if I give it too high of a
        //value then I get a pixel overflow error. Try to find different
        //EdgeInset values that can fix this issue. For now its a small value.
        child: ListView(
            shrinkWrap: true,
            children: <Widget> [
              Container(
              padding: EdgeInsets.all(100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Form to type in
                  TextFormField(
                    validator: (value){
                      if (value.isEmpty){
                        return "Enter Your Weight";
                      }//if
                      //need to add validator for 3 digits
                      //need to validate isdigit
                      /*
                      else if (value.){

                      }
                      */
                    }, //validator
                    keyboardType: TextInputType.number
                  ),
                  //Padding for RaisedButton
                  Center(
                    child:Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: RaisedButton(
                          onPressed: () {
                            //Validate if true will return
                            //else form is invalid
                            if (_formKey.currentState.validate()) {
                              //if true show snackbar
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text(
                                  "Processing Data")));
                            }//if
                          },
                          child: Text("Submit"),
                        )
                      )
                    )
                  )
                ],
              )
            )
        ]
      )
    );
  }

}