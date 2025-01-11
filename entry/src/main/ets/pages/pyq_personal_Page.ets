import { CustomContentDialog, router } from '@kit.ArkUI';
import {
  formatTime,
  image_show,
  ImageUploadLocal,
  logoutput,
  random_sc,
  sortPyqData,
  sortPyqDataList
} from '../utils/tool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  comment_obj,
  convertTime,
  personal_data,
  personal_detail_data,
  personal_every_year_pyq_data,
  pyq_data,
} from '../utils/dataModel';
import { Pyq_Layout } from '../components/pyq_Layout';
import AreaPickerDialog from '../components/AreaPickerDialog/AreaPickerDialog';
import { common } from '@kit.AbilityKit';
import { Picture_analysis } from '../components/Picture_analysis';
import { combineAndSortData, pyq_all_Page_data } from './pyq_all_Page';

interface GeneratedTypeLiteralInterface_1 {
  protocol: string;
  hostname: string;
}

interface data_from_dianzanPage {
  new_fake_personal_data: pyq_data
}

function parseUrl(url: string): GeneratedTypeLiteralInterface_1 {
  const regex = /^(https?:\/\/)?([^\/]+)/;
  const match = url.match(regex);
  if (match) {
    return {
      protocol: match[1] || 'http://',
      hostname: match[2]
    };
  }
  throw new Error('Invalid URL');
}


@Entry
@Component
struct Pyq_all_Page {
  @State new_comment_list: comment_obj[] = []
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageLink('fake_person_data') fake_personal_data: personal_data[] = []
  @StorageLink('pyq_all_Page_data') pyq_all_Page_data: pyq_all_Page_data[] = []
  @State profileSrcPixmap: PixelMap = image_show(this.fake_personal_data[0].data.avatar)
  @State commentSrcPixmap: PixelMap = image_show(this.fake_personal_data[0].data.avatar)
  @State listlocation: boolean = false
  old_wx_number: string = ''
  @State new_person_data: personal_data | undefined = undefined
  @State new_personal_detail_data: personal_detail_data | undefined = undefined
  new_wx_number: string = ''
  new_avater: string = this.fake_personal_data[0].data.avatar
  new_nickname: string = ''
  new_district: string = ''
  new_content: string = ''
  new_gallery: string[] = []
  new_location: string = ''
  new_love_sum: number = 0
  new_comment_num: number = 0
  new_comment_content: comment_obj[] = []
  new_share_time: number = new Date().getTime()
  new_share_source: string = ''
  @State new_comment_avatar: string = this.fake_personal_data[0].data.avatar
  @State new_comment_nickname: string = ''
  @State new_comment_contents: string = ''
  new_comment_share_time: number = new Date().getTime();
  @State selectedDate: string = '选择发布时间'
  @State comment_selectedDate: string = '选择发布时间'
  @State selectedDistrict: string = '选择地区'
  @State pickerValue: string[] = [] //省市区选中值
  @State areaController: CustomDialogController | null = null //省市区选择组件控制器
  @Provide pic_sum: number = 0
  @Provide new_pic_list: string[] = []
  @State parsedUrl: GeneratedTypeLiteralInterface_1 | undefined = undefined;
  @State image_url: string = ''
  @State url: string = ''
  @State bg_url: string = this.fake_personal_data[0].data.bg as string
  comment_add_dialog: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.comment_add_dialog_builder();
      },
      buttons: [
        {
          value: '取消',
          buttonStyle: ButtonStyleMode.NORMAL,
          action: () => {
          }
        },
        {
          value: '确定',
          fontColor: '#000000',
          buttonStyle: ButtonStyleMode.EMPHASIZED,
          background: '#00E050',
          action: () => {
            if (this.new_comment_list.length !== 0) {
              this.new_comment_num = this.new_comment_list.length
              this.new_comment_content = this.new_comment_list
            }
            this.new_comment_avatar = this.fake_personal_data[0].data.avatar
            this.new_comment_nickname = ''
            this.new_comment_contents = ''
            this.new_comment_share_time = new Date().getTime();
            this.new_comment_list = []
          }
        }
      ],
    }),
  })
  @State pyq_personal_Page_data: personal_data = this.fake_personal_data[0]
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: '取消',
          buttonStyle: ButtonStyleMode.NORMAL,
          action: () => {
          }
        },
        {
          value: '发布',
          fontColor: '#000000',
          buttonStyle: ButtonStyleMode.EMPHASIZED,
          background: '#00E050',
          action: () => {
            // hilog.fatal(1, '新数据',
            //   'new_wx_number:' + this.new_wx_number + '\n' +
            //     'new_avater:' + this.new_avater + '\n' +
            //     'new_nickname:' + this.new_nickname + '\n' +
            //     'new_district:' + this.new_district + '\n' +
            //     'new_content:' + this.new_content + '\n' +
            //     'new_gallery:' + this.new_gallery.toString() + '\n' +
            //     'new_location:' + this.new_location + '\n' +
            //     'new_love_sum:' + this.new_love_sum + '\n' +
            //     'new_comment_num:' + this.new_comment_num + '\n' +
            //     'new_comment_content:' + this.new_comment_content.toString() + '\n' +
            //     'new_share_time:' + this.new_share_time + '\n'
            // )

            //判断时候有新图片，如果有新图片就直接插入到pyq_first4_pic数组中
            if (this.new_gallery.length !== 0) {
              this.fake_personal_data[0].data.pyq_first4_pic.push(...this.new_gallery)
            }
            //构建新的pyq_data
            let new_pyq_data: pyq_data = {
              content: this.new_content,
              gallery: this.new_gallery,
              location: this.new_location,
              love_num: Number(this.new_love_sum),
              comment_num: this.new_comment_num,
              comment_content: this.new_comment_content,
              show_time: convertTime(this.new_share_time),
              share_time: this.new_share_time,
              link: this.url,
              link_image_url: this.image_url,
              share_source: this.new_share_source
            }

            //获取要发布的朋友圈的年份
            let new_year = new Date(this.new_share_time).getFullYear()
            //判断年份是否已经存在
            let isIn: boolean = false
            for (const obj of this.fake_personal_data[0].data.pyq_data) {
              //若年份已存在，直接插入新数据
              if (Object.values(obj).includes(new_year)) {
                isIn = true
                obj.pyq_data_list.unshift(new_pyq_data)
              }
            }
            //若年份不存在，构建新的personal_every_year_pyq_data数据，然后插入到pyq_data数组中
            if (!isIn) {
              let new_pyq_data_list: pyq_data[] = []
              new_pyq_data_list.push(new_pyq_data)

              let new_personal_every_year_pyq_data: personal_every_year_pyq_data = {
                year: new_year,
                pyq_data_list: new_pyq_data_list
              }
              this.fake_personal_data[0].data.pyq_data.unshift(new_personal_every_year_pyq_data)
            }

            //判断微信号是否为空，为空则使用旧数据
            if (this.new_wx_number == '') {
              this.new_wx_number = this.old_wx_number
            }
            //判断昵称是否为空，为空则使用旧数据
            if (this.new_nickname == '') {
              this.new_nickname = this.fake_personal_data[0].data.nickname
            }
            //判断地区是否为空，为空则使用旧数据
            if (this.new_district == '') {
              this.new_district = this.fake_personal_data[0].data.district
            }

            //构建新的personal_detail_data数据
            this.new_personal_detail_data = {
              avatar: this.new_avater,
              nickname: this.new_nickname,
              district: this.new_district,
              pyq_first4_pic: this.fake_personal_data[0].data.pyq_first4_pic,
              pyq_data: this.fake_personal_data[0].data.pyq_data,
              bg: this.bg_url
            }
            //构建新的personal_data数据
            this.new_person_data = {
              wx_number: this.new_wx_number,
              data: this.new_personal_detail_data
            }
            //打印新personal_data的数据
            logoutput(this.new_person_data, 'new_person_data')
            //更新personal_data[0]
            this.fake_personal_data[0] = this.new_person_data
            this.pyq_personal_Page_data = this.new_person_data
            //按照朋友圈的年份进行降序排序
            this.fake_personal_data = sortPyqData(this.fake_personal_data)
            this.fake_personal_data = sortPyqDataList(this.fake_personal_data)

            this.pyq_all_Page_data = combineAndSortData(this.fake_personal_data)
            //重置数据
            this.new_wx_number = ''
            this.new_avater = this.fake_personal_data[0].data.avatar
            this.new_nickname = ''
            this.new_district = ''
            this.new_content = ''
            this.new_gallery = []
            this.new_location = ''
            this.new_love_sum = 0
            this.new_comment_num = 0
            this.new_comment_content = []
            this.new_share_time = new Date().getTime()
            this.new_pic_list = []
            this.url = ''
            this.image_url = ''
            this.selectedDate = '选择发布时间'
            this.selectedDistrict = '选择地区'
            this.pickerValue = []
            this.new_share_source = ''
          }
        }
      ],
    }),
  });
  private context = getContext(this) as common.UIAbilityContext;
  private listScroller: Scroller = new Scroller();

  @Styles
  TexInput_commonstyles() {
    .width('100%')
    .borderRadius(5)
  }

  @Builder
  buildContent(): void {
    Scroll() {
      Column({ space: 5 }) {
        Row({ space: 5 }) {
          Image(this.profileSrcPixmap)
            .width(80)
            .height(80)
            .border({ width: 1 })
            .objectFit(ImageFit.Cover)
            .onClick(async () => {
              let res = (await ImageUploadLocal(1, this.context.getApplicationContext()))
              if (res.avater_url !== '') {
                this.new_avater = res.avater_url as string
                this.profileSrcPixmap = image_show(res.avater_url as string)
              }
            })
          Column({ space: 5 }) {
            TextInput({
              placeholder: '昵称',
              text: $$this.new_nickname
            })
              .TexInput_commonstyles()
            TextInput({
              placeholder: '微信号',
              text: $$this.new_wx_number
            })
              .TexInput_commonstyles()

            Button(this.selectedDistrict)
              .buttonStyle(ButtonStyleMode.NORMAL)
              .type(ButtonType.Normal)
              .TexInput_commonstyles()
              .onClick(() => {
                this.areaController?.open()
              })

            Button(this.selectedDate)
              .buttonStyle(ButtonStyleMode.NORMAL)
              .type(ButtonType.Normal)
              .TexInput_commonstyles()
              .onClick(() => {
                this.getUIContext().showDatePickerDialog({
                  selected: new Date(),
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value: Date) => {
                    this.selectedDate = formatTime(value.getTime(), 0)
                    this.new_share_time = value.getTime()

                  }
                })
              })
          }
          .layoutWeight(1)
        }
        .width('100%')

        TextArea({ placeholder: '需要分享的内容', text: $$this.new_content })
          .TexInput_commonstyles()
          .height(100)
        Tabs() {
          TabContent() {
            Picture_analysis()
          }
          .padding(5)
          .width('100%')
          .borderWidth({ left: 1 })
          .tabBar('图片')
          .onClick(async () => {
            let res = (await ImageUploadLocal(9, this.context.getApplicationContext()))
            hilog.fatal(1, 'Picture_analysis', '' + res.avater_url)
            this.pic_sum = res.avater_url.length
            this.new_pic_list = res.avater_url as string[]
            this.new_gallery = this.new_pic_list
          })

          TabContent() {
            Row({ space: 5 }) {
              TextArea({ placeholder: '请输入链接', text: $$this.url })
                .barState(BarState.Off)
                .fontSize(14)
                .layoutWeight(1)
                .height('100%')
                .onChange((value: string) => {
                  if (value !== '') {
                    this.parsedUrl = parseUrl(value);
                  }
                })
              Column({ space: 5 }) {
                Image(this.image_url)
                  .width(70)
                  .layoutWeight(1)
                  .objectFit(ImageFit.Contain)
                  .border({ width: 1 })
                Button('自动获取')
                  .controlSize(ControlSize.SMALL)
                  .type(ButtonType.Normal)
                  .borderRadius(5)
                  .onClick(() => {
                    if (this.parsedUrl !== undefined) {
                      this.image_url = `${this.parsedUrl!.protocol}${this.parsedUrl!.hostname}/favicon.ico`;
                      hilog.fatal(1, 'http', 'image_url:' + this.image_url);
                    }

                  })
              }
              .height('100%')
            }
            .padding(10)
            .height('100%')
          }
          .borderWidth({ left: 1 })
          .tabBar('链接')
        }
        .border({ width: 1 })
        .borderRadius(5)
        .vertical(true)
        .scrollable(false)
        .height(100)
        .onChange((index: number) => {
          if (index == 0) {
            this.url = ''
          } else {
            this.new_gallery = []
            this.pic_sum = 0
            this.new_pic_list = []
          }
        })

        TextInput({ placeholder: '定位（可不填）', text: $$this.new_location })
          .TexInput_commonstyles()

        Row({ space: 5 }) {
          Button('好友朋友圈模式')
            .layoutWeight(1)
            .buttonStyle(ButtonStyleMode.NORMAL)
            .borderRadius(5)
            .type(ButtonType.Normal)
          Button('添加评论')
            .layoutWeight(1)
            .buttonStyle(ButtonStyleMode.NORMAL)
            .borderRadius(5)
            .type(ButtonType.Normal)
            .onClick(() => {
              this.comment_add_dialog.open()
            })
        }
        .width('100%')

        Row({ space: 5 }) {
          TextInput({ placeholder: '点赞数量', text: $$this.new_love_sum })
            .placeholderFont({ size: 14 })
            .TexInput_commonstyles()
            .layoutWeight(1)
            .type(InputType.Number)
          TextInput({ placeholder: '分享来源（可不填）', text: $$this.new_share_source })
            .TexInput_commonstyles()
            .layoutWeight(2)
        }
        .width('100%')

        Button('自定义好友')
          .type(ButtonType.Normal)
          .buttonStyle(ButtonStyleMode.NORMAL)
          .borderRadius(5)
          .width('100%')
      }
      .width('100%')
    }
    .scrollBar(BarState.Off)
  }

  @Builder
  comment_add_dialog_builder(): void {
    Column({ space: 5 }) {
      Column({ space: 5 }) {
        Row({ space: 5 }) {
          Image(this.commentSrcPixmap)
            .width(50)
            .height(50)
            .objectFit(ImageFit.Cover)
            .border({ width: 1 })
            .onClick(async () => {
              let res = (await ImageUploadLocal(1, this.context.getApplicationContext()))
              if (res.avater_url !== '') {
                this.new_comment_avatar = res.avater_url as string
                this.commentSrcPixmap = image_show(this.new_comment_avatar)
              }
            })
          Column({ space: 5 }) {
            TextInput({ placeholder: '昵称', text: $$this.new_comment_nickname })
              .TexInput_commonstyles()
            TextArea({ placeholder: '内容', text: $$this.new_comment_contents })
              .TexInput_commonstyles()
            Button(this.comment_selectedDate)
              .buttonStyle(ButtonStyleMode.NORMAL)
              .type(ButtonType.Normal)
              .TexInput_commonstyles()
              .onClick(() => {
                this.getUIContext().showDatePickerDialog({
                  selected: new Date(),
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value: Date) => {
                    this.comment_selectedDate = formatTime(value.getTime(), 0)
                    this.new_comment_share_time = value.getTime()
                  }
                })
              })
          }
          .layoutWeight(1)
        }

        Row({ space: 10 }) {
          Button('随机生成')
            .type(ButtonType.Normal)
            .buttonStyle(ButtonStyleMode.NORMAL)
            .borderRadius(5)
            .layoutWeight(1)
            .onClick(() => {
              let random_comment_obj: comment_obj = random_sc(this.fake_personal_data[0].data.avatar)
              this.new_comment_avatar = random_comment_obj.comment_avatar
              this.new_comment_nickname = random_comment_obj.comment_nickname
              this.new_comment_contents = random_comment_obj.comment_content
              this.comment_selectedDate = formatTime(random_comment_obj.comment_time, 0)
              this.commentSrcPixmap = image_show(this.new_comment_avatar)

            })
          Button('添加评论')
            .type(ButtonType.Normal)
            .buttonStyle(ButtonStyleMode.NORMAL)
            .borderRadius(5)
            .layoutWeight(1)
            .onClick(() => {
              let new_comment: comment_obj = {
                comment_avatar: this.new_comment_avatar,
                comment_nickname: this.new_comment_nickname,
                comment_content: this.new_comment_contents,
                comment_time: this.new_comment_share_time
              }
              this.new_comment_list.push(new_comment)
              hilog.fatal(1, 'http', 'new_comment_list:' + JSON.stringify(this.new_comment_list));
            })
        }.width('100%')

      }
      .width('100%')

      Column() {
        if (this.new_comment_list.length !== 0) {
          Row() {
            Text(`共${this.new_comment_list.length}条评论`)
              .fontSize(15)
            Text('一键清空')
              .fontSize(15)
              .onClick(() => {
                this.new_comment_list = []
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)

          List({ space: 5 }) {
            ForEach(this.new_comment_list, (item: comment_obj, index) => {
              ListItem() {
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
              }
              .borderRadius(5)
              .padding(5)
              .border({ width: 1 })
            })
          }
          .width('100%')
          .scrollBar(BarState.Off)
          .padding(5)
        } else {
          Text('还没添加评论哦~')
            .fontSize(17)
        }

      }.backgroundColor('#ECECEC')
      .width('100%')
      .borderRadius(5)
      .padding(5)
    }
    .width('100%')

  }

  aboutToAppear(): void {
    // this.back_pyq_personal_Page_data = this.fake_personal_data[0]
    this.old_wx_number = this.fake_personal_data[0].wx_number
    //省市区选择器自定义弹窗
    this.areaController = new CustomDialogController({
      builder: AreaPickerDialog({
        value: this.pickerValue, //首次默认选中值
        onChange: (value: string[]) => { //选择改变回调
          this.pickerValue = value
          if (this.pickerValue[0].replace(/省|自治区|市/g, '') == this.pickerValue[1].replace(/市/g, '')) {
            this.selectedDistrict = this.pickerValue[0].replace(/省|自治区|市/g, '')
          } else {
            this.selectedDistrict =
              this.pickerValue[0].replace(/省|自治区|市/g, '') + ' ' + this.pickerValue[1].replace(/市/g, '')
          }
          this.new_district = this.selectedDistrict

        }
      }),
      customStyle: true,
    })
  }

  onPageShow(): void {
    this.pyq_personal_Page_data = this.fake_personal_data[0]

    let res = router.getParams() as data_from_dianzanPage

    if (res !== undefined) {
      logoutput(res.new_fake_personal_data, 'new_fake_personal_data')
      for (let yearData of this.fake_personal_data[0].data.pyq_data) {
        if (yearData.year == new Date(res.new_fake_personal_data.share_time).getFullYear()) {
          for (let i = 0; i < yearData.pyq_data_list.length; i++) {
            if (yearData.pyq_data_list[i].share_time === res.new_fake_personal_data.share_time) {
              logoutput(yearData.pyq_data_list[i], '原数据')
              yearData.pyq_data_list[i] = res.new_fake_personal_data;
              logoutput(yearData.pyq_data_list[i], '更新后的数据')
            }
          }
        }
      }
      this.pyq_all_Page_data = combineAndSortData(this.fake_personal_data)
    }
    logoutput(this.fake_personal_data[0], 'new_fake_personal_data更新后的全局数据')
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
        Text('相册')
          .fontSize(18)
          .lineHeight(25)
          .opacity(this.listlocation ? 1 : 0)
        Image($r(this.listlocation ? 'app.media.bubble' : 'app.media.bubble_withe'))
          .width(23)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .zIndex(2)
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
              .objectFit(ImageFit.Cover)
              .onClick(async () => {
                let res = (await ImageUploadLocal(1, this.context.getApplicationContext()))
                if (res.avater_url !== '') {
                  this.bg_url = res.avater_url as string
                  this.fake_personal_data[0].data.bg = res.avater_url as string
                }
              })
            Row({ space: 9 }) {
              Text(this.pyq_personal_Page_data.data.nickname)
                .fontSize(20)
                .fontColor('#ffffff')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 8 })
                .layoutWeight(1)
                .textAlign(TextAlign.End)
              Image(image_show(this.pyq_personal_Page_data.data.avatar))
                .width(70)
                .height(70)
                .borderRadius(10)
            }
            .width(159)
            .height(70)
            .alignItems(VerticalAlign.Top)
            .position({ x: '55.00%', y: '28.00%' })
            .onClick(() => {
              router.back()
            })
          }.width('100%')
        }
        .width('100%')

        ListItem() {
          Row({ space: 5 }) {
            Text('今天').fontSize(22)
              .fontWeight(FontWeight.Bold)
              .padding({ top: 8 })
              .width(48.33)
            Row() {
              Image($r('app.media.camera_gray')).width(20)
            }
            .margin({ left: 10 })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .width(80)
            .height(80)
            .backgroundColor('#F7F7F7')
            .onClick(() => {
              this.dialogController.open()
            })
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
        }
        .margin({ top: 32 })
        .padding({ right: 10, left: 10 })

        ForEach(this.pyq_personal_Page_data.data.pyq_data, (item: personal_every_year_pyq_data, index) => {

          if (item.pyq_data_list.length !== 0) {
            ListItem() {
              Text(item.year.toString() + '年')
                .fontSize(23)
            }
            .margin({ top: 25 })
            .padding({ right: 10, left: 10 })
          }


          ForEach(item.pyq_data_list, (item: pyq_data, index) => {
            ListItem() {
              Row({ space: 5 }) {
                Text() {
                  Span(new Date(item.share_time).getDate().toString().padStart(2, '0'))
                  Span((new Date(item.share_time).getMonth() + 1).toString() + '月')
                    .fontSize(11)
                    .margin({ bottom: 8 })
                  Span('\n')
                  Span(item.location)
                    .fontSize(10)
                    .fontColor('#BEBEBE')
                }
                .width(48.33)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .padding({ top: 2 })

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
                  .layoutWeight(1)
                  .alignItems(VerticalAlign.Center)
                  .margin({ left: 10 })
                  .backgroundColor('#F7F7F7')
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/dianzan_Page',
                      params: {
                        avater: this.pyq_personal_Page_data.data.avatar,
                        nickname: this.pyq_personal_Page_data.data.nickname,
                        result: item
                      }
                    })
                  })
                } else {
                  Row() {
                    Pyq_Layout({
                      picture_num: item.gallery.length,
                      picture_list: item.gallery
                    })
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/pyq_detail_Page',
                          params: {
                            result: item
                          }
                        })
                      })
                    Row() {
                      Text(item.content)
                        .backgroundColor(item.gallery.length == 0 ? '#F7F7F7' : '')
                        .fontSize(18)
                        .margin({ left: item.gallery.length == 0 ? 0 : 5 })
                        .layoutWeight(1)
                        .maxLines(3)
                        .padding(item.gallery.length == 0 ? 8 : 0)
                        .textAlign(TextAlign.Start)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .layoutWeight(1)
                    .height(80)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/dianzan_Page',
                        params: {
                          avater: this.pyq_personal_Page_data.data.avatar,
                          nickname: this.pyq_personal_Page_data.data.nickname,
                          result: item
                        }
                      })
                    })
                  }
                  .layoutWeight(1)
                  .alignItems(VerticalAlign.Top)
                  .margin({ left: 10 })
                }
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)
            }
            .margin({ top: 25 })
            .padding({ right: 10, left: 10 })

          })
        })
      }
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
    .border({ width: 0 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}


