<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  data() {
    return { 
      student: { name: '32605150601陈续文' } 
    }
  },
  components: {
    HelloWorld
  }
}
</script>

<template>
  <HelloWorld />
  <h1>我的第一个Vue应用 - {{ student.name }}</h1>
</template>
