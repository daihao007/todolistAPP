#include <algorithm>
#include <cmath>
#include <cstdint>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace {

struct Utf8Char {
    std::string text;
    uint32_t codePoint;
};

struct SentenceItem {
    std::string text;
    size_t index;
    double score;
};

bool IsUtf8Continuation(unsigned char byte)
{
    return (byte & 0xC0) == 0x80;
}

bool DecodeNextUtf8(const std::string& input, size_t& offset, Utf8Char& output)
{
    if (offset >= input.size()) {
        return false;
    }

    const size_t start = offset;
    const unsigned char first = static_cast<unsigned char>(input[offset]);
    size_t length = 1;
    uint32_t codePoint = first;

    if ((first & 0x80) == 0) {
        length = 1;
        codePoint = first;
    } else if ((first & 0xE0) == 0xC0) {
        length = 2;
        codePoint = first & 0x1F;
    } else if ((first & 0xF0) == 0xE0) {
        length = 3;
        codePoint = first & 0x0F;
    } else if ((first & 0xF8) == 0xF0) {
        length = 4;
        codePoint = first & 0x07;
    } else {
        ++offset;
        output = { input.substr(start, 1), first };
        return true;
    }

    if (offset + length > input.size()) {
        offset = input.size();
        output = { input.substr(start), first };
        return true;
    }

    for (size_t i = 1; i < length; ++i) {
        const unsigned char next = static_cast<unsigned char>(input[offset + i]);
        if (!IsUtf8Continuation(next)) {
            ++offset;
            output = { input.substr(start, 1), first };
            return true;
        }
        codePoint = (codePoint << 6) | (next & 0x3F);
    }

    offset += length;
    output = { input.substr(start, length), codePoint };
    return true;
}

std::vector<Utf8Char> DecodeUtf8(const std::string& input)
{
    std::vector<Utf8Char> chars;
    size_t offset = 0;
    while (offset < input.size()) {
        Utf8Char current;
        if (DecodeNextUtf8(input, offset, current)) {
            chars.push_back(current);
        }
    }
    return chars;
}

bool IsChinese(uint32_t codePoint)
{
    return (codePoint >= 0x4E00 && codePoint <= 0x9FFF) ||
        (codePoint >= 0x3400 && codePoint <= 0x4DBF) ||
        (codePoint >= 0x20000 && codePoint <= 0x2A6DF);
}

bool IsAsciiAlpha(uint32_t codePoint)
{
    return (codePoint >= 'a' && codePoint <= 'z') || (codePoint >= 'A' && codePoint <= 'Z');
}

bool IsAsciiDigit(uint32_t codePoint)
{
    return codePoint >= '0' && codePoint <= '9';
}

bool IsWhitespace(uint32_t codePoint)
{
    return codePoint == ' ' || codePoint == '\t' || codePoint == '\n' || codePoint == '\r';
}

bool IsPunctuation(uint32_t codePoint)
{
    static const std::unordered_set<uint32_t> punctuations = {
        ',', '.', '!', '?', ';', ':', '"', '\'', '(', ')', '[', ']', '{', '}', '<', '>',
        '/', '\\', '|', '-', '_', '+', '=', '*', '&', '^', '%', '$', '#', '@', '~', '`',
        0x3002, 0xFF0C, 0x3001, 0xFF01, 0xFF1F, 0xFF1B, 0xFF1A, 0x201C, 0x201D,
        0x2018, 0x2019, 0xFF08, 0xFF09, 0x3010, 0x3011, 0x300A, 0x300B, 0x3008,
        0x3009, 0x300E, 0x300F, 0x2014, 0x2026, 0x3000
    };
    return punctuations.find(codePoint) != punctuations.end();
}

bool IsTokenChar(const Utf8Char& ch)
{
    return IsChinese(ch.codePoint) || IsAsciiAlpha(ch.codePoint) || IsAsciiDigit(ch.codePoint);
}

std::string JoinChars(const std::vector<Utf8Char>& chars, size_t start, size_t length)
{
    std::string result;
    for (size_t i = start; i < start + length && i < chars.size(); ++i) {
        result += chars[i].text;
    }
    return result;
}

bool IsPureNumber(const std::vector<Utf8Char>& chars, size_t start, size_t length)
{
    for (size_t i = start; i < start + length && i < chars.size(); ++i) {
        if (!IsAsciiDigit(chars[i].codePoint)) {
            return false;
        }
    }
    return true;
}

bool ContainsChinese(const std::vector<Utf8Char>& chars, size_t start, size_t length)
{
    for (size_t i = start; i < start + length && i < chars.size(); ++i) {
        if (IsChinese(chars[i].codePoint)) {
            return true;
        }
    }
    return false;
}

bool HasBadBoundaryChar(const std::vector<Utf8Char>& chars, size_t start, size_t length)
{
    static const std::unordered_set<uint32_t> badStart = {
        0x4E86, 0x7684, 0x662F, 0x548C, 0x4E0E, 0x53CA, 0x5C06, 0x628A, 0x88AB,
        0x5728, 0x5BF9, 0x4E3A, 0x4ECE, 0x4E2A, 0x6BD4, 0x8F83, 0x5F88,
        0x8981, 0x53BB, 0x5426
    };
    static const std::unordered_set<uint32_t> badEnd = {
        0x7684, 0x4E86, 0x548C, 0x4E0E, 0x53CA, 0x5728, 0x5BF9, 0x4E3A,
        0x8FD9, 0x90A3, 0x4E2A, 0x5F88, 0x8981, 0x53BB, 0x5426, 0x51C6
    };
    if (length == 0 || start + length > chars.size()) {
        return true;
    }
    return badStart.find(chars[start].codePoint) != badStart.end() ||
        badEnd.find(chars[start + length - 1].codePoint) != badEnd.end();
}

bool IsStopToken(const std::string& token)
{
    static const std::unordered_set<std::string> stopTokens = {
        "今天", "明天", "昨天", "下周", "本周", "这个", "那个", "比较", "一下", "一个",
        "我们", "你们", "他们", "进行", "关于", "已经", "还有", "以及", "然后", "但是",
        "因为", "所以", "如果", "可以", "需要", "准备", "安排", "完成",
        "周六", "周日", "六准", "备去", "要买", "是否", "顺便", "家里", "里的",
        "买洗", "衣液", "天记", "记得", "得买", "记得买", "买咖", "买咖啡",
        "得买咖", "天记得", "明天记", "明天记得"
    };
    return stopTokens.find(token) != stopTokens.end();
}

std::vector<std::vector<Utf8Char>> BuildTokenSegments(const std::string& text)
{
    std::vector<std::vector<Utf8Char>> segments;
    std::vector<Utf8Char> current;
    for (const Utf8Char& ch : DecodeUtf8(text)) {
        if (IsTokenChar(ch)) {
            current.push_back(ch);
            continue;
        }

        if (!current.empty()) {
            segments.push_back(current);
            current.clear();
        }
    }
    if (!current.empty()) {
        segments.push_back(current);
    }
    return segments;
}

std::vector<std::string> Tokenize(const std::string& text)
{
    std::vector<std::string> tokens;
    for (const auto& segment : BuildTokenSegments(text)) {
        for (size_t ngram = 2; ngram <= 3; ++ngram) {
            if (segment.size() < ngram) {
                continue;
            }
            for (size_t i = 0; i + ngram <= segment.size(); ++i) {
                if (IsPureNumber(segment, i, ngram) || !ContainsChinese(segment, i, ngram)) {
                    continue;
                }
                if (HasBadBoundaryChar(segment, i, ngram)) {
                    continue;
                }

                std::string token = JoinChars(segment, i, ngram);
                if (token.size() < 2 || IsStopToken(token)) {
                    continue;
                }
                tokens.push_back(token);
            }
        }
    }
    return tokens;
}

double PresetIdf(const std::string& token)
{
    static const std::unordered_map<std::string, double> importantTerms = {
        { "项目", 2.2 }, { "会议", 2.2 }, { "开发", 2.2 }, { "计划", 2.2 },
        { "任务", 1.0 }, { "数据库", 2.4 }, { "迁移", 2.1 }, { "目标", 2.0 },
        { "问题", 2.0 }, { "风险", 2.25 }, { "结论", 2.0 }, { "总结", 2.0 },
        { "推进", 2.1 }, { "产品", 2.1 }, { "评审", 2.3 }, { "登录", 2.2 },
        { "流程", 2.25 }, { "优化", 2.25 }, { "方案", 1.8 }, { "接口", 2.1 },
        { "联调", 2.1 }, { "测试", 2.1 }, { "环境", 1.7 }, { "部署", 2.1 },
        { "设计", 1.9 }, { "学习", 1.9 }, { "工作", 1.9 }, { "课程", 1.9 },
        { "调研", 1.9 }, { "需求", 2.1 }, { "生活", 2.1 }, { "采购", 2.3 },
        { "用品", 2.1 }, { "超市", 2.0 }, { "牛奶", 2.4 }, { "水果", 2.4 },
        { "纸巾", 2.4 }, { "药箱", 2.3 }, { "补充", 2.0 }, { "洗衣液", 2.6 },
        { "咖啡", 2.6 }
    };
    auto iter = importantTerms.find(token);
    if (iter != importantTerms.end()) {
        return iter->second;
    }

    const auto chars = DecodeUtf8(token);
    if (chars.size() == 2) {
        return 1.35;
    }
    if (chars.size() == 3) {
        return 1.0;
    }
    return 0.85;
}

size_t ClampTopK(int topK, size_t maxValue)
{
    if (topK <= 0) {
        return 0;
    }
    return std::min(static_cast<size_t>(topK), maxValue);
}

bool Contains(const std::string& text, const std::string& needle)
{
    return !needle.empty() && text.find(needle) != std::string::npos;
}

std::vector<std::string> SplitToSentences(const std::string& text)
{
    std::vector<std::string> sentences;
    std::string current;
    for (const Utf8Char& ch : DecodeUtf8(text)) {
        if (ch.codePoint == 0x3002 || ch.codePoint == 0xFF01 || ch.codePoint == 0xFF1F ||
            ch.codePoint == 0xFF1B || ch.codePoint == '.' || ch.codePoint == '!' ||
            ch.codePoint == '?' || ch.codePoint == ';' || ch.codePoint == '\n' ||
            ch.codePoint == '\r') {
            if (!current.empty()) {
                sentences.push_back(current);
                current.clear();
            }
            continue;
        }
        if (!current.empty() || !IsWhitespace(ch.codePoint)) {
            current += ch.text;
        }
    }
    if (!current.empty()) {
        sentences.push_back(current);
    }

    std::vector<std::string> filtered;
    for (const std::string& sentence : sentences) {
        const auto chars = DecodeUtf8(sentence);
        if (chars.size() >= 6) {
            filtered.push_back(sentence);
        }
    }
    return filtered;
}

size_t Utf8Length(const std::string& text)
{
    return DecodeUtf8(text).size();
}

double ScoreSentence(const std::string& sentence, const std::vector<std::string>& keywords)
{
    const size_t sentenceLength = Utf8Length(sentence);
    double score = static_cast<double>(std::min<size_t>(sentenceLength, 40));

    for (size_t i = 0; i < keywords.size(); ++i) {
        if (Utf8Length(keywords[i]) >= 2 && Contains(sentence, keywords[i])) {
            const int bonus = std::max(8 - static_cast<int>(i), 3);
            score += bonus;
        }
    }

    static const std::vector<std::string> summaryHints = {
        "目标", "计划", "需要", "准备", "安排", "问题", "风险", "结论", "总结", "完成", "推进"
    };
    for (const std::string& hint : summaryHints) {
        if (Contains(sentence, hint)) {
            score += 6;
        }
    }

    if (sentenceLength < 10) {
        score -= 8;
    }
    if (sentenceLength > 80) {
        score -= 4;
    }
    return score;
}

} // namespace

std::vector<std::string> ExtractKeywordsNative(const std::string& text, int topK)
{
    const std::vector<std::string> tokens = Tokenize(text);
    if (tokens.empty()) {
        return {};
    }

    std::unordered_map<std::string, int> frequency;
    for (const std::string& token : tokens) {
        frequency[token] += 1;
    }

    struct WeightedToken {
        std::string token;
        double score;
        int count;
    };

    std::vector<WeightedToken> weighted;
    weighted.reserve(frequency.size());
    const double total = static_cast<double>(tokens.size());
    for (const auto& item : frequency) {
        const double tf = static_cast<double>(item.second) / total;
        const double score = tf * PresetIdf(item.first);
        weighted.push_back({ item.first, score, item.second });
    }

    std::sort(weighted.begin(), weighted.end(), [](const WeightedToken& left, const WeightedToken& right) {
        if (std::abs(left.score - right.score) > 0.000001) {
            return left.score > right.score;
        }
        if (left.count != right.count) {
            return left.count > right.count;
        }
        return left.token.size() < right.token.size();
    });

    const size_t limit = ClampTopK(topK, weighted.size());
    std::vector<std::string> result;
    result.reserve(limit);
    for (size_t i = 0; i < limit; ++i) {
        result.push_back(weighted[i].token);
    }
    return result;
}

std::vector<std::string> ScoreSentencesNative(
    const std::string& text,
    const std::vector<std::string>& keywords,
    int topK)
{
    const std::vector<std::string> sentences = SplitToSentences(text);
    if (sentences.empty()) {
        return {};
    }

    std::vector<SentenceItem> ranked;
    ranked.reserve(sentences.size());
    for (size_t i = 0; i < sentences.size(); ++i) {
        ranked.push_back({ sentences[i], i, ScoreSentence(sentences[i], keywords) });
    }

    std::sort(ranked.begin(), ranked.end(), [](const SentenceItem& left, const SentenceItem& right) {
        if (std::abs(left.score - right.score) > 0.000001) {
            return left.score > right.score;
        }
        return left.index < right.index;
    });

    const size_t limit = ClampTopK(topK, ranked.size());
    ranked.resize(limit);
    std::sort(ranked.begin(), ranked.end(), [](const SentenceItem& left, const SentenceItem& right) {
        return left.index < right.index;
    });

    std::vector<std::string> result;
    result.reserve(ranked.size());
    for (const SentenceItem& item : ranked) {
        result.push_back(item.text);
    }
    return result;
}
