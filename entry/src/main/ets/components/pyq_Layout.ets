/*
 * 朋友圈图片布局 组件
 */
import { image_show } from '../utils/tool'

@Component
export struct Pyq_Layout {
  @Prop
  picture_num: number
  layoutOptions3: GridLayoutOptions = {
    regularSize: [1, 1],
    onGetRectByIndex: (index: number) => {
      if (index == 0) { // key1是“0”按键对应的index
        return [0, 0, 2, 1]
      }
      return [1, 1, 1, 1]
    }
  }
  layoutOptions5: GridLayoutOptions = {
    regularSize: [1, 1],
    onGetRectByIndex: (index: number) => {
      if (index == 0) { // key1是“0”按键对应的index
        return [0, 0, 2, 2]
      } else if (index == 1) { // key2是“=”按键对应的index
        return [0, 2, 2, 1]
      }
      return [1, 1, 1, 1]
    }
  }
  layoutOptions6: GridLayoutOptions = {
    regularSize: [1, 1],
    onGetRectByIndex: (index: number) => {
      if (index == 0) { // key1是“0”按键对应的index
        return [0, 0, 2, 2]
      }
      return [1, 1, 1, 1]
    }
  }
  layoutOptions7: GridLayoutOptions = {
    regularSize: [1, 1],
    onGetRectByIndex: (index: number) => {
      if (index == 0) { // key1是“0”按键对应的index
        return [0, 0, 2, 1]
      } else if (index == 1) {
        return [0, 1, 2, 1]
      }
      return [1, 1, 1, 1]
    }
  }
  layoutOptions8: GridLayoutOptions = {
    regularSize: [1, 1],
    onGetRectByIndex: (index: number) => {
      if (index == 0) { // key1是“0”按键对应的index
        return [0, 0, 2, 1]
      }
      return [1, 1, 1, 1]
    }
  }
  @Prop
  picture_list: string[]

  build() {
    if (this.picture_num == 1) {
      Grid() {
        GridItem() {
          Image(image_show(this.picture_list[0]))
            .objectFit(ImageFit.Cover)
        }
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr')
      .rowsTemplate('1fr')
    } else if (this.picture_num == 2) {
      Grid() {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .rowsGap(1)
      .columnsGap(1)
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr')
    } else if (this.picture_num == 3) {
      Grid(undefined, this.layoutOptions3) {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    } else if (this.picture_num == 4) {
      Grid() {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    } else if (this.picture_num == 5) {
      Grid(undefined, this.layoutOptions5) {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    } else if (this.picture_num == 6) {
      Grid(undefined, this.layoutOptions6) {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    } else if (this.picture_num == 7) {
      Grid(undefined, this.layoutOptions7) {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    } else if (this.picture_num == 8) {
      Grid(undefined, this.layoutOptions8) {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    } else if (this.picture_num == 9) {
      Grid() {
        ForEach(this.picture_list, (url: string, index) => {
          GridItem() {
            Image(image_show(url))
              .objectFit(ImageFit.Cover)
          }

        })
      }
      .width(80)
      .height(80)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap(1)
      .columnsGap(1)
    }
  }
}