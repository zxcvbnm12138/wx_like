import { LengthMetrics, router } from '@kit.ArkUI';
import { personal_data, personal_every_year_pyq_data, pyq_data } from '../utils/dataModel';
import { image_show } from '../utils/tool';
import { hilog } from '@kit.PerformanceAnalysisKit';

export interface pyq_all_Page_data {
  wx_number: string;
  avatar: string;
  nickname: string;
  district: string;
  pyq_first4_pic: string[];
  content: string;
  gallery: string[];
  location: string;
  love_num: number;
  comment_num: number;
  comment_content: string[];
  show_time: string;
  share_time: number;
  link?: string;
  link_image_url?: string;
}

export function combineAndSortData(data: personal_data[]): pyq_all_Page_data[] {
  let combinedData: pyq_all_Page_data[] = [];

  data.forEach(person => {
    person.data.pyq_data.forEach(yearData => {
      yearData.pyq_data_list.forEach(pyqItem => {
        combinedData.push({
          wx_number: person.wx_number,
          avatar: person.data.avatar,
          nickname: person.data.nickname,
          district: person.data.district,
          pyq_first4_pic: person.data.pyq_first4_pic,
          content: pyqItem.content,
          gallery: pyqItem.gallery,
          location: pyqItem.location,
          love_num: pyqItem.love_num,
          comment_num: pyqItem.comment_num,
          comment_content: pyqItem.comment_content,
          show_time: pyqItem.show_time,
          share_time: pyqItem.share_time,
          link: pyqItem?.link,
          link_image_url: pyqItem?.link_image_url,
        } as pyq_all_Page_data);
      });
    });
  });

  combinedData.sort((a, b) => b.share_time - a.share_time);
  return combinedData;
}


@Entry
@Component
struct Pyq_all_Page {
  @State listlocation: boolean = false
  @State maxLinesindex: number = 999
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageLink('fake_person_data') fake_person_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = [];
  controller: TextController = new TextController()
  private listScroller: Scroller = new Scroller();
  @State bg_url:string = this.fake_person_data[0].data.bg as string

  onPageShow(): void {
    this.bg_url = this.fake_person_data[0].data.bg as string
  }

  build() {
    Stack() {
      Row() {
        Image($r('app.media.back'))
          .width(20)
          .fillColor(this.listlocation ? '#000000' : '#ffffff')
          .onClick(() => {
            router.back()
          })
        Text('朋友圈')
          .fontSize(18)
          .lineHeight(25)
          .opacity(this.listlocation ? 1 : 0)
        Image($r(this.listlocation ? 'app.media.camera' : 'app.media.camera_withe'))
          .width(23)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .zIndex(2)
      .backgroundColor(this.listlocation ? '#EDEDED' : Color.Transparent)
      .height(px2vp(this.topRectHeight) + 54)
      .padding({ top: px2vp(this.topRectHeight), left: 10, right: 10 })
      .border({ width: 0 })
      .animation({
        duration: 200
      })


      List({ scroller: this.listScroller }) {
        ListItem() {
          Column() {
            Image(image_show(this.bg_url))
              .height('33.3%')
              .width('100%')
            Row({ space: 9 }) {
              Text(this.fake_person_data[0].data.nickname)
                .fontSize(20)
                .fontColor('#ffffff')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 8 })
                .layoutWeight(1)
                .textAlign(TextAlign.End)
              Image(image_show(this.fake_person_data[0].data.avatar))
                .width(70)
                .height(70)
                .borderRadius(10)
            }
            .width(159)
            .height(70)
            .alignItems(VerticalAlign.Top)
            .position({ x: '55.00%', y: '28.00%' })
            .onClick(() => {
              router.pushUrl({ url: 'pages/detail_Page' })
            })
          }
        }
        .width('100%')

        ForEach(this.pyq_all_Page_data, (item: pyq_all_Page_data, index) => {
          ListItem() {
            Row({ space: 5 }) {
              Column() {
                Image(image_show(item.avatar))
                  .width(50)
                  .height(50)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8)
              }

              Column() {
                Text(item.nickname)
                  .border({ width: 0 })
                  .fontColor('#586b95')
                  .fontSize(18)
                Text(item.content, { controller: this.controller })
                  .maxLines(this.maxLinesindex)
                  .textOverflow({ overflow: TextOverflow.Clip })
                  .border({ width: 0 })
                  .width('100%')
                  .fontSize(17)
                if (item.link && item.link !== '') {
                  Row() {
                    Row() {
                      Image(item.link_image_url)
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

                    Text(item.link)
                      .fontSize(18)
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .layoutWeight(1)
                      .textAlign(TextAlign.Start)
                      .border({ width: 0 })
                  }
                  .border({ width: 0 })
                  .padding(5)
                  .alignItems(VerticalAlign.Center)
                  .backgroundColor('#F7F7F7')
                  .margin({ top: 10 })
                }
                else {
                  Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
                    ForEach(item.gallery, (pic: string, index) => {
                      Image(image_show(pic))
                        .objectFit(ImageFit.Cover)
                        .width(93)
                        .height(93)
                    })
                  }
                  .width('100%')
                  .margin({ top: 10 })
                }

                Text(item.location).border({ width: 0 }).fontColor('#586b95').fontSize(14)
                  .margin({ top: 5 })

                Row() {
                  Row({space:5}){
                    Text(item.show_time).fontColor('#BEBEBE').fontSize(12)
                    if (item.wx_number == this.fake_person_data[0].wx_number)
                    {
                      Image($r('app.media.del'))
                        .width(16)
                        .height(16)
                        .onClick(()=>{
                          // this.pyq_all_Page_data.splice(index,1)
                          // 假设 index 是要删除的元素的索引
                          let deletedElement = this.pyq_all_Page_data.splice(index, 1)[0];
                          let shareTimeToDelete = deletedElement.share_time;
                          let wxNumberToDelete = deletedElement.wx_number;
                          let yearToDelete = new Date(shareTimeToDelete).getFullYear();
                          // 遍历 personal_data 数组，找到并删除对应的 pyq_data 元素
                          this.fake_person_data.forEach(person => {
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

                        })
                    }
                  }

                  Image($r('app.media.ICO28_more')).width(30)
                    .height(23)
                    .backgroundColor('#F7F7F7').borderRadius(5)
                }.border({ width: 0 })
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

                Row({ space: 10 }) {
                  Image($r('app.media.love')).width(20).fillColor('#586b95')
                  Text('陈爱银, 陈爱银').fontColor('#586b95').fontSize(16)
                    .lineHeight(25)
                }
                .border({ width: 0 })
                .backgroundColor('#F7F7F7')
                .width('100%')
                .margin({ top: 5 })
                .padding({ left: 5 })
                .borderRadius(5)
                .height(30)
                .alignItems(VerticalAlign.Center)
              }
              .padding({ top: 2 })
              .layoutWeight(1)
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .margin({ top: 32 })
          .padding({ right: 10, left: 10, bottom: 10 })
        })
      }
      .divider({
        strokeWidth: 0.5,
        color: '#D7D7D7'
      })
      .width('100%')
      .height('100%')
      .border({ width: 0 })
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)
      .onDidScroll(() => {
        let location = this.listScroller.currentOffset().yOffset
        this.listlocation = location >= 168
      })
    }
    .alignContent(Alignment.Top)
    .backgroundColor('#EDEDED')
    .border({ width: 1 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}