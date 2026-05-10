import random
import string

def pad_utf8(text, length):
    """文字列をUTF-8エンコードし、指定のバイト数になるようスペースでパディングする"""
    encoded = text.encode('utf-8', errors='replace')
    if len(encoded) > length:
        # 切り詰め（実際の業務では文字の境界に注意が必要だが、今回はダミーなので強制カット）
        return encoded[:length]
    else:
        return encoded + b' ' * (length - len(encoded))

def generate_mynumber():
    """12桁の数字"""
    return ''.join(random.choices(string.digits, k=12))

def generate_name(index):
    """ダミーの氏名（最大30文字）"""
    names = ["山田太郎", "鈴木花子", "佐藤次郎", "田中美咲", "伊藤健太", "渡辺愛", "小林誠", "加藤結衣"]
    name = random.choice(names) + f"_{index}"
    # 全角文字と見なして適当な長さに
    return name

def generate_address():
    """ダミーの住所。約20%の確率で東京都にする"""
    prefs = [
        "東京都新宿区西新宿2-8-1",
        "東京都渋谷区神南1-1-1",
        "東京都千代田区丸の内1-1-1",
        "大阪府大阪市北区中之島1-1-1",
        "神奈川県横浜市中区港町1-1",
        "愛知県名古屋市中区三の丸3-1-2",
        "福岡県福岡市博多区博多駅中央街1-1",
        "北海道札幌市中央区北1条西2丁目"
    ]
    weights = [10, 10, 10, 20, 20, 10, 10, 10]
    return random.choices(prefs, weights=weights, k=1)[0]

def generate_phone():
    """13桁の電話番号（例: 090-XXXX-XXXX）"""
    return f"090-{random.randint(1000,9999)}-{random.randint(1000,9999)}"

def main():
    total_records = 10000
    output_file = "input_data.txt"

    with open(output_file, "wb") as f:
        for i in range(1, total_records + 1):
            mynumber = pad_utf8(generate_mynumber(), 12)
            name = pad_utf8(generate_name(i), 90)
            address = pad_utf8(generate_address(), 150)
            phone = pad_utf8(generate_phone(), 13)

            record = mynumber + name + address + phone + b"\n"
            f.write(record)

    print(f"{total_records}件のテストデータを {output_file} に生成しました。")

if __name__ == "__main__":
    main()
