#!/bin/bash
set -e

echo "=== 1. COBOLプログラムのコンパイル ==="
cobc -x sum_amount.cbl

echo "=== 2. プログラムの実行 ==="
./sum_amount

echo "=== 3. 出力結果 (result.txt) の確認 ==="
cat result.txt

echo "=== 4. テスト検証 ==="
# 今回は合計金額が2000になるはず
EXPECTED="TOTAL AMOUNT: 0002000"
ACTUAL=$(cat result.txt)

if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "=> テスト成功: 合計金額が正しく計算されました！"
else
    echo "=> テスト失敗: 期待値 '$EXPECTED', 実際 '$ACTUAL'"
    exit 1
fi
