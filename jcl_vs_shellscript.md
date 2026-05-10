# メインフレームのJCLとLinux(GnuCOBOL)の実行スクリプトの比較

メインフレーム環境では、通常 **JCL（ジョブ制御言語）** を使用して、プログラムの実行、ファイルの割り当て、コンパイルなどを制御します。

しかし、Linux環境（GnuCOBOLなど）でネイティブにJCLを実行することはできません（実行にはHerculesなどのエミュレータや専用の商用製品が必要です）。そのため、一般的なオープン系環境では、**JCLの役割を「シェルスクリプト（Bashなど）」で代替**して実行します。

ここでは、「もしメインフレームだったらどう書くか（JCL）」と、「LinuxでのJCLの代替（シェルスクリプト）」の2つのサンプルを比較します。

---

## 1. メインフレームでのJCLサンプル (参考)

もしメインフレーム上で、「東京都のデータを抽出するCOBOLプログラム」をコンパイルして実行する場合、以下のようなJCLになります。

```jcl
//EXTRACT  JOB (12345),'DATA EXTRACT',CLASS=A,MSGCLASS=X
//*---------------------------------------------------------
//* 1. コンパイルステップ
//*---------------------------------------------------------
//COMPILE  EXEC PGM=IGYCRCTL,PARM='OBJECT,NODYNAM'
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DSN=TNDK.COBOL.SOURCE(EXTRACT),DISP=SHR
//SYSLIN   DD DSN=&&OBJMOD,DISP=(MOD,PASS),SPACE=(CYL,(1,1))
//*---------------------------------------------------------
//* 2. 実行ステップ
//*---------------------------------------------------------
//RUNSTEP  EXEC PGM=EXTRACT
//STEPLIB  DD DSN=TNDK.COBOL.LOAD,DISP=SHR
//INFILE   DD DSN=TNDK.DATA.INPUT,DISP=SHR
//OUTFILE  DD DSN=TNDK.DATA.OUTPUT,DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(5,5)),UNIT=SYSDA,
//            DCB=(RECFM=FB,LRECL=265,BLKSIZE=2650)
//SYSOUT   DD SYSOUT=*
```

* **ポイント:** `DD` 文で、入力ファイル(`INFILE`)と出力ファイル(`OUTFILE`)の物理データセットとの紐付けを行っています。

---

## 2. Linux環境におけるJCLの代替（シェルスクリプト）

現在のLinux環境では、以下のシェルスクリプト（`run_extract.sh`）がJCLの役割（コンパイルから実行、結果の確認まで）を果たしています。

```bash
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
```

* **ポイント:** GnuCOBOLの場合、ファイル名の割り当てはソースコード（`ASSIGN TO "ファイル名"`）や、環境変数（`export DD_INFILE="ファイル名"` 等）を利用してスクリプト上で動的に解決するのが一般的です。

---

## 3. スクリプトの実行結果

実際に `run_extract.sh` を実行（JCLでいうジョブのサブミットに相当）した結果は以下の通りです。

```text
1. テストデータを生成しています...
10000件のテストデータを input_data.txt に生成しました。
2. COBOLプログラムをコンパイルしています...
3. 抽出処理を実行しています...
抽出処理が完了しました。
4. 結果の確認:
--- 入力データ件数 ---
10000 input_data.txt
--- 抽出データ件数 ---
2987 output_tokyo.txt
--- 抽出データ先頭3件の確認 ---
034726203455渡辺愛_1                                                                               東京都千代田区丸の内1-1-1                                                                                                                   090-1338-7173
837297401655伊藤健太_6                                                                            東京都新宿区西新宿2-8-1                                                                                                                      090-6811-5596
850019829971山田太郎_7                                                                            東京都新宿区西新宿2-8-1                                                                                                                      090-5493-4872
```

このように、Linux上では**シェルスクリプト**を使って、JCLのように複数ステップ（データ生成 → コンパイル → プログラム実行 → ファイル出力の確認）を自動で流す形になります。
