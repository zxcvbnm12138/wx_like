/*
 *公共朋友圈页面
 */

import { componentUtils, LengthMetrics, router } from '@kit.ArkUI';
import { comment_obj, personal_data } from '../utils/dataModel';
import { combineAndSortData, image_show } from '../utils/tool';

// 公共朋友圈数据对象接口
export interface pyq_all_Page_data {
  // 微信号
  wx_number: string;

  // 头像URL
  avatar: string;

  // 昵称
  nickname: string;

  // 所在区域
  district: string;

  // 朋友圈前四张图片的URL数组
  pyq_first4_pic: string[];

  // 需分享的内容文本
  content: string;

  // 需要分享的图片的URL数组
  gallery: string[];

  // 定位
  location: string;

  // 点赞数量
  love_num: number;

  // 评论数量
  comment_num: number;

  // 评论内容对象数组
  comment_content: comment_obj[];

  // 展示的时间
  show_time: string;

  // 分享的时间戳
  share_time: number;

  // 需要分享的链接
  link?: string;

  // 需要分享的链接的图片
  link_image_url?: string;

  // 分享来源
  share_source?: string;

  // 朋友圈内容的行数
  content_lines: number
  // 根据点赞数生成的用户名数组
  like_user: string[]
}

@Entry
@Component
struct Pyq_all_Page {
  @State new_comment_content: string = ''; //评论框内容
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageLink('fake_person_data') fake_person_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = [];
  @State listlocation: boolean = false // 内容区移动的偏移量，超过168则将置顶栏设为灰色，反之为透明
  @State bg_url: string = this.fake_person_data[0].data.bg as string // 初始化背景图片URL，从模拟的个人数据中获取
  listScroller: Scroller = new Scroller();
  Textcontroller: TextAreaController = new TextAreaController()
  @Provide comment_square_show: number = -1 //评论框的层级，控制其显隐
  @Provide new_comment_index: number = 0 // 需要添加评论的那条朋友圈的索引

  // 页面显示时候的钩子函数
  onPageShow(): void {
    //更新朋友圈背景图
    this.bg_url = this.fake_person_data[0].data.bg as string
  }

  build() {
    Stack() {
      //置顶栏
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

      //朋友圈内容展示区域
      List({ scroller: this.listScroller }) {
        ListItem() {
          //背景图 和 头像昵称
          Column() {
            //背景图
            Image(image_show(this.bg_url))
              .height('33.3%')
              .width('100%')
            //头像和昵称
            Row({ space: 9 }) {
              //昵称
              Text(this.fake_person_data[0].data.nickname)
                .fontSize(20)
                .fontColor('#ffffff')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 8 })
                .layoutWeight(1)
                .textAlign(TextAlign.End)
              //头像
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

        //内容展示区域
        ForEach(this.pyq_all_Page_data, (item: pyq_all_Page_data, index) => {
          ListItem() {
            //朋友圈内容展示组件
            show_data({ item: item, index: index, listScroller: this.listScroller })
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
        let location = this.listScroller.currentOffset().yOffset //获得列表的偏移量
        this.listlocation = location >= 168
      })
      .expandSafeArea([SafeAreaType.KEYBOARD])
      .zIndex(2)

      //评论框
      Row({ space: 10 }) {
        TextArea({ controller: this.Textcontroller, placeholder: '评论', text: $$this.new_comment_content })
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
              let new_comment: comment_obj = {
                comment_avatar: this.fake_person_data[0].data.avatar,
                comment_nickname: this.fake_person_data[0].data.nickname,
                comment_content: this.new_comment_content,
                comment_time: new Date().getTime()
              }

              let addElement = this.pyq_all_Page_data[this.new_comment_index];
              let shareTimeToadd = addElement.share_time;
              let wxNumberToadd = addElement.wx_number;
              let yearToadd = new Date(shareTimeToadd).getFullYear();

              this.fake_person_data.forEach(person => {
                if (person.wx_number === wxNumberToadd) {
                  person.data.pyq_data.forEach(yearData => {
                    if (yearData.year === yearToadd) {
                      yearData.pyq_data_list.forEach(pyqItem => {
                        if (pyqItem.share_time === shareTimeToadd) {
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


            }
            this.Textcontroller.stopEditing()
          })
      }
      .width('100%')
      .backgroundColor('#F7F7F7')
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .zIndex(this.comment_square_show)
      .position({ bottom: 0 })
      .width('100%')
      .height(55)

    }
    //点击空白区域控制评论框的层级为最低同时退出编辑状态，达到隐藏效果
    .onClick(() => {
      this.Textcontroller.stopEditing() //使评论框推出编辑状态
      this.comment_square_show = -1
    })
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
    .backgroundColor('#EDEDED')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}

// 朋友圈文本内容展示组件
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
          this.content_lines = this.controller.getLayoutManager().getLineCount() //获取文本的行数
          // hilog.fatal(0x0001, 'ohos.arkts', 'onAppear' + this.controller.getLayoutManager().getLineCount())
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


//朋友圈展示组件
@Component
struct show_data {
  @State isShow: Visibility = Visibility.Hidden;
  @StorageLink('fake_person_data') fake_person_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = [];
  @State is_like: boolean = false
  @Consume comment_square_show: number
  @Consume new_comment_index: number
  @State item: pyq_all_Page_data | undefined = undefined
  @State index: number = 0
  listScroller: Scroller | undefined = undefined

  build() {
    Row({ space: 5 }) {
      //头像
      Column() {
        Image(image_show(this.item!.avatar))
          .width(50)
          .height(50)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
      }


      Column() {
        //昵称
        Text(this.item!.nickname)
          .border({ width: 0 })
          .fontColor('#586b95')
          .fontSize(18)

        //文本内容
        is_expend({ item: this.item, index: this.index })

        //判断分享的是链接还是图片
        if (this.item!.link && this.item!.link !== '') {
          //链接展示
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
          //图片展示
          Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
            ForEach(this.item!.gallery, (pic: string, index) => {
              if (this.item!.gallery.length == 1) {
                Image(image_show(pic))
                  .objectFit(ImageFit.Contain)
                  .width(110)
              } else {
                Image(image_show(pic))
                  .objectFit(ImageFit.Cover)
                  .width(93)
                  .height(93)
              }
            })
          }
          .width('100%')
          .margin({ top: 10 })
        }

        //定位
        Text(this.item!.location)
          .fontColor('#586b95')
          .fontSize(14)
          .margin({ top: 5 })

        //发布时间、删除、点赞与评论以及触发按钮区域
        Row() {
          // 发布时间和删除按钮区域
          Row({ space: 5 }) {
            //发布时间
            Text(this.item!.show_time).fontColor('#BEBEBE').fontSize(12)
            //判断是否有分享来源
            if (this.item!.share_source && this.item!.share_source !== '') {
              //分享来源
              Text(this.item!.share_source).fontColor('#BEBEBE').fontSize(12)
            }
            //判断是否是主用户，默认个人朋友圈数据中的第一个元素为主用户
            if (this.item!.wx_number == this.fake_person_data[0].wx_number) {
              //删除按钮
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

          //点赞与评论按钮区域
          Stack() {
            // 点赞与评论 区域
            Row() {
              // 点赞
              Row({ space: 5 }) {
                Image($r(this.is_like ? 'app.media.red_like' : 'app.media.love'))
                  .width(16)
                  .fillColor(this.is_like ? Color.Red : '#FCFCFC')
                Text('赞')
                  .fontColor('#FCFCFC')
                  .fontSize(16)
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .layoutWeight(1)
              .onClick(() => {
                let like_name: string = this.fake_person_data[0].data.nickname
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
                            if (pyqItem.share_time === shareTimeToadd) {
                              pyqItem.love_num -= 1
                            }
                          })
                        }
                      })
                    }
                  });
                } else {
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
                            if (pyqItem.share_time === shareTimeToadd) {
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

              // 分界线
              Row() {
              }
              .width(1)
              .height('70%')
              .border({ width: 0.7, color: '#FCFCFC' })

              // 评论
              Row({ space: 5 }) {
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
                this.listScroller?.scrollBy(0, px2vp(current_location - 1467))
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
            .margin({ right: 32 })

            //触发 点赞与评论 的按钮
            Image($r('app.media.ICO28_more'))
              .width(30)
              .height(23)
              .backgroundColor('#F7F7F7')
              .borderRadius(5)//控制 点赞与评论 的显隐
              .onClick(() => {
                if (this.isShow == Visibility.Visible) {
                  this.isShow = Visibility.None
                } else {
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

        //点赞 和 评论展示区域
        List({ space: 0 }) {
          //判断点赞数是否为0
          if (this.item!.love_num !== 0) {
            ListItem() {
              Row() {
                // 点赞的用户名展示区
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
          //判断评论数是否为0
          if (this.item!.comment_num !== 0) {
            ListItem() {
              Column({ space: 5 }) {
                // 评论内容
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
