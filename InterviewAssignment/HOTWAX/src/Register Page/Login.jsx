import { useState } from "react";
import { useNavigate } from "react-router-dom";
import './Login.css';
function Login() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();
    const handleSubmit = (e) => {
        e.preventDefault();
        if (!username || !password) {
            alert("Username and Password are required");
            return;
        }

        const usernameverify = localStorage.getItem("user");
        const passwordverify = localStorage.getItem("password");

        if (usernameverify === username && password === passwordverify) {
            alert("Login successful");
            //navigate kara dena
            navigate("/dashboard")

        }
        else {
            alert("Sorry Invalid credentials")
        }

    };

    return (
        <div className="login-container">
            <h2>Login</h2>
            <form onSubmit={handleSubmit} style={{ maxWidth: "400px", margin: "auto" }}>
                <div className="login-username-input">
                    <input
                        type="text"
                        placeholder="Username"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                        required
                    />
                </div>
                <div className="login-password-input">
                    <input
                        type="password"
                        placeholder="Password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                    />
                </div>
                <button type="submit" className="login-btn">Login</button>
            </form>
        </div>
    );
}

export default Login;
