import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/default_layout.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/models/song_item_model.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_category_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/song_item_notifier_fb_provider.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/riverpods/uid_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/util/firebase_service.dart';

class SongEditScreenFirebase extends ConsumerStatefulWidget {
  final SongItemModel songItem;
  const SongEditScreenFirebase({
    super.key,
    required this.songItem,
  });

  @override
  ConsumerState<SongEditScreenFirebase> createState() =>
      _SongEditScreenFirebaseState();
}

class _SongEditScreenFirebaseState
    extends ConsumerState<SongEditScreenFirebase> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? _songName, _songGYNumber, _songTJNumber, _songUtubeAddress, _songETC;
  final String _songFavorite = "false";
  String _selJanre = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(songCategoryListNotifierFirebaseProvider);
    List<String> cateList = [];

    for (var element in categories) {
      cateList.add(element.songJanreCategory);
    }
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DefaultLayout(
      title: '곡 편집',
      body: Padding(
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        const Text(
                          "노래 쟝르를 선택하세요!",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                          items: cateList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selJanre = value ?? "";
                            });
                          },
                          icon: const Icon(Icons.pin_drop),
                        ),
                        Text(_selJanre)
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
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => submit("Edit"),
                    child: const Text(
                      'Edit Song',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
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
    try {
      final newEventDetail = SongItemModel(
          widget.songItem.id,
          _songName!,
          _songGYNumber!,
          _songTJNumber!,
          _selJanre,
          _songUtubeAddress!,
          _songETC!,
          "${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}",
          _songFavorite);
      final item = newEventDetail.toMap();
      final uid = ref.read(uidProvider);
      MyFirebaseService.instance
          .doc(uid)
          .collection('songs')
          .doc(widget.songItem.id)
          .update(item);
      await ref
          .read(songListFirebaseProvider.notifier)
          .refreshSongDataAndSortByNo();
      Navigator.pop(context, 'success');
    } catch (e) {
      print(e);
    }
  }
}
