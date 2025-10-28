import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Item {
  String name;
  String address;
  String option;

  Item({required this.name, required this.address, required this.option});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = "Form Demo";
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedOption = "Take out";

  List<Item> _items = [];
  int? _selectedIndex;

  void _addItem() {
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter name and address")),
      );
      return;
    }
    setState(() {
      _items.add(Item(name: name, address: address, option: _selectedOption));
      _selectedIndex = _items.length - 1;
    });
  }

  void _editItem() {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an item to edit")),
      );
      return;
    }
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter name and address")),
      );
      return;
    }
    setState(() {
      _items[_selectedIndex!] = Item(name: name, address: address, option: _selectedOption);
    });
  }

  void _deleteItem() {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an item to delete")),
      );
      return;
    }
    setState(() {
      _items.removeAt(_selectedIndex!);
      if (_items.isEmpty) {
        _selectedIndex = null;
        _nameController.clear();
        _addressController.clear();
        _selectedOption = "Take out";
      } else {
        _selectedIndex = 0;
        final selected = _items[0];
        _nameController.text = selected.name;
        _addressController.text = selected.address;
        _selectedOption = selected.option;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelected = _selectedIndex != null;

    ButtonStyle buttonStyle(Color bgColor) {
      return ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 6,
        shadowColor: bgColor.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("VAT Name", style: TextStyle(color: Colors.grey[600])),
          Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Nhập tên",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text("VAT Address", style: TextStyle(color: Colors.blue)),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Nhập địa chỉ",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          RadioListTile<String>(
            title: Text("Take out"),
            value: "Take out",
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text("Sit down"),
            value: "Sit down",
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text("Delivery"),
            value: "Delivery",
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _addItem,
                icon: Icon(Icons.add),
                label: Text("Add"),
                style: buttonStyle(Colors.blue),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: hasSelected ? _editItem : null,
                icon: Icon(Icons.edit),
                label: Text("Edit"),
                style: buttonStyle(Colors.amber),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: hasSelected ? _deleteItem : null,
                icon: Icon(Icons.delete),
                label: Text("Delete"),
                style: buttonStyle(Colors.red),
              ),
            ],
          ),
          SizedBox(height: 32),
          Expanded(
            child: _items.isEmpty
                ? Center(child: Text("No items added"))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final selected = index == _selectedIndex;
                return ListTile(
                  selected: selected,
                  selectedTileColor: Colors.blue.shade100,
                  title: Text(item.name),
                  subtitle: Text("${item.address} - ${item.option}"),
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _nameController.text = item.name;
                      _addressController.text = item.address;
                      _selectedOption = item.option;
                    });
                  },
                );
              },
            ),
          ),
          if (hasSelected)
            Container(
              color: Colors.grey[900],
              width: double.infinity,
              padding: EdgeInsets.all(12),
              child: Text(
                "${_items[_selectedIndex!].name} ${_items[_selectedIndex!].address} ${_items[_selectedIndex!].option}",
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
