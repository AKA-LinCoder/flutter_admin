/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:

import 'package:cry/common/indexed_stack_lazy.dart';
import 'package:cry/cry_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/common/routes.dart';
import 'package:flutter_admin/constants/enum.dart';
import 'package:flutter_admin/models/tab_page.dart';
import 'package:flutter_admin/pages/layout/layout_controller.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';

///主体页面显示
class LayoutCenter extends StatefulWidget {
  LayoutCenter({Key? key}) : super(key: key);

  @override
  LayoutCenterState createState() => LayoutCenterState();
}

class LayoutCenterState extends State<LayoutCenter> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openedTabPageList = StoreUtil.readOpenedTabPageList();
    print("已经打开的列表长度${openedTabPageList.length}");
    ///因为联网获取了默认的首页 （可配置）所以默认会有一个
    if(openedTabPageList.length==0){
      return Container();
    }
    var currentOpenedTabPageId = StoreUtil.readCurrentOpenedTabPageId();
    int currentIndex = openedTabPageList.indexWhere((note) => note!.id == currentOpenedTabPageId);
    ///初始化tabController 指向默认tab
    var tabController = TabController(vsync: this, length: openedTabPageList.length, initialIndex: currentIndex);
    var defaultTabs = StoreUtil.getDefaultTabs();

    LayoutController layoutController = Get.find();
    ///监听菜单切换
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        StoreUtil.writeCurrentOpenedTabPageId(openedTabPageList[tabController.index]!.id);
        layoutController.update();
      }
    });

    ///所以需要展示在上面的tab
    TabBar tabBar = TabBar(
      controller: tabController,
      isScrollable: true,
      indicator: const UnderlineTabIndicator(),
      tabs: openedTabPageList.map<Tab>((TabPage? tabPage) {
        ///单个菜单项布局
        var tabContent = Row(
          children: <Widget>[
            Text(Utils.isLocalEn(context) ? tabPage!.nameEn ?? '' : tabPage!.name ?? ''),
            if (!defaultTabs.contains(tabPage))
              Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  width: 25,
                  child: IconButton(
                    iconSize: 10,
                    splashRadius: 10,
                    onPressed: () => Utils.closeTab(tabPage),
                    icon: Icon(Icons.close),
                  ),
                ),
              )
          ],
        );

        return Tab(
          child: CryMenu(
            child: tabContent,
            onSelected: (dynamic v) {
              print("这是v$v");
              switch (v) {
                case TabMenuOption.close:
                  Utils.closeTab(tabPage);
                  break;
                case TabMenuOption.closeAll:
                  Utils.closeAllTab();
                  break;
                case TabMenuOption.closeOthers:
                  Utils.closeOtherTab(tabPage);
                  break;
                case TabMenuOption.closeAllToTheRight:
                  Utils.closeAllToTheRightTab(tabPage);
                  break;
                case TabMenuOption.closeAllToTheLeft:
                  Utils.closeAllToTheLeftTab(tabPage);
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<TabMenuOption>>[
              if (!defaultTabs.contains(tabPage))
                PopupMenuItem(
                  value: TabMenuOption.close,
                  child: ListTile(
                    title: Text('Close'),
                  ),
                ),
              PopupMenuItem(
                value: TabMenuOption.closeAll,
                child: ListTile(
                  title: Text('Close All'),
                ),
              ),
              PopupMenuItem(
                value: TabMenuOption.closeOthers,
                child: ListTile(
                  title: Text('Close Others'),
                ),
              ),
              PopupMenuItem(
                value: TabMenuOption.closeAllToTheRight,
                child: ListTile(
                  title: Text('Close All to the Right'),
                ),
              ),
              PopupMenuItem(
                value: TabMenuOption.closeAllToTheLeft,
                child: ListTile(
                  title: Text('Close All to the Left'),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    ///具体菜单内容
    var content = Container(
      child: Expanded(
        child: IndexedStackLazy(
          index: currentIndex,
          children: openedTabPageList.map((TabPage? tabPage) {
            ///page:具体页面的数据
            var page = tabPage!.url != null ? Routes.layoutPagesMap[tabPage.url!] ?? Container() : tabPage.widget ?? Container();
            return KeyedSubtree(
              child: page,
              key: Key('page-${tabPage.id}'),
            );
          }).toList(),
        ),
      ),
    );

    var result = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: context.theme.primaryColor,
            child: Row(
              children: <Widget>[
                ///展示顶部可以删除的tab
                Expanded(child: tabBar),
                ///全屏展示按钮
                IconButton(
                  onPressed: () => layoutController.toggleMaximize(),
                  icon: Icon(layoutController.isMaximize ? Icons.close_fullscreen : Icons.open_in_full),
                  iconSize: 20,
                  color: Colors.white,
                )
              ],
            ),
          ),
          ///具体显示内容
          content,
        ],
      ),
    );
    return result;
  }
}
