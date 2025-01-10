import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';
import { buffer } from '@kit.ArkTS';
import { personal_data, personal_every_year_pyq_data } from './dataModel';

export function Arraysc(t: number): number[] {
  let numbers: number[] = [];
  // 使用for循环从1遍历到38，将每个数字添加到数组中
  for (let i = 1; i <= t; i++) {
    numbers.push(i);
  }
  return numbers
}

interface GeneratedTypeLiteralInterface_1 {
  new_avater?: PixelMap;
  avater_url: string|string[];
}

export async function ImageUploadLocal(pic_sum:number,context: Context | undefined): Promise<GeneratedTypeLiteralInterface_1> {
  const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
  const photoPicker = new photoAccessHelper.PhotoViewPicker()

  photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE
  if (pic_sum == 1){
    photoSelectOptions.maxSelectNumber = pic_sum; // 选择媒体文件的最大数目
    const photoSelectResult = await photoPicker.select(photoSelectOptions)
    let imageUrl: string = photoSelectResult.photoUris[0];
    hilog.fatal(0x0001, "ImageUploadLocal", '拿到了图片url:' + imageUrl)

    let file = fs.openSync(imageUrl, fs.OpenMode.READ_ONLY);
    hilog.fatal(0x0001, "ImageUploadLocal", 'file fd: ' + file.fd);

    hilog.fatal(0x0001, "ImageUploadLocal", "CacheDir:" + context?.cacheDir)
    const fileType = 'jpg'
    // 生成一个新的文件名
    const fileName = Date.now() + '.' + fileType
    // 通过缓存路径+文件名 拼接出完整的路径
    const copyFilePath = context?.cacheDir + '/' + fileName
    hilog.fatal(0x0001, "ImageUploadLocal", "copyFilePath:" + copyFilePath)
    // 将文件 拷贝到 临时目录
    fs.copyFileSync(file.fd, copyFilePath)

    let file2 = fs.openSync(copyFilePath, fs.OpenMode.READ_ONLY);
    hilog.fatal(0x0001, "ImageUploadLocal", "file2:" + file2.fd)

    const imageSourceApi = image.createImageSource(file2.fd)
    let profileImage = imageSourceApi.createPixelMapSync()
    hilog.fatal(0x0001, "ImageUploadLocal", 'profileImage: ' + profileImage);
    return {
      new_avater: profileImage,
      avater_url: copyFilePath
    }
  }else {
    photoSelectOptions.maxSelectNumber = pic_sum; // 选择媒体文件的最大数目
    const photoSelectResult = await photoPicker.select(photoSelectOptions)
    let imageUrl: string[] = photoSelectResult.photoUris;
    let copyFilePath_list:string[] =[]
    for (let i:number = 0; i<imageUrl.length;i++) {
      hilog.fatal(0x0001, "ImageUploadLocal", '拿到了图片url:' + imageUrl)

      let file = fs.openSync(imageUrl[i], fs.OpenMode.READ_ONLY);
      hilog.fatal(0x0001, "ImageUploadLocal", 'file fd: ' + file.fd);

      hilog.fatal(0x0001, "ImageUploadLocal", "CacheDir:" + context?.cacheDir)
      const fileType = 'jpg'
      // 生成一个新的文件名
      const fileName = Date.now() + '.' + fileType
      // 通过缓存路径+文件名 拼接出完整的路径
      const copyFilePath = context?.cacheDir + '/' + fileName
      copyFilePath_list.push(copyFilePath)
      hilog.fatal(0x0001, "ImageUploadLocal", "copyFilePath:" + copyFilePath)
      // 将文件 拷贝到 临时目录
      fs.copyFileSync(file.fd, copyFilePath)

      let file2 = fs.openSync(copyFilePath, fs.OpenMode.READ_ONLY);
      hilog.fatal(0x0001, "ImageUploadLocal", "file2:" + file2.fd)

      // const imageSourceApi = image.createImageSource(file2.fd)
      // let profileImage = imageSourceApi.createPixelMapSync()
      // hilog.fatal(0x0001, "ImageUploadLocal", 'profileImage: ' + profileImage);
    }
    return {
      avater_url: copyFilePath_list
    }
  }

}

export function formatTime(timestamp: number, mode: number): string {
  // 创建一个Date对象
  const date = new Date(timestamp);

  // 获取年、月、日、小时、分钟、秒
  const year = date.getFullYear(); // 年份
  const month = date.getMonth() + 1; // 月份（注意：getMonth()返回的是0-11，表示1-12月）
  const day = date.getDate(); // 日
  const hours = date.getHours(); // 小时（24小时制）
  const minutes = date.getMinutes(); // 分钟
  const seconds = date.getSeconds(); // 秒

  // 输出完整的日期和时间
  if (mode == 0) {
    let fulltime: string =
      (`${year}年${month.toString().padStart(2, '0')}月${day.toString().padStart(2, '0')}日 ${hours.toString()
        .padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`)
    return fulltime
  } else if (mode == 1) {
    let fulltime: string = (`${year}年${month.toString().padStart(2, '0')}月${day.toString().padStart(2, '0')}日 `)
    return fulltime
  } else if (mode == 2) {
    let fulltime: string = (`${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`)
    return fulltime
  }
  throw new Error("Invalid condition");
}

export function image_show(url: string): PixelMap {
  let file = fs.openSync(url, fs.OpenMode.READ_ONLY);
  const imageSourceApi = image.createImageSource(file.fd)
  let profileImage = imageSourceApi.createPixelMapSync()
  fs.close(file)
  return profileImage
}

export function upload_local (url:string,context: Context | undefined):string{

  let uint8Array: Uint8Array = context!.resourceManager.getRawFileContentSync(url);
  let bf = buffer.from(uint8Array).buffer;
  const pic_Path_dir = context!.filesDir + '/img'
  const person_image = context!.filesDir + '/img/' + url
  hilog.fatal(1, 'uint8Array', '' + person_image)
  try {
    fs.mkdirSync(pic_Path_dir)
    const fsOpen = fs.openSync(person_image,
      fs.OpenMode.READ_WRITE | fs.OpenMode.READ_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    fs.writeSync(fsOpen.fd, bf);
    fs.close(fsOpen)
  } catch {
    const fsOpen = fs.openSync(person_image,
      fs.OpenMode.READ_WRITE | fs.OpenMode.READ_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    fs.writeSync(fsOpen.fd, bf);
    fs.close(fsOpen)
  }
  return person_image
}

export function sortPyqData(users: personal_data[]): personal_data[] {
  const sortedUsers = users.map(user => {
    const sortedPyqData = user.data.pyq_data.sort((a, b) => b.year - a.year);
    return {
      wx_number: user.wx_number,
      data: {
        avatar: user.data.avatar,
        nickname: user.data.nickname,
        district: user.data.district,
        pyq_first4_pic: user.data.pyq_first4_pic,
        pyq_data: sortedPyqData,
        bg: user.data.bg,
      }
    } as personal_data;
  });
  return sortedUsers;
}

export function sortPyqDataList(users: personal_data[]): personal_data[] {
  const sortedUsers: personal_data[] = users.map(user => {
    const sortedPyqData: personal_every_year_pyq_data[] = user.data.pyq_data.map(pyqData => {
      const sortedPyqDataList = pyqData.pyq_data_list.sort((a, b) => b.share_time - a.share_time);
      return {
        year: pyqData.year,
        pyq_data_list: sortedPyqDataList,
      } as personal_every_year_pyq_data;
    });
    return {
      wx_number: user.wx_number,
      data: {
        avatar: user.data.avatar,
        nickname: user.data.nickname,
        district: user.data.district,
        pyq_first4_pic: user.data.pyq_first4_pic,
        pyq_data: sortedPyqData,
        bg: user.data.bg,
      }
    } as personal_data;
  });
  return sortedUsers;
}

export  function logoutput(obj:object,name:string){
  let logIndex = 0
  for (let index = 0; index < JSON.stringify(obj).length / 1000; index++) {
    let str = JSON.stringify(obj).substring(logIndex, logIndex + 1000)
    hilog.fatal(1, `${name}:`, '%{public}s', str);
    logIndex = logIndex + 1000
  }
}
