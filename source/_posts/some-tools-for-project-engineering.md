---
title: 一些项目工程化的小工具
date: 2022-06-26 18:58:46
tags: [工程化]
categories: 其他
---

## 一、Prettier：配合 git 进行代码格式化

Prettier是一个常用的代码格式化的工具，在个人开发当中一般会在代码编辑器（如：vscode）安装相应的插件，然后设置在保存时进行代码格式化。而在多人协作的项目当中，这里推荐在 git 提交代码的时候自动格式化。

[Prettier的官网](https://prettier.io/docs/en/install.html)有详细的介绍，在这里简单的实践一下。

以一个简单的 react 项目作为例子，首先创建一个初始项目

```bash
npx create-react-app test-prettier
```

然后添加依赖

```bash
yarn add --dev --exact prettier
```

添加配置文件

```bash
echo {}> .prettierrc.json
```

添加 ignore 文件，并添加初始的忽略文件

```bash
touch .prettierignore 
```

```
# Ignore artifacts:
build
coverage
```

然后我们把 App.js 的代码格式改得混乱一点

```jsx
import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div 
    className="App">
      <header className="App-header">
        <img src={ logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a  className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
          </header>
    </div>
  );
}

export default App;
```

执行

```bash
npx prettier --write .
```

可以发现代码已经成功格式化了，但是在多人协作的项目当中更好的做法是自动化去做，因此借助 git hook 来实现提交代码的时候自动格式化。

首先执行

```bash
npx mrm@2 lint-staged
```

安装之后发现，package.json 添加了一个 `lint-staged` 它会对 js、css、md 文件进行格式化，在 typeScript 或者 vue 等项目也可以添加相应的文件后缀名。然后需要在 git commit 之前进行格式化，我们还需要在 package.json 添加一个配置

```json
"lint-staged": {
  "*.{js,css,md}": "prettier --write"
},
"husky": {
  "hooks": {
    "pre-commit": "lint-staged"
  }
}
```

在 pre-commit 的时候执行格式化。现在我们再次将代码格式弄乱，之后执行 git commit 就发现代码自动格式化成功了。

如果需要和 eslint 一同工作的话还需要安装 eslint-config-prettier 插件，这样 prettier 就可以和 eslint 共同工作了。

## 二、commitlint：代码提交信息格式化

在多人协作的项目当中总有一些同事会在 commit message 中随便写写，或者大家使用不同的格式，会导致提交信息造成混乱，commitlint 就可以很好地解决这个问题。

它可以订立一个提交 commit message 的规范，当某为协作者提交的信息不符合这个规范就会导致提交失败。

还是用上文的项目做例子，首先安装依赖

```bash
yarn add @commitlint/{config-conventional,cli} -D
```

然后按照文档配置一下

```bash
echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
```

添加 hook

```bash
cat <<EEE > .husky/commit-msg
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

npx --no -- commitlint --edit "\${1}"
EEE
```

在 package.json 添加 husky 配置

```json
"husky": {
  "hooks": {
    "pre-commit": "lint-staged",
    "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
  }
}
```

现在随便写一个 commit message 提交，发现会报错，然后尝试一下符合格式的 commit message

```bash
git commit -m "fix:add config"
```

发现可以正常提交了。

