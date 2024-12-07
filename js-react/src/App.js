import './App.css';
import React, { useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import Keycloak from 'keycloak-js';
import Home from './views/Home'
import Profile from "./views/Profile";
import Test from "./views/Test";

const keycloak = new Keycloak({
  url: "http://keycloak.docker.localhost",
  realm: "master",
  clientId: "js-react"
});

await keycloak.init({ onLoad: 'check-sso' }).then((auth) => {
  if (auth) {
    console.log("Authenticated");
  } else {
    keycloak.login()
  }
  localStorage.setItem('token', keycloak.token);
  localStorage.setItem('refreshToken', keycloak.refreshToken);
}).catch(() => {
  console.error("Authentication failed");
});

function App() {
  useEffect(() => {
    // Set up token refresh
    const refreshToken = () => {
      keycloak.updateToken(70) // Refresh if token will expire in 70 seconds
          .then((refreshed) => {
            if (refreshed) {
              console.log("Token refreshed");
              localStorage.setItem('token', keycloak.token);
            }
          }).catch(() => {
            console.error("Failed to refresh token");
            keycloak.login()
      });
    };

    // Set an interval to refresh the token
    const interval = setInterval(refreshToken, 60000); // Check every minute

    // Clear interval on component unmount
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="App">
      <Router>
        <div>
          {/* Navigation Links */}
          <nav>
            <ul>
              <li>
                <Link to="/">Home</Link>
              </li>
              <li>
                <Link to="/profile">Profile</Link>
              </li>
              <li>
                <Link to="/test">Test</Link>
              </li>
            </ul>
          </nav>

          {/* Define Routes */}
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/test" element={<Test />} />
            <Route path="/profile" element={<Profile tokenParsed={keycloak.tokenParsed} />} /> {/* New Profile route */}
          </Routes>
        </div>
      </Router>
    </div>
  );
}

export default App;
