/*
 * 朋友圈详情页面
 */

import { LengthMetrics, router } from '@kit.ArkUI';
import { Arraysc, combineAndSortData, formatTime, image_show } from '../utils/tool';
import { comment_obj, personal_data, pyq_data } from '../utils/dataModel';
import { pyq_all_Page_data } from './pyq_all_Page';

// 从个人朋友圈列表页传进来的数据的接口
interface result {
  result: pyq_data
}

@Entry
@Component
struct Dianzan_Page {
  @State new_comment_content: string = ''; //评论框的内容
  @StorageProp('topRectHeight') topRectHeight: number = 0; //从全局数据获得状态栏的高度
  @StorageLink('fake_person_data') personal_data: personal_data[] = [] //从全局数据获得 个人朋友圈 数据
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = []; //从全局数据获得 公共朋友圈 数据
  @State love_sum: number[] = [] //根据单条朋友圈的点赞个数生成一个数组，用于生成对应个数的点赞好友的头像
  @State fake_person_data: pyq_data | undefined = undefined
  listScroller: Scroller = new Scroller();
  @State isShow: Visibility = Visibility.Hidden; //控制 点赞与评论框的显隐
  @State is_like: boolean = false //控制是否点赞

  aboutToAppear(): void {
    const res = router.getParams() as result
    this.fake_person_data = res.result //接收单条朋友圈的数据
    this.love_sum = Arraysc(this.fake_person_data.love_num) //生成对应点赞个数的数组
  }

  build() {
    Column() {
      //置顶栏
      Row() {
        // 返回按钮
        Image($r('app.media.back'))
          .width(20)
          .fillColor('#000000')
          .onClick(() => {
            router.back({
              url: 'pages/pyq_personal_Page',
              params: {
                new_fake_personal_data: this.fake_person_data
              }
            })
          })
        //文本
        Text('详情')
          .fontSize(18)
          .lineHeight(25)
        //省略号按钮
        Image($r('app.media.slh'))
          .width(23)
          .fillColor('#000000')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .zIndex(2)
      .backgroundColor('#EDEDED')
      .height(px2vp(this.topRectHeight) + 54) //高度设置为 状态栏高度 + 所需高度
      .padding({ top: px2vp(this.topRectHeight), left: 10, right: 10 }) //padding top一下状态栏高度

      // 内容展示区域
      List({ scroller: this.listScroller }) {
        ListItem() {
          Column() {
            //内容区
            Row({ space: 5 }) {
              //头像
              Column() {
                Image(image_show(this.personal_data[0].data.avatar))
                  .width(50)
                  .height(50)
                  .borderRadius(8)
                  .onClick(() => {
                    // 调用router的pushUrl方法导航到个人信息页
                    router.pushUrl({
                      url: 'pages/detail_Page',
                    })
                  })
              }

              //内容区
              Column() {
                //昵称
                Text(this.personal_data[0].data.nickname)
                  .fontColor('#586b95')
                  .fontSize(18)
                  .margin({ bottom: 8 })
                  .onClick(() => {
                    // 调用router的pushUrl方法导航到个人信息页
                    router.pushUrl({
                      url: 'pages/detail_Page',
                    })
                  })
                //朋友圈内容
                Text(this.fake_person_data?.content)
                  .border({ width: 0 })
                  .width('100%')
                  .fontSize(17)

                // 判断是分享链接还是图片
                if (this.fake_person_data?.link && this.fake_person_data.link !== '') {
                  // 链接内容展示区
                  Row() {
                    // 链接的图片
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

                    //链接的内容
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
                  .margin({ left: 10, bottom: 10 })
                  .backgroundColor('#F7F7F7')
                  .width('100%')
                  .height(50)
                  .border({ width: 0 })
                } else {
                  //图片展示区
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

                //定位
                Text(this.fake_person_data?.location)
                  .fontColor('#586b95')
                  .fontSize(14)
                  .margin({ top: 2 })

                // 发布时间、删除、点赞与评论以及触发按钮区域
                Row() {
                  // 发布时间和删除按钮区域
                  Row({ space: 5 }) {
                    // 发布时间
                    Text(this.fake_person_data?.show_time)
                      .fontColor('#BEBEBE')
                      .fontSize(12)
                    //判断是否有分享来源
                    if (this.fake_person_data?.share_source && this.fake_person_data.share_source !== '') {
                      //分享来源
                      Text(this.fake_person_data.share_source).fontColor('#BEBEBE').fontSize(12)
                    }
                    //删除按钮
                    Image($r('app.media.del'))
                      .width(16)
                      .height(16)
                      .onClick(() => {
                        // 获取待删除的分享时间
                        let shareTimeToDelete = this.fake_person_data!.share_time;
                        // 获取待删除的微信号码
                        let wxNumberToDelete = this.personal_data[0].wx_number;
                        // 根据分享时间获取年份
                        let yearToDelete = new Date(shareTimeToDelete).getFullYear();

                        // 遍历个人数据列表，寻找匹配的微信号码和年份，并删除相应的分享项
                        this.personal_data.forEach(person => {
                          if (person.wx_number === wxNumberToDelete) {
                            person.data.pyq_data.forEach(yearData => {
                              if (yearData.year === yearToDelete) {
                                // 过滤掉待删除的分享项
                                yearData.pyq_data_list = yearData.pyq_data_list.filter(pyqItem => {
                                  return pyqItem.share_time !== shareTimeToDelete;
                                })
                              }
                            })
                          }
                        });

                        // 更新全部朋友圈数据
                        this.pyq_all_Page_data = combineAndSortData(this.personal_data);

                        // 返回上一页
                        router.back();
                      })
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
                        // 切换用户点赞状态
                        if (this.is_like) {
                          // 如果用户已点赞，则取消点赞
                          this.is_like = !this.is_like
                          this.fake_person_data!.love_num -= 1
                          this.love_sum.shift()
                        } else {
                          // 如果用户未点赞，则进行点赞
                          this.is_like = !this.is_like
                          this.fake_person_data!.love_num += 1
                          this.love_sum.unshift(1)
                        }

                        // 300毫秒后隐藏当前界面
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
                        // 请求焦点到指定的id为dianzan_Page_textArea的输入框组件
                        this.getUIContext().getFocusController().requestFocus('dianzan_Page_textArea')

                        // 设置定时器，在300毫秒后执行回调函数
                        setTimeout(() => {
                          // 隐藏元素，使用Visibility.None枚举值
                          this.isShow = Visibility.None
                        }, 300);
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
                  }
                  .alignContent(Alignment.End)
                  .layoutWeight(1)
                }
                .height(25)
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

              }
              .padding({ top: 2 })
              .layoutWeight(1)
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .alignItems(VerticalAlign.Top)

            // 点赞头像和评论 展示区
            Row() {
              Column({ space: 1 }) {
                //判断点赞数是否为0
                if (this.fake_person_data!.love_num !== 0) {
                  Row({ space: 8 }) {
                    Image($r('app.media.love'))
                      .width(18)
                      .fillColor('#586b95')
                      .margin({ top: 5 })
                    // 头像
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
                //判断评论数是否为0
                if (this.fake_person_data?.comment_num !== 0) {
                  Row({ space: 8 }) {
                    Image($r('app.media.bubble'))
                      .width(18)
                      .fillColor('#586b95')
                      .margin({ top: 5 })
                    // 评论
                    Column({ space: 10 }) {
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
                              Text(formatTime(item.comment_time, 0))
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

      // 评论框
      Row({ space: 10 }) {
        //输入框
        TextArea({ placeholder: '评论', text: $$this.new_comment_content })
          .placeholderColor('##B2B2B2')
          .backgroundColor('#ffffff')
          .layoutWeight(1)
          .borderRadius(5)
          .caretColor('#00E050')
          .barState(BarState.Off)
          .heightAdaptivePolicy(TextHeightAdaptivePolicy.LAYOUT_CONSTRAINT_FIRST)
          .defaultFocus(false)//默认不获焦
          .enableKeyboardOnFocus(true)//获焦的时候打开键盘
          .id('dianzan_Page_textArea')// 获焦的时候的回调
          .onFocus(() => {
            this.listScroller.scrollEdge(Edge.Bottom) //控制列表滚动到下边缘
          })
        // 表情
        Image($r('app.media.smile'))
          .width(28)
          .height(28)
        //发送按钮
        Button('发送', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(5)
          .backgroundColor('#00E050')
          .fontColor('#ffffff')
          .height(34)
          .width(65)// 当点击事件发生时执行以下函数
          .onClick(() => {
            // 检查新评论内容是否不为空
            if (this.new_comment_content !== '') {
              // 创建一个新的评论对象
              let new_comment: comment_obj = {
                // 从个人数据中获取并赋值头像
                comment_avatar: this.personal_data[0].data.avatar,
                // 从个人数据中获取并赋值昵称
                comment_nickname: this.personal_data[0].data.nickname,
                // 将新评论内容赋值给评论对象
                comment_content: this.new_comment_content,
                // 获取当前时间戳并赋值给评论时间
                comment_time: new Date().getTime()
              }
              // 将新评论添加到评论列表的开头
              this.fake_person_data?.comment_content?.unshift(new_comment)
              // 更新评论数量
              this.fake_person_data!.comment_num += 1
              // 清空新评论内容
              this.new_comment_content = ''
            }
          })
      }
      .width('100%')
      .backgroundColor('#F7F7F7')
      .padding(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]) //将安全区域扩展到全屏

  }
}