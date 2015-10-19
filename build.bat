@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:clean
echo =======清除hexo生成的缓存文件========
start "hexo clean && exit"

:deploy
echo =======创建静态文件并部署到服务器========
start "hexo deploy && exit"

:push
echo =======提交代码到github=========
git add --all
git commit -m "%1 || update"
git push
pause