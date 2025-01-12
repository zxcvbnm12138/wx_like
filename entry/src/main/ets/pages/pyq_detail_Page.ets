import { router } from '@kit.ArkUI';
import { pyq_data } from '../utils/dataModel';
import { formatTime, image_show } from '../utils/tool';

interface result {
  result: pyq_data
}

@Entry
@Component
struct Pyq_detail_Page {
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @State fake_pyq_detail_data: pyq_data | undefined = undefined
  @State current_pic: number = 1

  aboutToAppear(): void {
    const res = router.getParams() as result
    this.fake_pyq_detail_data = res.result

  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(20)
          .fillColor('#ffffff')
          .onClick(() => {
            router.back()
          })

        Text() {
          Span(formatTime(this.fake_pyq_detail_data?.share_time, 0) + '\n')
            .fontSize(17)
          Span(this.current_pic + '/' + this.fake_pyq_detail_data?.gallery.length.toString())
            .fontSize(14)
        }
        .textAlign(TextAlign.Center)
        .lineHeight(20)
        .fontColor('#ffffff')

        Image($r('app.media.slh'))
          .width(23)

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .backgroundColor('#111111')
      .height(px2vp(this.topRectHeight) + 54)
      .padding({ top: px2vp(this.topRectHeight), left: 10, right: 10 })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Stack() {
        Swiper() {
          ForEach(this.fake_pyq_detail_data?.gallery, (item: string, index) => {
            Image(image_show(item))
              .objectFit(ImageFit.Contain)
          })
        }
        .width('100%')
        .loop(false)
        .indicator(false)
        .height('100%')
        .padding({ top: 20, bottom: 10 })
        .onChange((index: number) => {
          this.current_pic = index + 1
        })


        Text(this.fake_pyq_detail_data?.content)
          .width('60%')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({ left: 10 })
          .fontSize(16)
          .fontColor('#ffffff')
          .margin({ bottom: 10 })
          .zIndex(2)
      }
      .width('100%')
      .layoutWeight(1)
      .alignContent(Alignment.BottomStart)


      Row() {
        Row() {
          Image($r('app.media.love'))
            .width(18)
            .fillColor('#ffffff')
            .margin({ left: 8 })
          Text(this.fake_pyq_detail_data?.love_num.toString())
            .fontSize(14)
            .fontColor('#ffffff')
            .margin({ left: 3 })
          Image($r('app.media.bubble'))
            .width(18)
            .fillColor('#ffffff')
            .margin({ left: 10 })
          Text(this.fake_pyq_detail_data?.comment_num?.toString())
            .fontSize(14)
            .margin({ left: 3 })
            .fontColor('#ffffff')
        }

        Row() {
          Text('详情')
            .fontSize(15)
            .fontColor('#ffffff')
            .margin({ right: 4 })
          Image($r('app.media.forward'))
            .fillColor('#ffffff')
            .width(15)
        }
        .onClick(() => {
          router.pushUrl({
            url: 'pages/dianzan_Page',
            params: {
              result: this.fake_pyq_detail_data
            }
          })
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .backgroundColor('#111111')
      .height(54)
      .padding({ left: 10, right: 10 })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#000000')
    .border({ width: 0 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}