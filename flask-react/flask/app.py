from flask import Flask, jsonify, abort, request, make_response
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
import os

app = Flask(__name__)
CORS(app)

DATABASE_CONFIG = {
    'dbname': os.getenv('db_name', 'postgres'),
    'user': os.getenv('db_user', 'postgres'),
    'password': os.getenv('db_password', 'postgres'),
    'host': os.getenv('rds_endpoint', 'localhost'),
    'port': 5432
}

def get_db_connection():
    return psycopg2.connect(**DATABASE_CONFIG, cursor_factory=RealDictCursor)

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Movie API. Use /movies for CRUD operations."})

@app.route('/movies', methods=['GET'])
def get_movies():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM movies;")
    movies = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({'movies': movies})

@app.route('/movies/<int:movie_id>', methods=['GET'])
def get_movie(movie_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM movies WHERE movie_id = %s;", (movie_id,))
    movie = cursor.fetchone()
    cursor.close()
    conn.close()
    if movie is None:
        abort(404)
    return jsonify({'movie': movie})

@app.route('/movies', methods=['POST'])
def add_movie():
    if not request.is_json:
        abort(400)
    data = request.get_json()
    if 'title' not in data:
        abort(400)

    title = data['title']
    director = data.get('director')
    year = data.get('year')

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO movies (title, director, year) VALUES (%s, %s, %s) RETURNING *;",
        (title, director, year)
    )
    new_movie = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'movie': new_movie}), 201

@app.route('/movies/<int:movie_id>', methods=['PUT'])
def update_movie(movie_id):
    if not request.is_json:
        abort(400)
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM movies WHERE movie_id = %s;", (movie_id,))
    movie = cursor.fetchone()
    if movie is None:
        abort(404)

    title = data.get('title', movie['title'])
    director = data.get('director', movie['director'])
    year = data.get('year', movie['year'])

    cursor.execute(
        "UPDATE movies SET title = %s, director = %s, year = %s WHERE movie_id = %s RETURNING *;",
        (title, director, year, movie_id)
    )
    updated_movie = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'movie': updated_movie})

@app.route('/movies/<int:movie_id>', methods=['DELETE'])
def delete_movie(movie_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM movies WHERE movie_id = %s RETURNING movie_id;", (movie_id,))
    deleted = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    if deleted is None:
        abort(404)
    return jsonify({'result': True})

@app.errorhandler(400)
def bad_request(error):
    return make_response(jsonify({'error': 'Bad request'}), 400)

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

@app.errorhandler(500)
def server_error(error):
    return make_response(jsonify({'error': 'Internal server error'}), 500)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
