# Events

- 原文链接：[https://docs.google.com/document/d/1WOVzoWp7hwsNwW1U7UfrtnahNojnC9gfKfrlM6KuBPw/edit?tab=t.0](https://docs.google.com/document/d/1WOVzoWp7hwsNwW1U7UfrtnahNojnC9gfKfrlM6KuBPw/edit?tab=t.0)
- 翻译辅助：Deepseek

事件对于告知代码**何时**以及**如何**运行至关重要。将函数挂接到事件后，每当该事件触发时，您的函数就会被调用。事件还会向您的函数传递参数。

事件的常见用法：

```lua
-- Damage newly created units by 30 if they were made by an AI player
function OnUnitAddedToMap(playerID, unitID)
	if Players[playerID]:IsAI() then
		local pUnit = UnitManager.GetUnit(playerID, unitID)
		pUnit:ChangeDamage(30)
	end
end
```

## 事件类型

主要分为三种类型的事件：

### 事件(Events)
- 由文明源代码发布，源自GameCore等DLL文件
- 具有完全跨上下文特性，可从Gameplay和UI上下文中访问、接收和调用

### Lua事件(LuaEvents)
- 可同时在Gameplay和UI上下文中访问
- 不具备跨上下文特性（需要通过`ExposedMembers`突破限制）
- 访问不存在的Lua事件时会自动创建新事件

### 游戏事件(GameEvents)
- 仅限Gameplay上下文使用
- 可通过`ExposedMembers`在UI上下文中访问
- 支持通过特定方法从UI上下文调用（减少同步问题风险）

## 特性说明
- **事件**和**Lua事件**具有`__call`元方法，支持像函数一样直接调用
- 使用`ExposedMembers`可能导致同步问题(desync)
- 推荐使用`UnitManager.RequestOperation`、`UnitManager.RequestCommand`或`UI.RequestPlayerOperation`进行跨上下文调用

举例：

```lua
Events.ExitToMainMenu()
LuaEvents.CityBannerButton_OnEnter(playerID, cityID)
```

---

## 事件函数列表

### 事件(Events)函数

| 函数名 | 参数 | 返回值说明 |
|--------|------|------------|
| Add | 函数 | 添加事件监听器 |
| Remove | 函数 | 移除事件监听器 |
| RemoveAll | - | 移除所有事件监听器 |
| Count | - | 返回本地状态下添加到事件的函数数量 |
| Dispatch | - | 分发事件 |
| Call | 参数(...) | 调用事件 |
| CallImmediate | 参数(...) | 立即调用事件 |

### 游戏事件(GameEvents)函数

| 函数名 | 参数 | 返回值说明 |
|--------|------|------------|
| Add | 函数 | 添加事件监听器 |
| Remove | 函数 | 移除事件监听器 |
| RemoveAll | - | 移除所有事件监听器 |
| Count | - | 返回本地状态下添加到事件的函数数量 |
| TestAny | - | 条件检测（任一） |
| TestAll | - | 条件检测（全部） |
| Call | 参数(...) | 调用事件 |
| Accumulate | - | 累积计算 |
| AccumulateINT | - | 整型累积计算 |

### Lua事件(LuaEvents)函数

| 函数名 | 参数 | 返回值说明 |
|--------|------|------------|
| Add | 函数 | 添加事件监听器 |
| Remove | 函数 | 移除事件监听器 |
| RemoveAll | - | 移除所有事件监听器 |
| Count | - | 返回本地状态下添加到事件的函数数量 |
| Call | 参数(...) | 调用事件 |

> **注意**：使用跨上下文通信时需特别注意同步问题，建议优先使用官方推荐的调用方式。

---

- 以下为译注

## 参考

事件函数原型及参数参考链接

- [https://docs.google.com/spreadsheets/d/1EiCTOlPx3IkeAmU0xujGEp9k0v9VuCxe95OcrsyWOVs/edit?gid=60650167#gid=60650167](https://docs.google.com/spreadsheets/d/1EiCTOlPx3IkeAmU0xujGEp9k0v9VuCxe95OcrsyWOVs/edit?gid=60650167#gid=60650167)

- [suktrict 的事件大全](https://sukritact.github.io/Civilization-VI-Modding-Knowledge-Base/)

