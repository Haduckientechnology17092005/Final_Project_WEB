import os
import time
import signal
import sys
import json
import re
import mysql.connector
from mysql.connector import Error
import google.generativeai as genai
from gtts import gTTS
import uuid

# === Cấu hình ===
GOOGLE_API_KEY = "AIzaSyDbQVMmZjz-P_GHJW6eFlJsXsk3n-UeALw"  # Nhập API Key tại đây
MYSQL_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "dutenglish_db"
}

# Cấu hình thư mục âm thanh
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
AUDIO_DIR = os.path.join(BASE_DIR, '../webapp/audio')
os.makedirs(AUDIO_DIR, exist_ok=True)

# === Xử lý tín hiệu dừng ===
running = True
def signal_handler(sig, frame):
    global running
    print("\n⏹️ Đã nhận tín hiệu dừng. Thoát sau khi hoàn tất...")
    running = False
signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

class AutoVocabGenerator:
    def __init__(self):
        if not GOOGLE_API_KEY:
            raise ValueError("❌ Chưa có GOOGLE_API_KEY")

        # Cấu hình Google Gemini
        genai.configure(api_key=GOOGLE_API_KEY)
        self.model = genai.GenerativeModel("gemini-1.5-flash")

        # Kết nối MySQL
        try:
            self.conn = mysql.connector.connect(**MYSQL_CONFIG)
            self.cursor = self.conn.cursor()
            print("✅ Kết nối MySQL thành công")
        except Error as e:
            print(f"❌ Lỗi MySQL: {e}")
            sys.exit(1)

    def close(self):
        if self.conn.is_connected():
            self.cursor.close()
            self.conn.close()
            print("🔒 Đã đóng kết nối MySQL")

    def clean_json(self, text):
        """Loại bỏ định dạng JSON markdown"""
        return re.sub(r"^```(?:json)?\s*|```$", "", text.strip()).strip()

    def generate_random_topic_and_words(self):
        """Tạo chủ đề và từ vựng ngẫu nhiên bằng Gemini"""
        prompt = """
Hãy tạo 1 chủ đề học tiếng Anh thú vị (dạng danh từ) và danh sách 20 từ liên quan đến chủ đề đó.
Trả về JSON thuần như sau, không thêm bất kỳ ký tự nào khác:

{
  "category": "Travel",
  "words": ["passport", "luggage", "destination", "adventure", "explore", "journey", "vacation", "explore", "adventure", "journey", "vacation", "explore", "adventure", "journey", "vacation", "explore", "adventure", "journey", "vacation", "explore"]
}
"""
        try:
            response = self.model.generate_content(prompt)
            cleaned = self.clean_json(response.text)
            print(">>> Chủ đề sinh ra:", cleaned)
            return json.loads(cleaned)
        except Exception as e:
            print(f"❌ Lỗi khi tạo chủ đề: {e}")
            return None

    def create_category_if_not_exists(self, name):
        """Tạo danh mục mới nếu chưa tồn tại"""
        self.cursor.execute("SELECT id FROM Category WHERE name = %s", (name,))
        row = self.cursor.fetchone()
        if row:
            return row[0]
        self.cursor.execute("INSERT INTO Category (name) VALUES (%s)", (name,))
        self.conn.commit()
        print(f"➕ Tạo mới Category: {name}")
        return self.cursor.lastrowid

    def is_vocab_exists(self, word):
        """Kiểm tra từ vựng đã tồn tại chưa"""
        self.cursor.execute("SELECT id FROM Vocabulary WHERE raw = %s", (word,))
        return self.cursor.fetchone() is not None

    def generate_vocab_data(self, word):
        """Tạo dữ liệu từ vựng bằng Gemini"""
        prompt = f"""
Bạn là trợ lý tạo dữ liệu từ vựng tiếng Anh.

Tạo JSON cho từ "{word}" với format sau. Trả về JSON thuần, không kèm giải thích hay markdown:

{{
  "raw": "{word}",
  "phonetic": "/fiːld/",
  "origin": "Nguồn gốc nếu có",
  "meanings": [
    {{
      "partOfSpeech": "noun",
      "definitions": [
        {{
          "definition": "Nghĩa tiếng Việt",
          "example": "Ví dụ 1"
        }}
      ]
    }}
  ]
}}
"""
        try:
            response = self.model.generate_content(prompt)
            cleaned = self.clean_json(response.text)
            print(f">>> Từ '{word}':", cleaned)
            return json.loads(cleaned)
        except Exception as e:
            print(f"❌ Lỗi khi tạo từ '{word}': {e}")
            return None

    def create_audio_file(self, word):
        """Tạo file MP3 và trả về đường dẫn tương đối"""
        try:
            # Tạo tên file duy nhất với UUID
            filename = f"{uuid.uuid4().hex}.mp3"
            filepath = os.path.join(AUDIO_DIR, filename)
            
            # Tạo âm thanh với gTTS
            tts = gTTS(text=word, lang='en')
            tts.save(filepath)
            print(f"🔊 Đã tạo âm thanh cho: {word}")
            
            # Trả về đường dẫn tương đối (chỉ phần sau /audio)
            return f"audio/{filename}"
        except Exception as e:
            print(f"❌ Lỗi khi tạo âm thanh cho '{word}': {e}")
            return None

    def save_vocab_to_db(self, vocab_data, category_id):
        """Lưu từ vựng vào CSDL với file âm thanh"""
        try:
            # Tạo file âm thanh
            audio_path = self.create_audio_file(vocab_data["raw"])
            
            # Chèn từ vựng
            self.cursor.execute("""
                INSERT INTO Vocabulary (raw, phonetic, audio_url, origin, category_id)
                VALUES (%s, %s, %s, %s, %s)
            """, (
                vocab_data["raw"],
                vocab_data.get("phonetic"),
                audio_path,
                vocab_data.get("origin"),
                category_id
            ))
            vocab_id = self.cursor.lastrowid

            # Chèn nghĩa và định nghĩa
            for meaning in vocab_data.get("meanings", []):
                self.cursor.execute("""
                    INSERT INTO Meaning (vocab_id, partOfSpeech)
                    VALUES (%s, %s)
                """, (vocab_id, meaning["partOfSpeech"]))
                meaning_id = self.cursor.lastrowid

                for d in meaning.get("definitions", []):
                    self.cursor.execute("""
                        INSERT INTO Definition (meaning_id, definition, example)
                        VALUES (%s, %s, %s)
                    """, (meaning_id, d["definition"], d.get("example")))

            self.conn.commit()
            print(f"✅ Đã lưu từ: {vocab_data['raw']} (ID: {vocab_id})")
            return True
        except Exception as e:
            print(f"❌ Lỗi khi lưu vào CSDL: {e}")
            self.conn.rollback()
            
            # Xóa file âm thanh nếu lưu CSDL thất bại
            if audio_path and os.path.exists(audio_path.replace("audio/", AUDIO_DIR + "/")):
                os.remove(audio_path.replace("audio/", AUDIO_DIR + "/"))
                print(f"🗑️ Đã xóa file âm thanh: {audio_path}")
            return False

    def run(self, delay_sec=10):
        """Vòng lặp thực thi chính"""
        print(f"\n🚀 Bắt đầu tạo từ vựng (Thời gian chờ: {delay_sec}s)")
        while running:
            # Tạo chủ đề và từ vựng
            topic_data = self.generate_random_topic_and_words()
            if not topic_data:
                print("⚠️ Không tạo được dữ liệu, thử lại sau 10s...")
                time.sleep(delay_sec)
                continue

            category_name = topic_data["category"]
            words = topic_data["words"]
            category_id = self.create_category_if_not_exists(category_name)

            # Xử lý từng từ
            for word in words:
                if not running:
                    break
                    
                if self.is_vocab_exists(word):
                    print(f"⏭️ Từ '{word}' đã có, bỏ qua")
                    continue

                vocab_data = self.generate_vocab_data(word)
                if not vocab_data:
                    print(f"⚠️ Bỏ qua '{word}' do lỗi tạo dữ liệu")
                    continue

                self.save_vocab_to_db(vocab_data, category_id)
                time.sleep(2)  # Tránh vượt quá giới hạn API

            # Thời gian chờ giữa các chu kỳ
            if running:
                print(f"⏳ Đợi {delay_sec}s trước chu kỳ tiếp theo...\n")
                time.sleep(delay_sec)

        self.close()

# === Chạy chính ===
if __name__ == "__main__":
    try:
        generator = AutoVocabGenerator()
        generator.run(delay_sec=10)
    except KeyboardInterrupt:
        print("\n⏹️ Đã dừng bằng bàn phím. Đang thoát...")
    except Exception as e:
        print(f"❌ Lỗi nghiêm trọng: {e}")
        sys.exit(1)