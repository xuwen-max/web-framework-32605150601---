import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import store from './store'                       // ⑦ Vuex（任务 7）：一个变量，全家共享
import { createPinia } from 'pinia'               // ⑧ Pinia（任务 8）
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

const app = createApp(App)

// 全局注册所有 Element Plus 图标，模板里可直接写 <HomeFilled /> <User /> 等
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)              // 挂持久化插件：管 store 里的数据要不要存 localStorage

app.use(router).use(ElementPlus).use(store).use(pinia).mount('#app')
