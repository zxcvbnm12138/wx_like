import { LengthMetrics, router } from '@kit.ArkUI';
import { Arraysc, image_show } from '../utils/tool';
import { personal_data, pyq_data } from '../utils/dataModel';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { combineAndSortData, pyq_all_Page_data } from './pyq_all_Page';

interface result {
  result: pyq_data
}

@Entry
@Component
struct Dianzan_Page {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageLink('fake_person_data') personal_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = [];
  @State love_sum: number[] = []
  @State fake_person_data: pyq_data | undefined = undefined

  aboutToAppear(): void {

    const res = router.getParams() as result
    this.fake_person_data = res.result
    this.love_sum = Arraysc(this.fake_person_data.love_num)
    hilog.fatal(1, '4', 'fake_person_data' + JSON.stringify(this.fake_person_data))
    hilog.fatal(1, '4', 'love_sum' + this.love_sum)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(20)
          .fillColor('#000000')
          .onClick(() => {
            router.back()
          })
        Text('详情')
          .fontSize(18)
          .lineHeight(25)
        Image($r('app.media.slh'))
          .width(23)
          .fillColor('#000000')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .zIndex(2)
      .backgroundColor('#EDEDED')
      .height(px2vp(this.topRectHeight) + 54)
      .padding({ top: px2vp(this.topRectHeight), left: 10, right: 10 })

      List() {
        ListItem() {
          Column() {
            Row({ space: 5 }) {
              Column() {
                Image(image_show(this.personal_data[0].data.avatar))
                  .width(50)
                  .height(50)
                  .borderRadius(8)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/detail_Page',
                    })
                  })
              }

              Column() {
                Text(this.personal_data[0].data.nickname)
                  .fontColor('#586b95')
                  .fontSize(18)
                  .margin({ bottom: 8 })
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/detail_Page',
                    })
                  })
                Text(this.fake_person_data?.content)
                  .border({ width: 0 })
                  .width('100%')
                  .fontSize(17)


                Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
                  ForEach(this.fake_person_data?.gallery, (item: string, index) => {
                    Image(image_show(item))
                      .objectFit(ImageFit.Cover)
                      .width(96)
                      .height(96)
                  })
                }
                .width('100%')
                .margin({ top: 10, bottom: 10 })

                Text(this.fake_person_data?.location)
                  .fontColor('#586b95')
                  .fontSize(14)
                  .margin({ top: 2 })


                Row() {
                  Row({ space: 5 }) {
                    Text(this.fake_person_data?.show_time)
                      .fontColor('#BEBEBE')
                      .fontSize(12)
                    Image($r('app.media.del'))
                      .width(16)
                      .height(16)
                      .onClick(() => {
                        let shareTimeToDelete = this.fake_person_data!.share_time;
                        let wxNumberToDelete = this.personal_data[0].wx_number;
                        let yearToDelete = new Date(shareTimeToDelete).getFullYear();

                        this.personal_data.forEach(person => {
                          if (person.wx_number === wxNumberToDelete) {
                            person.data.pyq_data.forEach(yearData => {
                              if (yearData.year === yearToDelete) {
                                yearData.pyq_data_list = yearData.pyq_data_list.filter(pyqItem => {
                                  return pyqItem.share_time !== shareTimeToDelete;
                                })
                              }
                            })
                          }
                        });
                        this.pyq_all_Page_data = combineAndSortData(this.personal_data)

                        router.back()


                      })
                  }

                  Image($r('app.media.ICO28_more'))
                    .width(30)
                    .height(23)
                    .backgroundColor('#F7F7F7')
                    .borderRadius(5)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

              }
              .padding({ top: 2 })
              .layoutWeight(1)
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .alignItems(VerticalAlign.Top)

            Row() {
              Column({ space: 1 }) {
                Row({ space: 8 }) {
                  Image($r('app.media.love'))
                    .width(18)
                    .fillColor('#586b95')
                    .margin({ top: 5 })
                  Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(6.5), cross: LengthMetrics.vp(6) } }) {
                    ForEach(this.love_sum, () => {
                      Image($r('app.media.test_avater'))
                        .width(31)
                        .height(31)
                        .borderRadius(2)
                    })
                  }
                  .layoutWeight(1)
                }
                .backgroundColor('#F7F7F7')
                .width('100%')
                .padding(5)
                .borderRadius(5)
                .alignItems(VerticalAlign.Top)

                Row({ space: 8 }) {
                  Image($r('app.media.bubble'))
                    .width(18)
                    .fillColor('#586b95')
                    .margin({ top: 5 })
                  Column({space:10}) {
                    ForEach(Arraysc(this.fake_person_data!.comment_num), (item: string, index) => {
                      Row({ space: 5 }) {
                        Image($r('app.media.test_avater'))
                          .width(27)
                          .height(27)
                          .borderRadius(2)
                        Column({ space: 5 }) {
                          Row() {
                            Text('陈爱银')
                              .fontSize(11)
                              .fontColor('#586b95')
                            Text('2024年12月29日 13:09')
                              .fontSize(11)
                              .fontColor('#BEBEBE')
                          }
                          .width('100%')
                          .justifyContent(FlexAlign.SpaceBetween)
                          Row() {
                            Text('哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟哟')
                              .fontSize(14)
                          }
                          .width('100%')
                        }
                        .width('100%')
                        .layoutWeight(1)
                      }
                      .alignItems(VerticalAlign.Top)
                      .width('100%')
                    })
                  }
                  .alignItems(HorizontalAlign.Center)
                  .layoutWeight(1)
                }
                .backgroundColor('#F7F7F7')
                .width('100%')
                .padding(5)
                .borderRadius(5)
                .alignItems(VerticalAlign.Top)
              }
              .margin({ top: 15 })
              .width('100%')
            }
            .width('100%')
          }
          .width('100%')
        }
        .padding({
          top: 15,
          bottom: 5,
          right: 10,
          left: 10
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)

      Row({ space: 10 }) {
        TextArea({ placeholder: '评论', })
          .placeholderColor('##B2B2B2')
          .backgroundColor('#ffffff')
          .layoutWeight(1)
          .borderRadius(5)
          .caretColor('#00E050')
          .barState(BarState.Off)
          .heightAdaptivePolicy(TextHeightAdaptivePolicy.LAYOUT_CONSTRAINT_FIRST)
        Image($r('app.media.smile'))
          .width(28)
          .height(28)
        Button('发送', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(5)
          .backgroundColor('#00E050')
          .fontColor('#ffffff')
          .height(34)
          .width(65)
      }
      .width('100%')
      .backgroundColor('#F7F7F7')
      .padding(10)
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}