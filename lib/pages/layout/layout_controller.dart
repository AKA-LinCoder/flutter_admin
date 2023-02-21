/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:

import 'package:flutter_admin/constants/enum.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  MenuDisplayType? menuDisplayType = MenuDisplayType.side;
  bool isMaximize = false;

  ///@title toggleMaximize
  ///@description TODO  改变body是否全屏显示
  ///@updateTime 2023/2/21 16:39
  ///@author LinGuanYu
  toggleMaximize() {

    this.isMaximize = !this.isMaximize;
    this.update();
  }

  ///@title updateMenuDisplayType
  ///@description TODO 更新左侧菜单展示方式
  ///@param: v
  ///@updateTime 2023/2/21 16:38
  ///@author LinGuanYu
  updateMenuDisplayType(v) {

    menuDisplayType = v;
    update();
  }
}
