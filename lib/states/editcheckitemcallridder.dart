import 'package:flutter/material.dart';
import 'package:scnexpress/models/listitem_noaccept_model.dart';
import 'package:scnexpress/utility/my_constant.dart';
import 'package:scnexpress/widgets/Show_title.dart';

class CheckEditItemCallRider extends StatefulWidget {
  final ListItemNoAcceptModel listitemDetailModel;
  const CheckEditItemCallRider({Key? key, required this.listitemDetailModel})
      : super(key: key);

  @override
  State<CheckEditItemCallRider> createState() => _CheckEditItemCallRiderState();
}

class _CheckEditItemCallRiderState extends State<CheckEditItemCallRider> {
  ListItemNoAcceptModel? listItemNoAcceptModel;

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listItemNoAcceptModel = widget.listitemDetailModel;
    itemNameController.text = listItemNoAcceptModel!.bill_code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ແກ້ໄຂກວດສອບບິນ'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle('ເລກບິນສິນຄ້າ'),
                buildItemName(constraints),
              ],
            ),
          ),
        ));
  }

  Row buildItemName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            controller: itemNameController,
            decoration: InputDecoration(
              labelText: 'ເລກສິນຄ້າ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemType(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'ເລກສິນຄ້າ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemWight(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'ເລກສິນຄ້າ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildItemSize(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'ເລກສິນຄ້າ:',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }
}
