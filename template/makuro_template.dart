import 'package:flutter/material.dart';
import 'package:hide_keyboard/hide_keyboard.dart';
import 'package:get/get.dart';
import 'package:laundriku/makuro_db/makuro_query.dart';


/// template digunakan untuk standart page
/// 
/// jangan lupa menyertakan [T] adalah Tipe dari class
/// 
/// __CONTOH__
/// 
/// ```dart
/// class Customer extends MakuroTemplate<Customer>{}
/// ```
/// 
/// .
abstract class MakuroTemplate<T> extends StatelessWidget{
  final searchController = TextEditingController();
  final ValueNotifier<GlobalKey<FormState>> keyForm = ValueNotifier(GlobalKey<FormState>());
  ValueNotifier<String> get selectValue;
  ValueNotifier<List<T>> get lsData;

  /// title atau judul untuk disamping backbutton
  /// 
  /// __CONTOH__
  /// 
  /// ```dart
  /// <- NAMA_PAGE
  /// ```
  /// 
  /// .
  String get title;

  @override
  Widget build(BuildContext context) =>
  HideKeyboard(
    child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                BackButton(),
                Text(title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
            Flexible(child: widgetBody())
          ],
        ),
      ),
    ),
  );

  Widget widgetBody();


  Widget widgetListView(Function(T) selected, {bool isSelectAble = false,  bool isPopUp = false}) => 
  widgetLoad(
    child: ValueListenableBuilder(
      valueListenable: lsData, 
      builder: (context, value, child) => 
      ListView(
        physics: BouncingScrollPhysics(),
        children: widgtList(selected, isSelectAble, isPopUp)
      ),
    )
  );

  List<Widget> widgtList(Function(T) selected, bool isSelectAble, bool isPopUp);

  onTapWidgetList({bool isSelectAble = false, T? model, String? value, bool isPopUp = false, Function(T)? selected,}){
    if(isSelectAble){
      selectValue.value = value!;
      if(isPopUp){
        selected!(model!);
        Get.back();
      }else{
        selected!(model!);
      }
      
    }else{
      widgetAddBottomSheet(isEdit: true, model: model);
    }
  }

  List<Widget> widgetListForm();


  /// sebuah tombol untuk memicu bottoSheet
  /// [tx] adalah nama dari tombol
  /// 
  /// __CONTOH__
  /// 
  /// ```dart
  /// buttonAdd("tambah customer")
  /// ```
  /// 
  /// .
  Widget buttonAddWidget(String tx)=>
  TextButton(
    onPressed: () => widgetAddBottomSheet(
      isEdit: false
    ), 
    child: Text(tx)
  );

  Widget buttonSelect(Function(T) hasil) =>
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: OutlinedButton(
      onPressed: () => Get.bottomSheet(
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                Flexible(
                  child: widgetListView(hasil, isSelectAble: true, isPopUp: true)
                )
              ],
            ),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        enterBottomSheetDuration: Duration(seconds: 0),
        exitBottomSheetDuration: Duration(seconds: 0)
      ), 
      child: ValueListenableBuilder(
        valueListenable: selectValue,
        builder: (context, value, child) => 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.toString()),
            Icon(
              Icons.arrow_drop_down
            )
          ],
        ),
      )
    ),
  );

  //onSelected(T model);

  widgetAddBottomSheet({bool? isEdit, T? model}) =>
  Get.bottomSheet(
    FutureBuilder(
      future: onCheckEdit(isEdit!, model),
      builder: (context, snapshot) => 
      snapshot.connectionState != ConnectionState.done?
      Text("loading")
      : DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => 
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(),
                  Text(isEdit? "EDIT $title": "ADD $title", 
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: keyForm.value,
                    child: Column(
                      children: widgetListForm(),
                    ),
                  ),
                )
              
              ),
              isEdit?
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () => onDelete(model!),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          child: Text("DELETE",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () => onUpdate(model!),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            child: Text("UPDATE",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
              :Container(
                child: Card(
                  margin: EdgeInsets.all(8),
                  color: Colors.orange,
                  child: InkWell(
                    onTap: onSave,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Text("SAVE",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    isDismissible: true,
    enterBottomSheetDuration: Duration(seconds: 0),
    exitBottomSheetDuration: Duration(seconds: 0)
  );


  Widget widgetLoad({Widget? child}) =>
  FutureBuilder(
    future: onLoadData(),
    builder: (context, snapshot) => 
    snapshot.connectionState != ConnectionState.done?
    Center(
      child: CircularProgressIndicator(strokeWidth: 0.5,backgroundColor: Colors.orange,)
    )
    : child!,
  );

  Widget widgetSearch()=>
  Container(
    padding: EdgeInsets.all(8),
    child: TextFormField(
      controller: searchController,
      onChanged: onSearch,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
        labelText: "search",
        prefixIcon: Icon(Icons.search),
        suffixIcon: InkWell(
          onTap: () {
            searchController.text = "";
            HideKeyboard.now();
            onLoadData();
          },
          child: Icon(Icons.remove,
            color: Colors.red,
          ),
        )
      ),
    ),
  );

  onCheckEdit(bool isEdit, T? model);

  onSave();

  onUpdate(T model);

  onDelete(T model);
  
  onSearch(String value);

  onLoadData();

  
  Future<bool> willSave({required Future<bool?> cek})async{
    final ada = await cek;
    if(ada!){
      Get.snackbar("INFo", "name already taken", backgroundColor: Colors.black, colorText: Colors.white,borderRadius: 0);
      return false;
    }else{
      return true;
    }
  }

  willUpdate(Future<int?> update)async{
    final id = await update;
    onLoadData();
    Get.back();
    print("update $id");
  }

  willDelete(Future<int?> hapus)async{
    final id = await hapus;
    onLoadData();
    Get.back();
    print("hapus $id");
  }


  Widget widgetSingleForm({String? lableText, Icon? prefixIcon, TextEditingController? controller, TextInputType? inputType, bool isNote = false}) =>
  Container(
    padding: EdgeInsets.all(8),
    child: TextFormField(
      textAlignVertical: TextAlignVertical.top,
      validator: (value) => value!.isEmpty? "no empty is allowed": null,
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      maxLength: isNote? 100 : 50,
      maxLines: isNote ? 3: 1,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
        labelText: lableText,
        prefixIcon: prefixIcon,
      ),
    ),
  );

  Widget buttonRadio(List<String> target, TextEditingController controller, {Function(String)? hasil}) {
    final kunci = ValueNotifier(controller.text.isEmpty? target[0]: controller.text);

    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4)
      ),
      child: ValueListenableBuilder(
        valueListenable: kunci, 
        builder: (context, value, child) => 
        Wrap(
          alignment: WrapAlignment.start,
          children: [
            for(final tr in target)
            InkWell(
              onTap: (){
                kunci.value = tr;
                controller.text = tr;
                hasil!(tr);
              },
              child: Container(
                width: Get.width / 2,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      width: 20,
                      height: 20,
                      child: Center(
                        child: kunci.value == tr?
                        Icon(
                          Icons.check,
                          size: 16,
                        )
                        : SizedBox.shrink(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Text(tr.toUpperCase(),
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  
  
  
}
