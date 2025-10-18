# 模组整合脚本

## 目标

自动化创建一个将多个模组整合到一起的整合包模组，具体可参考我在[纪元回响](https://github.com/Z-Vanadium/Civ6EchoesOfEpochs)中的用法

## 使用方法

### 配置

将所有你要整合的 mod 和 `modinfo_combiner.py` 放在同一目录下

这一步完成后，你的目录应该类似于：

```
Mod1/
Mod2/
Mod3/
modinfo_combiner.py
requirements.txt
```

### 信息修改

修改 `modinfo_combiner.py`，将作者信息、mod 名称等修改为你的 mod 的信息

### 运行脚本

```bash
pip install -r requirements.txt
python modinfo_combiner.py
```

运行后会多出一个 `*.modinfo` 文件，这就是整合后 mod 的模组信息文件