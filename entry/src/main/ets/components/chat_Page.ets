/*
 * 聊天 UI组件
 */

@Component
export struct Chat_Page {
  @StorageProp('topRectHeight') topRectHeight: number = 0;

  build() {
    Stack() {
      Row() {
        Row() {
          Text('微信').fontSize(18)
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

      List() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 3, 4, 5, 8], () => {
          ListItem() {
            Row() {
              Image($r('app.media.test_avater'))
                .width(51)
                .borderRadius(5)
              Column() {
                Row() {
                  Text('菠萝吹雪')
                    .fontSize(18)
                    .fontColor(Color.Black)
                    .lineHeight(25)
                  Text('14:24')
                    .fontSize(12)
                    .fontColor('#BEBEBE')
                    .lineHeight(17)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Top)

                Row() {
                  Text('哈哈哈哈没事没事哈哈哈哈没事没事哈哈哈哈没事没事')
                    .fontSize(13)
                    .fontColor('#BEBEBE')
                    .lineHeight(19)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                    .layoutWeight(1)
                  Image($r('app.media.mdr'))
                    .width(12)
                    .fillColor('#BEBEBE')
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .layoutWeight(1)
              .height(51)
              .margin({ left: 10 })
              .justifyContent(FlexAlign.Center)
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .height(66)
          }
          .padding({
            left: 15,
            right: 10,
            top: 5,
            bottom: 5
          })
        })
      }
      .margin({ top: 54 })
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)
      .divider({ strokeWidth: 0.5, color: '#D7D7D7', startMargin: 76 })

    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .padding({ top: px2vp(this.topRectHeight) })
    .backgroundColor('#EDEDED')
  }
}