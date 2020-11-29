import 'dart:io';
import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//screen to create/edit the bill
class BillForm extends StatefulWidget {
  final bool isUpdating;

  BillForm({@required this.isUpdating});

  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autovalidate = false;
  // ignore: avoid_init_to_null
  String selectedCategory = null;
  // ignore: avoid_init_to_null
  String selectedCurrency = null;
  String name;

  Bill _currentBill;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime _warrantyValidUntil;
  var itemWarrantyLengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);

    if (billNotifier.currentBill != null) {
      _currentBill = billNotifier.currentBill;
    } else {
      _currentBill = Bill();
    }

    //setting initial value for editext widget
    if (_currentBill.warrantyLength == null) {
      _currentBill.warrantyLength = '';
    } else {
      itemWarrantyLengthController =
          TextEditingController(text: "${_currentBill.warrantyLength}");
    }
    _imageUrl = _currentBill.image;

    if (_currentBill.warrantyStart == null) {
      _currentBill.warrantyStart = Timestamp.fromDate(_selectedDate);
    }

    if (_warrantyValidUntil != null) {
      setState(() {
        _warrantyValidUntil = DateTime(
            _selectedDate.year,
            _selectedDate.month + int.parse(itemWarrantyLengthController.text),
            _selectedDate.day);

        _currentBill.warrantyEnd = Timestamp.fromDate(_warrantyValidUntil);
        _currentBill.warrantyLength = itemWarrantyLengthController.text;
      });
    }
  }

  _showImage() {
    //if there's any file chosen
    if (_imageFile == null && _imageUrl == null) {
      return Text(" ");
      //if local file is chosen
    } else if (_imageFile != null) {
      print('showing image from local file');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          //presenting a picture
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          //button to choose a file
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _showSelectionDialog(context),
          )
        ],
      );
      //showing item from url
    } else if (_imageUrl != null) {
      print('showing image from url');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _getLocalImage();
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _getImageFromCamera();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _getImageFromCamera() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildShopNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name of the shop'),
      autovalidate: _autovalidate,
      initialValue: _currentBill.nameShop,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name of the shop is required';
        }

        if (value.length < 2 || value.length > 20) {
          return 'Name must be more than 2 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.nameShop = value;
      },
    );
  }

  Widget _buildItemNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name of the item'),
      autovalidate: _autovalidate,
      initialValue: _currentBill.nameItem,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name of the item is required';
        }

        if (value.length < 2 || value.length > 20) {
          return 'Name must be more than 2 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.nameItem = value;
      },
    );
  }

  Widget _buildItemCategoryField() {
    return DropdownButtonFormField<String>(
      value: _currentBill.category,
      style: TextStyle(fontSize: 16, color: Colors.black),
      hint: Text('Choose category'),
      onChanged: (newValue) => setState(() => _currentBill.category = newValue),
      validator: (value) => value == null ? 'Item category required' : null,
      items: [
        'Electronics',
        'Fashion',
        'Sports',
        'Books/Music/Culture',
        'Home',
        'Food',
        'Health',
        'Services',
        'Other'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  //###############################
  //## Cost and currency widgets ##
  //###############################

  Widget _buildCostFieldValue() {
    return TextFormField(
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hoverColor: Colors.black,
        labelText: 'Price',
        labelStyle: TextStyle(fontSize: 16),
        isDense: true,
      ),
      initialValue: _currentBill.priceItem,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentBill.priceItem = value;
      },
    );
  }

  Widget _buildCostCurrencyField() {
    return DropdownButtonFormField<String>(
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      value: _currentBill.currencyItem,
      decoration: InputDecoration(
        hoverColor: Colors.black,
        labelText: 'Currency',
        labelStyle: TextStyle(fontSize: 16),
        isDense: true,
      ),
      onChanged: (newValue) =>
          setState(() => _currentBill.currencyItem = newValue),
      validator: (value) => value == null ? 'Currency required' : null,
      items: [
        'USD',
        'GBP',
        'EUR',
        'PLN',
        'INR',
        'RMB',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildCostField() {
    return
        //color: Colors.blue,
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            //color: Colors.red,
            child: _buildCostFieldValue(),
          ),
        ),
        SizedBox(width: 20.0),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: Container(
              //color: Colors.blue,
              child: _buildCostCurrencyField(),
            ),
          ),
        ),
      ],

      //),
    );
  }

  //######################
  //## Warranty widgets ##
  //######################

  void _presentDatePicker() {
    //Gives future, because we're waiting for user to pick up the date
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
        _currentBill.warrantyStart = Timestamp.fromDate(_selectedDate);

        _warrantyValidUntil = DateTime(
            _selectedDate.year,
            _selectedDate.month + int.parse(itemWarrantyLengthController.text),
            _selectedDate.day);

        _currentBill.warrantyEnd = Timestamp.fromDate(_warrantyValidUntil);
        _currentBill.warrantyLength = itemWarrantyLengthController.text;
      });
    });
  }

  void warrantyValidUntil() {
    if (itemWarrantyLengthController.text.isEmpty) {
      setState(() {
        _warrantyValidUntil = null;
      });
    } else {
      setState(() {
        _warrantyValidUntil = DateTime(
            _selectedDate.year,
            _selectedDate.month + int.parse(itemWarrantyLengthController.text),
            _selectedDate.day);

        _currentBill.warrantyEnd = Timestamp.fromDate(_warrantyValidUntil);
        _currentBill.warrantyLength = itemWarrantyLengthController.text;

        //setting if Warranty is still valid
        var now = DateTime.now();

        if (DateTime(now.year, now.month, now.day)
            .isBefore(_currentBill.warrantyEnd.toDate())) {
          _currentBill.warrantyValid = "VALID";
        }
        // Is now time is after the warranty End
        // If it's true warranty is Expired
        else if (DateTime(now.year, now.month, now.day)
            .isAfter(_currentBill.warrantyEnd.toDate())) {
          _currentBill.warrantyValid = "EXPIRED";
        }
      });
    }
    setState(() {
      _warrantyValidUntil = DateTime(
          _selectedDate.year,
          _selectedDate.month + int.parse(itemWarrantyLengthController.text),
          _selectedDate.day);

      _currentBill.warrantyEnd = Timestamp.fromDate(_warrantyValidUntil);
      _currentBill.warrantyLength = itemWarrantyLengthController.text;
    });
  }

  Widget _buildItemWarrantyLength() {
    //Data input - ITEM WARRANTY LENGTH
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 16),
              hintText: 'Enter warranty length in months',
              labelText: 'Warranty length'),
          controller: itemWarrantyLengthController,
          onChanged: (_) => warrantyValidUntil(),
          onSubmitted: (_) => warrantyValidUntil(),
        ),
      ),
    );
  }

  Widget _buildChooseStartDayButton() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: RaisedButton(
                textColor: Theme.of(context).accentColor,
                //color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  //side: BorderSide(color: Colors.orange),
                ),
                child: Text(
                  'Choose warranty start date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: _presentDatePicker,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Text(
                  _currentBill.warrantyStart == null
                      ? ''
                      : '${DateFormat.yMMMd().format(_currentBill.warrantyStart.toDate())}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarrantyValidUntil() {
    //DateTime - WARRANTY VALID UNTIL
    return Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              'Warranty valid until:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              _currentBill.warrantyEnd == null
                  ? Text('')
                  : '${DateFormat.yMMMd().format(_currentBill.warrantyEnd.toDate())}',
            ),
          ),
        ],
      ),
    );
  }

//#########################

  _onBillUploaded(Bill bill) {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    billNotifier.addBill(bill);
    Navigator.pop(context);
  }

  _saveBill() {
    print('saveBill Called');

    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadBillAndImage(
        _currentBill, widget.isUpdating, _imageFile, _onBillUploaded);

    print("name: ${_currentBill.nameShop}");
    print("category: ${_currentBill.category}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffB1097C),
                Color(0xff0947B1),
              ]),
        )),
        title: Text(
          widget.isUpdating ? "Edit Bill" : "Create Bill",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 16),
              SizedBox(height: 16),
              //if there's no image file
              _imageFile == null && _imageUrl == null
                  ? ButtonTheme(
                      child: RaisedButton(
                        color: buttonCustomColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          //side: BorderSide(color: Colors.orange),
                        ),
                        onPressed: () => _showSelectionDialog(context),
                        child: Text(
                          'Add Image',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: accentCustomColor),
                        ),
                      ),
                    )
                  : SizedBox(height: 16),
              SizedBox(height: 26),
              _buildShopNameField(),
              _buildItemNameField(),
              _buildItemCategoryField(),
              _buildCostField(),
              _buildItemWarrantyLength(),
              _buildChooseStartDayButton(),
              itemWarrantyLengthController.text.isEmpty
                  ? SizedBox(height: 2)
                  : _buildWarrantyValidUntil(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //FocusScope.of(context).requestFocus(new FocusNode());
          //Navigator.of(context).pop();
          _saveBill();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
