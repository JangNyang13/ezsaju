#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
20080402.sql  (만세력 DB 덤프)  →  manse_1900_2100.json
 - INSERT  문만 파싱해서 pandas DataFrame으로 적재
 - 필요 컬럼만 뽑아 JSON(records) 저장
"""

import re, json, sqlparse
import pandas as pd
from pathlib import Path
from tqdm import tqdm

# ─────────────────────────────────────────────────────────────
SQL_FILE  = Path("20080402.sql")           # ZIP 풀어서 같은 폴더에 두기
JSON_FILE = Path("manse_1900_2100.json")

# 원하는 컬럼만 남기면 용량 ↓
COLUMNS = [
    "cd_sy","cd_sm","cd_sd",
    "cd_hyganjee","cd_hmganjee","cd_hdganjee",
    "cd_terms_time",
    "cd_leap_month","cd_month_size",
    "holiday"
]
# ─────────────────────────────────────────────────────────────

def parse_insert_values(statement: str):
    """
    주어진 INSERT … VALUES (…) 구문 → List[Tuple]
    """
    # 괄호 덩어리만 잘라서 파싱
    values_str = statement.partition("VALUES")[2].strip().rstrip(";")
    tuples = []
    for grp in re.findall(r"\([^)]*\)", values_str):
        # 작은따옴표 안의 ','는 그대로 두고, 밖의 ','만 분할
        parts = list(sqlparse.split(",".join(sqlparse.split(grp[1:-1], ","))))
        cleaned = [p.strip(" '") or None for p in parts]
        tuples.append(cleaned)
    return tuples

# 1) 파일 읽기 ▶ INSERT 문만 추출
print("▶ INSERT 문 스캔 중…")
all_rows, col_order = [], None

with SQL_FILE.open("r", encoding="euc-kr", errors="ignore") as f:
    for line in tqdm(f, total=sum(1 for _ in SQL_FILE.open("r", encoding="euc-kr", errors="ignore"))):
        if line.lstrip().upper().startswith("INSERT INTO"):
            if col_order is None:                       # 첫 INSERT에서 컬럼 순서 확보
                col_order = re.findall(r"\(([^)]+)\)", line)[0].replace("`","").split(",")
            for row in parse_insert_values(line):
                all_rows.append(row)

print(f"✔ 총 {len(all_rows):,} 행 파싱 완료")

# 2) DataFrame  →  필요한 컬럼만
df = pd.DataFrame(all_rows, columns=col_order)[COLUMNS]

# 3) JSON 저장
df.to_json(JSON_FILE, orient="records", force_ascii=False, indent=2)
print(f"🎉 {JSON_FILE.name} 저장 끝! (rows: {len(df):,},  size: {JSON_FILE.stat().st_size/1024:,.1f} KB)")
