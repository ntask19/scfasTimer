share.lua
======

##設定

**build.setting**  

```
settings =
{
    plugins =
    {
        ["CoronaProvider.native.popup.social"] =
        {
            publisherId = "com.coronalabs"
        },
    },
}
```

##使い方
```
share = require(PluginDir .. "share.share")
share.default_message = 'こんにちは'

local option = {
	service='twitter'
	message='こんばんは', 
	image={filename='Icon.png',baseDir=system.ResourceDirectory}
	url = 'http://test.com'	
}
share.post(option)
```

* service

> シェアする先（share, twitter, facebook, sinaWeibo, tencentWeibo）
 
* url

> シェアするURL

* image

> シェアする画像(filename : 画像名, baseDir : ディレクトリ)

* message

> シェアする文章