import textAnalyzer from 'libtext_analyzer.so'

interface CryptoModule {
  hashPassword(password: string, salt: string): string
  generateSalt(): string
  verifyPassword(password: string, salt: string, expectedHash: string): boolean
}

const nativeCrypto = textAnalyzer as CryptoModule

export class NativeCrypto {
  static generateSalt(): string {
    try {
      return nativeCrypto.generateSalt()
    } catch (e) {
      console.error('Native generateSalt failed:', e)
      return ''
    }
  }

  static hashPassword(password: string, salt: string): string {
    try {
      return nativeCrypto.hashPassword(password, salt)
    } catch (e) {
      console.error('Native hashPassword failed:', e)
      return ''
    }
  }

  static verifyPassword(password: string, salt: string, expectedHash: string): boolean {
    try {
      return nativeCrypto.verifyPassword(password, salt, expectedHash)
    } catch (e) {
      console.error('Native verifyPassword failed:', e)
      return false
    }
  }
}
