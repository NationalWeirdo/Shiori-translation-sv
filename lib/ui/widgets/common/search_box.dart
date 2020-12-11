import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class SearchBox extends StatefulWidget {
  final bool showClearButton;
  const SearchBox({
    Key key,
    this.showClearButton = true,
  }) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchFocusNode = FocusNode();
  TextEditingController _searchBoxTextController;

  @override
  void initState() {
    super.initState();
    _searchBoxTextController = TextEditingController(text: '');
    _searchBoxTextController.addListener(_onSearchTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              controller: _searchBoxTextController,
              focusNode: _searchFocusNode,
              cursorColor: theme.accentColor,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: '${s.search}...',
              ),
            ),
          ),
          if (widget.showClearButton)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cleanSearchText,
            ),
        ],
      ),
    );
  }

  void _onSearchTextChanged() {}

  void _cleanSearchText() {
    _searchFocusNode.requestFocus();
    if (_searchBoxTextController.text.isEmpty) {
      return;
    }
    _searchBoxTextController.text = '';
  }
}
