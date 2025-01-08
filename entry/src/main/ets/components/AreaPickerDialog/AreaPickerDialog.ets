import AreaPicker from './AreaPicker'

@CustomDialog
export default struct AreaPickerDialog {
  private dialogController: CustomDialogController //弹窗控制器
  @State value: string[] = [] //选中值
  //确认关闭选择改变回调
  public  onChange: (value: string[]) => void = () => {
  }
  private defaultValue: string[] = []; //首次打开选中值

  aboutToAppear(): void {
    //记录打开时候的默认值
    this.defaultValue = this.value
    if (Array.isArray(this.value) && this.value.length < 3) {
      this.value = ['北京市', '北京市', '东城区']; //设置默认值
    }
  }

  build() {
    Column({ space: 50 }) {
      //头部确认、取消操作行
      Row() {
        Text('取消')
          .fontColor('#909090')
          .onClick(() => {
            this.dialogController.close()
          })
        Text('请选择省市区')
        Text('确定')
          .fontColor('#0A7EE6')
          .onClick(() => {
            //和首次打开值对比
            if (this.defaultValue.join('') !== this.value.join('')) {
              this.onChange(this.value)
            }
            this.dialogController.close()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      //地区选择器
      AreaPicker({ value: this.value })
    }
    .backgroundColor(Color.White)
    .borderRadius(24)
    .padding(20)
    .width('93%')
  }
}
