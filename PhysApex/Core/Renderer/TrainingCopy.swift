import Foundation

// MARK: - 训练型文案工具
//
// 为什么存在这个文件（别删）：
// 审核合规红线（Guideline 2.1 / "书籍杂志内容"闸门）要求界面上不出现"成段正文"。
// 中国大陆虽已从销售地区移除（仅港澳台），这条形态约定继续保留：既是防抽查，也是产品定位。
// 数据层里那些写得很好的长句（物理图像、极限检验的直觉解释、教材式释义）直接上屏，
// 整屏看起来就像在"阅读资料"，而不是在"做题"。
// 所有来自数据层、要上屏的文本，先过这里切成训练型短句；渲染层再加行数上限兜底。
// 判据：任一屏最多 3 行连续正文，单条不超过 answerLimit 字。

enum TrainingCopy {

    /// 卡片背面正文的硬上限（字数）。要改大之前先问：这一屏还像不像一张训练卡。
    static let answerLimit = 46

    /// 背面主答案（结论句）的硬上限。
    static let titleLimit = 34

    /// 分点短语的硬上限。
    static let bulletLimit = 24

    /// 在标点处断开，把长句裁成一句训练型短句；被裁则补省略号。
    ///
    /// 裁切点优先落在句读（。！？；，、—）上，找不到就在 limit 处硬切，
    /// 尽量读起来像一个完整的短语，而不是半句话。
    static func concise(_ text: String, limit: Int = answerLimit) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > limit else { return trimmed }

        let chars = Array(trimmed)
        let boundary: Set<Character> = ["。", "！", "？", "；", "，", "、", "—"]
        var cutIndex = 0
        for i in stride(from: limit, through: 1, by: -1) where boundary.contains(chars[i - 1]) {
            cutIndex = i
            break
        }
        let head = cutIndex > 0 ? String(chars[0..<cutIndex]) : String(chars[0..<limit])
        let cleaned = head.trimmingCharacters(in: CharacterSet(charactersIn: "，、；：—。 "))
        return cleaned + "…"
    }

    /// 把短列表统一成「• 短句」形态，逐条限长，最多 4 条。
    static func bullets(_ items: [String], limit: Int = bulletLimit) -> String {
        items.prefix(4).map { "• " + concise($0, limit: limit) }.joined(separator: "\n")
    }
}
