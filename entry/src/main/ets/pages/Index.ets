/*
 * 这里是主页面 包含了：聊天 通讯录 发现 我
 * 在主页面进行了数据初始化，并且将其存储到全局存储中
 * pyq_all_Page_data：公共朋友圈 数据
 * fake_person_data：个人朋友圈 数据 ，默认个人朋友圈数据中的第一个元素为主用户
 */

import { Chat_Page } from '../components/chat_Page';
import { Fx_Page } from '../components/fx_Page';
import { common } from '@kit.AbilityKit';
import { fake_all_data, fake_data, personal_data } from '../utils/dataModel';
import { combineAndSortData, sortPyqData, sortPyqDataList } from '../utils/tool';
import { pyq_all_Page_data } from './pyq_all_Page';
import { Txl_Page } from '../components/txl_Page';
import { Wo_Page } from '../components/wo_Page';
interface tabBar {
  tabIndex: number
  url: string,
  title: string
}

@Entry
@Component
struct Index {
  @State selectIndex: number = 0
  @State tabBarList: tabBar[] = [
    { tabIndex: 0, url: 'app.media.chat', title: '微信' },
    { tabIndex: 1, url: 'app.media.tongxunlu', title: '通讯录' },
    { tabIndex: 2, url: 'app.media.faxian', title: '发现' },
    { tabIndex: 3, url: 'app.media.wo2', title: '我' },
  ];
  @State fake_person_data: personal_data[] | undefined = undefined
  @State pyq_all_Page_data: pyq_all_Page_data[] = []
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    // 生成假数据以模拟真实场景中的个人信息
    this.fake_person_data = fake_data(this.context.getApplicationContext())
    // 将所有假数据添加到 个人朋友圈数据 中
    this.fake_person_data.push(fake_all_data(this.context.getApplicationContext()))

    // 对个人朋友圈数据进行按照年份进行降序排序
    this.fake_person_data = sortPyqData(this.fake_person_data)
    // 进一步对个人朋友圈数据列表按照月份进行降序排序
    this.fake_person_data = sortPyqDataList(this.fake_person_data)

    // 综合处理并排序所有数据，生成 公共朋友圈数据
    this.pyq_all_Page_data = combineAndSortData(this.fake_person_data)

    // 将处理后的所有数据保存到应用存储中，以便后续使用
    AppStorage.setOrCreate('pyq_all_Page_data', this.pyq_all_Page_data)
    AppStorage.setOrCreate('fake_person_data', this.fake_person_data)
  }

  @Builder
  taBarBuilder(tabindex: number, icon: string, title: string) {
    Column() {
      if (this.selectIndex == tabindex) {
        Image($r(icon))
          .fillColor('#07C160')
          .width(23)
          .margin({ bottom: 3 })
        Text(title)
          .fontColor('#07C160')
          .fontSize(12)
          .lineHeight(18)
      } else {
        Image($r(icon))
          .width(23)
          .margin({ bottom: 3 })
        Text(title)
          .fontColor(Color.Black)
          .fontSize(12)
          .lineHeight(18)
      }
    }.alignItems(HorizontalAlign.Center)
  }

  build() {
    Tabs() {
      TabContent() {
        Chat_Page()
      }
      .tabBar(this.taBarBuilder(this.tabBarList[0].tabIndex, this.tabBarList[0].url, this.tabBarList[0].title))

      TabContent() {
        Txl_Page()
      }.tabBar(this.taBarBuilder(this.tabBarList[1].tabIndex, this.tabBarList[1].url, this.tabBarList[1].title))

      TabContent() {
        Fx_Page()
      }.tabBar(this.taBarBuilder(this.tabBarList[2].tabIndex, this.tabBarList[2].url, this.tabBarList[2].title))

      TabContent() {
        Wo_Page()
      }.tabBar(this.taBarBuilder(this.tabBarList[3].tabIndex, this.tabBarList[3].url, this.tabBarList[3].title))
    }
    .barPosition(BarPosition.End)
    .scrollable(true)
    .animationDuration(100)
    .vertical(false)
    .onChange((index: number) => {
      this.selectIndex = index
    })
    .onTabBarClick((index: number) => {
      this.selectIndex = index
    })
  }
}