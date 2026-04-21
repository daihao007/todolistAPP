// ets/model/Note.ets
export interface Note {
  id: string;
  title: string;
  content: string;
  imagePath: string;
  tags: string; // 注意：RDB数据库存字符串比较简单，多个标签用逗号隔开，如 "工作,重要"
  createTime: number;
  isTodo: number; // 0代表不是待办，1代表是
}

// 这里的假数据，发给 D 同学，让他用在 NoteCard 组件里
export const MockNotes: Note[] = [
  {
    id: '1',
    title: '小组作业开会记录',
    content: '今天讨论了 ArkTS 的项目结构，大家分工明确。',
    imagePath: '',
    tags: '学校,作业',
    createTime: Date.now(),
    isTodo: 1
  },
  {
    id: '2',
    title: '买水果',
    content: '西瓜、苹果、香蕉',
    imagePath: '',
    tags: '生活',
    createTime: Date.now(),
    isTodo: 0
  }
]