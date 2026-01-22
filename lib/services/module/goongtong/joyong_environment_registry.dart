import 'joyong_environment_rule.dart';

/// 🔮 조후 환경 규칙 레지스트리
// 구조: [일간][월지] = List<JoyongEnvironmentRule>
final Map<String, Map<String, List<JoyongEnvironmentRule>>>
joyongEnvironmentRegistry = {

  /// =========================
  /// 甲木
  /// =========================
  '甲': {
    '寅': [//==================================================================

      /// 1. 병·계 없음 → 음양 조화 부족
      JoyongEnvironmentRule(
        id: 'gap_in_no_bing_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 2. 병·정 없음 + 금 강함
      JoyongEnvironmentRule(
        id: 'gap_in_strong_metal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁') &&
            (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            ctx.branches.any((b) => ['酉','申','丑'].contains(b)),
      ),

      /// 3. 병·정 없음 + 금국
      JoyongEnvironmentRule(
        id: 'gap_in_metal_guk_root_damage_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁') &&
            ctx.gukGroups.contains('금국'),
      ),

      /// 4. 무·기 없음 + 수 과다
      JoyongEnvironmentRule(
        id: 'gap_in_water_overflow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            ctx.branches.any((b) => ['子','亥'].contains(b)),
      ),

      /// 5. 무·기 + 금국 → 재다신약
      JoyongEnvironmentRule(
        id: 'gap_in_wealth_burden_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.gukGroups.contains('금국'),
      ),

      /// 6. 경 없음 + 정 존재 → 목화통명
      JoyongEnvironmentRule(
        id: 'gap_in_mokhwa_tongmyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            ctx.stems.contains('丁'),
      ),

      /// 7. 정·계 동시 존재
      JoyongEnvironmentRule(
        id: 'gap_in_jeong_gui_conflict_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('癸'),
      ),

      /// 8. 계 2개 이상
      JoyongEnvironmentRule(
        id: 'gap_in_excess_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length >= 2,
      ),

      /// 9. 화국 과다
      JoyongEnvironmentRule(
        id: 'gap_in_fire_guk_overflow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 10. 목국 + 경 있음
      JoyongEnvironmentRule(
        id: 'gap_in_mok_guk_with_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('庚'),
      ),

      /// 11. 목국 + 경 없음
      JoyongEnvironmentRule(
        id: 'gap_in_mok_guk_no_gyeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            !ctx.stems.contains('庚'),
      ),

      /// 12. 수국 + 무 있음
      JoyongEnvironmentRule(
        id: 'gap_in_water_guk_with_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('戊'),
      ),

      /// 13. 수국 + 무 없음
      JoyongEnvironmentRule(
        id: 'gap_in_water_guk_no_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.contains('戊'),
      ),

      /// 14. 경·무 존재
      JoyongEnvironmentRule(
        id: 'gap_in_high_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('戊'),
      ),

      /// 15. 경·무·정 존재
      JoyongEnvironmentRule(
        id: 'gap_in_great_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('戊') &&
            ctx.stems.contains('丁'),
      ),
    ],
    '卯': [//==================================================================

      /// 1. 경금 존재 → 양인가살, 소귀
      JoyongEnvironmentRule(
        id: 'gap_myo_gyeong_small_honor_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// 2. 경금 + 토(무·기) + 토지지 → 영웅격
      JoyongEnvironmentRule(
        id: 'gap_myo_gyeong_with_earth_hero_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

      /// 3. 계수 존재 → 흉포, 힘 낭비
      JoyongEnvironmentRule(
        id: 'gap_myo_gui_disorder_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 4. 병·정 존재 + 임·계 없음 → 관귀
      JoyongEnvironmentRule(
        id: 'gap_myo_official_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 5. 인·진 없음 → 재운 집착
      JoyongEnvironmentRule(
        id: 'gap_myo_no_in_jin_wealth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.branches.contains('寅') &&
            !ctx.branches.contains('辰'),
      ),
    ],
    '辰': [//==================================================================
      /// 1. 경·임 동시 존재 → 음양 조화
      JoyongEnvironmentRule(
        id: 'gap_jin_gyeong_im_harmony_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('壬'),
      ),

      /// 2. 병 2개 이상 → 화기 과다
      JoyongEnvironmentRule(
        id: 'gap_jin_excess_bing_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2,
      ),

      /// 3. 병 2개 이상 + 임·계 존재
      JoyongEnvironmentRule(
        id: 'gap_jin_bing_controlled_by_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 4. 수 완전 부재 + 토 다수
      JoyongEnvironmentRule(
        id: 'gap_jin_strong_earth_no_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)) &&
            ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

      /// 5. 무·기 + 목 과다
      JoyongEnvironmentRule(
        id: 'gap_jin_earth_robbed_by_wood_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
                ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 4,
      ),

      /// 6. 금국 + 정화 없음
      JoyongEnvironmentRule(
        id: 'gap_jin_metal_guk_no_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            !ctx.stems.contains('丁'),
      ),

      /// 7. 금국 + 정화 존재
      JoyongEnvironmentRule(
        id: 'gap_jin_metal_guk_with_jeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('丁'),
      ),

    ],
    '巳': [//==================================================================

      /// 1. 경 + 신 2개 이상 → 금기세 과중
      JoyongEnvironmentRule(
        id: 'gap_sa_heavy_metal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => b == '申').length >= 2,
      ),

      /// 2. 경 + 신 2개 이상 + 임 존재
      JoyongEnvironmentRule(
        id: 'gap_sa_metal_water_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => b == '申').length >= 2 &&
            ctx.stems.contains('壬'),
      ),

      /// 3. 경 1개 + 병 2개
      JoyongEnvironmentRule(
        id: 'gap_sa_clear_fire_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '庚').length == 1 &&
            ctx.stems.where((s) => s == '丙').length >= 2,
      ),

      /// 4. 경 + 지지 신·유 2↑ + 화 2↑
      JoyongEnvironmentRule(
        id: 'gap_sa_fire_metal_overflow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 2 &&
            (ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
                ctx.branches.where((b) => ['巳','午'].contains(b)).length) >= 2,
      ),

      /// 5. 계·정·경 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_sa_three_harmony_excellence_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('庚'),
      ),

      /// 6. 계 없음 + 정·경 존재
      JoyongEnvironmentRule(
        id: 'gap_sa_fire_controls_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('庚'),
      ),

      /// 7. 임 존재
      JoyongEnvironmentRule(
        id: 'gap_sa_ren_effort_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 8. 임·계·해·자·경·정 없음 + 병·무 존재
      JoyongEnvironmentRule(
        id: 'gap_sa_no_use_structure_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['壬','癸','庚','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)) &&
            ctx.stems.any((s) => ['丙','戊'].contains(s)),
      ),

    ],
    '午': [//==================================================================

      /// 1. 계 존재 → 화기 보호
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_fire_protect_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 2. 정 존재 → 화극기 조절 (공통 긍정)
      JoyongEnvironmentRule(
        id: 'gap_oh_jeong_adjust_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丁'),
      ),

      /// 3. 계·정 동시
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_jeong_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丁'),
      ),

      /// 4. 계·정·경 모두
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_jeong_gyeong_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('庚'),
      ),

      /// 5. 목 과다
      JoyongEnvironmentRule(
        id: 'gap_oh_many_wood_need_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3,
      ),

      /// 6. 목 과다 + 경 존재
      JoyongEnvironmentRule(
        id: 'gap_oh_many_wood_with_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3 &&
            ctx.stems.contains('庚'),
      ),

      /// 7. 경 + 신 or 유
      JoyongEnvironmentRule(
        id: 'gap_oh_gyeong_with_metal_branch_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 8. 오월 계·경 동시 → 상격
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_gyeong_supreme_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('庚'),
      ),

      /// 9. 화·수 동시 과다
      JoyongEnvironmentRule(
        id: 'gap_oh_fire_water_overload_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length >= 2 &&
            ctx.branches.where((b) => b == '午').length >= 2 &&
            ctx.stems.where((s) => s == '癸').length >= 2 &&
            ctx.branches.where((b) => b == '子').length >= 2,
      ),

      /// 10. 금 과다
      JoyongEnvironmentRule(
        id: 'gap_oh_heavy_kill_energy_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 3,
      ),

      /// 11. 금 과다 + 화·수 존재
      JoyongEnvironmentRule(
        id: 'gap_oh_heavy_kill_balanced_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 3 &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 12. 병·사 과다 + 무금
      JoyongEnvironmentRule(
        id: 'gap_oh_strange_structure_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 &&
            ctx.branches.where((b) => b == '巳').length >= 2 &&
            ctx.stems.contains('丁') &&
            !ctx.stems.contains('庚') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 13. 토 과다 + 을
      JoyongEnvironmentRule(
        id: 'gap_oh_heavy_earth_with_eul_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 3 &&
            ctx.stems.contains('乙'),
      ),

      /// 14. 진 + 갑·기 각 2
      JoyongEnvironmentRule(
        id: 'gap_oh_true_harmony_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('辰') &&
            ctx.stems.where((s) => s == '甲').length >= 2 &&
            ctx.stems.where((s) => s == '己').length >= 2,
      ),

      /// 15. 기만 존재
      JoyongEnvironmentRule(
        id: 'gap_oh_only_gi_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            !ctx.stems.contains('戊'),
      ),
    ],
    '未': [//==================================================================

      /// 1. 계 존재 → 화기 보호
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_fire_protect_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 2. 정 존재 → 화극기 조절 (공통 긍정)
      JoyongEnvironmentRule(
        id: 'gap_oh_jeong_adjust_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丁'),
      ),

      /// 3. 계·정 동시
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_jeong_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丁'),
      ),

      /// 4. 계·정·경 모두
      JoyongEnvironmentRule(
        id: 'gap_oh_gui_jeong_gyeong_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('庚'),
      ),

      /// 5. 목 과다
      JoyongEnvironmentRule(
        id: 'gap_oh_many_wood_need_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3,
      ),

      /// 6. 목 과다 + 경 존재
      JoyongEnvironmentRule(
        id: 'gap_oh_many_wood_with_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3 &&
            ctx.stems.contains('庚'),
      ),

      /// 7. 경 + 신 or 유
      JoyongEnvironmentRule(
        id: 'gap_oh_gyeong_with_metal_branch_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 8. /// 경·정 동시 → 상격
       JoyongEnvironmentRule(
         id: 'gap_mi_gyeong_jeong_supreme_pos',
         effect: EnvironmentEffect.positive,
         condition: (ctx) =>
         ctx.stems.contains('庚') &&
             ctx.stems.contains('丁'),
       ),

      /// 9. 화·수 동시 과다
      JoyongEnvironmentRule(
        id: 'gap_oh_fire_water_overload_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length >= 2 &&
            ctx.branches.where((b) => b == '午').length >= 2 &&
            ctx.stems.where((s) => s == '癸').length >= 2 &&
            ctx.branches.where((b) => b == '子').length >= 2,
      ),

      /// 10. 금 과다
      JoyongEnvironmentRule(
        id: 'gap_oh_heavy_kill_energy_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 3,
      ),

      /// 11. 금 과다 + 화·수 존재
      JoyongEnvironmentRule(
        id: 'gap_oh_heavy_kill_balanced_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 3 &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 12. 병·사 과다 + 무금
      JoyongEnvironmentRule(
        id: 'gap_oh_strange_structure_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 &&
            ctx.branches.where((b) => b == '巳').length >= 2 &&
            ctx.stems.contains('丁') &&
            !ctx.stems.contains('庚') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 13. 토 과다 + 을
      JoyongEnvironmentRule(
        id: 'gap_oh_heavy_earth_with_eul_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 3 &&
            ctx.stems.contains('乙'),
      ),

      /// 14. 진 + 갑·기 각 2
      JoyongEnvironmentRule(
        id: 'gap_oh_true_harmony_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('辰') &&
            ctx.stems.where((s) => s == '甲').length >= 2 &&
            ctx.stems.where((s) => s == '己').length >= 2,
      ),

      /// 15. 기만 존재
      JoyongEnvironmentRule(
        id: 'gap_oh_only_gi_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            !ctx.stems.contains('戊'),
      ),

    ],
    '申': [//==================================================================

      /// 1. 정·경 모두 존재 → 방천화극, 완전한 창
      JoyongEnvironmentRule(
        id: 'gap_sin_jeong_gyeong_perfect_weapon_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('庚'),
      ),

      /// 2. 경 존재 → 살인상생
      JoyongEnvironmentRule(
        id: 'gap_sin_gyeong_kill_life_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// 3. 경 있고 정 없음
      JoyongEnvironmentRule(
        id: 'gap_sin_gyeong_no_jeong_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.stems.contains('丁'),
      ),

      /// 4. 정 존재 + 사·신·유 지지
      JoyongEnvironmentRule(
        id: 'gap_sin_hidden_gyeong_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// 5. 경 + 신·유 합 2↑ + 정 없음
      JoyongEnvironmentRule(
        id: 'gap_sin_heavy_metal_no_control_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            (ctx.branches.where((b) => ['申','酉'].contains(b)).length +
                ctx.stems.where((s) => s == '庚').length) >= 2 &&
            !ctx.stems.contains('丁'),
      ),

      /// 6. 경 + 신·유 합 2↑ + 해·자·축 2↑
      JoyongEnvironmentRule(
        id: 'gap_sin_metal_with_water_root_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') ||
            ctx.branches.any((b) => ['申','酉'].contains(b))) &&
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 2 &&
            ctx.branches.where((b) => ['亥','子','丑'].contains(b)).length >= 2,
      ),

      /// 7. 토 다수 → 종재격
      JoyongEnvironmentRule(
        id: 'gap_sin_many_earth_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['戊','己'].contains(s)).length +
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length) >= 2,
      ),

      /// 8. 오·미·술 존재
      JoyongEnvironmentRule(
        id: 'gap_sin_hidden_fire_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['午','未','戌'].contains(b)),
      ),

      /// 9. 정 + 오·미·술 존재
      JoyongEnvironmentRule(
        id: 'gap_sin_hidden_fire_emerge_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['午','未','戌'].contains(b)),
      ),

      /// 10. 정 2개 + 자·축·인 없음
      JoyongEnvironmentRule(
        id: 'gap_sin_double_jeong_no_rest_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length >= 2 &&
            !ctx.branches.any((b) => ['子','丑','寅'].contains(b)),
      ),

      /// 11. 계 2개 이상
      JoyongEnvironmentRule(
        id: 'gap_sin_excess_gui_unbalanced_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length >= 2,
      ),

      /// 12. 수국 + 무·기 존재
      JoyongEnvironmentRule(
        id: 'gap_sin_water_guk_remove_gui_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

    ],
    '酉': [//=================================================================

      /// 1. 정 1개
      JoyongEnvironmentRule(
        id: 'gap_you_single_jeong_controls_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length == 1,
      ),

      /// 2. 정·병 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_you_jeong_bing_control_and_yang_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('丙'),
      ),

      /// 3. 정·경 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_you_jeong_gyeong_perfect_weapon_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('庚'),
      ),

      /// 4. 정·경·계 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_you_jeong_gyeong_gui_incomplete_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('癸'),
      ),

      /// 5. 병·경 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_you_bing_gyeong_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('庚'),
      ),

      /// 6. 병·정 모두 없음
      JoyongEnvironmentRule(
        id: 'gap_you_no_fire_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁'),
      ),

      /// 7. 병 존재 + 계 없음
      JoyongEnvironmentRule(
        id: 'gap_you_bing_no_gui_mokhwa_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 8. 병 존재 + 계 존재
      JoyongEnvironmentRule(
        id: 'gap_you_bing_gui_ordinary_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// 9. 화국 형성
      JoyongEnvironmentRule(
        id: 'gap_you_fire_guk_controls_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 10. 화국 + 갑 or 기
      JoyongEnvironmentRule(
        id: 'gap_you_fire_guk_with_gap_gi_old_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.any((s) => ['甲','己'].contains(s)),
      ),

      /// 11. 금국 + 경 1개 이상
      JoyongEnvironmentRule(
        id: 'gap_you_metal_guk_with_gyeong_sickness_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('庚'),
      ),

      /// 12. 목국 + 갑·을 존재
      JoyongEnvironmentRule(
        id: 'gap_you_mok_guk_with_gap_eul_use_metal_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.any((s) => ['甲','乙'].contains(s)),
      ),

    ],
    '戌': [

      /// 1. 정 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_jeong_only_prefers_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丁'),
      ),

      /// 2. 정 + 임/계 + 갑/기
      JoyongEnvironmentRule(
        id: 'gap_sul_jeong_water_gap_gi_exam_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            ctx.stems.any((s) => ['甲','己'].contains(s)),
      ),

      /// 3. 갑 1↑ + 경 없음
      JoyongEnvironmentRule(
        id: 'gap_sul_many_gap_no_gyeong_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('庚'),
      ),

      /// 4. 경 + 병 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_gyeong_bing_self_made_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// 5. 목 과다
      JoyongEnvironmentRule(
        id: 'gap_sul_many_wood_need_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3,
      ),

      /// 6. 목 과다 + 병/정 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_many_wood_with_fire_need_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3 &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// 7. 토 과다
      JoyongEnvironmentRule(
        id: 'gap_sul_many_earth_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 3,
      ),

      /// 8. 화 과다
      JoyongEnvironmentRule(
        id: 'gap_sul_excess_fire_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            ctx.branches.any((b) => ['巳','午'].contains(b)),
      ),

      /// 9. 화 과다 + 수 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_fire_with_water_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            ctx.branches.any((b) => ['巳','午'].contains(b)) &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 10. 화 과다 + 수 없음 + 화국
      JoyongEnvironmentRule(
        id: 'gap_sul_fire_guk_no_water_desert_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 11. 정 + 무 존재 + 수 완전 부재
      JoyongEnvironmentRule(
        id: 'gap_sul_jeong_mu_no_water_shangguan_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('戊') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 12. 갑 2↑ or 갑+인 + 경 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_strong_gap_controlled_by_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ((ctx.stems.where((s) => s == '甲').length >= 2) ||
            (ctx.stems.contains('甲') && ctx.branches.contains('寅'))) &&
            ctx.stems.contains('庚'),
      ),

      /// 13. 갑 2↑ or 갑+인 + 경 없음 + 신/유 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_hidden_gyeong_small_honor_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ((ctx.stems.where((s) => s == '甲').length >= 2) ||
            (ctx.stems.contains('甲') && ctx.branches.contains('寅'))) &&
            !ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 14. 경 2↑ or 경+신 + 정 존재
      JoyongEnvironmentRule(
        id: 'gap_sul_many_gyeong_with_jeong_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ((ctx.stems.where((s) => s == '庚').length >= 2) ||
            (ctx.stems.contains('庚') && ctx.branches.contains('申'))) &&
            ctx.stems.contains('丁'),
      ),

    ],
    '亥': [

      /// 1. 경·정·무 모두 존재 → 거탁류청
      JoyongEnvironmentRule(
        id: 'gap_hae_gyeong_jeong_mu_clear_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('戊'),
      ),

      /// 2. 갑 2개 이상 + 경 뿌리 없음
      JoyongEnvironmentRule(
        id: 'gap_hae_many_gap_no_metal_root_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length >= 2 &&
            !ctx.branches.contains('申'),
      ),

      /// 3. 경·무 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_hae_gyeong_mu_wealth_longevity_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('戊'),
      ),

      /// 4. 신·해 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_hae_sin_hae_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('申') &&
            ctx.branches.contains('亥'),
      ),

      /// 5. 진·술·축·미·무 없음 + 기 존재
      JoyongEnvironmentRule(
        id: 'gap_hae_only_gi_weak_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            !ctx.stems.contains('戊') &&
            !ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

    ],
    '子': [

      /// 1. 경·정·사·인 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_ja_gyeong_jeong_sa_in_perfect_harmony_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('丁') &&
            ctx.branches.contains('巳') &&
            ctx.branches.contains('寅'),
      ),

      /// 2. 계 존재 (+ 무·기 여부는 문장에서 판단)
      JoyongEnvironmentRule(
        id: 'gap_ja_gui_cold_damage_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 3. 임 존재
      JoyongEnvironmentRule(
        id: 'gap_ja_ren_extreme_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 4. 수국 + 임 존재
      JoyongEnvironmentRule(
        id: 'gap_ja_water_guk_ren_hardship_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('壬'),
      ),

    ],
    '丑': [

      /// 1. 경·정 모두 존재
      JoyongEnvironmentRule(
        id: 'gap_chuk_gyeong_jeong_mokhwa_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('丁'),
      ),

      /// 2. 경 존재 + 오·미·술 1개 이상
      JoyongEnvironmentRule(
        id: 'gap_chuk_gyeong_hidden_fire_small_honor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['午','未','戌'].contains(b)),
      ),

      /// 3. 정 존재 + 사·신·유 1개 이상
      JoyongEnvironmentRule(
        id: 'gap_chuk_jeong_hidden_metal_small_wealth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// 4. 경 없음
      JoyongEnvironmentRule(
        id: 'gap_chuk_no_gyeong_useless_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚'),
      ),

      /// 5. 정 없음
      JoyongEnvironmentRule(
        id: 'gap_chuk_no_jeong_poor_scholar_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丁'),
      ),

      /// 6. 정 2개 이상 OR 정 + 오 존재
      JoyongEnvironmentRule(
        id: 'gap_chuk_strong_fire_with_gap_benevolence_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length >= 2 ||
            (ctx.stems.contains('丁') && ctx.branches.contains('午')),
      ),

    ],
  },
  /// =========================
  /// 乙木
  /// =========================
  '乙': {
    '寅': [

      /// 1. 병·계 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_in_bing_gui_harmony_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// 2. 병 존재 + 계 없음
      JoyongEnvironmentRule(
        id: 'eul_in_bing_only_bright_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 3. 병 존재 + 계·진·자·축 없음
      JoyongEnvironmentRule(
        id: 'eul_in_bing_no_water_dry_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.any((s) => s == '癸') &&
            !ctx.branches.any((b) => ['辰','子','丑'].contains(b)),
      ),

      /// 4. 병·인·사·오 1개 이하 + 계·진·자·축 2개 이상
      JoyongEnvironmentRule(
        id: 'eul_in_strong_water_cold_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length +
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).length) <= 1 &&
            (ctx.stems.where((s) => s == '癸').length +
                ctx.branches.where((b) => ['辰','子','丑'].contains(b)).length) >= 2,
      ),

      /// 5. 계 + (자·축·진 중 1) + 기 2↑ or 기+(축·미)
      JoyongEnvironmentRule(
        id: 'eul_in_gui_gi_wet_earth_low_grade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)) &&
            (
                ctx.stems.where((s) => s == '己').length >= 2 ||
                    (ctx.stems.contains('己') &&
                        ctx.branches.any((b) => ['丑','未'].contains(b)))
            ),
      ),

    ],
    '卯': [

      /// 1. 병·계 모두 있고 경 없음
      JoyongEnvironmentRule(
        id: 'eul_myo_bing_gui_no_gyeong_great_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            !ctx.stems.contains('庚'),
      ),

      /// 2. 경 존재 + 진 없음
      JoyongEnvironmentRule(
        id: 'eul_myo_gyeong_no_jin_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.branches.contains('辰'),
      ),

      /// 3. 진 존재
      JoyongEnvironmentRule(
        id: 'eul_myo_jin_common_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.contains('辰'),
      ),

      /// 4. 지지 목국
      JoyongEnvironmentRule(
        id: 'eul_myo_mok_guk_rooted_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

      /// 5. 지지 목국 + 병 존재
      JoyongEnvironmentRule(
        id: 'eul_myo_mok_guk_bing_best_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('丙'),
      ),

      /// 6. 임·계·해·자 2개 이상
      JoyongEnvironmentRule(
        id: 'eul_myo_excess_water_low_grade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 2,
      ),

      /// 7. 무 2개 이상 OR 무 + 진/술
      JoyongEnvironmentRule(
        id: 'eul_myo_mu_heavy_gui_bound_low_grade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length >= 2 ||
            (ctx.stems.contains('戊') &&
                ctx.branches.any((b) => ['辰','戌'].contains(b))),
      ),

      /// 8. 지지 목국 (해묘미 / 인묘진 방합 포함)
      JoyongEnvironmentRule(
        id: 'eul_myo_mok_guk_great_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

      /// 9. 지지 금국 OR 신·유 존재
      JoyongEnvironmentRule(
        id: 'eul_myo_metal_root_damage_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') ||
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

    ],
    '辰': [

      /// 1. 계·병 모두 있고 기·경 모두 없음
      JoyongEnvironmentRule(
        id: 'eul_jin_gui_bing_no_gi_gyeong_okdang_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            !ctx.stems.contains('己') &&
            !ctx.stems.contains('庚'),
      ),

      /// 2. 계·병·기·경 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_jin_gui_bing_gi_gyeong_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('己') &&
            ctx.stems.contains('庚'),
      ),

      /// 3. 을 1개 + 기 없음 + 경 존재
      JoyongEnvironmentRule(
        id: 'eul_jin_single_eul_gyeong_no_gi_small_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '乙').length == 1 &&
            ctx.stems.contains('庚') &&
            !ctx.stems.contains('己'),
      ),

      /// 4. 임·계·자·해 중 2개 이상
      JoyongEnvironmentRule(
        id: 'eul_jin_excess_water_control_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['子','亥'].contains(b)).length) >= 2,
      ),

      /// 5. 경·기 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_jin_gyeong_gi_mixed_low_grade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('己'),
      ),

      /// 6. 수국 + 병·무 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_jin_water_guk_bing_mu_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

      /// 7. 수국 + 병·무 모두 없음
      JoyongEnvironmentRule(
        id: 'eul_jin_water_guk_no_bing_mu_wander_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('戊'),
      ),

      /// 8. 계 + 자/해 + 신 존재
      JoyongEnvironmentRule(
        id: 'eul_jin_gui_water_with_shin_weak_wealth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['子','亥'].contains(b)) &&
            ctx.branches.contains('申'),
      ),

      /// 9. 임 + 자/해 존재
      JoyongEnvironmentRule(
        id: 'eul_jin_ren_water_overflow_life_path_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['子','亥'].contains(b)),
      ),

    ],
    '巳': [

      /// 1. 계 존재
      JoyongEnvironmentRule(
        id: 'eul_sa_gui_only_use_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 2. 경 존재 + 지지 신 1개 이상
      JoyongEnvironmentRule(
        id: 'eul_sa_gyeong_shin_clear_gui_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.contains('申'),
      ),

      /// 3. 계 + 경 + 신
      JoyongEnvironmentRule(
        id: 'eul_sa_gui_gyeong_shin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('庚') &&
            ctx.branches.contains('申'),
      ),

      /// 4. 계 1개 + 금 없음
      JoyongEnvironmentRule(
        id: 'eul_sa_single_gui_no_metal_local_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length == 1 &&
            !ctx.stems.contains('庚') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 5. 토 2개 이상
      JoyongEnvironmentRule(
        id: 'eul_sa_many_earth_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['戊','己'].contains(s)).length +
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length) >= 2,
      ),

      /// 6. 병 + 무 모두 존재 (+ 화국)
      JoyongEnvironmentRule(
        id: 'eul_sa_bing_mu_fire_guk_blind_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('戊') &&
            ctx.gukGroups.contains('화국'),
      ),

    ],
    '午': [

      /// 1. 계 존재 (하지 이전)
      JoyongEnvironmentRule(
        id: 'eul_o_gui_before_solstice_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 2. 병·계 모두 존재 (하지 이후)
      JoyongEnvironmentRule(
        id: 'eul_o_bing_gui_after_solstice_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// 3. 경 + 신(천간/지지) + 금수 3개 이상
      JoyongEnvironmentRule(
        id: 'eul_o_many_metal_water_use_fire_first_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)) &&
            (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
                ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 3,
      ),

      /// 4. 지지 화국 형성
      JoyongEnvironmentRule(
        id: 'eul_o_fire_guk_complete_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 5. 계 없음
      JoyongEnvironmentRule(
        id: 'eul_o_no_gui_dry_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('癸'),
      ),

      /// 6. 병 존재 + 화국
      JoyongEnvironmentRule(
        id: 'eul_o_bing_fire_guk_sickness_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.gukGroups.contains('화국'),
      ),

      /// 7. 화 + 토 3개 이상
      JoyongEnvironmentRule(
        id: 'eul_o_excess_fire_earth_useless_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length +
            ctx.stems.where((s) => ['戊','己'].contains(s)).length +
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length) >= 3,
      ),

    ],
    '未': [

      /// 1. 을 존재 + 금수 많음
      JoyongEnvironmentRule(
        id: 'eul_mi_eul_many_metal_water_use_bing_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            (ctx.stems.any((s) => ['庚','辛','壬','癸'].contains(s)) ||
                ctx.gukGroups.contains('수국') ||
                ctx.gukGroups.contains('금국')),
      ),

      /// 2. 지지 수국
      JoyongEnvironmentRule(
        id: 'eul_mi_water_guk_strong_flow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

      /// 3. 무·기 존재
      JoyongEnvironmentRule(
        id: 'eul_mi_mu_gi_control_gui_low_grade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// 4. 갑 + 무·기 존재
      JoyongEnvironmentRule(
        id: 'eul_mi_gap_controls_earth_clear_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// 5. 무·기 + 진·술·축·미
      JoyongEnvironmentRule(
        id: 'eul_mi_many_earth_heavy_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

      /// 6. 병·계·갑 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_mi_bing_gui_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('甲'),
      ),

      /// 7. 병·계 없음 + 정 존재
      JoyongEnvironmentRule(
        id: 'eul_mi_only_jeong_dry_common_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸') &&
            ctx.stems.contains('丁'),
      ),

      /// 8. 임·계·갑·을 모두 없음
      JoyongEnvironmentRule(
        id: 'eul_mi_no_water_wood_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['壬','癸','甲','乙'].contains(s)),
      ),

      /// 9. 무 + 진·술·축·미 + 비겁 없음
      JoyongEnvironmentRule(
        id: 'eul_mi_heavy_earth_no_companion_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            !ctx.stems.any((s) => ['甲','乙'].contains(s)) &&
            !ctx.branches.any((b) => ['寅','卯'].contains(b)),
      ),

      /// 10. 병 + 신 존재
      JoyongEnvironmentRule(
        id: 'eul_mi_bing_shin_transform_warning_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.contains('申'),
      ),

      /// 11. 을 + 인·묘 존재 + 병·계 없음
      JoyongEnvironmentRule(
        id: 'eul_mi_eul_root_no_fire_water_wander_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            ctx.branches.any((b) => ['寅','卯'].contains(b)) &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 12. 갑 + 인·묘 존재 + 병·계·경 없음
      JoyongEnvironmentRule(
        id: 'eul_mi_gap_root_no_control_wander_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','卯'].contains(b)) &&
            !ctx.stems.any((s) => ['丙','癸','庚'].contains(s)),
      ),

    ],
    '申': [

      /// 1. 경·신·유 2개 이상
      JoyongEnvironmentRule(
        id: 'eul_sin_many_gyeong_metal_strife_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '庚').length +
            ctx.branches.where((b) => ['申','酉'].contains(b)).length) >= 2,
      ),

      /// 2. 기 존재
      JoyongEnvironmentRule(
        id: 'eul_sin_gi_cover_metal_protect_wood_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('己'),
      ),

      /// 3. 계 존재 + 인/사/오 존재
      JoyongEnvironmentRule(
        id: 'eul_sin_gui_with_fire_branch_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// 4. 병 없음 + 계 존재
      JoyongEnvironmentRule(
        id: 'eul_sin_no_bing_gui_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// 5. 신·유 + 자·축 존재 + 병·기 없음
      JoyongEnvironmentRule(
        id: 'eul_sin_metal_water_no_control_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.any((b) => ['申','酉'].contains(b)) &&
            ctx.branches.any((b) => ['子','丑'].contains(b)) &&
            !ctx.stems.any((s) => ['丙','己'].contains(s)),
      ),

    ],
    '酉': [

      /// 1. 병·계 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_you_bing_gui_fame_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// 2. 지지 금국
      JoyongEnvironmentRule(
        id: 'eul_you_metal_guk_need_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('금국'),
      ),

      /// 3. 수·화 전부 없음
      JoyongEnvironmentRule(
        id: 'eul_you_no_water_fire_hardship_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['壬','癸','丙','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子','巳','午'].contains(b)),
      ),

      /// 4. 병·계·무 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_you_bing_gui_mu_mixed_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('戊'),
      ),

    ],
    '戌': [

      /// 1. 무 + 신 존재 (등라계갑)
      JoyongEnvironmentRule(
        id: 'eul_sul_mu_shin_depend_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.branches.contains('申'),
      ),

      /// 2. 계 존재 (+ 천간 신금은 문장에서 해석)
      JoyongEnvironmentRule(
        id: 'eul_sul_gui_with_shin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 3. 임 2개 이상 OR 임 + 해/자
      JoyongEnvironmentRule(
        id: 'eul_sul_excess_ren_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => ['亥','子'].contains(b))),
      ),

      /// 4. 인·신·진·술 2개 이상 + 무 존재
      JoyongEnvironmentRule(
        id: 'eul_sul_follow_wealth_no_companion_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['寅','申','辰','戌'].contains(b)).length >= 2 &&
            ctx.stems.contains('戊'),
      ),

    ],
    '亥': [

      /// 1. 병 or 무 1개 이상
      JoyongEnvironmentRule(
        id: 'eul_hae_bing_or_mu_need_light_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.any((s) => ['丙','戊'].contains(s)),
      ),

      /// 2. 병·무 모두 존재
      JoyongEnvironmentRule(
        id: 'eul_hae_bing_mu_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

      /// 3. 병 존재 + 무 없음
      JoyongEnvironmentRule(
        id: 'eul_hae_bing_no_mu_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('戊'),
      ),

      /// 4. 인·사·오 2개 이상
      JoyongEnvironmentRule(
        id: 'eul_hae_hidden_fire_south_luck_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['寅','巳','午'].contains(b)).length >= 2,
      ),

      /// 5. 임·계·해·자 2개 이상 + 무 없음
      JoyongEnvironmentRule(
        id: 'eul_hae_excess_water_no_earth_drift_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 2 &&
            !ctx.stems.contains('戊'),
      ),

      /// 6. 임·계·해·자 2개 이상 + 무 없음 + 병·사 없음
      JoyongEnvironmentRule(
        id: 'eul_hae_excess_water_no_fire_earth_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 2 &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('丙') &&
            !ctx.branches.contains('巳'),
      ),

      /// 7. 임 1개 + 무 2개 이상 OR 무 + 진/술
      JoyongEnvironmentRule(
        id: 'eul_hae_ren_heavy_earth_conflict_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (
                ctx.stems.where((s) => s == '戊').length >= 2 ||
                    (ctx.stems.contains('戊') &&
                        ctx.branches.any((b) => ['辰','戌'].contains(b)))
            ),
      ),

      /// 8. 지지 목국
      JoyongEnvironmentRule(
        id: 'eul_hae_mok_guk_spring_like_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

      /// 9. 병·무 모두 없음
      JoyongEnvironmentRule(
        id: 'eul_hae_no_bing_mu_repeat_failure_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('戊'),
      ),

    ],
    '子': [

      /// 1. 병 존재 + 계 없음
      JoyongEnvironmentRule(
        id: 'eul_ja_bing_no_gui_thaw_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 2. 인·사·오 1개 이상
      JoyongEnvironmentRule(
        id: 'eul_ja_hidden_fire_talent_official_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// 3. 임·계 1개 이상
      JoyongEnvironmentRule(
        id: 'eul_ja_water_strong_need_earth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 4. 수국 + 임·계 존재
      JoyongEnvironmentRule(
        id: 'eul_ja_water_guk_extreme_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 5. 정 1개
      JoyongEnvironmentRule(
        id: 'eul_ja_single_jeong_weak_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length == 1,
      ),

      /// 6. 병·정 모두 없음
      JoyongEnvironmentRule(
        id: 'eul_ja_no_fire_desolate_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// 7. 무·기 존재 + 화 전무
      JoyongEnvironmentRule(
        id: 'eul_ja_earth_only_survive_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['巳','午'].contains(b)),
      ),

      /// 8. 정 + 사/오
      JoyongEnvironmentRule(
        id: 'eul_ja_jeong_with_fire_group_risk_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['巳','午'].contains(b)),
      ),

      /// 9. 정 + 갑
      JoyongEnvironmentRule(
        id: 'eul_ja_jeong_gap_descendant_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// 10. 수국 + 임·계 1개 이상 (중복 강조 규칙)
      JoyongEnvironmentRule(
        id: 'eul_ja_water_guk_float_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 11. 무 1개 이상
      JoyongEnvironmentRule(
        id: 'eul_ja_mu_control_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

      /// 12. 목국 + 병/정
      JoyongEnvironmentRule(
        id: 'eul_ja_mok_guk_fire_complete_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// 13. 기 + 병
      JoyongEnvironmentRule(
        id: 'eul_ja_gi_bing_great_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.stems.contains('丙'),
      ),

    ],
    '丑': [

      /// 1. 병 존재 (계 투출 없음 전제)
      JoyongEnvironmentRule(
        id: 'eul_chuk_bing_thaw_high_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 2. 인·사·오 1개 이상
      JoyongEnvironmentRule(
        id: 'eul_chuk_hidden_fire_survival_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// 3. 병·정·인·사·오 전무
      JoyongEnvironmentRule(
        id: 'eul_chuk_no_fire_cold_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// 4. 기 + 축/미 존재, 갑·을 없음
      JoyongEnvironmentRule(
        id: 'eul_chuk_earth_only_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['丑','未'].contains(b)) &&
            !ctx.stems.any((s) => ['甲','乙'].contains(s)),
      ),

      /// 5. 기 + 축/미 존재, 갑·을 존재
      JoyongEnvironmentRule(
        id: 'eul_chuk_earth_with_wood_overwhelmed_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['丑','未'].contains(b)) &&
            ctx.stems.any((s) => ['甲','乙'].contains(s)),
      ),

      /// 6. 갑·기 + 진/술/축/미
      JoyongEnvironmentRule(
        id: 'eul_chuk_gap_gi_soil_control_need_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

    ],
  },
  /// =========================
  /// 丙火
  /// =========================
  '丙': {
    '寅': [

      /// 1. 임·경 존재
      JoyongEnvironmentRule(
        id: 'byeong_in_ren_gyeong_water_fire_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('庚'),
      ),

      /// 2. 임·경 모두 투출 → 과갑
      JoyongEnvironmentRule(
        id: 'byeong_in_ren_gyeong_high_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('庚'),
      ),

      /// 3. 임 + 사 / 신·유
      JoyongEnvironmentRule(
        id: 'byeong_in_hidden_metal_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (
                ctx.branches.contains('巳') ||
                    ctx.branches.any((b) => ['申','酉'].contains(b))
            ),
      ),

      /// 4. 경 + 인·사·오 1~2
      JoyongEnvironmentRule(
        id: 'byeong_in_gyeong_heroic_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).isNotEmpty &&
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).length <= 2,
      ),

      /// 5. 경신금 무리
      JoyongEnvironmentRule(
        id: 'byeong_in_gyeong_shin_mix_common_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 6. 경 2개 + 신금 없음
      JoyongEnvironmentRule(
        id: 'byeong_in_double_gyeong_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '庚').length >= 2 &&
            !ctx.branches.contains('申'),
      ),

      /// 7. 병 적고 무 없음 + 임 존재
      JoyongEnvironmentRule(
        id: 'byeong_in_ren_overflow_hidden_blade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.where((s) => s == '丙').length <= 1 &&
            !ctx.stems.contains('戊'),
      ),

      /// 8. 무·진·술 3개 이상
      JoyongEnvironmentRule(
        id: 'byeong_in_heavy_earth_block_light_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '戊').length +
            ctx.branches.where((b) => ['辰','戌'].contains(b)).length) >= 3,
      ),

      /// 9. 화국 + 임·계
      JoyongEnvironmentRule(
        id: 'byeong_in_fire_guk_need_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 10. 화국 + 임·계 없음
      JoyongEnvironmentRule(
        id: 'byeong_in_fire_guk_no_water_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 11. 화국 일반 경고
      JoyongEnvironmentRule(
        id: 'byeong_in_fire_guk_season_miss_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 12. 갑 존재
      JoyongEnvironmentRule(
        id: 'byeong_in_gap_hidden_control_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// 13. 임 없음 + 계 존재
      JoyongEnvironmentRule(
        id: 'byeong_in_no_ren_use_gui_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

      /// 14. 임 없음
      JoyongEnvironmentRule(
        id: 'byeong_in_no_ren_poor_balance_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬'),
      ),

    ],
    '卯': [

      /// 1. 임 존재 + 경신금·기토 조화 + 임수 뿌리
      JoyongEnvironmentRule(
        id: 'byeong_myo_ren_balance_high_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.any((s) => ['庚','辛','己'].contains(s)) &&
            ctx.branches.any((b) => ['亥','子','申'].contains(b)),
      ),

      /// 2. 임 없음 + 기 존재
      JoyongEnvironmentRule(
        id: 'byeong_myo_no_ren_use_gi_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('己'),
      ),

      /// 3. 임 + 해·자·신 + 무 존재
      JoyongEnvironmentRule(
        id: 'byeong_myo_ren_group_control_examless_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['亥','子','申'].contains(b)) &&
            ctx.stems.contains('戊'),
      ),

      /// 4. 임 + 해·자·신 + 무 없음
      JoyongEnvironmentRule(
        id: 'byeong_myo_ren_group_no_mu_common_office_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['亥','子','申'].contains(b)) &&
            !ctx.stems.contains('戊'),
      ),

      /// 5. 임 + 해·자·신 + 무토 전무
      JoyongEnvironmentRule(
        id: 'byeong_myo_ren_group_no_earth_wander_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['亥','子','申'].contains(b)) &&
            !ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            !ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// 6. 임 + 해·자·신 + 토 전무 + 금 다수
      JoyongEnvironmentRule(
        id: 'byeong_myo_ren_metal_cold_useless_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['亥','子','申'].contains(b)) &&
            !ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 7. 지지 목국
      JoyongEnvironmentRule(
        id: 'byeong_myo_mok_guk_cunning_gain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

    ],
    '辰': [

      /// 1. 진·술·축·미 2개 이상 (부)
      JoyongEnvironmentRule(
        id: 'byeong_jin_heavy_earth_need_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

      /// 2. 임·갑 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_jin_ren_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// 3. 갑 없음 + 경 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_jin_no_gap_use_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// 4. 임 존재 + 인·묘·해 1개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_jin_hidden_gap_wealth_small_honor_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['寅','卯','亥'].contains(b)),
      ),

      /// 5. 갑 존재 + 임 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_jin_gap_no_ren_turbid_wealth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('壬'),
      ),

      /// 6. 신·해·자 1개 이상 + 갑 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_jin_hidden_ren_no_gap_poor_scholar_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.any((b) => ['申','亥','子'].contains(b)) &&
            !ctx.stems.contains('甲'),
      ),

      /// 7. 임·갑 모두 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_jin_no_ren_no_gap_base_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('甲'),
      ),

      /// 8. 을·정 모두 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_jin_eul_jeong_mixed_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            ctx.stems.contains('丁'),
      ),

    ],
    '巳': [

      /// 1. 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sa_use_ren_cooling_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 2. 임 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sa_no_ren_isolated_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬'),
      ),

      /// 3. 경 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sa_gyeong_water_root_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// 4. 임·경 모두 있고 무 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sa_ren_gyeong_no_mu_high_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('庚') &&
            !ctx.stems.contains('戊'),
      ),

      /// 5. 임 없음 + 계 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sa_no_ren_use_gui_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

      /// 6. 경·계 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sa_gyeong_gui_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('癸'),
      ),

      /// 7. 임·계 모두 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sa_no_water_stubborn_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// 8. 경 존재 + 신·유 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sa_heavy_gyeong_wealth_no_honor_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 9. 오 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sa_o_day_pain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.branches.contains('午'),
      ),

      /// 10. 수국 + 임 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sa_water_guk_robbery_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('壬'),
      ),

      /// 11. 수국 + 임 + 기 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sa_water_guk_ren_gi_dirty_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('壬') &&
            ctx.stems.contains('己'),
      ),

    ],
    '午': [

      /// 1. 임·경 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_ren_gyeong_high_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('庚'),
      ),

      /// 2. 임 존재 + 경 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_ren_no_gyeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            !ctx.stems.contains('庚'),
      ),

      /// 3. 임·경 모두 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_no_ren_gyeong_hidden_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('庚'),
      ),

      /// 4. 갑·기 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_gap_gi_martial_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('己'),
      ),

      /// 5. 화국 (부)
      JoyongEnvironmentRule(
        id: 'byeong_o_fire_guk_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 6. 화국 + 계 1개 이상 (부)
      JoyongEnvironmentRule(
        id: 'byeong_o_fire_guk_gui_dry_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('癸'),
      ),

      /// 7. 화국 + 갑·기 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_o_fire_guk_gap_gi_pain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('己'),
      ),

      /// 8. 경·신 없음 + 갑·을·인·묘 2개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_mok_fire_only_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.branches.contains('申') &&
            ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
                ctx.branches.where((b) => ['寅','卯'].contains(b)).length >= 2,
      ),

      /// 9. 경·계 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_gyeong_gui_official_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('癸'),
      ),

      /// 10. 해·자 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_hidden_water_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 11. 토국 + 갑 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_o_earth_guk_gap_longevity_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2 &&
            ctx.stems.contains('甲'),
      ),

    ],
    '未': [

      /// 1. 경·임 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_mi_gyeong_ren_high_official_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('壬'),
      ),

      /// 2. 경 없음 + 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_mi_ren_no_gyeong_local_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            ctx.stems.contains('壬'),
      ),

      /// 3. 기 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_mi_gi_mixed_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('己'),
      ),

      /// 4. 임·기 모두 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_mi_ren_gi_poverty_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('己'),
      ),

      /// 5. 임 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_mi_no_ren_low_class_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬'),
      ),

      /// 6. 병·정 1개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_mi_fire_root_need_gyeong_ren_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// 7. 병 1개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_mi_prefer_mok_fire_luck_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

    ],
    '申': [

      /// 1. 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sin_use_ren_late_sun_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 2. 임·무 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sin_ren_mu_high_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('戊'),
      ),

      /// 3. 진·술·신·인 1개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sin_hidden_mu_local_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['辰','戌','申','寅'].contains(b)),
      ),

      /// 4. 임 2개 이상 OR 임 + 자/해, 무 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sin_excess_ren_no_mu_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') &&
                    ctx.branches.any((b) => ['子','亥'].contains(b)))
        ) &&
            !ctx.stems.contains('戊'),
      ),

      /// 5. 임 과다 + 무 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sin_excess_ren_with_mu_power_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') &&
                    ctx.branches.any((b) => ['子','亥'].contains(b)))
        ) &&
            ctx.stems.contains('戊'),
      ),

      /// 6. 천간 신 + 지지 신·유 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sin_heavy_metal_follow_power_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

    ],
    '酉': [

      /// 1. 병·사 2개 이상 + 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_yu_heavy_fire_ren_complete_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length +
            ctx.branches.where((b) => b == '巳').length >= 2 &&
            ctx.stems.contains('壬'),
      ),

      /// 2. 해·자·신 1개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_yu_hidden_ren_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['亥','子','申'].contains(b)),
      ),

      /// 3. 무·진·술 2개 이상 (부)
      JoyongEnvironmentRule(
        id: 'byeong_yu_heavy_earth_fake_scholar_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length +
            ctx.branches.where((b) => ['辰','戌'].contains(b)).length >= 2,
      ),

      /// 4. 임 없음 + 계 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_yu_no_ren_use_gui_short_fame_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

      /// 5. 천간 신 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_yu_sin_exposed_poor_old_age_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// 6. 천간 신·정 모두 존재 (부)
      JoyongEnvironmentRule(
        id: 'byeong_yu_sin_jeong_cunning_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.stems.contains('丁'),
      ),

      /// 7. 금국 + 신 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_yu_metal_guk_no_sin_empty_wealth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            !ctx.stems.contains('辛'),
      ),

      /// 8. 금국 + 신 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_yu_metal_guk_with_sin_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('辛'),
      ),

    ],
    '戌': [

      /// 1. 갑·임 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sul_gap_ren_complete_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('壬'),
      ),

      /// 2. 임 없음 + 계 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sul_no_ren_use_gui_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

      /// 3. 진·신·해·자·축 1개 이상 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sul_hidden_water_exam_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['辰','申','亥','子','丑'].contains(b)),
      ),

      /// 4. 해·인·묘 1개 이상 + 임 존재 + 경 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_sul_hidden_gap_ren_no_gyeong_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.stems.contains('壬') &&
            !ctx.stems.contains('庚'),
      ),

      /// 5. 경 또는 무 1개 이상 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sul_gyeong_or_mu_common_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.any((s) => ['庚','戊'].contains(s)),
      ),

      /// 6. 갑·임·계 모두 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sul_no_gap_ren_gui_base_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// 7. 화·토 3개 이상 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sul_heavy_fire_earth_wander_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁','戊','己'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午','辰','戌','丑','未'].contains(b)).length >= 3,
      ),

      /// 8. 화·토 3개 이상 + 금·수 전무 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sul_heavy_fire_earth_no_metal_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁','戊','己'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午','辰','戌','丑','未'].contains(b)).length >= 3 &&
            !ctx.stems.any((s) => ['庚','辛','壬','癸'].contains(s)),
      ),

      /// 9. 화국 (부)
      JoyongEnvironmentRule(
        id: 'byeong_sul_fire_guk_late_poverty_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

    ],
    '亥': [
      /// 1. 갑·무·경 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_hae_gap_mu_gyeong_leader_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('戊') &&
            ctx.stems.contains('庚'),
      ),

      /// 2. 천간 신 + 지지 진 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_hae_sin_jin_hap_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.branches.contains('辰'),
      ),

      /// 3. 임 2개 이상 OR 임+해, 갑 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_hae_excess_ren_no_gap_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') && ctx.branches.contains('亥'))
        ) &&
            !ctx.stems.contains('甲'),
      ),

      /// 4. 임 과다 + 갑 존재 + 무 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_hae_excess_ren_gap_no_mu_dirty_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') && ctx.branches.contains('亥'))
        ) &&
            ctx.stems.contains('甲') &&
            !ctx.stems.contains('戊'),
      ),

      /// 5. 병 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_hae_general_rule_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

    ],
    '子': [

      /// 1. 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_ren_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 2. 무 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_mu_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

      /// 3. 임 + 무 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_ren_mu_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('戊'),
      ),

      /// 4. 임 + 기 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_ren_ji_alternate_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('己'),
      ),

      /// 5. 임 없음 + 계 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_no_ren_gui_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

      /// 6. 임 + 해/자 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_ren_cluster_no_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (ctx.branches.contains('亥') || ctx.branches.contains('子')),
      ),

      /// 7. 임 + 해/자 존재 + 갑 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_ja_ren_cluster_no_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (ctx.branches.contains('亥') || ctx.branches.contains('子')) &&
            !ctx.stems.contains('甲'),
      ),

      /// 8. 임 + 해/자 존재 + 갑 존재 + 무 없음 (부)
      JoyongEnvironmentRule(
        id: 'byeong_ja_ren_cluster_gap_no_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (ctx.branches.contains('亥') || ctx.branches.contains('子')) &&
            ctx.stems.contains('甲') &&
            !ctx.stems.contains('戊'),
      ),

    ],
    '丑': [

      /// 1. 임 + 갑 모두 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_chuk_ren_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// 2. 갑 없음 + 해/인/묘 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_chuk_no_gap_hidden_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            (ctx.branches.contains('亥') ||
                ctx.branches.contains('寅') ||
                ctx.branches.contains('卯')),
      ),

      /// 3. 갑 없음 + 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_chuk_no_gap_single_ren_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            ctx.stems.contains('壬'),
      ),

      /// 4. 기 2개 또는 (기 + 축/미) + 갑·을 없음 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_chuk_ji_group_no_wood_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final jiCount = ctx.stems.where((s) => s == '己').length;
          final hasJiCombo =
              ctx.stems.contains('己') &&
                  (ctx.branches.contains('丑') || ctx.branches.contains('未'));

          return (jiCount >= 2 || hasJiCombo) &&
              !ctx.stems.contains('甲') &&
              !ctx.stems.contains('乙');
        },
      ),

      /// 5. 계 2개 또는 (계 + 해/자) + 기 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_chuk_gui_ji_self_made_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final guiCount = ctx.stems.where((s) => s == '癸').length;
          final hasGuiCombo =
              ctx.stems.contains('癸') &&
                  (ctx.branches.contains('亥') || ctx.branches.contains('子'));

          return (guiCount >= 2 || hasGuiCombo) &&
              ctx.stems.contains('己');
        },
      ),

      /// 6. 계 존재 (긍)
      JoyongEnvironmentRule(
        id: 'byeong_chuk_gui_literary_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

    ],
  },
  /// =========================
  /// 丁火
  /// =========================
  '丁': {
    '寅': [

      /// 1. 경 존재 (긍)
      JoyongEnvironmentRule(
        id: 'jeong_in_gyeong_needed_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// 2. 갑 + 인/묘 존재 & 경 없음 (부)
      JoyongEnvironmentRule(
        id: 'jeong_in_many_gap_no_gyeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            (ctx.branches.contains('寅') || ctx.branches.contains('卯')) &&
            !ctx.stems.contains('庚'),
      ),

      /// 3. 갑 1 + 을/묘 2 이상 (부)
      JoyongEnvironmentRule(
        id: 'jeong_in_single_gap_many_eul_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final gapCount = ctx.stems.where((s) => s == '甲').length;
          final eulMyoCount =
              ctx.stems.where((s) => s == '乙').length +
                  ctx.branches.where((b) => b == '卯').length;

          return gapCount == 1 && eulMyoCount >= 2;
        },
      ),

      /// 4. 임 존재 (긍)
      JoyongEnvironmentRule(
        id: 'jeong_in_ren_transform_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 5. 경 + 임/계 + 기 존재 (긍)
      JoyongEnvironmentRule(
        id: 'jeong_in_gyeong_ren_gui_gi_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')) &&
            ctx.stems.contains('己'),
      ),

      /// 6. 임/계 + 해/자 존재 (부)
      JoyongEnvironmentRule(
        id: 'jeong_in_many_water_no_support_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.contains('壬') || ctx.stems.contains('癸')) &&
            (ctx.branches.contains('亥') || ctx.branches.contains('子')),
      ),

      /// 7. 지지 화국 + 수 전무 (부)
      JoyongEnvironmentRule(
        id: 'jeong_in_fire_bureau_no_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸') &&
            !ctx.branches.contains('亥') &&
            !ctx.branches.contains('子'),
      ),


    ],
    '卯': [

      /// [경][갑] 존재
      JoyongEnvironmentRule(
        id: 'jeong_myo_gyeong_gap_use_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [경][갑] 모두 존재 (상격)
      JoyongEnvironmentRule(
        id: 'jeong_myo_gyeong_gap_top_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [경] 존재 + [해][인][묘]
      JoyongEnvironmentRule(
        id: 'jeong_myo_gyeong_hidden_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [갑] 존재 + [사][신][유]
      JoyongEnvironmentRule(
        id: 'jeong_myo_gap_hidden_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// [경][을] 모두 있음
      JoyongEnvironmentRule(
        id: 'jeong_myo_gyeong_eul_bind_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('乙'),
      ),

      /// [경] 있고 [묘][진][미]
      JoyongEnvironmentRule(
        id: 'jeong_myo_gyeong_with_eul_light_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['卯','辰','未'].contains(b)),
      ),

      /// [을] 있고 [갑] 없음
      JoyongEnvironmentRule(
        id: 'jeong_myo_only_eul_no_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            !ctx.stems.contains('甲'),
      ),

      /// 지지 목국 + [경]
      JoyongEnvironmentRule(
        id: 'jeong_myo_mok_guk_with_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('庚'),
      ),

      /// 지지 목국 + [경] 없음
      JoyongEnvironmentRule(
        id: 'jeong_myo_mok_guk_no_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            !ctx.stems.contains('庚'),
      ),

      /// [계] 존재
      JoyongEnvironmentRule(
        id: 'jeong_myo_gui_moist_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [임][계]+[해][자] 있고 [무] 없음
      JoyongEnvironmentRule(
        id: 'jeong_myo_excess_water_no_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.contains('壬') || ctx.stems.contains('癸')) &&
            ctx.branches.any((b) => ['亥','子'].contains(b)) &&
            !ctx.stems.contains('戊'),
      ),

      /// [을] 있고 [계][자] 2개 이상 + [무]
      JoyongEnvironmentRule(
        id: 'jeong_myo_eul_gui_controlled_by_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            (ctx.stems.where((s) => s == '癸').length +
                ctx.branches.where((b) => b == '子').length) >= 2 &&
            ctx.stems.contains('戊'),
      ),
    ],
    '辰': [

      /// [갑][경] 존재
      JoyongEnvironmentRule(
        id: 'jeong_jin_gap_gyeong_use_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// [갑][경] 모두 존재 (상격)
      JoyongEnvironmentRule(
        id: 'jeong_jin_gap_gyeong_top_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// [경] 있고 [해][인][묘]
      JoyongEnvironmentRule(
        id: 'jeong_jin_gyeong_hidden_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [갑] 있고 [사][신][유]
      JoyongEnvironmentRule(
        id: 'jeong_jin_gap_hidden_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// 지지 목국
      JoyongEnvironmentRule(
        id: 'jeong_jin_mok_guk_use_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

      /// [경] 존재 + [정][계] 없음
      JoyongEnvironmentRule(
        id: 'jeong_jin_only_gyeong_no_fire_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.stems.contains('丁') &&
            !ctx.stems.contains('癸'),
      ),

      /// 지지 수국 + [임]
      JoyongEnvironmentRule(
        id: 'jeong_jin_water_guk_im_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('壬'),
      ),

      /// 지지 수국 + [임] + [갑][기]
      JoyongEnvironmentRule(
        id: 'jeong_jin_water_guk_im_gap_gi_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('壬') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('己'),
      ),
    ],
    '巳': [

      /// [갑][경] 존재
      JoyongEnvironmentRule(
        id: 'jeong_sa_gap_gyeong_mokhwa_tongmyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// [갑] 존재 (계수 기피)
      JoyongEnvironmentRule(
        id: 'jeong_sa_many_gap_avoid_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// [자][축][진] + [임]
      JoyongEnvironmentRule(
        id: 'jeong_sa_im_with_water_root_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [경] 있고 [갑] 없음 + [무]
      JoyongEnvironmentRule(
        id: 'jeong_sa_gyeong_no_gap_with_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲') &&
            ctx.stems.contains('戊'),
      ),

      /// [무] 있고 [갑][을] 없음 + 수 없음
      JoyongEnvironmentRule(
        id: 'jeong_sa_mu_only_shangguan_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            !ctx.stems.any((s) => ['甲','乙'].contains(s)) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 수 2개 이상 + 목 2개 이상
      JoyongEnvironmentRule(
        id: 'jeong_sa_excess_water_wood_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 2 &&
            (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
                ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 2,
      ),

      /// [병][사] 2개 이상 + 수 없음
      JoyongEnvironmentRule(
        id: 'jeong_sa_excess_fire_no_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length +
            ctx.branches.where((b) => b == '巳').length) >= 2 &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),
    ],
    '午': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'jeong_o_im_loyal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// 화국 + 병정화 + 경임
      JoyongEnvironmentRule(
        id: 'jeong_o_fire_guk_full_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('壬'),
      ),

      /// [무][기] + [임]
      JoyongEnvironmentRule(
        id: 'jeong_o_earth_control_im_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.stems.contains('壬'),
      ),

      /// 지지 [신][해][자]
      JoyongEnvironmentRule(
        id: 'jeong_o_hidden_im_future_dev_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [계] 1개
      JoyongEnvironmentRule(
        id: 'jeong_o_single_gui_authority_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length == 1,
      ),

      /// [인][진][사][해]
      JoyongEnvironmentRule(
        id: 'jeong_o_in_jin_sa_hae_life_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','辰','巳','亥'].contains(b)),
      ),

      /// 화 전부 없음 + 임계
      JoyongEnvironmentRule(
        id: 'jeong_o_no_fire_need_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['巳','午'].contains(b)) &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 목 1~2 + 화 2 이상
      JoyongEnvironmentRule(
        id: 'jeong_o_few_wood_many_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final woodCount =
              ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
                  ctx.branches.where((b) => ['寅','卯'].contains(b)).length;
          final fireCount =
              ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
                  ctx.branches.where((b) => ['巳','午'].contains(b)).length;
          return woodCount >= 1 && woodCount <= 2 && fireCount >= 2;
        },
      ),
    ],
    '未': [

      /// [갑] 있고 지지 목국
      JoyongEnvironmentRule(
        id: 'jeong_mi_gap_mok_guk_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.gukGroups.contains('목국'),
      ),

      /// [갑] 있고 지지 목국 아님 + [신][해][자]
      JoyongEnvironmentRule(
        id: 'jeong_mi_gap_no_mok_guk_hidden_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.gukGroups.contains('목국') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// 지지 목국 + [임][계]
      JoyongEnvironmentRule(
        id: 'jeong_mi_mok_guk_with_im_gui_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 지지 목국 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'jeong_mi_mok_guk_no_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            !ctx.stems.contains('甲'),
      ),
    ],
    '申': [

      /// [갑][경][병] 존재 (조후 기본)
      JoyongEnvironmentRule(
        id: 'jeong_sin_gap_gyeong_byeong_core_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// [을] 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'jeong_sin_eul_no_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑][경][병] 모두 존재 (급제 상격)
      JoyongEnvironmentRule(
        id: 'jeong_sin_gap_gyeong_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// [을][경][병] 존재
      JoyongEnvironmentRule(
        id: 'jeong_sin_eul_gyeong_byeong_small_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// [임][계] 과다
      JoyongEnvironmentRule(
        id: 'jeong_sin_excess_water_need_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length >= 2) ||
            (ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
                ctx.branches.any((b) => ['亥','子'].contains(b))),
      ),

      /// [경] + [신][유]
      JoyongEnvironmentRule(
        id: 'jeong_sin_gyeong_with_metal_branches_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// [임][해] 2개 이상
      JoyongEnvironmentRule(
        id: 'jeong_sin_excess_im_transform_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length +
            ctx.branches.where((b) => b == '亥').length >= 2,
      ),

      /// [경] 2개 이상 + [임] 없음
      JoyongEnvironmentRule(
        id: 'jeong_sin_many_gyeong_no_im_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '庚').length >= 2 &&
            !ctx.stems.contains('壬'),
      ),
    ],
    '酉': [

      /// [갑][경][병] 존재 (조후 기본)
      JoyongEnvironmentRule(
        id: 'jeong_yu_gap_gyeong_byeong_core_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// [을] 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'jeong_yu_eul_no_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑][경][병] 모두 존재 (급제 상격)
      JoyongEnvironmentRule(
        id: 'jeong_yu_gap_gyeong_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// [을][경][병] 존재
      JoyongEnvironmentRule(
        id: 'jeong_yu_eul_gyeong_byeong_small_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('乙') &&
            ctx.stems.contains('庚') &&
            ctx.stems.contains('丙'),
      ),

      /// [임][계] 과다
      JoyongEnvironmentRule(
        id: 'jeong_yu_excess_water_need_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length >= 2) ||
            (ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
                ctx.branches.any((b) => ['亥','子'].contains(b))),
      ),

      /// [경] + [신][유]
      JoyongEnvironmentRule(
        id: 'jeong_yu_gyeong_with_metal_branches_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// [임][해] 2개 이상
      JoyongEnvironmentRule(
        id: 'jeong_yu_excess_im_transform_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length +
            ctx.branches.where((b) => b == '亥').length >= 2,
      ),

      /// [경] 2개 이상 + [임] 없음
      JoyongEnvironmentRule(
        id: 'jeong_yu_many_gyeong_no_im_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '庚').length >= 2 &&
            !ctx.stems.contains('壬'),
      ),

      /// 천간 [신] + 지지 [신][유]
      JoyongEnvironmentRule(
        id: 'jeong_yu_sin_metal_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),
    ],
    '戌': [

      /// [무] + [진][술][축][미]
      JoyongEnvironmentRule(
        id: 'jeong_sul_mu_earth_overflow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

      /// [무] + [진][술][축][미] + [갑] 없음
      JoyongEnvironmentRule(
        id: 'jeong_sul_mu_no_gap_shangguan_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 존재
      JoyongEnvironmentRule(
        id: 'jeong_sul_gap_mokhwa_tongmyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),
    ],
    '亥': [

      /// [경][갑] 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_gyeong_gap_balanced_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [경][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_no_gyeong_no_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 과다 또는 [갑]+[인][묘]
      JoyongEnvironmentRule(
        id: 'jeong_hae_many_gap_top_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length >= 2 ||
            (ctx.stems.contains('甲') &&
                ctx.branches.any((b) => ['寅','卯'].contains(b))),
      ),

      /// [경][갑] 모두 존재 + [기] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_gyeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 1개 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_single_byeong_light_steal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1,
      ),

      /// [병] 1개 + 수국 또는 [해][자][신][유]
      JoyongEnvironmentRule(
        id: 'jeong_hae_byeong_with_water_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            (ctx.gukGroups.contains('수국') ||
                ctx.branches.any((b) => ['亥','子','申','酉'].contains(b))),
      ),

      /// [병] 1개 + [계] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_byeong_no_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            !ctx.stems.contains('癸'),
      ),

      /// [경] + [신][유] 있고 수 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_metal_no_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 수 있음 + 금 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_water_no_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.any((s) => ['壬','癸'].contains(s)) ||
            ctx.branches.any((b) => ['亥','子'].contains(b))) &&
            !ctx.stems.contains('庚') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// [무] 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_mu_control_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

      /// [무] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_no_mu_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('戊'),
      ),

      /// [인][진][사][신][술][해]
      JoyongEnvironmentRule(
        id: 'jeong_hae_hidden_mu_keep_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','辰','巳','申','戌','亥'].contains(b)),
      ),

      /// 수 과다 + 계수
      JoyongEnvironmentRule(
        id: 'jeong_hae_excess_water_gui_special_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 3 &&
            ctx.stems.contains('癸'),
      ),
    ],
    '子': [

      /// [경][갑] 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_gyeong_gap_balanced_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [경][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_no_gyeong_no_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 과다 또는 [갑]+[인][묘]
      JoyongEnvironmentRule(
        id: 'jeong_hae_many_gap_top_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length >= 2 ||
            (ctx.stems.contains('甲') &&
                ctx.branches.any((b) => ['寅','卯'].contains(b))),
      ),

      /// [경][갑] 모두 존재 + [기] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_gyeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 1개 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_single_byeong_light_steal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1,
      ),

      /// [병] 1개 + 수국 또는 [해][자][신][유]
      JoyongEnvironmentRule(
        id: 'jeong_hae_byeong_with_water_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            (ctx.gukGroups.contains('수국') ||
                ctx.branches.any((b) => ['亥','子','申','酉'].contains(b))),
      ),

      /// [병] 1개 + [계] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_byeong_no_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            !ctx.stems.contains('癸'),
      ),

      /// [경] + [신][유] 있고 수 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_metal_no_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 수 있음 + 금 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_water_no_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.any((s) => ['壬','癸'].contains(s)) ||
            ctx.branches.any((b) => ['亥','子'].contains(b))) &&
            !ctx.stems.contains('庚') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// [무] 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_mu_control_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

      /// [무] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_no_mu_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('戊'),
      ),

      /// [인][진][사][신][술][해]
      JoyongEnvironmentRule(
        id: 'jeong_hae_hidden_mu_keep_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','辰','巳','申','戌','亥'].contains(b)),
      ),

      /// 수 과다 + 계수
      JoyongEnvironmentRule(
        id: 'jeong_hae_excess_water_gui_special_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 3 &&
            ctx.stems.contains('癸'),
      ),
    ],
    '丑': [

      /// [경][갑] 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_gyeong_gap_balanced_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [경][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_no_gyeong_no_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 과다 또는 [갑]+[인][묘]
      JoyongEnvironmentRule(
        id: 'jeong_hae_many_gap_top_class_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length >= 2 ||
            (ctx.stems.contains('甲') &&
                ctx.branches.any((b) => ['寅','卯'].contains(b))),
      ),

      /// [경][갑] 모두 존재 + [기] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_gyeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 1개 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_single_byeong_light_steal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1,
      ),

      /// [병] 1개 + 수국 또는 [해][자][신][유]
      JoyongEnvironmentRule(
        id: 'jeong_hae_byeong_with_water_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            (ctx.gukGroups.contains('수국') ||
                ctx.branches.any((b) => ['亥','子','申','酉'].contains(b))),
      ),

      /// [병] 1개 + [계] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_byeong_no_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            !ctx.stems.contains('癸'),
      ),

      /// [경] + [신][유] 있고 수 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_metal_no_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 수 있음 + 금 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_water_no_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.any((s) => ['壬','癸'].contains(s)) ||
            ctx.branches.any((b) => ['亥','子'].contains(b))) &&
            !ctx.stems.contains('庚') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// [무] 존재
      JoyongEnvironmentRule(
        id: 'jeong_hae_mu_control_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

      /// [무] 없음
      JoyongEnvironmentRule(
        id: 'jeong_hae_no_mu_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('戊'),
      ),

      /// [인][진][사][신][술][해]
      JoyongEnvironmentRule(
        id: 'jeong_hae_hidden_mu_keep_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','辰','巳','申','戌','亥'].contains(b)),
      ),

      /// 수 과다 + 계수
      JoyongEnvironmentRule(
        id: 'jeong_hae_excess_water_gui_special_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 3 &&
            ctx.stems.contains('癸'),
      ),
    ],
  },
  /// =========================
  /// 戊土
  /// =========================
  '戊': {
    '寅': [

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_warm_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [병] 없음
      JoyongEnvironmentRule(
        id: 'mu_in_no_byeong_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙'),
      ),

      /// [병][갑][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_gap_gui_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('癸'),
      ),

      /// [병][갑] + 지지 [자][축][진]
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_gap_hidden_gui_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [갑][계] + [인][사][오]
      JoyongEnvironmentRule(
        id: 'mu_in_gap_gui_hidden_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [계][병] + [묘][인][해]
      JoyongEnvironmentRule(
        id: 'mu_in_gui_byeong_hidden_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['卯','寅','亥'].contains(b)),
      ),

      /// [병] + [해][인][묘] + [자][축][진]      병갑계甲'癸
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_multi_hidden_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [갑] + 병계암장
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_multi_hidden_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [계] + 병갑암장
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_multi_hidden_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [병] 과다 + 계수 없음
      JoyongEnvironmentRule(
        id: 'mu_in_strong_byeong_no_gui_late_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            ctx.branches.any((b) => ['巳','午'].contains(b))) &&
            !ctx.stems.contains('癸'),
      ),

      /// [병] 있으나 [갑][계] 없음
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_no_gap_gui_drought_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸'),
      ),

      /// 화국 + 임계 없음
      JoyongEnvironmentRule(
        id: 'mu_in_fire_guk_no_water_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 화국 + 계수
      JoyongEnvironmentRule(
        id: 'mu_in_fire_guk_gui_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('癸'),
      ),

      /// 화국 + 임수
      JoyongEnvironmentRule(
        id: 'mu_in_fire_guk_im_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('壬'),
      ),

      /// 갑목 과다 + 병 없음
      JoyongEnvironmentRule(
        id: 'mu_in_many_gap_no_byeong_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '甲').length >= 2 ||
            ctx.branches.any((b) => ['寅','卯'].contains(b))) &&
            !ctx.stems.contains('丙'),
      ),

      /// 수국 + 갑경
      JoyongEnvironmentRule(
        id: 'mu_in_water_guk_gap_gyeong_complete_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// 경·화·토 전무
      JoyongEnvironmentRule(
        id: 'mu_in_no_support_extreme_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// 을목 과다
      JoyongEnvironmentRule(
        id: 'mu_in_many_eul_cunning_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '乙').length >= 2 ||
            ctx.branches.any((b) => ['寅','卯'].contains(b)),
      ),
    ],
    '卯': [

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_warm_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [병] 없음
      JoyongEnvironmentRule(
        id: 'mu_in_no_byeong_cold_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙'),
      ),

      /// [병][갑][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_gap_gui_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('癸'),
      ),

      /// [병][갑] + 지지 [자][축][진]
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_gap_hidden_gui_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [갑][계] + [인][사][오]
      JoyongEnvironmentRule(
        id: 'mu_in_gap_gui_hidden_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [계][병] + [묘][인][해]
      JoyongEnvironmentRule(
        id: 'mu_in_gui_byeong_hidden_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['卯','寅','亥'].contains(b)),
      ),

      /// [병] + [해][인][묘] + [자][축][진]      병갑계甲'癸
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_multi_hidden_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [갑] + 병계암장
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_multi_hidden_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [계] + 병갑암장
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_multi_hidden_skill_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [병] 과다 + 계수 없음
      JoyongEnvironmentRule(
        id: 'mu_in_strong_byeong_no_gui_late_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            ctx.branches.any((b) => ['巳','午'].contains(b))) &&
            !ctx.stems.contains('癸'),
      ),

      /// [병] 있으나 [갑][계] 없음
      JoyongEnvironmentRule(
        id: 'mu_in_byeong_no_gap_gui_drought_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸'),
      ),

      /// 화국 + 임계 없음
      JoyongEnvironmentRule(
        id: 'mu_in_fire_guk_no_water_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 화국 + 계수
      JoyongEnvironmentRule(
        id: 'mu_in_fire_guk_gui_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('癸'),
      ),

      /// 화국 + 임수
      JoyongEnvironmentRule(
        id: 'mu_in_fire_guk_im_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('壬'),
      ),

      /// 갑목 과다 + 병 없음
      JoyongEnvironmentRule(
        id: 'mu_in_many_gap_no_byeong_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '甲').length >= 2 ||
            ctx.branches.any((b) => ['寅','卯'].contains(b))) &&
            !ctx.stems.contains('丙'),
      ),

      /// 수국 + 갑경
      JoyongEnvironmentRule(
        id: 'mu_in_water_guk_gap_gyeong_complete_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// 경·화·토 전무
      JoyongEnvironmentRule(
        id: 'mu_in_no_support_extreme_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// 을목 과다
      JoyongEnvironmentRule(
        id: 'mu_in_many_eul_cunning_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '乙').length >= 2 ||
            ctx.branches.any((b) => ['寅','卯'].contains(b)),
      ),
    ],
    '辰': [

      /// [병][갑][계] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_chen_no_byeong_gap_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸'),
      ),

      /// [병] 없음 + [갑][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_chen_gap_gui_exam_top_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('癸'),
      ),

      /// [갑] 없음 + [병][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_chen_byeong_gui_exam_mid_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [해][인][묘] + [자][축][진]
      JoyongEnvironmentRule(
        id: 'mu_chen_hidden_gap_gui_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [계] 존재
      JoyongEnvironmentRule(
        id: 'mu_chen_gui_skill_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [병] 과다 + 계수 없음
      JoyongEnvironmentRule(
        id: 'mu_chen_excess_fire_no_gui_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳','午'].contains(b)))) &&
            !ctx.stems.contains('癸'),
      ),

      /// 화 과다 + [임]
      JoyongEnvironmentRule(
        id: 'mu_chen_fire_many_with_ren_late_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['丙','丁'].contains(s)).length >= 2 ||
            ctx.branches.any((b) => ['巳','午'].contains(b))) &&
            ctx.stems.contains('壬'),
      ),

      /// 화 과다 + [계]
      JoyongEnvironmentRule(
        id: 'mu_chen_fire_many_with_gui_late_honor_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['丙','丁'].contains(s)).length >= 2 ||
            ctx.branches.any((b) => ['巳','午'].contains(b))) &&
            ctx.stems.contains('癸'),
      ),

      /// [해][자][신]
      JoyongEnvironmentRule(
        id: 'mu_chen_hidden_ren_food_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['亥','子','申'].contains(b)),
      ),

      /// [자][축][진]
      JoyongEnvironmentRule(
        id: 'mu_chen_hidden_gui_name_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// 화국
      JoyongEnvironmentRule(
        id: 'mu_chen_fire_guk_fortune_type_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 목국 + [갑][을]
      JoyongEnvironmentRule(
        id: 'mu_chen_mok_guk_gap_eul_official_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('乙'),
      ),

      /// 목국 + [갑][을] + 경 없음
      JoyongEnvironmentRule(
        id: 'mu_chen_mok_guk_no_gyeong_need_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('乙') &&
            !ctx.stems.contains('庚'),
      ),

      /// 목 과다 + 비겁·인성 없음
      JoyongEnvironmentRule(
        id: 'mu_chen_many_mok_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['寅','卯'].contains(b)).length +
            ctx.stems.where((s) => ['甲','乙'].contains(s)).length >= 3 &&
            !ctx.stems.any((s) => ['戊','己','丙','丁'].contains(s)),
      ),

      /// 목 과다 + 비겁·인성 존재
      JoyongEnvironmentRule(
        id: 'mu_chen_many_mok_with_support_need_gui_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['寅','卯'].contains(b)).length +
            ctx.stems.where((s) => ['甲','乙'].contains(s)).length >= 3 &&
            ctx.stems.any((s) => ['戊','己'].contains(s)) &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// 목 과다 + 제어 전무
      JoyongEnvironmentRule(
        id: 'mu_chen_many_mok_no_control_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['寅','卯'].contains(b)).length +
            ctx.stems.where((s) => ['甲','乙'].contains(s)).length >= 3 &&
            !ctx.stems.any((s) => ['癸','丙','丁','庚'].contains(s)) &&
            !ctx.branches.any((b) => ['巳','午','申','酉'].contains(b)),
      ),
    ],
    '巳': [

      /// [병][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_sa_byeong_gap_court_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_sa_byeong_gui_top_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [병][갑][계] 중 1개 이상 존재
      JoyongEnvironmentRule(
        id: 'mu_sa_one_of_byeong_gap_gui_not_low_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.any((s) => ['丙','甲','癸'].contains(s)),
      ),

      /// [병] 과다 또는 [병]+[사][오]
      JoyongEnvironmentRule(
        id: 'mu_sa_excess_byeong_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// [병] 과다 + [계] + [신][해][자]
      JoyongEnvironmentRule(
        id: 'mu_sa_excess_byeong_gui_hidden_ren_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳','午'].contains(b)))) &&
            ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [병] 과다 + 계 없음 + [자][축][진]
      JoyongEnvironmentRule(
        id: 'mu_sa_excess_byeong_hidden_gui_life_ok_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳','午'].contains(b)))) &&
            !ctx.stems.contains('癸') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// 금국 + [계]
      JoyongEnvironmentRule(
        id: 'mu_sa_metal_guk_gui_special_glory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('癸'),
      ),
    ],
    '午': [

      /// [임][갑][병] 존재
      JoyongEnvironmentRule(
        id: 'mu_o_im_gap_byeong_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// [임][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_o_im_gap_gunshin_exam_top_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// 지지 화국 (단, 임수 있으면 제외)
      JoyongEnvironmentRule(
        id: 'mu_o_fire_guk_without_im_difficult_fame_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.contains('壬'),
      ),

      /// [임][계][해][자] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_o_no_water_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

    ],
    '未': [

      /// [계][병][갑] 존재
      JoyongEnvironmentRule(
        id: 'mu_mi_gui_byeong_gap_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [계][병] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_mi_gui_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙'),
      ),

      /// [갑][계] 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'mu_mi_gap_gui_no_byeong_sujae_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('癸') &&
            !ctx.stems.contains('丙'),
      ),

      /// [계] 존재 + [갑][병] 없음
      JoyongEnvironmentRule(
        id: 'mu_mi_only_gui_small_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병] 존재 + [계] 없음
      JoyongEnvironmentRule(
        id: 'mu_mi_byeong_no_gui_cultural_life_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// [계][신] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_mi_gui_sin_art_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('辛'),
      ),

      /// [계][병] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_mi_no_gui_no_byeong_normal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            !ctx.stems.contains('丙'),
      ),

      /// [계][병][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_mi_no_gui_no_byeong_no_gap_lower_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲'),
      ),

      /// 토 과다 + [갑] 있고 [경][신] 없음
      JoyongEnvironmentRule(
        id: 'mu_mi_heavy_earth_gap_writer_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['戊','己'].contains(s)).length +
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length) >= 3 &&
            ctx.stems.contains('甲') &&
            !ctx.stems.any((s) => ['庚','辛'].contains(s)),
      ),

    ],
    '申': [

      /// [병][계][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_sin_byeong_gui_gap_full_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('甲'),
      ),

      /// [자][축][진] + [병] 존재
      JoyongEnvironmentRule(
        id: 'mu_sin_hidden_gui_byeong_exam_up_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [병][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_sin_byeong_gap_secure_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 없음 + [계][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_sin_no_byeong_gui_gap_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('甲'),
      ),

      /// [계][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_sin_no_gui_no_gap_normal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲'),
      ),

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'mu_sin_byeong_spouse_good_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [계][갑][병] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_sin_no_gui_no_gap_no_byeong_lower_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// 지지 수국
      JoyongEnvironmentRule(
        id: 'mu_sin_water_guk_need_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

    ],
    '酉': [

      /// [무] 존재
      JoyongEnvironmentRule(
        id: 'mu_yu_mu_need_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

      /// [병][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_yu_byeong_gui_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [병] + [자][축][진]
      JoyongEnvironmentRule(
        id: 'mu_yu_byeong_hidden_gui_entry_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [계] 존재 + [인] 또는 [사][오]
      JoyongEnvironmentRule(
        id: 'mu_yu_gui_hidden_fire_wealth_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            (ctx.branches.contains('寅') ||
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// [인] 또는 [사][오] 존재 (병화 암장)
      JoyongEnvironmentRule(
        id: 'mu_yu_hidden_fire_normal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.contains('寅') ||
            ctx.branches.any((b) => ['巳','午'].contains(b)),
      ),

      /// [병][계] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_yu_no_byeong_no_gui_wandering_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// 천간 [신][유] 5개 이상 + [병][정] 없음
      JoyongEnvironmentRule(
        id: 'mu_yu_strong_metal_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['辛','酉'].contains(s)).length >= 5 &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁'),
      ),

      /// 지지 수국 + [임][계]
      JoyongEnvironmentRule(
        id: 'mu_yu_water_guk_wealth_pressure_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

    ],
    '戌': [

      /// [갑][계] 존재
      JoyongEnvironmentRule(
        id: 'mu_sul_gap_gui_primary_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('癸'),
      ),

      /// [경] 천간 + 지지 [신][유]
      JoyongEnvironmentRule(
        id: 'mu_sul_metal_support_gui_byeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// [병] 없음 + [계] 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'mu_sul_only_gui_small_office_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲'),
      ),

      /// [계][병] 없음 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'mu_sul_only_gap_basic_life_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            !ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [계][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_sul_no_gui_no_gap_plain_or_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲'),
      ),

      /// 지지 수국 + [임][계]
      JoyongEnvironmentRule(
        id: 'mu_sul_water_guk_control_or_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 지지 화국
      JoyongEnvironmentRule(
        id: 'mu_sul_fire_guk_dry_limit_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// [임][계] 1개 이상 + [경] 또는 지지 [신]
      JoyongEnvironmentRule(
        id: 'mu_sul_water_metal_clear_moderate_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            (ctx.stems.contains('庚') ||
                ctx.branches.contains('申')),
      ),

    ],
    '亥': [

      /// [갑][병] 존재
      JoyongEnvironmentRule(
        id: 'mu_hae_gap_byeong_primary_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// [갑][병] 모두 존재 (조후 적절)
      JoyongEnvironmentRule(
        id: 'mu_hae_gap_byeong_balanced_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// 지지 [신] 존재
      JoyongEnvironmentRule(
        id: 'mu_hae_branch_shin_limit_entry_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.contains('申'),
      ),

      /// [경] 없음 + 지지 [신] 없음 + [해][인][묘] + [병]
      JoyongEnvironmentRule(
        id: 'mu_hae_no_gyeong_hidden_gap_high_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.branches.contains('申') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.stems.contains('丙'),
      ),

      /// [경][정] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_hae_gyeong_jeong_alt_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('丁'),
      ),

      /// [경][정] 없음 + [해][인][묘] ≥1 + [인][사][오] ≥1
      JoyongEnvironmentRule(
        id: 'mu_hae_hidden_gap_byeong_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [임][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'mu_hae_im_mu_support_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('戊'),
      ),

      /// [병][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_hae_no_gap_no_byeong_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲'),
      ),

    ],
    '子': [

      /// [갑][병] 존재
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_byeong_primary_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// [갑][병] 모두 존재 (귀격)
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_byeong_precious_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// [병] 있고 [해][인][묘] 존재
      JoyongEnvironmentRule(
        id: 'mu_ja_byeong_hidden_gap_livelihood_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [인][사][오] 있고 [갑] 존재
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_hidden_byeong_minor_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [병] 있고 [갑] 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_byeong_no_gap_power_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 있고 [병] 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_no_byeong_clean_life_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_no_gap_no_byeong_limited_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병] 2개 또는 [병]+[사][오]
      JoyongEnvironmentRule(
        id: 'mu_ja_strong_byeong_fire_cycle_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// 수기 과다 + 토기 2개 이상
      JoyongEnvironmentRule(
        id: 'mu_ja_water_soil_balance_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 2 &&
            (ctx.stems.where((s) => ['戊','己'].contains(s)).length +
                ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length) >= 2,
      ),

      /// 임수 과다 + 갑기 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_many_im_no_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => ['亥','子'].contains(b)))) &&
            !ctx.stems.any((s) => ['甲','己'].contains(s)),
      ),

      /// 계수 2개
      JoyongEnvironmentRule(
        id: 'mu_ja_two_gui_strain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length >= 2,
      ),

    ],
    '丑': [

      /// [갑][병] 존재
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_byeong_primary_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// [갑][병] 모두 존재 (귀격)
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_byeong_precious_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙'),
      ),

      /// [병] 있고 [해][인][묘] 존재
      JoyongEnvironmentRule(
        id: 'mu_ja_byeong_hidden_gap_livelihood_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [인][사][오] 있고 [갑] 존재
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_hidden_byeong_minor_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [병] 있고 [갑] 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_byeong_no_gap_power_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 있고 [병] 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_gap_no_byeong_clean_life_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_no_gap_no_byeong_limited_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병] 2개 또는 [병]+[사][오]
      JoyongEnvironmentRule(
        id: 'mu_ja_strong_byeong_fire_cycle_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// 수기 과다 + 토기 2개 이상
      JoyongEnvironmentRule(
        id: 'mu_ja_water_soil_balance_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length) >= 2 &&
            (ctx.stems.where((s) => ['戊','己'].contains(s)).length +
                ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length) >= 2,
      ),

      /// 임수 과다 + 갑기 없음
      JoyongEnvironmentRule(
        id: 'mu_ja_many_im_no_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => ['亥','子'].contains(b)))) &&
            !ctx.stems.any((s) => ['甲','己'].contains(s)),
      ),

      /// 계수 2개
      JoyongEnvironmentRule(
        id: 'mu_ja_two_gui_strain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length >= 2,
      ),

    ],
  },
  /// =========================
  /// 己土
  /// =========================
  '己': {
    '寅': [

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'gi_in_byeong_precious_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'gi_in_im_flood_control_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [갑] 2개 또는 [갑]+[인][묘]
      JoyongEnvironmentRule(
        id: 'gi_in_strong_gap_complete_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length >= 2 ||
            (ctx.stems.contains('甲') &&
                ctx.branches.any((b) => ['寅','卯'].contains(b))),
      ),

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gi_in_gyeong_refined_structure_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [병][정][사][오] 2개 이상
      JoyongEnvironmentRule(
        id: 'gi_in_strong_fire_fortune_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length) >= 2,
      ),

      /// [무] 2개 또는 [무]+[진][술]
      JoyongEnvironmentRule(
        id: 'gi_in_strong_mu_control_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length >= 2 ||
            (ctx.stems.contains('戊') &&
                ctx.branches.any((b) => ['辰','戌'].contains(b))),
      ),

      /// [을] 존재
      JoyongEnvironmentRule(
        id: 'gi_in_eul_cannot_suppress_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('乙'),
      ),

    ],
    '卯': [

      /// [갑] 존재
      JoyongEnvironmentRule(
        id: 'gi_myo_gap_primary_soil_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// [갑][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'gi_myo_gap_gui_top_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('癸'),
      ),

      /// [경][임] 모두 존재
      JoyongEnvironmentRule(
        id: 'gi_myo_gyeong_im_balanced_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('壬'),
      ),

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'gi_myo_byeong_small_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [인][사][오] 존재
      JoyongEnvironmentRule(
        id: 'gi_myo_hidden_fire_office_fortune_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// 지지 목국 + [경] 존재
      JoyongEnvironmentRule(
        id: 'gi_myo_wood_guk_gyeong_protect_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('庚'),
      ),

      /// [을] 2개 또는 [을]+[인][묘]
      JoyongEnvironmentRule(
        id: 'gi_myo_many_eul_cunning_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '乙').length >= 2 ||
            (ctx.stems.contains('乙') &&
                ctx.branches.any((b) => ['寅','卯'].contains(b))),
      ),

    ],
    '辰': [

      /// [병][계][갑] 존재
      JoyongEnvironmentRule(
        id: 'gi_jin_byeong_gui_gap_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('甲'),
      ),

      /// [병][계][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gi_jin_all_three_high_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 또는 [갑] 또는 [계] 1개 이상
      JoyongEnvironmentRule(
        id: 'gi_jin_one_of_three_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.any((s) => ['丙','甲','癸'].contains(s)),
      ),

      /// [병][갑] 모두 존재 + [계] 없음
      JoyongEnvironmentRule(
        id: 'gi_jin_byeong_gap_no_gui_wealth_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸'),
      ),

      /// [계] 존재 + [병][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'gi_jin_only_gui_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('甲'),
      ),

      /// [병][계] 모두 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'gi_jin_byeong_gui_no_gap_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲'),
      ),

      /// [병][계] 모두 없음
      JoyongEnvironmentRule(
        id: 'gi_jin_no_byeong_no_gui_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// [을] 존재
      JoyongEnvironmentRule(
        id: 'gi_jin_eul_overload_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('乙'),
      ),

    ],
    '巳': [

      /// [계][병] 존재
      JoyongEnvironmentRule(
        id: 'gi_sa_gui_byeong_priority_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙'),
      ),

      /// [계][병] 모두 존재 + [신] 존재
      JoyongEnvironmentRule(
        id: 'gi_sa_gui_byeong_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

      /// [병] 있고 [계] 없음
      JoyongEnvironmentRule(
        id: 'gi_sa_byeong_no_gui_replace_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// [병][정] 2개 이상 또는 [병][정]+[사][오]
      JoyongEnvironmentRule(
        id: 'gi_sa_many_fire_dry_hard_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length >= 2 ||
            (ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// [갑][병] 존재 + 수 없음
      JoyongEnvironmentRule(
        id: 'gi_sa_gap_byeong_no_water_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [임] + [경] 또는 천간 [신]
      JoyongEnvironmentRule(
        id: 'gi_sa_im_metal_relief_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (ctx.stems.contains('庚') || ctx.stems.contains('辛')),
      ),

      /// [임][계] 모두 있음
      JoyongEnvironmentRule(
        id: 'gi_sa_im_gui_turnaround_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

    ],
    '午': [

      /// [계][병] 존재
      JoyongEnvironmentRule(
        id: 'gi_sa_gui_byeong_priority_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙'),
      ),

      /// [계][병] 모두 존재 + [신] 존재
      JoyongEnvironmentRule(
        id: 'gi_sa_gui_byeong_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

      /// [병] 있고 [계] 없음
      JoyongEnvironmentRule(
        id: 'gi_sa_byeong_no_gui_replace_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// [병][정] 2개 이상 또는 [병][정]+[사][오]
      JoyongEnvironmentRule(
        id: 'gi_sa_many_fire_dry_hard_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length >= 2 ||
            (ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// [갑][병] 존재 + 수 없음
      JoyongEnvironmentRule(
        id: 'gi_sa_gap_byeong_no_water_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [임] + [경] 또는 천간 [신]
      JoyongEnvironmentRule(
        id: 'gi_sa_im_metal_relief_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (ctx.stems.contains('庚') || ctx.stems.contains('辛')),
      ),

      /// [임][계] 모두 있음
      JoyongEnvironmentRule(
        id: 'gi_sa_im_gui_turnaround_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

    ],
    '未': [

      /// [계][병] 존재
      JoyongEnvironmentRule(
        id: 'gi_sa_gui_byeong_priority_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙'),
      ),

      /// [계][병] 모두 존재 + [신] 존재
      JoyongEnvironmentRule(
        id: 'gi_sa_gui_byeong_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

      /// [병] 있고 [계] 없음
      JoyongEnvironmentRule(
        id: 'gi_sa_byeong_no_gui_replace_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('癸'),
      ),

      /// [병][정] 2개 이상 또는 [병][정]+[사][오]
      JoyongEnvironmentRule(
        id: 'gi_sa_many_fire_dry_hard_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length >= 2 ||
            (ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
                ctx.branches.any((b) => ['巳','午'].contains(b))),
      ),

      /// [갑][병] 존재 + 수 없음
      JoyongEnvironmentRule(
        id: 'gi_sa_gap_byeong_no_water_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('丙') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [임] + [경] 또는 천간 [신]
      JoyongEnvironmentRule(
        id: 'gi_sa_im_metal_relief_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            (ctx.stems.contains('庚') || ctx.stems.contains('辛')),
      ),

      /// [임][계] 모두 있음
      JoyongEnvironmentRule(
        id: 'gi_sa_im_gui_turnaround_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

    ],
    '申': [

      /// [병][계] 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_gui_storage_warm_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [병][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_gui_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [계] 없음 + [병] 2개
      JoyongEnvironmentRule(
        id: 'gi_sin_two_byeong_no_gui_alt_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            ctx.stems.where((s) => s == '丙').length >= 2,
      ),

      /// [병] 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_no_water_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [임][계] 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_water_no_byeong_comfort_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// 지지 금국 + [계]
      JoyongEnvironmentRule(
        id: 'gi_sin_metal_guk_gui_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('癸'),
      ),

      /// [진][술][축][미] + [갑]
      JoyongEnvironmentRule(
        id: 'gi_sin_soil_control_gap_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            ctx.stems.contains('甲'),
      ),

      /// [갑] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_no_gap_lonely_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲'),
      ),

      /// [갑] 존재 + [계] 없음 + 금 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_gap_no_gui_no_metal_exam_need_virtue_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸') &&
            !ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 지지 화국 + 수 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_fire_guk_no_water_danger_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [병] + [자][축][진]
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_hidden_gui_metal_high_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [병] + [오][미][술]
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_support_origin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['午','未','戌'].contains(b)),
      ),

      /// [계][병][신] 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_gui_byeong_sin_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

    ],
    '酉': [

      /// [병][계] 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_gui_storage_warm_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [병][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_gui_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [계] 없음 + [병] 2개
      JoyongEnvironmentRule(
        id: 'gi_sin_two_byeong_no_gui_alt_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            ctx.stems.where((s) => s == '丙').length >= 2,
      ),

      /// [병] 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_no_water_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [임][계] 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_water_no_byeong_comfort_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// 지지 금국 + [계]
      JoyongEnvironmentRule(
        id: 'gi_sin_metal_guk_gui_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('癸'),
      ),

      /// [진][술][축][미] + [갑]
      JoyongEnvironmentRule(
        id: 'gi_sin_soil_control_gap_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            ctx.stems.contains('甲'),
      ),

      /// [갑] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_no_gap_lonely_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲'),
      ),

      /// [갑] 존재 + [계] 없음 + 금 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_gap_no_gui_no_metal_exam_need_virtue_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸') &&
            !ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 지지 화국 + 수 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_fire_guk_no_water_danger_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [병] + [자][축][진]
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_hidden_gui_metal_high_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [병] + [오][미][술]
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_support_origin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['午','未','戌'].contains(b)),
      ),

      /// [계][병][신] 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_gui_byeong_sin_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

    ],
    '戌': [

      /// [병][계] 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_gui_storage_warm_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [병][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_gui_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸'),
      ),

      /// [계] 없음 + [병] 2개
      JoyongEnvironmentRule(
        id: 'gi_sin_two_byeong_no_gui_alt_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            ctx.stems.where((s) => s == '丙').length >= 2,
      ),

      /// [병] 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_no_water_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [임][계] 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_water_no_byeong_comfort_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// 지지 금국 + [계]
      JoyongEnvironmentRule(
        id: 'gi_sin_metal_guk_gui_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('癸'),
      ),

      /// [진][술][축][미] + [갑]
      JoyongEnvironmentRule(
        id: 'gi_sin_soil_control_gap_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)) &&
            ctx.stems.contains('甲'),
      ),

      /// [갑] 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_no_gap_lonely_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲'),
      ),

      /// [갑] 존재 + [계] 없음 + 금 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_gap_no_gui_no_metal_exam_need_virtue_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸') &&
            !ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛') &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

      /// 지지 화국 + 수 없음
      JoyongEnvironmentRule(
        id: 'gi_sin_fire_guk_no_water_danger_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [병] + [자][축][진]
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_hidden_gui_metal_high_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['子','丑','辰'].contains(b)),
      ),

      /// [병] + [오][미][술]
      JoyongEnvironmentRule(
        id: 'gi_sin_byeong_support_origin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['午','未','戌'].contains(b)),
      ),

      /// [계][병][신] 존재
      JoyongEnvironmentRule(
        id: 'gi_sin_gui_byeong_sin_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

    ],
    '亥': [

      /// [병][갑] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_byeong_gap_winter_core_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 1개 + [갑] 1개 + [인][사][오] 1개
      JoyongEnvironmentRule(
        id: 'gi_hae_single_byeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            ctx.stems.where((s) => s == '甲').length == 1 &&
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).length == 1,
      ),

      /// [인][사][오] 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'gi_hae_hidden_fire_no_water_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [임] 과다 또는 [임]+[해][자] + [무] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_many_im_control_mu_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') &&
                    ctx.branches.any((b) => ['亥','子'].contains(b)))
        ) &&
            ctx.stems.contains('戊'),
      ),

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_im_overflow_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [계] 과다 또는 [계]+[해][자] + [무][기] 없음
      JoyongEnvironmentRule(
        id: 'gi_hae_many_gui_no_peer_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '癸').length >= 2 ||
                (ctx.stems.contains('癸') &&
                    ctx.branches.any((b) => ['亥','子'].contains(b)))
        ) &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('己'),
      ),

      /// [무][기] 존재 + [진][술][축][미]
      JoyongEnvironmentRule(
        id: 'gi_hae_mu_gi_soil_need_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('戊') || ctx.stems.contains('己')) &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

      /// [경][신] 3개 이상
      JoyongEnvironmentRule(
        id: 'gi_hae_many_gyeong_sin_need_jeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['庚','辛'].contains(s)).length >= 3,
      ),

    ],
    '子': [

      /// [병][갑] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_byeong_gap_winter_core_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 1개 + [갑] 1개 + [인][사][오] 1개
      JoyongEnvironmentRule(
        id: 'gi_hae_single_byeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            ctx.stems.where((s) => s == '甲').length == 1 &&
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).length == 1,
      ),

      /// [인][사][오] 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'gi_hae_hidden_fire_no_water_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [임] 과다 또는 [임]+[해][자] + [무] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_many_im_control_mu_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') &&
                    ctx.branches.any((b) => ['亥','子'].contains(b)))
        ) &&
            ctx.stems.contains('戊'),
      ),

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_im_overflow_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [계] 과다 또는 [계]+[해][자] + [무][기] 없음
      JoyongEnvironmentRule(
        id: 'gi_hae_many_gui_no_peer_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '癸').length >= 2 ||
                (ctx.stems.contains('癸') &&
                    ctx.branches.any((b) => ['亥','子'].contains(b)))
        ) &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('己'),
      ),

      /// [무][기] 존재 + [진][술][축][미]
      JoyongEnvironmentRule(
        id: 'gi_hae_mu_gi_soil_need_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('戊') || ctx.stems.contains('己')) &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

      /// [경][신] 3개 이상
      JoyongEnvironmentRule(
        id: 'gi_hae_many_gyeong_sin_need_jeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['庚','辛'].contains(s)).length >= 3,
      ),

    ],
    '丑': [

      /// [병][갑] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_byeong_gap_winter_core_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 1개 + [갑] 1개 + [인][사][오] 1개
      JoyongEnvironmentRule(
        id: 'gi_hae_single_byeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1 &&
            ctx.stems.where((s) => s == '甲').length == 1 &&
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).length == 1,
      ),

      /// [인][사][오] 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'gi_hae_hidden_fire_no_water_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [임] 과다 또는 [임]+[해][자] + [무] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_many_im_control_mu_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '壬').length >= 2 ||
                (ctx.stems.contains('壬') &&
                    ctx.branches.any((b) => ['亥','子'].contains(b)))
        ) &&
            ctx.stems.contains('戊'),
      ),

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'gi_hae_im_overflow_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [계] 과다 또는 [계]+[해][자] + [무][기] 없음
      JoyongEnvironmentRule(
        id: 'gi_hae_many_gui_no_peer_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '癸').length >= 2 ||
                (ctx.stems.contains('癸') &&
                    ctx.branches.any((b) => ['亥','子'].contains(b)))
        ) &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('己'),
      ),

      /// [무][기] 존재 + [진][술][축][미]
      JoyongEnvironmentRule(
        id: 'gi_hae_mu_gi_soil_need_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('戊') || ctx.stems.contains('己')) &&
            ctx.branches.any((b) => ['辰','戌','丑','未'].contains(b)),
      ),

      /// [경][신] 3개 이상
      JoyongEnvironmentRule(
        id: 'gi_hae_many_gyeong_sin_need_jeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['庚','辛'].contains(s)).length >= 3,
      ),

    ],
  },
  /// =========================
  /// 庚金
  /// =========================
  '庚': {
    '寅': [

      /// [병][갑] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_in_byeong_gap_warm_soil_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_in_byeong_gap_top_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('甲'),
      ),

      /// [병]만 있거나 [갑]만 있음
      JoyongEnvironmentRule(
        id: 'gyeong_in_single_byeong_or_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('丙') && !ctx.stems.contains('甲')) ||
            (ctx.stems.contains('甲') && !ctx.stems.contains('丙')),
      ),

      /// [갑] + [인][사][오]
      JoyongEnvironmentRule(
        id: 'gyeong_in_gap_hidden_byeong_alt_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// 토 과다 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_in_many_soil_gap_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 3 &&
            ctx.stems.contains('甲'),
      ),

      /// 토 과다 + [갑] 없음 + [해][인][묘]
      JoyongEnvironmentRule(
        id: 'gyeong_in_many_soil_hidden_gap_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 3 &&
            !ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [정] + [무][기] + 수 없음
      JoyongEnvironmentRule(
        id: 'gyeong_in_jeong_mu_no_water_official_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            (ctx.stems.contains('戊') || ctx.stems.contains('己')) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// 화 과다
      JoyongEnvironmentRule(
        id: 'gyeong_in_many_fire_use_soil_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length >= 3,
      ),

      /// 화국 + [임]
      JoyongEnvironmentRule(
        id: 'gyeong_in_fire_guk_with_im_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('壬'),
      ),

      /// [병][정] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_in_no_fire_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁'),
      ),

      /// [병][계] + [무] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_in_byeong_gui_no_mu_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('癸') &&
            !ctx.stems.contains('戊'),
      ),

      /// 화 과다 (부)
      JoyongEnvironmentRule(
        id: 'gyeong_in_many_fire_hard_life_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length >= 3,
      ),

      /// [경] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gyeong_in_general_summary_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

    ],
    '卯': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_myo_gyeong_core_structure_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정] 없음 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_myo_no_jeong_only_byeong_alt_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丁') &&
            ctx.stems.contains('丙'),
      ),

      /// [정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_myo_jeong_gap_great_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [정] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_myo_jeong_support_with_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丁'),
      ),

      /// [을] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_myo_eul_wet_grass_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('乙'),
      ),

      /// [정][경] 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_myo_jeong_gyeong_no_gap_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲'),
      ),

      /// [정] 존재 + [경][갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_myo_only_jeong_exam_life_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑][을] 3개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_myo_many_gap_eul_follow_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['甲','乙'].contains(s)).length >= 3,
      ),

      /// [무] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_myo_mu_press_dead_metal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('戊'),
      ),

    ],
    '辰': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_jin_gyeong_need_gap_jeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [병][정][사][오] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_jin_no_fire_dull_metal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['巳','午'].contains(b)),
      ),

      /// [인][묘][갑][을] 3개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_jin_many_wood_weak_metal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3,
      ),

      /// [정][갑] 모두 존재 (+ 비견)
      JoyongEnvironmentRule(
        id: 'gyeong_jin_jeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// [갑] 존재 + [정] 없음 + [술][미][오]
      JoyongEnvironmentRule(
        id: 'gyeong_jin_gap_hidden_fire_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['戌','未','午'].contains(b)),
      ),

      /// [정] 존재 + [갑] 없음 + [해][인][묘]
      JoyongEnvironmentRule(
        id: 'gyeong_jin_jeong_hidden_gap_alt_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [해][인][묘] + [술][미][오] + [정][갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_jin_hidden_gap_jeong_wealth_calligraphy_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['戌','未','午'].contains(b)) &&
            !ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 존재 + [정][술][미][오] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_jin_only_gap_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丁') &&
            !ctx.branches.any((b) => ['戌','未','午'].contains(b)),
      ),

      /// [정] 존재 + [갑][해][인][묘] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_jin_only_jeong_no_soil_control_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲') &&
            !ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [정][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_jin_no_jeong_no_gap_low_grade_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 1개 + [정] 없음 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_jin_gap_byeong_military_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length == 1 &&
            !ctx.stems.contains('丁') &&
            ctx.stems.contains('丙') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 지지 토국
      JoyongEnvironmentRule(
        id: 'gyeong_jin_earth_guk_need_gap_or_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

      /// 지지 화국 + [계]
      JoyongEnvironmentRule(
        id: 'gyeong_jin_fire_guk_gui_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('癸'),
      ),

      /// 지지 화국 + [병][정] + [임]
      JoyongEnvironmentRule(
        id: 'gyeong_jin_fire_guk_controlled_by_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            ctx.stems.contains('壬'),
      ),

    ],
    '巳': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sa_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [임][병][무] 1~2개 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sa_partial_im_byeong_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final count =
              ctx.stems.where((s) => ['壬', '丙', '戊'].contains(s)).length;
          return count >= 1 && count <= 2;
        },
      ),

      /// [임][병][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sa_full_im_byeong_mu_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

      /// [병] 2개 또는 [병]+[사][오] + [임] 없음 + 지지 [신][해][자] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_sa_strong_fire_no_water_family_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳', '午'].contains(b)))) &&
            !ctx.stems.contains('壬') &&
            !ctx.branches.any((b) => ['申', '亥', '子'].contains(b)),
      ),

      /// [병] 2개 또는 [병]+[사][오] + [임] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sa_strong_fire_controlled_by_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳', '午'].contains(b)))) &&
            ctx.stems.contains('壬'),
      ),

      /// [병] 2개 또는 [병]+[사][오] + 지지 [신][해][자]
      JoyongEnvironmentRule(
        id: 'gyeong_sa_strong_fire_hidden_im_mixed_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') &&
                ctx.branches.any((b) => ['巳', '午'].contains(b)))) &&
            ctx.branches.any((b) => ['申', '亥', '子'].contains(b)),
      ),

      /// 지지 금국
      JoyongEnvironmentRule(
        id: 'gyeong_sa_metal_guk_need_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('금국'),
      ),

      /// [정][오] 3~4개
      JoyongEnvironmentRule(
        id: 'gyeong_sa_many_jeong_overheat_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final count =
              ctx.stems.where((s) => s == '丁').length +
                  ctx.branches.where((b) => b == '午').length;
          return count >= 3 && count <= 4;
        },
      ),

    ],
    '午': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_o_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [임] 존재 + [진][축][자] 존재 + 지지 [사][신][유][축][술][유]
      JoyongEnvironmentRule(
        id: 'gyeong_o_im_exam_top_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['辰','丑','子'].contains(b)) &&
            ctx.branches.any((b) => ['巳','申','酉','丑','戌','酉'].contains(b)),
      ),

      /// [무][기] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_o_mu_gi_block_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// [해][인][진] 존재 + 지지 [신]
      JoyongEnvironmentRule(
        id: 'gyeong_o_hidden_mu_keep_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','辰'].contains(b)) &&
            ctx.branches.contains('申'),
      ),

      /// 지지 [사][신][축][술][유] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_o_hidden_metal_support_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['巳','申','丑','戌','酉'].contains(b)),
      ),

      /// [계] 천간 + [신] 지지
      JoyongEnvironmentRule(
        id: 'gyeong_o_gui_with_shin_alt_glory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.branches.contains('申'),
      ),

      /// 지지 화국 + 수 1개 이하
      JoyongEnvironmentRule(
        id: 'gyeong_o_fire_guk_low_water_busy_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            (ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
                ctx.branches.where((b) => ['亥','子'].contains(b)).length) <= 1,
      ),

      /// 지지 화국 + [임][계] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_o_fire_guk_water_control_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// 지지 화국 + [무][기] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_o_fire_guk_mu_gi_relief_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// 목화 과다 + 도움 없음
      JoyongEnvironmentRule(
        id: 'gyeong_o_excess_wood_fire_follow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
            ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 2 &&
            (ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
                ctx.branches.where((b) => ['巳','午'].contains(b)).length) >= 2 &&
            !ctx.stems.any((s) => ['壬','癸','戊','己','庚','辛'].contains(s)),
      ),

    ],
    '未': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_mi_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_mi_jeong_gap_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [계] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_mi_gui_harm_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [갑] 존재 + [정] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_mi_gap_no_jeong_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丁'),
      ),

      /// [정] 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_mi_jeong_no_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// [정][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_mi_no_jeong_no_gap_low_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// 목 존재 + 정 없음 + 지지 수 존재
      JoyongEnvironmentRule(
        id: 'gyeong_mi_wood_water_no_jeong_low_office_or_trade_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['甲','乙'].contains(s)) &&
            !ctx.stems.contains('丁') &&
            ctx.branches.any((b) => ['壬','癸','亥','子'].contains(b)),
      ),

      /// 지지 토 2개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_mi_earth_guk_literary_tech_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

      /// 금 3개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_mi_many_metal_alt_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => ['庚','辛'].contains(s)).length +
            ctx.branches.where((b) => ['申','酉'].contains(b)).length) >= 3,
      ),

    ],
    '申': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sin_jeong_gap_smooth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [정] 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_sin_jeong_no_gap_refined_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 존재 + [정] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_sin_gap_no_jeong_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丁'),
      ),

      /// [정][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_sin_no_jeong_no_gap_low_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// 지지 수국
      JoyongEnvironmentRule(
        id: 'gyeong_sin_water_guk_need_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

      /// 지지 수국 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sin_water_guk_byeong_no_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('丙'),
      ),

      /// 지지 수국 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sin_water_guk_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('甲'),
      ),

      /// 지지 토 2개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_sin_earth_guk_order_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

      /// 지지 화국
      JoyongEnvironmentRule(
        id: 'gyeong_sin_fire_guk_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 지지 화국 + 금 3개 이상 + 목 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sin_fire_guk_strong_metal_trade_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            (ctx.stems.where((s) => ['庚','辛'].contains(s)).length +
                ctx.branches.where((b) => ['申','酉'].contains(b)).length) >= 3 &&
            ctx.stems.any((s) => ['甲','乙'].contains(s)),
      ),

      /// [신][유][술] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sin_shin_you_sul_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('申') &&
            ctx.branches.contains('酉') &&
            ctx.branches.contains('戌'),
      ),

    ],
    '酉': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_jeong_gap_merit_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [인][사][오] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_yangin_loyal_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [병][사] 2개 이상 + [정] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_many_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '丙').length +
            ctx.branches.where((b) => b == '巳').length) >= 2 &&
            ctx.stems.contains('丁'),
      ),

      /// [병] 존재 + [술][미][오] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_byeong_hidden_jeong_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['戌','未','午'].contains(b)),
      ),

      /// [해][인][묘] 존재 + [병][정] 존재 + 수 없음
      JoyongEnvironmentRule(
        id: 'gyeong_yu_fire_clear_no_water_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// [술][미][오] 존재 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_heavy_officer_pressure_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.any((b) => ['戌','未','午'].contains(b)) &&
            ctx.stems.contains('丙'),
      ),

      /// [병] 1개만 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_single_byeong_talent_limit_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length == 1,
      ),

      /// [인][묘] 1개 이상 존재
      JoyongEnvironmentRule(
        id: 'gyeong_yu_wood_exists_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','卯'].contains(b)),
      ),


      /// [병][정] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_yu_no_fire_artistic_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁'),
      ),

    ],
    '戌': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sul_core_soil_wash_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [임][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sul_im_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// [갑] 존재 + [신][해][자]
      JoyongEnvironmentRule(
        id: 'gyeong_sul_gap_hidden_im_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [임] 존재 + [해][인][묘]
      JoyongEnvironmentRule(
        id: 'gyeong_sul_im_hidden_gap_academy_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [갑] 존재 + [임] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_sul_only_gap_study_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('壬'),
      ),

      /// [임] 존재 + [갑] 없음  (순화)
      JoyongEnvironmentRule(
        id: 'gyeong_sul_only_im_no_gap_limit_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            !ctx.stems.contains('甲'),
      ),

      /// [임][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_sul_no_im_no_gap_low_class_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('甲'),
      ),

      /// 지지 수국 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_sul_water_guk_byeong_rescue_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('丙'),
      ),

      /// [무] 2개 이상 또는 [무]+[진][술]
      JoyongEnvironmentRule(
        id: 'gyeong_sul_many_mu_heavy_soil_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length >= 2 ||
            (ctx.stems.contains('戊') &&
                ctx.branches.any((b) => ['辰','戌'].contains(b))),
      ),

    ],
    '亥': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_hae_gyeong_core_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정][갑] 모두 존재 + 지지 수국 아님
      JoyongEnvironmentRule(
        id: 'gyeong_hae_jeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲') &&
            !ctx.gukGroups.contains('수국'),
      ),

      /// [인][사][오] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_hae_fire_hidden_comfort_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [해][자] 존재 + [기] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_hae_water_control_gi_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','子'].contains(b)) &&
            ctx.stems.contains('己'),
      ),

      /// [병] 존재 + [정] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_hae_byeong_no_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁'),
      ),

      /// [술][미][오] 존재 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_hae_gap_hidden_fire_nonofficial_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['戌','未','午'].contains(b)),
      ),

      /// 위 조건 전부 해당 없음 → 보통
      /// [정][갑][인][사][오][해][자] 모두 없음 → 기본 흐름
      JoyongEnvironmentRule(
        id: 'gyeong_hae_plain_default_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['丁', '甲'].contains(s)) &&
            !ctx.branches.any((b) => ['寅', '巳', '午', '亥', '子'].contains(b)),
      ),


      /// 지지 금국 + 화기운 전무
      JoyongEnvironmentRule(
        id: 'gyeong_hae_metal_guk_no_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)) &&
            !ctx.branches.any((b) => ['巳','午'].contains(b)),
      ),

    ],
    '子': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_ja_core_cold_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정][갑] 모두 존재 + [인][사][오] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_ja_jeong_gap_fire_hidden_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [정][갑] 모두 존재 + [인][사][오] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_ja_jeong_gap_no_fire_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲') &&
            !ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [정] 있고 [갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_ja_only_jeong_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// [갑] 있고 [정] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_ja_only_gap_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('丁'),
      ),

      /// [병] 존재 + [술][미][오] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_ja_byeong_hidden_path_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['戌','未','午'].contains(b)),
      ),

      /// [술][미][오] 존재 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_ja_gap_tech_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['戌','未','午'].contains(b)),
      ),

      /// [병] 2개 이상 또는 [병]+[사]
      JoyongEnvironmentRule(
        id: 'gyeong_ja_byeong_excess_show_only_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丙').length >= 2 ||
            (ctx.stems.contains('丙') && ctx.branches.contains('巳')),
      ),

      /// 지지 수국 + [병][정] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_ja_water_guk_clear_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// [병][정][사][오] 3개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_ja_fire_excess_damage_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length >= 3,
      ),

      /// [경][신][유][임][계][해][자] 3개 이상
      JoyongEnvironmentRule(
        id: 'gyeong_ja_metal_water_excess_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['庚','辛','壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['申','酉','亥','子'].contains(b)).length >= 3,
      ),

    ],
    '丑': [

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'gyeong_chuk_core_cold_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [병][정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gyeong_chuk_byeong_jeong_gap_grace_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [병] 존재 + [정][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_chuk_only_byeong_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// [정][갑] 모두 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_chuk_jeong_gap_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병][정] 모두 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'gyeong_chuk_byeong_jeong_self_made_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲'),
      ),

      /// 지지 금국 + [병][정] 모두 없음
      JoyongEnvironmentRule(
        id: 'gyeong_chuk_metal_guk_no_fire_inner_path_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

    ],
  },

  /// =========================
  /// 辛金
  /// =========================
  '辛': {
    '寅': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_in_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [기][임] 모두 존재 + 지지에 [경]
      JoyongEnvironmentRule(
        id: 'sin_in_gi_im_exam_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.stems.contains('壬') &&
            ctx.branches.contains('申'),
      ),

      /// [기] 존재 + 지지 [해][인][묘]
      JoyongEnvironmentRule(
        id: 'sin_in_gi_hidden_wood_grace_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'sin_in_byeong_technical_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [기][경] 모두 없음
      JoyongEnvironmentRule(
        id: 'sin_in_no_gi_no_gyeong_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('己') &&
            !ctx.stems.contains('庚'),
      ),

      /// 지지 화국 + [임] 존재
      JoyongEnvironmentRule(
        id: 'sin_in_fire_guk_with_im_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            ctx.stems.contains('壬'),
      ),

      /// 지지 수국 + [병] 없음
      JoyongEnvironmentRule(
        id: 'sin_in_water_guk_no_fire_cold_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.contains('丙'),
      ),

    ],
    '卯': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_myo_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [임][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_myo_im_gap_high_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// [임][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'sin_myo_no_im_no_gap_local_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('甲'),
      ),

      /// [해] 존재 + [무][기] 모두 없음
      JoyongEnvironmentRule(
        id: 'sin_myo_hai_no_earth_small_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('亥') &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('己'),
      ),

      /// 지지 [신] 존재
      JoyongEnvironmentRule(
        id: 'sin_myo_branch_shen_reputation_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.contains('申'),
      ),

      /// [임][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_myo_im_mu_conflict_moderate_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('戊'),
      ),

      /// [임] 2개 이상 또는 [임]+[자][해]
      JoyongEnvironmentRule(
        id: 'sin_myo_excess_im_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => ['子','亥'].contains(b))),
      ),

      /// 지지 목국
      JoyongEnvironmentRule(
        id: 'sin_myo_wood_guk_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

      /// 지지 화국
      JoyongEnvironmentRule(
        id: 'sin_myo_fire_guk_transform_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

    ],
    '辰': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_jin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [임][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_jin_im_gap_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// [임] 존재 + [해][인][묘] 존재
      JoyongEnvironmentRule(
        id: 'sin_jin_im_hidden_gap_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [갑] 존재 + [신][해][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_jin_gap_hidden_im_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [임][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'sin_jin_no_im_no_gap_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('甲'),
      ),

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'sin_jin_byeong_compete_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [해][자] 존재 + 지지 [신] 존재
      JoyongEnvironmentRule(
        id: 'sin_jin_water_guk_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('申') &&
            ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [진][술][축][미] 2개 이상
      JoyongEnvironmentRule(
        id: 'sin_jin_heavy_earth_buried_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

      /// [병][정][사][오] 3개 이상 + 수 없음
      JoyongEnvironmentRule(
        id: 'sin_jin_excess_fire_no_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length >= 3 &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

      /// [경] 존재 + [해][자] 없음
      JoyongEnvironmentRule(
        id: 'sin_jin_strong_metal_short_life_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.branches.contains('亥') &&
            !ctx.branches.contains('子'),
      ),

    ],
    '巳': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_sa_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// 지지 금국 + [임][계] 존재
      JoyongEnvironmentRule(
        id: 'sin_sa_metal_guk_water_clear_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

      /// [계] 존재 + [임] 없음 + [신][해][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_sa_gui_hidden_im_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            !ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [신][해][자][진][축][자] 존재 + [해][인][진][신][미][오][축] 존재
      JoyongEnvironmentRule(
        id: 'sin_sa_all_hidden_small_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['申','亥','子','辰','丑'].contains(b)) &&
            ctx.branches.any((b) => ['亥','寅','辰','申','未','午','丑'].contains(b)),
      ),

      /// [임][계] 없음 + [병][정] 존재
      JoyongEnvironmentRule(
        id: 'sin_sa_fire_no_water_lonely_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸') &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// 지지 화국
      JoyongEnvironmentRule(
        id: 'sin_sa_fire_guk_mixed_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// [해] 존재
      JoyongEnvironmentRule(
        id: 'sin_sa_hae_hidden_im_status_change_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.contains('亥'),
      ),

      /// [갑] 존재
      JoyongEnvironmentRule(
        id: 'sin_sa_gap_no_water_hollow_wealth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// [임][계][갑] 모두 없음
      JoyongEnvironmentRule(
        id: 'sin_sa_no_im_gui_gap_low_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸') &&
            !ctx.stems.contains('甲'),
      ),

    ],
    '午': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_o_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// 지지 화국
      JoyongEnvironmentRule(
        id: 'sin_o_fire_guk_strong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// [임] 없음 + [계][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_o_no_im_gui_mu_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸') &&
            ctx.stems.contains('戊'),
      ),

      /// [경][신] 존재
      JoyongEnvironmentRule(
        id: 'sin_o_with_bi_geop_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.any((s) => ['庚','辛'].contains(s)),
      ),

      /// [임][기] 모두 존재 + [진][축][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_o_im_gi_hidden_gui_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['辰','丑','子'].contains(b)),
      ),

      /// [미][오][축] 존재
      JoyongEnvironmentRule(
        id: 'sin_o_hidden_gi_academic_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['未','午','丑'].contains(b)),
      ),

      /// [임] 없음 + [기] 존재
      JoyongEnvironmentRule(
        id: 'sin_o_no_im_only_gi_alt_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            ctx.stems.contains('己'),
      ),

      /// [계][경] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_o_gui_gyeong_granted_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('庚'),
      ),

    ],
    '未': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_mi_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [경][임] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_mi_gyeong_im_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('壬'),
      ),

      /// [사][신][유] 존재 + [신][해][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_mi_hidden_metal_water_fortune_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['巳','申','酉'].contains(b)) &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [갑] 존재
      JoyongEnvironmentRule(
        id: 'sin_mi_gap_gi_union_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// [경] 존재 (갑목 제어)
      JoyongEnvironmentRule(
        id: 'sin_mi_gyeong_control_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'sin_mi_im_normalization_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

    ],
    '申': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_sin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [경][신] 2개 이상 OR [경][신] 2개 이상 + [신][유] 2개 이상
      JoyongEnvironmentRule(
        id: 'sin_sin_excess_metal_need_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final metalStems =
              ctx.stems.where((s) => ['庚','辛'].contains(s)).length;
          final metalBranches =
              ctx.branches.where((b) => ['申','酉'].contains(b)).length;

          return metalStems >= 2 ||
              (metalStems >= 2 && metalBranches >= 2);
        },
      ),

      /// [경][신][신][유] 3개 이상 + [임][계][해][자] 2개 이상
      JoyongEnvironmentRule(
        id: 'sin_sin_metal_water_with_mu_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final metalCount =
              ctx.stems.where((s) => ['庚','辛'].contains(s)).length +
                  ctx.branches.where((b) => ['申','酉'].contains(b)).length;

          final waterCount =
              ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
                  ctx.branches.where((b) => ['亥','子'].contains(b)).length;

          return metalCount >= 3 && waterCount >= 2;
        },
      ),

      /// [임][계][해][자] 3개 이상 + [무] 존재
      JoyongEnvironmentRule(
        id: 'sin_sin_excess_water_need_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final waterCount =
              ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
                  ctx.branches.where((b) => ['亥','子'].contains(b)).length;

          return waterCount >= 3 &&
              ctx.stems.contains('戊');
        },
      ),

    ],
    '酉': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_yu_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'sin_yu_single_im_weakened_by_wood_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [신][유] 3개 이상 + [임] 존재
      JoyongEnvironmentRule(
        id: 'sin_yu_many_metal_with_im_and_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final metalCount =
              ctx.stems.where((s) => s == '辛').length +
                  ctx.branches.where((b) => b == '酉').length;

          return metalCount >= 3 &&
              ctx.stems.contains('壬');
        },
      ),

      /// [정] 1개 존재
      JoyongEnvironmentRule(
        id: 'sin_yu_single_jeong_elegant_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length == 1,
      ),

      /// [신] 존재 + [임][갑] 각 1개 + [경] 없음
      JoyongEnvironmentRule(
        id: 'sin_yu_one_im_one_gap_no_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.stems.where((s) => s == '壬').length == 1 &&
            ctx.stems.where((s) => s == '甲').length == 1 &&
            !ctx.stems.contains('庚'),
      ),

      /// [신] 2개 이상 + [갑] 1개 + 토 다수
      JoyongEnvironmentRule(
        id: 'sin_yu_many_sin_many_soil_heavy_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final sinCount = ctx.stems.where((s) => s == '辛').length;
          final soilCount =
              ctx.stems.where((s) => s == '己').length +
                  ctx.branches.where((b) => ['辰','丑'].contains(b)).length;

          return sinCount >= 2 &&
              ctx.stems.where((s) => s == '甲').length == 1 &&
              soilCount >= 2;
        },
      ),

      /// [신] 2개 이상 또는 [신]+[유] + [임]
      JoyongEnvironmentRule(
        id: 'sin_yu_metal_with_im_clean_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final sinCount = ctx.stems.where((s) => s == '辛').length;
          return (sinCount >= 2 ||
              (ctx.stems.contains('辛') && ctx.branches.contains('酉'))) &&
              ctx.stems.contains('壬');
        },
      ),

      /// [임] 과다
      JoyongEnvironmentRule(
        id: 'sin_yu_excess_im_need_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final imCount =
              ctx.stems.where((s) => s == '壬').length +
                  ctx.branches.where((b) => ['亥','子'].contains(b)).length;

          return imCount >= 2;
        },
      ),

      /// 금국 + 천간 [신] 2개
      JoyongEnvironmentRule(
        id: 'sin_yu_metal_guk_no_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.where((s) => s == '辛').length >= 2,
      ),

      /// 금국 + [임] 존재
      JoyongEnvironmentRule(
        id: 'sin_yu_metal_guk_with_im_top_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('壬'),
      ),

      /// 금국 + [갑][기] + [임] + 화 없음
      JoyongEnvironmentRule(
        id: 'sin_yu_metal_guk_white_tiger_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('甲') &&
            ctx.stems.contains('己') &&
            ctx.stems.contains('壬') &&
            !ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

      /// [병] 존재
      JoyongEnvironmentRule(
        id: 'sin_yu_byeong_normal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// [신] + 기토 다수
      JoyongEnvironmentRule(
        id: 'sin_yu_sin_soil_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final giCount =
              ctx.stems.where((s) => s == '己').length +
                  ctx.branches.where((b) => ['丑','未'].contains(b)).length;

          return ctx.stems.contains('辛') && giCount >= 2;
        },
      ),

      /// [기] 존재 + 목·금 암장
      JoyongEnvironmentRule(
        id: 'sin_yu_gi_with_hidden_balance_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// [을] 과다
      JoyongEnvironmentRule(
        id: 'sin_yu_many_yi_need_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '乙').length >= 2,
      ),

      /// 토 과다
      JoyongEnvironmentRule(
        id: 'sin_yu_heavy_soil_finance_issue_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final soilCount =
              ctx.stems.where((s) => ['戊','己'].contains(s)).length +
                  ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length;

          return soilCount >= 3;
        },
      ),

      /// 완전 금국
      JoyongEnvironmentRule(
        id: 'sin_yu_full_metal_revolution_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('금국'),
      ),

    ],
    '戌': [

      /// [신] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'sin_sul_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [임][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_sul_im_gap_both_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('甲'),
      ),

      /// [임] 존재 + [갑] 없음 + 목 암장 + [무] 존재
      JoyongEnvironmentRule(
        id: 'sin_sul_im_no_gap_with_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            !ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.stems.contains('戊'),
      ),

      /// [갑] 존재 + [임] 없음 + 특정 지지 조합
      JoyongEnvironmentRule(
        id: 'sin_sul_gap_no_im_alt_official_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)) &&
            ctx.branches.any((b) => ['亥','寅','辰','申'].contains(b)),
      ),

      /// [갑][임] 모두 없음 + 병화·신금 다수
      JoyongEnvironmentRule(
        id: 'sin_sul_no_gap_im_with_fire_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final fireCount = ctx.stems.where((s) => s == '丙').length;
          final metalCount = ctx.stems.where((s) => s == '辛').length;

          return !ctx.stems.contains('甲') &&
              !ctx.stems.contains('壬') &&
              fireCount >= 1 &&
              metalCount >= 1;
        },
      ),

      /// [계] 존재
      JoyongEnvironmentRule(
        id: 'sin_sul_gye_clear_but_hard_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [기] 존재 (문장 톤 수정 반영)
      JoyongEnvironmentRule(
        id: 'sin_sul_gi_muddy_rich_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('己'),
      ),

    ],
    '亥': [

      /// [신] 존재
      JoyongEnvironmentRule(
        id: 'sin_hae_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) => ctx.stems.contains('辛'),
      ),

      /// [임][병] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_hae_im_byeong_both_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('丙'),
      ),

      /// [병] 존재, [임] 없음, [신][해][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_hae_byeong_no_im_branch_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [임] 존재, [병] 없음, [인][사][오] 존재
      JoyongEnvironmentRule(
        id: 'sin_hae_im_no_byeong_fire_branch_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            !ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      /// [임][병] 모두 없음, [인][사][오] 존재, [신][해][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_hae_no_im_byeong_fire_water_branch_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('丙') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [임][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_hae_im_mu_both_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('戊'),
      ),

      /// [임][해] 2개 이상, [무] 없음
      JoyongEnvironmentRule(
        id: 'sin_hae_many_im_no_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) {
          final count = ctx.stems.where((s) => s == '壬').length +
              ctx.branches.where((b) => b == '亥').length;
          return count >= 2 && !ctx.stems.contains('戊');
        },
      ),

      /// [무][진][술] 2개 이상
      JoyongEnvironmentRule(
        id: 'sin_hae_many_mu_earth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length +
            ctx.branches.where((b) => ['辰','戌'].contains(b)).length >= 2,
      ),

      /// [갑][인] 2개 이상
      JoyongEnvironmentRule(
        id: 'sin_hae_many_gap_in_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length +
            ctx.branches.where((b) => b == '寅').length >= 2,
      ),

      /// [기][축][미] 2개 이상
      JoyongEnvironmentRule(
        id: 'sin_hae_many_gi_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '己').length +
            ctx.branches.where((b) => ['丑','未'].contains(b)).length >= 2,
      ),

      /// [임][계][해][자] 3개 이상
      JoyongEnvironmentRule(
        id: 'sin_hae_many_water_extreme_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length >= 3,
      ),
    ],
    '子': [

      /// [신] 존재
      JoyongEnvironmentRule(
        id: 'sin_ja_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [임][병] 모두 존재 + [무][계] 없음
      JoyongEnvironmentRule(
        id: 'sin_ja_im_byeong_no_mu_gye_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            ctx.stems.contains('丙') &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('癸'),
      ),

      /// [신][해][자] 존재 + [병] 존재
      JoyongEnvironmentRule(
        id: 'sin_ja_hidden_im_byeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['申','亥','子'].contains(b)) &&
            ctx.stems.contains('丙'),
      ),

      /// [임] 2개 이상 또는 [임]+[해][자] + [무][술][진]
      JoyongEnvironmentRule(
        id: 'sin_ja_many_im_with_mu_high_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => ['亥','子'].contains(b)))) &&
            ctx.branches.any((b) => ['戌','辰'].contains(b)) ||
            ctx.stems.contains('戊'),
      ),

      /// [임][해] 2개 이상 + [무][병] 없음
      JoyongEnvironmentRule(
        id: 'sin_ja_excess_im_no_mu_byeong_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '壬').length +
            ctx.branches.where((b) => b == '亥').length) >= 2 &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('丙'),
      ),

      /// [임][해] 2개 이상 + [갑][을][인][묘] 2개 이상 + [병] 없음
      JoyongEnvironmentRule(
        id: 'sin_ja_excess_im_gap_no_byeong_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '壬').length +
            ctx.branches.where((b) => b == '亥').length) >= 2 &&
            (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
                ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 2 &&
            !ctx.stems.contains('丙'),
      ),

      /// 수국 + [계] 존재 (+ 무토 2개 제어는 해석단)
      JoyongEnvironmentRule(
        id: 'sin_ja_water_bureau_gye_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('癸'),
      ),

      /// 해자축 수국 완성 + 병화 없음
      JoyongEnvironmentRule(
        id: 'sin_ja_hae_ja_chuk_complete_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ['亥','子','丑'].every((b) => ctx.branches.contains(b)) &&
            !ctx.stems.contains('丙'),
      ),

      /// [경][신] 없음 + [갑][을] 존재 + [무][병] 없음
      JoyongEnvironmentRule(
        id: 'sin_ja_no_metal_gap_only_ascetic_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.any((s) => ['庚','辛'].contains(s)) &&
            ctx.stems.any((s) => ['甲','乙'].contains(s)) &&
            !ctx.stems.contains('戊') &&
            !ctx.stems.contains('丙'),
      ),

      /// 목국 + [정] 존재 + [무] 존재
      JoyongEnvironmentRule(
        id: 'sin_ja_wood_bureau_jeong_mu_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('戊'),
      ),

    ],
    '丑': [

      /// [신] 존재
      JoyongEnvironmentRule(
        id: 'sin_chuk_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('辛'),
      ),

      /// [병][임] 모두 존재
      JoyongEnvironmentRule(
        id: 'sin_chuk_byeong_im_okdang_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('壬'),
      ),

      /// [인][사][오] 존재 + [신][해][자] 존재
      JoyongEnvironmentRule(
        id: 'sin_chuk_hidden_fire_water_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['寅','巳','午'].contains(b)) &&
            ctx.branches.any((b) => ['申','亥','子'].contains(b)),
      ),

      /// [병] 존재 + [임] 없음
      JoyongEnvironmentRule(
        id: 'sin_chuk_only_byeong_rich_showy_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('壬'),
      ),

      /// [임] 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'sin_chuk_only_im_cold_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            !ctx.stems.contains('丙'),
      ),

      /// [병] 2개 또는 [병]+[사][오] + [임] 없음 + [계] 존재
      JoyongEnvironmentRule(
        id: 'sin_chuk_many_byeong_no_im_with_gye_merchant_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => s == '丙').length >= 2 ||
                (ctx.stems.contains('丙') &&
                    ctx.branches.any((b) => ['巳','午'].contains(b)))
        ) &&
            !ctx.stems.contains('壬') &&
            ctx.stems.contains('癸'),
      ),

      /// [임][계][해][자] 3개 이상 + [갑][기] 존재 + [병][정] 존재
      JoyongEnvironmentRule(
        id: 'sin_chuk_many_water_gap_gi_fire_comfort_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
                ctx.branches.where((b) => ['亥','子'].contains(b)).length
        ) >= 3 &&
            ctx.stems.any((s) => ['甲','己'].contains(s)) &&
            ctx.stems.any((s) => ['丙','丁'].contains(s)),
      ),

    ],
  },
  /// =========================
  /// 壬水
  /// =========================
  '壬': {
    '寅': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_in_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [경][병][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_in_gyeong_byeong_mu_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

      /// [사][신][유] 존재 + [해][인][진][신][술][사] 존재
      JoyongEnvironmentRule(
        id: 'im_in_hidden_metal_earth_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['巳','申','酉'].contains(b)) &&
            ctx.branches.any((b) => ['亥','寅','辰','申','戌','巳'].contains(b)),
      ),

      /// [임][계] 존재 + [경][신] 존재
      JoyongEnvironmentRule(
        id: 'im_in_water_peer_metal_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['壬','癸'].contains(s)) &&
            ctx.stems.any((s) => ['庚','辛'].contains(s)),
      ),

      /// [술][진] 2개 이상 존재
      JoyongEnvironmentRule(
        id: 'im_in_many_earth_gap_control_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['戌','辰'].contains(b)).length >= 2,
      ),

      /// 지지가 화국
      JoyongEnvironmentRule(
        id: 'im_in_fire_guk_missed_timing_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

    ],
    '卯': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_myo_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [무][신] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_myo_mu_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.stems.contains('辛'),
      ),

      /// [무] 존재 + [축][술][유] 존재
      JoyongEnvironmentRule(
        id: 'im_myo_mu_hidden_sin_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.branches.any((b) => ['丑','戌','酉'].contains(b)),
      ),

      /// [무][신] 없음 + [경] 존재
      JoyongEnvironmentRule(
        id: 'im_myo_no_mu_sin_gyeong_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('戊') &&
            !ctx.stems.contains('辛') &&
            ctx.stems.contains('庚'),
      ),

      /// 지지가 목국
      JoyongEnvironmentRule(
        id: 'im_myo_wood_guk_exam_or_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

      /// [갑][을] 존재 + [병][정][사][오] 3개 이상
      JoyongEnvironmentRule(
        id: 'im_myo_wood_fire_overheat_need_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.any((s) => ['甲','乙'].contains(s)) &&
            ctx.branches.where((b) => ['巳','午','丙','丁'].contains(b)).length >= 3,
      ),

      /// [임] 2개 이상
      JoyongEnvironmentRule(
        id: 'im_myo_many_im_need_mu_control_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2,
      ),

      /// [갑][을] 모두 존재 + [임][계] 없음
      JoyongEnvironmentRule(
        id: 'im_myo_gap_eul_no_water_dependence_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('乙') &&
            !ctx.stems.any((s) => ['壬','癸'].contains(s)),
      ),

    ],
    '辰': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_jin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [갑][경] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_jin_gap_gyeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('庚'),
      ),

      /// [갑] 존재 + 지지 [사][신][유]
      JoyongEnvironmentRule(
        id: 'im_jin_gap_hidden_gyeong_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// 지지 [해][인][묘] 존재
      JoyongEnvironmentRule(
        id: 'im_jin_hidden_gap_root_stable_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [계] 존재
      JoyongEnvironmentRule(
        id: 'im_jin_gye_support_upper_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [해][인][묘] 1개만 존재
      JoyongEnvironmentRule(
        id: 'im_jin_single_hidden_gap_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['亥','寅','卯'].contains(b)).length == 1,
      ),

      /// [경] 1개 존재 + [사][신][유] 없음
      JoyongEnvironmentRule(
        id: 'im_jin_single_gyeong_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '庚').length == 1 &&
            !ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

      /// [갑] 없음
      JoyongEnvironmentRule(
        id: 'im_jin_no_gap_rough_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲'),
      ),

      /// [경] 없음
      JoyongEnvironmentRule(
        id: 'im_jin_no_gyeong_dull_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚'),
      ),

      /// [진][술][축][미] 2개 이상
      JoyongEnvironmentRule(
        id: 'im_jin_many_earth_loss_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

    ],
    '巳': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_sa_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [임] 2개 + [계] 존재
      JoyongEnvironmentRule(
        id: 'im_sa_two_im_gye_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.stems.contains('癸'),
      ),

      /// [계] + [신] 존재
      JoyongEnvironmentRule(
        id: 'im_sa_gye_sin_alt_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('癸') &&
            ctx.stems.contains('辛'),
      ),

      /// [갑][을][인][묘] ≤1  +  화 3개 이상
      JoyongEnvironmentRule(
        id: 'im_sa_few_wood_many_fire_spouse_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['寅','卯'].contains(b)).length <= 1 &&
            ctx.branches.where((b) => ['巳','午'].contains(b)).length +
                ctx.stems.where((s) => ['丙','丁'].contains(s)).length >= 3,
      ),

      /// [경][신][신][유] 3개 이상
      JoyongEnvironmentRule(
        id: 'im_sa_many_metal_recover_strength_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['庚','辛'].contains(s)).length +
            ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 3,
      ),

      /// [인] 존재 + [갑][묘][해] 없음
      JoyongEnvironmentRule(
        id: 'im_sa_hidden_gap_conflict_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.contains('寅') &&
            !ctx.stems.contains('甲') &&
            !ctx.branches.any((b) => ['卯','亥'].contains(b)),
      ),

      /// [갑][을] 2개 이상 OR [갑][을][인][묘] 3개 이상
      JoyongEnvironmentRule(
        id: 'im_sa_many_wood_need_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['甲','乙'].contains(s)).length >= 2 ||
            (ctx.stems.where((s) => ['甲','乙'].contains(s)).length +
                ctx.branches.where((b) => ['寅','卯'].contains(b)).length) >= 3,
      ),

      /// 지지 수국
      JoyongEnvironmentRule(
        id: 'im_sa_water_guk_high_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

    ],
    '午': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_o_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [경][계] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_o_gyeong_gye_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('癸'),
      ),

      /// [임] 2개 + [경] 존재
      JoyongEnvironmentRule(
        id: 'im_o_two_im_gyeong_top_rank_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.stems.contains('庚'),
      ),

      /// [경] 존재 + [임] 1개 + [계] 없음
      JoyongEnvironmentRule(
        id: 'im_o_only_gyeong_single_im_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.where((s) => s == '壬').length == 1 &&
            !ctx.stems.contains('癸'),
      ),

      /// 지지 화국 + 금·수 전무
      JoyongEnvironmentRule(
        id: 'im_o_fire_guk_no_metal_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.any((s) => ['庚','辛','壬','癸'].contains(s)) &&
            !ctx.branches.any((b) => ['申','酉','亥','子'].contains(b)),
      ),

    ],
    '未': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_mi_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [신][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_mi_sin_gap_clear_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.stems.contains('甲'),
      ),

      /// [해][인][묘] 존재 + 천간 [신] 존재
      JoyongEnvironmentRule(
        id: 'im_mi_hidden_gap_visible_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.stems.contains('辛'),
      ),

      /// [축][술][유] 존재 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'im_mi_hidden_sin_gap_alt_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['丑','戌','酉'].contains(b)) &&
            ctx.stems.contains('甲'),
      ),

      /// [임] 2개 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'im_mi_two_im_gap_state_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.stems.contains('甲'),
      ),

      /// [해][인][묘] 존재 + [임] 투출
      JoyongEnvironmentRule(
        id: 'im_mi_hidden_gap_im_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            ctx.stems.contains('壬'),
      ),

      /// [진][술][축][미][사][오] 3개 이상
      JoyongEnvironmentRule(
        id: 'im_mi_many_fire_earth_poor_but_clean_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where(
              (b) => ['辰','戌','丑','未','巳','午'].contains(b),
        ).length >= 3,
      ),

      /// [기][축] 2개 이상
      JoyongEnvironmentRule(
        id: 'im_mi_strong_earth_gajongsal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => b == '丑').length >= 2 ||
            ctx.stems.where((s) => s == '己').length >= 2,
      ),

      /// 지지 목국
      JoyongEnvironmentRule(
        id: 'im_mi_wood_guk_excess_leak_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

    ],
    '申': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [무][정] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_sin_mu_jeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.stems.contains('丁'),
      ),

      /// [무] 존재 + [오][술] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_mu_hidden_fire_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.branches.any((b) => ['午','戌'].contains(b)),
      ),

      /// [인][술] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_sin_in_sul_official_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.contains('寅') &&
            ctx.branches.contains('戌'),
      ),

      /// [술][미][오] 존재 + [해][인][진][신][술][사] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_hidden_mu_jeong_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['戌','未','午'].contains(b)) &&
            ctx.branches.any((b) => ['亥','寅','辰','申','戌','巳'].contains(b)),
      ),

      /// [임] 2개 이상 + [무] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_many_im_mu_comfort_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.stems.contains('戊'),
      ),

      /// [해][인][묘] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_hidden_gap_normal_but_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['亥','寅','卯'].contains(b)),
      ),

      /// [무] 2개 이상 OR [무]+[술][진] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_many_mu_need_gap_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length >= 2 ||
            (ctx.stems.contains('戊') &&
                ctx.branches.any((b) => ['戌','辰'].contains(b))),
      ),

      /// [갑] 2개 OR [갑]+[인][묘] 존재
      JoyongEnvironmentRule(
        id: 'im_sin_many_gap_rootless_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '甲').length >= 2 ||
            (ctx.stems.contains('甲') &&
                ctx.branches.any((b) => ['寅','卯'].contains(b))),
      ),

    ],
    '酉': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_yu_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [갑] 존재
      JoyongEnvironmentRule(
        id: 'im_yu_gap_academic_fame_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// [해][인][묘] 존재 + [경] 없음
      JoyongEnvironmentRule(
        id: 'im_yu_hidden_gap_no_gyeong_talent_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['亥','寅','卯'].contains(b)) &&
            !ctx.stems.contains('庚'),
      ),

      /// [임] 2개 이상 + 지지 [신][해] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_yu_many_im_sin_hae_use_mu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.branches.contains('申') &&
            ctx.branches.contains('亥'),
      ),

      /// [해] 존재
      JoyongEnvironmentRule(
        id: 'im_yu_hae_talent_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.contains('亥'),
      ),

      /// [무] 없음 + 금·수 다수
      JoyongEnvironmentRule(
        id: 'im_yu_no_mu_many_metal_water_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('戊') &&
            (
                ctx.stems.where((s) => ['庚','辛','壬','癸'].contains(s)).length >= 3 ||
                    ctx.branches.where((b) => ['申','酉','亥','子'].contains(b)).length >= 3
            ),
      ),

    ],
    '戌': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_sul_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [임] 2개 또는 [임]+[해][자] 존재
      JoyongEnvironmentRule(
        id: 'im_sul_strong_water_with_gap_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => ['亥','子'].contains(b))),
      ),

      /// [무] 2개 또는 [무]+[술][진] 존재
      JoyongEnvironmentRule(
        id: 'im_sul_strong_mu_with_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '戊').length >= 2 ||
            (ctx.stems.contains('戊') &&
                ctx.branches.any((b) => ['戌','辰'].contains(b))),
      ),

      /// [미][오][축] 존재
      JoyongEnvironmentRule(
        id: 'im_sul_hidden_gi_exam_pass_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any((b) => ['未','午','丑'].contains(b)),
      ),

      /// [경] 존재
      JoyongEnvironmentRule(
        id: 'im_sul_gyeong_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('庚'),
      ),

      /// [정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_sul_jeong_gap_minor_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [임][계][해][자] 3개 이상
      JoyongEnvironmentRule(
        id: 'im_sul_many_water_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (
            ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
                ctx.branches.where((b) => ['亥','子'].contains(b)).length
        ) >= 3,
      ),

    ],
    '亥': [

      /// [임] 존재
      JoyongEnvironmentRule(
        id: 'im_hae_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

      /// [무][경] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_hae_mu_gyeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.stems.contains('庚'),
      ),

      /// [갑] 존재
      JoyongEnvironmentRule(
        id: 'im_hae_gap_hurt_mu_no_gyeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('甲'),
      ),

      /// [해][인][진][신][술][사] 존재
      JoyongEnvironmentRule(
        id: 'im_hae_hidden_mu_student_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.branches.any(
                  (b) => ['亥','寅','辰','申','戌','巳'].contains(b),
            ),
      ),

      /// [무][경] 모두 존재 + [갑] 없음
      JoyongEnvironmentRule(
        id: 'im_hae_mu_gyeong_no_gap_high_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.stems.contains('庚') &&
            !ctx.stems.contains('甲'),
      ),

      /// 지지 목국 + [갑][을] 존재
      JoyongEnvironmentRule(
        id: 'im_hae_wood_bureau_gap_eul_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.any((s) => ['甲','乙'].contains(s)),
      ),

      /// 지지 수국 + [무][기] 모두 없음
      JoyongEnvironmentRule(
        id: 'im_hae_water_bureau_no_earth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.any((s) => ['戊','己'].contains(s)),
      ),

      /// [병][무] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_hae_byeong_mu_complete_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

      /// [병] 존재 + [무] 없음
      JoyongEnvironmentRule(
        id: 'im_hae_byeong_no_mu_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('戊'),
      ),

      /// [무] 존재 + [병] 없음
      JoyongEnvironmentRule(
        id: 'im_hae_mu_no_byeong_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            !ctx.stems.contains('丙'),
      ),

    ],
    '子': [
      // [임] 존재
      JoyongEnvironmentRule(
        id: 'im_ja_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

// [무][병] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_ja_wu_byeong_both_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            ctx.stems.contains('丙'),
      ),

// [무] 존재 [병] 없음
      JoyongEnvironmentRule(
        id: 'im_ja_wu_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('戊') &&
            !ctx.stems.contains('丙'),
      ),

// [병] 존재 [무] 없음
      JoyongEnvironmentRule(
        id: 'im_ja_byeong_only_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('戊'),
      ),

// 수국 + 병 없음 + 무 존재
      JoyongEnvironmentRule(
        id: 'im_ja_water_bureau_wu_no_fire_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

// [병] 존재 (자리 적절)
      JoyongEnvironmentRule(
        id: 'im_ja_byeong_support_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

// 화국
      JoyongEnvironmentRule(
        id: 'im_ja_fire_bureau_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

// 사고(진술축미) 2개 이상
      JoyongEnvironmentRule(
        id: 'im_ja_earth_four_two_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches
            .where((b) => ['辰','戌','丑','未'].contains(b))
            .length >= 2,
      ),

    ],
    '丑': [
      // [임] 존재
      JoyongEnvironmentRule(
        id: 'im_chuk_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('壬'),
      ),

// [임][해] 3개 이상 + [무] 존재
      JoyongEnvironmentRule(
        id: 'im_chuk_many_water_with_wu_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length +
            ctx.branches.where((b) => b == '亥').length >= 3 &&
            ctx.stems.contains('戊'),
      ),

// 금국 + 병정화 없음
      JoyongEnvironmentRule(
        id: 'im_chuk_metal_bureau_no_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁'),
      ),

// [병][신] 모두 존재
      JoyongEnvironmentRule(
        id: 'im_chuk_byeong_sin_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

// [병][정][갑] 존재
      JoyongEnvironmentRule(
        id: 'im_chuk_byeong_jeong_gap_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

// [임][계][해][자] 2개 이상
      JoyongEnvironmentRule(
        id: 'im_chuk_many_water_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['壬','癸'].contains(s)).length +
            ctx.branches.where((b) => ['亥','子'].contains(b)).length >= 2,
      ),

    ],
  },
  /// =========================
  /// 癸水
  /// =========================
  '癸': {
    '寅': [
      // [계] 존재
      JoyongEnvironmentRule(
        id: 'gye_in_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      // [병][신] 모두 존재
      JoyongEnvironmentRule(
        id: 'gye_in_byeong_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

      // 지지 화국
      JoyongEnvironmentRule(
        id: 'gye_in_fire_bureau_with_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      // [병] 존재
      JoyongEnvironmentRule(
        id: 'gye_in_byeong_general_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      // [병][신] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_in_no_byeong_no_sin_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('辛'),
      ),

      // [신] 존재 + [인][사][오] 존재
      JoyongEnvironmentRule(
        id: 'gye_in_sin_hidden_fire_favor_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.branches.any((b) => ['寅','巳','午'].contains(b)),
      ),

      // [병][사] 존재 + 천간 [신][유] 존재
      JoyongEnvironmentRule(
        id: 'gye_in_byeong_sa_sin_you_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.branches.contains('巳') &&
            ctx.stems.any((s) => ['辛','酉'].contains(s)),
      ),

      // 지지 수국
      JoyongEnvironmentRule(
        id: 'gye_in_water_bureau_rule_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

      // [경][신] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_in_no_gyeong_no_sin_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛'),
      ),

      // 화 2개 이상 + 토 2개 이상
      JoyongEnvironmentRule(
        id: 'gye_in_fire_earth_excess_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length >= 2 &&
            ctx.stems.where((s) => ['戊','己'].contains(s)).length +
                ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).length >= 2,
      ),

    ],
    '卯': [
      // [계] 존재
      JoyongEnvironmentRule(
        id: 'gye_myo_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

// [경][신] 모두 존재 (정화 없음)
      JoyongEnvironmentRule(
        id: 'gye_myo_gyeong_sin_no_jeong_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('辛') &&
            !ctx.stems.contains('丁'),
      ),

// [경][신] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_myo_no_gyeong_no_sin_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛'),
      ),

// [경] 존재 [신] 없음 + [축][술][유]
      JoyongEnvironmentRule(
        id: 'gye_myo_gyeong_only_hidden_sin_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛') &&
            ctx.branches.any((b) => ['丑','戌','酉'].contains(b)),
      ),

// [신] 존재 [경] 없음 + [사][신][유]
      JoyongEnvironmentRule(
        id: 'gye_myo_sin_only_hidden_gyeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            !ctx.stems.contains('庚') &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

// [경][신] 모두 없음 + [축][술][유] + [사][신][유]
      JoyongEnvironmentRule(
        id: 'gye_myo_hidden_metal_wealth_or_art_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛') &&
            ctx.branches.any((b) => ['丑','戌','酉'].contains(b)) &&
            ctx.branches.any((b) => ['巳','申','酉'].contains(b)),
      ),

// [경][신][신][유] 2개 이상 + [기][정] 모두 존재
      JoyongEnvironmentRule(
        id: 'gye_myo_heavy_metal_controlled_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) {
          final metalCount =
              ctx.stems.where((s) => ['庚','辛'].contains(s)).length +
                  ctx.branches.where((b) => ['申','酉'].contains(b)).length;
          return metalCount >= 2 &&
              ctx.stems.contains('己') &&
              ctx.stems.contains('丁');
        },
      ),

// 지지 목국
      JoyongEnvironmentRule(
        id: 'gye_myo_wood_bureau_overflow_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

    ],
    '辰': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_jin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 지지 수국 + [기] 존재
      JoyongEnvironmentRule(
        id: 'gye_jin_water_guk_with_gi_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('己'),
      ),

      /// [진][술][축][미] 3개 이상
      JoyongEnvironmentRule(
        id: 'gye_jin_many_earth_branches_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches
            .where((b) => ['辰','戌','丑','未'].contains(b))
            .length >= 3,
      ),

      /// 지지 목국 + 금 없음
      JoyongEnvironmentRule(
        id: 'gye_jin_wood_guk_no_metal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            !ctx.stems.any((s) => ['庚','辛'].contains(s)) &&
            !ctx.branches.any((b) => ['申','酉'].contains(b)),
      ),

    ],
    '巳': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_sa_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// 천간 [신] 존재 + [정] 없음 + [임] 존재
      JoyongEnvironmentRule(
        id: 'gye_sa_sin_im_no_jeong_high_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            !ctx.stems.contains('丁') &&
            ctx.stems.contains('壬'),
      ),

      /// [정] 존재
      JoyongEnvironmentRule(
        id: 'gye_sa_jeong_breaks_sin_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('丁'),
      ),

      /// [축][술][유] 존재 + [정] 없음
      JoyongEnvironmentRule(
        id: 'gye_sa_hidden_sin_no_jeong_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.any((b) => ['丑','戌','酉'].contains(b)) &&
            !ctx.stems.contains('丁'),
      ),

      /// 화·토 각각 2개 이상
      JoyongEnvironmentRule(
        id: 'gye_sa_heavy_fire_earth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems
            .where((s) => ['丙','丁'].contains(s))
            .length +
            ctx.branches
                .where((b) => ['巳','午'].contains(b))
                .length >= 2 &&
            ctx.stems
                .where((s) => ['戊','己'].contains(s))
                .length +
                ctx.branches
                    .where((b) => ['辰','戌','丑','未'].contains(b))
                    .length >= 2,
      ),

      /// [경] 존재 + [임][정] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_sa_only_gyeong_scholar_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('丁'),
      ),

      /// [경] 존재 + [신] 없음
      JoyongEnvironmentRule(
        id: 'gye_sa_gyeong_no_sin_other_path_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            !ctx.stems.contains('辛'),
      ),

    ],
    '午': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_o_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [경][신] 존재 + [임][계] 존재
      JoyongEnvironmentRule(
        id: 'gye_o_gyeong_sin_with_im_gye_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// [경][신] 존재 + 지지 [신][자][진] 모두 존재 (수국)
      JoyongEnvironmentRule(
        id: 'gye_o_gyeong_sin_water_guk_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            ctx.gukGroups.contains('수국'),
      ),

      /// [임][계] 모두 없음 + 지지 수 1개만 존재
      JoyongEnvironmentRule(
        id: 'gye_o_no_im_gye_one_water_branch_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸') &&
            ctx.branches.where((b) => ['亥','子'].contains(b)).length == 1,
      ),

      /// 지지가 수국
      JoyongEnvironmentRule(
        id: 'gye_o_water_guk_wealth_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

      /// [경][신] 1개 이상 + [임][계] 1개 이상
      JoyongEnvironmentRule(
        id: 'gye_o_gold_water_together_great_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// 지지가 화국 + [임] 없음
      JoyongEnvironmentRule(
        id: 'gye_o_fire_guk_no_im_monk_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.contains('壬'),
      ),

      /// [임] 2개 존재 + [경] 존재
      JoyongEnvironmentRule(
        id: 'gye_o_two_im_with_gyeong_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.stems.contains('庚'),
      ),

      /// [기] 1개 이상 + [축][미] 존재
      JoyongEnvironmentRule(
        id: 'gye_o_gi_with_chuk_mi_jongsal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['丑','未'].contains(b)),
      ),

    ],
    '未': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_mi_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [경][신] 존재 + [임][계] 존재
      JoyongEnvironmentRule(
        id: 'gye_mi_gyeong_sin_with_im_gye_noble_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// [경][신] 존재 + 지지 [신][자][진] 모두 존재 (수국)
      JoyongEnvironmentRule(
        id: 'gye_mi_gyeong_sin_water_guk_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            ctx.gukGroups.contains('수국'),
      ),

      /// [임][계] 모두 없음 + 지지 수 1개만 존재
      JoyongEnvironmentRule(
        id: 'gye_mi_no_im_gye_one_water_branch_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸') &&
            ctx.branches.where((b) => ['亥','子'].contains(b)).length == 1,
      ),

      /// 지지가 수국
      JoyongEnvironmentRule(
        id: 'gye_mi_water_guk_wealth_only_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('수국'),
      ),

      /// [경][신] 1개 이상 + [임][계] 1개 이상
      JoyongEnvironmentRule(
        id: 'gye_mi_gold_water_together_great_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        (ctx.stems.contains('庚') || ctx.stems.contains('辛')) &&
            (ctx.stems.contains('壬') || ctx.stems.contains('癸')),
      ),

      /// 지지가 화국 + [임] 없음
      JoyongEnvironmentRule(
        id: 'gye_mi_fire_guk_no_im_monk_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('화국') &&
            !ctx.stems.contains('壬'),
      ),

      /// [임] 2개 존재 + [경] 존재
      JoyongEnvironmentRule(
        id: 'gye_mi_two_im_with_gyeong_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 &&
            ctx.stems.contains('庚'),
      ),

      /// [기] 1개 이상 + [축][미] 존재
      JoyongEnvironmentRule(
        id: 'gye_mi_gi_with_chuk_mi_jongsal_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('己') &&
            ctx.branches.any((b) => ['丑','未'].contains(b)),
      ),

    ],
    '申': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_sin_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [정][갑] 모두 존재
      JoyongEnvironmentRule(
        id: 'gye_sin_jeong_gap_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            ctx.stems.contains('甲'),
      ),

      /// [정] 존재 + [갑][임][계] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_sin_only_jeong_no_support_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丁') &&
            !ctx.stems.contains('甲') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸'),
      ),

      /// [경][신][신][유] 4개 이상 + [정] 없음
      JoyongEnvironmentRule(
        id: 'gye_sin_heavy_metal_no_fire_poor_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.where((b) => ['申','酉'].contains(b)).length >= 4 &&
            !ctx.stems.contains('丁'),
      ),

      /// [정] 1개 존재
      JoyongEnvironmentRule(
        id: 'gye_sin_single_jeong_quality_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '丁').length == 1,
      ),

      /// [술][미] 2개 + [인][사][술][미][오] 존재 + [갑] 존재 + 수 없음
      JoyongEnvironmentRule(
        id: 'gye_sin_soil_fire_gap_no_water_rich_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches.where((b) => ['戌','未'].contains(b)).length >= 2 &&
            ctx.branches.any((b) => ['寅','巳','戌','未','午'].contains(b)) &&
            ctx.stems.contains('甲') &&
            !ctx.stems.contains('壬') &&
            !ctx.stems.contains('癸') &&
            !ctx.branches.any((b) => ['亥','子'].contains(b)),
      ),

    ],
    '酉': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_yu_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [병][신] 존재
      JoyongEnvironmentRule(
        id: 'gye_yu_byeong_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('辛'),
      ),

      /// [병] 존재 + [신] 없음 + [축][술][유] 존재
      JoyongEnvironmentRule(
        id: 'gye_yu_byeong_hidden_sin_exam_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('辛') &&
            ctx.branches.any((b) => ['丑','戌','酉'].contains(b)),
      ),

      /// [무][기][진][술][축][미] 3개 이상 존재
      JoyongEnvironmentRule(
        id: 'gye_yu_heavy_earth_trade_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.branches
            .where((b) => ['辰','戌','丑','未'].contains(b))
            .length +
            ctx.stems
                .where((s) => ['戊','己'].contains(s))
                .length >= 3,
      ),

    ],
    '戌': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_sul_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [신][갑] 모두 존재 + 지지에 [자]
      JoyongEnvironmentRule(
        id: 'gye_sul_sin_gap_high_office_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('辛') &&
            ctx.stems.contains('甲') &&
            ctx.branches.contains('子'),
      ),

      /// [계] 2개 이상 + [갑] 존재
      JoyongEnvironmentRule(
        id: 'gye_sul_double_gye_gap_success_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length >= 2 &&
            ctx.stems.contains('甲'),
      ),

      /// [갑][신] 존재 + [계] 없음
      JoyongEnvironmentRule(
        id: 'gye_sul_gap_sin_no_gye_granted_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('辛') &&
            !ctx.stems.contains('癸'),
      ),

      /// [갑][계] 존재 + [신] 없음
      JoyongEnvironmentRule(
        id: 'gye_sul_gap_gye_no_sin_wealth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('癸') &&
            !ctx.stems.contains('辛'),
      ),

      /// [갑] 존재 + [계][신] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_sul_only_gap_plain_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸') &&
            !ctx.stems.contains('辛'),
      ),

      /// [갑][계][신] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_sul_no_gap_gye_sin_low_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('甲') &&
            !ctx.stems.contains('癸') &&
            !ctx.stems.contains('辛'),
      ),

      /// [갑][임] 모두 존재
      JoyongEnvironmentRule(
        id: 'gye_sul_gap_im_control_earth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('甲') &&
            ctx.stems.contains('壬'),
      ),

    ],
    '亥': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_hae_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [경][신] 모두 존재 + [정] 없음
      JoyongEnvironmentRule(
        id: 'gye_hae_gyeong_sin_clear_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('辛') &&
            !ctx.stems.contains('丁'),
      ),

      /// 목국 + [정] 존재
      JoyongEnvironmentRule(
        id: 'gye_hae_mokguk_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('丁'),
      ),

      /// 목국 + [병][정] 모두 존재
      JoyongEnvironmentRule(
        id: 'gye_hae_mokguk_byeong_jeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('목국') &&
            ctx.stems.contains('丙') &&
            ctx.stems.contains('丁'),
      ),

      /// [임] 2개 이상 OR [임]+[해][자]
      JoyongEnvironmentRule(
        id: 'gye_hae_strong_im_flow_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.any((b) => b == '亥' || b == '子')),
      ),

      /// [경][신] 모두 존재 (정화 유무 관계)
      JoyongEnvironmentRule(
        id: 'gye_hae_many_metal_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('庚') &&
            ctx.stems.contains('辛'),
      ),

      /// [병][정][사][오] 4개 이상
      JoyongEnvironmentRule(
        id: 'gye_hae_many_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => ['丙','丁'].contains(s)).length +
            ctx.branches.where((b) => ['巳','午'].contains(b)).length >= 4,
      ),

    ],
    '子': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_ja_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [임] 2개 이상 OR [임]+[자]
      JoyongEnvironmentRule(
        id: 'gye_ja_strong_im_no_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.where((s) => s == '壬').length >= 2 ||
            (ctx.stems.contains('壬') &&
                ctx.branches.contains('子'))) &&
            !ctx.stems.contains('丙'),
      ),

      /// [계] 3개 OR [계]2개 + [해]
      JoyongEnvironmentRule(
        id: 'gye_ja_many_gye_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.where((s) => s == '癸').length >= 3 ||
            (ctx.stems.where((s) => s == '癸').length >= 2 &&
                ctx.branches.contains('亥')),
      ),

      /// 수국 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gye_ja_suguk_byeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            ctx.stems.contains('丙'),
      ),

      /// 금국 + [병][인][사][오] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_ja_geumguk_no_fire_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁') &&
            ctx.branches.where((b) => ['寅','巳','午'].contains(b)).isEmpty,
      ),

      /// [병][정][사][오] 모두 없음
      JoyongEnvironmentRule(
        id: 'gye_ja_no_fire_all_water_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        !ctx.stems.contains('丙') &&
            !ctx.stems.contains('丁') &&
            ctx.branches.where((b) => ['巳','午'].contains(b)).isEmpty,
      ),

      /// [무][기] 존재 + 사고(진술축미) 1개
      JoyongEnvironmentRule(
        id: 'gye_ja_many_earth_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        (ctx.stems.contains('戊') || ctx.stems.contains('己')) &&
            ctx.branches.where((b) => ['辰','戌','丑','未'].contains(b)).isNotEmpty,
      ),

    ],
    '丑': [

      /// [계] 존재 (총론)
      JoyongEnvironmentRule(
        id: 'gye_chuk_core_theory_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.stems.contains('癸'),
      ),

      /// [병][임] 모두 존재 + [진][술]
      JoyongEnvironmentRule(
        id: 'gye_chuk_byeong_im_chen_sul_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            ctx.stems.contains('壬') &&
            ctx.branches.any((b) => ['辰','戌'].contains(b)),
      ),

      /// [병] 존재, [임] 없음
      JoyongEnvironmentRule(
        id: 'gye_chuk_byeong_no_im_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.contains('丙') &&
            !ctx.stems.contains('壬'),
      ),

      /// [임] 존재, [병] 없음, [무] 존재
      JoyongEnvironmentRule(
        id: 'gye_chuk_im_no_byeong_mu_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.stems.contains('壬') &&
            !ctx.stems.contains('丙') &&
            ctx.stems.contains('戊'),
      ),

      /// [자][축] 지지 + [계] 존재
      JoyongEnvironmentRule(
        id: 'gye_chuk_ja_chuk_gye_plain_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.branches.contains('子') &&
            ctx.branches.contains('丑') &&
            ctx.stems.contains('癸'),
      ),

      /// [계] 없음 + [신][정] 존재
      JoyongEnvironmentRule(
        id: 'gye_chuk_no_gye_sin_jeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        !ctx.stems.contains('癸') &&
            ctx.stems.contains('辛') &&
            ctx.stems.contains('丁'),
      ),

      /// [계][기][축][미][자] 5개 이상
      JoyongEnvironmentRule(
        id: 'gye_chuk_many_gye_gi_water_earth_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.stems.where((s) => ['癸','己'].contains(s)).length +
            ctx.branches.where((b) => ['丑','未','子'].contains(b)).length >= 5,
      ),

      /// 수국 + [병] 없음
      JoyongEnvironmentRule(
        id: 'gye_chuk_suguk_no_byeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
        ctx.gukGroups.contains('수국') &&
            !ctx.stems.contains('丙'),
      ),

      /// 화국
      JoyongEnvironmentRule(
        id: 'gye_chuk_hwaguk_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('화국'),
      ),

      /// 금국 + [병] 존재
      JoyongEnvironmentRule(
        id: 'gye_chuk_geumguk_byeong_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
        ctx.gukGroups.contains('금국') &&
            ctx.stems.contains('丙'),
      ),

      /// [병] 존재 (약함)
      JoyongEnvironmentRule(
        id: 'gye_chuk_weak_byeong_neg',
        effect: EnvironmentEffect.negative,
        condition: (ctx) =>
            ctx.stems.contains('丙'),
      ),

      /// 목국
      JoyongEnvironmentRule(
        id: 'gye_chuk_mokguk_pos',
        effect: EnvironmentEffect.positive,
        condition: (ctx) =>
            ctx.gukGroups.contains('목국'),
      ),

    ],
  },
};
