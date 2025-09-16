# HAVOKSCRIPT

- 原文链接：[https://docs.google.com/document/d/1rYKgr_-Do2qzt22nv91rBUCx3JpKtuh5fjG5w9COaMs/edit?tab=t.0](https://docs.google.com/document/d/1rYKgr_-Do2qzt22nv91rBUCx3JpKtuh5fjG5w9COaMs/edit?tab=t.0)
- 翻译辅助：Deepseek

HavokScript 是 Lua 5.1 的超集，也是《文明 VI》的主要脚本语言；其声称的优势在于更快的性能和类型安全。

HavokScript 对 Lua 进行了以下扩展：

*   静态类型变量 (Statically typed variables)
*   结构体 (Structs)
    -   关键字：*hstructure*
    -   关键字：*hmake*

HavokScript 的特性完全是可选的，大多数模组制作者完全忽略它们，但 Firaxis 经常使用它们。了解这些特性，即使你选择不使用它们，也可能有助于你理解《文明》的 Lua 环境。

## 什么是静态类型变量？

静态类型变量是指在编译时确定类型的变量。与动态类型变量不同，静态类型变量不能被赋予另一种类型的值。

### 为什么使用静态类型变量？

静态类型变量主要用于调试和代码组织，但也会带来轻微的性能提升。任何尝试将静态类型变量设置为另一种类型值的操作都会被解释器视为语法错误并立即识别。

### 为什么不使用静态类型变量？

它们不是标准的 Lua 语法，因此你的 IDE 会将它们检测为语法错误，这破坏了它们代码组织的目的，并且会严重干扰 Intellisense（智能感知）。

- 这可以通过使用我的 VScode 扩展 [Civilization VI Environment Emulation](https://marketplace.visualstudio.com/items?itemName=WildW.vscode-civvi-environment) 来克服。

**代码示例：**
```lua
local x: number = 30
local y: string = "I am a string"

x = y
```

-->Syntax Error: [string "local x: number = 30 local y: string = "I am a string" x = y"]:4: Attempting to set local variable of type 'number' to type 'string' 

## 什么是结构体？

简而言之，结构体是表的严格模板，它们强制你遵守字段和数据类型的结构。

### 为什么使用结构体？

结构体在你需要管理特别大的脚本或代码库时非常有用，这些情况下结构一致的表经常被传递，并且需要考虑性能。

### 为什么不使用结构体？

结构体带来的性能提升是以牺牲 Lua 表的动态特性为代价的，坦率地说，大多数模组并不需要它们。在不必要的地方使用结构体只会使你的代码复杂化，并且它们独特的语法在你的 IDE 中会被高亮显示为错误。

- 这可以通过使用我的 VScode 扩展 [Civilization VI Environment Emulation](https://marketplace.visualstudio.com/items?itemName=WildW.vscode-civvi-environment) 来克服。

**代码示例：**

```lua
hstructure AdvisorItem
	Message: string;--TXT key to look up for advisor message
	MessageAudio: string;--Name of audio to play with message
	Image: string;--(optional) Name of texture used in image
	OptionsNum: number;--Number of options
	Button1Text: string;--TXT key to look up for button 1
	Button2Text: string;--TXT key to look up for button 2
	Button1Func: ifunction;--Callback on button 1
	Button2Func: ifunction;--Callback on button 2
	CalloutHeader: string;--TXT key to look up for callout header
	CalloutBody: string;--TXT key to look up for callout body
	PlotCallback: ifunction;--Returns plotID of dialog’s plot
	ShowPortrait: boolean;--Will advisor portrait appear in dialog?
	UITriggers: table;--IDs/Trigger names when advisor item is up
end
```

这个可以在 `AdvisorPopup.lua` 中找到的结构体定义了用于创建顾问弹出消息的数据结构。在整个文件中，定义了用于处理此类结构体的函数，例如这个：

```lua
function ShowOrQueuePopup(advisorData: AdvisorItem)
	--Code here
end
```

这个函数期望一个 `AdvisorItem`，它可以像这样创建：

```lua
local exampleAdvisorItem = hmake AdvisorItem {
	Message = "message text not set",
	MessageAudio = nil,
	OptionsNum = 0,
	Button1Text = "button1 text not set",
	Button2Text = nil,
	Button1Func = nil,
	Button2Func = nil,
	CalloutHeader = "header text not set",
	CalloutBody = "body text not set",
	PlotCallback = nil,
	ShowPortrait = false,
	UITriggers = {} 
};
```

或者，你也可以省略你打算初始化为 nil 的条目：

```lua
local exampleAdvisorItem = hmake AdvisorItem {
	Message = "message text not set",
	OptionsNum = 0,
	Button1Text = "button1 text not set",
	CalloutHeader = "header text not set",
	CalloutBody = "body text not set",
	ShowPortrait = false,
	UITriggers = {} 
};

--But you can still set them later
exampleAdvisorItem.Button2Text = "Hello World!"
```

最有趣的是，hstructure 会在整个应用程序的生命周期内保持定义，并且可以从任何上下文（甚至是 front-end 和 in-game 内）访问。

---

- 以下为译注

在 Havokscript 中，对于对象的成员获取有 2 种方式

```lua
-- 点号用来访问成员变量，与键值对相同
Object.memberVariable
Object['memberVariable']

-- 冒号用来调用成员方法
Object:memberMethod(...)
```

## 参考

Firaxis的游戏引擎对象Object（如玩家Player、单位Unit、城市City等）大多以表的形式暴露给Lua，并且为其功能提供了大量以方法形式存在的API，可参考

- [https://docs.google.com/spreadsheets/d/1EiCTOlPx3IkeAmU0xujGEp9k0v9VuCxe95OcrsyWOVs/edit?gid=1494828281#gid=1494828281](https://docs.google.com/spreadsheets/d/1EiCTOlPx3IkeAmU0xujGEp9k0v9VuCxe95OcrsyWOVs/edit?gid=1494828281#gid=1494828281)