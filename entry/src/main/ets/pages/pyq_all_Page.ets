import { LengthMetrics, router } from '@kit.ArkUI';
import { personal_data, personal_every_year_pyq_data, pyq_data } from '../utils/dataModel';
import { image_show } from '../utils/tool';
import { hilog } from '@kit.PerformanceAnalysisKit';


@Entry
@Component
struct Pyq_all_Page {
  @State listlocation :boolean = false
  @State textover:string = '全文'
  @State maxLinesindex:number = 999
  initlines:number = 0
  isover:boolean = false
  isVisibility:boolean = false
   // @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('fake_person_data') fake_person_data: personal_data[]=[]
  controller: TextController = new TextController()
  private listScroller: Scroller = new Scroller();


  build() {
    Stack(){
      Row(){
        Image($r('app.media.back'))
          .width(20)
          .fillColor(this.listlocation ? '#000000':'#ffffff')
          .onClick(()=>{
            router.back()
          })
        Text('朋友圈')
          .fontSize(18)
          .lineHeight(25)
          .opacity(this.listlocation ? 1 : 0)
        Image($r(this.listlocation ? 'app.media.camera':'app.media.camera_withe'))
          .width(23)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .zIndex(2)
      .backgroundColor(this.listlocation ? '#EDEDED' : Color.Transparent)
      .height(px2vp(this.topRectHeight)+54)
      .padding({top:px2vp(this.topRectHeight),left:10,right:10})
      .border({width:0})
      .animation({
        duration:200
      })


      List({ scroller: this.listScroller }){
        ListItem(){
          Column(){
            Image(image_show(this.fake_person_data[0].data.bg as string))
              .height('33.3%')
              .width('100%')
            Row({space:9}){
              Text(this.fake_person_data[0].data.nickname)
                .fontSize(20)
                .fontColor('#ffffff')
                .fontWeight(FontWeight.Bold)
                .margin({top:8})
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
            .onClick(()=>{
              router.pushUrl({url:'pages/detail_Page'})
            })
          }
        }
        .width('100%')

        ForEach(this.fake_person_data,(item1:personal_data,index)=>{
          ForEach(item1.data.pyq_data,(item2:personal_every_year_pyq_data,index)=>{
            ForEach(item2.pyq_data_list,(item3:pyq_data,index)=>{
                ListItem(){
                  Row({space:5}){
                    Column(){
                      Image(image_show(item1.data.avatar))
                        .width(50)
                        .height(50)
                        .objectFit(ImageFit.Cover)
                        .borderRadius(8)
                    }
                    Column(){
                      Text(item1.data.nickname)
                        .border({width:0})
                        .fontColor('#586b95')
                        .fontSize(18)
                      Text(item3.content,{ controller: this.controller })
                        .maxLines(this.maxLinesindex)
                        .textOverflow({overflow:TextOverflow.Clip})
                        .border({width:0})
                        .width('100%')
                        .fontSize(17)
                        // .onAppear(()=>{
                        //   let layoutManager: LayoutManager = this.controller.getLayoutManager();
                        //   this.initlines = layoutManager.getLineCount()
                        //   hilog.fatal(0x0064,'','initlines:'+this.initlines)
                        //   this.isVisibility = this.isover = this.initlines<=5
                        //   if (this.isover){
                        //     this.maxLinesindex=this.initlines
                        //   }else {
                        //     this.maxLinesindex=5
                        //     this.textover = '全文'
                        //   }
                        // })
                      // Text(this.textover)
                      //   .fontColor('#586b95')
                      //   .visibility(this.isVisibility ? Visibility.None : Visibility.Visible)
                      //   .onClick(()=>{
                      //     if (this.isover){
                      //       this.maxLinesindex = 5
                      //       this.textover = '全文'
                      //       this.isover = !this.isover
                      //     }else {
                      //       this.maxLinesindex = this.initlines
                      //       this.textover = '收起'
                      //       this.isover = !this.isover
                      //     }
                      //   })
                      Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }){
                        ForEach(item3.gallery,(pic:string,index)=>{
                          GridItem(){
                            Image(image_show(pic))
                              .objectFit(ImageFit.Cover)
                              .width(93)
                              .height(93)
                          }.backgroundColor('')
                        })
                      }
                      .width('100%')
                      .margin({top:10})

                      Text(item3.location).border({width:0}).fontColor('#586b95').fontSize(14)
                        .margin({top:5})
                      Row(){
                        Text(item3.show_time).fontColor('#BEBEBE').fontSize(12)
                        Image($r('app.media.ICO28_more')).width(30)
                          .height(23)
                          .backgroundColor('#F7F7F7').borderRadius(5)
                      }.border({width:0})
                      .width('100%')
                      .justifyContent(FlexAlign.SpaceBetween)
                      Row({space:10}){
                        Image($r('app.media.love')).width(20).fillColor('#586b95')
                        Text('陈爱银, 陈爱银').fontColor('#586b95').fontSize(16)
                          .lineHeight(25)
                      }.border({width:0})
                      .backgroundColor('#F7F7F7')
                      .width('100%')
                      .margin({top:5})
                      .padding({left:5})
                      .borderRadius(5)
                      .height(30)
                      .alignItems(VerticalAlign.Center)
                    }
                    .padding({top:2})
                    .layoutWeight(1)
                    .width('100%')
                    .alignItems(HorizontalAlign.Start)
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Top)
                }
                .margin({top:32})
                .padding({right:10,left:10,bottom:10})
            })
          })
        })

      }
      .divider({
        strokeWidth:0.5,
        color:'#D7D7D7'
      })
      .width('100%')
      .height('100%')
      .border({width:0})
      .backgroundColor('#ffffff')
      .scrollBar(BarState.Off)
      .onDidScroll(()=>{
        let location = this.listScroller.currentOffset().yOffset
        this.listlocation = location >= 168
      })
    }
    .alignContent(Alignment.Top)
    .backgroundColor('#EDEDED')
    .border({width:1})
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }
}