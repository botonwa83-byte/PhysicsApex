import Foundation

// MARK: - 公式训练数据（少而精，每条都是「通透卡」）

enum LawLibrary {
    static let all: [PhysicsLaw] = [
        PhysicsLaw(
            id: "newton2",
            name: "牛顿第二定律",
            topic: .newton,
            stage: .senior,
            expression: "F合 = ma",
            dimension: "N = kg·m/s²",
            physicalImage: "力不是「维持」运动的，而是「改变」运动的——踢一脚球，球变速；不踢，它就匀速跑下去。",
            meaning: "合外力决定加速度。力的方向就是加速度的方向，跟速度方向无关。",
            limitChecks: [
                LimitCheck(scenario: "合力 F → 0", result: "a → 0，速度保持不变", intuition: "不受力就匀速或静止——这正是牛顿第一定律。原来一、二定律是一家人。"),
                LimitCheck(scenario: "质量 m → 很大", result: "同样的力，a → 很小", intuition: "推汽车几乎推不动：质量就是「惰性」的度量，越大越难改变运动。"),
            ],
            conditions: ["惯性参考系", "宏观低速（远小于光速）", "质量恒定"],
            commonMisuses: ["把「有力」当成「有速度」——其实力对应的是加速度", "在非惯性系直接用（需补惯性力）"],
            latex: "\\vec{F}_{\\text{合}} = m\\vec{a}"
        ),
        PhysicsLaw(
            id: "momentum_conservation",
            name: "动量守恒定律",
            topic: .momentum,
            stage: .senior,
            expression: "p前 = p后，即 Σmᵢvᵢ = 常量",
            dimension: "kg·m/s",
            physicalImage: "一群人在光滑冰面上推来推去，不管怎么折腾，整体的「总动量账本」纹丝不动。",
            meaning: "系统合外力为零时，总动量守恒——碰撞 / 爆炸题的上帝视角，无视中间过程多复杂。",
            limitChecks: [
                LimitCheck(scenario: "等质量弹性正碰", result: "两球交换速度", intuition: "台球母球撞上静止球，自己停下、把速度「传」过去——守恒律的经典画面。"),
                LimitCheck(scenario: "撞墙：墙的质量 M → ∞", result: "小球原速反弹，墙几乎不动", intuition: "墙改变不了自己的速度，只把小球弹回去——极端质量比下的直觉。"),
            ],
            conditions: ["系统所受合外力为零", "或：碰撞 / 爆炸瞬间内力远大于外力", "矢量式，注意方向与正负"],
            commonMisuses: ["把动量守恒误当动能守恒（非弹性碰撞动能会损失）", "只在某一方向守恒时当成整体守恒"],
            latex: "\\sum m_i \\vec{v}_i = \\text{常量}"
        ),
        PhysicsLaw(
            id: "mechanical_energy",
            name: "机械能守恒定律",
            topic: .energy,
            stage: .senior,
            expression: "Ek + Ep = 常量",
            dimension: "J = kg·m²/s²",
            physicalImage: "过山车——爬高时把动能「存」成势能，俯冲时再「取」回来，总账始终不变（没摩擦的话）。",
            meaning: "只有重力 / 弹力做功时，动能与势能相互转化、总量不变。",
            limitChecks: [
                LimitCheck(scenario: "从高 h 自由下落到底", result: "v = √(2gh)，与质量无关", intuition: "真空中羽毛和铁球同速落地——mgh = ½mv² 两边的 m 约掉了。"),
                LimitCheck(scenario: "单摆摆到最低点", result: "速度最大、势能最低", intuition: "能量在两种形式间倒来倒去，此消彼长，最低点动能全满。"),
            ],
            conditions: ["只有重力和弹力做功", "其他力不做功", "系统无摩擦生热"],
            commonMisuses: ["有摩擦 / 空气阻力时仍套守恒", "势能零点选取前后不一致"],
            latex: "E_k + E_p = \\text{常量}"
        ),
        PhysicsLaw(
            id: "work_energy",
            name: "动能定理",
            topic: .energy,
            stage: .senior,
            expression: "W合 = ½mv₂² − ½mv₁²",
            dimension: "J = N·m",
            physicalImage: "合力做的功，像往「动能账户」里存钱或取钱——余额的变化就是末动能减初动能。",
            meaning: "合外力做的功等于动能的变化——不管路径多曲折、力是否变化，只看功的总和。",
            limitChecks: [
                LimitCheck(scenario: "合力做功 = 0", result: "动能不变，速率不变", intuition: "匀速圆周运动里向心力永远垂直速度、不做功，所以速率恒定。"),
                LimitCheck(scenario: "只有摩擦力做负功", result: "动能持续减少直到停下", intuition: "滑行的物体终会停——动能被摩擦「吃掉」变成了热。"),
            ],
            conditions: ["适用于任何力（含变力、摩擦力）", "标量式，功有正负"],
            commonMisuses: ["漏掉摩擦力做的负功", "把「路程」当「位移」算功"],
            latex: "W_{\\text{合}} = \\tfrac{1}{2}mv_2^2 - \\tfrac{1}{2}mv_1^2"
        ),
        PhysicsLaw(
            id: "lorentz",
            name: "洛伦兹力",
            topic: .magnetic,
            stage: .senior,
            expression: "F = qvB·sinθ",
            dimension: "N（B 的单位 T = kg/(A·s²)）",
            physicalImage: "磁场像个「拐弯器」——它只改变带电粒子的方向，从不给它提速。",
            meaning: "磁场对运动电荷的作用力，方向由左手 / 右手定则判定，恒垂直于速度。",
            limitChecks: [
                LimitCheck(scenario: "速度 v 平行于磁场 B", result: "F = 0，粒子直线穿过", intuition: "顺着磁场跑不拐弯——sinθ = 0，磁场对它「视而不见」。"),
                LimitCheck(scenario: "速度 v 垂直于 B", result: "做匀速圆周，半径 r = mv/qB", intuition: "恒垂直的力正好当向心力，画出一个完美的圆。"),
            ],
            conditions: ["电荷在磁场中运动", "θ 为 v 与 B 的夹角"],
            commonMisuses: ["以为洛伦兹力会做功（它永远不做功）", "v 平行 B 时仍以为有力"],
            latex: "F = qvB\\sin\\theta"
        ),
        PhysicsLaw(
            id: "gravitation",
            name: "万有引力定律",
            topic: .circular,
            stage: .senior,
            expression: "F = GMm/r²",
            dimension: "N（G ≈ 6.67×10⁻¹¹ N·m²/kg²）",
            physicalImage: "任何两个有质量的物体都在互相吸引——连你和手机之间也有，只是太弱察觉不到。",
            meaning: "质量是引力之源，距离越远引力越弱（平方反比）。",
            limitChecks: [
                LimitCheck(scenario: "距离 r → 2 倍", result: "引力 → 1/4", intuition: "平方反比衰减极快，这就是近地与高轨卫星受力差别巨大的原因。"),
                LimitCheck(scenario: "其中一个质量 → 0", result: "引力 → 0", intuition: "没有质量就没有引力源——质量是引力的唯一通行证。"),
            ],
            conditions: ["质点或均匀球体", "r 为两球心间距", "对任何有质量物体成立"],
            commonMisuses: ["把 r 当成表面间距（应是球心间距）", "对非球对称物体直接套用"],
            latex: "F = G\\dfrac{Mm}{r^2}"
        ),
        PhysicsLaw(
            id: "circular_force",
            name: "向心力",
            topic: .circular,
            stage: .senior,
            expression: "F = mv²/r = mω²r",
            dimension: "N",
            physicalImage: "让物体拐弯的力，永远指向圆心——绳拉小球转圈，绳的拉力就是它。",
            meaning: "向心力是「效果命名」，由真实的力（张力 / 重力 / 摩擦 / 洛伦兹力）提供，不是额外的力。「为什么两边可以划等号」：mv²/r 是圆周运动所「需要」的向心力，真实力（如绳的张力）「提供」这个力——需要=提供，所以划等号。",
            limitChecks: [
                LimitCheck(scenario: "速度 v → 2 倍（半径不变）", result: "向心力 → 4 倍", intuition: "高速过弯特别危险，因为力随 v² 暴涨。"),
                LimitCheck(scenario: "半径 r → ∞", result: "向心力 → 0", intuition: "走直线不需要向心力——圆周与直线在此平滑统一。"),
            ],
            conditions: ["匀速圆周时向心力 = 合力", "一般圆周取合力指向圆心的分量"],
            commonMisuses: ["在受力图里额外画一个「向心力」", "把向心力当成新产生的力"],
            latex: "F = \\dfrac{mv^2}{r} = m\\omega^2 r"
        ),
        PhysicsLaw(
            id: "impulse",
            name: "动量定理",
            topic: .momentum,
            stage: .senior,
            expression: "Ft = mv₂ − mv₁",
            dimension: "N·s = kg·m/s",
            physicalImage: "同样改变动量，把时间拖长就能减小冲力——安全气囊、跳远落沙坑全靠它。",
            meaning: "合力的冲量等于动量的变化，矢量式。",
            limitChecks: [
                LimitCheck(scenario: "作用时间 t → 很长（缓冲）", result: "平均力 F → 很小", intuition: "气囊把碰撞时间拉长，冲力骤降——这就是保命的物理。"),
                LimitCheck(scenario: "作用时间 t → 0（硬碰）", result: "冲力 → 极大", intuition: "鸡蛋落地瞬间停下冲力大到碎；落到棉花上时间长就没事。"),
            ],
            conditions: ["适用于变力（用平均力或冲量）", "矢量式，注意方向"],
            commonMisuses: ["把冲量当成力", "漏掉矢量方向的正负"],
            latex: "\\vec{F}t = m\\vec{v}_2 - m\\vec{v}_1"
        ),
        PhysicsLaw(
            id: "coulomb",
            name: "库仑定律",
            topic: .electricField,
            stage: .senior,
            expression: "F = kq₁q₂/r²",
            dimension: "N（k ≈ 9×10⁹ N·m²/C²）",
            physicalImage: "电荷版的「万有引力」——同种相斥、异种相吸，同样是平方反比。",
            meaning: "点电荷间作用力与电量乘积成正比、与距离平方成反比。",
            limitChecks: [
                LimitCheck(scenario: "距离 r → 2 倍", result: "力 → 1/4", intuition: "和万有引力一样的平方反比，自然界两种基本力共用一个数学骨架。"),
                LimitCheck(scenario: "其中一个电荷 → 0", result: "力 → 0", intuition: "中性物体间没有库仑力（极化感应是进阶话题）。"),
            ],
            conditions: ["点电荷", "真空或空气中", "r 为电荷间距"],
            commonMisuses: ["对带电体（非点电荷）直接套用", "忘了力是矢量、要叠加"],
            latex: "F = k\\dfrac{q_1 q_2}{r^2}"
        ),
        PhysicsLaw(
            id: "ohm",
            name: "欧姆定律",
            topic: .circuit,
            stage: .senior,
            expression: "I = U/R",
            dimension: "A = V/Ω",
            physicalImage: "电压是「水压」、电流是「水流」、电阻是「水管粗细」——压越大流越快，管越细流越慢。",
            meaning: "电流正比于电压、反比于电阻。",
            limitChecks: [
                LimitCheck(scenario: "电阻 R → 2 倍（电压不变）", result: "电流 → 一半", intuition: "限流就靠加大电阻——反比关系一目了然。"),
                LimitCheck(scenario: "电阻 R → 0（短路）", result: "电流 → ∞（理论上）", intuition: "短路电流极大极危险，现实里被电源内阻和保险丝拦住。"),
            ],
            conditions: ["纯电阻、恒温", "金属导体", "U、I、R 对应同一段电路"],
            commonMisuses: ["对非线性元件（灯丝、二极管）套用", "U、I、R 张冠李戴"],
            latex: "I = \\dfrac{U}{R}"
        ),
        PhysicsLaw(
            id: "closed_circuit",
            name: "闭合电路欧姆定律",
            topic: .circuit,
            stage: .senior,
            expression: "E = I(R + r)，U端 = E − Ir",
            dimension: "V",
            physicalImage: "电源像个「带内耗的水泵」——电动势是它的总本事，内阻悄悄吃掉一部分。",
            meaning: "电动势等于内外电压之和；路端电压随电流增大而下降。",
            limitChecks: [
                LimitCheck(scenario: "外阻 R → ∞（断路）", result: "I→0，U端 → E", intuition: "断路时电压表读数约等于电动势。"),
                LimitCheck(scenario: "外阻 R → 0（短路）", result: "I → E/r（最大），U端 → 0", intuition: "短路电流由内阻决定，路端电压为零。"),
            ],
            conditions: ["闭合回路", "r 为电源内阻"],
            commonMisuses: ["忽略内阻", "把路端电压当成恒定电动势"],
            latex: "E = I(R+r),\\quad U_{\\text{端}} = E - Ir"
        ),
        PhysicsLaw(
            id: "ampere",
            name: "安培力",
            topic: .magnetic,
            stage: .senior,
            expression: "F = BIL·sinθ",
            dimension: "N",
            physicalImage: "磁场推「电流」的力——电动机转起来，就是无数根通电导线被磁场推动。",
            meaning: "磁场对通电导线的作用力，方向用左手定则：伸开左手，四指指电流方向，手心迎磁场方向（B穿入掌心），大拇指所指即安培力方向。θ=90°时最大，θ=0°时为零。",
            limitChecks: [
                LimitCheck(scenario: "电流方向平行磁场（θ=0）", result: "F = 0", intuition: "顺着磁场的电流不受力。"),
                LimitCheck(scenario: "电流垂直磁场（θ=90°）", result: "F = BIL（最大）", intuition: "电动机里导线都尽量垂直磁场摆放，力最大。"),
            ],
            conditions: ["θ 为电流与 B 的夹角", "匀强磁场中的直导线"],
            commonMisuses: ["与洛伦兹力公式混用", "左手定则方向判错"],
            latex: "F = BIL\\sin\\theta"
        ),
        PhysicsLaw(
            id: "faraday",
            name: "法拉第电磁感应定律",
            topic: .induction,
            stage: .senior,
            expression: "E = n·ΔΦ/Δt（切割式 E = BLv）",
            dimension: "V",
            physicalImage: "磁场「变化」才生电——磁铁插进线圈的那一下来电，停着不动就没电。",
            meaning: "感应电动势正比于磁通量的变化率，而不是磁通量本身。「为什么两边可以划等号」：E=BLv 中，E 是电动势（能量来源），后面接上电路 I=E/R，就可以算出安培力 F=BIL——这两个等号是「能量守恒」的体现。",
            limitChecks: [
                LimitCheck(scenario: "磁通量不变（ΔΦ=0）", result: "E = 0", intuition: "磁铁停在线圈里，再强也不来电——「变化」才是关键。"),
                LimitCheck(scenario: "变化越快（Δt → 小）", result: "E 越大", intuition: "发电机转得越快、磁铁抽插越急，电压越高。"),
            ],
            conditions: ["闭合回路", "Φ 为穿过回路的磁通量"],
            commonMisuses: ["把 E 与 Φ 划等号（应是变化率）", "漏掉匝数 n"],
            latex: "E = n\\dfrac{\\Delta\\Phi}{\\Delta t}\\quad (E = BLv)"
        ),
        PhysicsLaw(
            id: "gas_law",
            name: "理想气体状态方程",
            topic: .thermal,
            stage: .senior,
            expression: "pV/T = 常量",
            dimension: "pV 的量纲是能量 J",
            physicalImage: "一定量气体的「压强×体积÷温度」是个守恒的账本——挤小体积，压强或温度必涨。",
            meaning: "一定质量理想气体三个状态量之间的约束关系。",
            limitChecks: [
                LimitCheck(scenario: "体积 V → 一半（温度不变）", result: "压强 → 2 倍", intuition: "打气筒按下去，气体被压、压强升高。"),
                LimitCheck(scenario: "温度 T → 升高（体积不变）", result: "压强 → 升高", intuition: "密闭罐受热会爆，就是这个原因。"),
            ],
            conditions: ["一定质量、理想气体", "温度必须用开尔文 K", "三量同时只能定两个"],
            commonMisuses: ["温度误用摄氏度", "气体质量变化时套用"],
            latex: "\\dfrac{pV}{T} = \\text{常量}"
        ),
        PhysicsLaw(
            id: "photo_equation",
            name: "光电效应方程",
            topic: .modern,
            stage: .senior,
            expression: "Ek = hν − W₀",
            dimension: "J（或 eV）",
            physicalImage: "光子像一颗子弹，能量 hν 砸向电子；先付「逸出费」W₀，剩下的才变成电子的动能。",
            meaning: "光电子的最大初动能 = 光子能量 − 逸出功。",
            limitChecks: [
                LimitCheck(scenario: "频率 ν → 截止频率（hν=W₀）", result: "Ek → 0", intuition: "刚好够「付费」就能打出电子，但它跑不动。"),
                LimitCheck(scenario: "光强增大（频率不变）", result: "Ek 不变，只是电子更多", intuition: "光强管数量、频率管能量——光电效应的铁律。"),
            ],
            conditions: ["hν > W₀ 才发生", "W₀ 由金属种类决定"],
            commonMisuses: ["以为光强影响最大初动能", "用波动观点解释（解释不了截止频率）"],
            latex: "E_k = h\\nu - W_0"
        ),
        PhysicsLaw(
            id: "refraction",
            name: "折射定律",
            topic: .optics,
            stage: .senior,
            expression: "n = sinθ₁/sinθ₂；全反射 sinC = 1/n",
            dimension: "折射率 n 无量纲",
            physicalImage: "光进入更「密」的介质会变慢、并向法线偏折——像车斜着开进泥地，靠泥一侧先慢，车头就偏了。",
            meaning: "入射角与折射角正弦之比等于折射率，是光速比的体现。",
            limitChecks: [
                LimitCheck(scenario: "光密→光疏，入射角 > 临界角", result: "折射光消失，全反射", intuition: "光纤靠它把光锁在纤芯里，几乎无损耗地传输。"),
                LimitCheck(scenario: "入射角 → 0（垂直入射）", result: "折射角 → 0，不偏折", intuition: "正对着看水里的物体方向不变，只是显得浅。"),
            ],
            conditions: ["两种均匀介质的界面", "角度从法线量起"],
            commonMisuses: ["把全反射方向搞反（必须光密→光疏）", "角度误从界面量起"],
            latex: "n = \\dfrac{\\sin\\theta_1}{\\sin\\theta_2},\\quad \\sin C = \\dfrac{1}{n}"
        ),

        // ── 补充：牛顿第一/三定律（基础但常被跳过）──

        PhysicsLaw(
            id: "newton1_3",
            name: "牛顿第一/三定律",
            topic: .newton,
            stage: .senior,
            expression: "第一：合力=0→匀速/静止；第三：F₁₂ = −F₂₁",
            dimension: "N",
            physicalImage: "第一定律：物体「懒」，不愿改变自己的运动状态，除非有人逼它（施力）。第三定律：你推墙，墙也在推你——力总是成对的，大小相等、方向相反、作用在不同物体上。",
            meaning: "第一定律揭示了「惯性」的存在，定义了惯性参考系。第三定律说明内力不能改变系统总动量——这是动量守恒的根源。",
            limitChecks: [
                LimitCheck(scenario: "第三定律：大象推小老鼠", result: "力等大！但加速度不同（a=F/m）", intuition: "两者力相等，但质量不同，所以加速度不同。学生最常混淆「等力」和「等加速度」。"),
                LimitCheck(scenario: "第一定律：太空飞船关闭发动机", result: "继续匀速飞行（无摩擦）", intuition: "宇宙飞船关机不停——这是第一定律的最纯粹体现。"),
            ],
            conditions: ["第一定律在惯性参考系成立", "第三定律在任何参考系成立，且是瞬时的"],
            commonMisuses: [
                "「物体静止就是没有力」错！静止可以有多个力平衡",
                "作用力与反作用力不能抵消，因为作用在两个不同物体上",
                "「推车车动，车也推我」这对力不平衡——它们作用在不同物体上",
            ],
            latex: "\\vec{F}_{12} = -\\vec{F}_{21},\\quad \\sum \\vec{F} = 0 \\Rightarrow \\vec{v} = \\text{常量}"
        ),

        PhysicsLaw(
            id: "friction_hooke",
            name: "摩擦力与胡克定律",
            topic: .newton,
            stage: .senior,
            expression: "滑动摩擦：f=μN；弹力：F=kx",
            dimension: "N",
            physicalImage: "摩擦力是「粗糙」带来的阻力，大小和压力成正比。弹力是「形变」带来的恢复力，形变越大弹力越大——弹簧就是最直观的例子。",
            meaning: "摩擦力方向总是阻碍「相对运动（趋势）」；弹力方向总是指向「恢复原状」的方向。两者都是被动力，由其他条件决定大小。",
            limitChecks: [
                LimitCheck(scenario: "静摩擦力：物体静止、施力越来越大", result: "静摩擦力跟着增大，直到最大静摩擦 ≈ μN", intuition: "静摩擦力是「调节力」——能跟着变，但有上限。超过了才开始滑动。"),
                LimitCheck(scenario: "弹簧 k 很大（硬弹簧）", result: "同样的力形变很小", intuition: "钢板弹簧很硬（k大），压下去一点点；床垫弹簧很软（k小），一压就凹很多。"),
            ],
            conditions: [
                "f=μN：N 是法向力（不是重力！），斜面上 N=mg·cosθ",
                "胡克定律只在弹性限度内成立，超过就永久变形",
                "静摩擦最大值 ≈ 滑动摩擦力（略大），一般题目当相等处理",
            ],
            commonMisuses: [
                "把 N 当成重力 mg：斜面上 N=mgcosθ，不是 mg",
                "以为动摩擦力总阻碍运动——传送带上物体加速时摩擦力是动力",
                "胡克定律 F=kx 中 x 是「形变量」不是「总长度」",
            ],
            latex: "f = \\mu N,\\quad F = kx"
        ),

        PhysicsLaw(
            id: "work_power",
            name: "功与功率",
            topic: .energy,
            stage: .senior,
            expression: "W = Fs·cosθ；P = W/t = Fv",
            dimension: "W: J = N·m；P: W = J/s",
            physicalImage: "功是「有效的推力×移动距离」——用力推墙推不动，做功为零（位移为零）；垂直方向的力拎着重物水平走，做功也为零（力与位移垂直，cosθ=0）。功率是「做功的速度」，爬楼梯做同样的功，跑得快的功率大。",
            meaning: "功是「能量转移」的量度，有正有负。正功给系统加能量，负功取走能量。合外力做的功 = 动能变化（动能定理）。",
            limitChecks: [
                LimitCheck(scenario: "θ = 90°（力⊥位移）", result: "W = 0，力不做功", intuition: "向心力永远垂直速度，所以匀速圆周里向心力不做功——速率永远不变。"),
                LimitCheck(scenario: "P = Fv：速度增大", result: "若功率恒定，F 必须减小", intuition: "汽车加速过程：发动机功率恒定，速度越大，驱动力越小，最终 F=阻力时达到最大速度。"),
            ],
            conditions: [
                "W = Fscosθ 要求力和位移同一过程，不能混淆",
                "P = Fv 中 v 是力的作用点的速度（不是物体质心速度）",
                "变力做功只能用动能定理或图像面积",
            ],
            commonMisuses: [
                "用路程代替位移算功（功用位移，不用路程）",
                "合力做功才能用动能定理，不能对单个力用",
                "功率 P=UI（电功率）和机械功率 P=Fv 的单位都是 W",
            ],
            latex: "W = Fs\\cos\\theta,\\quad P = \\dfrac{W}{t} = Fv"
        ),

        PhysicsLaw(
            id: "magnetic_flux",
            name: "磁通量与楞次定律",
            topic: .induction,
            stage: .senior,
            expression: "Φ = BS·cosα；楞次：感应电流的磁场阻碍Φ变化",
            dimension: "Wb（韦伯）= T·m²",
            physicalImage: "磁通量 Φ 就是「穿过回路的磁力线条数」——面积越大、磁场越强、越正对磁场，穿过的线越多。楞次定律说：你想让磁通量增加，感应电流就「对抗」，产生反向磁场阻止它增加；你想减少，它就「守护」，产生同向磁场维持它。",
            meaning: "磁通量是电磁感应的「触发器」——Φ 变化才有感应电动势（法拉第定律 E=ΔΦ/Δt）。楞次定律给出感应电流方向，是判断方向的首选工具。",
            limitChecks: [
                LimitCheck(scenario: "线圈平面平行磁场（α=90°）", result: "Φ = 0，但转动时 ΔΦ/Δt 最大", intuition: "发电机这个位置电动势最大——磁通量为零但变化最快。"),
                LimitCheck(scenario: "磁铁靠近闭合线圈", result: "楞次：感应电流让线圈「推开」磁铁（阻碍靠近）", intuition: "感应电流像一个「守旧者」：永远阻止外界改变现状。"),
            ],
            conditions: [
                "α 是 B 与线圈平面「法线」的夹角（不是与平面的夹角）",
                "楞次定律判方向，法拉第定律算大小——二者配合使用",
                "只有闭合回路才能形成感应电流（开路只有电动势）",
            ],
            commonMisuses: [
                "把 α 理解为 B 与线圈平面的夹角（应是与法线的夹角，相差 90°）",
                "楞次定律不是「感应电流方向与磁通量相反」，而是阻碍变化",
                "导体棒切割磁感线用右手定则（不是楞次），两者不能混用",
            ],
            latex: "\\Phi = BS\\cos\\alpha,\\quad \\text{楞次：}I_{感}\\text{ 阻碍 }\\Delta\\Phi"
        ),

        PhysicsLaw(
            id: "cyclotron",
            name: "带电粒子在匀强磁场中的圆周运动",
            topic: .magnetic,
            stage: .senior,
            expression: "r = mv/(qB)；T = 2πm/(qB)",
            dimension: "r: m；T: s",
            physicalImage: "带电粒子进入磁场，洛伦兹力当向心力——它把粒子「掰弯」成圆。速度越快弯得越大（圆越大）；但周期 T 与速度完全无关，只由质量和磁场决定——这是回旋加速器能工作的秘密。",
            meaning: "半径正比于速度（动量）；周期只由 m/q 和 B 决定，与速度无关。「为什么两边可以划等号」：因为洛伦兹力恰好垂直速度、大小等于向心力所需值，两个表达式描述同一个力。",
            limitChecks: [
                LimitCheck(scenario: "磁场 B → 2 倍（v 不变）", result: "r → ½，T → ½", intuition: "磁场越强，粒子弯得越厉害，圆越小；同时转得越快。"),
                LimitCheck(scenario: "粒子速度 v → 2 倍", result: "r → 2 倍，T 不变", intuition: "速度快圆大，但圆的周长也大了，走得也快，时间刚好一样——这是等时性，回旋加速器就靠它。"),
            ],
            conditions: ["匀强磁场", "粒子速度远小于光速（否则相对论修正）", "v⊥B（若有平行分量则走螺旋线）"],
            commonMisuses: [
                "以为 v 大了 T 也大——T=2πm/qB 不含 v，周期恒定",
                "画受力图时把洛伦兹力画成「额外力」——洛伦兹力就是这里的向心力",
                "r=mv/qB 中 m 是粒子质量，q 是电荷量（不是电荷数）",
            ],
            latex: "r = \\dfrac{mv}{qB},\\quad T = \\dfrac{2\\pi m}{qB}"
        ),

        PhysicsLaw(
            id: "electric_power",
            name: "电功率",
            topic: .circuit,
            stage: .senior,
            expression: "P = UI = I²R = U²/R；电热：Q = I²Rt",
            dimension: "W = J/s",
            physicalImage: "电功率是「用电的速度」——同样一度电，电热丝几分钟用完，LED 灯泡能用好几个小时。P=UI 是普适公式；P=I²R 只用于纯电阻；Q=I²Rt 是焦耳定律（产热）。",
            meaning: "P=UI 对所有电器通用（含非线性元件）；P=I²R 和 P=U²/R 只适用于纯电阻。选哪个取决于「已知什么量」。",
            limitChecks: [
                LimitCheck(scenario: "电阻不变，电压 → 2 倍", result: "功率 → 4 倍（P=U²/R）", intuition: "220V 用电器接到 380V 上，功率变成 3 倍，分分钟烧掉。"),
                LimitCheck(scenario: "远距离输电：相同功率，提高电压", result: "电流减小，线路损耗 P热=I²R 大幅降低", intuition: "高压输电省电——这是变压器最重要的应用场景。"),
            ],
            conditions: [
                "P=I²R 要求纯电阻——灯泡是纯电阻，电动机不是",
                "电动机：输入 P=UI，机械输出 P机=UI-I²r，热损耗 Q=I²r",
                "Q=I²Rt 是产热（焦耳热），适合任何有电阻的器件",
            ],
            commonMisuses: [
                "电动机套用 P=U²/R 计算功率（电动机有反电动势，不是纯电阻）",
                "混淆「电功率」和「热功率」——只有纯电阻两者才相等",
                "串联和并联中求各元件功率，要先求通过的 U 或 I",
            ],
            latex: "P = UI = I^2R = \\dfrac{U^2}{R},\\quad Q = I^2Rt"
        ),

        // ── 以下为补充条目，覆盖降维快解与沙盘高频公式 ──

        PhysicsLaw(
            id: "kinematics",
            name: "匀变速运动三公式",
            topic: .kinematics,
            stage: .senior,
            expression: "v=v₀+at；s=v₀t+½at²；v²=v₀²+2as",
            dimension: "m/s, m, m/s²",
            physicalImage: "油门踩下去匀加速，速度表匀速往上走，走过的路程越来越多——三个公式是同一段运动从三个角度（速度/位移/无时）描述。",
            meaning: "只要 a 不变，这三条关系就成立。已知三个量求第四个——先挑不含无关量的那条公式。",
            limitChecks: [
                LimitCheck(scenario: "a = 0（匀速）", result: "s = v₀t，公式退化为匀速", intuition: "匀速是匀变速的特例，加速度为零时三条公式自动变成中学最基本的关系。"),
                LimitCheck(scenario: "v₀ = 0（从静止开始）", result: "s = ½at²", intuition: "自由落体就是这种情况：s∝t²，每秒走过的路程比是1:3:5:7……"),
            ],
            conditions: ["加速度 a 恒定不变", "取正方向要一致，方向与正方向相反的量取负值"],
            commonMisuses: [
                "v₀ 和 v 搞反（尤其是竖直上抛）",
                "忘记 a 有方向：减速时 a 与 v 反向，a 要取负",
                "三公式只适用于匀变速，变加速不能套",
            ],
            latex: "v = v_0 + at,\\quad s = v_0t + \\tfrac{1}{2}at^2,\\quad v^2 = v_0^2 + 2as"
        ),

        PhysicsLaw(
            id: "projectile",
            name: "平抛运动分解",
            topic: .kinematics,
            stage: .senior,
            expression: "x=v₀t；y=½gt²；v=√(vₓ²+vᵧ²)",
            dimension: "m, m/s",
            physicalImage: "从悬崖水平抛出一颗石子——水平方向它匀速飞，竖直方向它自由落，两个独立的运动叠加在一起就是抛物线。",
            meaning: "合运动 = 分运动的叠加。水平竖直互不干扰，用时间 t 联系两个方向。",
            limitChecks: [
                LimitCheck(scenario: "v₀ = 0（竖直下落）", result: "退化为自由落体 y=½gt²", intuition: "平抛是自由落体的推广——水平速度不影响竖直方向的下落时间。"),
                LimitCheck(scenario: "t 很小（刚离开手时）", result: "轨迹近似直线", intuition: "刚抛出的瞬间，重力还没来得及把它「拽弯」。"),
            ],
            conditions: ["只有重力做功（无空气阻力）", "初速水平", "斜抛时 vₓ=v₀cosθ, vᵧ₀=v₀sinθ"],
            commonMisuses: [
                "混淆水平和竖直公式（水平匀速，竖直才自由落体）",
                "飞行时间由竖直方向决定，与水平速度无关",
                "落地速度要用矢量合成，不能直接相加",
            ],
            latex: "x = v_0 t,\\quad y = \\tfrac{1}{2}gt^2,\\quad v = \\sqrt{v_x^2 + v_y^2}"
        ),

        PhysicsLaw(
            id: "shm_period",
            name: "简谐运动周期公式",
            topic: .wave,
            stage: .senior,
            expression: "弹簧：T=2π√(m/k)；单摆：T=2π√(L/g)",
            dimension: "s",
            physicalImage: "弹簧系统里，质量像「顽固」，弹簧劲度像「急性子」——越重越懒，越硬弹得越快；单摆则是摆长和重力之间的博弈。",
            meaning: "周期与振幅无关（等时性），只由系统的「惯性」和「回复力强度」决定。这是简谐运动最反直觉也最重要的结论。",
            limitChecks: [
                LimitCheck(scenario: "弹簧劲度 k → 很大", result: "T → 0（振得很快）", intuition: "超硬弹簧（如钢轨道）振动频率极高。"),
                LimitCheck(scenario: "摆长 L → 4 倍", result: "T → 2 倍", intuition: "T∝√L，摆长变四倍，周期才变两倍。"),
            ],
            conditions: ["小振幅（单摆 θ<5°）", "弹簧轻质、弹性限度内", "忽略阻尼"],
            commonMisuses: [
                "以为振幅大周期就大（等时性：振幅不影响周期）",
                "单摆在月球上周期变长（g 小，T=2π√(L/g) 变大）",
                "弹簧劲度 k 与弹簧长短有关：弹簧越短越硬",
            ],
            latex: "T = 2\\pi\\sqrt{\\dfrac{m}{k}},\\quad T = 2\\pi\\sqrt{\\dfrac{L}{g}}"
        ),

        PhysicsLaw(
            id: "electric_field",
            name: "电场强度公式",
            topic: .electricField,
            stage: .senior,
            expression: "E = F/q（定义式）；E = kQ/r²（点电荷）；E = U/d（匀强）",
            dimension: "N/C = V/m",
            physicalImage: "放一个正「探针电荷」q 进来，它受到多大力，那个力除以 q 就是电场强度——E 描述的是这块空间有多「电」，跟 q 无关。",
            meaning: "E 是场的性质，不依赖于探测电荷 q 的大小；E 的方向就是正电荷受力方向。",
            limitChecks: [
                LimitCheck(scenario: "平行板电容器 d→0（极板靠近）", result: "E=U/d → 无穷大", intuition: "同样电压，极板越近电场越强——击穿空气就靠这个原理。"),
                LimitCheck(scenario: "距点电荷 r→很远", result: "E→0", intuition: "电场随距离平方衰减，离得足够远就感受不到了。"),
            ],
            conditions: [
                "E=F/q 要用小探测电荷（不能影响源场）",
                "E=U/d 只在匀强电场（平行板间）成立",
                "E = kQ/r² 只适用于点电荷",
            ],
            commonMisuses: [
                "把 E=U/d 用在非匀强电场",
                "认为 q 越大 E 越大——E 与 q 无关",
                "方向：负电荷受力与 E 相反",
            ],
            latex: "E = \\dfrac{F}{q} = \\dfrac{kQ}{r^2} = \\dfrac{U}{d}"
        ),

        PhysicsLaw(
            id: "capacitor",
            name: "电容公式",
            topic: .electricField,
            stage: .senior,
            expression: "C = Q/U；平行板 C = ε₀S/d",
            dimension: "F（法拉）= C/V",
            physicalImage: "电容就是「储电量/电压」——同样的电压，塞进去的电荷越多，电容越大；平行板像两块充电的煎饼，越大越近越能「存电」。",
            meaning: "电容是「容量」，描述在单位电压下能存多少电荷，由几何结构决定，与 Q、U 无关。",
            limitChecks: [
                LimitCheck(scenario: "极板间距 d → 2 倍", result: "C → ½；若 Q 不变，U → 2 倍", intuition: "两极板离开，储电能力下降，电压升高。"),
                LimitCheck(scenario: "充电后断电（Q 不变），再增大 d", result: "C 减小，U=Q/C 升高，E=U/d 不变", intuition: "断电后 Q 被锁住，电场不变，但电压随间距增大——重要考点！"),
            ],
            conditions: ["C=ε₀S/d 只适用于平行板、真空/空气", "实际有介质时 C=εS/d"],
            commonMisuses: [
                "C=Q/U 中 C 不随 Q、U 变化（Q/U 的比值才是 C）",
                "「断电后」与「接电源」两种情境下动态分析结论完全不同",
                "C 越大不代表电场越强（E 由 U/d 决定）",
            ],
            latex: "C = \\dfrac{Q}{U} = \\dfrac{\\varepsilon_0 S}{d}"
        ),

        PhysicsLaw(
            id: "transformer",
            name: "理想变压器公式",
            topic: .induction,
            stage: .senior,
            expression: "U₁/U₂ = n₁/n₂；I₁/I₂ = n₂/n₁；P₁ = P₂",
            dimension: "U: V；I: A；P: W",
            physicalImage: "变压器是「力矩放大器」的电学版——匝数多的一侧电压高、电流小；匝数少的一侧电压低、电流大；功率不增不减，能量守恒。",
            meaning: "变压器改变的是电压和电流，不改变功率（理想条件下）。升压→降流，降压→升流。",
            limitChecks: [
                LimitCheck(scenario: "n₁=n₂（匝数相同）", result: "U₁=U₂，I₁=I₂，像导线直连", intuition: "1:1 变压器本质上不变，但可以起电气隔离作用。"),
                LimitCheck(scenario: "副线圈开路（I₂=0）", result: "I₁≈0，功率≈0", intuition: "空载变压器几乎不耗电——这是理想情况，实际有磁化损耗。"),
            ],
            conditions: ["理想变压器：无漏磁、线圈电阻为零、无铁损", "公式中 I₁/I₂=n₂/n₁ 仅在有负载时成立（开路时 I₁≠0 不适用）"],
            commonMisuses: [
                "开路时也套 I 的比值公式",
                "多副线圈时混用电流比（应分别对每个副线圈用 P 守恒）",
                "忘记升压变压器的初级匝数少、次级匝数多",
            ],
            latex: "\\dfrac{U_1}{U_2} = \\dfrac{n_1}{n_2},\\quad \\dfrac{I_1}{I_2} = \\dfrac{n_2}{n_1},\\quad P_1 = P_2"
        ),

        PhysicsLaw(
            id: "wave_speed",
            name: "波速公式",
            topic: .wave,
            stage: .senior,
            expression: "v = λf = λ/T",
            dimension: "m/s",
            physicalImage: "波是「形状」在空间里跑，不是介质在跑——浮在水面的软木塞只是上下抖，水波的「图案」却在向外传播。",
            meaning: "波速由介质决定（不由频率决定！）；频率由声源决定；波长是两者共同决定的结果。",
            limitChecks: [
                LimitCheck(scenario: "频率 f 升高（同一介质）", result: "v 不变，λ = v/f 减小", intuition: "同一根绳子，振得更快，波长变短，但波速不变——这是波动最反直觉的地方。"),
                LimitCheck(scenario: "声音从空气进入水", result: "v 增大，f 不变，λ 增大", intuition: "频率是声源决定的，不会因为介质变了而变——所以水里声音波长更长。"),
            ],
            conditions: ["机械波：v 由介质的弹性和密度决定", "电磁波：真空中 v=c=3×10⁸ m/s", "同一介质同一频率，v 与振幅无关"],
            commonMisuses: [
                "以为频率高波速就快（波速与频率无关）",
                "多普勒效应时频率变了，介质中波速没变",
                "v=λf 中的 v 和 λ 要在同一介质中取值",
            ],
            latex: "v = \\lambda f = \\dfrac{\\lambda}{T}"
        ),

        PhysicsLaw(
            id: "mass_energy",
            name: "质能方程",
            topic: .modern,
            stage: .senior,
            expression: "E = mc²；ΔE = Δmc²",
            dimension: "J；1 u = 931.5 MeV/c²",
            physicalImage: "质量就是「浓缩的能量」——一丁点质量亏损（原子核层面），乘以光速的平方（9×10¹⁶），就是巨大的能量。核电站发电与太阳发光，都来源于这个 c²。",
            meaning: "质量和能量是同一事物的两种度量，可以相互转化。核反应的能量来源就是反应前后的质量差。",
            limitChecks: [
                LimitCheck(scenario: "Δm = 1 u ≈ 1.66×10⁻²⁷ kg", result: "ΔE = Δmc² ≈ 931.5 MeV", intuition: "必记换算：1 u 的质量亏损对应 931.5 MeV 的能量。"),
                LimitCheck(scenario: "化学反应（原子层面）", result: "质量变化极小（10⁻¹²量级）", intuition: "化学反应也有质量亏损，但太小测不出来——只有核反应的亏损才显著。"),
            ],
            conditions: ["Δm 用原子质量单位 u 时，ΔE（MeV）= Δm(u) × 931.5", "核反应中质子数和中子数守恒，但不是质量守恒"],
            commonMisuses: [
                "把「质量数守恒」误以为「质量守恒」——核反应中真实质量（不是质量数）不守恒",
                "裂变/聚变都有质量亏损，但聚变亏损比例更大",
                "ΔE = Δmc² 中 c=3×10⁸ m/s，算出来单位是 J",
            ],
            latex: "E = mc^2,\\quad \\Delta E = \\Delta m \\cdot c^2"
        ),

        PhysicsLaw(
            id: "lens_formula",
            name: "薄透镜公式",
            topic: .optics,
            stage: .senior,
            expression: "1/u + 1/v = 1/f；放大率 m = v/u",
            dimension: "cm 或 m",
            physicalImage: "透镜让来自物点的发散光重新汇聚成像——物距（物到镜）和像距（像到镜）之间有严格的倒数关系，焦距是连接它们的桥梁。",
            meaning: "已知焦距和物距，就能算出成像位置。u=2f 时 v=2f（等大实像）；u<f 时 v 为负（虚像，正立放大）。",
            limitChecks: [
                LimitCheck(scenario: "u = f（物在焦点上）", result: "1/v = 0，v → ∞，平行光出射", intuition: "手电筒聚光——灯在焦点处，出射平行光束。"),
                LimitCheck(scenario: "u < f（物在焦点内）", result: "v 为负，虚像正立放大", intuition: "放大镜的原理：物比焦距近，像在同侧，正立放大。"),
            ],
            conditions: ["薄透镜近轴光线", "实物实像时 u>0, v>0；虚像 v<0", "凸透镜 f>0；凹透镜 f<0"],
            commonMisuses: [
                "搞混实像与虚像的符号规则",
                "凹透镜只成缩小正立虚像，不成实像",
                "放大率 m=v/u，m>1 放大，m<1 缩小，m 为负时倒立",
            ],
            latex: "\\dfrac{1}{u} + \\dfrac{1}{v} = \\dfrac{1}{f},\\quad m = \\dfrac{v}{u}"
        ),

        PhysicsLaw(
            id: "bohr_energy",
            name: "玻尔能级公式",
            topic: .modern,
            stage: .senior,
            expression: "Eₙ = E₁/n²（氢原子 E₁ = −13.6 eV）",
            dimension: "eV（电子伏）",
            physicalImage: "原子里的电子不能在任意轨道上待，只能在特定的「台阶」上——越往外台阶能量越高，跳下来就放出光子，跳上去就吸收光子，不多不少。",
            meaning: "氢原子能级是分立的，光谱线来自能级之间的跃迁，每根谱线对应一个固定的 ΔE=hν。",
            limitChecks: [
                LimitCheck(scenario: "n → ∞", result: "Eₙ → 0，电子逃出原子（电离）", intuition: "第 n 能级能量是 −13.6/n² eV，n 越大能量越趋近 0，直到脱离束缚。"),
                LimitCheck(scenario: "n=1 到 n=2（最低跃迁）", result: "ΔE=10.2 eV，紫外线", intuition: "氢原子最低能级跳到第二级需要 10.2eV，在紫外区——肉眼看不见。"),
            ],
            conditions: ["只对氢原子（单电子）精确适用", "多电子原子的能级更复杂", "辐射公式 hν=E高-E低"],
            commonMisuses: [
                "从高能级跳到低能级是辐射（放出光子），反之是吸收",
                "跃迁对应的光子能量 hν=|ΔE|，不是 E 本身",
                "第 n 能级的能量是负值（束缚态），越负越稳定",
            ],
            latex: "E_n = \\dfrac{E_1}{n^2},\\quad E_1 = -13.6\\,\\text{eV},\\quad h\\nu = E_m - E_n"
        ),

        // ── 查缺补漏第三批（8条）──

        PhysicsLaw(
            id: "electric_potential",
            name: "电势与电势能",
            topic: .electricField,
            stage: .senior,
            expression: "φ = W/q；EP = qφ；W_AB = q(φA−φB) = qEd",
            dimension: "φ: V = J/C；EP: J",
            physicalImage: "电势就像电场里的「海拔」——电荷从高电势流向低电势，就像水从高处流向低处。电势能是电荷「存」在那个位置的能量，移动时电场做功把它释放或储存。",
            meaning: "电场力做功只与起末位置有关（路径无关）——W_AB = EP_A − EP_B = q(φA−φB)。等势面上移动不做功；电场线从高电势指向低电势。",
            limitChecks: [
                LimitCheck(scenario: "正电荷从高电势移向低电势", result: "电场力做正功，EP 减小，动能增大", intuition: "就像石头从高处落下：势能转化为动能。正电荷「顺水流下」电场力做正功。"),
                LimitCheck(scenario: "负电荷从高电势移向低电势", result: "电场力做负功，EP 增大", intuition: "负电荷「逆水而行」——方向与电场力相反，做负功，势能反而增大。"),
            ],
            conditions: [
                "W=qEd 只在匀强电场中、d 为沿电场方向的分位移",
                "电势零点可任意选取（通常选无穷远或大地为零）",
                "正/负电荷势能符号不同，务必代入 q 的正负号",
            ],
            commonMisuses: [
                "把「电势高」和「电势能大」画等号——负电荷在高电势处势能反而小",
                "W=qEd 的 d 是沿 E 方向分位移，不是总路程或总位移",
                "等势面⊥电场线：沿等势面移动 W=0，不是 EP=0",
            ],
            latex: "\\varphi = \\dfrac{W}{q},\\quad W_{AB} = q(\\varphi_A - \\varphi_B) = qEd"
        ),

        PhysicsLaw(
            id: "kepler_satellite",
            name: "开普勒第三定律与卫星运动",
            topic: .circular,
            stage: .senior,
            expression: "T²/R³ = k；v = √(GM/r)；GM = gR²（黄金代换）",
            dimension: "T: s；R: m；v: m/s",
            physicalImage: "所有绕同一天体运行的卫星，轨道半径的立方与周期的平方之比是个常数——离得越远，转得越慢，但慢的程度有精确规律。黄金代换 GM=gR² 把「万有引力常数 G」和「天体质量 M」打包成地表重力 g，一次性消掉两个难测量。",
            meaning: "T²/R³=k 的 k 只取决于中心天体（太阳/地球），与卫星质量无关。k 越大说明中心天体越重。",
            limitChecks: [
                LimitCheck(scenario: "r → 2 倍", result: "T → 2√2 倍（≈2.83倍）", intuition: "T∝r^(3/2)：轨道半径翻倍，周期变成 2.83 倍，不是 2 倍。"),
                LimitCheck(scenario: "近地卫星 r≈R（地球半径）", result: "v₁=√(gR)≈7.9km/s（第一宇宙速度）", intuition: "黄金代换：v=√(GM/R)=√(gR²/R)=√(gR)——用 g 和 R 就能算出第一宇宙速度。"),
            ],
            conditions: [
                "k=4π²/GM，同一中心天体的所有卫星共用同一个 k",
                "GM=gR² 中 g 是天体表面重力加速度，R 是天体半径",
                "椭圆轨道 T²/a³=k 中 a 是半长轴",
            ],
            commonMisuses: [
                "比较不同天体系统的卫星时套用同一个 k（不同中心天体 k 不同）",
                "r 越大 v 越小（v∝1/√r），轨道越高速度越慢",
                "T²/R³=k 中 R 是轨道半径（圆心到卫星），不是离地面高度",
            ],
            latex: "\\dfrac{T^2}{R^3} = \\dfrac{4\\pi^2}{GM},\\quad v = \\sqrt{\\dfrac{GM}{r}},\\quad GM = gR^2"
        ),

        PhysicsLaw(
            id: "circular_kinematics",
            name: "圆周运动运动学量",
            topic: .circular,
            stage: .senior,
            expression: "v = ωr；ω = 2π/T = 2πf；a向 = v²/r = ω²r",
            dimension: "ω: rad/s；v: m/s；a: m/s²",
            physicalImage: "圆周运动里有三种「快慢」：线速度 v（弧长快慢）、角速度 ω（转角快慢）、周期 T（转一圈的时间）。它们之间有严格换算——就像同一个圆盘上，外圈线速度大但角速度和内圈一样。",
            meaning: "同一个物体：ω 和 T 描述转的快慢；v 还和半径有关。同轴转动时 ω 相同；皮带轮传动时 v 相同。向心加速度永远指向圆心，是速度「方向改变」的度量。",
            limitChecks: [
                LimitCheck(scenario: "同一圆盘：内圈 r₁ < 外圈 r₂", result: "ω 相同；v₁ < v₂（外圈线速度大）", intuition: "光盘边缘比中心「跑得快」，但它们「转得一样快」——v=ωr 一眼看清。"),
                LimitCheck(scenario: "皮带连接半径不同的两轮", result: "v 相同；ω 小轮大（r 小则 ω=v/r 大）", intuition: "皮带传动：大轮带小轮，小轮转得快（角速度大）。"),
            ],
            conditions: [
                "a向 = v²/r 只是向心加速度（改变方向）；若速率也变，还有切向加速度",
                "ω = 2πf = 2π/T 适用于匀速圆周",
                "v = ωr 中 r 是转动半径（到转轴的距离）",
            ],
            commonMisuses: [
                "向心加速度不是「合加速度」——变速圆周还有切向加速度",
                "皮带轮套 ω 相同（应套 v 相同）；同轴套 v 相同（应套 ω 相同）",
                "转速 n（转/秒）与角速度 ω：ω = 2πn",
            ],
            latex: "v = \\omega r,\\quad \\omega = \\dfrac{2\\pi}{T},\\quad a = \\dfrac{v^2}{r} = \\omega^2 r"
        ),

        PhysicsLaw(
            id: "series_parallel",
            name: "串并联电路规律",
            topic: .circuit,
            stage: .senior,
            expression: "串：R=ΣRᵢ，I同，U=ΣUᵢ；并：1/R=Σ(1/Rᵢ)，U同，I=ΣIᵢ",
            dimension: "Ω, A, V",
            physicalImage: "串联像水管首尾相连：同一股水（电流）依次经过，每段各分一份电压，总电阻叠加。并联像多条并排水管：两端电压相同，总电流分流，总电阻反而比任何单支都小。",
            meaning: "串联分压（U之比=R之比）；并联分流（I之比=1/R之比=G之比）。两个电阻并联：R并=R₁R₂/(R₁+R₂)，永远小于较小的那个。",
            limitChecks: [
                LimitCheck(scenario: "两个相等电阻 R 串联", result: "R总=2R，每个分一半电压", intuition: "两节相同电池串联：电压翻倍，容量不变——串联增压。"),
                LimitCheck(scenario: "两个相等电阻 R 并联", result: "R总=R/2，每支流一半电流", intuition: "并联增流——两路分流，总电阻反而减半。"),
            ],
            conditions: [
                "理想导线（电阻=0），理想电源（内阻=0）",
                "混联电路先化简：找「首尾相连无分叉」的串联段，找「同节点」的并联段",
                "串联时功率之比 = 电阻之比（P=I²R，I相同）",
                "并联时功率之比 = 1/电阻之比（P=U²/R，U相同）",
            ],
            commonMisuses: [
                "两电阻并联用 R₁+R₂ 当总电阻（串联才对，并联要用倒数）",
                "串联分压比=电阻比（不是电流比或功率比）",
                "并联中各支路电流之比=各电阻倒数之比（电导之比）",
            ],
            latex: "R_{串} = \\sum R_i,\\quad \\dfrac{1}{R_{并}} = \\sum \\dfrac{1}{R_i}"
        ),

        PhysicsLaw(
            id: "thermodynamics_first",
            name: "热力学第一定律",
            topic: .thermal,
            stage: .senior,
            expression: "ΔU = W + Q（W为外界对系统做的功，Q为吸收的热量）",
            dimension: "J",
            physicalImage: "内能的变化只有两种来源：「做功」（压缩/膨胀）和「传热」（加热/散热）——就像银行账户，收入来自工资（Q）和兼职（W），支出也是。做功是「有序」的能量转移；传热是「无序」的能量转移。",
            meaning: "三种特殊过程：①等温 ΔU=0，W+Q=0（气体膨胀必须吸热）；②绝热 Q=0，ΔU=W；③等容 W=0，ΔU=Q。内能变化=做功+传热，两者可以互换，但总量守恒。",
            limitChecks: [
                LimitCheck(scenario: "绝热压缩（Q=0）", result: "ΔU=W>0，内能增大，温度升高", intuition: "打气筒用力压，气体变热——没有传热，全靠做功升温。柴油发动机就用绝热压缩点火。"),
                LimitCheck(scenario: "等温膨胀（ΔU=0，理想气体）", result: "Q=-W，系统吸热全部用于对外做功", intuition: "理想气体等温膨胀：内能不变，但对外推活塞做了功，这些能量来自吸收的热量。"),
            ],
            conditions: [
                "ΔU=W+Q 中各量符号：ΔU>0 升温，W>0 外界压缩，Q>0 吸热",
                "理想气体内能只与温度有关，温度不变则 ΔU=0",
                "常考题型：已知两个量求第三个",
            ],
            commonMisuses: [
                "把「做功」和「传热」搞反符号（外界对系统做功 W>0，系统对外做功 W<0）",
                "以为「绝热」就是温度不变——绝热是不传热，温度完全可以变化",
                "混淆内能变化 ΔU（状态量）和热量 Q（过程量）",
            ],
            latex: "\\Delta U = W + Q"
        ),

        PhysicsLaw(
            id: "half_life",
            name: "放射性衰变与半衰期",
            topic: .modern,
            stage: .senior,
            expression: "N = N₀·(½)^(t/T½)；剩余比例 = (½)ⁿ（n 为半衰期个数）",
            dimension: "T½: s（或年）",
            physicalImage: "放射性原子核「不知疲倦地」按固定概率衰变——每过一个半衰期，剩下的一半；再过一个，再剩一半……就像人口每 30 年减半，规律严格，但到底谁先走完全随机。",
            meaning: "经过 n 个半衰期，剩余 N₀/2ⁿ，衰变了 N₀(1-1/2ⁿ)。T½ 由核种决定，不受温度、压强、化学状态影响——「物理」性质，不是「化学」性质。",
            limitChecks: [
                LimitCheck(scenario: "经过 1 个 T½", result: "剩 50%", intuition: "经过 2 个剩 25%，3 个剩 12.5%，10 个剩约 0.1%。"),
                LimitCheck(scenario: "t << T½（刚开始）", result: "N ≈ N₀（几乎没衰变）", intuition: "铀-238 半衰期 45 亿年，一天之内衰变量极少——放射源活度极低且稳定。"),
            ],
            conditions: [
                "T½ 是统计规律，对单个核无意义",
                "N 可指粒子数、质量、放射性活度（三者都按同比例衰减）",
                "考试通常取整数个半衰期，直接用 (½)ⁿ 即可",
            ],
            commonMisuses: [
                "经过 2 个半衰期剩 (1-2×50%)=0——错！剩 (1/2)²=25%，不是线性减少",
                "半衰期受外界影响（错，半衰期是核本身的性质）",
                "1 个 T½ 衰变「恰好一半」——是概率上的一半，单个核不适用",
            ],
            latex: "N = N_0 \\left(\\dfrac{1}{2}\\right)^{t/T_{1/2}}"
        ),

        PhysicsLaw(
            id: "particle_acceleration",
            name: "带电粒子加速与偏转",
            topic: .electricField,
            stage: .senior,
            expression: "加速：qU = ½mv²；偏转（类平抛）：y = qEL²/(2mv₀²)",
            dimension: "J, m",
            physicalImage: "电场对带电粒子是「发射台」（加速段）和「方向盘」（偏转段）的组合——示波管、电子枪、质谱仪都是这套组合的产品。加速段把电压全部转化为动能；偏转段像水平板间的平抛，电场力充当「重力」。",
            meaning: "加速电压 U 决定粒子速度；偏转场长度 L 和场强 E 决定偏转量 y。两段公式联立是阴极射线管、质谱仪题的标准解法。",
            limitChecks: [
                LimitCheck(scenario: "加速电压 U → 4 倍", result: "末速度 v → 2 倍（v∝√U）", intuition: "平方根关系：电压翻四倍速度翻两倍——不是线性的！"),
                LimitCheck(scenario: "偏转场场强 E → 2 倍（L 不变）", result: "偏转量 y → 2 倍", intuition: "电场越强「推」得越狠，偏转越大——线性关系。"),
            ],
            conditions: [
                "qU=½mv² 假设粒子从静止加速；若有初速则改为动能定理",
                "偏转公式 y = qEL²/(2mv₀²) 需代入加速后的 v₀",
                "忽略重力（带电粒子质量小，电场力远大于重力）",
            ],
            commonMisuses: [
                "加速后进入磁场时把 v 再算一遍（直接代入 qU=½mv² 算的 v 即可）",
                "偏转中竖直方向用 qE/m 加速，不是 g",
                "出偏转场后粒子做匀速直线运动（不再受力），不要继续算加速度",
            ],
            latex: "qU = \\dfrac{1}{2}mv^2,\\quad y = \\dfrac{qEL^2}{2mv_0^2}"
        ),

        PhysicsLaw(
            id: "friction_heat",
            name: "摩擦生热与能量守恒",
            topic: .energy,
            stage: .senior,
            expression: "Q摩 = f·Δs相对；ΔE机械 = −Q摩",
            dimension: "J",
            physicalImage: "摩擦生热的「原材料」是两个接触面的「相对滑动距离」——不是任何一个物体走了多远，而是它们互相「蹭」了多少。就算物体在运动，只要它们之间没有相对滑动，就不生热。",
            meaning: "「摩擦热」的关键是「相对位移」，不是「绝对位移」——这是滑块木板题、传送带题的核心公式，学生最容易搞错。",
            limitChecks: [
                LimitCheck(scenario: "人在传送带上静止（随带移动）", result: "Δs相对=0，Q=0，没有热量产生", intuition: "人和带步调一致，没有相互摩擦，当然不生热。"),
                LimitCheck(scenario: "滑块在木板上滑行后共速", result: "Q = f × (s滑块 − s木板)", intuition: "两者走的路程不一样，差值才是「蹭」的距离——用来算热量。"),
            ],
            conditions: [
                "f 是滑动摩擦力大小（不是静摩擦力）",
                "Δs相对 = 两物体「相对于彼此」滑动的距离，永远≥0",
                "能量守恒：损失的机械能 = Q = f·Δs相对，可以互相验算",
            ],
            commonMisuses: [
                "用「某一物体的位移」代替「相对位移」计算热量",
                "忘记考虑两个物体都在运动：Δs=|s₁−s₂|",
                "传送带问题中地面静止，传送带（s带）和物体（s物）的相对位移要分段算",
            ],
            latex: "Q_{摩} = f \\cdot \\Delta s_{相对},\\quad \\Delta E_{机械} = -Q_{摩}"
        ),
    ]

    static func laws(for topic: PhysicsTopic) -> [PhysicsLaw] {
        all.filter { $0.topic == topic }
    }
}
