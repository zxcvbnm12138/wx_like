@Entry
@Component
struct Dianzan_Page {
  @State isShow: Visibility = Visibility.None

  build() {
    Column() {
      Row() {
        Row() {
          Text('1天前').fontColor('#BEBEBE').fontSize(12)
        }
        .border({ width: 1 })

        Row({ space: 3 }) {
          Row() {
            Row({ space: 5 }) {
              Image($r('app.media.love'))
                .width(20)
                .fillColor('#FCFCFC')
              Text('赞')
                .fontColor('#FCFCFC')
                .fontSize(20)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .layoutWeight(1)

            Row() {
            }
            .width(1)
            .height('70%')
            .border({ width: 0.7, color: '#FCFCFC' })

            Row({ space: 5 }) {
              Image($r('app.media.bubble'))
                .fillColor('#FCFCFC')
                .width(20)
              Text('评论')
                .fontColor('#FCFCFC')
                .fontSize(20)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .layoutWeight(1)
          }
          .height(43)
          .backgroundColor('#4C4C4C')
          .borderRadius(5)
          .width(200)
          .visibility(this.isShow)
          .animation({
            duration: 200,
          })

          Image($r('app.media.ICO28_more'))
            .width(30)
            .height(23)
            .backgroundColor('#F7F7F7')
            .borderRadius(5)
            .onClick(() => {
              if (this.isShow == Visibility.Visible) {
                this.isShow = Visibility.None
              } else {
                this.isShow = Visibility.Visible
              }
            })
        }
        .justifyContent(FlexAlign.End)
        .border({ width: 1 })
        .layoutWeight(1)

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: 1 })
    }
    .padding(20)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}