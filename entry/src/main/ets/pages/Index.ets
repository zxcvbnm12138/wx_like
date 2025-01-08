import { Chat_Page } from '../components/chat_Page'
import { Fx_Page } from '../components/fx_Page';
import { common } from '@kit.AbilityKit';
import { fake_all_data, fake_data, personal_data } from '../utils/dataModel';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { sortPyqData, sortPyqDataList } from '../utils/tool';
import { combineAndSortData, pyq_all_Page_data } from './pyq_all_Page';

interface tabBar{
  tabIndex:number
  url:string,
  title:string
}

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext;
  @State selectIndex: number = 0
  @State tabBarList: tabBar[] = [
    { tabIndex: 0, url: 'app.media.chat', title: '微信' },
    { tabIndex: 1, url: 'app.media.tongxunlu', title: '通讯录' },
    { tabIndex: 2, url: 'app.media.faxian', title: '发现' },
    { tabIndex: 3, url: 'app.media.wo2', title: '我' },
  ];
  @State fake_person_data: personal_data[]|undefined = undefined
  @State pyq_all_Page_data:pyq_all_Page_data[] =[]
  aboutToAppear(): void {
    this.fake_person_data = fake_data(this.context.getApplicationContext())
    this.fake_person_data.push(fake_all_data(this.context.getApplicationContext()))

    this.fake_person_data=sortPyqData(this.fake_person_data)
    this.fake_person_data=sortPyqDataList(this.fake_person_data)

    this.pyq_all_Page_data = combineAndSortData(this.fake_person_data)
    AppStorage.setOrCreate('pyq_all_Page_data',this.pyq_all_Page_data)

    AppStorage.setOrCreate('fake_person_data',this.fake_person_data)
  }

  @Builder
  taBarBuilder(tabindex: number, icon: string, title: string) {
    Column() {
      if (this.selectIndex == tabindex) {
        Image($r(icon))
          .fillColor(Color.Green)
          .width(23)
          .margin({bottom:3})
        Text(title)
          .fontColor(Color.Green)
          .fontSize(12)
          .lineHeight(18)
      } else {
        Image($r(icon))
          .width(23)
          .margin({bottom:3})
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
      Text('通讯录内容')
    }.tabBar(this.taBarBuilder(this.tabBarList[1].tabIndex, this.tabBarList[1].url, this.tabBarList[1].title))

    TabContent() {
      Fx_Page()
    }.tabBar(this.taBarBuilder(this.tabBarList[2].tabIndex, this.tabBarList[2].url, this.tabBarList[2].title))

    TabContent() {
      Text('我内容')
    }.tabBar(this.taBarBuilder(this.tabBarList[3].tabIndex, this.tabBarList[3].url, this.tabBarList[3].title))
    }
    .barPosition(BarPosition.End)
    .scrollable(true)
    .animationDuration(100)
    .vertical(false)
    .onChange((index:number)=>{
      this.selectIndex = index
    })
    .onTabBarClick((index:number)=>{
      this.selectIndex = index
    })
  }
}