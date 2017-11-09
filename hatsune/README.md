## 开始

以下步骤将会帮助你安装和运行本工程。

### 安装 Homebrew

_如果已经安装了 Homebrew，则可以跳过。_

推荐使用 [Homebrew](http://brew.sh/) 来管理工具包。

打开终端：

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### 安装 React Native 环境

_如果已经安装了 React Native，则可以跳过_。

_已经安装了 Homebrew之后才可进行一下操作。_

使用 Homebrew 安装 Node 和 Watchman 和 React Native CLI，打开终端：

```sh
brew install node
brew install watchman
npm install -g react-native-cli
```

### 安装本工程的依赖

```sh
cd hatsune
npm install
```

由于本工程一些未知问题，之后跑 iOS 模拟器的时候有个依赖 react-native-fs 会有报错，解决方法是继续再跑一条命令，重新单独安装一遍。

```sh
npm install react-native-fs@2.0.1-rc.2 --save
```

接下来可以到 iOS 目录下进行 iOS 项目的开发，Android 目录下进行 Android 项目开发

### Android环境集成

#### buildscript版本

如若出现：

```sh
Error:Unsupported method: BaseConfig.getApplicationIdSuffix().
The version of Gradle you connect to does not support that method.
To resolve the problem you can change/upgrade the target version of Gradle you connect to.
Alternatively, you can ignore this exception and read other information from the model.
```
的错误提示，修改`hathune/build.gradle`，将`buildscript`的`dependencies`修改为：

```groovy
classpath 'com.android.tools.build:gradle:2.2.3'
```
同时修改`hathune/gradle/wrapper/gradle-wrapper.properties`文件：

```groovy
distributionUrl=https\://services.gradle.org/distributions/gradle-2.14.1-all.zip
```

#### react-native duplicate 依赖

如若出现：

```sh
Duplicate module name: xxxxx
```

之类的错误，可能是依赖安装的有问题，可使用`npm3`重新安装依赖，如：

```sh
npm install -g npm3

npm3 install
```

#### build 空指针
需要手动修改`PushSDK`工程里的`build.gradle`，将`compileSdkVersion 19`修改为：

```groovy
compileSdkVersion 22
```
或

```groovy
compileSdkVersion 23
```

### ignore lint

`lint`代码检查会导致第三方依赖库无法通过编译，统一忽略掉的方法：

```sh
./gradlew build -x lint
```

### exclude LICENSE

在`app/build.gradle`里添加

```groovy
android {
	packagingOptions {
	        exclude 'META-INF/DEPENDENCIES.txt'
	        exclude 'META-INF/LICENSE.txt'
	        exclude 'META-INF/NOTICE.txt'
	        exclude 'META-INF/NOTICE'
	        exclude 'META-INF/LICENSE'
	        exclude 'META-INF/DEPENDENCIES'
	        exclude 'META-INF/notice.txt'
	        exclude 'META-INF/license.txt'
	        exclude 'META-INF/dependencies.txt'
	        exclude 'META-INF/LGPL2.1'
    }
}
```