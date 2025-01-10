import { pyq_all_Page_data } from '../pages/pyq_all_Page';
import { image_show } from '../utils/tool';

interface data {
  avatar_url: string;
  nickname: string;
}

interface txlTable {
  title: string;
  projects: data[];
}

@Component
export struct Txl_Page {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = []
  @State selectedIndex: number = 0;
  @State alphabets: string[] = ['↑', '☆']
  private listScroller: Scroller = new Scroller();
  private txlTable: txlTable[] = [
    {
      title: 'A',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '1' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '2' },
      ]
    },
    {
      title: 'B',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '3' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '4' },
      ]
    },
    {
      title: 'C',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '5' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '6' },
      ]
    },
    {
      title: 'D',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '89' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '9' },
      ]
    },
    {
      title: 'E',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '7' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '8' },
      ]
    },
    {
      title: 'F',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '10' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '11' },
      ]
    },
    {
      title: 'G',
      projects: [
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '菠萝吹雪' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '12' },
        { avatar_url: this.pyq_all_Page_data[0].avatar, nickname: '13' },
      ]
    },
  ]

  updateAlphabets() {
    this.alphabets.length = 2; // 保留前两个元素
    this.txlTable.forEach((item: txlTable) => {
      this.alphabets.push(item.title);
    });
    this.alphabets.push('#'); // 添加最后一个元素
  }

  aboutToAppear(): void {
    this.updateAlphabets()
  }

  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(10)
      .backgroundColor('#ededed')
      .width("100%")
      .padding({left: 10,top:5,bottom:5})
  }

  build() {
    Stack() {
      Row() {
        Row() {
          Text('通讯录').fontSize(18)
            .lineHeight(25)
            .fontColor(Color.Black)
            .border({ width: 0 })
          Row({ space: 20 }) {
            Image($r('app.media.mti_search'))
              .width(22)
            Image($r('app.media.mti_add'))
              .width(22)
          }
        }
        .width('56%')
        .border({ width: 0 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .border({ width: 0 })
      .width('100.00%')
      .height(54)
      .backgroundColor('#EDEDED')
      .padding({ right: 10, left: 10 })
      .justifyContent(FlexAlign.End)

      List({ scroller: this.listScroller }) {
        ListItemGroup() {
          ForEach([
            { avatar_url: 'app.media.xindepengyou', nickname: '新的朋友' },
            { avatar_url: 'app.media.liaotiandepengyou', nickname: '仅聊天的朋友' },
            { avatar_url: 'app.media.qunliao', nickname: '群聊' },
            { avatar_url: 'app.media.weixinbiaoqian', nickname: '标签' },
            { avatar_url: 'app.media.gzh', nickname: '公众号' },
            { avatar_url: 'app.media.fwh', nickname: '服务号' },
          ] as data[], (item: data) => {
            ListItem() {
              Row() {
                Image($r(item.avatar_url))
                  .width(40)
                  .height(40)
                  .borderRadius(5)
                Text(item.nickname)
                  .margin({ left: 10 })
              }
              .alignItems(VerticalAlign.Center)
            }
            .padding({ left: 15, top: 8, bottom: 8 })
          })
        }
        .divider({ strokeWidth: 0.5, color: '#D7D7D7', startMargin: 65 })

        ListItemGroup({ header: this.itemHead('我的企业及企业联系人') }) {
          ListItem() {
            Row() {
              Image($r('app.media.qywx'))
                .width(40)
                .height(40)
                .borderRadius(5)
              Text('企业微信联系人')
                .margin({ left: 10 })
            }.alignItems(VerticalAlign.Center)
          }
          .padding({ left: 15, top: 8, bottom: 8 })
        }

        ListItemGroup({ header: this.itemHead('星标朋友') }) {
          ListItem() {
            Row() {
              Image($r('app.media.qywx'))
                .width(40)
                .height(40)
                .borderRadius(5)
              Text('企业微信联系人')
                .margin({ left: 10 })
            }.alignItems(VerticalAlign.Center)
          }
          .padding({ left: 15, top: 8, bottom: 8 })
        }.visibility(Visibility.None)

        ForEach(this.txlTable, (item: txlTable) => {
          ListItemGroup({ header: this.itemHead(item.title) }) {
            ForEach(item.projects, (project: data) => {
              ListItem() {
                Row() {
                  Image(image_show(project.avatar_url))
                    .width(40)
                    .height(40)
                    .borderRadius(5)
                  Text(project.nickname)
                    .margin({ left: 10 })
                }.alignItems(VerticalAlign.Center)
              }
              .padding({ left: 15, top: 8, bottom: 8 })
            })
          }
          .divider({ strokeWidth: 0.5, color: '#D7D7D7', startMargin: 65 })
        })
      }
      .width('100%')
      .margin({ top: 54 })
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)

      // .onScrollIndex((firstIndex: number) => {
      //   this.selectedIndex = firstIndex;
      //   hilog.fatal(0x0001, 'test', 'onScrollIndex: ' + firstIndex)
      // })

      Column() {
        AlphabetIndexer({ arrayValue: this.alphabets, selected: 0 })
          .alignStyle(IndexerAlign.Right, 15)
          .autoCollapse(false)
          .usingPopup(true)
          .enableHapticFeedback(false)
          .selectedColor('#FFFFFF')
          .selectedBackgroundColor('#07C160')
          .popupColor('#FFFFFF')
          .popupBackground(Color.Black)
          .popupTitleBackground('#cccccc')
          .popupItemBorderRadius(24)

          .onSelect((index: number) => {
            if (index == 0) {
              this.listScroller.scrollToIndex(index);
            } else {
              this.listScroller.scrollToIndex(index + 1);
            }
          })
      }
      .position({ bottom: 84, right: 0 })
      .padding({ top: px2vp(this.topRectHeight) + 54 })
      .justifyContent(FlexAlign.Center)
      .height('100%')

    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .padding({ top: px2vp(this.topRectHeight) })
    .backgroundColor('#EDEDED')
  }
}