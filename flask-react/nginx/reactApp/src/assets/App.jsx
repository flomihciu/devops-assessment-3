import React, { useState, useEffect } from 'react';

const API_URL = ''; // Relative path for Nginx proxy

function App() {
  const [movies, setMovies] = useState([]);
  const [newMovie, setNewMovie] = useState({ title: '', director: '', year: '' });
  const [getMovieId, setGetMovieId] = useState('');
  const [fetchedMovie, setFetchedMovie] = useState(null);
  const [updateMovie, setUpdateMovie] = useState({ id: '', title: '', director: '', year: '' });

  const fetchMovies = async () => {
    try {
      const res = await fetch(`${API_URL}/movies`);
      const data = await res.json();
      setMovies(data.movies);
    } catch (err) {
      console.error('Failed to fetch movies:', err.message);
    }
  };

  useEffect(() => {
    fetchMovies();
  }, []);

  const handleAddMovie = async (e) => {
    e.preventDefault();
    try {
      const res = await fetch(`${API_URL}/movies`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newMovie),
      });

      if (!res.ok) {
        const errorText = await res.text();
        throw new Error(`Server error: ${res.status} - ${errorText}`);
      }

      const data = await res.json();
      console.log('Added:', data.movie);
      setNewMovie({ title: '', director: '', year: '' });
      fetchMovies();
    } catch (err) {
      console.error('Failed to add movie:', err.message);
      alert('Error: ' + err.message);
    }
  };

  const handleGetMovie = async () => {
    if (!getMovieId) return;
    try {
      const res = await fetch(`${API_URL}/movies/${getMovieId}`);
      if (res.ok) {
        const data = await res.json();
        setFetchedMovie(data.movie);
      } else {
        setFetchedMovie(null);
        alert('Movie not found');
      }
    } catch (err) {
      console.error('Failed to fetch movie:', err.message);
    }
  };

  const handleUpdateMovie = async (e) => {
    e.preventDefault();
    const { id, title, director, year } = updateMovie;
    if (!id) return;

    try {
      const res = await fetch(`${API_URL}/movies/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, director, year }),
      });

      if (!res.ok) {
        const errorText = await res.text();
        throw new Error(`Server error: ${res.status} - ${errorText}`);
      }

      const data = await res.json();
      console.log('Updated:', data.movie);
      setUpdateMovie({ id: '', title: '', director: '', year: '' });
      fetchMovies();
    } catch (err) {
      console.error('Failed to update movie:', err.message);
    }
  };

  const handleDeleteMovie = async (id) => {
    try {
      const res = await fetch(`${API_URL}/movies/${id}`, { method: 'DELETE' });
      if (res.ok) {
        console.log('Deleted movie', id);
        fetchMovies();
      }
    } catch (err) {
      console.error('Failed to delete movie:', err.message);
    }
  };

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h1>Movie Management</h1>

      <section>
        <h2>All Movies</h2>
        <button onClick={fetchMovies}>Refresh Movies</button>
        <ul>
          {movies.map(movie => (
            <li key={movie.movie_id}>
              <strong>{movie.title}</strong> ({movie.year || 'N/A'}) – Directed by {movie.director || 'N/A'}
              <button onClick={() => handleDeleteMovie(movie.movie_id)} style={{ marginLeft: '10px' }}>Delete</button>
              <button
                onClick={() =>
                  setUpdateMovie({
                    id: movie.movie_id,
                    title: movie.title,
                    director: movie.director,
                    year: movie.year,
                  })
                }
                style={{ marginLeft: '10px' }}
              >
                Edit
              </button>
            </li>
          ))}
        </ul>
      </section>

      <section>
        <h2>Add Movie</h2>
        <form onSubmit={handleAddMovie}>
          <input
            type="text"
            placeholder="Title"
            value={newMovie.title}
            onChange={e => setNewMovie({ ...newMovie, title: e.target.value })}
            required
          />
          <input
            type="text"
            placeholder="Director"
            value={newMovie.director}
            onChange={e => setNewMovie({ ...newMovie, director: e.target.value })}
          />
          <input
            type="number"
            placeholder="Year"
            value={newMovie.year}
            onChange={e => setNewMovie({ ...newMovie, year: e.target.value })}
          />
          <button type="submit">Add Movie</button>
        </form>
      </section>

      <section>
        <h2>Get Movie By ID</h2>
        <input
          type="number"
          placeholder="Movie ID"
          value={getMovieId}
          onChange={e => setGetMovieId(e.target.value)}
        />
        <button onClick={handleGetMovie}>Get Movie</button>
        {fetchedMovie && (
          <div>
            <h3>Movie Details</h3>
            <p>ID: {fetchedMovie.movie_id}</p>
            <p>Title: {fetchedMovie.title}</p>
            <p>Director: {fetchedMovie.director || 'N/A'}</p>
            <p>Year: {fetchedMovie.year || 'N/A'}</p>
          </div>
        )}
      </section>

      <section>
        <h2>Update Movie</h2>
        <form onSubmit={handleUpdateMovie}>
          <input
            type="number"
            placeholder="Movie ID"
            value={updateMovie.id}
            onChange={e => setUpdateMovie({ ...updateMovie, id: e.target.value })}
            required
          />
          <input
            type="text"
            placeholder="Title"
            value={updateMovie.title}
            onChange={e => setUpdateMovie({ ...updateMovie, title: e.target.value })}
            required
          />
          <input
            type="text"
            placeholder="Director"
            value={updateMovie.director}
            onChange={e => setUpdateMovie({ ...updateMovie, director: e.target.value })}
          />
          <input
            type="number"
            placeholder="Year"
            value={updateMovie.year}
            onChange={e => setUpdateMovie({ ...updateMovie, year: e.target.value })}
          />
          <button type="submit">Update Movie</button>
        </form>
      </section>
    </div>
  );
}

export default App;
