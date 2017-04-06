---
title: Vuex 入门 —— 干货集中营应用
date: 2017-03-28 16:09:20
tags: [vue,vuex]
categories: 学习笔记
description: vuex 入门 —— 干货集中营应用
---

[Vuex](https://vuex.vuejs.org) 是一个前端状态管理库，是专门为 [Vue.js] 设计。可以以常常与 React 搭配的另一个前端状态管理库 [Redux](http://redux.js.org/) 类比，但 Redux 不但可以搭配 React 玩可以与其他库搭配使用。

现在就使用 Vuex 开发一个简单的应用，借此说明 Vuex 相关的概念。

<!-- more -->
## Vuex 的基本概念

在开发复杂的前端应用的时候，当用户作出一个操作的时候，页面当中经常会有多个组件因为这个操作作出不同的响应，从而改变状态。而状态管理库就是便于我们去管理这种复杂的对操作的响应，从而使组件之间的信息传递变得简单而可维护。

![vuex](https://vuex.vuejs.org/zh-cn/images/vuex.png)

## 应用预览

![预览](http://acwongblog.qiniudn.com/2017-03_gank-vivew.png)

这个应用包括两个部分，如上图，左方列表是通过[干货集中营](http://gank.io/api)的 api 获取的文章列表。

点击标号 **1** 可以将文章放入右方的阅读列表。

切换标号 **2** 的控件可以选择获取的文章类型。

切换标号 **3** 的控件可以过滤阅读列表的文章类型。

点击标号 **4** 移除阅读列表中的文章。

源代码可以在这里[下载](https://github.com/acwong00/blog-demo-code/tree/master/vuex-gank)。

## 建立 store

Vuex 使用一个单一的 store 来管理前端状态 state，当 store 发生变化时，相应的组件也会同时发生变化。

首先来看 store 的入口文件

**src/store/index.js**

```javascript
import Vue from 'vue'
import Vuex from 'vuex'
import createLogger from 'vuex/dist/logger'
import { ADD_TO_READING_LIST } from './mutation-types'
import gankList from './modules/gank-list'
import readingList from './modules/reading-list'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    categories: ['Android', 'iOS', '前端']
  },

  modules: {
    gankList,
    readingList
  },

  actions: {
    addToReadingList({ commit }, id) {
      commit(ADD_TO_READING_LIST, { id })
    }
  },

  mutations: {
    [ADD_TO_READING_LIST](state, { id }) {
      state.readingList.readingList
        .push(state.gankList.ganks.find(gank => gank._id === id))
    }
  },

  plugins: [createLogger()]
})
```

- mutation-types.js 包含提交 mutation 时使用的常量。
- `Vue.use(Vuex)` 要 Vue 与 Vuex 互相连接，要使用 `use` 的方法。
- `modules` Vuex 允许将 store 分成多个不同的模块，便于管理一个大的 store 对象，这里的两个模块分别就对应应用左右两个部分。module 可以有各自的 actions，getters，mutations
- 涉及到多个模块 state 的操作都应该定义在这里，如这里的 mutations，actions
- `createLogger` 插件用于调试，可以在控制台输出变化前后的 state

> note: 将左方列表的文章加入到右方列表会同时使用两个模块的 state，必须在这里定义相应的 mutation，因为在某一模块定义的 mutaion 只能访问改模块的 state

接下来是两个模块

**src/store/modules/gank-list.js**

```js
import { getGanks } from '../api'
import { REQUEST_GANKS, RECEIVE_GANKS, CHANGE_CATEGORY } from '../mutation-types'

const state = {
  isFetching: false,
  ganks: []
}

const actions = {
  getGanks({ commit }, category) {
    commit(REQUEST_GANKS)
    getGanks(category)
      .then(response => response.data.results)
      .then(ganks => commit(RECEIVE_GANKS, { ganks }))
  }
}

const mutations = {
  [REQUEST_GANKS] (state) {
    state.isFetching = true
  },

  [RECEIVE_GANKS] (state, { ganks }) {
    state.isFetching = false
    state.ganks = ganks
  }
}

export default {
  state,
  actions,
  mutations
}
```

- action 与 mutation 不同，mutation 必须是同步函数，而 action 则可以包含异步操作。
- mutation 应该由 action 去提交，这样结构会比较清晰。

**src/store/modules/reading-list.js**

```js
import { DELETE_FROM_READING_LIST } from '../mutation-types'

const state = {
  readingList: []
}

const getters = {
  ids(state) {
    return state.readingList.map(item => item._id)
  }
}

const actions = {
  deleteItem ({ commit }, id) {
    commit(DELETE_FROM_READING_LIST, { id })
  }
}

const mutations = {
  [DELETE_FROM_READING_LIST] (state, { id }) {
    state.readingList = state.readingList.filter(item => item._id !== id)
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
```

- 有时候需要在 state 当中派生出一些状态，这个时候就可以使用 `getters`

## 编写组件

**src/components/App.vue**

```html
<template>

<div id="app">
  <h1>Gank reading App</h1>
  <div class="container">
    <gank-list></gank-list>
    <reading-list></reading-list>
  </div>
</div>
</template>

<script>

import GankList from './GankList.vue'
import ReadingList from './ReadingList.vue'

export default {
  components: {
    GankList,
    ReadingList
  }
}

</script>

<style>

ul {
  padding: 0;
  margin: 0;
  list-style: none;
}
.container {
  display: flex;
  justify-content: space-between;
}

</style>
```

App 组件文件包含 `gank-list` 和 `reading-list` 两个组件。

**src/components/GankList.vue**

```html
<template>
<div class="gank-list">
  <h2>分类 {{ selected }}</h2>
  <select v-model="selected" @change="changeCategory(selected)">
    <option v-for="category in categories">
      {{ category }}
    </option>
  </select>
  <div v-if="isFetching">
    获取中...
  </div>
  <ul v-else>
    <li v-for="gank in ganks">
      <a href="javascript:void(0);" @click="add(gank._id, $event)">加入阅读列表</a>
      <span>{{ gank.desc }}</span>
    </li>
  </ul>
</div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'

export default {
  data () {
    return {
      selected: null
    }
  },

  computed: Object.assign(
    mapGetters({
      ids: 'ids'
    }), 
    mapState({
      isFetching: state => state.gankList.isFetching,
      ganks: state => state.gankList.ganks,
      categories: state => state.categories
    })
  ),

  methods: {
    changeCategory(selected) {
      this.$store.dispatch('getGanks', selected)
    },
    add(id, event) {
      if (this.ids.indexOf(id) < 0) {
        this.$store.dispatch('addToReadingList', id)
      }
    }
  },

  created () {
    this.$data.selected = this.categories[0]
    this.$store.dispatch('getGanks', this.$data.selected)
  }
}


</script>

<style>
  .gank-list ul {
    width: 500px;
  }
  .gank-list li {
    display: flex;
  }
  .gank-list li a {
    width: 100px;
    margin-right: 20px;
    flex: none;
  }
</style>
```

- Vuex 提供了 `mapGetters`、`mapState`、`mapActions` 等方法来连接 store 的内容。
- 当手动调用 action 的时候要使用 `dispatch` 方法。
- getter 目前还没有库支持的命名空间，当应用变复杂的时候容易出错，可以手动为 getter 添加命名空间。

**src/components/ReadingList.vue**

```html
<template>
<div class="reading-list">
  <h2>阅读列表</h2>
  <select v-model="selected">
    <option value="all">all</option>
    <option v-for="category in categories">
      {{ category }}
    </option>
  </select>
  <div v-if="readingListOfCategory.length === 0">
    还没有阅读条目
  </div>
  <ul v-else>
    <li v-for="item in readingListOfCategory">
      <a :href="item.url" target="_blank">{{ item.desc }}</a>
      <a href="javascript:void(0);" @click="deleteItem(item._id)">移除</a>
    </li>
  </ul>
</div>
</template>
<script>
import { mapState, mapActions } from 'vuex'
export default {
  data() {
    return {
      selected: 'all'
    }
  },
  
  computed: Object.assign({
    readingListOfCategory() {
      if (this.selected === 'all') {
        return this.readingList
      } else {
        return this.readingList.filter(item => item.type === this.selected)
      }
    }
  }, mapState({
    readingList: state => state.readingList.readingList,
    categories: state => state.categories
  })),

  methods: mapActions({
    deleteItem: 'deleteItem'
  })
}
</script>
<style>
  .reading-list li {
    display: flex;
  }
  .reading-list li a {
    padding-right: 20px;
  }
</style>
```

> note: Vuex 还提供了 `mapMutations` 方法让开发者可以在组件当中直接提交 mutation 但为了保持清晰的数据流结构，用 action 来提交 mutation，应该避免使用 `mapMutations`

## 总结

### 与 Redux 一些不同的地方

- Redux 的 state 是只读的，每次执行 action 必须返回一个新对象。Vuex 的 state 是可修改的。
- Redux 中 action 对多个不同的 state 作出修改，一般的做法是通过不同 Reducer 来监听同一个 action 分别作出修改。Vuex 直接通过公共的 mutation 修改各个不同的 state。

Vuex 使用上与 Redux 等数据流管理库有很多类似的地方，有 Redux 等库使用经验的人很容易上手，作为 Vue 官方的一个数据流库非常值得学习。
