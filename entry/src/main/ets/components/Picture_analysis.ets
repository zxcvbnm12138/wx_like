/*
 * 解析图片 组件
 */
import { image_show } from '../utils/tool';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';

@Component
export struct Picture_analysis {
  dragIndex: number = 0
  @Consume pic_sum: number
  @Consume new_pic_list: string[]
  private context = getContext(this) as common.UIAbilityContext;

  changeIndex(dragIndex: number, insertIndex: number) {
    let temp: string = this.new_pic_list[insertIndex]
    this.new_pic_list[insertIndex] = this.new_pic_list[dragIndex]
    this.new_pic_list[dragIndex] = temp
  }

  build() {
    if (this.pic_sum == 0) {
      Text('解析图片')
    } else {
      List({ space: 2 }) {
        ForEach(this.new_pic_list, (item: string, index) => {
          ListItem() {
            Image(image_show(item))
              .width(45)
              .height(42)
              .border({ width: 1 })
          }
          .draggable(true)
          .onDragStart(() => {
          })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.dragIndex = index;
              hilog.fatal(9, 'onDrop', 'index:' + index)
            }
          })
        })
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical)
      .lanes(5)
      .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE,
        uniformTypeDescriptor.UniformDataType.OPENHARMONY_PIXEL_MAP])
      .onDrop((event: DragEvent, extraParams?: string) => {
        let arr: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
        let img = arr[0] as unifiedDataChannel.SystemDefinedPixelMap;
        hilog.fatal(9, 'onDrop', 'insertIndex:' + JSON.parse(extraParams as string).insertIndex)
        let insertIndex: number = JSON.parse(extraParams as string).insertIndex
        this.changeIndex(this.dragIndex, insertIndex);
      })
    }
  }
}