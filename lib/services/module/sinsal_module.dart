//lib/services/module/sinsal_module.dart
import '../../models/saju_data.dart';
/// ------------------------------------------------------------
/// 신살(神煞) 모듈 엔진
/// ------------------------------------------------------------
/// - 일간 / 월지 / 년지 기준으로 주요 길신 및 흉신을 판별
/// - 포함: 천을귀인, 천관귀인, 태극귀인, 삼기귀인,
///         월덕귀인, 월덕합, 천덕귀인, 천주귀인, 복성귀인,
///         간록, 역마, 천사, 화개, 학당귀인
/// ------------------------------------------------------------
/// SinsalEngine (신살 자동 판별 엔진)
/// ------------------------------------------------------------
/// - 모든 신살 규칙을 데이터 테이블로 관리
/// - 결과에 발견 위치(년지, 월지, 일지, 시지) 표시
/// ------------------------------------------------------------
///
class SinsalEngine {
  static Map<String, dynamic> interpret(SajuData saju) {
    final result = <String, List<String>>{
      '길신': [],
      '흉신': [],
    };

    // 변환 매핑 (한자 → 한글)
    const hanjaToHangul = {
      '甲': '갑', '乙': '을', '丙': '병', '丁': '정', '戊': '무',
      '己': '기', '庚': '경', '辛': '신', '壬': '임', '癸': '계',
      '子': '자', '丑': '축', '寅': '인', '卯': '묘', '辰': '진',
      '巳': '사', '午': '오', '未': '미', '申': '신', '酉': '유',
      '戌': '술', '亥': '해',
    };
    // 한자 입력값이 들어오면 자동 변환
    String normalize(String char) => hanjaToHangul[char] ?? char;


    // 적용
    final yearStem = normalize(saju.yearStem);
    final monthStem = normalize(saju.monthStem);
    final dayStem = normalize(saju.dayStem);
    final hourStem = normalize(saju.hourStem);
    final yearBranch = normalize(saju.yearBranch);
    final monthBranch = normalize(saju.monthBranch);
    final dayBranch = normalize(saju.dayBranch);
    final hourBranch = normalize(saju.hourBranch);


    // 천간 라벨 (Stem Labels)
    final stemLabels = {
      '년간': yearStem,
      '월간': monthStem,
      '일간': dayStem,
      '시간': hourStem,
    };
    // 지지 라벨 맵
    final branchLabels = {
      '년지': yearBranch,
      '월지': monthBranch,
      '일지': dayBranch,
      '시지': hourBranch,
    };
    final juLabels = {
      '년주': '$yearStem$yearBranch',
      '월주': '$monthStem$monthBranch',
      '일주': '$dayStem$dayBranch',
      '시주': '$hourStem$hourBranch',
    };


    // ------------------------------------------------------------
    // 신살 룰 테이블
    // ------------------------------------------------------------
    final rules = [
      {
        'name': '천을귀인',
        'type': '길신',
        'basis': dayStem,
        'table': _cheonEulGwiIn,
        'compare': branchLabels,
        'mode': 'contains',
      },
      {
        'name': '천관귀인',
        'type': '길신',
        'basis': dayStem,
        'table': _cheonGwanGwiIn,
        'compare': branchLabels,
        'mode': 'contains',
      },
      {
        'name': '태극귀인',
        'type': '길신',
        'basis': dayStem,
        'table': _taegeukGwiIn,
        'compare': branchLabels,
        'mode': 'contains',
      },
      {
        'name': '월덕귀인',
        'type': '길신',
        'basis': monthBranch,
        'table': _wolDeokGuiIn,
        'compare': stemLabels,
        'mode': 'equal',
      },
      {
        'name': '월덕합',
        'type': '길신',
        'basis': monthBranch,
        'table': _wolDeokHap,
        'compare': stemLabels,
        'mode': 'equal',
      },
      {
        'name': '천덕귀인',
        'type': '길신',
        'basis': monthBranch,
        'table': _cheonDeokGuiIn,
        'compare': (['자', '오', '묘', '유'].contains(monthBranch))
            ? branchLabels // 지지들 비교
            : stemLabels,  // 천간들 비교
        'mode': 'equal',
      },

      {
        'name': '천주귀인',
        'type': '길신',
        'basis': dayStem,
        'table': _cheonJuGuiIn,
        'compare': branchLabels,
        'mode': 'contains',
      },
      {
        'name': '복성귀인',
        'type': '길신',
        'basis': dayStem,
        'table': _bokSeongGuiIn,
        'compare': branchLabels,
        'mode': 'contains',
      },
      {
        'name': '간록',
        'type': '길신',
        'basis': dayStem,
        'table': _ganRok,
        'compare': branchLabels,
        'mode': 'equal',
      },
      {
        'name': '역마',
        'type': '길신',
        'basis': [saju.yearBranch, saju.dayBranch],
        'table': _yeokMa,
        'compare': branchLabels,
        'mode': 'contains',
      },
      {
        'name': '천사',
        'type': '길신',
        'basis': monthBranch,
        'table': _cheonSa,
        'compare': {'일주': dayStem + dayBranch},
        'mode': 'equal',
      },
      {
        'name': '화개',
        'type': '길신',
        'basis': yearBranch,
        'table': _hwaGae,
        'compare': branchLabels,
        'mode': 'equal',
      },
      {
        'name': '학당귀인',
        'type': '길신',
        'basis': dayStem,
        'table': _hakDang,
        'compare': branchLabels,
        'mode': 'equal',
      },
      {
        'name': '식록',
        'type': '길신',
        'basis': dayStem,
        'table': _sikRok,
        'compare': stemLabels,
        'mode': 'equal',
      },
      {
        'name': '금여록',
        'type': '길신',
        'basis': dayStem,
        'table': _geumyeoRok,
        'compare': branchLabels,
        'mode': 'equal',
      },
      {
        'name': '공록',
        'type': '길신',
        'basis': '$dayStem$dayBranch',
        'table': _gongRok,
        'compare': juLabels,
        'mode': 'equal',
      },
      {
        'name': '교록',
        'type': '길신',
        'basis': '$dayStem$dayBranch',
        'table': _gyoRok,
        'compare': juLabels,
        'mode': 'equal',
      },
      {
        'name': '암록',
        'type': '길신',
        'basis': dayStem,
        'table': _amRok,
        'compare': branchLabels,
        'mode': 'equal',
      },
      {
        'name': '협록',
        'type': '길신',
        'basis': dayStem,
        'table': _hyeopRok,
        'compare': branchLabels,
        'mode': 'custom',
      },

      {
        'name': '원성',
        'type': '길신',
        'basis': dayStem,
        'table': _wonSeong,
        'compare': branchLabels,
        'mode': 'equal',
      },
    ];

    // ------------------------------------------------------------
    // 룰 기반 계산
    // ------------------------------------------------------------
    for (final rule in rules) {
      final table = rule['table'] as Map<String, dynamic>;
      final basisRaw = rule['basis']; // ✅ String 또는 List<String> 모두 가능
      final compare = rule['compare'] as Map<String, String>;
      final mode = rule['mode'] as String;
      final type = rule['type'] as String;
      final name = rule['name'] as String;

      final found = <String>[];

      // case 1: basis가 String인 경우 (기존 그대로)
      if (basisRaw is String) {
        final tableVal = table[basisRaw];
        if (tableVal != null) {
          compare.forEach((label, value) {
            if (mode == 'contains' &&
                tableVal is List &&
                tableVal.contains(value)) {
              found.add(label);
            } else if (mode == 'equal' &&
                tableVal is String &&
                tableVal == value) {
              found.add(label);
            }
          });
        }
      }

      // case 2: basis가 List<String>인 경우 (예: ['년지','일지'])
      else if (basisRaw is List) {
        for (final b in basisRaw) {
          final tableVal = table[b];
          if (tableVal != null) {
            compare.forEach((label, value) {
              if (mode == 'contains' &&
                  tableVal is List &&
                  tableVal.contains(value)) {
                found.add(label);
              } else if (mode == 'equal' &&
                  tableVal is String &&
                  tableVal == value) {
                found.add(label);
              }
            });
          }
        }
      }

      // 공통 결과 추가
      if (found.isNotEmpty) {
        // 라벨 정규화: '월지'나 '월간'도 모두 '월주'로 통일
        final juLabels = found.map((f) {
          if (f.contains('년')) return '년주';
          if (f.contains('월')) return '월주';
          if (f.contains('일')) return '일주';
          if (f.contains('시')) return '시주';
          return f;
        }).toList();

        result[type]!.add('$name(${juLabels.join(', ')})');
      }

    }


    // ------------------------------------------------------------
    // 별도 규칙 (삼기귀인, 공망, 절로공망)
    // ------------------------------------------------------------

    // 삼기귀인 (順行/逆行 모두 인정)
    if (_checkSamGiGuiIn(saju)) {result['길신']!.add('삼기귀인');}

    // 공망 (일주 기준)
    final gongMang = _getGongMang(dayStem, dayBranch);
    if (gongMang.contains(dayBranch)) result['흉신']!.add('공망');

    // 절로공망 (4지 중 포함 시)
    final jeol = _jeolRoGongMang[dayStem];
    if (jeol != null &&
        [yearBranch, monthBranch, dayBranch, hourBranch]
            .cast<String>()
            .any((b) => jeol.contains(b))) {
      result['흉신']!.add('절로공망');
    }

    // 협록 (좌, 우 지지 중 하나라도 포함 시)
    if (_checkHyeopRok(dayStem, _hyeopRok, branchLabels)) {
      result['길신']!.add('협록');
    }

    return result;
  }

  // ------------------------------------------------------------
  // 헬퍼 함수들
  // ------------------------------------------------------------
  //삼기귀인
  static bool _checkSamGiGuiIn(SajuData saju) {
    const combos = [
      ['갑', '무', '경'],
      ['을', '병', '정'],
      ['임', '계', '신'],
    ];
    // 기준 세 세트: (년, 월, 일) / (월, 일, 시)
    final sets = [
      [saju.yearStem, saju.monthStem, saju.dayStem],
      [saju.monthStem, saju.dayStem, saju.hourStem],
    ];

    for (final set in sets) {
      for (final combo in combos) {
        // 순행
        if (_isSequence(set, combo)) return true;
        // 역행
        if (_isSequence(set.reversed.toList(), combo)) return true;
      }
    }
    return false;
  }

  // 순서 일치 여부 판정
  static bool _isSequence(List<String> stems, List<String> combo) {
    for (int i = 0; i < combo.length; i++) {
      if (!stems.contains(combo[i])) return false;
    }
    // 순서가 일치해야 함
    final indices = combo.map((c) => stems.indexOf(c)).toList();
    return indices[0] < indices[1] && indices[1] < indices[2];
  }

  //공망
  static List<String> _getGongMang(String dayStem, String dayBranch) {
    const stems = ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'];
    const branches = ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'];
    final stemIndex = stems.indexOf(dayStem);
    final branchIndex = branches.indexOf(dayBranch);
    if (stemIndex == -1 || branchIndex == -1) return [];
    final endBranchIndex = (branchIndex + (stems.length - stemIndex - 1)) % 12;
    return [
      branches[(endBranchIndex + 1) % 12],
      branches[(endBranchIndex + 2) % 12],
    ];

  }

  //협록체크
  static bool _checkHyeopRok(
      String stem,
      Map<String, dynamic> table,
      Map<String, String> branchLabels,
      ) {
    final rule = table[stem];
    if (rule == null) return false;

    final lefts = List<String>.from(rule['좌'] ?? []);
    final rights = List<String>.from(rule['우'] ?? []);

    return branchLabels.values
        .cast<String>()
        .any((b) => lefts.contains(b) || rights.contains(b));
  }


  // ------------------------------------------------------------
  // 신살 테이블 (기존 그대로)
  // ------------------------------------------------------------
  static const _cheonEulGwiIn = {
    '갑': ['축', '미'], '무': ['축', '미'], '경': ['축', '미'],
    '을': ['자', '신'], '기': ['자', '신'],
    '병': ['해', '유'], '정': ['해', '유'],
    '임': ['묘', '사'], '계': ['묘', '사'],
    '신': ['오', '인'],
  };

  static const _cheonGwanGwiIn = {
    '갑': ['미'], '을': ['진'], '병': ['사'], '정': ['유'],
    '무': ['술'], '기': ['묘'], '경': ['해'],
    '신': ['신'], '임': ['인'], '계': ['오'],
  };

  static const _taegeukGwiIn = {
    '갑': ['자', '오'], '을': ['자', '오'],
    '병': ['묘', '유'], '정': ['묘', '유'],
    '무': ['진', '술', '축', '미'], '기': ['진', '술', '축', '미'],
    '경': ['인', '묘'], '신': ['인', '묘'],
    '임': ['사', '신'], '계': ['사', '신'],
  };

  static const _wolDeokGuiIn = {
    '인': '병', '오': '병', '술': '병',
    '신': '임', '자': '임', '진': '임',
    '해': '갑', '묘': '갑', '미': '갑',
    '사': '경', '유': '경', '축': '경',
  };

  static const _wolDeokHap = {
    '인': '신', '오': '신', '술': '신',
    '신': '정', '자': '정', '진': '정',
    '해': '기', '묘': '기', '미': '기',
    '사': '을', '유': '을', '축': '을',
  };

  static const _cheonDeokGuiIn = {
    '인': '정', '묘': '신', '진': '임', '사': '신',
    '오': '해', '미': '갑', '신': '계', '유': '인',
    '술': '병', '해': '을', '자': '사', '축': '경',
  };

  static const _cheonJuGuiIn = {
    '갑': ['사'], '병': ['사'], '을': ['오'], '정': ['오'],
    '기': ['유'], '무': ['신'], '계': ['묘'],
    '임': ['인'], '신': ['자'],
  };

  static const _bokSeongGuiIn = {
    '갑': ['인', '자'], '병': ['인', '자'],
    '무': ['신'], '기': ['미'], '을': ['해'], '정': ['해'],
    '경': ['오'], '신': ['사'], '임': ['진'], '계': ['묘', '축'],
  };

  static const _ganRok = {
    '갑': '인', '을': '묘', '병': '사', '무': '사',
    '정': '오', '기': '오', '경': '신', '신': '유',
    '임': '해', '계': '자',
  };

  static const _yeokMa = {
    '신': ['인'], '자': ['인'], '진': ['인'],
    '인': ['신'], '오': ['신'], '술': ['신'],
    '사': ['해'], '유': ['해'], '축': ['해'],
    '해': ['사'], '묘': ['사'], '미': ['사'],
  };

  static const _cheonSa = {
    '인': '무인', '묘': '무인', '진': '무인',
    '사': '갑오', '오': '갑오', '미': '갑오',
    '신': '무신', '유': '무신', '술': '무신',
    '해': '갑자', '자': '갑자', '축': '갑자',
  };

  static const _hwaGae = {
    '인': '술', '오': '술', '술': '술',
    '사': '축', '유': '축', '축': '축',
    '신': '진', '자': '진', '진': '진',
    '해': '미', '묘': '미', '미': '미',
  };

  static const _hakDang = {
    '갑': '해', '을': '오', '병': '인', '무': '인',
    '정': '유', '기': '유', '경': '사', '신': '자',
    '임': '신', '계': '묘',
  };

  static const _sikRok = {
    '갑': '병', '을': '정', '병': '무', '정': '기',
    '무': '경', '기': '신', '경': '임', '신': '계',
    '임': '갑', '계': '을',
  };

  static const _geumyeoRok = {
    '갑': '진', '을': '사', '병': '미', '무': '미',
    '정': '신', '기': '신', '경': '술', '신': '해',
    '임': '축', '계': '인',
  };

  static const _gongRok = {
    '무진': '병오',
    '병오': '무진',
    '정사': '기미',
    '기미': '정사',
  };

  static const _gyoRok = {
    '갑신': '경인', '경인': '갑신',
    '을유': '신묘', '신묘': '을유',
    '병자': '계사', '계사': ['병자', '무자'],
    '정해': '임오', '임오': ['정해', '기해'],
    '무자': '계사',
    '기해': '임오',
  };

  static const _amRok = {
    '갑': '해',
    '을': '술',
    '병': '신',
    '정': '미',
    '무': '신',
    '기': '미',
    '경': '사',
    '신': '진',
    '임': '인',
    '계': '축',
  };

  static const _hyeopRok = {
    '갑': {'좌': ['축'], '우': ['묘']},
    '을': {'좌': ['진'], '우': ['사']},
    '병': {'좌': ['진'], '우': ['오']},
    '정': {'좌': ['미'], '우': ['사']},
    '무': {'좌': ['진'], '우': ['오']},
    '기': {'좌': ['미'], '우': ['사']},
    '경': {'좌': ['미'], '우': ['유']},
    '신': {'좌': ['술'], '우': ['신']},
    '임': {'좌': ['술'], '우': ['자']},
    '계': {'좌': ['축'], '우': ['해']},
  };

  static const _wonSeong = {
    '갑': '해', '을': '오', '병': '인', '정': '유',
    '무': '인', '기': '유', '경': '사', '신': '자',
    '임': '신', '계': '묘',
  };

  static const _jeolRoGongMang = {
    '갑': ['신', '유'], '기': ['신', '유'],
    '을': ['오', '미'], '경': ['오', '미'],
    '병': ['진', '사'], '신': ['진', '사'],
    '정': ['인', '묘'], '임': ['인', '묘'],
    '무': ['자', '축'], '계': ['자', '축'],
  };
}
