
import 'package:doan1/searching/sear_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchingBar extends StatelessWidget {
  const SearchingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _presentLocationController = TextEditingController();
    TextEditingController _wannagoLocationController = TextEditingController();
    _presentLocationController.text = 'Your Location';
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        bool openCloseup = ref.watch(openCloseupListProvider);
        return Form(child: Column(
          children: [
            TextFormField(
              controller: _presentLocationController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (String str){
                Future.delayed(Duration(milliseconds: 500),(){
                  if(str.isEmpty){
                    ref.read(openCloseupListProvider.state).update((state) => false);
                  }else{
                    ref.read(openCloseupListProvider.state).update((state) => true);
                    
                  }
                });
              },
            ),
            openCloseup?Text('Proplayer'):SizedBox(),
            TextFormField(
              controller: _wannagoLocationController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search some where',
                  suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search))
              ),
            )
          ],
        ));
      },
    );
  }
}
