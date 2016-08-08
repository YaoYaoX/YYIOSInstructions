# YYIOSInstructions
日常积累,以后慢慢加

积累内容

### 1. 国际化

    步骤(文件名对应，别写错了)：
    1. 新建文件Localizable.strings(新建 -> ios -> Resource -> Strings file)
    2. 选择Project -> info -> Localizations -> add -> 勾选Localizable.strings文件，完成，添加所需语言
    3. 在对应语中文件下，填写相关健值对文件: "key" = "string(对应语种)";
    4. 使用string方式：NSLocalizedString(key, nil);
    5. "应用名"的国际化请查看文件InfoPlist.strings(其他文件中设置无效)


### 2. Tabbar＋Navigation结构

