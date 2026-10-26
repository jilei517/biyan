import 'package:biyan/data/image_urls.dart';
import 'package:biyan/models/banner_item.dart';
import 'package:biyan/models/diary_entry.dart';
import 'package:biyan/models/hobby_category.dart';
import 'package:biyan/models/memo_item.dart';
import 'package:biyan/models/outfit_item.dart';
import 'package:biyan/models/watched_movie.dart';

class AppData {
  AppData._();

  static const List<BannerItem> banners = [
    BannerItem(
      id: 1,
      title: '#早春通勤穿搭',
      subtitle: '温差大，外套别忘了',
      tag: 'OUTFIT TIPS',
      content:
          '早春天热天冷来回切，外套最好能随时脱掉。里面一件打底或薄针织，外面风衣或西装都行。裤子选直筒或阔腿，别穿太紧的牛仔裤，坐一天会难受。\n\n颜色别搞太花，米白、灰、浅蓝够用。想有点变化就换包或者耳环，衣服本身不用天天新买。',
      authorId: 'linxi',
      authorName: '林栖',
      image: ImageUrls.bannerCommute,
      tips: [
        BannerTip(
          title: '三层叠穿法',
          desc: '内搭 + 针织开衫 + 风衣，随时增减，地铁里热、室外凉都不怕。',
        ),
        BannerTip(
          title: '鞋履选低跟乐福',
          desc: '3cm 左右的乐福鞋或玛丽珍，舒适通勤一整天，配袜套更有层次感。',
        ),
        BannerTip(
          title: '一只通勤大包',
          desc: '能装下电脑和补妆品的托特包是刚需，选皮质或帆布都好看。',
        ),
      ],
      moreItems: [
        BannerMoreItem(
          title: '衬衫的五种穿法',
          summary: '塞进裤腰、打结、当外套…一件白衬衫玩出花样',
          content:
              '① 全塞：利落正式，适合会议日；② 前塞后放：随性显瘦；③ 下摆打结：配高腰裤显腿长；④ 敞开当薄外套：内搭吊带或背心；⑤ 袖口挽两圈：瞬间松弛感。早春选棉质或天丝面料，透气不闷。',
        ),
        BannerMoreItem(
          title: '职场配色安全牌',
          summary: '黑白灰之外，这些颜色同样专业耐看',
          content:
              '藏蓝、驼色、烟灰粉都是职场友好色。全身不超过三种颜色，主色占 60%、辅助色 30%、点缀色 10%。避免大面积荧光或过于跳跃的撞色，用丝巾或胸针做小面积提亮就够了。',
        ),
        BannerMoreItem(
          title: '早八快速出门公式',
          summary: '5 分钟搞定体面出门的懒人方案',
          content:
              '前一晚把第二天要穿的衣服挂好，配饰放一起。公式：基础内搭 + 万能下装 + 一件外套 + 一双好走的鞋。妆容可以只画眉毛和口红，发型用鲨鱼夹或低马尾，三分钟也能很精致。',
        ),
      ],
    ),
    BannerItem(
      id: 2,
      title: '#胶囊衣橱计划',
      subtitle: '五件单品搭出七天不重样',
      tag: 'STYLE GUIDE',
      content:
          '胶囊衣橱不是穿得少，而是穿得精。选 5–7 件能互相搭配的单品，用组合代替囤积，衣柜清爽、出门也不纠结。\n\n周末胶囊推荐：一条好版型牛仔裤、一件 Oversize 针织、纯色 T 恤、轻薄风衣、小白鞋。这五样可以搭出逛街、咖啡、看展、短途旅行等多种场景，拍照也上镜。',
      authorId: 'momo',
      authorName: '莫莫',
      image: ImageUrls.bannerCapsule,
      tips: [
        BannerTip(
          title: '牛仔裤是万能底',
          desc: '直筒或微喇版型最百搭，深蓝比浅蓝更显瘦、也更耐脏。',
        ),
        BannerTip(
          title: '针织当披肩',
          desc: '冷的时候搭肩上或系腰间，比多带一件外套更轻便。',
        ),
        BannerTip(
          title: '小白鞋走天下',
          desc: '干净的小白鞋能中和任何风格，脏了就用湿巾擦一擦。',
        ),
      ],
      moreItems: [
        BannerMoreItem(
          title: '周末七天穿搭表',
          summary: '同一批单品，每天换一种组合',
          content:
              'Day1：T 恤 + 牛仔裤 + 小白鞋；Day2：针织 + 牛仔裤 + 乐福鞋；Day3：连衣裙 + 风衣；Day4：T 恤叠针织 + 半裙；Day5：衬衫 + 牛仔裤；Day6：运动风卫衣 + 阔腿裤；Day7：约会裙 + 薄外套。每件单品至少出现两次，才算合格的胶囊衣橱。',
        ),
        BannerMoreItem(
          title: '断舍离三问法则',
          summary: '买新衣服前，先问自己这三个问题',
          content:
              '① 它能和我衣柜里至少三件单品搭配吗？② 我过去一年会穿它超过 10 次吗？③ 如果没有折扣，我还会买吗？三问都答「是」再入手，能大幅减少冲动消费和闲置衣物。',
        ),
        BannerMoreItem(
          title: '配饰点睛术',
          summary: '少买衣服，多用配饰换风格',
          content:
              '同一套基础穿搭，换帽子、包包、项链或墨镜，气质完全不同。建议常备：草编帽（度假风）、棒球帽（休闲风）、金属链条包（酷感）、帆布托特（文艺风）。配饰不占地方，却能无限扩展造型可能。',
        ),
      ],
    ),
    BannerItem(
      id: 3,
      title: '#色彩搭配法则',
      subtitle: '拒绝沉闷，点亮日常造型',
      tag: 'COLOR MIX',
      content:
          '穿搭怕乱，先从配色入手。最稳妥的是「同色系渐变」：深浅不同的同一颜色叠穿，高级又不费力。想出彩可以试试互补色小面积点缀，比如蓝 + 橙的丝巾、绿 + 粉的袜子，主体仍保持中性色。\n\n记住 60-30-10 法则：主色占六成（外套或大身），辅助色三成（下装或内搭），点缀色一成（配饰）。这样全身有重点，又不会像打翻调色盘。',
      authorId: 'kai',
      authorName: '阿凯',
      image: ImageUrls.bannerColor,
      tips: [
        BannerTip(
          title: '同色系最省心',
          desc: '卡其 + 米色 + 焦糖，温柔耐看，适合初次尝试配色的人。',
        ),
        BannerTip(
          title: '黑白灰永不过时',
          desc: '经典三色打底，再用一个亮色包包或鞋子提亮即可。',
        ),
        BannerTip(
          title: '肤色决定色调',
          desc: '暖皮适合杏色、珊瑚色；冷皮适合灰蓝、莓果色，穿对了显白。',
        ),
      ],
      moreItems: [
        BannerMoreItem(
          title: '四季代表色参考',
          summary: '按季节选色，氛围感自然来',
          content:
              '春：薄荷绿、樱花粉、浅鹅黄；夏：海盐蓝、纯白、柠檬黄；秋：南瓜橙、酒红、焦糖棕；冬：雾灰、藏蓝、燕麦白。不必全身季节色，一件单品呼应季节就够有仪式感。',
        ),
        BannerMoreItem(
          title: '撞色不踩雷指南',
          summary: '大胆配色也能穿得好看',
          content:
              '降低饱和度是关键：选莫兰迪色系的撞色，比如灰粉 + 灰绿、雾霾蓝 + 脏橘。撞色面积控制在 10% 以内，其余用黑白灰托底。新手可以从袜子、发夹、手机壳这些小物件开始尝试。',
        ),
        BannerMoreItem(
          title: '约会穿搭配色',
          summary: '温柔又不失存在感的约会色盘',
          content:
              '推荐组合：奶油白连衣裙 + 裸粉开衫；浅蓝衬衫 + 白色半裙 + 棕色腰带；碎花裙 + 纯色针织外搭。避免全身深色或过于花哨的印花，柔和色调更容易营造亲近感。',
        ),
      ],
    ),
  ];

  static const List<OutfitItem> outfits = [
    OutfitItem(
      id: 1,
      style: '通勤简约风',
      desc: '白衬衫配阔腿裤，开会穿这个基本不会出错。',
      tags: ['职场', '干练'],
      brand: 'ZARA / UNIQLO',
      authorId: 'linxi',
      authorName: '林栖',
      image: 'assets/images/img_a.jpg',
      content:
          '这套搭配的核心在于「干净线条 + 适度留白」。白色衬衫选择略微宽松的版型，既能藏住久坐的小赘肉，又不会显得邋遢；高腰阔腿裤拉长腿部比例，走路带风的同时保持专业感。整体色调控制在白、米、浅棕三色以内，是初入职场最不容易出错的选择。',
      items: ['白色宽松衬衫', '高腰西装阔腿裤', '浅棕色乐福鞋', '简约金属腕表'],
      scene: '日常通勤 · 会议汇报 · 客户拜访',
      tips: [
        OutfitTip(
          title: '上松下紧',
          desc: '衬衫选宽松款，裤装选直筒或阔腿，避免全身都贴身，更显从容大气。',
        ),
        OutfitTip(
          title: '色彩克制',
          desc: '全身不超过三种颜色，以白、米、浅棕为主，避免过于跳跃的亮色。',
        ),
        OutfitTip(
          title: '配饰点睛',
          desc: '一块简约腕表或细链项链即可，切忌堆砌过多饰品，保持职场专业感。',
        ),
      ],
    ),
    OutfitItem(
      id: 2,
      style: '周末休闲',
      desc: 'Oversize T恤 + 牛仔裙，舒适度满分，适合和朋友去逛街喝咖啡。',
      tags: ['舒适', '街头'],
      brand: 'Urban Outfitters',
      authorId: 'momo',
      authorName: '莫莫',
      image: 'assets/images/img_b.jpg',
      content:
          '周末穿搭的秘诀是「看起来随意，其实有细节」。Oversize T恤塞进牛仔半裙里，制造高腰线；牛仔裙选 A 字或直筒款，对身材包容度高。配一双小白鞋或帆布鞋，再加一个帆布托特包，整套 Look 轻松完成，逛一整天也不累脚。',
      items: ['Oversize 纯棉 T 恤', '高腰牛仔半裙', '白色帆布鞋', '帆布托特包'],
      scene: '逛街购物 · 咖啡下午茶 · 城市漫步',
      tips: [
        OutfitTip(
          title: '塞衣角提腰线',
          desc: '宽松上衣前短后长或只塞一侧衣角，比全塞更随性，还能显腿长。',
        ),
        OutfitTip(
          title: '牛仔选浅水洗',
          desc: '春夏选浅蓝或中蓝水洗，比深色更清爽，和白色 T 恤是经典组合。',
        ),
        OutfitTip(
          title: '帽子加分',
          desc: '棒球帽或渔夫帽既能遮阳，又能增加街头感，是周末出街的万能单品。',
        ),
      ],
    ),
    OutfitItem(
      id: 3,
      style: '运动活力',
      desc: '瑜伽服 + 运动外套，随时准备去健身房挥洒汗水。',
      tags: ['健身', '户外'],
      brand: 'Lululemon',
      authorId: 'kai',
      authorName: '阿凯',
      image: 'assets/images/img_c.jpg',
      content:
          '运动穿搭不仅要好看，更要兼顾功能性。高弹力瑜伽裤贴合腿部线条，运动时无束缚感；运动内衣提供足够支撑，外搭一件轻薄拉链外套，热身时可脱可穿。选透气速干面料，出汗后也能快速干爽，从健身房到便利店买水都能自信出镜。',
      items: ['高弹力瑜伽裤', '运动内衣', '轻薄拉链外套', '缓震跑鞋'],
      scene: '健身房 · 户外跑步 · 瑜伽课程',
      tips: [
        OutfitTip(
          title: '面料选速干',
          desc: '聚酯纤维混纺或专业运动面料，吸湿排汗，避免纯棉湿透贴身。',
        ),
        OutfitTip(
          title: '颜色可以亮一点',
          desc: '运动场景适合尝试珊瑚粉、薄荷绿等活力色，提升运动动力。',
        ),
        OutfitTip(
          title: '外套必备',
          desc: '运动前后体温变化大，一件轻薄外套既能保暖，也方便搭配出街。',
        ),
      ],
    ),
    OutfitItem(
      id: 4,
      style: '约会甜美',
      desc: '一条剪裁得体的碎花连衣裙，搭配微卷长发，心动满分。',
      tags: ['心动', '温柔'],
      brand: 'UR',
      authorId: 'momo',
      authorName: '莫莫',
      image: 'assets/images/img_d.jpg',
      content:
          '约会别穿得像去面试。碎花裙可以，花别太大。腰上有收口的更好穿。鞋子选能走路的，别一上来就恨天高。妆淡一点就行，别搞得不像本人。',
      items: ['小碎花收腰连衣裙', '裸色细带凉鞋', '珍珠耳钉', '迷你链条包'],
      scene: '浪漫晚餐 · 看展约会 · 公园散步',
      tips: [
        OutfitTip(
          title: '碎花要小要疏',
          desc: '小碎花、间距疏的款式更显瘦显气质，密集大印花容易显土显胖。',
        ),
        OutfitTip(
          title: '露肤要克制',
          desc: '锁骨、手腕、脚踝选一处点缀即可，避免过度暴露，保持优雅感。',
        ),
        OutfitTip(
          title: '发型是加分项',
          desc: '微卷披发或低马尾配碎发，比扎高马尾更温柔，和碎花裙绝配。',
        ),
      ],
    ),
    OutfitItem(
      id: 5,
      style: '法式优雅',
      desc: '条纹衫 + 九分烟管裤，慵懒中透着精致，巴黎女孩的经典日常。',
      tags: ['法式', '优雅'],
      brand: 'Sandro / Maje',
      authorId: 'linxi',
      authorName: '林栖',
      image: 'assets/images/img_e.jpg',
      content:
          '法式穿搭的精髓是「毫不费力的精致」。海军条纹衫是永恒单品，搭配九分烟管裤和芭蕾平底鞋，简约却高级。配色以 navy、白、米、红为主，一条红色丝巾或口红就能点亮全身。不必追求名牌堆砌，质感面料和合适剪裁才是关键。',
      items: ['海军条纹针织衫', '九分烟管裤', '芭蕾平底鞋', '草编手提包'],
      scene: 'brunch 早午餐 · 艺术展览 · 塞纳河畔散步',
      tips: [
        OutfitTip(
          title: '条纹选细不选粗',
          desc: '细条纹更显瘦显精致，粗条纹容易显臃肿，间距适中最经典。',
        ),
        OutfitTip(
          title: '露脚踝显轻盈',
          desc: '九分裤配浅口鞋，露出一截脚踝是法式穿搭的标志性细节。',
        ),
        OutfitTip(
          title: '丝巾万能点缀',
          desc: '系在包带上、当发带或围在颈间，一条丝巾就能提升整体法式感。',
        ),
      ],
    ),
    OutfitItem(
      id: 6,
      style: '秋冬叠穿',
      desc: '针织开衫 + 高领打底 + 大衣，层次感满分，保暖又时髦。',
      tags: ['叠穿', '保暖'],
      brand: 'COS / Massimo Dutti',
      authorId: 'linxi',
      authorName: '林栖',
      image: 'assets/images/img_k.jpg',
      content:
          '秋冬穿搭的灵魂是「层次」。内层选贴身高领打底，中层用针织开衫或马甲制造厚度，外层一件质感大衣收尾。颜色遵循「内浅外深」或「同色系渐变」，避免每层都花哨。围巾和手套既是保暖刚需，也是提升氛围感的利器。',
      items: ['高领打底衫', '羊毛针织开衫', '中长款大衣', '羊绒围巾'],
      scene: '秋冬通勤 · 周末市集 · 咖啡馆阅读',
      tips: [
        OutfitTip(
          title: '三层法则',
          desc: '内薄外厚、内紧外松，三层以内最利落，超过四层容易显臃肿。',
        ),
        OutfitTip(
          title: '材质要有对比',
          desc: '针织 + 羊毛 + 皮革的组合，不同材质碰撞更有高级感。',
        ),
        OutfitTip(
          title: '围巾系法多变',
          desc: '巴黎结、绕颈结或随意搭肩，一条围巾能换出三种不同风格。',
        ),
      ],
    ),
    OutfitItem(
      id: 7,
      style: '度假风情',
      desc: '亚麻连衣裙 + 草编包 + 凉拖，海风与阳光的最佳拍档。',
      tags: ['度假', '清爽'],
      brand: 'Zara / H&M',
      authorId: 'momo',
      authorName: '莫莫',
      image: 'assets/images/img_l.jpg',
      content:
          '度假穿搭追求「轻松自在」。亚麻或棉质连衣裙透气又上镜，选白色、天蓝、姜黄等度假色系。草编包和凉拖是标配，再戴一副墨镜和宽檐帽，防晒的同时轻松出片。记得选有口袋的款式，方便装手机和海边小物。',
      items: ['亚麻吊带连衣裙', '草编托特包', '平底凉拖', '宽檐遮阳帽'],
      scene: '海边度假 · 热带旅行 · 泳池派对',
      tips: [
        OutfitTip(
          title: '选天然面料',
          desc: '亚麻、棉麻混纺透气吸汗，比化纤更适合高温高湿的度假环境。',
        ),
        OutfitTip(
          title: '亮色大胆尝试',
          desc: '度假是少数可以全身亮色的场景，姜黄、珊瑚橙都很出片。',
        ),
        OutfitTip(
          title: '一件式最省心',
          desc: '连衣裙比上下分装更方便，赶早班机或换场景时不用纠结搭配。',
        ),
      ],
    ),
    OutfitItem(
      id: 8,
      style: '极简黑白',
      desc: '黑色西装 + 白色内搭，永不过时的高级感，少即是多。',
      tags: ['极简', '高级'],
      brand: 'Theory / Toteme',
      authorId: 'linxi',
      authorName: '林栖',
      image: 'assets/images/img_m.jpg',
      content:
          '极简黑白是衣橱的「定海神针」。剪裁精良的黑色西装或西裤，搭配质感白 T 或丝质衬衫，不需要多余装饰。关键在于面料和版型——选有垂坠感的羊毛混纺或精纺棉，避免廉价反光。一只结构感手袋和干净的白鞋完成整套 Look。',
      items: ['黑色修身西装', '白色丝质衬衫', '黑色直筒西裤', '白色皮革小白鞋'],
      scene: '重要会议 · 品牌活动 · 都市街拍',
      tips: [
        OutfitTip(
          title: '黑白要有层次',
          desc: '全黑时用不同材质区分，如哑光西装配亮面皮鞋，避免一片死黑。',
        ),
        OutfitTip(
          title: '投资经典款',
          desc: '黑白极简靠剪裁说话，宁可少买几件，也要选版型最好的那一件。',
        ),
        OutfitTip(
          title: '金属配饰点睛',
          desc: '金银首饰或方形手表，在黑白基调上增加精致细节而不破坏极简感。',
        ),
      ],
    ),
    OutfitItem(
      id: 9,
      style: '学院复古',
      desc: '格纹半裙 + 针织背心 + 乐福鞋，重返校园的文艺气息。',
      tags: ['学院', '复古'],
      brand: 'Ralph Lauren / Brooks Brothers',
      authorId: 'kai',
      authorName: '阿凯',
      image: 'assets/images/img_n.jpg',
      content:
          '学院风自带书卷气和减龄效果。格纹半裙或百褶裙是核心单品，搭配针织背心和白衬衫，再踩一双乐福鞋。配色以酒红、藏蓝、墨绿等深色系为主，金色纽扣和徽章细节增加复古感。适合图书馆、校园参观或文艺市集。',
      items: ['格纹百褶半裙', '针织 V 领背心', '白色牛津衬衫', '棕色乐福鞋'],
      scene: '校园参观 · 书店阅读 · 文艺市集',
      tips: [
        OutfitTip(
          title: '格纹大小有讲究',
          desc: '小格纹显精致，大格纹更复古，身高娇小选小格更友好。',
        ),
        OutfitTip(
          title: '叠穿制造层次',
          desc: '衬衫 + 背心 + 外套的三层叠穿，是学院风的经典公式。',
        ),
        OutfitTip(
          title: '袜子也是细节',
          desc: '白色短袜配乐福鞋，或及膝袜配玛丽珍，学院感立刻拉满。',
        ),
      ],
    ),
    OutfitItem(
      id: 10,
      style: '街头酷感',
      desc: '皮夹克 + 工装裤 + 马丁靴，又飒又 A 的都市女孩态度。',
      tags: ['街头', '酷飒'],
      brand: 'AllSaints / Dr. Martens',
      authorId: 'kai',
      authorName: '阿凯',
      image: 'assets/images/img_o.jpg',
      content:
          '街头酷感强调「态度与个性」。短款皮夹克是灵魂单品，内搭简约黑 T 或连帽卫衣，下装选工装裤或破洞牛仔裤。马丁靴或厚底运动鞋增加气场，再配一条金属链条项链或棒球帽，整套 Look 又酷又有辨识度。',
      items: ['短款黑色皮夹克', '黑色工装裤', '马丁靴', '金属链条项链'],
      scene: 'Livehouse · 潮流市集 · 城市夜骑',
      tips: [
        OutfitTip(
          title: '上短下长显比例',
          desc: '短款夹克 + 高腰裤/工装裤，拉长腿部线条，是小个子的酷感秘诀。',
        ),
        OutfitTip(
          title: '全黑要有材质差',
          desc: '皮革、棉质、金属混搭，全黑也不沉闷，反而更有层次。',
        ),
        OutfitTip(
          title: '一个亮点就够',
          desc: '链条、徽章或彩色袜子选一处强调，避免堆砌过多街头元素显乱。',
        ),
      ],
    ),
  ];

  static const List<String> defaultSelectedHobbies = [
    '冲浪',
    '烧烤',
    '看电影',
    '肖申克的救赎',
  ];

  static const List<String> defaultCustomTags = [
    '滑雪',
    '冲浪',
    '肖申克的救赎',
  ];

  static const List<HobbyCategory> hobbyCategories = [
    HobbyCategory(
      title: '食物',
      tags: [
        '火锅',
        '烧烤',
        '面条',
        '米粉',
        '寿司',
        '烧烤',
        '奶茶',
        '咖啡',
        '意大利面',
        '炸串',
      ],
    ),
    HobbyCategory(
      title: '活动',
      tags: [
        '唱歌',
        '看电影',
        '跑步',
        '爬山',
        '游泳',
        '看展',
        '画画',
        '玩游戏',
        '射箭',
      ],
    ),
  ];

  static const _weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  static String _diaryMonthWeek(int year, int month, int day) {
    final weekday = _weekdays[DateTime(year, month, day).weekday - 1];
    return '$month月/$weekday';
  }

  static String _diaryFullDate(int year, int month, int day) {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  static const int _sampleLaterDay = 8;
  static const int _sampleEarlierDay = 2;

  static List<DiaryEntry> defaultDiaryEntries() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    const laterDay = _sampleLaterDay;
    const earlierDay = _sampleEarlierDay;

    return [
      DiaryEntry(
        id: 101,
        day: '$laterDay',
        monthWeek: _diaryMonthWeek(year, month, laterDay),
        emotionIcon: '😊',
        text: '去海边了，风比想的大。拍了几张，晚上海鲜点多了。',
        images: const [
          ImageUrls.diarySea1,
          ImageUrls.diarySea2,
          ImageUrls.diarySea3,
        ],
        emotionText: '开心',
        time: '16:20',
        year: year,
        month: month,
        fullDate: _diaryFullDate(year, month, laterDay),
      ),
      DiaryEntry(
        id: 102,
        day: earlierDay < 10 ? '0$earlierDay' : '$earlierDay',
        monthWeek: _diaryMonthWeek(year, month, earlierDay),
        emotionIcon: '🥰',
        text: '周末去了收藏夹里那家店。咖啡一般，窗边位子还行。下次换一家。',
        images: const [
          ImageUrls.diaryCafe1,
          ImageUrls.diaryCafe2,
          ImageUrls.diaryCafe3,
        ],
        emotionText: '满足',
        time: '10:30',
        year: year,
        month: month,
        fullDate: _diaryFullDate(year, month, earlierDay),
      ),
    ];
  }

  static List<MemoItem> defaultMemos() {
    return [
      const MemoItem(
        id: 1,
        title: '购物清单',
        content: '牛奶、鸡蛋、全麦面包、洗面奶\n记得买低脂的！',
        date: '07-08',
      ),
      const MemoItem(
        id: 2,
        title: '下周计划',
        content: '1. 整理房间\n2. 看完《悉达多》\n3. 周五晚上和朋友聚餐',
        date: '07-07',
      ),
    ];
  }

  static const List<Map<String, String>> emotionOptions = [
    {'icon': '😊', 'text': '开心'},
    {'icon': '😢', 'text': '难过'},
    {'icon': '🥰', 'text': '满足'},
    {'icon': '📝', 'text': '记录'},
    {'icon': '😌', 'text': '平静'},
  ];

  static List<WatchedMovie> defaultWatchedMovies() {
    const titles = [
      '肖申克的救赎',
      '千与千寻',
      '泰坦尼克号',
      '阿甘正传',
      '星际穿越',
      '盗梦空间',
      '海上钢琴师',
      '忠犬八公',
      '放牛班的春天',
      '怦然心动',
      '楚门的世界',
      '当幸福来敲门',
      '寻梦环游记',
      '疯狂动物城',
      '摔跤吧！爸爸',
      '三傻大闹宝莱坞',
      '美丽人生',
      '机器人总动员',
      '飞屋环游记',
      '哈尔的移动城堡',
      '龙猫',
      '你的名字',
      '天气之子',
      '铃芽之旅',
      '海蒂和爷爷',
      '小森林',
      '情书',
      '恋恋笔记本',
    ];
    return List<WatchedMovie>.generate(titles.length, (index) {
      final month = (index % 12) + 1;
      final day = (index % 28) + 1;
      return WatchedMovie(
        id: index + 1,
        title: titles[index],
        date: '${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
      );
    });
  }

  static List<BannerItem> visibleBanners({
    required Set<int> blockedBannerIds,
    required Set<String> blockedAuthorIds,
  }) {
    return banners
        .where(
          (banner) =>
              !blockedBannerIds.contains(banner.id) &&
              !blockedAuthorIds.contains(banner.authorId),
        )
        .toList();
  }

  static List<OutfitItem> visibleOutfits({
    required Set<int> blockedOutfitIds,
    required Set<String> blockedAuthorIds,
  }) {
    return outfits
        .where(
          (outfit) =>
              !blockedOutfitIds.contains(outfit.id) &&
              !blockedAuthorIds.contains(outfit.authorId),
        )
        .toList();
  }
}
