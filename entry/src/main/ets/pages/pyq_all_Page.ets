import { componentUtils, LengthMetrics, MeasureText, router } from '@kit.ArkUI';
import { comment_obj, personal_data } from '../utils/dataModel';
import { Arraysc, image_show, logoutput } from '../utils/tool';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 全部人朋友圈页面的数据对象接口
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
  comment_content: comment_obj[];
  show_time: string;
  share_time: number;
  link?: string;
  link_image_url?: string;
  share_source?: string;
  content_lines: number
  like_user:string[]
}

/*从全局fake_person_data中抽取出每项朋友圈数据，组合成全部人朋友圈页面的数据，
再通过每项朋友圈的share_time值进行降序，最终变成全部人朋友圈页面的数据*/
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
          share_source: pyqItem?.share_source,
          content_lines: lines_sc(pyqItem.content),
          like_user: generateRandomNames(pyqItem.love_num)
        } as pyq_all_Page_data);
      });
    });
  });
  combinedData.sort((a, b) => b.share_time - a.share_time);
  return combinedData;
}

// 获取文本行数
function lines_sc(content: string): number {
  const naturalLines = calculateNaturalLines(content);
  const extraLines = calculateExtraLines(content);
  return naturalLines + extraLines;
}

// 计算自然换行的行数
function calculateNaturalLines(content: string): number {
  // 去掉换行符
  const contentWithoutNewLines = content.replace(/\n/g, '');

  // 测量文本宽度
  const textSize = MeasureText.measureTextSize({
    textContent: contentWithoutNewLines,
    fontSize: 17,
  });

  // 计算行数
  const containerWidth = 1011.25;
  const calculatedLines = textSize && typeof textSize.width === 'number'
    ? Math.ceil(textSize.width / containerWidth)
    : 0; // 或者设置一个默认值

  return calculatedLines;
}

// 计算从第二个连续换行符开始的额外换行符的行数
function calculateExtraLines(content: string): number {
  // 匹配所有换行符
  const matches = content.match(/\n/g) || [];

  // 计算从第二个换行符开始的额外换行符的行数
  let extraLines = 0;
  let consecutiveNewLines = 0;

  for (const match of matches) {
    consecutiveNewLines++;
    if (consecutiveNewLines > 1) {
      extraLines++;
    }
  }

  return extraLines;
}


// 随机生成中文姓名
function getRandomChineseName(): string {
  const firstNames =
    ['赵', '钱', '孙', '李', '周', '吴', '郑', '王', '冯', '陈', '褚', '卫', '蒋', '沈', '韩', '杨', '朱', '秦', '尤',
      '许'];
  const lastNames =
    ['伟', '芳', '娜', '秀英', '敏', '静', '丽', '强', '磊', '军', '洋', '艳', '杰', '娟', '涛', '明', '超', '秀兰',
      '霞', '平'];

  const firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
  const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];

  return firstName + lastName;
}
// 根据点赞个数生成对应数量的随机中文名字数组
function generateRandomNames(love_num: number): string[] {
  const names: string[] = [];
  for (let i = 0; i < love_num; i++) {
    names.push(getRandomChineseName());
  }
  return names;
}


@Entry
@Component
struct Pyq_all_Page {
  @State new_comment_content: string='';

  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageLink('fake_person_data') fake_person_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = [];
  @State listlocation: boolean = false
  @State bg_url: string = this.fake_person_data[0].data.bg as string
  listScroller: Scroller = new Scroller();
  Textcontroller: TextAreaController = new TextAreaController()
  @Provide comment_square_show:number = -1
  @Provide new_comment_index:number = 0

  onPageShow(): void {
    this.bg_url = this.fake_person_data[0].data.bg as string
    logoutput(this.pyq_all_Page_data, 'pyq_all_Page_data')
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
      .zIndex(3)
      .backgroundColor(this.listlocation ? '#EDEDED' : Color.Transparent)
      .height(px2vp(this.topRectHeight) + 54)
      .padding({ top: px2vp(this.topRectHeight), left: 10, right: 10 })
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
            show_data({item:item,index:index,listScroller: this.listScroller})
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
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)
      .onDidScroll(() => {
        let location = this.listScroller.currentOffset().yOffset
        this.listlocation = location >= 168
      })
      .expandSafeArea([SafeAreaType.KEYBOARD])
      .zIndex(2)


      Row({ space: 10 }) {
        TextArea({ controller:this.Textcontroller,placeholder: '评论',text:$$this.new_comment_content })
          .placeholderColor('##B2B2B2')
          .backgroundColor('#ffffff')
          .layoutWeight(1)
          .borderRadius(5)
          .caretColor('#00E050')
          .barState(BarState.Off)
          .heightAdaptivePolicy(TextHeightAdaptivePolicy.LAYOUT_CONSTRAINT_FIRST)
          .defaultFocus(false)
          .enableKeyboardOnFocus(true)
          .id('textArea')
          .enterKeyType(EnterKeyType.NEW_LINE)
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
            this.comment_square_show = -1
            if (this.new_comment_content !== '') {

              let new_comment :comment_obj = {
                comment_avatar: this.fake_person_data[0].data.avatar,
                comment_nickname: this.fake_person_data[0].data.nickname,
                comment_content: this.new_comment_content,
                comment_time: new Date().getTime()
              }
              // this.pyq_all_Page_data[this.new_comment_index].comment_content.unshift(new_comment)
              // this.pyq_all_Page_data[this.new_comment_index].comment_num += 1
              // this.pyq_all_Page_data = [...this.pyq_all_Page_data]
              // 假设 index 是要删除的元素的索引
              let addElement = this.pyq_all_Page_data[this.new_comment_index];
              let shareTimeToadd = addElement.share_time;
              let wxNumberToadd = addElement.wx_number;
              let yearToadd = new Date(shareTimeToadd).getFullYear();
              // 遍历 personal_data 数组，找到并删除对应的 pyq_data 元素
              this.fake_person_data.forEach(person => {
                if (person.wx_number === wxNumberToadd) {
                  person.data.pyq_data.forEach(yearData => {
                    if (yearData.year === yearToadd) {
                      yearData.pyq_data_list.forEach(pyqItem => {
                        if (pyqItem.share_time === shareTimeToadd){
                          pyqItem.comment_num += 1
                          pyqItem.comment_content?.unshift(new_comment)
                        }
                      })
                    }
                  })
                }
              });
              this.pyq_all_Page_data = combineAndSortData(this.fake_person_data)
              this.new_comment_content = ''
              this.Textcontroller.stopEditing()

            }
          })
      }
      .width('100%')
      .backgroundColor('#F7F7F7')
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .zIndex(this.comment_square_show)
      .position({bottom:0})
      .width('100%')
      .height(55)

    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
    .backgroundColor('#EDEDED')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}

@Component
struct is_expend {
  @State textover: string = '全文'
  @State maxLinesindex: number = 999
  @State item: pyq_all_Page_data | undefined = undefined
  @State content_lines: number = 0
  index: number = 0
  controller: TextController = new TextController()

  build() {
    Column() {
      Text(this.item!.content, { controller: this.controller })
        .maxLines(this.maxLinesindex)
        .textOverflow({ overflow: TextOverflow.Clip })
        .border({ width: 0 })
        .width('100%')
        .fontSize(17)
        .onAppear(() => {
          this.content_lines = this.controller.getLayoutManager().getLineCount()
          hilog.fatal(0x0001, 'ohos.arkts', 'onAppear' + this.controller.getLayoutManager().getLineCount())
        })
      if (this.content_lines > 5) {
        Text(this.textover)
          .fontColor('#586b95')
          .onAppear(() => {
            this.maxLinesindex = 5
          })
          .onClick(() => {
            if (this.maxLinesindex == 5) {
              this.maxLinesindex = 999
              this.textover = '收起'
            } else {
              this.maxLinesindex = 5
              this.textover = '全文'
            }
          })
      }
    }
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
struct show_data{

  @State isShow: Visibility = Visibility.Hidden;
  @StorageLink('fake_person_data') fake_person_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = [];
  @State is_like:boolean = false
  @Consume comment_square_show:number
  @Consume new_comment_index:number

  @State item: pyq_all_Page_data | undefined = undefined
  @State index: number = 0
  listScroller: Scroller|undefined = undefined


  build() {
    Row({ space: 5 }) {
      Column() {
        Image(image_show(this.item!.avatar))
          .width(50)
          .height(50)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
      }

      Column() {
        Text(this.item!.nickname)
          .border({ width: 0 })
          .fontColor('#586b95')
          .fontSize(18)

        is_expend({ item: this.item, index: this.index })

        if (this.item!.link && this.item!.link !== '') {
          Row() {
            Row() {
              Image(this.item!.link_image_url)
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

            Text(this.item!.link)
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
        } else {
          Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
            ForEach(this.item!.gallery, (pic: string, index) => {
              Image(image_show(pic))
                .objectFit(ImageFit.Cover)
                .width(93)
                .height(93)
            })
          }
          .width('100%')
          .margin({ top: 10 })
        }

        Text(this.item!.location)
          .fontColor('#586b95')
          .fontSize(14)
          .margin({ top: 5 })

        Row() {
          Row({ space: 5 }) {
            Text(this.item!.show_time).fontColor('#BEBEBE').fontSize(12)
            if (this.item!.share_source && this.item!.share_source !== '') {
              Text(this.item!.share_source).fontColor('#BEBEBE').fontSize(12)
            }
            if (this.item!.wx_number == this.fake_person_data[0].wx_number) {
              Image($r('app.media.del'))
                .width(16)
                .height(16)
                .onClick(() => {
                  // 假设 index 是要删除的元素的索引
                  let deletedElement = this.pyq_all_Page_data.splice(this.index, 1)[0];
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

          Stack(){
            Row(){
              Row({space:5}){
                Image($r(this.is_like ? 'app.media.bubble' : 'app.media.love'))
                  .width(16)
                  .fillColor('#FCFCFC')
                Text('赞')
                  .fontColor('#FCFCFC')
                  .fontSize(16)
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .layoutWeight(1)
              .onClick(() => {
                let like_name:string = this.fake_person_data[0].data.nickname
                if (this.is_like) {
                  this.item!.love_num -= 1
                  this.is_like = !this.is_like
                  this.item?.like_user.shift()
                  let addElement = this.pyq_all_Page_data[this.index];
                  let shareTimeToadd = addElement.share_time;
                  let wxNumberToadd = addElement.wx_number;
                  let yearToadd = new Date(shareTimeToadd).getFullYear();
                  this.fake_person_data.forEach(person => {
                    if (person.wx_number === wxNumberToadd) {
                      person.data.pyq_data.forEach(yearData => {
                        if (yearData.year === yearToadd) {
                          yearData.pyq_data_list.forEach(pyqItem => {
                            if (pyqItem.share_time === shareTimeToadd){
                              pyqItem.love_num -= 1
                            }
                          })
                        }
                      })
                    }
                  });
                }else{
                  this.item!.love_num += 1
                  this.is_like = !this.is_like
                  this.item?.like_user.unshift(like_name)
                  let addElement = this.pyq_all_Page_data[this.index];
                  let shareTimeToadd = addElement.share_time;
                  let wxNumberToadd = addElement.wx_number;
                  let yearToadd = new Date(shareTimeToadd).getFullYear();
                  this.fake_person_data.forEach(person => {
                    if (person.wx_number === wxNumberToadd) {
                      person.data.pyq_data.forEach(yearData => {
                        if (yearData.year === yearToadd) {
                          yearData.pyq_data_list.forEach(pyqItem => {
                            if (pyqItem.share_time === shareTimeToadd){
                              pyqItem.love_num += 1
                            }
                          })
                        }
                      })
                    }
                  });
                }
                setTimeout(() => {
                  this.isShow = Visibility.None
                }, 300);

              })

              Row(){}
              .width(1)
              .height('70%')
              .border({ width: 0.7,color:'#FCFCFC'})

              Row({space:5}){
                Image($r('app.media.bubble'))
                  .fillColor('#FCFCFC')
                  .width(16)
                Text('评论')
                  .fontColor('#FCFCFC')
                  .fontSize(16)
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .layoutWeight(1)
              .onClick(() => {
                this.comment_square_show = 3
                this.getUIContext().getFocusController().requestFocus('textArea')
                setTimeout(() => {
                  this.isShow = Visibility.None
                }, 300);
                let current_location = componentUtils.getRectangleById(this.index.toString()).screenOffset.y
                this.listScroller?.scrollBy( 0, px2vp(current_location - 1467) )
                this.new_comment_index = this.index

              })
            }
            .height(35)
            .backgroundColor('#4C4C4C')
            .borderRadius(5)
            .width(180)
            .visibility(this.isShow)
            .animation({
              duration: 200,
            })
            .zIndex(1)
            .margin({right:32})
            Image($r('app.media.ICO28_more')).width(30)
              .height(23)
              .backgroundColor('#F7F7F7').borderRadius(5)
              .onClick(() => {
                if (this.isShow == Visibility.Visible) {
                  this.isShow = Visibility.None
                }else {
                  this.isShow = Visibility.Visible
                }
              })
              .id(this.index.toString())
          }
          .alignContent(Alignment.End)
          .layoutWeight(1)

        }
        .height(25)
        .border({ width: 0 })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        List({ space: 0 }) {
          if (this.item!.love_num !== 0) {
            ListItem() {
              Row() {
                Text() {
                  Span('♡ ')
                  ForEach(this.item?.like_user, (like: string, index) => {
                    Span(like)
                    if (this.item?.like_user.length !== index + 1) {
                      Span(', ')
                    }
                  })
                }
                .fontSize(14)
                .width('100%')
                .fontColor('#586b95')
                .borderRadius(0)
              }
              .alignItems(VerticalAlign.Top)
            }.padding(5)
          }
          if (this.item!.comment_num !== 0) {
            ListItem() {
              Column({ space: 5 }) {
                ForEach(this.item!.comment_content, (comment_item: comment_obj, index) => {
                  Text() {
                    Span(comment_item.comment_nickname + ': ')
                      .fontColor('#586b95')
                    Span(comment_item.comment_content)
                  }
                  .fontSize(14)
                  .lineHeight(18)
                  .width('100%')
                })
              }
            }.padding(5)
          }
        }
        .backgroundColor('#F7F7F7')
        .width('100%')
        .margin({ top: 5 })
        .borderRadius(5)
        .divider({ strokeWidth: 0.3, color: '#ffc4c3c3' })

      }
      .padding({ top: 2 })
      .layoutWeight(1)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }
}

