document.addEventListener("DOMContentLoaded", function() {
    const restApiUrl = 'http://localhost:5000/data'; // Replace with actual API URL
  
    // Fetch data from your backend API
    fetch(restApiUrl)
      .then(response => response.json())
      .then(data => {
        const c_cap = data.data; // Assuming the API returns an object with a "data" field
  
        let tableHTML = `
          <style>
            table {
              border-collapse: collapse;
              width: 50%;
              margin: auto;
            }
            th, td {
              padding: 10px;
              text-align: left;
              border: 1px solid #ddd;
            }
            th {
              background-color: #f2f2f2;
            }
          </style>
          <table>
            <tr>
              <th>Movie</th>
              <th>Actor</th>
            </tr>`;
  
        // Loop through the data and populate the table
        c_cap.forEach(item => {
          tableHTML += `
            <tr>
              <td>${item.movie}</td>
              <td>${item.hero}</td>
            </tr>`;
        });
  
        tableHTML += `</table>`;
  
        // Display the table in the body of the HTML
        document.body.innerHTML = tableHTML;
      })
      .catch(error => {
        console.error('Error fetching data:', error);
        document.body.innerHTML = '<p>Error fetching data from the backend.</p>';
      });
  });
  