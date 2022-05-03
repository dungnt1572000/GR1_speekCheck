
import 'package:doan1/constant/accessTokenTest.dart';
import 'package:doan1/searching/sear_viewmodel.dart';
import 'package:doan1/src/searching_service/searching_object.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../src/searching_service/api_search_client.dart';

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
        var searchingObject = ref.watch(SearchingObjectProvider);
        return Form(child: Column(
          children: [
            TextFormField(
              controller: _presentLocationController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (String str){
                Future.delayed(const Duration(milliseconds: 500),(){
                  if(str.isEmpty){
                    ref.read(openCloseupListProvider.state).update((state) => false);
                  }else{
                    ref.read(openCloseupListProvider.state).update((state) => true);

                  }
                });
              },
            ),
            // openCloseup?Expanded(child: ListView.builder(
            //   itemCount: searchingObject.features.length,
            //   itemBuilder: (context, index) {
            //     var checkType = searchingObject.features[index];
            //       if(checkType is PlaceObject){
            //         return ListTile(title: Text(checkType.text),subtitle: Text(checkType.placeName),);
            //       }else if(checkType is PositionObject){
            //         return ListTile(title: Text(checkType.text),subtitle: Text(checkType.placeName),);
            //       }else{
            //         return  ListTile(title: const Text('NaN'),);
            //       }
            // },)):const SizedBox(),
            TextFormField(
              controller: _wannagoLocationController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search some where',
                  suffixIcon: IconButton(onPressed: (){
                    SearchingClient(Dio()).fetchToGetSearchingObject('Hanoi', accessToken).then((value) {
                      Logger().e(value.features.length);
                    });

                  }, icon: const Icon(Icons.search))
              ),
              onChanged: (String str){
                Future.delayed(const Duration(milliseconds: 500),(){
                  if(str.isEmpty){
                    ref.read(openCloseupListProvider.state).update((state) => false);
                  }else{
                    ref.read(openCloseupListProvider.state).update((state) => true);

                  }
                });
              },
            ),
            openCloseup?Container(
              height: 350,
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  // var checkType = searchingObject.features[index];
                  // if(checkType is PlaceObject){
                  //   return ListTile(title: Text(checkType.text),subtitle: Text(checkType.placeName),);
                  // }else if(checkType is PositionObject){
                  //   return ListTile(title: Text(checkType.text),subtitle: Text(checkType.placeName),);
                  // }else{
                  //   return  ListTile(title: const Text('NaN'),);
                  // }
                  return  ListTile(title: const Text('NaN'),);
                },),
            ):const SizedBox(),
          ],
        ));
      },
    );
  }
}
