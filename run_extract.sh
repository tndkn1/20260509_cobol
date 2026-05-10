#!/bin/bash

echo "1. テストデータを生成しています..."
python3 generate_data.py

echo "2. COBOLプログラムをコンパイルしています..."
cobc -x extract_tokyo.cbl

echo "3. 抽出処理を実行しています..."
./extract_tokyo

echo "4. 結果の確認:"
echo "--- 入力データ件数 ---"
wc -l input_data.txt
echo "--- 抽出データ件数 ---"
wc -l output_tokyo.txt
echo "--- 抽出データ先頭3件の確認 ---"
head -n 3 output_tokyo.txt
