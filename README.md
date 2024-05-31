# AstroNvim User Configuration Example

A user configuration template for [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

#### Clone AstroNvim

```shell
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository
- https
```shell
git clone https://github.com/meetorion/astronvim_config ~/.config/nvim/lua/user
```

- ssh
```shell
git clone git@github.com:meetorion/astronvim_config.git ~/.config/nvim/lua/user
```

#### Start Neovim

```shell
nvim
```
### 自定义需求
## AI插件
目前支持gp.nvim、neoai.nvim、CodeGPT等。

## buffer管理
默认支持，使用<leader>+f+b
