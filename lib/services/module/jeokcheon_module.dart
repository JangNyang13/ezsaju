import '../../models/saju_data.dart';

class JeokcheonModule {
  /// 일간별 성정 해석
  static String personality(String stem) {
    switch (stem) {
      case '甲':
        return '곧고 정직하나 완고함 주의, 큰 나무처럼 성장형 인물.';
      case '乙':
        return '부드럽고 융통성 있으나 결정력 부족, 조화형 리더.';
      case '丙':
        return '밝고 에너지 넘치며, 리더십과 추진력 강.';
      case '丁':
        return '섬세하고 지혜롭지만 내면이 예민함, 예술 감성.';
      case '戊':
        return '중후하고 안정적, 신중한 현실주의자.';
      case '己':
        return '세밀하고 실속형, 남의 마음을 잘 읽음.';
      case '庚':
        return '정의감 강하고 냉철, 직선적 사고로 개혁형.';
      case '辛':
        return '감각적이고 예술성 높음, 때로는 내성적.';
      case '壬':
        return '넓은 시야, 포용력, 큰 비전 가진 리더형.';
      case '癸':
        return '깊은 통찰, 연구형, 내면 세계가 풍부.';
      default:
        return '조화로운 성향';
    }
  }

  /// 일간별 운로 해석
  static String fortuneDirection(String stem) {
    switch (stem) {
      case '甲':
      case '乙':
        return '목(木) 기운 — 시작과 성장, 교육·개발 분야 길.';
      case '丙':
      case '丁':
        return '화(火) 기운 — 명예·성과, 리더십 발휘 시 성취.';
      case '戊':
      case '己':
        return '토(土) 기운 — 안정·현실, 경영·부동산에 강점.';
      case '庚':
      case '辛':
        return '금(金) 기운 — 분석·기술, 법률·공무·기획에 유리.';
      case '壬':
      case '癸':
        return '수(水) 기운 — 지식·예술, 교육·상담·연구 적성.';
      default:
        return '중용의 운로';
    }
  }

  /// 교훈 문장 (철학적 해석)
  static String wisdom(String stem) {
    switch (stem) {
      case '甲':
        return '큰 뜻을 품되, 뿌리를 지키면 천하에 이름을 남긴다.';
      case '乙':
        return '겸손은 꽃을 피우고, 결단은 열매를 맺는다.';
      case '丙':
        return '밝은 빛은 어둠 속에서도 자신을 태운다.';
      case '丁':
        return '작은 불씨도 따뜻함을 전하니, 부드러움이 강함을 이긴다.';
      case '戊':
        return '묵직한 바위처럼 중심을 잡을 때 만사가 통한다.';
      case '己':
        return '조용한 흙이 만물을 살리듯, 세심함이 힘이 된다.';
      case '庚':
        return '칼은 다듬어야 빛나듯, 노력으로 완성된다.';
      case '辛':
        return '보석은 고요히 빛나며, 진실함이 아름다움이다.';
      case '壬':
        return '바다는 만천하를 품되, 흐름을 잃지 않는다.';
      case '癸':
        return '깊은 샘물은 천천히 흘러, 결국 생명을 살린다.';
      default:
        return '자신의 흐름을 따르라.';
    }
  }

  static Map<String, String> interpret(SajuData saju) {
    final stem = saju.dayPillar.substring(0, 1);
    return {
      '성정': personality(stem),
      '운로': fortuneDirection(stem),
      '교훈': wisdom(stem),
    };
  }
}
