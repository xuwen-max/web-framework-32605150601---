<template>
  <div id="app">
    <h1>📓 记事本 notes-app · 第 2 章实验</h1>
    <NoteCard />

    <hr />
    <h2>📝 记事本雏形（综合任务）</h2>

    <div class="input-row">
      <input v-model="newNote" placeholder="输入笔记内容，回车也可添加" @keyup.enter="addNote" />
      <button class="add-btn" @click="addNote">＋ 添加</button>
    </div>

    <div class="options">
      <span class="opt-label">优先级</span>
      <label class="radio-pill"><input type="radio" value="高" v-model="priority" /> 高</label>
      <label class="radio-pill"><input type="radio" value="中" v-model="priority" /> 中</label>
      <label class="radio-pill"><input type="radio" value="低" v-model="priority" /> 低</label>
    </div>

    <div class="options">
      <span class="opt-label">标签</span>
      <label class="check-pill"><input type="checkbox" value="待办" v-model="tags" /> 待办</label>
      <label class="check-pill"><input type="checkbox" value="灵感" v-model="tags" /> 灵感</label>
    </div>

    <p class="preview">
      实时展示 → 内容：{{ newNote || '（未输入）' }}｜优先级：{{ priority }}｜标签：{{ tags.join('、') || '（未选）' }}
    </p>

    <ul>
      <li v-for="(note, index) in notes" :key="note.id">
        <div class="note-body">
          <span class="note-index">{{ index + 1 }}</span>
          <span class="note-text">{{ note.text }}</span>
          <span class="note-tag" :class="'p-' + note.priority">{{ note.priority }}</span>
          <span class="note-tags" v-if="note.tags.length">{{ note.tags.join(' / ') }}</span>
        </div>
        <button class="delete-btn" @click="notes.splice(index, 1)">删除</button>
      </li>
    </ul>

    <p class="empty-tip" v-if="notes.length === 0">暂无笔记，快添加一条吧 ✨</p>
    <p class="count-tip" v-show="notes.length > 0">共 {{ notes.length }} 条</p>



    <hr />
    <h2>🎯 事件实验室（2.4—2.5）</h2>
    <EventLab />
  </div>
</template>

<script>
import NoteCard from './components/NoteCard.vue'
import EventLab from './components/EventLab.vue'


export default {
  components: { NoteCard, EventLab },
  data() {
    return {
      newNote: '',
      priority: '中',
      tags: [],
      notes: [],
      nextId: 1
    }
  },
  methods: {
    addNote() {
      if (!this.newNote.trim()) return
      this.notes.push({
        id: this.nextId++,
        text: this.newNote.trim(),
        priority: this.priority,
        tags: [...this.tags]
      })
      this.newNote = ''
    }
  }
}
</script>

<style scoped>
#app {
  max-width: 680px;
  margin: 40px auto;
  padding: 32px 36px;
  border-radius: 20px;
  background: linear-gradient(135deg, #f0fdf4 0%, #ecfeff 100%);
  box-shadow: 0 8px 32px rgba(16, 185, 129, 0.10);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", sans-serif;
  color: #1e293b;
}

h1 {
  font-size: 22px;
  font-weight: 700;
  margin-bottom: 0;
  color: #059669;
}

h2 {
  font-size: 17px;
  font-weight: 600;
  margin: 20px 0 14px;
  color: #047857;
}

hr {
  border: none;
  border-top: 1px solid #bbf7d0;
  margin: 18px 0;
}

/* 输入区 */
.input-row {
  display: flex;
  gap: 10px;
  margin-bottom: 16px;
}

.input-row input {
  flex: 1;
  padding: 11px 16px;
  border-radius: 12px;
  border: 1.5px solid #bbf7d0;
  background: #fff;
  font-size: 15px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.input-row input::placeholder {
  color: #a7f3d0;
}

.input-row input:focus {
  border-color: #34d399;
  box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.18);
}

.add-btn {
  padding: 11px 22px;
  border-radius: 12px;
  border: none;
  background: linear-gradient(135deg, #34d399, #06b6d4);
  color: #fff;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.2s;
  box-shadow: 0 2px 8px rgba(6, 182, 212, 0.25);
}

.add-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 14px rgba(6, 182, 212, 0.35);
}

.add-btn:active {
  transform: translateY(0);
}

/* 选项区 */
.options {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.opt-label {
  font-size: 13px;
  color: #6b7280;
  margin-right: 4px;
}

.radio-pill,
.check-pill {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 5px 14px;
  border-radius: 20px;
  border: 1.5px solid #d1fae5;
  background: #fff;
  font-size: 13px;
  color: #374151;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s;
}

.radio-pill:hover,
.check-pill:hover {
  background: #ecfdf5;
  border-color: #6ee7b7;
}

.radio-pill input,
.check-pill input {
  accent-color: #10b981;
}

/* 预览区 */
.preview {
  margin: 14px 0 18px;
  padding: 12px 16px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.7);
  border: 1px dashed #a7f3d0;
  font-size: 13px;
  line-height: 1.7;
  color: #4b5563;
}

/* 列表 */
ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

ul li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 16px;
  margin-bottom: 10px;
  border-radius: 14px;
  background: #fff;
  border: 1px solid #d1fae5;
  box-shadow: 0 1px 4px rgba(16, 185, 129, 0.06);
  transition: transform 0.15s, box-shadow 0.2s;
}

ul li:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.12);
  border-color: #6ee7b7;
}

.note-body {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
  font-size: 14px;
  min-width: 0;
}

.note-index {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #ecfdf5;
  color: #059669;
  font-size: 12px;
  font-weight: 700;
  flex-shrink: 0;
}

.note-text {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.note-tag {
  padding: 2px 10px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}

.p-高 {
  background: #fee2e2;
  color: #dc2626;
}

.p-中 {
  background: #fef3c7;
  color: #d97706;
}

.p-低 {
  background: #d1fae5;
  color: #059669;
}

.note-tags {
  font-size: 12px;
  color: #9ca3af;
  flex-shrink: 0;
}

.delete-btn {
  padding: 6px 14px;
  border-radius: 10px;
  border: 1px solid #fecaca;
  background: #fff;
  color: #ef4444;
  font-size: 13px;
  cursor: pointer;
  transition: background 0.2s;
  margin-left: 12px;
}

.delete-btn:hover {
  background: #fef2f2;
}

.empty-tip {
  margin-top: 18px;
  color: #a7f3d0;
  font-size: 14px;
  text-align: center;
}

.count-tip {
  margin-top: 14px;
  color: #059669;
  font-size: 13px;
  text-align: right;
}
</style>