import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBox({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color.fromRGBO(217, 217, 217, 100),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      onChanged: onChanged,
    );
  }
}

class SearchTerm {
  final String term;

  const SearchTerm(this.term);
}
