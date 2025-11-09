import os
import mysql.connector
from mysql.connector import Error
import sys
import re
import random

# === Cấu hình ===
MYSQL_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "english"
}

class FillInTheBlankGenerator:
    def __init__(self):
        # Kết nối MySQL
        self.conn = None
        try:
            self.conn = mysql.connector.connect(**MYSQL_CONFIG)
            # Sử dụng cursor dạng dictionary để dễ dàng truy cập cột bằng tên
            self.cursor = self.conn.cursor(dictionary=True)
            print("✅ Kết nối MySQL thành công")
        except Error as e:
            print(f"❌ Lỗi MySQL: {e}")
            sys.exit(1)

    def close(self):
        if self.conn and self.conn.is_connected():
            self.cursor.close()
            self.conn.close()
            print("🔒 Đã đóng kết nối MySQL")

    def generate_questions(self, limit=200):
        """
        Tự động tạo câu hỏi điền vào chỗ trống từ các từ vựng đã có.
        """
        print(f"\n🚀 Bắt đầu quá trình tạo câu hỏi điền vào chỗ trống (tối đa {limit} câu)...")

        try:
            # Lấy tất cả các từ vựng có câu ví dụ và chưa được tạo câu hỏi
            self.cursor.execute("""
                SELECT v.id, v.raw, v.category_id, d.example
                FROM Vocabulary v
                JOIN Meaning m ON v.id = m.vocab_id
                JOIN Definition d ON m.id = d.meaning_id
                WHERE d.example IS NOT NULL 
                  AND d.example != ''
                  AND v.id NOT IN (SELECT vocabulary_id FROM fill_in_blank WHERE vocabulary_id IS NOT NULL)
                LIMIT %s
            """, (limit,))
            
            vocab_with_examples = self.cursor.fetchall()

            if not vocab_with_examples:
                print("✅ Không có từ vựng mới nào để tạo câu hỏi. Tất cả đã được tạo.")
                return

            print(f"🔍 Tìm thấy {len(vocab_with_examples)} từ vựng có thể tạo câu hỏi.")
            
            total_generated = 0
            for vocab in vocab_with_examples:
                vocab_id = vocab['id']
                correct_word = vocab['raw']
                example_sentence = vocab['example']
                category_id = vocab['category_id']

                # 1. Tạo câu hỏi bằng cách thay thế từ bằng '___'
                # Sử dụng regex để thay thế chính xác từ, không phân biệt hoa thường
                # \b là word boundary, đảm bảo chỉ thay thế toàn bộ từ.
                # re.escape để xử lý các ký tự đặc biệt có trong từ.
                # count=1 chỉ thay thế lần xuất hiện đầu tiên.
                question_text = re.sub(
                    r'\b' + re.escape(correct_word) + r'\b', 
                    '___', 
                    example_sentence, 
                    flags=re.IGNORECASE, 
                    count=1
                )
                
                # Nếu câu hỏi không thay đổi (ví dụ từ không có trong câu), bỏ qua
                if question_text == example_sentence:
                    print(f"⚠️  Cảnh báo: Từ '{correct_word}' không tìm thấy trong câu ví dụ. Bỏ qua.")
                    continue

                # 2. Lấy 2 đáp án sai ngẫu nhiên
                # Ưu tiên lấy từ cùng chủ đề để câu hỏi có độ khó cao hơn
                self.cursor.execute("""
                    SELECT raw FROM Vocabulary
                    WHERE category_id = %s AND id != %s
                    ORDER BY RAND()
                    LIMIT 2
                """, (category_id, vocab_id))
                wrong_answers = [row['raw'] for row in self.cursor.fetchall()]

                # Nếu không đủ 2 đáp án sai cùng chủ đề, lấy ngẫu nhiên từ bất kỳ chủ đề nào
                if len(wrong_answers) < 2:
                    needed = 2 - len(wrong_answers)
                    self.cursor.execute("""
                        SELECT raw FROM Vocabulary
                        WHERE id != %s
                        ORDER BY RAND()
                        LIMIT %s
                    """, (vocab_id, needed))
                    wrong_answers.extend([row['raw'] for row in self.cursor.fetchall()])

                # Nếu vẫn không đủ 2 đáp án sai (do CSDL quá ít từ), bỏ qua
                if len(wrong_answers) < 2:
                    print(f"⚠️  Không đủ từ vựng để tạo đáp án sai cho từ '{correct_word}'. Bỏ qua.")
                    continue
                
                # 3. Chèn câu hỏi vào CSDL
                self.cursor.execute("""
                    INSERT INTO fill_in_blank 
                        (question, correct_answer, wrong_answer_1, wrong_answer_2, vocabulary_id)
                    VALUES (%s, %s, %s, %s, %s)
                """, (
                    question_text, 
                    correct_word, 
                    wrong_answers[0], 
                    wrong_answers[1], 
                    vocab_id
                ))
                self.conn.commit()
                total_generated += 1
                print(f"✅ Đã tạo câu hỏi cho từ: '{correct_word}'")
            
            print(f"\n🎉 Hoàn tất! Đã tạo mới {total_generated} câu hỏi.")

        except Error as e:
            print(f"❌ Lỗi trong quá trình tạo câu hỏi: {e}")
            self.conn.rollback()

# === Chạy chính ===
if __name__ == "__main__":
    try:
        generator = FillInTheBlankGenerator()
        # Bạn có thể thay đổi số lượng câu hỏi muốn tạo mỗi lần chạy
        generator.generate_questions(limit=200) 
    except Exception as e:
        print(f"❌ Lỗi nghiêm trọng: {e}")
    finally:
        if 'generator' in locals() and generator:
            generator.close()
        sys.exit(0)