#gameNetwork
****


##overview
ランキングやアカウント機能を簡単に利用するためのサービス。
iOSは**Game Center**, Androidは**Google Game Play Service**を利用。
使い方詳細は[CoronaSDK Docks -game Network-](https://docs.coronalabs.com/plugin/gameNetwork-google/index.html)を参照

## 目次
**Android設定方法**

1. [Androidの設置](#how-to-android)
1. [build.setting](#build_setting)
1. [イベントについて](#event)
1. [sample code](#sample_code)
1. [機能一覧](#method)

**iOS設定方法**

1. [iOSの設置](#how-to-ios)
1. [build.setting](#build_setting-ios)
1. [イベントについて](#event)
1. [sample code](#sample_code)

-------

#<a name="how-to-android"></a>使用方法(Google Game Play Service)
1. Google PlayよりGame Play Game Serviceに登録する。[ここを参考](http://qiita.com/t2low/items/b447f6ed913fabd83b61)。ここではGoogle Play Store部分のみを作成（xml等は除く）
2. build.settingの変更。下記に記載しているコードを追加.
3. イベントの作成。下記にイベント作成については記載している
4. ランキングの形式を設定

### <a name="build_setting"></a>build.settingについて
```
settings =
{
    plugins =
    {
        ["CoronaProvider.gameNetwork.google"] =
        {
            publisherId = "com.coronalabs",
            supportedPlatforms = { android=true },
        },
    },
}
```

Google Playのアプリ名の下の数字を設定
![google play game app id](https://dl.pushbulletusercontent.com/RnJcr159yJcXmBctBj7xV93UpmBiKJSE/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202015-06-29%2014.45.44.png)

```
settings =
{
    android =
    {
        googlePlayGamesAppId = "123456789012",
    },
}
```

### <a name="event"></a>イベント作成



### <a name="method"></a>機能一覧

#####ランキング取得
```
gameNetwork.request("loadScore", {})
```

#####ログイン
```
gameNetwork.request( "login",{
    userInitiated = true,
    listener = requestCallback
})
```

-------
# 使用方法(Game Centerの場合)

1. build.settingの変更。下記に記載しているコードを追加.
1. ランキングの形式を設定

### <a name="build_setting"></a>build.settingについて
```
settings =
{
    plugins =
    {
        ["CoronaProvider.gameNetwork.apple"] =
        {
            publisherId = "com.coronalabs",
            supportedPlatforms = { iphone=true, ["iphone-sim"]=true },
        },
    },
}
```
