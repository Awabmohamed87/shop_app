import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/ed';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  var _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late Product product;
  late String id;
  var _initialValues = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = ModalRoute.of(context)!.settings.arguments.toString();

    id != 'null'
        ? product = Provider.of<Products>(context, listen: false).getProduct(id)
        : product =
            Product(id: '', title: '', description: '', price: 0, imageUrl: '');
    _initialValues = {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl
    };
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text('Edit Screen'),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (newValue) => _initialValues['title'] = newValue,
                      validator: (value) {
                        if (value!.isEmpty) return "Field can't be empty!";
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      initialValue: _initialValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (newValue) =>
                          _initialValues['description'] = newValue,
                      validator: (value) {
                        if (value!.isEmpty) return "Field can't be empty!";
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _priceFocusNode,
                      initialValue: _initialValues['price'].toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      onSaved: (newValue) =>
                          _initialValues['price'] = double.parse(newValue!),
                      validator: (value) {
                        if (value!.isEmpty) return "Field can't be empty!";
                        if (double.tryParse(value) == null)
                          return 'Enter a valid price!';
                        if (double.parse(value) < 0)
                          return 'Please enter a number greater than 0';
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border: Border.all(), color: Colors.grey),
                            child: _initialValues['imageUrl'] == ''
                                ? Text('No Image')
                                : FittedBox(
                                    child: Image.network(
                                        _initialValues['imageUrl']))),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormField(
                            focusNode: _imageUrlFocusNode,
                            initialValue: _initialValues['imageUrl'],
                            decoration: InputDecoration(labelText: 'Imageurl'),
                            keyboardType: TextInputType.url,
                            onFieldSubmitted: (newVal) {
                              setState(() {
                                _initialValues['imageUrl'] = newVal;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            onSaved: (newValue) {
                              setState(() {
                                _initialValues['imageUrl'] = newValue;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field can't be empty!";
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final newProduct = Product(
          id: id,
          title: _initialValues['title'],
          description: _initialValues['description'],
          price: _initialValues['price'],
          imageUrl: _initialValues['imageUrl']);
      if (product.id != '')
        await Provider.of<Products>(context, listen: false)
            .updateProduct(id, newProduct);
      else
        await Provider.of<Products>(context, listen: false)
            .addProduct(newProduct);
    } catch (erorr) {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }
}
