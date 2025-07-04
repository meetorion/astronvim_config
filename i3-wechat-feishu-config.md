# i3 微信飞书浮动模式配置

本文档记录了为微信、飞书等应用配置浮动模式和修复共享屏幕阴影问题的配置。

## i3 配置 (~/.config/i3/config)

在 i3 配置文件中添加以下规则：

```bash
# 微信和飞书默认浮动模式
for_window [class="wemeetapp"] floating enable
for_window [class="WeChat"] floating enable
for_window [class="wechat"] floating enable
for_window [class="WeChatWork"] floating enable
for_window [class="wechatwork"] floating enable
for_window [class="Feishu"] floating enable
for_window [class="feishu"] floating enable
for_window [class="Lark"] floating enable
for_window [class="lark"] floating enable
for_window [class="ByteDance-Lark"] floating enable
for_window [class="bytedance-lark"] floating enable

# 共享屏幕时的特殊处理（禁用阴影和透明度）
for_window [title=".*共享屏幕.*"] floating enable, border pixel 0
for_window [title=".*Screen Share.*"] floating enable, border pixel 0
for_window [title=".*屏幕共享.*"] floating enable, border pixel 0
for_window [title=".*分享屏幕.*"] floating enable, border pixel 0

# 窗口信息检测工具快捷键
bindsym $mod+Ctrl+i exec --no-startup-id ~/.config/i3/scripts/get-window-info.sh
```

## picom 配置 (~/.config/i3/picom.conf)

### 阴影排除规则

在 `shadow-exclude` 数组中添加：

```bash
shadow-exclude = [
    # ... 现有规则 ...
    
    # 微信和飞书相关窗口的阴影排除
    "class_g = 'WeChat'",
    "class_g = 'wechat'",
    "class_g = 'WeChatWork'",
    "class_g = 'wechatwork'",
    "class_g = 'Feishu'",
    "class_g = 'feishu'",
    "class_g = 'Lark'",
    "class_g = 'lark'",
    "class_g = 'ByteDance-Lark'",
    "class_g = 'bytedance-lark'",
    "class_g = 'wemeetapp'",
    
    # 共享屏幕时的阴影排除
    "name *= '共享屏幕'",
    "name *= 'Screen Share'",
    "name *= '屏幕共享'",
    "name *= '分享屏幕'",
    "name *= 'Share Screen'",
    "name *= 'screen share'",
    "name *= 'screenshare'",
    
    # 视频会议相关窗口
    "name *= 'Meeting'",
    "name *= 'meeting'",
    "name *= '会议'",
    "name *= 'Video Call'",
    "name *= 'video call'",
];
```

### 透明度规则

在 `opacity-rule` 数组中添加：

```bash
opacity-rule = [ 
    # ... 现有规则 ...
    
    # 微信和飞书保持完全不透明
    "100:class_g = 'WeChat'",
    "100:class_g = 'wechat'", 
    "100:class_g = 'WeChatWork'",
    "100:class_g = 'wechatwork'",
    "100:class_g = 'Feishu'",
    "100:class_g = 'feishu'",
    "100:class_g = 'Lark'",
    "100:class_g = 'lark'",
    "100:class_g = 'ByteDance-Lark'",
    "100:class_g = 'bytedance-lark'",
    "100:class_g = 'wemeetapp'",
    
    # 共享屏幕时保持完全不透明
    "100:name *= '共享屏幕'",
    "100:name *= 'Screen Share'",
    "100:name *= '屏幕共享'",
    "100:name *= '分享屏幕'",
    "100:name *= 'Share Screen'",
    "100:name *= 'screen share'",
    "100:name *= 'screenshare'",
    "100:name *= 'Meeting'",
    "100:name *= 'meeting'",
    "100:name *= '会议'",
    "100:name *= 'Video Call'",
    "100:name *= 'video call'"
]
```

## 窗口信息检测脚本

创建 `~/.config/i3/scripts/get-window-info.sh`：

```bash
#!/bin/bash

# 检测窗口信息的脚本
# 使用方法：运行脚本后点击要检测的窗口

echo "点击要检测的窗口..."
sleep 1

# 获取窗口ID
WINDOW_ID=$(xdotool selectwindow)

if [ -n "$WINDOW_ID" ]; then
    echo "=== 窗口信息 ==="
    echo "窗口ID: $WINDOW_ID"
    
    # 获取窗口类名
    CLASS=$(xprop -id $WINDOW_ID WM_CLASS | cut -d'"' -f2,4 | tr ',' ' ')
    echo "类名 (Class): $CLASS"
    
    # 获取窗口标题
    TITLE=$(xprop -id $WINDOW_ID WM_NAME | cut -d'"' -f2)
    echo "标题 (Title): $TITLE"
    
    # 获取窗口类型
    TYPE=$(xprop -id $WINDOW_ID _NET_WM_WINDOW_TYPE | cut -d'=' -f2)
    echo "类型 (Type): $TYPE"
    
    # 获取窗口状态
    STATE=$(xprop -id $WINDOW_ID _NET_WM_STATE | cut -d'=' -f2)
    echo "状态 (State): $STATE"
    
    echo ""
    echo "=== i3 配置参考 ==="
    echo "for_window [class=\"$CLASS\"] floating enable"
    echo "for_window [title=\"$TITLE\"] floating enable"
    
    echo ""
    echo "=== picom 配置参考 ==="
    echo "\"class_g = '$CLASS'\","
    echo "\"name = '$TITLE'\","
else
    echo "未选择窗口"
fi
```

记得给脚本执行权限：
```bash
chmod +x ~/.config/i3/scripts/get-window-info.sh
```

## 使用方法

1. **应用配置**：将上述配置添加到对应的配置文件中
2. **重启 i3**：按 `$mod+Shift+r` 重启 i3
3. **重启 picom**：`killall picom && picom --config ~/.config/i3/picom.conf &`
4. **检测窗口**：按 `$mod+Ctrl+i` 运行窗口检测脚本，点击要检测的窗口获取其类名和标题

## 功能说明

- **浮动模式**：微信、飞书等应用会自动以浮动窗口打开
- **阴影禁用**：视频会议和屏幕共享窗口不会有阴影遮罩
- **透明度控制**：确保这些应用保持完全不透明
- **调试工具**：可以快速检测任何窗口的属性以便添加新规则

这些配置解决了在 i3wm 中使用微信、飞书时的常见问题，特别是共享屏幕时的阴影遮罩问题。