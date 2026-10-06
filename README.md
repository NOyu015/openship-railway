# Openship on Railway

把开源自托管部署平台 [Openship](https://github.com/oblien/openship)（fork：HCTDIP/openship）跑在 Railway 上，手机浏览器打开 UI 就能一键构建发布，不用敲终端。

## Railway 部署

1. Railway 里进 Project → New → GitHub Repo，选本仓库。
2. Variables 里填 1 个环境变量：
   - `ADMIN_PASSWORD`：dashboard 管理员登录密码（自己定个随机的，登录邮箱是 `fei@local`）
3. Volumes 里加一个 Volume，挂载到 `/data`（存数据库和配置，重启不丢）。
4. Settings → Networking → Generate Domain，拿到公网地址。
5. 手机打开地址 → 用 `fei@local` + 你设的密码登录。

## 说明

- 跑的是 bare 模式（单进程+内置数据库，不用 Docker），适合先把控制面跑起来。
- 首次启动会自动从 GitHub release 下载 dashboard（约 36MB），多等一两分钟。
- 不用的时候在 Railway 里把 Service 暂停（Stop），一分钱不烧。
