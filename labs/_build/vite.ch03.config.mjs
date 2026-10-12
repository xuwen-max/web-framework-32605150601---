// 验证用配置（临时）：把实验台当 root，输出与缓存都放在 labs\_build 下
import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

export default defineConfig({
  root: 'D:/web-framework-32605150601陈续文/labs/ch03-components',
  cacheDir: 'D:/web-framework-32605150601陈续文/labs/_build/.vite-ch03',
  plugins: [vue()],
  server: { host: '127.0.0.1', port: 5192, strictPort: true },
})
