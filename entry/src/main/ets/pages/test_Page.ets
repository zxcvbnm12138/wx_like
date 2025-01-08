import { LengthMetrics } from '@kit.ArkUI'

@Entry
@Component
struct Dianzan_Page {
  build() {
    Column() {

      List() {
        ListItem() {
          Column() {
            Row({ space: 5 }) {
              Column() {
                Image($r('app.media.test_avater'))
                  .width(50)
                  .height(50)
                  .borderRadius(8)
                  .onClick(()=>{
                  })
              }
              Column() {
                Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
                  ForEach([1,2,4,4,4,4,4,4,4], (item:string,index) => {
                    Image($r('app.media.test_avater'))
                      .objectFit(ImageFit.Cover)
                      .width('32%')
                  })
                }
                .width('100%')
                .margin({ top: 10 ,bottom:10})
              }
              .padding({ top: 2 })
              .layoutWeight(1)
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .padding({ right: 10, left: 10 })
        }.padding({ top: 15, bottom: 5 })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}