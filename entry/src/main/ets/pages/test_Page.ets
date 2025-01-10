
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

// function https(){
//   let httpRequest = http.createHttp();
//   // httpRequest.on('headersReceive', (header: Object) => {
//   //   hilog.fatal(1,'http','header: ' + JSON.stringify(header));
//   // });
//   let url:string = 'https://m.weibo.cn/favicon.ico';
//   httpRequest.request(url,(err: BusinessError,data :http.HttpResponse)=>{
//
//     if (!err) {
//       // data.result为HTTP响应内容，可根据业务需要进行解析
//       hilog.fatal(1,'http','Result:' + JSON.stringify(data));
//       // hilog.fatal(1,'http','code:' + JSON.stringify(data.responseCode));
//       // hilog.fatal(1,'http','type:' + JSON.stringify(data.resultType));
//       // // data.header为HTTP响应头，可根据业务需要进行解析
//       // hilog.fatal(1,'http','header:' + JSON.stringify(data.header));
//       // hilog.fatal(1,'http','cookies:' + JSON.stringify(data.cookies)); // 自API version 8开始支持cookie
//       // // 取消订阅HTTP响应头事件
//       // httpRequest.off('headersReceive');
//       // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
//       httpRequest.destroy();
//     }
//     else {
//       hilog.fatal(1,'http','error:' + JSON.stringify(err));
//       // httpRequest.off('headersReceive');
//       httpRequest.destroy();
//     }
//   });
// }

interface GeneratedTypeLiteralInterface_1 {
  protocol: string;
  hostname: string;
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
struct Dianzan_Page {
  @State parsedUrl: GeneratedTypeLiteralInterface_1|undefined = undefined;
  aboutToAppear(): void {
  // https()
  }

  @State image_url: string = ''
  @State url: string = ''

  build() {
    Column() {

      Tabs(){
        TabContent() {
          Text('解析图片')
        }
        .borderWidth({ left: 1 })
        .tabBar('图片')
      TabContent() {
        Row({space:5}) {
          TextArea({ placeholder: '请输入链接', text: $$this.url })
            .layoutWeight(1)
            .height('100%')
            .onChange((value: string) => {
              this.parsedUrl = parseUrl(value);
            })
          Column({space:5}) {
            Image(this.image_url)
              .width(70)
              .layoutWeight(1)
              .objectFit(ImageFit.Contain)
              .border({width:1})
            Button('自动获取')
              .controlSize(ControlSize.SMALL)
              .type(ButtonType.Normal)
              .borderRadius(5)
              .onClick(() => {
                this.image_url = `${this.parsedUrl!.protocol}${this.parsedUrl!.hostname}/favicon.ico`;
                hilog.fatal(1,'http','image_url:' + this.image_url);
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
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}