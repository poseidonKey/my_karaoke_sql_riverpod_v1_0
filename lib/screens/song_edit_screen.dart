import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/databases/db_helper.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/default_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_category.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_provider.dart';

class SongEditScreen extends ConsumerStatefulWidget {
  final SongItemModel songItem;
  const SongEditScreen({
    super.key,
    required this.songItem,
  });

  @override
  ConsumerState<SongEditScreen> createState() => _SongEditScreenState();
}

class _SongEditScreenState extends ConsumerState<SongEditScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? _songName, _songGYNumber, _songTJNumber, _songUtubeAddress, _songETC;
  final String _songFavorite = "false";
  late final String _id;
  String? _selJanre;
  @override
  void initState() {
    super.initState();
    _id = widget.songItem.id!;
    _selJanre = widget.songItem.songJanre;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final categories = ref.watch(songCategoryListNotifierProvider);
    return DefaultLayout(
      title: '곡 편집',
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        30.0,
                        20.0,
                        30.0,
                        10.0,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '곡명',
                        ),
                        initialValue: widget.songItem.songName,
                        validator: (val) =>
                            val!.trim().isEmpty ? '곡명은 필수 입니다.' : null,
                        onSaved: (val) => _songName = val,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5.0,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '금영노래방 번호',
                        ),
                        initialValue: widget.songItem.songGYNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        // validator: (val) =>
                        //     val!.trim().isEmpty ? '금영노래방 번호는 필수입니다' : null,
                        onSaved: (val) => _songGYNumber = val ?? "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5.0,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '태진노래방 번호',
                        ),
                        initialValue: widget.songItem.songTJNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSaved: (val) => _songTJNumber = val ?? "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selJanre ?? '쟝르를 선택하세요',
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          DropdownButton(
                            // items: ["팝", "발라드", "클래식", "트로트", "댄스"]
                            items: categories
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.songJanreCategory),
                                    ))
                                .toList(),
                            onChanged: (SongItemCategory? value) {
                              // print(value?.songJanreCategory);
                              setState(() {
                                _selJanre = value?.songJanreCategory ?? '';
                              });
                            },
                            icon: const Icon(Icons.pin_drop),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5.0,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '관련 유튜브 주소',
                        ),
                        initialValue: widget.songItem.songUtubeAddress,
                        onSaved: (val) => _songUtubeAddress = val ?? "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5.0,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '특기사항',
                        ),
                        initialValue: widget.songItem.songETC,
                        onSaved: (val) => _songETC = val ?? "",
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 30.0,
                    //     vertical: 5.0,
                    //   ),
                    //   child: TextFormField(
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       filled: true,
                    //       labelText: '날짜',
                    //     ),
                    //     // readOnly: true,
                    //     enabled: false,
                    //     onSaved: (val) => _createTime =
                    //         "${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}",
                    //   ),
                    // ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => submit("Edit"),
                          child: const Text(
                            '수정',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit(String mode) async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    print(_selJanre);
    try {
      DbHelper helper = DbHelper();
      await helper.openDb();
      final newEventDetail = SongItemModel(
          _id,
          _songName!,
          _songGYNumber!,
          _songTJNumber!,
          _selJanre ?? '',
          _songUtubeAddress!,
          _songETC!,
          "${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}",
          _songFavorite);
      await helper.updateData(newEventDetail);
      Navigator.pop(context, 'success');
    } catch (e) {
      print(e);
    }
  }
}
