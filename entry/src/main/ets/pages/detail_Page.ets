import { router } from '@kit.ArkUI';
import { fake_data, personal_data,  } from '../utils/dataModel';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image_show } from '../utils/tool';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Detail_Page {
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('fake_person_data') fake_person_data: personal_data[] = []

  build() {
    Stack(){
      Row(){
        Image($r('app.media.back'))
          .width(20)
          .onClick(()=>{
            router.back()
          })
          .border({ width: 0})
      }
      .border({width:0})
      .width('100%')
      .zIndex(2)
      .backgroundColor('#ffffff' )
      .height(px2vp(this.topRectHeight)+54)
      .padding({top:px2vp(this.topRectHeight),left:10,right:10})
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Column({space:10}){
        Row({space:20}) {
          Image(image_show(this.fake_person_data[0].data.avatar))
            .width(70)
            .height(70)
            .objectFit(ImageFit.Cover)
            .borderRadius(5)
            .border({ width: 0})
          Column({space:3}) {
            Row(){
              Text(this.fake_person_data[0].data.nickname)
                .fontSize(20)
                .fontColor(Color.Black)
                .lineHeight(25)
              Image($r('app.media.male'))
                .width(16)
                .margin({left:5})
            }
            Text('微信号：'+this.fake_person_data[0].wx_number)
              .fontSize(15)
              .fontColor('#BEBEBE')
              .lineHeight(19)
            Text('地区：' +
              this.fake_person_data[0].data.district)
              .fontSize(15)
              .fontColor('#BEBEBE')
              .lineHeight(19)
          }
          .padding({top:8})
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .height(110)
        .backgroundColor('#ffffff')
        .padding({ top:5,left:10,right: 10 })
        .alignItems(VerticalAlign.Top)

        Row(){
          Text('朋友圈')
            .fontSize(16)
            .lineHeight(20)
          Row({space:10}){
            ForEach(this.fake_person_data[0].data.pyq_first4_pic,(item:string,index)=>{
              if (index <4){
                Image(image_show(item))
                  .width(50)
              }
            })
          }
          Image($r('app.media.forward'))
            .width(20)
        }
        .width('100%')
        .height(85)
        .padding({left:10,right:10})
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor('#ffffff')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/pyq_personal_Page',
          })
        })

        Row({space:7}){
          Image($r('app.media.chat')).width(23).fillColor('#586b95')
          Text('发消息').fontColor('#586b95').fontSize(18)
        }
        .width('100%')
        .height(55)
        .backgroundColor('#ffffff')
        .justifyContent(FlexAlign.Center)


      }
      .width('100%')
      .margin({top:px2vp(this.topRectHeight)+54})


    }
    .alignContent(Alignment.Top)
    .backgroundColor('#EDEDED')
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }
}