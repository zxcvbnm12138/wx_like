import { personal_data } from '../utils/dataModel';
import { image_show } from '../utils/tool';

interface wo_data {
  url: string,
  name: string
}

@Component
export struct Wo_Page {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('fake_person_data') fake_person_data: personal_data[] = []

  build() {
    Stack() {
      Row() {
      }
      .width('100.00%')
      .height(54)

      Column() {
        Row({ space: 20 }) {
          Image(image_show(this.fake_person_data[0].data.avatar))
            .width(70)
            .height(70)
            .objectFit(ImageFit.Cover)
            .borderRadius(5)
          Column() {
            Row() {
              Column({ space: 15 }) {
                Text(this.fake_person_data[0].data.nickname)
                  .fontSize(20)
                  .fontColor(Color.Black)
                  .lineHeight(25)
                Text('微信号：' + this.fake_person_data[0].wx_number)
                  .fontSize(15)
                  .fontColor('#747474')
                  .lineHeight(19)
              }
              .layoutWeight(1)
              .height('100%')
              .padding({ top: 5 })
              .alignItems(HorizontalAlign.Start)

              Row({ space: 10 }) {
                Image($r('app.media.wx_ewm'))
                  .width(18)
                Image($r('app.media.forward'))
                  .width(16)
                  .fillColor('#747474')
              }
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .height(70)

            Row() {
              Button({ type: ButtonType.Capsule, stateEffect: true, controlSize: ControlSize.SMALL }) {
                Row() {
                  Image($r('app.media.plus'))
                    .width(14)
                    .fillColor('#747474')
                  Text('状态')
                    .fontSize(14)
                    .fontColor('#747474')
                    .lineHeight(16)
                    .margin({ left: 1 })
                }
                .alignItems(VerticalAlign.Center)

              }
              .height(23)
              .width(60)
              .backgroundColor(Color.Transparent)
              .border({ width: 0.7, color: '#747474' })

              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image($r('app.media.wx_zt'))
                  .width(14)
                  .height(14)
                  .borderRadius(10)
                  .fillColor('#747474')
              }
              .width(22)
              .height(22)
              .padding(1)
              .margin({ left: 10 })
              .backgroundColor(Color.Transparent)
              .border({ width: 0.7, color: '#747474' })

            }
            .width('100%')
            .layoutWeight(1)
            .alignItems(VerticalAlign.Center)
          }
          .height('100%')
          .layoutWeight(1)
        }
        .width('100%')
        .height(140)
        .backgroundColor('#ffffff')
        .padding({ top: 5, left: 10, right: 10 })
        .alignItems(VerticalAlign.Top)

        List() {
          ListItem() {
            Row() {
              Row() {
                Image($r('app.media.wx_zf'))
                  .width(23)

                Text('服务')
                  .margin({ left: 10 })
              }

              Image($r('app.media.forward'))
                .width(16)
                .fillColor('#747474')
            }
            .height(56)
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left: 15,
              top: 8,
              bottom: 8,
              right: 15
            })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 10, bottom: 10 })

          ListItemGroup() {
            ListItem() {
              Row() {
                Row() {
                  Image($r('app.media.wx_sc'))
                    .width(20)

                  Text('收藏')
                    .margin({ left: 10 })
                }

                Image($r('app.media.forward'))
                  .width(16)
                  .fillColor('#747474')
              }
              .height(56)
              .width('100%')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                left: 15,
                top: 8,
                bottom: 8,
                right: 15
              })
            }
            .width('100%')
            .backgroundColor(Color.White)

            ListItem() {
              Row() {
                Row() {
                  Image($r('app.media.wx_tk'))
                    .width(23)

                  Text('朋友圈')
                    .margin({ left: 10 })
                }

                Image($r('app.media.forward'))
                  .width(16)
                  .fillColor('#747474')
              }
              .height(56)
              .width('100%')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                left: 15,
                top: 8,
                bottom: 8,
                right: 15
              })
            }
            .width('100%')
            .backgroundColor(Color.White)

            ListItem() {
              Row() {
                Row() {
                  Image($r('app.media.wx_bf'))
                    .width(23)

                  Text('视频号')
                    .margin({ left: 10 })
                }

                Image($r('app.media.forward'))
                  .width(16)
                  .fillColor('#747474')
              }
              .height(56)
              .width('100%')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                left: 15,
                top: 8,
                bottom: 8,
                right: 15
              })
            }
            .width('100%')
            .backgroundColor(Color.White)

            ListItem() {
              Row() {
                Row() {
                  Image($r('app.media.wx_kb'))
                    .width(23)

                  Text('卡包')
                    .margin({ left: 10 })
                }

                Image($r('app.media.forward'))
                  .width(16)
                  .fillColor('#747474')
              }
              .height(56)
              .width('100%')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                left: 15,
                top: 8,
                bottom: 8,
                right: 15
              })
            }
            .width('100%')
            .backgroundColor(Color.White)

            ListItem() {
              Row() {
                Row() {
                  Image($r('app.media.wx_bq'))
                    .width(20)

                  Text('表情')
                    .margin({ left: 10 })
                }

                Image($r('app.media.forward'))
                  .width(16)
                  .fillColor('#747474')
              }
              .height(56)
              .width('100%')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                left: 15,
                top: 8,
                bottom: 8,
                right: 15
              })
            }
            .width('100%')
            .backgroundColor(Color.White)
          }
          .divider({ strokeWidth: 0.5, color: '#D7D7D7', startMargin: 65 })


          ListItem() {
            Row() {
              Row() {
                Image($r('app.media.wx_sz'))
                  .width(19)

                Text('设置')
                  .margin({ left: 10 })
              }

              Image($r('app.media.forward'))
                .width(16)
                .fillColor('#747474')
            }
            .height(56)
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left: 15,
              top: 8,
              bottom: 8,
              right: 15
            })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 10 })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#EDEDED')
      }
      .width('100%')
      .height('100%')
      .padding({ top: 54 })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .padding({ top: px2vp(this.topRectHeight) })
    .backgroundColor('#ffffff')
  }
}