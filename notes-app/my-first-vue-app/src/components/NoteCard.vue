<template>
  <div class="note-card">
    <h3>🗒️ NoteCard · 六类指令演示</h3>

    <!-- 插值三连 + 响应式 -->
    <div class="block">
      <p>{{ message }}</p>
      <p class="upper">{{ message.toUpperCase() }}</p>
      <p>{{ 1 + 2 * 3 }}</p>
      <p>count = <strong>{{ count }}</strong>（3 秒后自动变 100）</p>
    </div>

    <!-- v-text / v-html -->
    <div class="block">
      <p v-text="rawText"></p>
      <p v-html="htmlText"></p>
    </div>

    <!-- v-bind -->
    <div class="block">
      <img :src="imgSrc" :title="tipTitle" width="80" class="logo" />
      <p :class="{ active: count > 0 }">count 大于 0 时这行变高亮</p>
    </div>

    <!-- v-on -->
    <div class="block btn-row">
      <button class="btn" @click="count++">count +1</button>
      <button class="btn btn-cyan" @click="say('你好', $event)">say</button>
    </div>

    <!-- v-model 表单 -->
    <div class="block form-box">
      <p class="preview">
        实时 → 姓名：{{ form.name || '未输入' }}｜性别：{{ form.gender || '未选择' }}｜爱好：{{ form.hobbies.length ?
          form.hobbies.join('、') : '未选择' }}
      </p>
      <input class="text-input" v-model="form.name" placeholder="输入姓名" />
      <div class="options">
        <label><input type="radio" value="男" v-model="form.gender" /> 男</label>
        <label><input type="radio" value="女" v-model="form.gender" /> 女</label>
      </div>
      <div class="options">
        <label><input type="checkbox" value="篮球" v-model="form.hobbies" /> 篮球</label>
        <label><input type="checkbox" value="编程" v-model="form.hobbies" /> 编程</label>
      </div>
    </div>

    <!-- v-if / v-show -->
    <div class="block">
      <button class="btn btn-cyan" @click="show = !show">切换显隐</button>
      <p v-if="show">v-if：条件为真我才被渲染</p>
      <p v-else>v-else：上面为假才轮到我</p>
      <p v-show="show">v-show：我一直存在，只是 display:none</p>
    </div>

    <!-- v-for -->
    <div class="block">
      <ul class="subject-list">
        <li v-for="(subject, index) in subjects" :key="index">{{ index }} - {{ subject }}</li>
      </ul>
      <div class="btn-row">
        <button class="btn" @click="subjects[1] = '英语（索引赋值）'">数组索引赋值</button>
        <button class="btn btn-cyan" @click="form.school = '成都理工大学工程技术学院'">对象新增属性</button>
      </div>
      <p class="school" v-if="form.school">{{ form.school }}</p>
    </div>
  </div>


</template>

<script>
export default {
  name: 'NoteCard',
  data() {
    return {
      title: '我的第一条笔记',
      message: 'hello vue',
      count: 0,
      rawText: '<b>我是 v-text 的纯文本</b>',
      htmlText: '<b>我是 v-html 解析出的加粗</b>',
      imgSrc: 'https://vuejs.org/images/logo.svg',
      tipTitle: ':title 悬停提示',
      form: { name: '', gender: '', hobbies: [] },
      show: true,
      subjects: ['语文', '数学', 'Vue']
    }
  },
  methods: {
    say(word, event) {
      alert(word + '｜事件类型：' + event.type)
    }
  },
  mounted() {
    setTimeout(() => { this.count = 100 }, 3000)
  }
}
</script>

<style scoped>
.note-card {
  border: 1.5px solid #d1fae5;
  padding: 22px 24px;
  border-radius: 18px;
  background: #fff;
  box-shadow: 0 4px 16px rgba(16, 185, 129, 0.08);
  color: #1e293b;
  margin-bottom: 4px;
}

.note-card h3 {
  margin: 0 0 16px;
  font-size: 17px;
  font-weight: 700;
  color: #059669;
}

.block {
  padding: 14px 0;
  border-top: 1px dashed #d1fae5;
  font-size: 14px;
  line-height: 1.8;
}

.block:first-of-type {
  border-top: none;
}

.upper {
  color: #6b7280;
  font-size: 13px;
}

.active {
  color: #10b981;
  font-weight: 700;
}

.logo {
  vertical-align: middle;
  margin-right: 8px;
  border-radius: 8px;
  background: #f0fdf4;
  padding: 6px;
}

.btn-row {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.btn {
  padding: 8px 16px;
  border-radius: 10px;
  border: none;
  background: linear-gradient(135deg, #34d399, #10b981);
  color: #fff;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.2s;
  box-shadow: 0 2px 6px rgba(16, 185, 129, 0.2);
}

.btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.btn-cyan {
  background: linear-gradient(135deg, #67e8f9, #22d3ee);
  box-shadow: 0 2px 6px rgba(34, 211, 238, 0.2);
}

.btn-cyan:hover {
  box-shadow: 0 4px 12px rgba(34, 211, 238, 0.35);
}

.form-box .preview {
  margin-bottom: 12px;
  padding: 10px 14px;
  border-radius: 10px;
  background: #f0fdf4;
  border: 1px dashed #bbf7d0;
  line-height: 1.6;
  font-size: 13px;
  color: #4b5563;
}

.text-input {
  display: block;
  width: 100%;
  box-sizing: border-box;
  padding: 10px 14px;
  border: 1.5px solid #d1fae5;
  border-radius: 10px;
  font-size: 14px;
  outline: none;
  margin-bottom: 10px;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.text-input:focus {
  border-color: #34d399;
  box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.15);
}

.options {
  display: flex;
  gap: 14px;
  margin-top: 8px;
}

.options label {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #374151;
  cursor: pointer;
}

.options input {
  accent-color: #10b981;
}

.subject-list {
  list-style: none;
  padding: 0;
  margin: 0 0 12px;
}

.subject-list li {
  padding: 7px 12px;
  margin-bottom: 6px;
  border-radius: 8px;
  background: #f0fdf4;
  border: 1px solid #d1fae5;
  font-size: 13px;
}

.school {
  margin-top: 8px;
  padding: 6px 12px;
  border-radius: 8px;
  background: #ecfeff;
  color: #0891b2;
  font-size: 13px;
}
</style>