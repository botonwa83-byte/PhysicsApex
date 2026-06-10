import SwiftUI

// MARK: - 知识全景图数据：覆盖整个高考物理（完整骨架 + 精炼节点）

enum KnowledgeAtlas {
    static let modules: [KnowledgeModule] = [mechanics, electromagnetism, thermal, optics, modern]

    static var totalPoints: Int { modules.reduce(0) { $0 + $1.pointCount } }

    // MARK: 力学
    static let mechanics = KnowledgeModule(
        id: "mechanics", name: "力学", icon: "figure.run", color: .apexLava,
        chapters: [
            KnowledgeChapter(id: "kinematics", name: "运动的描述与直线运动", icon: "ruler", points: [
                KnowledgePoint("k_basic", "质点·参考系·位移", essence: "研究运动先选参考系；位移是矢量、路程是标量。", formula: "Δx = x₂ − x₁", problemId: "relative_motion", stage: .junior),
                KnowledgePoint("k_va", "速度·加速度", essence: "速度是位置变化率，加速度是速度变化率——和速度方向无必然关系。", formula: "v = Δx/Δt，a = Δv/Δt", problemId: "b1_accel_dir"),
                KnowledgePoint("k_uniform", "匀变速直线运动", essence: "三大公式串起 v、x、t、a；缺谁选谁。", formula: "v=v₀+at；x=v₀t+½at²；v²=v₀²+2ax", pitfall: "矢量正负方向先统一，再代数运算。", problemId: "b1_uniform_accel"),
                KnowledgePoint("k_graph", "v-t / x-t 图象", essence: "斜率是变化率，面积是累积量——图象法秒杀运动学。", weapon: .graphMethod, pitfall: "别把 x-t 图的斜率当加速度。", problemId: "b1_vt_graph"),
            ]),
            KnowledgeChapter(id: "force", name: "相互作用·力", icon: "arrow.up.and.down.and.arrow.left.and.right", points: [
                KnowledgePoint("f_gravity", "重力·弹力·摩擦力", essence: "三种常见力的来源与方向；弹力垂直接触面，摩擦力沿接触面。", formula: "G=mg；F弹=kx；f=μN", problemId: "b1_friction_dir", stage: .junior),
                KnowledgePoint("f_compose", "力的合成与分解", essence: "平行四边形定则；按效果或正交分解。", formula: "F=√(F₁²+F₂²+2F₁F₂cosθ)", problemId: "b2_conical"),
                KnowledgePoint("f_diagram", "受力分析", essence: "隔离 → 画力 → 正交分解，三步不漏力。", weapon: .forceDiagram, pitfall: "凭空捏造「运动方向的力」是最大坑。", problemId: "b1_incline_var"),
            ]),
            KnowledgeChapter(id: "newton", name: "牛顿运动定律", icon: "arrow.down.to.line", points: [
                KnowledgePoint("n_first", "惯性·牛顿第一定律", essence: "力是改变运动的原因，不是维持运动的原因。", problemId: "b1_uniform_motion", stage: .junior),
                KnowledgePoint("n_second", "牛顿第二定律", essence: "合外力决定加速度，方向一致。", formula: "F合 = ma", weapon: .forceDiagram, lawId: "newton2", problemId: "incline_senior"),
                KnowledgePoint("n_connect", "连接体·超重失重", essence: "整体法求加速度，隔离法求内力；视重随加速度变。", pitfall: "失重不是没有重力，是支持力小于重力。", problemId: "b1_connector"),
            ]),
            KnowledgeChapter(id: "curve", name: "曲线运动·平抛", icon: "scribble.variable", points: [
                KnowledgePoint("c_compose", "运动的合成与分解", essence: "复杂曲线运动拆成两个简单直线运动。", weapon: .graphMethod, problemId: "river_descent"),
                KnowledgePoint("c_projectile", "平抛运动", essence: "水平匀速 + 竖直自由落体，两方向独立。", formula: "x=v₀t；y=½gt²", pitfall: "下落时间只由高度定，与水平速度无关。", problemId: "projectile_junior"),
            ]),
            KnowledgeChapter(id: "circular", name: "圆周运动·万有引力", icon: "globe", points: [
                KnowledgePoint("ci_speed", "线速度·角速度·向心加速度", essence: "描述圆周运动的快慢。", formula: "v=ωr；a=v²/r=ω²r", problemId: "b2_centripetal"),
                KnowledgePoint("ci_force", "向心力", essence: "指向圆心的合力，由实际力提供，不是新的力。", formula: "F=mv²/r=mω²r", pitfall: "向心力是「效果命名」，别在受力图里额外多画一个。", lawId: "circular_force", problemId: "b2_cent_source"),
                KnowledgePoint("g_gravity", "万有引力·天体运动", essence: "引力提供向心力，黄金代换 GM=gR²。", formula: "GMm/r²=mv²/r；v=√(GM/r)", weapon: .equivalentMethod, lawId: "gravitation", problemId: "b2_central_mass"),
                KnowledgePoint("g_satellite", "宇宙速度·同步卫星", essence: "第一宇宙速度 7.9 km/s；同步卫星周期 24 h、定高。", formula: "v₁=7.9 km/s", problemId: "near_earth_sat"),
            ]),
            KnowledgeChapter(id: "momentum", name: "动量", icon: "arrow.left.arrow.right", points: [
                KnowledgePoint("m_impulse", "冲量·动量定理", essence: "合力的冲量等于动量的变化。", formula: "I=Ft；Ft=Δp", lawId: "impulse", problemId: "b2_buffer"),
                KnowledgePoint("m_conserve", "动量守恒定律", essence: "系统不受外力，碰前碰后总动量不变——只看首末态。", formula: "Σmv = 常量", weapon: .momentumConservation, lawId: "momentum_conservation", problemId: "collision_descent"),
                KnowledgePoint("m_collision", "碰撞", essence: "弹性碰撞动量动能都守恒；非弹性动能有损失。", weapon: .momentumConservation, pitfall: "完全非弹性碰撞别误用机械能守恒。", problemId: "b2_elastic"),
            ]),
            KnowledgeChapter(id: "energy", name: "功和能", icon: "bolt.fill", points: [
                KnowledgePoint("e_work", "功·功率", essence: "功是力沿位移的累积，功率是做功快慢。", formula: "W=Fscosθ；P=Fv", problemId: "b3_car_power"),
                KnowledgePoint("e_kinetic", "动能定理", essence: "合外力做的功等于动能变化——不管路径多曲折。", formula: "W合=½mv₂²−½mv₁²", weapon: .workEnergyTheorem, lawId: "work_energy", problemId: "work_energy_multi"),
                KnowledgePoint("e_mech", "机械能守恒", essence: "只有重力/弹力做功时，动能势能互换、总量不变。", formula: "Ek+Ep=常量", weapon: .mechanicalEnergy, lawId: "mechanical_energy", problemId: "b3_pendulum_e"),
                KnowledgePoint("e_conserve", "能量守恒·功能关系", essence: "能量不生不灭，摩擦生热 Q=f·Δs相对。", weapon: .energyIntuition, problemId: "b3_conveyor"),
            ]),
            KnowledgeChapter(id: "vibration", name: "机械振动与波", icon: "waveform.path", points: [
                KnowledgePoint("v_shm", "简谐运动·单摆", essence: "回复力正比于位移；单摆周期只与摆长重力有关。", formula: "T=2π√(L/g)", stage: .senior),
                KnowledgePoint("v_wave", "机械波·干涉衍射", essence: "波传递振动和能量，不传递介质；同频相干叠加。", formula: "v=λf"),
            ]),
        ])

    // MARK: 电磁学
    static let electromagnetism = KnowledgeModule(
        id: "em", name: "电磁学", icon: "bolt.horizontal.circle", color: .apexStarBlue,
        chapters: [
            KnowledgeChapter(id: "estatic", name: "静电场", icon: "e.circle", points: [
                KnowledgePoint("es_coulomb", "电荷·库仑定律", essence: "同种相斥异种相吸，力与距离平方成反比。", formula: "F=kq₁q₂/r²", lawId: "coulomb", problemId: "b4_coulomb"),
                KnowledgePoint("es_field", "电场强度·电场线", essence: "场强是单位电荷受力，电场线疏密表强弱。", formula: "E=F/q=kQ/r²", problemId: "electric_deflection"),
                KnowledgePoint("es_potential", "电势·电势差·电势能", essence: "沿电场线电势降低；电场力做功 W=qU。", formula: "U=W/q", pitfall: "电势是标量、有正负，别和场强方向混。", problemId: "b4_potential"),
                KnowledgePoint("es_cap", "电容器", essence: "储存电荷的元件；电容只由结构定。", formula: "C=Q/U", weapon: .equivalentCircuit, problemId: "b4_capacitor_q"),
            ]),
            KnowledgeChapter(id: "current", name: "恒定电流", icon: "minus.plus.batteryblock", points: [
                KnowledgePoint("cu_ohm", "欧姆定律·电阻定律", essence: "电流正比电压、反比电阻；电阻由材料尺寸定。", formula: "I=U/R；R=ρL/S", lawId: "ohm", problemId: "b4_ohm_basic"),
                KnowledgePoint("cu_power", "电功·电功率", essence: "电流做功转化能量；纯电阻 P=I²R=U²/R。", formula: "W=UIt；P=UI", problemId: "b4_elec_power"),
                KnowledgePoint("cu_closed", "闭合电路欧姆定律", essence: "电源电动势 = 内外电压之和。", formula: "E=I(R+r)", pitfall: "路端电压随电流增大而减小。", lawId: "closed_circuit", problemId: "b4_closed_circuit"),
                KnowledgePoint("cu_circuit", "串并联·电路分析", essence: "化繁为简，等效成一个电阻。", weapon: .equivalentCircuit, problemId: "b4_series_parallel"),
            ]),
            KnowledgeChapter(id: "magnetic", name: "磁场", icon: "magnet", points: [
                KnowledgePoint("mg_field", "磁感应强度·磁感线", essence: "B 描述磁场强弱方向；磁感线是闭合曲线。", formula: "B=F/(IL)", problemId: "b5_lorentz_r"),
                KnowledgePoint("mg_ampere", "安培力", essence: "磁场对电流的力，左手定则定方向。", formula: "F=BIL", lawId: "ampere", problemId: "b5_ampere_force"),
                KnowledgePoint("mg_lorentz", "洛伦兹力·粒子圆周", essence: "磁场只改变粒子方向不改变速率，做匀速圆周。", formula: "F=qvB；r=mv/qB", weapon: .symmetry, lawId: "lorentz", problemId: "magnetic_period"),
            ]),
            KnowledgeChapter(id: "induction", name: "电磁感应", icon: "wave.3.right", points: [
                KnowledgePoint("in_faraday", "法拉第电磁感应定律", essence: "磁通量变化率决定感应电动势大小。", formula: "E=nΔΦ/Δt", lawId: "faraday", problemId: "b5_faraday_emf"),
                KnowledgePoint("in_lenz", "楞次定律·切割", essence: "感应电流阻碍磁通量变化；切割 E=BLv。", formula: "E=BLv", weapon: .lenzRule, pitfall: "「阻碍」是阻碍变化，不是阻碍运动本身。", problemId: "rail_terminal"),
            ]),
            KnowledgeChapter(id: "ac", name: "交变电流", icon: "waveform.path.ecg", points: [
                KnowledgePoint("ac_sine", "正弦交流·峰值有效值", essence: "线圈匀速转动产生正弦交流；有效值按热效应定义。", formula: "U有效=U峰/√2", problemId: "b5_rms"),
                KnowledgePoint("ac_transformer", "变压器·输电", essence: "理想变压器电压比等于匝数比。", formula: "U₁/U₂=n₁/n₂", problemId: "b5_transformer"),
            ]),
        ])

    // MARK: 热学
    static let thermal = KnowledgeModule(
        id: "thermal", name: "热学", icon: "thermometer.medium", color: .apexGold,
        chapters: [
            KnowledgeChapter(id: "molecule", name: "分子动理论", icon: "circle.grid.3x3", points: [
                KnowledgePoint("mo_brown", "分子动理论·内能", essence: "物质由分子组成、永不停息运动；内能=分子动能+势能。", pitfall: "温度是分子平均动能标志，与分子数无关。", problemId: "internal_energy"),
            ]),
            KnowledgeChapter(id: "gas", name: "气体", icon: "wind", points: [
                KnowledgePoint("ga_law", "气体三定律·状态方程", essence: "压强微观来自分子碰壁；一定质量理想气体 pV/T 不变。", formula: "pV/T = 常量", weapon: .controlVariable, lawId: "gas_law", problemId: "b6_gas_state"),
            ]),
            KnowledgeChapter(id: "thermo", name: "热力学定律", icon: "flame", points: [
                KnowledgePoint("th_first", "热力学第一定律", essence: "内能变化 = 外界做的功 + 吸收的热。", formula: "ΔU=W+Q", problemId: "b6_first_law"),
                KnowledgePoint("th_second", "热力学第二定律", essence: "热自发地从高温流向低温，宏观过程有方向性。", pitfall: "并非否定能量守恒，而是约束过程方向。", problemId: "b6_second_law"),
            ]),
        ])

    // MARK: 光学
    static let optics = KnowledgeModule(
        id: "optics", name: "光学", icon: "rays", color: .apexEmerald,
        chapters: [
            KnowledgeChapter(id: "geo", name: "几何光学", icon: "light.min", points: [
                KnowledgePoint("ge_refract", "反射·折射·全反射", essence: "光从光密到光疏、入射角超临界角即全反射。", formula: "n=sinθ₁/sinθ₂；sinC=1/n", pitfall: "全反射只发生在光密→光疏方向。", lawId: "refraction", problemId: "total_reflection"),
            ]),
            KnowledgeChapter(id: "wave_optics", name: "物理光学", icon: "circle.hexagongrid", points: [
                KnowledgePoint("wo_interfere", "干涉·衍射·偏振", essence: "光是电磁波；相干光叠加出明暗条纹。", formula: "Δx=Lλ/d", weapon: .symmetry, problemId: "double_slit"),
            ]),
        ])

    // MARK: 近代物理
    static let modern = KnowledgeModule(
        id: "modern", name: "近代物理", icon: "atom", color: .apexMystery,
        chapters: [
            KnowledgeChapter(id: "photo", name: "光电效应", icon: "sun.max", points: [
                KnowledgePoint("ph_photon", "光子·光电效应", essence: "光以光子形式一份份传能；超过截止频率才有光电子。", formula: "Ek=hν−W₀", pitfall: "光强只影响电子数，不影响最大初动能。", lawId: "photo_equation", problemId: "photo_effect"),
            ]),
            KnowledgeChapter(id: "atom", name: "原子结构", icon: "circle.circle", points: [
                KnowledgePoint("at_bohr", "玻尔模型·能级跃迁", essence: "电子只能在分立轨道；跃迁辐射/吸收光子。", formula: "hν=Em−En", problemId: "b6_bohr_jump"),
            ]),
            KnowledgeChapter(id: "nucleus", name: "原子核", icon: "burst", points: [
                KnowledgePoint("nu_decay", "衰变·半衰期", essence: "α/β/γ 衰变；半衰期是统计规律。", pitfall: "半衰期由核本身决定，与温度压强无关。"),
                KnowledgePoint("nu_mass", "核反应·质能方程", essence: "质量亏损释放巨大能量；裂变聚变之源。", formula: "E=mc²", weapon: .dimensionalAnalysis, problemId: "b6_nuclear_energy"),
            ]),
        ])
}
