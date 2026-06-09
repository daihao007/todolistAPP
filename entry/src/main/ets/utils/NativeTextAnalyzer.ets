import textAnalyzer from 'libtext_analyzer.so'

interface TextAnalyzerModule {
  extractKeywords(text: string, topK: number): string[]
  scoreSentences(text: string, keywords: string[], topK: number): string[]
}

const nativeTextAnalyzer = textAnalyzer as TextAnalyzerModule

export class NativeTextAnalyzer {
  /**
   * 提取关键词
   * @param text 待分析文本
   * @param topK 返回数量，默认5
   * @returns 关键词数组
   */
  static extractKeywords(text: string, topK: number = 5): string[] {
    try {
      return nativeTextAnalyzer.extractKeywords(text, topK)
    } catch (e) {
      console.error('Native extractKeywords failed:', e)
      return []
    }
  }

  /**
   * 评分句子（用于摘要生成）
   * @param text 待分析文本
   * @param keywords 关键词数组
   * @param topK 句子数量，默认2
   * @returns 句子数组（保持原始顺序）
   */
  static scoreSentences(text: string, keywords: string[], topK: number = 2): string[] {
    try {
      return nativeTextAnalyzer.scoreSentences(text, keywords, topK)
    } catch (e) {
      console.error('Native scoreSentences failed:', e)
      return []
    }
  }
}
