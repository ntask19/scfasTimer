analytics
====

##overview  
解析ツールについて
詳細は[CoronaSDK Docs -analytics-](https://docs.coronalabs.com/api/library/analytics/index.html)より

##使用方法
1. [Flurry](https://dev.flurry.com/home.do)よりアプリを登録（iOS, Android両方）.
2. Flurryの画面上部の**「Application」**よりアプリを登録する
3. API Keyを取得する
4. CoroanSDKの`main.lua`ファイルの解析ツールのコメントアウトを消す
5. `analytics/analytics.lua`に**app_key**に取得したAPI Keyを入れる
6. `build.setting`に下記のコードを入れる
7. 取得するイベントに**logEvent**を入れる

### build.settingについて
```
settings =
{
    android =
    {
        usesPermissions =
        {
            "android.permission.INTERNET",
            -- The following permissions are optional.
            -- If set, Flurry will also record current location via GPS and/or WiFi.
            -- If not set, Flurry can only record which country the app was used in.
            "android.permission.ACCESS_FINE_LOCATION",    --fetches location via GPS
            "android.permission.ACCESS_COARSE_LOCATION",  --fetches location via WiFi or cellular service
        },
        usesFeatures =
        {
            -- If you set permissions "ACCESS_FINE_LOCATION" and "ACCESS_COARSE_LOCATION" above,
            -- you should set the app to NOT require location services:
            { name="android.hardware.location", required=false },
            { name="android.hardware.location.gps", required=false },
            { name="android.hardware.location.network", required=false },
        },
    },
}
```
```
settings =
{
    plugins =
    {
        ["CoronaProvider.analytics.flurry"] =
        {
            publisherId = "com.coronalabs"
        },
        ["plugin.google.play.services"] =
        {
            publisherId = "com.coronalabs"
        },
    },
}
```

## sample code
```
local analytics = require( "analytics" )

-- initialize with proper API key corresponding to your application
analytics.init( "API_KEY" )

-- log events
analytics.logEvent( "Event" )
```