import Foundation

// MARK: - 物理佯谬 / 思想实验 数据

enum ParadoxData {
    static let all: [Paradox] = [
        Paradox(
            id: "galileo_tower",
            title: "伽利略的轻重之争",
            category: .classic,
            hook: "重的物体真的下落得更快吗？一个纯思想就能证伪。",
            setup: "亚里士多德说：物体越重，下落越快。伽利略问：那把一个重球和一个轻球绑在一起呢？",
            theParadox: "按「重的快」，轻球会拖慢重球，整体应介于两者之间、比重球慢；但绑在一起总重更大，又该比重球更快。同一个系统得出两个相反结论——矛盾！",
            resolution: "唯一自洽的答案是：下落快慢与质量无关。忽略空气阻力，所有物体加速度都是 g。",
            takeaway: "好的思想实验不需要做实验，逻辑矛盾本身就是证据。",
            relatedGiants: ["galileo", "newton"]
        ),
        Paradox(
            id: "twin_paradox",
            title: "双生子佯谬",
            category: .relativity,
            hook: "坐飞船旅行的双胞胎，回来竟然更年轻？",
            setup: "一对双胞胎，一个乘接近光速的飞船远行后返回，另一个留在地球。",
            theParadox: "相对论说运动的钟变慢，所以飞船上的人更年轻。但运动是相对的——在飞船看来是地球在动，为何不是地球上的人更年轻？",
            resolution: "对称被打破了：飞船经历了加速/掉头（非惯性），两人处境不对称。掉头的那个确实更年轻。",
            takeaway: "相对性原理只对惯性系成立；谁加速谁'变年轻'。",
            relatedGiants: ["einstein"]
        ),
        Paradox(
            id: "maxwell_demon",
            title: "麦克斯韦妖",
            category: .thermo,
            hook: "一个小妖精能让热量自发从冷流向热？",
            setup: "一个分子级小妖把守隔板上的活门，只放快分子去一侧、慢分子去另一侧，似乎不费功就制造了温差。",
            theParadox: "这违反热力学第二定律——熵似乎自发减小了，永动机有戏？",
            resolution: "妖精要「测量并记忆」分子信息，擦除记忆必然耗散能量、增加熵。把妖也算进系统，总熵仍增加。",
            takeaway: "信息是有物理代价的——这是信息热力学的起点。",
            relatedGiants: ["maxwell"]
        ),
        Paradox(
            id: "schrodinger_cat",
            title: "薛定谔的猫",
            category: .quantum,
            hook: "一只猫可以同时又死又活？",
            setup: "盒中放猫、放射性原子、毒气瓶。原子衰变触发毒气。原子处于「衰变与未衰变」的叠加态。",
            theParadox: "若微观叠加成立，猫岂不是也处于「死+活」叠加？打开盒子前猫到底什么状态？",
            resolution: "宏观系统与环境强烈纠缠会迅速「退相干」，叠加态实际无法维持——这正是量子与经典的边界问题。",
            takeaway: "测量问题至今没有公认答案，它逼问「现实」的定义。",
            relatedGiants: ["feynman"]
        ),
        Paradox(
            id: "epr",
            title: "EPR 与量子纠缠",
            category: .quantum,
            hook: "测量这里的一个粒子，瞬间「决定」了一光年外另一个粒子？",
            setup: "一对纠缠粒子分飞两地。量子力学说，在你测量之前它们都没有确定的状态；可一旦测了其中一个，另一个的状态立刻被确定。",
            theParadox: "爱因斯坦称之为「鬼魅般的超距作用」，认为这违反相对论（信息不能超光速），主张背后一定有「隐变量」。",
            resolution: "贝尔不等式 + 实验（2022 诺奖）判定爱因斯坦错了：纠缠是真的，且不能用隐变量解释。但它并不传递信息，不违反相对论。",
            takeaway: "世界在最深处是「非定域」的——但宇宙仍守住了「信息不超光速」的底线。",
            relatedGiants: ["bohr"]
        ),
        Paradox(
            id: "olbers",
            title: "奥伯斯佯谬",
            category: .classic,
            hook: "如果宇宙无限大、恒星无限多，夜空为什么是黑的？",
            setup: "假设宇宙无限古老、无限大、恒星均匀分布。那么任何一个方向最终都该落在某颗恒星上，整片夜空都该像太阳表面一样亮。",
            theParadox: "可夜空明明是黑的。要么宇宙不是无限的，要么它不是永恒的——直觉和观测撞了车。",
            resolution: "宇宙有有限的年龄（约 138 亿年），远处恒星的光还没来得及到达；加上宇宙膨胀把远方的光红移变暗。",
            takeaway: "夜空的黑暗本身，就是宇宙有一个「开端」的证据。",
            relatedGiants: ["kepler"]
        ),
        Paradox(
            id: "time_arrow",
            title: "时间之箭",
            category: .thermo,
            hook: "物理定律大多不分过去未来，为什么时间只能向前？",
            setup: "把一段运动录像倒放，牛顿定律、电磁定律看起来都照样成立——微观世界几乎是「时间对称」的。",
            theParadox: "可现实里，杯子会摔碎却不会自动复原，热只从热流向冷。时间的方向感从哪来？",
            resolution: "答案在熵：孤立系统的熵只增不减（热力学第二定律）。「时间向前」= 熵增大的方向。",
            takeaway: "时间之箭不是写在运动定律里的，而是写在「无序总在增加」这条统计规律里。",
            relatedGiants: ["maxwell"]
        ),
    ]
}
