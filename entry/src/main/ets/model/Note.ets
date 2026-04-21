import { TodoVisualStatus } from '../common/Constants'

export interface Note {
  id: string
  title: string
  content: string
  imagePath: string
  tags: string
  createTime: number
  isTodo: number
  todoStatus: string
}

export const MockNotes: Note[] = [
  {
    id: '1',
    title: '小组作业开会记录',
    content: '今天讨论了 ArkTS 项目结构和页面分工，确认先把编辑页和首页打通。',
    imagePath: '',
    tags: '工作,学习',
    createTime: Date.now(),
    isTodo: 1,
    todoStatus: TodoVisualStatus.PENDING
  },
  {
    id: '2',
    title: '周末采买清单',
    content: '西瓜、苹果、香菜和牛奶。',
    imagePath: '',
    tags: '生活',
    createTime: Date.now() - 86400000,
    isTodo: 1,
    todoStatus: TodoVisualStatus.COMPLETED
  }
]
