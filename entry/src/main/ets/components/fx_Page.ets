import { router } from '@kit.ArkUI';


@Component
export struct Fx_Page {
  @StorageProp('topRectHeight') topRectHeight: number = 0;

  build() {
    Stack() {
      Row() {
        Row() {
          Text('发现').fontSize(18)
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

      List({ space: 5 }) {
        ListItem() {
          Row() {
            Row({ space: 15 }) {
              Image($r('app.media.pyq'))
                .width(25)
              Text('朋友圈')
                .fontSize(16)
                .lineHeight(20)
            }

            Image($r('app.media.forward'))
              .width(20)

          }
          .border({ width: 0 })
          .width('100%')
          .height(54)
          .padding({ left: 10, right: 10 })
          .justifyContent(FlexAlign.SpaceBetween)

        }
        .backgroundColor('#ffffff')
        .onClick(() => {
          router.pushUrl({ url: 'pages/pyq_all_Page' })
        })


        ListItem() {
          Row() {
            Row({ space: 15 }) {
              Image($r('app.media.wx_game'))
                .width(28)
              Text('游戏')
                .fontSize(16)
                .lineHeight(20)
            }

            Image($r('app.media.forward'))
              .width(20)
          }
          .border({ width: 0 })
          .width('100%')
          .height(54)
          .padding({ left: 10, right: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .backgroundColor('#ffffff')
      }
      .margin({ top: 54 })
      .border({ width: 0 })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
    .backgroundColor('#EDEDED')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .padding({ top: px2vp(this.topRectHeight) })

  }
}