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
    ]
}
