import { LengthMetrics, router } from '@kit.ArkUI';
import { Arraysc, formatTime, image_show } from '../utils/tool';
import { comment_obj, convertTime, personal_data, pyq_data } from '../utils/dataModel';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { combineAndSortData, pyq_all_Page_data } from './pyq_all_Page';

interface result {
  result: pyq_data
}

@Entry
@Component
struct Dianzan_Page {
  @State new_comment_content: string ='';
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
    Stack(){
      Column() {
        Row() {
          Image($r('app.media.back'))
            .width(20)
            .fillColor('#000000')
            .onClick(() => {
              router.back({
                url: 'pages/pyq_personal_Page',
                params:{
                  new_fake_personal_data: this.fake_person_data
                }
              })
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


                  if (this.fake_person_data?.link && this.fake_person_data.link !== '') {
                    Row() {
                      Row() {
                        Image(this.fake_person_data.link_image_url)
                          .width(30)
                          .height(30)
                          .objectFit(ImageFit.Cover)
                          .border({ width: 0 })
                      }
                      .justifyContent(FlexAlign.Center)
                      .alignItems(VerticalAlign.Center)
                      .width(40)
                      .height(40)
                      .border({ width: 0 })

                      Text(this.fake_person_data.link)
                        .fontSize(18)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .layoutWeight(1)
                        .textAlign(TextAlign.Start)
                        .border({ width: 0 })
                    }
                    .padding(5)
                    .alignItems(VerticalAlign.Center)
                    .margin({ left: 10 , bottom: 10 })
                    .backgroundColor('#F7F7F7')
                    .width('100%')
                    .height(50)
                    .border({ width: 0 })
                  }else {
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
                  }


                  Text(this.fake_person_data?.location)
                    .fontColor('#586b95')
                    .fontSize(14)
                    .margin({ top: 2 })


                  Row() {
                    Row({ space: 5 }) {
                      Text(this.fake_person_data?.show_time)
                        .fontColor('#BEBEBE')
                        .fontSize(12)
                      if(this.fake_person_data?.share_source && this.fake_person_data.share_source !== '')
                      {
                        Text(this.fake_person_data.share_source).fontColor('#BEBEBE').fontSize(12)
                      }
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
                  if(this.fake_person_data!.love_num !==0)
                  {
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
                  }
                  if (this.fake_person_data?.comment_num !== 0 ){
                    Row({ space: 8 }) {
                      Image($r('app.media.bubble'))
                        .width(18)
                        .fillColor('#586b95')
                        .margin({ top: 5 })
                      Column({space:10}) {
                        ForEach(this.fake_person_data?.comment_content, (item: comment_obj, index) => {
                          Row({ space: 5 }) {
                            Image(image_show(item.comment_avatar))
                              .width(27)
                              .height(27)
                              .borderRadius(2)
                            Column({ space: 5 }) {
                              Row() {
                                Text(item.comment_nickname)
                                  .fontSize(11)
                                  .fontColor('#586b95')
                                Text(formatTime(item.comment_time,0))
                                  .fontSize(11)
                                  .fontColor('#BEBEBE')
                              }
                              .width('100%')
                              .justifyContent(FlexAlign.SpaceBetween)
                              Row() {
                                Text(item.comment_content)
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
        .padding({bottom:54})
      }
      .expandSafeArea([SafeAreaType.KEYBOARD])
      Row({ space: 10 }) {
        TextArea({ placeholder: '评论', text: $$this.new_comment_content})
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
          .onClick(() => {
            if (this.new_comment_content !== '') {

              let new_comment :comment_obj = {
                comment_avatar: this.personal_data[0].data.avatar,
                comment_nickname: this.personal_data[0].data.nickname,
                comment_content: this.new_comment_content,
                comment_time: new Date().getTime()
              }
              this.fake_person_data?.comment_content?.unshift(new_comment)
              this.fake_person_data!.comment_num += 1
              this.new_comment_content = ''
            }
          })
      }
      .width('100%')
      .backgroundColor('#F7F7F7')
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .zIndex(2)
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}