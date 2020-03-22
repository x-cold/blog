
---

title: Git 实用指南

urlname: lfmcil

date: 2019-03-28 00:00:00 +0800

tags: [git]

categories: []

---


个人整理的一些常用的 Git 概念和命令集合，方便速查和快速解决某些场景下的问题，覆盖了日常开发和协同工作下的一部分场景，不只是命令行的介绍。欢迎关注[语雀原文](https://www.yuque.com/yinzhi/blog/lfmcil)，持续更新！

<a name="0b133c66"></a>
## 精简入门

1、克隆仓库

克隆仓库会下载仓库完整的文件、分支和历史记录。

```bash
git clone [<options>] [--] <repo> [<dir>]
```

<!-- more -->

```bash
# 克隆完整的仓库到 ./git-learning 目录下
git clone git@github.com:x-cold/git-learning.git
# 只克隆 dev 分支到 ./dev 目录下
git clone -b dev git@github.com:x-cold/git-learning.git dev
```

2、将文件变更记录写入到本地的索引库

```bash
git add [<options>] [--] <pathspec>...
```

```bash
# 添加当前目录下所有文件
git add .
# 添加部分文件
git add src/ app/ index.js
```

3、提交变更到工作区

```bash
git commit [<options>] [--] <pathspec>...
```

```bash
# 最普通的提交
git commit -m "feat: support canvas"
# 修改当前的 commit message
git commit --amend
# 重置当前的 commit author 和 message
git commit --amend --reset-author 
```

4、推送代码到远程仓库

```bash
git push [<options>] [<repository> [<refspec>...]]
```

```bash
# 提交本地仓库当前分支到远程仓库的 master 分支
git push origin master
# 提交本地仓库 dev 分支到远程的 master 分支
git push origin master:dev
```

<a name="af75a264"></a>
## 聊聊设计

![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1553735304999-5c646d62-6d36-45d9-9ae1-ffdf4b5d6e67.png#align=left&display=inline&height=837&name=image.png&originHeight=837&originWidth=1024&size=67634&status=done&width=1024)<br />图像来自维基百科

Git 是一个分布式的版本控制工具，因此远程和本地可以视为两个独立的 Git 仓库。上图是一张经典的 Git 中的数据流与存储级别的介绍，其中储存级别主要包含几部分：

- 工作区 (Working Files)，指的是我们时刻在编辑的文件的目录，通常来说我们修改文件都是在工作区体现的
- 暂存区（Stage），暂存将本地的修改，然后提交到本地仓库
- 本地仓库（Local）
- 远程仓库（Remote）

由此不难看出整体的数据流动，就是一条从：工作区 -> 暂存区 -> 本地仓库 -> 远程仓库 的双向数据流通道。

<a name="0dfbe902"></a>
## 常用命令
<a name="04900ddb"></a>
### git init

创建一个空白的 git 仓库

```bash
git init
```

<a name="73e58b95"></a>
### git add

```bash
git add [<options>] [--] <pathspec>...
```

<a name="5f9e613a"></a>
### git commit

```bash
git commit [<options>] [--] <pathspec>...
```

<a name="da5508cb"></a>
### git remote

remote 指的是本地的 git 仓库关联的远程 git 仓库。

1、查看远程仓库信息

```bash
git remote
```

2、看远程仓库详细信息

```bash
git remote -v
```

3、删除远程仓库

```bash
git remote remove <name>
```

```bash
# 移除名字为 origin 的远程仓库
git remote remove origin
```

4、添加远程仓库

```bash
git remote add [-t <branch>] [-m <master>] [-f] [--tags | --no-tags] [--mirror=<fetch|push>] <name> <url>
```

```bash
git remote origin git@github.com:x-cold/git-learning.git
```

<a name="57bbe662"></a>
### git branch

1、列出本地存在的分支

```bash
git branch
```

2、列出远程分支

```bash
git branch -r
```

3、列出本地和远程分支

```bash
git branch -a
```

4、创建本地分支

```bash
git branch [branchName]  (remoteBranch)
```

```bash
# 基于远程仓库的 dev 分支，创建本地仓库的 feature/canvas 分支
git branch feature/canvas dev
```

5、分支重命名

```bash
git branch [<options>] (-m | -M) [<old-branch>] <new-branch>
```

```bash
# 修改 feature/canvas 分支名为 feature/canvas2
git branch -M feature/canvas feature/canvas2
```

6、删除本地分支

```bash
git branch -d | -D [branchName]
```

7、删除远程分支

```bash
git branch [<options>] [-r] (-d | -D) <branch-name>.
```

```bash
# 删除 feature/canvas2 分支
git branch -d feature/canvas2
```

8、设置默认上游及分支

```bash
git branch --set-upstream <localBranch> <remote>/<remoteBranch>
```

```bash
# 以后只需要在 dev 分支执行 git push (无需额外的参数) 就可以提交到 origin/dev
git branch --set-upstream dev origin/dev
```

<a name="386668d1"></a>
### git checkout

检出分支:

```bash
git checkout [<options>] <branch>
```

```bash
# 切换当前分支到 dev 分支
git checkout dev
# 基于当前分支创建 test 分支，并且将当前分支切换到 test 分支
git checkout -b test
```

除开用于分支切换，checkout 还可以用于恢复**未添加到本地工作区，但是被修改过的文件。**<br />**
```bash
# 将 index.js 恢复到当前 commit 的内容
git checkout index.js
```

<a name="89b6da3d"></a>
### git merge

合并分支:

```bash
git merge [<options>] [<commit>...]
```

```bash
# 合并远程仓库的 master 分支到当前分支
git merge origin/master
```

<a name="5c874c8c"></a>
### git rebase

变基，是一种常用且有风险的操作，会改变提交历史，谨慎使用！

```bash
git rebase 
while(存在冲突) {
    git status
    找到当前冲突文件，编辑解决冲突
    git add -u
    git rebase --continue
    if( git rebase --abort )
        break; 
}
```

<a name="b8180c6e"></a>
### git cherry-pick

魔法级的命令，cherry-pick 可以提取 N 个的提交记录，合入稳定版本的分支上。

```bash
git cherry-pick [<options>] <commit-ish>...
```

```bash
# 挑选 371c2 单个提交记录，合入当前分支
git cherry-pick 371c2
# 挑选出 371c2 到 971209 的所有提交记录，并合入当前分支
git cherry-pick 371c2…971209
```

<a name="0380e71d"></a>
### git push

推送到远程仓库，同步本地仓库的提交历史到远程仓库

```bash
git push [<options>] [<repository> [<refspec>...]]
```

```bash
# 提交本地仓库当前分支到远程仓库的 master 分支
git push origin master
# 提交本地仓库 dev 分支到远程的 master 分支
git push origin master:dev
# 提交单个 tag
git push origin publish/1.0.0
# 提交所有 tag
git push origin --tags
```

<a name="6f808f5a"></a>
### git pull

拉取远程分支，同步远程仓库的提交历史到本地仓库

```bash
git pull [<options>] [<repository> [<refspec>...]]
```

```bash
# 通常来说，默认的 pull 行为等同于 git fetch + git merge
# 下面这行命令等同于 git fetch origin master && git merge origin/master
git pull origin master

# 也可以通过变基的方式来拉取代码，这样分支模型不容易受到影响
# 下面这行命令等同于 git fetch origin master && git rebase origin/master
git pull --rebase origin master
```

<a name="2968dbdd"></a>
### git tag

1、创建 tag

```bash
git tag -a v1.1.0 -m ""
```

2、查看 tag

```bash
git tag
```

3、推送到远程

```bash
git push origin --tags
```

4、删除本地 tag

```bash
git tag -d v1.0.0
```

5、删除远程 tag

```bash
git push origin :refs/tags/v1.0.0
```

<a name="d1595401"></a>
## .git 仓库元数据

每一个 git 的代码仓库目录下，都会有一个 `.git` 的文件夹，其中包含的重要文件包含以下：

| 文件/文件夹 | 含义 |  |
| --- | --- | --- |
| config* | 配置文件 |  |
| description | 描述，仅供 Git Web 程序使用 |  |
| HEAD | 当前被检出的分支 |  |
| index | 暂存区信息 |  |
| hooks/ | 客户端或服务端的钩子脚本（hook scripts） |  |
| info/ | 全局性排除（global exclude）文件，不希望被记录在 .gitignore 文件中的忽略模式（ignored patterns） |  |
| objects/ | 所有数据内容 |  |
| refs/ | 数据（分支）的提交对象的指针 |  |
|  |  |  |


<a name="7c99e281"></a>
## 进阶技巧

<a name="d653f1cb"></a>
### 修改 commit 历史

使用 git rebase 进行历史修改，假定修改最近 3 条历史，操作步骤如下：

1、`git rebase -i HEAD~3`

运行此命令会提供一个提交列表，如下所示，其中 commit 记录是时间逆序排列的；

```
pick f7f3f6d changed my name a bit
pick 310154e updated README formatting and added blame
pick a5f4a0d added cat-file

# Rebase 710f0f8..a5f4a0d onto 710f0f8
#
# Commands:
#  p, pick = use commit
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#
# If you remove a line here THAT COMMIT WILL BE LOST.
# However, if you remove everything, the rebase will be aborted.
#
```

2、编辑上述列表文件，在需要更改的 commit 前，将 `pick` 修改为 `edit` ，如果需要压缩，可设置为 `squash` 保存退出，进入到 rebase 流程；

3、通过 `git commit --amend --author` 对历史记录依次修改和持续进行 rebase；

<a name="b65fd098"></a>
### 添加指定文件

```bash
git ls-files src/ | grep '\.css$' | xargs git add
```

<a name="160944bd"></a>
### 删除所有 commit 中的某些文件

```bash
# 删除文件
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch -r build' --prune-empty --tag-name-filter cat -- --all

# 触发 GC
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

<a name="5317a015"></a>
### git stash

使用 stash 可以将当工作区更改的临时存放起来，等一番 git 操作（比如 merge / rebase 等）之后，再将这部分更改重新放回工作区。

```bash
# 临时存放，临时存放区是一个栈的结构，支持多次临时存放，遵循后入先出的原则
git stash
# 重新放回到工作区
git stash pop
```

<a name="2e307a62"></a>
## 附录

- [githug](https://github.com/Gazler/githug), 一个专门为 git 学习路径设计的游戏

- [awesome-git-addons](https://github.com/stevemao/awesome-git-addons), git 命令行工具扩展的合集

- [git-tips](https://github.com/git-tips/tips), 常用使用场景和技巧集合

- [lazygit](https://github.com/jesseduffield/lazygit), 懒人专用的 git 命令行程序


<a name="d64d6855"></a>
## 其他用途

<a name="2d3ad16e"></a>
### issue 评论

- [gitment](https://github.com/imsun/gitment), github issue 社会化评论插件

- [gittalk](https://github.com/gitalk/gitalk), github issue 社会化评论插件，感觉稍微好看一点点





