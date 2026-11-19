// import { createApp } from 'vue'
// import './style.css'
// import App from './App.vue'
// import router from './router'

// createApp(App).use(router).mount('#app')   // 补全：把上面 import 的路由器实例交给应用


import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'          // 第 5 章的路由，今天当"实验台导航"复用
const app = createApp(App)
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
app.use(ElementPlus)
app.use(router)

app.mount('#app')