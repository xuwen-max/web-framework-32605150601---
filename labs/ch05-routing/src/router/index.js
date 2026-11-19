// ============================================================
// router/index.js —— ch05-routing 路由表（全章唯一，逐实验长大）
// 创建：createRouter + createWebHashHistory（hash 模式，地址带 #）
// 挂载：main.js 里 app.use(router) 之后，全项目才有 router-link/router-view
// ============================================================
import { createRouter, createWebHashHistory } from 'vue-router'

// 页面组件就是普通 .vue 文件，谁要上路由舞台，谁就要先被 import 进来
import Home from '../views/01-basic/Home.vue'
import About from '../views/01-basic/About.vue'
import NotFound from '../views/02-redirect/NotFound.vue'

// 任务 3：动态路由（列表 + 详情两个组件）
import Users from '../views/03-dynamic/Users.vue'
import User from '../views/03-dynamic/User.vue'

// 任务 4：嵌套路由（外壳 + 两个子页）
import Center from '../views/04-nested/Center.vue'
import CenterProfile from '../views/04-nested/CenterProfile.vue'
import CenterOrders from '../views/04-nested/CenterOrders.vue'

// 任务 5、6 的演示页
import NamedDemo from '../views/05-named/NamedDemo.vue'
import ProgramDemo from '../views/06-programmatic/ProgramDemo.vue'
import Search from '../views/06-programmatic/Search.vue'

// 任务 7：登录页（守卫的拦截目的地）
import Login from '../views/07-guard/Login.vue'

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    // 根路径重定向：放在最前，第一时间接管
    { path: '/', redirect: '/home' },
    { path: '/home', component: Home },
    { path: '/about', component: About },

    // 动态路由：:id 是占位符，一条规则匹配 /user/1、/user/2、/user/9527…
    { path: '/users', component: Users },
    { path: '/user/:id', name: 'user', component: User },

    // 嵌套路由：外壳 + children（子 path 不带开头斜杠，自动拼成 /center/profile）
    {
      path: '/center',        // 外壳自己管 /center 这一级
      component: Center,
      children: [
        // 空路径重定向：访问 /center 本身时跳到默认子页，否则壳里空空如也
        { path: '', redirect: '/center/profile' },
        { path: 'profile', component: CenterProfile },
        { path: 'orders', component: CenterOrders }
      ]
    },

    // 任务 5：命名路由演示页
    { path: '/named', component: NamedDemo },

    // 编程式导航驾驶舱 + query 搜索页
    { path: '/program', component: ProgramDemo },
    { path: '/search', component: Search },

    // 登录页（守卫的拦截目的地）
    { path: '/login', component: Login },

    // 404 兜底：通配符必须放最后，且 pathMatch 前面那个冒号不能丢
    { path: '/:pathMatch(.*)*', name: 'NotFound', component: NotFound }
  ]
})

// 实验 07：全局前置守卫——/center 是会员区，没 token 一律拦去 /login
// to=去哪 from=从哪来 next=放行函数（每个分支都必须调，忘了就整站卡住）
router.beforeEach((to, from, next) => {
  // 判断条件给了：目标是 /center 本身、或 /center/ 开头的子路由
  if (to.path === '/center' || to.path.startsWith('/center/')) {
    if (localStorage.getItem('token')) {   // 本地存着 token 就算已登录
      next()                                // 验明正身，放行（只调函数、不传参数）
    } else {
      next('/login')                        // 拦下，改道去登录页
    }
  } else {
    next()                                  // 非会员区，直接放行
  }
})

export default router
