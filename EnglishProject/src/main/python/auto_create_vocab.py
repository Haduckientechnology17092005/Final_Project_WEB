import requests
import mysql.connector
import time
import signal
import sys

# Database Configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'your_db_user',
    'password': 'your_db_password',
    'database': 'english'
}

# Gemini API URL and key (replace this with your actual API endpoint and key)
GEMINI_API_URL = 'https://your-gemini-api.com/endpoint'
GEMINI_API_KEY = 'AIzaSyCZ0pTVh1L9GlUB3roOF6ds5dWQPd0ilao'

# Global flag to control the while loop
running = True

# Function to create a prompt for the Gemini API
def create_prompt():
    # You can customize the prompt based on your need
    prompt = "Give me a random English word along with its part of speech, phonetic transcription, and a brief definition with an example sentence."
    return prompt

# Function to get vocabulary data from Gemini API
def fetch_vocab_data():
    headers = {'Authorization': f'Bearer {GEMINI_API_KEY}'}
    prompt = create_prompt()  # Generate the prompt dynamically

    # Send a POST request to the Gemini API with the prompt
    payload = {
        'prompt': prompt,
        'max_tokens': 200,  # Limit the number of tokens (you can adjust this)
        'temperature': 0.7   # Adjust the creativity of the output (you can adjust this)
    }
    
    try:
        response = requests.post(GEMINI_API_URL, headers=headers, json=payload)

        if response.status_code == 200:
            result = response.json()
            # Assuming the result has the necessary vocab data
            return result['choices'][0]['text']  # Or adjust based on API response format
        else:
            print(f"Error fetching data: {response.status_code}")
            return None
    except Exception as e:
        print(f"Error occurred: {e}")
        return None

# Function to connect to the database
def connect_db():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

# Function to insert a new category
def insert_category(cursor, category_name):
    query = "INSERT INTO Category (name) VALUES (%s) ON DUPLICATE KEY UPDATE name=name"
    cursor.execute(query, (category_name,))

# Function to insert vocabulary
def insert_vocab(cursor, vocab_data):
    query = """
    INSERT INTO Vocabulary (raw, phonetic, audio_url, origin, category_id)
    VALUES (%s, %s, %s, %s, %s)
    """
    cursor.execute(query, (vocab_data['raw'], vocab_data['phonetic'], vocab_data['audio_url'], vocab_data['origin'], vocab_data['category_id']))

# Function to insert meanings
def insert_meaning(cursor, vocab_id, meaning_data):
    query = """
    INSERT INTO Meaning (vocab_id, partOfSpeech)
    VALUES (%s, %s)
    """
    cursor.execute(query, (vocab_id, meaning_data['partOfSpeech']))

# Function to insert definition
def insert_definition(cursor, meaning_id, definition_data):
    query = """
    INSERT INTO Definition (meaning_id, definition, example)
    VALUES (%s, %s, %s)
    """
    cursor.execute(query, (meaning_id, definition_data['definition'], definition_data['example']))

# Main function to create vocabulary, meaning, and definition
def create_vocab_in_db(vocab_data):
    connection = connect_db()
    if connection:
        cursor = connection.cursor()

        # Insert category
        insert_category(cursor, vocab_data['category_name'])

        # Insert vocabulary
        insert_vocab(cursor, vocab_data)

        # Commit the transaction and close the connection
        connection.commit()
        cursor.close()
        connection.close()
        print(f"Vocabulary '{vocab_data['raw']}' has been added to the database.")
    else:
        print("Unable to connect to the database.")

# Process the vocabulary data
def process_vocab_data():
    vocab_data = fetch_vocab_data()
    
    if vocab_data:
        # Example vocab structure returned by the Gemini API (could be different based on your API)
        # {
        #   'raw': 'example_word',
        #   'phonetic': '/ɪɡˈzæmpəl/',
        #   'audio_url': 'http://example.com/audio/example.mp3',
        #   'origin': 'Latin',
        #   'category_id': 1,
        #   'category_name': 'Noun',
        #   'meanings': [
        #       {'partOfSpeech': 'noun', 'definition': 'An example definition', 'example': 'Example in a sentence.'}
        #   ]
        # }
        create_vocab_in_db(vocab_data)
        
        for meaning in vocab_data['meanings']:
            # Insert meanings and definitions
            # Assuming vocab_id is obtained after inserting vocab into the database
            insert_meaning(cursor, vocab_id, meaning)
            insert_definition(cursor, meaning_id, meaning['definition'])

# Signal handler to gracefully stop the while loop
def signal_handler(sig, frame):
    global running
    print('Exiting gracefully...')
    running = False

# Function to run the cron-like task in an infinite loop
def run_forever():
    global running
    while running:
        process_vocab_data()  # Fetch and process vocab data
        time.sleep(60)  # Sleep for 1 minute (or adjust as needed)
        
# Set up signal handler for graceful exit
signal.signal(signal.SIGINT, signal_handler)  # SIGINT is triggered by Ctrl+C
signal.signal(signal.SIGTERM, signal_handler)  # SIGTERM is another termination signal

if __name__ == "__main__":
    print("Starting the vocab creation process...")
    run_forever()
    print("Process has stopped.")
