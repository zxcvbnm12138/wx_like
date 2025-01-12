import { useCascaderAreaData } from './data'

@Component
export default struct AreaPicker {
  @State cascade: TextCascadePickerRangeContent[] = useCascaderAreaData() //省市区列表数据
  @Link value: string[] //选中值例如：['北京市','北京市','东城区']

  build() {
    TextPicker({ range: this.cascade, value: this.value })
      .canLoop(false)
      .textStyle({
        font: {
          size: '14fp'
        }
      })
      .selectedTextStyle({
        font: {
          size: '16fp'
        }
      })
      .onChange((value: string | string[], index: number | number[]) => {
        this.onChange(value as string[], index as number[])
        this.value = value as string[]
      })

  }

  private onChange: (value: string[], index: number[]) => void = () => {
  } //选择改变回调函数
}
