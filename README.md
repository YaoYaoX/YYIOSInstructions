# YYIOSInstructions
ios日常积累,以后慢慢加

积累内容

### 1. 国际化

    步骤(文件名对应，别写错了)：
    1. 新建文件Localizable.strings(新建 -> ios -> Resource -> Strings file)
    2. 选择Project -> info -> Localizations -> add -> 勾选Localizable.strings文件，完成，添加所需语言
    3. 在对应语中文件下，填写相关健值对文件: "key" = "string(对应语种)";
    4. 使用string方式：NSLocalizedString(key, nil);
    5. "应用名"的国际化请查看文件InfoPlist.strings(其他文件中设置无效)


### 2. Tabbar＋Navigation结构


### 3. 自定义可点击、滑动的tab
![tabDemo](https://github.com/YaoYaoX/YYIOSInstructions/blob/master/Picture/scrollableTabView.gif)


### 4. ActionSheet(类似微博的ActionSheet)
<img src="https://github.com/YaoYaoX/YYIOSInstructions/blob/master/Picture/actionsheet.png" width = "300" alt="ActionSheet" align="center" />

### 5. Polygon:可以转动的多边形

    1. numberOfSides：多边形的边数
    2. rotateNum：每次旋转时转动的角个数
<br />
<img src="https://github.com/YaoYaoX/YYIOSInstructions/blob/master/Picture/polygon.png" width="300" alt="Polygon" align="center" />

### 6. 传感器的使用

涉及的内容有以下几部分，详细的说明请看:[IOS ＋ 传感器的使用(加速计、陀螺仪、计步器等)](http://www.jianshu.com/p/37a65f683bb9)
   
    1. 光线强弱检
    2. 距离传感器
    3. 计步器
    4. 加速计
    5. 陀螺仪
    6. 磁力计
<br />
